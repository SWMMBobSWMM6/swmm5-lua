-- glibm_rt.lua - runtime for the Lua translation of glibc 2.39's math routines (glibm.lua, written by
-- tools/libm/gim2x.py's Lua back end). The translated routines use bit casts between doubles and 64-bit integers
-- (string.pack / string.unpack), x86's float-to-integer conversions, glibc's error helpers (math_err.c), and fused
-- multiply-adds. Lua has no fma, so RT.fma is an exact emulation: Boldo and Melquiond's method (fma = RN(th +
-- RO(tl + ul)), the product split exactly by Dekker's method and the sum by Knuth's, RO = round to odd) when every
-- operand is moderate, as in the JavaScript port's glibm_rt.js; otherwise (zeros, infinities, NaN, very large or very
-- small magnitudes) the exact sum a*b + c in 24-bit limbs, rounded once to nearest even. Checked against the
-- hardware fma glibc's FMA variants run on (lua/test). Written by Claude (Anthropic) for Robert Dickinson.
local spack, sunpack, floor, m_abs, mininteger = string.pack, string.unpack, math.floor, math.abs, math.mininteger
local RT = {}

local function d2u(x) return (sunpack('<i8', spack('<d', x))) end
local function u2d(u) return (sunpack('<d', spack('<i8', u))) end
RT.d2u, RT.u2d = d2u, u2d
RT.INF = 1.0 / 0.0
RT.QNAN = u2d(0x7ff8000000000000)
RT.NZERO = u2d(mininteger)                       -- 0x8000000000000000
local DEFAULT_NAN = u2d(-2251799813685248)        -- 0xfff8000000000000: what x86 computes for an invalid operation
local INF = RT.INF
local function p2(e) return u2d((e + 1023) << 52) end   -- 2^e, -1022 <= e <= 1023
local function pow2(k)                           -- 2^k, -1074 <= k <= 1023
  if k >= -1022 then return p2(k) end
  return u2d(1 << (k + 1074))
end

-- x86-64 cvttsd2si: NaN and out-of-range values give the "integer indefinite" value
function RT.d2i(x)
  if not (-2147483649.0 < x and x < 2147483648.0) then return -2147483648 end
  if x >= 0 then return floor(x) end
  return -floor(-x)
end
function RT.d2l(x)
  if not (-9223372036854775809.0 < x and x < 9223372036854775808.0) then return mininteger end
  if x >= 0 then return floor(x) end
  return -floor(-x)
end
function RT.u64ToDouble(u)                       -- (double) of an unsigned 64-bit value, rounded once
  if u >= 0 then return u * 1.0 end
  return (((u >> 1) | (u & 1)) * 1.0) * 2.0
end
function RT.copysign(x, y) return u2d((d2u(x) & 0x7fffffffffffffff) | (d2u(y) & mininteger)) end

-- glibc's math_err.c helpers (the value they return; errno is not modelled)
function RT.math_oflow(sign) local y = p2(769); return (sign ~= 0 and -y or y) * y end
function RT.math_uflow(sign) local y = p2(-767); return (sign ~= 0 and -y or y) * y end
function RT.math_may_uflow(sign) local y = 1.5 * p2(-538); return (sign ~= 0 and -y or y) * y end
function RT.math_divzero(sign) local z = 0.0; return (sign ~= 0 and -1.0 or 1.0) / z end
function RT.math_invalid(x) return (x - x) / (x - x) end
function RT.math_check_oflow(y) return y end
function RT.math_check_uflow(y) return y end

-- tables: concatenated 16-hex-digit bit patterns, as 0-based arrays
function RT.u64tab(hex)
  local t = {}
  for i = 0, #hex // 16 - 1 do t[i] = tonumber('0x' .. hex:sub(16 * i + 1, 16 * i + 16)) end
  return t
