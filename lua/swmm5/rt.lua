-- rt.lua - C runtime layer for the Lua port of EPA SWMM 5.2.4 (Lua 5.4, as lupa embeds it).
--
-- What SWMM's output depends on, in Lua: x86-64's float-to-integer conversion and C's truncating integer division;
-- C's float (rounded to single precision by string.pack('f'), which is C's (float) cast); NUL-terminated byte
-- strings (CPtr: a table of signed bytes and an offset); printf, whose numeric conversions go one at a time to
-- Lua's string.format, which hands them to glibc's snprintf; strtod and sscanf, whose digits go to tonumber, which
-- calls glibc's strtod; stdio files through Lua's io library, which is C's stdio; and the math functions, which
-- are glibc's (math.*) where lupa's Lua binds the same glibc routine EPA calls, with the cases corrected where it
-- binds an older symbol version, and glibc's own code translated by tools/libm/gim2x.py (glibm.lua) where Lua has no
-- way to reach the routine (pow with y == 2, atan). Every function returns exactly one value (Lua passes every
-- value of a call in last position on to the caller). Written by Claude (Anthropic) for Robert Dickinson; see
-- ../README.md.
local math, string, table, io, os = math, string, table, io, os
local floor, ceil, mlog, fmod = math.floor, math.ceil, math.log, math.fmod
local spack, sunpack, schar, sbyte, sformat, ssub, srep = string.pack, string.unpack, string.char, string.byte,
                                                          string.format, string.sub, string.rep
local tunpack, tconcat = table.unpack, table.concat
local setmetatable, getmetatable, type, tostring, tonumber, error, select = setmetatable, getmetatable, type, tostring,
                                                                         tonumber, error, select

local R = {}

-- a name the translator failed to declare is an error, not a Lua global
R.strict = setmetatable({}, {
  __index = function(_, k) error("undeclared name '" .. tostring(k) .. "'", 2) end,
  __newindex = function(_, k) error("assignment to undeclared name '" .. tostring(k) .. "'", 2) end})

local function bits2d(u) return (sunpack('<d', spack('<i8', u))) end
local function d2bits(x) return (sunpack('<i8', spack('<d', x))) end
R.bits2d, R.d2bits = bits2d, d2bits
R.NAN = bits2d(0x7ff8000000000000)          -- glibc's NAN macro: sign bit clear
R.DEFAULT_NAN = bits2d(-0x8000000000000)     -- 0xfff8000000000000, what x86 computes for 0/0 ("-nan")
R.INF = 1.0 / 0.0
R.LMIN = math.mininteger
R.FLOAT = setmetatable({}, {__name = 'FLOAT'})   -- marks a float target in sscanf's arguments

