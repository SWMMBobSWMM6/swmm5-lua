-- crtcheck.lua - compare the Lua port's printf, strtod and sscanf (swmm5/rt.lua) with the system glibc's results
-- written by tools/crt/test/mkfmt.c (lines KIND \t FORMAT \t ARG \t RESULT, hex-encoded), as the PHP, Ruby and
-- Groovy ports' crtcheck scripts do. Run by run_crtcheck.sh. Written by Claude (Anthropic) for Robert Dickinson;
-- see ../README.md.
local dir, path = ...
local R = dofile(dir .. '/rt.lua')
local spack, sunpack, sbyte, sfmt = string.pack, string.unpack, string.byte, string.format
local function unhex(h) return (h:gsub('..', function(x) return string.char(tonumber(x, 16)) end)) end
local function hexOf(p)
  local t, b, i = {}, p.b, p.o
  while b[i] ~= 0 do t[#t + 1] = sfmt('%02x', b[i] & 255); i = i + 1 end
  return table.concat(t)
end
local function bits(v) return sfmt('%016x', (sunpack('<i8', spack('<d', v)))) end
local function u64(h) return (tonumber('0x' .. h)) end   -- 16 hex digits wrap to a signed 64-bit integer
local names = {'printf %f', 'printf %d', 'printf %ld', 'printf %s', 'strtod', 'sscanf'}
local KIND = {f = 1, i = 2, l = 3, s = 4, d = 5, n = 6}
local total, bad = {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}
local shown = 0
local out = R.buf(1024)
local fcache = {}
local SC = R.lit('%d %lf %s')
for line in io.lines(path) do
  if line ~= '' then
    local kind, fm, arg, want = line:match('^([^\t]*)\t([^\t]*)\t([^\t]*)\t(.*)$')
    local k = KIND[kind]
    if k then
      local f = fcache[fm]
      if f == nil then f = R.lit(fm); fcache[fm] = f end
      local got
      if kind == 'f' then
        local x = (sunpack('<d', spack('<i8', u64(arg))))
        if fm == '%*.*f' then R.snprintf(out, 1024, f, 9, 3, x) else R.snprintf(out, 1024, f, x) end
        got = hexOf(out)
      elseif kind == 'i' then
        R.snprintf(out, 1024, f, R.i32(tonumber(arg, 16)))
        got = hexOf(out)
      elseif kind == 'l' then
        R.snprintf(out, 1024, f, u64(arg))
        got = hexOf(out)
      elseif kind == 's' then
        R.snprintf(out, 1024, f, R.lit(unhex(arg)))
        got = hexOf(out)
      elseif kind == 'd' then
        local s = R.lit(unhex(arg))
        local e = {}
        local v = R.strtod(s, e, 1)
        got = bits(v) .. ':' .. (e[1].o - s.o)
      else
        local s = R.lit(unhex(arg))
        local i1, d1 = {-77}, {-77.0}
        local b = R.buf(32)
        R.cset(b, 0, 63)
        local n = R.sscanf(s, SC, i1, 1, d1, 1, b)
        got = n .. ':' .. math.tointeger(i1[1]) .. ':' .. bits(d1[1]) .. ':' .. hexOf(b)
      end
      total[k] = total[k] + 1
      if got ~= want then
        bad[k] = bad[k] + 1
        if shown < 25 then
          shown = shown + 1
          io.stderr:write('  ' .. kind .. ' ' .. fm .. ' arg=' .. arg .. '  glibc=' .. want .. '  lua=' .. got .. '\n')
        end
      end
    end
  end
end
local t, b = 0, 0
for k = 1, 6 do print(names[k] .. ': ' .. total[k] .. ' cases, ' .. bad[k] .. ' differ'); t = t + total[k]; b = b + bad[k] end
print(b .. ' of ' .. t .. ' cases differ')