end
function RT.f64tab(hex)
  local t = RT.u64tab(hex)
  for i = 0, #hex // 16 - 1 do t[i] = u2d(t[i]) end
  return t
end

-- ------------------------------------------------------------ exact fused multiply-add
local SPLIT = 134217729.0                        -- 2^27 + 1
local BIG, SMALL, CBIG, CSMALL = p2(450), p2(-450), p2(900), p2(-900)

local function roundOdd(x, y)                    -- x + y rounded to odd
  local s = x + y
  local bb = s - x
  local e = (x - (s - bb)) + (y - bb)
  if e == 0 then return s end
  local u = d2u(s)
  if u & 1 ~= 0 then return s end
  if (e > 0) == (s > 0) then u = u + 1 else u = u - 1 end   -- one unit in the last place toward the exact value
  return u2d(u)
end

-- multi-word integers: arrays of 24-bit limbs, least significant first, no high zero limbs
local LB, LMASK = 24, (1 << 24) - 1
local function bfrom(m)
  local t, i = {}, 1
  while m > 0 do t[i] = m & LMASK; m = m >> LB; i = i + 1 end
  return t
end
local function bnorm(t) local n = #t; while n > 0 and t[n] == 0 do t[n] = nil; n = n - 1 end; return t end
local function bmul(x, y)
  local r = {}
  local nx, ny = #x, #y
  for i = 1, nx + ny do r[i] = 0 end
  for i = 1, nx do
    local carry, xi = 0, x[i]
    for j = 1, ny do
      local v = r[i + j - 1] + xi * y[j] + carry
      r[i + j - 1] = v & LMASK
      carry = v >> LB
    end
    local k = i + ny
    while carry > 0 do local v = r[k] + carry; r[k] = v & LMASK; carry = v >> LB; k = k + 1 end
  end
  return bnorm(r)
