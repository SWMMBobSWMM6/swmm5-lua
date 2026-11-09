-- libmcheck.lua - compare the math the Lua engine calls with the system libm, bit for bit (NaN payloads and signs
-- included), on vectors written by tools/libm/test/mkvectors.c and mkedge.c (records: name\0, n:u32, then n x (args...,
-- result) as doubles), and on floor/ceil/sqrt/fabs vectors from mkround.c. Each function is checked as the engine
-- calls it: exp, sin, cos, tan, asin, acos, sqrt and fabs are Lua's math library (glibc); log, log10, pow, floor and
-- ceil go through rt.lua's wrappers; pow with y == 2 and atan are glibc's GIMPLE translated (glibm.lua); fma is
-- glibm_rt.lua's emulation. "pow_translated" runs every pow vector through the translation, whatever y is.
-- Run by run_libm_tests.sh. Written by Claude (Anthropic) for Robert Dickinson; see ../README.md.
local dir, path = ...
local R = dofile(dir .. '/rt.lua')
local RT = dofile(dir .. '/glibm_rt.lua')
local G = assert(loadfile(dir .. "/glibm.lua"))(RT)
R.setGlibm(G)
local sunpack = string.unpack
local fns = {
  exp = math.exp, log = R.log, log10 = R.log10, pow = R.pow, sin = math.sin, cos = math.cos, tan = math.tan,
  asin = math.asin, acos = math.acos, atan = R.atan, fma = RT.fma, floor = R.floor, ceil = R.ceil,
  sqrt = math.sqrt, fabs = math.abs, neg = function(x) return -x end, f32 = R.f32, d2i = R.D2I, d2l = R.D2L}
local INTRES = {d2i = true, d2l = true}
local NARGS = {pow = 2, fma = 3}
local f = assert(io.open(path, 'rb'))
local data = f:read('a')
f:close()
local pos = 1
local function report(name, n, bad, nan, t0)
  print(string.format('%-14s %d of %d differ (%d of them a NaN sign)   (%.3f us/call)', name, bad, n, nan,
                      (os.clock() - t0) * 1e6 / math.max(n, 1)))
end
while pos <= #data do
  local z = data:find('\0', pos, true)
  local name = data:sub(pos, z - 1)
  local n
  n, pos = sunpack('<I4', data, z + 1)
  local na = NARGS[name] or 1
  local fn = fns[name]
  local runs = {{name, fn}}
  if name == 'pow' then runs[2] = {'pow_translated', G.pow} end
  local start = pos
  for _, run in ipairs(runs) do
    local label, fn = run[1], run[2]
    pos = start
    local bad, nan, shown = 0, 0, 0
    local t0 = os.clock()
    for i = 1, n do
      local x, y, c, want
      if na == 1 then x, want, pos = sunpack('<dd', data, pos)
      elseif na == 2 then x, y, want, pos = sunpack('<ddd', data, pos)
      else x, y, c, want, pos = sunpack('<dddd', data, pos) end
      local got = fn(x, y, c)
      local gb, wb
      if INTRES[name] then gb, wb = math.type(got) == 'integer' and got or 0x7ff0dead, RT.d2u(want)
      else gb, wb = RT.d2u(got), RT.d2u(want) end
      if gb ~= wb then
        bad = bad + 1
        if got ~= got and want ~= want and (gb < 0) ~= (wb < 0) then nan = nan + 1 end
        if shown < 4 then
          shown = shown + 1
          print(string.format('  %s(%a%s%s) = %016x, libm %016x', label, x, y and (', ' .. string.format('%a', y)) or '',
                              c and (', ' .. string.format('%a', c)) or '', gb, wb))
        end
      end
    end
    report(label, n, bad, nan, t0)
  end
end
