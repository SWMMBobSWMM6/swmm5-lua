-- overrides.lua - hand-ported pieces of EPA SWMM 5.2.4 that use C pointer arithmetic the translator does not map:
-- odesolve.c (whole file), mempool.c (its pool becomes plain byte buffers) and six helpers from swmm5.c and project.c.
-- Each keeps the C statement order and floating-point expressions exactly; pow is glibc's (R.pow). A translation of
-- the Java port's Overrides.java into Lua. Written by Claude (Anthropic) for Robert Dickinson; see ../README.md.
local F, G, R, S, T, K = ...
local m_abs = math.abs
local _ENV = R.strict

local MAXFNAME_ = 259

-- (the bytes of a char buffer are already C chars, -128 .. 127, so they are copied as they are)
F.sstrncpy = function(dest, src, n)
  local db, dof, sb, sof = dest.b, dest.o, src.b, src.o
  local offset = 0
  if n > 0 then
    while sb[sof + offset] ~= 0 do
      if offset == n then break end
      db[dof + offset] = sb[sof + offset]
      offset = offset + 1
    end
  end
  db[dof + offset] = 0
  return R.strlenI(dest)
end

F.sstrcat = function(dest, src, size)
  local db, dof, sb, sof = dest.b, dest.o, src.b, src.o
  local offset = R.strlenI(dest)
  local srcIndex = 0
  while sb[sof + srcIndex] ~= 0 do
    db[dof + offset] = sb[sof + srcIndex]
    offset = offset + 1
    srcIndex = srcIndex + 1
    if offset == size - 1 then break end
  end
  db[dof + offset] = 0
  return R.strlenI(dest)
end

local function isRelative(fname)
  if R.strchr(fname, 58) ~= nil then return false end       -- ':'
  if R.cget(fname, 0) == 92 then return false end            -- '\\'
  if R.cget(fname, 0) == 47 then return false end            -- '/'
  return true
end

-- realpath(fname, absPath): the working directory's physical path (`pwd -P`, through C's popen) and the name
F.getAbsolutePath = function(fname, absPath, size)
  if fname == nil or R.strlen(fname) == 0 then return end
  if isRelative(fname) then
    local full = R.realpathOf(R.strOf(fname))
    local m = #full
    for i = 1, m do R.cset(absPath, i - 1, full:byte(i)) end
    R.cset(absPath, m, 0)
  else
    F.sstrncpy(absPath, fname, R.strlen(fname))
  end
  local endOfDir = R.strrchr(absPath, 47)
  if endOfDir ~= nil then R.cset(endOfDir, 1, 0) end
end

F.getTempFileName = function(fname)
  F.sstrncpy(fname, R.lit('swmmXXXXXX'), MAXFNAME_)
  R.mkstemp(fname)
  return fname
end

F.project_createMatrix = function(nrows, ncols)
  if nrows <= 0 or ncols <= 0 then return nil end
  return R.grid(nrows, ncols, 0.0)
end

F.project_freeMatrix = function(a) end

F.AllocInit = function() return {} end
F.Alloc = function(n) return R.buf(n) end
F.AllocSetPool = function(p) return p end
F.AllocReset = function() end
F.AllocFreePool = function() end

-- ------------------------------------------------------------ odesolve.c (Cash-Karp Runge-Kutta)
local MAXSTP = 10000
local TINY, SAFETY, PGROW, PSHRNK, ERRCON = 1.0e-30, 0.9, -0.2, -0.25, 1.89e-4
local nmax = 0
local y, yscal, dydx, yerr, ytemp, ak2, ak3, ak4, ak5, ak6

F.odesolve_open = function(n)
  nmax = 0
  y = R.fill(n, 0.0); yscal = R.fill(n, 0.0); dydx = R.fill(n, 0.0); yerr = R.fill(n, 0.0); ytemp = R.fill(n, 0.0)
  ak2 = R.fill(n, 0.0); ak3 = R.fill(n, 0.0); ak4 = R.fill(n, 0.0); ak5 = R.fill(n, 0.0); ak6 = R.fill(n, 0.0)
  nmax = n
  return 1
end

F.odesolve_close = function() nmax = 0 end