end
local function bshl(x, s)
  local q, r = s // LB, s % LB
  local out = {}
  for i = 1, q do out[i] = 0 end
  local carry = 0
  for i = 1, #x do
    local v = (x[i] << r) | carry
    out[q + i] = v & LMASK
    carry = v >> LB
  end
  if carry > 0 then out[q + #x + 1] = carry end
  return bnorm(out)
end
local function bcmp(x, y)
  if #x ~= #y then return #x < #y and -1 or 1 end
  for i = #x, 1, -1 do if x[i] ~= y[i] then return x[i] < y[i] and -1 or 1 end end
  return 0
end
local function badd(x, y)
  local r, carry = {}, 0
  for i = 1, (#x > #y and #x or #y) do
    local v = (x[i] or 0) + (y[i] or 0) + carry
    r[i] = v & LMASK
    carry = v >> LB
  end
  if carry > 0 then r[#r + 1] = carry end
  return r
end
local function bsub(x, y)                        -- x >= y
  local r, borrow = {}, 0
  for i = 1, #x do
    local v = x[i] - (y[i] or 0) - borrow
    if v < 0 then v = v + (1 << LB); borrow = 1 else borrow = 0 end
    r[i] = v
  end
  return bnorm(r)
end
local function ibitlen(v) local n = 0; while v > 0 do n = n + 1; v = v >> 1 end; return n end
local function bbitlen(x) local n = #x; if n == 0 then return 0 end; return (n - 1) * LB + ibitlen(x[n]) end
local function bbit(x, p) local l = x[p // LB + 1]; if l == nil then return 0 end; return (l >> (p % LB)) & 1 end
local function bbits(x, lo, len)                 -- the integer of bits lo .. lo+len-1 (len <= 60)
  local v = 0
  for p = lo + len - 1, lo, -1 do v = (v << 1) | bbit(x, p) end
  return v
end
local function bany(x, p)                        -- any bit below p set
  if p <= 0 then return false end
  local full = p // LB
  for i = 1, full do if (x[i] or 0) ~= 0 then return true end end
  local r = p % LB
  if r > 0 and ((x[full + 1] or 0) & ((1 << r) - 1)) ~= 0 then return true end
  return false
end
local function decompose(x)                      -- finite x = +-m * 2^e, m an integer < 2^53
  local u = d2u(x)
  local ex = (u >> 52) & 0x7ff
  local m = u & 0x000FFFFFFFFFFFFF
  local e
  if ex == 0 then e = -1074 else m = m | (1 << 52); e = ex - 1075 end
  return u < 0, m, e
end
-- x86's NaN results: a NaN operand comes back quieted (the first NaN of a, b, c, as the hardware does for the
-- instruction forms GCC emits here), an invalid operation gives the default NaN
local function quiet(x) return u2d(d2u(x) | 0x0008000000000000) end
local function fmaExact(a, b, c)
  if a ~= a then return quiet(a) end
  if b ~= b then return quiet(b) end
  if c ~= c then return quiet(c) end
  if a == INF or a == -INF or b == INF or b == -INF then
    if a == 0 or b == 0 then return DEFAULT_NAN end
    local p = a * b
    if (c == INF or c == -INF) and ((c > 0) ~= (p > 0)) then return DEFAULT_NAN end
    return p
  end
  if c == INF or c == -INF then return c end
  local sa, ma, ea = decompose(a)
  local sb, mb, eb = decompose(b)
  local sc, mc, ec = decompose(c)
  local sp = sa ~= sb
  local pz = ma == 0 or mb == 0
  if pz and mc == 0 then return (sp and sc) and RT.NZERO or 0.0 end
  local ep = ea + eb
  local e0
  if pz then e0 = ec elseif mc == 0 then e0 = ep else e0 = ep < ec and ep or ec end
  local P = pz and {} or bshl(bmul(bfrom(ma), bfrom(mb)), ep - e0)
  local C = mc == 0 and {} or bshl(bfrom(mc), ec - e0)
  local mag, neg
  if pz then mag, neg = C, sc
  elseif mc == 0 then mag, neg = P, sp
  elseif sp == sc then mag, neg = badd(P, C), sp
  else
    local cmp = bcmp(P, C)
    if cmp == 0 then return 0.0 end
    if cmp > 0 then mag, neg = bsub(P, C), sp else mag, neg = bsub(C, P), sc end
  end
  local n = bbitlen(mag)
  local E = n - 1 + e0                           -- exponent of the leading bit
  local shift = E >= -1022 and n - 53 or -1074 - e0
  local q, k
  if shift > 0 then
    q = bbits(mag, shift, n - shift)
    if bbit(mag, shift - 1) == 1 and (bany(mag, shift - 1) or (q & 1) == 1) then q = q + 1 end
    k = e0 + shift
  else
    q = bbits(mag, 0, n)
    k = e0
  end
  if k + ibitlen(q) - 1 > 1023 then return neg and -INF or INF end
  -- q < 2^54 converts exactly, 2^k is representable, and so is the product
  local r = (q * 1.0) * pow2(k)
  return neg and -r or r
end
function RT.fma(a, b, c)
  if (a == 0 or b == 0) and a * b == 0 then return c + a * b end     -- an exact (signed) zero product
  local aa, ab, ac = m_abs(a), m_abs(b), m_abs(c)
  if aa > SMALL and aa < BIG and ab > SMALL and ab < BIG and ac < CBIG and (ac > CSMALL or c == 0) then
    local uh = a * b
    local t = SPLIT * a
    local ah = t - (t - a)
    local al = a - ah
    t = SPLIT * b
    local bh = t - (t - b)
    local bl = b - bh
    local ul = ((ah * bh - uh) + ah * bl + al * bh) + al * bl
    if c == 0 then return uh end
    local th = c + uh
    local bv = th - c
    local tl = (c - (th - bv)) + (uh - bv)
    return th + roundOdd(tl, ul)
  end
  return fmaExact(a, b, c)
end

return RT
