-- main.lua - the Lua port's command line, as EPA's run/main.c: runswmm <input file> <report file> [output file].
-- Loads the runtime (rt.lua), glibc's translated math (glibm.lua), the generated engine (Types.lua, Consts.lua and
-- one chunk per C file, listed in files.lua) and the hand-ported pieces (overrides.lua), each chunk receiving the
-- shared tables F (functions), G (globals), R (runtime), S (string literals), T (record constructors) and K
-- (constants), then runs swmm_run as EPA's main does. Written by Claude (Anthropic) for Robert Dickinson; see
-- ../README.md.
return function(dir, cwd, ...)
  -- the generational collector: the engine makes many short-lived tables (C's struct copies, boxed locals, char
  -- pointers); it took 10 to 15% off the time of the models tried, and changes nothing that is computed
  collectgarbage('generational')
  local argv = {...}
  local F, G, S, T, K = {}, {}, {}, {}, {}
  local R = dofile(dir .. '/rt.lua')
  local glibm = assert(loadfile(dir .. '/glibm.lua'))(dofile(dir .. '/glibm_rt.lua'))
  R.setGlibm(glibm)
  R.setCwd(cwd)
  local function load(name) assert(loadfile(dir .. '/' .. name .. '.lua'))(F, G, R, S, T, K) end
  load('Types')
  load('Consts')
  for _, name in ipairs(dofile(dir .. '/files.lua')) do load(name) end
  load('overrides')
  local function out(s) io.stdout:write(s); io.stdout:flush() end
  local version = F.swmm_getVersion()
  local vMajor = version // 10000
  local vMinor = (version - 10000 * vMajor) // 1000
  local vRelease = version - 10000 * vMajor - 1000 * vMinor
  if #argv == 0 then out('\nNot Enough Arguments (See Help --help)\n\n')
  elseif #argv == 1 then
    local a = argv[1]
    if a == '--help' or a == '-h' then
      out('\n\nSTORMWATER MANAGEMENT MODEL (SWMM) HELP\n\nCOMMANDS:\n\t--help (-h)       SWMM Help\n'
          .. '\t--version (-v)    Build Version\n\nRUNNING A SIMULATION:\n'
          .. '\t runswmm <input file> <report file> <optional output file>\n\n')
    elseif a == '--version' or a == '-v' then out('\n' .. vMajor .. '.' .. vMinor .. '.' .. vRelease .. '\n\n')
    else out('\nUnknown Argument (See Help --help)\n\n') end
  else
    local start = os.clock()
    out('\n... EPA SWMM ' .. vMajor .. '.' .. vMinor .. ' (Build ' .. vMajor .. '.' .. vMinor .. '.' .. vRelease .. ') [Lua port]\n')
    F.swmm_run(R.lit(argv[1]), R.lit(argv[2]), R.lit(argv[3] or ''))
    local msg = string.format('\n\n... EPA SWMM completed in %.2f seconds.', os.clock() - start)
    local err = R.buf(128)
    if F.swmm_getError(err, 127) > 0 then msg = msg .. ' There are errors.\n'
    elseif F.swmm_getWarnings() > 0 then msg = msg .. ' There are warnings.\n'
    else msg = msg .. '\n' end
    out(msg)
  end
  io.stdout:flush()
  return 0
end