local function rkck(x, n, h, derivs)
  local a2, a3, a4, a5, a6 = 0.2, 0.3, 0.6, 1.0, 0.875
  local b21, b31, b32, b41, b42, b43 = 0.2, 3.0 / 40.0, 9.0 / 40.0, 0.3, -0.9, 1.2
  local b51, b52, b53, b54 = -11.0 / 54.0, 2.5, -70.0 / 27.0, 35.0 / 27.0
  local b61, b62, b63 = 1631.0 / 55296.0, 175.0 / 512.0, 575.0 / 13824.0
  local b64, b65, c1 = 44275.0 / 110592.0, 253.0 / 4096.0, 37.0 / 378.0
  local c3, c4, c6 = 250.0 / 621.0, 125.0 / 594.0, 512.0 / 1771.0
  local dc5 = -277.0 / 14336.0
  local dc1, dc3 = c1 - 2825.0 / 27648.0, c3 - 18575.0 / 48384.0
  local dc4, dc6 = c4 - 13525.0 / 55296.0, c6 - 0.25
  for i = 0, n - 1 do ytemp[i] = y[i] + b21 * h * dydx[i] end
  derivs(x + a2 * h, ytemp, ak2)
  for i = 0, n - 1 do ytemp[i] = y[i] + h * (b31 * dydx[i] + b32 * ak2[i]) end
  derivs(x + a3 * h, ytemp, ak3)
  for i = 0, n - 1 do ytemp[i] = y[i] + h * (b41 * dydx[i] + b42 * ak2[i] + b43 * ak3[i]) end
  derivs(x + a4 * h, ytemp, ak4)
  for i = 0, n - 1 do ytemp[i] = y[i] + h * (b51 * dydx[i] + b52 * ak2[i] + b53 * ak3[i] + b54 * ak4[i]) end
  derivs(x + a5 * h, ytemp, ak5)
  for i = 0, n - 1 do ytemp[i] = y[i] + h * (b61 * dydx[i] + b62 * ak2[i] + b63 * ak3[i] + b64 * ak4[i] + b65 * ak5[i]) end
  derivs(x + a6 * h, ytemp, ak6)
  for i = 0, n - 1 do ytemp[i] = y[i] + h * (c1 * dydx[i] + c3 * ak3[i] + c4 * ak4[i] + c6 * ak6[i]) end
  for i = 0, n - 1 do yerr[i] = h * (dc1 * dydx[i] + dc3 * ak3[i] + dc4 * ak4[i] + dc5 * ak5[i] + dc6 * ak6[i]) end
end

-- x, hdid, hnext: one-element arrays, as the C passes their addresses
local function rkqs(x, n, htry, eps, hdid, hnext, derivs)
  local xold = x[0]
  local h = htry
  while true do
    rkck(xold, n, h, derivs)
    local errmax = 0.0
    for i = 0, n - 1 do
      local err = m_abs(yerr[i] / yscal[i])
      if err > errmax then errmax = err end
    end
    errmax = errmax / eps
    if errmax > 1.0 then
      local htemp = SAFETY * h * R.pow(errmax, PSHRNK)
      if h >= 0.0 then
        if htemp > 0.1 * h then h = htemp else h = 0.1 * h end
      else
        if htemp < 0.1 * h then h = htemp else h = 0.1 * h end
      end
      local xnew = xold + h
      if xnew == xold then return 2 end
    else
      if errmax > ERRCON then hnext[0] = SAFETY * h * R.pow(errmax, PGROW)
      else hnext[0] = 5.0 * h end
      hdid[0] = h
      x[0] = x[0] + h
      for i = 0, n - 1 do y[i] = ytemp[i] end
      return 0
    end
  end
end

F.odesolve_integrate = function(ystart, n, x1, x2, eps, h1, derivs)
  local hdid, hnext, x = {[0] = 0.0}, {[0] = 0.0}, {[0] = 0.0}
  x[0] = x1
  local h = h1
  if nmax < n then return 1 end
  for i = 0, n - 1 do y[i] = ystart[i] end
  for nstp = 1, MAXSTP do
    derivs(x[0], y, dydx)
    for i = 0, n - 1 do yscal[i] = m_abs(y[i]) + m_abs(dydx[i] * h) + TINY end
    if (x[0] + h - x2) * (x[0] + h - x1) > 0.0 then h = x2 - x[0] end
    local errcode = rkqs(x, n, h, eps, hdid, hnext, derivs)
    if errcode ~= 0 then break end
    if (x[0] - x2) * (x2 - x1) >= 0.0 then
      for i = 0, n - 1 do ystart[i] = y[i] end
      return 0
    end
    if m_abs(hnext[0]) <= 0.0 then return 2 end
    h = hnext[0]
  end
  return 3
end