-- ------------------------------------------------------------ arithmetic with C semantics
function R.i32(x) return ((x + 0x80000000) & 0xFFFFFFFF) - 0x80000000 end
function R.i8(x) return ((x + 128) & 255) - 128 end
function R.i16(x) return ((x + 32768) & 65535) - 32768 end
-- (int)x on x86-64: NaN or out of range gives INT_MIN. x // 1.0 is the float floor(x), and | 0 turns an integral
-- float into an integer, both in the VM (math.floor would be a C call)
function R.D2I(x)
  if x >= 0.0 then
    if x < 2147483648.0 then return (x // 1.0) | 0 end
  elseif x > -2147483649.0 then
    return -((-x) // 1.0) | 0
  end
  return -2147483648
end
function R.D2L(x)
  if x >= 0.0 then
    if x < 9223372036854775808.0 then return (x // 1.0) | 0 end
  elseif x > -9223372036854775809.0 then
    return -((-x) // 1.0) | 0
  end
  return R.LMIN
end
-- C's a / b on integers truncates; Lua's // floors
function R.idiv(a, b)
  local q = a // b
  if q < 0 and q * b ~= a then q = q + 1 end
  return q
end
-- C's (float)x: string.pack('f') is the C cast
function R.f32(x) return (sunpack('<f', spack('<f', x))) end

-- ------------------------------------------------------------ math
local glibm                                    -- glibc's pow and atan, translated (set by R.setGlibm)
function R.setGlibm(g) glibm = g end
-- lupa's Lua binds glibc's unversioned symbols: for log that is log@GLIBC_2.2.5, the SVID wrapper, which returns
-- __kernel_standard's NAN (sign bit clear) for x < 0; EPA's log@GLIBC_2.29 returns the default NaN (sign bit set)
function R.log(x)
  if x < 0 then return R.DEFAULT_NAN end
  return (mlog(x))
end
-- Lua's x ^ y is C's pow, except that luai_numpow computes a * a when y == 2 (glibc's pow differs from a * a in
-- about one argument in 1,500), so y == 2 goes to the translation. Otherwise x ^ y calls pow@GLIBC_2.2.5, whose
-- SVID wrapper (w_pow_compat.c) calls the same __ieee754_pow as EPA's pow@GLIBC_2.29 and changes only the
-- zero, infinite and NaN results, to the same values (checked bit for bit by test/run_libm_tests.sh)
function R.pow(x, y)
  if y == 2 then return glibm.pow(x, y) end
  return x ^ y
end
function R.atan(x) return glibm.atan(x) end    -- Lua's math.atan(x) is atan2(x, 1.0), a different routine
function R.log10(x) return (mlog(x, 10.0)) end  -- Lua 5.4's math.log(x, 10) is C's log10 (lmathlib.c math_log)
-- C's floor and ceil return doubles; math.floor and math.ceil return an integer when they can, which loses the
-- sign of a zero result: a zero result has x's sign
function R.floor(x)
  local r = floor(x) + 0.0
  if r == 0 then return x * 0.0 end
  return r
end
function R.ceil(x)
  local r = ceil(x) + 0.0
  if r == 0 then return x * 0.0 end
  return r
end

-- ------------------------------------------------------------ strings and memory
local CPtr = {__name = 'CPtr'}
R.CPtr = CPtr
local function mk(b, o) return setmetatable({b = b, o = o}, CPtr) end
R.mk = mk
-- A C array of more than BIG elements that starts as zeros (calloc) is a table that stores only the elements
-- written with something other than zero: reading an element never written gives the zero (__index), and writing
-- a zero (+0.0 for a double, 0 for an integer or char) into an element never written stores nothing (__newindex).
-- A Lua array element takes 16 bytes, where C's double takes 8 and its char 1: Hydrology/sewer_rdii_problem.inp
-- allocates 3.38 GB of RDII rainfall history in C, which as dense Lua tables would be 12 GB, most of it zeros never
-- read as anything else. Such a table's size is kept in sparseLen (alen below).
local BIG = 100000
local sparseLen = setmetatable({}, {__mode = 'k'})
local mtype, rawset_ = math.type, rawset
local ZMT_F = {__index = function() return 0.0 end,
               __newindex = function(t, k, v)
                 if v == 0 and mtype(v) == 'float' and 1.0 / v > 0 then return end   -- +0.0 only, not -0.0
                 rawset_(t, k, v)
               end}
local ZMT_I = {__index = function() return 0 end,
               __newindex = function(t, k, v)
                 if v == 0 and mtype(v) == 'integer' then return end
                 rawset_(t, k, v)
               end}
local function zeroTable(n, z)
  local t = setmetatable({}, mtype(z) == 'float' and ZMT_F or ZMT_I)
  sparseLen[t] = n
  return t
end
local function zeros(n)
  if n > BIG then return zeroTable(n, 0) end
  local t = {}
  for i = 0, n - 1 do t[i] = 0 end
  return t
end
function R.lit(s)
  local n = #s
  local b = {}
  for i = 1, n do
    local c = sbyte(s, i)
    b[i - 1] = c < 128 and c or c - 256
  end
  b[n] = 0
  local p = mk(b, 0)
  p.k = true                                    -- a constant string: printf may cache its parsed format
  return p
end
function R.buf(n) if n < 1 then n = 1 end; return mk(zeros(n), 0) end
function R.padd(p, n) return mk(p.b, p.o + n) end
function R.cget(p, i) return p.b[p.o + i] end
function R.cset(p, i, v) p.b[p.o + i] = ((v + 128) & 255) - 128; return v end
function R.peq(a, b)
  if a == b then return true end
  return a ~= nil and b ~= nil and a.b == b.b and a.o == b.o
end
local function strlenI(p)
  local b, e = p.b, p.o
  while b[e] ~= 0 do e = e + 1 end
  return e - p.o
end
R.strlenI = strlenI
function R.strlen(p) return strlenI(p) end
local function strOf(p)
  local b, o = p.b, p.o
  local n = strlenI(p)
  local parts = {}
  local i = 0
  while i < n do
    local m = n - i
    if m > 4000 then m = 4000 end
    local t = {}
    for j = 1, m do t[j] = b[o + i + j - 1] & 255 end
    parts[#parts + 1] = schar(tunpack(t, 1, m))
    i = i + m
  end
  return tconcat(parts)
end
R.strOf = strOf
function R.bufFrom(src, n)
  local p = R.buf(n)
  local m = strlenI(src)
  if m > n then m = n end
  for i = 0, m - 1 do p.b[i] = src.b[src.o + i] end
  return p
end
function R.bufOf(n, vals)
  local p = R.buf(n)
  for i = 1, #vals do p.b[i - 1] = ((vals[i] + 128) & 255) - 128 end
  return p
end
function R.bufs(n, m) local a = {}; for i = 0, n - 1 do a[i] = R.buf(m) end; return a end
function R.copyBuf(p)
  local b = {}
  for k, v in pairs(p.b) do b[k] = v end
  local n = sparseLen[p.b]
  if n then sparseLen[b] = n; setmetatable(b, getmetatable(p.b)) end
  return mk(b, p.o)
end
function R.fill(n, z)
  if n > BIG and z == 0 and (mtype(z) == 'integer' or 1.0 / z > 0) then return zeroTable(n, z) end
  local t = {}
  for i = 0, n - 1 do t[i] = z end
  return t
end
function R.recs(n, ctor) local t = {}; for i = 0, n - 1 do t[i] = ctor() end; return t end
function R.grid(n, m, z) local t = {}; for i = 0, n - 1 do t[i] = R.fill(m, z) end; return t end
local function alen(t)                          -- elements 0 .. alen-1 of a 0-based array
  local n = sparseLen[t]
  if n then return n end
  if t[0] == nil then return 0 end
  return #t + 1
end
R.alen = alen
function R.copyArr(t) local c = {}; for i = 0, alen(t) - 1 do c[i] = t[i] end; return c end
function R.copyRecs(t, cp) local c = {}; for i = 0, alen(t) - 1 do c[i] = cp(t[i]) end; return c end
function R.copyGrid(t) local c = {}; for i = 0, alen(t) - 1 do c[i] = R.copyArr(t[i]) end; return c end
-- realloc of a table: the old elements, then new ones (records, zeros, or nil)
function R.realloc(t, n, init)
  local c = {}
  local m = t and alen(t) or 0
  for i = 0, n - 1 do
    if i < m then c[i] = t[i]
    elseif type(init) == 'function' then c[i] = init()
    else c[i] = init end
  end
  return c
end
function R.realloc_c(p, n)
  local q = R.buf(n)
  if p ~= nil then
    local i = 0
    while i < n and p.b[p.o + i] ~= nil do q.b[i] = p.b[p.o + i]; i = i + 1 end
  end
  return q
end
function R.memset(p, v, n)
  if getmetatable(p) == CPtr then
    for i = 0, n - 1 do p.b[p.o + i] = v end
  else
    error('memset on a ' .. type(p))
  end
end
function R.strcpy(d, s)
  local db, doff, sb, so = d.b, d.o, s.b, s.o
  local i = 0
  while true do
    local c = sb[so + i]
    db[doff + i] = c
    if c == 0 then break end
    i = i + 1
  end
  return d
end
function R.strcat(d, s) R.strcpy(mk(d.b, d.o + strlenI(d)), s); return d end
function R.strcmp(a, b)
  local ab, ao, bb, bo = a.b, a.o, b.b, b.o
  local i = 0
  while true do
    local c, d = ab[ao + i] & 255, bb[bo + i] & 255
    if c ~= d then return c - d end
    if c == 0 then return 0 end
    i = i + 1
  end
end
function R.strchr(s, c)
  c = c & 255
  local b, i = s.b, s.o
  while true do
    if (b[i] & 255) == c then return mk(b, i) end
    if b[i] == 0 then return nil end
    i = i + 1
  end
end
function R.strrchr(s, c)
  c = c & 255
  local e = s.o + strlenI(s)
  if c == 0 then return mk(s.b, e) end
  for i = e - 1, s.o, -1 do if (s.b[i] & 255) == c then return mk(s.b, i) end end
  return nil
end
function R.strstr(h, n)
  local hl, nl = strlenI(h), strlenI(n)
  for i = 0, hl - nl do
    local ok = true
    for k = 0, nl - 1 do
      if h.b[h.o + i + k] ~= n.b[n.o + k] then ok = false; break end
    end
    if ok then return mk(h.b, h.o + i) end
  end
  return nil
end
-- the characters of a set argument (strcspn's reject, strtok's delimiters) as a table c -> true; a string literal's
-- set is built once (literals are never written)
local setCache = setmetatable({}, {__mode = 'k'})
local function charset(p)
  local lit = p.k and p.o == 0
  local set = lit and setCache[p]
  if set then return set end
  set = {}
  local b, i = p.b, p.o
  while b[i] ~= 0 do set[b[i]] = true; i = i + 1 end
  if lit then setCache[p] = set end
  return set
end
function R.strcspn(s, rej)
  local set = charset(rej)
  local b, o = s.b, s.o
  local i = o
  local c = b[i]
  while c ~= 0 and not set[c] do i = i + 1; c = b[i] end
  return i - o
end
local tokNext
function R.strtok(s, delim)
  if s ~= nil then tokNext = s end
  local p = tokNext
  if p == nil then return nil end
  local set = charset(delim)
  local b, i = p.b, p.o
  while b[i] ~= 0 and set[b[i]] do i = i + 1 end
  if b[i] == 0 then tokNext = nil; return nil end
  local start = i
  while b[i] ~= 0 and not set[b[i]] do i = i + 1 end
  if b[i] ~= 0 then b[i] = 0; tokNext = mk(b, i + 1) else tokNext = nil end
  return mk(b, start)
end
function R.toupper(c) if c >= 97 and c <= 122 then return c - 32 end; return c end
local function isSpace(c) return c == 32 or (c >= 9 and c <= 13) end
local function low(c) if c >= 65 and c <= 90 then return c | 0x20 end; return c end

-- ------------------------------------------------------------ strtod
-- glibc's strtod at b[i..] (at most maxw characters): returns the value and the end index, or nil if no number.
-- The extent is found here; the digits go to tonumber, which reads a decimal (or hexadecimal) string with C's
-- strtod (lua_str2number), correctly rounded. tonumber would give an integer for a string of digits, so "e0" (or
-- "p0" for hexadecimal) is appended. inf, infinity and nan(n-chars) are glibc's rules, written out.
local function hexval(c)
  if c >= 48 and c <= 57 then return c - 48 end
  local l = c | 0x20
  if l >= 97 and l <= 102 then return l - 87 end
  return -1
end
local function scanDouble(b, i, maxw)
  local lim = maxw and i + maxw or math.maxinteger
  local function g(k) if k >= lim then return 0 end; local c = b[k]; if c == nil then return 0 end; return c & 255 end
  local neg = false
  if g(i) == 43 or g(i) == 45 then neg = g(i) == 45; i = i + 1 end
  if low(g(i)) == 105 and low(g(i + 1)) == 110 and low(g(i + 2)) == 102 then
    i = i + 3
    if low(g(i)) == 105 and low(g(i + 1)) == 110 and low(g(i + 2)) == 105 and low(g(i + 3)) == 116
       and low(g(i + 4)) == 121 then i = i + 5 end
    return neg and -R.INF or R.INF, i
  end
  if low(g(i)) == 110 and low(g(i + 1)) == 97 and low(g(i + 2)) == 110 then
    i = i + 3
    local v = R.NAN
    if g(i) == 40 then
      local k = i + 1
      local t = {}
      while true do
        local c = g(k)
        if (c >= 48 and c <= 57) or ((c | 0x20) >= 97 and (c | 0x20) <= 122) or c == 95 then t[#t + 1] = schar(c); k = k + 1
        else break end
      end
      if g(k) == 41 then
        -- the n-char sequence read by strtoull with base 0, if all of it is a number, is the payload
        local seq = tconcat(t)
        local u
        if seq == '' then u = 0
        elseif seq:match('^0[xX]%x+$') then u = R.parseU64(seq:sub(3), 16)
        elseif seq:match('^0[0-7]*$') then u = R.parseU64(seq, 8)
        elseif seq:match('^[1-9]%d*$') then u = R.parseU64(seq, 10) end
        if u then v = bits2d(0x7FF8000000000000 | (u & 0x0007FFFFFFFFFFFF)) end
        i = k + 1
      end
    end
    if neg then v = bits2d(d2bits(v) | math.mininteger) end
    return v, i
  end
  if g(i) == 48 and (g(i + 1) | 0x20) == 120 then
    local k, nh = i + 2, 0
    local t = {neg and '-0x' or '0x'}
    while hexval(g(k)) >= 0 do t[#t + 1] = schar(g(k)); k = k + 1; nh = nh + 1 end
    if g(k) == 46 then
      local k2, fr = k + 1, {'.'}
      while hexval(g(k2)) >= 0 do fr[#fr + 1] = schar(g(k2)); k2 = k2 + 1 end
      if nh + #fr - 1 > 0 then t[#t + 1] = tconcat(fr); nh = nh + #fr - 1; k = k2 end
    end
    if nh == 0 then return neg and -0.0 or 0.0, i + 1 end      -- "0x" with no hex digit: the number is the "0"
    local ex = 'p0'
    if (g(k) | 0x20) == 112 then
      local k2, es = k + 1, ''
      if g(k2) == 43 or g(k2) == 45 then es = g(k2) == 45 and '-' or ''; k2 = k2 + 1 end
      if g(k2) >= 48 and g(k2) <= 57 then
        local d = {}
        while g(k2) >= 48 and g(k2) <= 57 do d[#d + 1] = schar(g(k2)); k2 = k2 + 1 end
        local ed = tconcat(d):gsub('^0+', '')
        if #ed > 6 then ed = '999999' end                        -- far beyond any double: inf or 0 either way
        ex = 'p' .. es .. (ed == '' and '0' or ed)
        k = k2
      end
    end
    local text = tconcat(t) .. ex
    local v = tonumber(text)
    if v == nil then error('strtod: ' .. text) end
    return v + 0.0, k
  end
  local ms, nd = i, 0
  local t = {}
  while g(i) >= 48 and g(i) <= 57 do t[#t + 1] = schar(g(i)); i = i + 1; nd = nd + 1 end
  if g(i) == 46 then
    t[#t + 1] = '.'
    i = i + 1
    while g(i) >= 48 and g(i) <= 57 do t[#t + 1] = schar(g(i)); i = i + 1; nd = nd + 1 end
  end
  if nd == 0 then return nil, nil end
  local ex = 'e0'
  if low(g(i)) == 101 then
    local k = i + 1
    local es = ''
    if g(k) == 43 or g(k) == 45 then es = g(k) == 45 and '-' or ''; k = k + 1 end
    if g(k) >= 48 and g(k) <= 57 then
      local d = {}
      while g(k) >= 48 and g(k) <= 57 do d[#d + 1] = schar(g(k)); k = k + 1 end
      local ed = tconcat(d):gsub('^0+', '')
      if #ed > 6 then ed = '999999' end
      ex = 'e' .. es .. (ed == '' and '0' or ed)
      i = k
    end
  end
  local text = (neg and '-' or '') .. tconcat(t) .. ex
  local v = tonumber(text)
  if v == nil then error('strtod: ' .. text) end
  return v, i, text
end
R.scanDouble = scanDouble
function R.parseU64(s, base)                    -- strtoull's value (saturating) as a 64-bit pattern
  local v = 0
  for k = 1, #s do
    local d = hexval(sbyte(s, k))
    local hi = (v >> 32) * base
    local lo = (v & 0xFFFFFFFF) * base + d
    hi = hi + (lo >> 32)
    if hi > 0xFFFFFFFF then return -1 end
    v = (hi << 32) | (lo & 0xFFFFFFFF)
  end
  return v
end
function R.strtod(s, et, ek)
  local b, i = s.b, s.o
  while b[i] ~= nil and b[i] ~= 0 and isSpace(b[i] & 255) do i = i + 1 end
  local v, e = scanDouble(b, i)
  if et ~= nil then et[ek] = v == nil and s or mk(b, e) end
  if v == nil then return 0.0 end
  return v
end
function R.atof(s) return R.strtod(s, nil, nil) end
function R.atoi(s)
  local b, i = s.b, s.o
  while b[i] ~= 0 and isSpace(b[i] & 255) do i = i + 1 end
  local neg = false
  if b[i] == 43 or b[i] == 45 then neg = b[i] == 45; i = i + 1 end
  local v, over = 0, false
  while b[i] >= 48 and b[i] <= 57 do
    if v > (math.maxinteger - (b[i] - 48)) // 10 then over = true else v = v * 10 + (b[i] - 48) end
    i = i + 1
  end
  if over then v = neg and math.mininteger or math.maxinteger
  elseif neg then v = -v end
  return R.i32(v)                               -- strtol's long, then (int): keeps the low 32 bits
end

-- ------------------------------------------------------------ sscanf
-- targets: a CPtr (for %s and %c into a char array) or a (table, key) pair for a number; R.FLOAT before a pair
-- marks a C float (the value is rounded to single precision)
function R.sscanf(s, fmt, ...)
  local args = {...}
  local nargs = select('#', ...)
  local ai = 1
  local b, i = s.b, s.o
  local f = R.strOf(fmt)
  local k, nf = 1, #f
  local count, anyInput = 0, false
  local function ch(j) local c = b[j]; if c == nil then return 0 end; return c & 255 end
  local function target()
    local a = args[ai]
    if a == R.FLOAT then
      local t, kk = args[ai + 1], args[ai + 2]
      ai = ai + 3
      return t, kk, true
    end
    if getmetatable(a) == CPtr then ai = ai + 1; return a, nil, false end
    local t, kk = args[ai], args[ai + 1]
    ai = ai + 2
    return t, kk, false
  end
  while k <= nf do
    local fc = sbyte(f, k)
    if isSpace(fc) then
      while k <= nf and isSpace(sbyte(f, k)) do k = k + 1 end
      while ch(i) ~= 0 and isSpace(ch(i)) do i = i + 1 end
    elseif fc ~= 37 then
      if ch(i) == 0 then return (anyInput or count > 0) and count or -1 end
      if ch(i) ~= fc then return count end
      i = i + 1; k = k + 1
    else
      k = k + 1
      if sbyte(f, k) == 37 then
        while ch(i) ~= 0 and isSpace(ch(i)) do i = i + 1 end
        if ch(i) ~= 37 then return count end
        i = i + 1; k = k + 1
      else
        local suppress = false
        if sbyte(f, k) == 42 then suppress = true; k = k + 1 end
        local width = 0
        while k <= nf and sbyte(f, k) >= 48 and sbyte(f, k) <= 57 do width = width * 10 + sbyte(f, k) - 48; k = k + 1 end
        while k <= nf and (sbyte(f, k) == 108 or sbyte(f, k) == 104 or sbyte(f, k) == 76) do k = k + 1 end
        local conv = sbyte(f, k)
        k = k + 1
        if conv ~= 99 and conv ~= 91 and conv ~= 110 then while ch(i) ~= 0 and isSpace(ch(i)) do i = i + 1 end end
        if ch(i) == 0 and conv ~= 110 then return (count == 0 and not anyInput) and -1 or count end
        if conv == 100 or conv == 105 or conv == 117 then            -- d i u
          local j = i
          local lim = width ~= 0 and i + width or math.maxinteger
          local neg = false
          if j < lim and (ch(j) == 43 or ch(j) == 45) then neg = ch(j) == 45; j = j + 1 end
          local ds = j
          local v, over = 0, false
          while j < lim and ch(j) >= 48 and ch(j) <= 57 do
            local dg = ch(j) - 48
            if v > (math.maxinteger - dg) // 10 then over = true else v = v * 10 + dg end
            j = j + 1
          end
          if j == ds then return count end
          i = j
          anyInput = true
          if over then v = neg and math.mininteger or math.maxinteger elseif neg then v = -v end
          if not suppress then
            local t, kk = target()
            t[kk] = R.i32(v)
            count = count + 1
          end
        elseif conv == 102 or conv == 101 or conv == 103 then         -- f e g
          local v, e, text = scanDouble(b, i, width ~= 0 and width or nil)
          if v == nil then return count end
          i = e
          anyInput = true
          if not suppress then
            local t, kk, isf = target()
            t[kk] = isf and R.f32(v) or v
            count = count + 1
          end
        elseif conv == 115 then                                        -- s
          local j, m = i, 0
          local w = width ~= 0 and width or 1 << 30
          while ch(j) ~= 0 and not isSpace(ch(j)) and m < w do j = j + 1; m = m + 1 end
          if not suppress then
            local d = target()
            for q = 0, m - 1 do d.b[d.o + q] = b[i + q] end
            d.b[d.o + m] = 0
            count = count + 1
          end
          i = j
          anyInput = true
        elseif conv == 99 then                                         -- c
          local cnt = width ~= 0 and width or 1
          if ch(i) == 0 then return (count == 0 and not anyInput) and -1 or count end
          local t, kk
          if not suppress then t, kk = target() end
          local q = 0
          while q < cnt and ch(i) ~= 0 do
            if not suppress then
              if getmetatable(t) == CPtr then t.b[t.o + q] = b[i] else t[kk] = b[i] end
            end
            i = i + 1; q = q + 1
          end
          anyInput = true
          if not suppress then count = count + 1 end
        else
          error('sscanf %' .. schar(conv))
        end
      end
    end
  end
  return count
end

-- ------------------------------------------------------------ printf
-- A literal format is parsed once (cache keyed by the CPtr of the literal) into pieces: text, or a conversion with its
-- flags, width, precision and length. Numeric conversions are written by string.format (glibc's snprintf) with
-- C's own spec; %s and %c are padded here; a 32-bit %u %x %X %o argument is masked to 32 bits as C sees it.
local fcache = setmetatable({}, {__mode = 'k'})
local function parse(fmt)
  local f = strOf(fmt)
  local pieces = {}
  local k, n = 1, #f
  local text = {}
  while k <= n do
    local c = sbyte(f, k)
    if c ~= 37 then text[#text + 1] = schar(c); k = k + 1
    elseif sbyte(f, k + 1) == 37 then text[#text + 1] = '%'; k = k + 2
    else
      if #text > 0 then pieces[#pieces + 1] = tconcat(text); text = {} end
      k = k + 1
      local fs = k
      while true do
        local x = sbyte(f, k)
        if x == 45 or x == 43 or x == 32 or x == 35 or x == 48 then k = k + 1 else break end
      end
      local flags = ssub(f, fs, k - 1)
      local width, wstar, prec, pstar = nil, false, nil, false
      if sbyte(f, k) == 42 then wstar = true; k = k + 1
      else
        local ws = k
        while sbyte(f, k) and sbyte(f, k) >= 48 and sbyte(f, k) <= 57 do k = k + 1 end
        if k > ws then width = tonumber(ssub(f, ws, k - 1)) end
      end
      if sbyte(f, k) == 46 then
        k = k + 1
        if sbyte(f, k) == 42 then pstar = true; k = k + 1
        else
          local ps = k
          while sbyte(f, k) and sbyte(f, k) >= 48 and sbyte(f, k) <= 57 do k = k + 1 end
          prec = tonumber(ssub(f, ps, k - 1)) or 0
        end
      end
      local long = false
      while true do
        local x = sbyte(f, k)
        if x == 108 or x == 76 or x == 122 or x == 106 or x == 116 or x == 113 then long = true; k = k + 1
        elseif x == 104 then k = k + 1
        else break end
      end
      local conv = ssub(f, k, k)
      k = k + 1
      pieces[#pieces + 1] = {flags = flags, width = width, wstar = wstar, prec = prec, pstar = pstar, long = long, conv = conv}
    end
  end
  if #text > 0 then pieces[#pieces + 1] = tconcat(text) end
  return pieces
end
local function pad(s, width, left)
  if width and #s < width then
    if left then return s .. srep(' ', width - #s) end
    return srep(' ', width - #s) .. s
  end
  return s
end
local function format(fmt, ...)
  -- only a literal's parse is cached: EPA also formats with a buffer it rewrites (report_writeErrorMsg's Msg)
  local pieces = fmt.k and fmt.o == 0 and fcache[fmt]
  if not pieces then
    pieces = parse(fmt)
    if fmt.k and fmt.o == 0 then fcache[fmt] = pieces end
  end
  local out = {}
  local ai = 1
  local args = {...}
  for pi = 1, #pieces do
    local p = pieces[pi]
    if type(p) == 'string' then out[#out + 1] = p
    else
      local flags, width, prec = p.flags, p.width, p.prec
      if p.wstar then
        width = args[ai]; ai = ai + 1
        if width < 0 then flags = flags .. '-'; width = -width end
      end
      if p.pstar then
        prec = args[ai]; ai = ai + 1
        if prec < 0 then prec = nil end
      end
      local conv = p.conv
      local v = args[ai]; ai = ai + 1
      local left = flags:find('-', 1, true) ~= nil
      if conv == 's' then
        local s = v == nil and '(null)' or strOf(v)
        if prec and #s > prec then s = ssub(s, 1, prec) end
        out[#out + 1] = pad(s, width, left)
      elseif conv == 'c' then
        out[#out + 1] = pad(schar(v & 255), width, left)
      else
        if (conv == 'u' or conv == 'x' or conv == 'X' or conv == 'o') and not p.long then v = v & 0xFFFFFFFF end
        if conv == 'd' or conv == 'i' or conv == 'u' or conv == 'x' or conv == 'X' or conv == 'o' then
          v = math.tointeger(v) or v
        end
        local spec = '%' .. flags .. (width and tostring(width) or '') .. (prec and ('.' .. tostring(prec)) or '') .. conv
        if (width and width > 99) or (prec and prec > 99) or conv == 'u' then
          out[#out + 1] = R.bigspec(flags, width, prec, conv, v)
        else
          out[#out + 1] = sformat(spec, v)
        end
      end
    end
  end
  return tconcat(out)
end
R.format = format
-- a conversion Lua's string.format refuses (a width or precision over 99, or %u): the same digits, padded here
function R.bigspec(flags, width, prec, conv, v)
  local left = flags:find('-', 1, true) ~= nil
  local zero = flags:find('0', 1, true) ~= nil and not left
  local s
  if conv == 'u' then
    s = v >= 0 and sformat('%d', v) or sformat('%.0f', (v & 0x7FFFFFFFFFFFFFFF) + 9223372036854775808.0)
    if v < 0 then                             -- an unsigned 64-bit value above 2^63: exact decimal digits
      local hi, lo = (v >> 1) // 5, (v >> 1) % 5 * 2 + (v & 1)
      s = sformat('%d%d', hi, lo)
    end
    if prec then
      if prec == 0 and v == 0 then s = '' end
      if #s < prec then s = srep('0', prec - #s) .. s end
      zero = false
    end
  else
    local f2 = flags:gsub('[-0]', '')
    s = sformat('%' .. f2 .. (prec and ('.' .. (prec > 99 and 99 or prec)) or '') .. conv, v)
    if prec and prec > 99 then error('printf precision over 99') end
  end
  if width and #s < width then
    if left then return s .. srep(' ', width - #s) end
    if zero then
      local sign, rest = s:match('^([-+ ]?)(.*)$')
      return sign .. srep('0', width - #s) .. rest
    end
    return srep(' ', width - #s) .. s
  end
  return s
end
function R.fprintf(f, fmt, ...)
  local s = format(fmt, ...)
  if f == nil then return -1 end
  f.fh:write(s)
  return #s
end
function R.snprintf(b, n, fmt, ...)
  local s = format(fmt, ...)
  if n > 0 then
    local m = #s
    if m > n - 1 then m = n - 1 end
    local bb, o = b.b, b.o
    for i = 1, m do local c = sbyte(s, i); bb[o + i - 1] = c < 128 and c or c - 256 end
    bb[o + m] = 0
  end
  return #s
end

-- ------------------------------------------------------------ files
-- a C FILE*: Lua's file handle (C's stdio underneath) and C's end-of-file flag
R.stdout = {fh = io.stdout, eof = false}
function R.fopen(name, mode)
  local m = strOf(mode):gsub('t', '')
  local fh = io.open(strOf(name), m)
  if fh == nil then return nil end
  return {fh = fh, eof = false}
end
function R.fclose(f)
  if f == nil then return -1 end
  if f.fh ~= io.stdout then f.fh:close() end
  return 0
end
function R.fflush(f) if f ~= nil then f.fh:flush() end; return 0 end
function R.feof(f) return f.eof and 1 or 0 end
function R.rewind(f) f.fh:seek('set', 0); f.eof = false end
function R.fseek(f, off, whence)
  local r = f.fh:seek(whence == 0 and 'set' or whence == 1 and 'cur' or 'end', off)
  if r == nil then return -1 end
  f.eof = false
  return 0
end
function R.ftell(f) return (f.fh:seek('cur')) end
-- fgets: at most n-1 bytes, up to and including a newline; a line that ends without a newline ends at end of file,
-- which sets the flag as C's fgets does
function R.fgets(b, n, f)
  local line = f.fh:read('L')
  if line == nil then f.eof = true; return nil end
  local m = #line
  if m > n - 1 then
    f.fh:seek('cur', -(m - (n - 1)))
    m = n - 1
  elseif sbyte(line, m) ~= 10 then
    f.eof = true
  end
  local bb, o = b.b, b.o
  local cs = {sbyte(line, 1, m)}                 -- m <= n - 1: a line buffer's size
  for i = 1, m do local c = cs[i]; bb[o + i - 1] = c < 128 and c or c - 256 end
  bb[o + m] = 0
  return b
end
function R.remove(name) if os.remove(strOf(name)) then return 0 end; return -1 end
function R.mkstemp(template)
  local n = strlenI(template)
  local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
  for t = 1, 1000 do
    for i = n - 6, n - 1 do
      local r = math.random(1, #chars)
      template.b[template.o + i] = sbyte(chars, r)
    end
    local name = strOf(template)
    local fh = io.open(name, 'r')
    if fh == nil then
      fh = io.open(name, 'w')
      if fh == nil then return -1 end
      fh:close()
      return 3
    end
    fh:close()
  end
  return -1
end
-- binary I/O: one value or an array, little-endian; kinds d (double), f (float), i (int), I (unsigned), l (long)
local PK = {d = '<d', f = '<f', i = '<i4', I = '<I4', l = '<i8', c = '<i1'}
local SZ = {d = 8, f = 4, i = 4, I = 4, l = 8, c = 1}
function R.fwrite1(kind, size, v, f)
  f.fh:write(ssub(spack(PK[kind], v), 1, size))
  return 1
end
function R.fread1(kind, size, t, k, f)
  local s = f.fh:read(size)
  if s == nil or #s < size then f.eof = true; return 0 end
  if size < SZ[kind] then
    local old = spack(PK[kind], t[k])          -- a short read keeps the upper bytes of the old value
    s = s .. ssub(old, size + 1)
  end
  t[k] = (sunpack(PK[kind], s))
  return 1
end
local BLOCK = 256
function R.fwrite_arr(kind, a, off, n, f)
  if kind == 'c' then
    local t = {}
    for i = 0, n - 1 do t[#t + 1] = schar(a.b[a.o + off + i] & 255) end
    f.fh:write(tconcat(t))
    return n
  end
  local pk = PK[kind]
  local i = 0
  while i < n do
    local m = n - i
    if m > BLOCK then m = BLOCK end
    f.fh:write(spack('<' .. srep(ssub(pk, 2), m), tunpack(a, off + i, off + i + m - 1)))
    i = i + m
  end
  return n
end
function R.fread_arr(kind, a, off, n, f)
  if kind == 'c' then
    local s = f.fh:read(n) or ''
    for i = 1, #s do local c = sbyte(s, i); a.b[a.o + off + i - 1] = c < 128 and c or c - 256 end
    if #s < n then f.eof = true end
    return #s
  end
  local sz, pk = SZ[kind], PK[kind]
  for i = 0, n - 1 do
    local s = f.fh:read(sz)
    if s == nil or #s < sz then f.eof = true; return i end
    a[off + i] = (sunpack(pk, s))
  end
  return n
end

-- realpath() of a file name relative to the working directory: the directory's physical path, which the launcher
-- passes (C's getcwd, through Python's os.getcwd: Lua has no getcwd, and lupa's Lua has no popen), and the name, as
-- glibc's realpath gives it for a name without ".." or symbolic links
local cwd
function R.setCwd(d) cwd = d end
function R.realpathOf(p)
  if p:sub(1, 1) == '/' then return p end
  return cwd .. '/' .. p
end

-- ------------------------------------------------------------ time
function R.time() return os.time() end
function R.ctime(t) return R.lit(os.date('%a %b %e %H:%M:%S %Y\n', t)) end

return R
