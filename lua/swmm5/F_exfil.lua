-- Generated from EPA SWMM 5.2.4 (exfil.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local ERR_NUMBER <const> = 211
local ERR_ITEMS <const> = 203
local TABULAR <const> = 0
local FUNCTIONAL <const> = 1
local CYLINDRICAL <const> = 2
local CONICAL <const> = 3
local PYRAMIDAL <const> = 5
local LENGTH <const> = 3
local MOD_GREEN_AMPT <const> = 3
local ERR_MEMORY <const> = 101
local _ENV = R.strict


-- exfil.c:34
F.exfil_readStorageParams = function(k, tok, ntoks, n)
  local i = 0
  local x = R.fill(3, 0.0)
  if (ntoks == (n + 1)) then
    if (not (F.getDouble(tok[n], x, 1) ~= 0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[n]) end
    end
    x[0] = 0.0
    x[2] = 0.0
  elseif (ntoks < (n + 3)) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  else
    do
      i = 0
      while (i < 3) do
        do
          if (not (F.getDouble(tok[(n + i)], x, i) ~= 0)) then
            do return F.error_setInpError(ERR_NUMBER, tok[(n + i)]) end
          end
        end
        i = i + 1
      end
    end
  end
  if (x[1] == 0.0) then
    do return 0 end
  end
  do return F.createStorageExfil(k, x) end
end

-- exfil.c:74
F.exfil_initState = function(k)
  local G_Storage = G.Storage
  local i = 0
  local a = {0.0}
  local alast = 0.0
  local d = {0.0}
  local aCurve = nil
  local exfil = G_Storage[k].exfil
  if (exfil ~= (nil)) then
    F.grnampt_initState(exfil.btmExfil)
    F.grnampt_initState(exfil.bankExfil)
    do
      local __sw1 = G_Storage[k].shape
      if __sw1 == TABULAR then goto case2
      elseif __sw1 == FUNCTIONAL then goto case3
      elseif __sw1 == CYLINDRICAL or __sw1 == CONICAL or __sw1 == PYRAMIDAL then goto case4
      else goto swend1 end
      ::case2::
      do
        i = G_Storage[k].aCurve
        exfil.btmArea = 0.0
        exfil.bankMinDepth = 0.0
        exfil.bankMaxDepth = 0.0
        exfil.bankMaxArea = 0.0
        if (i >= 0) then
          aCurve = G.Curve[i]
          G_Storage[k].exfil.btmArea = F.table_lookupEx(aCurve, 0.0)
          F.table_getFirstEntry(aCurve, d, 1, a, 1)
          alast = a[1]
          while (F.table_getNextEntry(aCurve, d, 1, a, 1) ~= 0) do
            do
              if (a[1] < alast) then
                break
              elseif (a[1] > alast) then
                exfil.bankMaxArea = a[1]
                exfil.bankMaxDepth = d[1]
              elseif (exfil.bankMaxArea == 0.0) then
                exfil.bankMinDepth = d[1]
              else
                break
              end
              alast = a[1]
            end
          end
          exfil.btmArea = (exfil.btmArea / (F.UCF(LENGTH) * F.UCF(LENGTH)))
          exfil.bankMaxArea = (exfil.bankMaxArea / (F.UCF(LENGTH) * F.UCF(LENGTH)))
          exfil.bankMinDepth = (exfil.bankMinDepth / (F.UCF(LENGTH)))
          exfil.bankMaxDepth = (exfil.bankMaxDepth / (F.UCF(LENGTH)))
        end
        goto swend1
      end
      ::case3::
      do
        exfil.btmArea = G_Storage[k].a0
        if (G_Storage[k].a2 == 0.0) then
          exfil.btmArea = (exfil.btmArea + G_Storage[k].a1)
        end
        exfil.bankMinDepth = 0.0
        exfil.bankMaxDepth = 10000000000.0
        exfil.bankMaxArea = 10000000000.0
        goto swend1
      end
      ::case4::
      do
        exfil.btmArea = G_Storage[k].a0
        exfil.bankMinDepth = 0.0
        exfil.bankMaxDepth = 10000000000.0
        exfil.bankMaxArea = 10000000000.0
        goto swend1
      end
      ::swend1::
    end
  end
end

-- exfil.c:158
F.exfil_getLoss = function(exfil, tStep, depth, area)
  local G_Adjust = G.Adjust
  local exfilRate = 0.0
  if (exfil.btmExfil.IMDmax == 0.0) then
    exfilRate = (exfil.btmExfil.Ks * G_Adjust.hydconFactor)
  else
    exfilRate = F.grnampt_getInfil(exfil.btmExfil, tStep, 0.0, depth, MOD_GREEN_AMPT)
  end
  exfilRate = (exfilRate * exfil.btmArea)
  if (depth > exfil.bankMinDepth) then
    area = ((((((area) <= (exfil.bankMaxArea))) and (area) or (exfil.bankMaxArea))) - exfil.btmArea)
    if (area > 0.0) then
      if (exfil.btmExfil.IMDmax == 0.0) then
        exfilRate = (exfilRate + ((area * exfil.btmExfil.Ks) * G_Adjust.hydconFactor))
      else
        if (depth > exfil.bankMaxDepth) then
          depth = ((depth - exfil.bankMaxDepth) + (((exfil.bankMaxDepth - exfil.bankMinDepth)) / 2.0))
        else
          depth = (((depth - exfil.bankMinDepth)) / 2.0)
        end
        exfilRate = (exfilRate + (area * F.grnampt_getInfil(exfil.bankExfil, tStep, 0.0, depth, MOD_GREEN_AMPT)))
      end
    end
  end
  do return exfilRate end
end

-- exfil.c:218
F.createStorageExfil = function(k, x)
  local G_Storage = G.Storage
  local exfil = nil
  exfil = G_Storage[k].exfil
  if (exfil == (nil)) then
    exfil = T.TExfil()
    if (exfil == (nil)) then
      do return F.error_setInpError(ERR_MEMORY, S[0]) end
    end
    G_Storage[k].exfil = exfil
    exfil.btmExfil = (nil)
    exfil.bankExfil = (nil)
    exfil.btmExfil = T.TGrnAmpt()
    if (exfil.btmExfil == (nil)) then
      do return F.error_setInpError(ERR_MEMORY, S[0]) end
    end
    exfil.bankExfil = T.TGrnAmpt()
    if (exfil.bankExfil == (nil)) then
      do return F.error_setInpError(ERR_MEMORY, S[0]) end
    end
  end
  if (not (F.grnampt_setParams(exfil.btmExfil, x) ~= 0)) then
    do return F.error_setInpError(ERR_NUMBER, S[0]) end
  end
  F.grnampt_setParams(exfil.bankExfil, x)
  do return 0 end
end

