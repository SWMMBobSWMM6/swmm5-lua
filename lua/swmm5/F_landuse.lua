-- Generated from EPA SWMM 5.2.4 (landuse.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local ERR_ITEMS <const> = 203
local LANDUSE <const> = 5
local ERR_NAME <const> = 209
local ERR_NUMBER <const> = 211
local POLLUT <const> = 4
local ERR_KEYWORD <const> = 205
local MG <const> = 0
local MASS <const> = 8
local UG <const> = 1
local NO_BUILDUP <const> = 0
local EXTERNAL_BUILDUP <const> = 4
local POWER_BUILDUP <const> = 1
local EXPON_BUILDUP <const> = 2
local SATUR_BUILDUP <const> = 3
local TSERIES <const> = 8
local NO_WASHOFF <const> = 0
local EXPON_WASHOFF <const> = 1
local RATING_WASHOFF <const> = 2
local FLOW <const> = 10
local EMC_WASHOFF <const> = 3
local LANDAREA <const> = 4
local PER_AREA <const> = 0
local PER_CURB <const> = 1
local BUILDUP_LOAD <const> = 0
local BMP_REMOVAL_LOAD <const> = 3
local RAINFALL <const> = 0
local _ENV = R.strict


-- landuse.c:51
F.landuse_readParams = function(j, tok, ntoks)
  local G_Landuse = G.Landuse
  local id = nil
  if (ntoks < 1) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  id = F.project_findID(LANDUSE, tok[0])
  if R.peq(id, (nil)) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  G_Landuse[j].ID = id
  if (ntoks > 1) then
    if (ntoks < 4) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    if (not (F.getDouble(tok[1], G_Landuse[j], "sweepInterval") ~= 0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[1]) end
    end
    if (not (F.getDouble(tok[2], G_Landuse[j], "sweepRemoval") ~= 0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[2]) end
    end
    if (not (F.getDouble(tok[3], G_Landuse[j], "sweepDays0") ~= 0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[3]) end
    end
  else
    G_Landuse[j].sweepInterval = 0.0
    G_Landuse[j].sweepRemoval = 0.0
    G_Landuse[j].sweepDays0 = 0.0
  end
  if ((G_Landuse[j].sweepRemoval < 0.0) or (G_Landuse[j].sweepRemoval > 1.0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[2]) end
  end
  do return 0 end
end

-- landuse.c:92
F.landuse_readPollutParams = function(j, tok, ntoks)
  local G_Pollut = G.Pollut
  local i = 0
  local k = 0
  local coPollut = 0
  local snowFlag = 0
  local x = R.fill(4, 0.0)
  local coFrac = {0.0}
  local cDWF = {0.0}
  local cInit = {0.0}
  local id = nil
  if (ntoks < 6) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  id = F.project_findID(POLLUT, tok[0])
  if R.peq(id, (nil)) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  k = F.findmatch(tok[1], G.QualUnitsWords)
  if (k < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
  end
  do
    i = 2
    while (i <= 4) do
      do
        if ((not (F.getDouble(tok[i], x, (i - 2)) ~= 0)) or (x[(i - 2)] < 0.0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[i]) end
        end
      end
      i = i + 1
    end
  end
  if (not (F.getDouble(tok[5], x, 3) ~= 0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[5]) end
  end
  snowFlag = 0
  coPollut = (-1)
  coFrac[1] = 0.0
  cDWF[1] = 0.0
  cInit[1] = 0.0
  if (ntoks >= 7) then
    snowFlag = F.findmatch(tok[6], G.NoYesWords)
    if (snowFlag < 0) then
      do return F.error_setInpError(ERR_KEYWORD, tok[6]) end
    end
  end
  if (ntoks >= 9) then
    if (not (F.strcomp(tok[7], S[275]) ~= 0)) then
      coPollut = F.project_findObject(POLLUT, tok[7])
      if (coPollut < 0) then
        do return F.error_setInpError(ERR_NAME, tok[7]) end
      end
      if ((not (F.getDouble(tok[8], coFrac, 1) ~= 0)) or (coFrac[1] < 0.0)) then
        do return F.error_setInpError(ERR_NUMBER, tok[8]) end
      end
    end
  end
  if (ntoks >= 10) then
    if ((not (F.getDouble(tok[9], cDWF, 1) ~= 0)) or (cDWF[1] < 0.0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[9]) end
    end
  end
  if (ntoks >= 11) then
    if ((not (F.getDouble(tok[10], cInit, 1) ~= 0)) or (cInit[1] < 0.0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[9]) end
    end
  end
  G_Pollut[j].ID = id
  G_Pollut[j].units = k
  if (G_Pollut[j].units == MG) then
    G_Pollut[j].mcf = F.UCF(MASS)
  elseif (G_Pollut[j].units == UG) then
    G_Pollut[j].mcf = (F.UCF(MASS) / 1000.0)
  else
    G_Pollut[j].mcf = 1.0
  end
  G_Pollut[j].pptConcen = x[0]
  G_Pollut[j].gwConcen = x[1]
  G_Pollut[j].rdiiConcen = x[2]
  G_Pollut[j].kDecay = (x[3] / 86400.0)
  G_Pollut[j].snowOnly = snowFlag
  G_Pollut[j].coPollut = coPollut
  G_Pollut[j].coFraction = coFrac[1]
  G_Pollut[j].dwfConcen = cDWF[1]
  G_Pollut[j].initConcen = cInit[1]
  do return 0 end
end

-- landuse.c:190
F.landuse_readBuildupParams = function(tok, ntoks)
  local G_Landuse = G.Landuse
  local i = 0
  local j = 0
  local k = 0
  local n = 0
  local p = 0
  local c = {[0] = 0.0, 0.0, 0.0}
  local tmax = 0.0
  if (ntoks < 3) then
    do return 0 end
  end
  j = F.project_findObject(LANDUSE, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  p = F.project_findObject(POLLUT, tok[1])
  if (p < 0) then
    do return F.error_setInpError(ERR_NAME, tok[1]) end
  end
  k = F.findmatch(tok[2], G.BuildupTypeWords)
  if (k < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[2]) end
  end
  G_Landuse[j].buildupFunc[p].funcType = k
  if (k > NO_BUILDUP) then
    if (ntoks < 7) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    if (k ~= EXTERNAL_BUILDUP) then
      do
        i = 0
        while (i < 3) do
          do
            if ((not (F.getDouble(tok[(i + 3)], c, i) ~= 0)) or (c[i] < 0.0)) then
              do return F.error_setInpError(ERR_NUMBER, tok[(i + 3)]) end
            end
          end
          i = i + 1
        end
      end
    end
    n = F.findmatch(tok[6], G.NormalizerWords)
    if (n < 0) then
      do return F.error_setInpError(ERR_KEYWORD, tok[6]) end
    end
    G_Landuse[j].buildupFunc[p].normalizer = n
  end
  do
    local __sw1 = G_Landuse[j].buildupFunc[p].funcType
    if __sw1 == POWER_BUILDUP then goto case3
    elseif __sw1 == EXPON_BUILDUP then goto case4
    elseif __sw1 == SATUR_BUILDUP then goto case5
    elseif __sw1 == EXTERNAL_BUILDUP then goto case6
    else goto case7 end
    ::case3::
    do
      if ((c[2] > 0.0) and (((c[2] < 0.01) or (c[2] > 10.0)))) then
        do return F.error_setInpError(ERR_KEYWORD, tok[5]) end
      end
      if ((c[1] * c[2]) == 0.0) then
        tmax = 0.0
      elseif ((R.log10(c[0]) / c[2]) > 3.5) then
        tmax = 3650.0
      else
        tmax = R.pow((c[0] / c[1]), (1.0 / c[2]))
      end
      goto swend2
    end
    ::case4::
    do
      if (c[1] == 0.0) then
        tmax = 0.0
      else
        tmax = ((-(R.log(0.001))) / c[1])
      end
      goto swend2
    end
    ::case5::
    do
      tmax = (1000.0 * c[2])
      goto swend2
    end
    ::case6::
    do
      if ((not (F.getDouble(tok[3], c, 0) ~= 0)) or (c[0] < 0.0)) then
        do return F.error_setInpError(ERR_NUMBER, tok[3]) end
      end
      if ((not (F.getDouble(tok[4], c, 1) ~= 0)) or (c[1] < 0.0)) then
        do return F.error_setInpError(ERR_NUMBER, tok[3]) end
      end
      n = F.project_findObject(TSERIES, tok[5])
      if (n < 0) then
        do return F.error_setInpError(ERR_NAME, tok[4]) end
      end
      G.Tseries[n].refersTo = EXTERNAL_BUILDUP
      c[2] = (n * 1.0)
      tmax = 0.0
      goto swend2
    end
    ::case7::
    do
      tmax = 0.0
    end
    ::swend2::
  end
  G_Landuse[j].buildupFunc[p].coeff[0] = c[0]
  G_Landuse[j].buildupFunc[p].coeff[1] = c[1]
  G_Landuse[j].buildupFunc[p].coeff[2] = c[2]
  G_Landuse[j].buildupFunc[p].maxDays = tmax
  do return 0 end
end

-- landuse.c:281
F.landuse_readWashoffParams = function(tok, ntoks)
  local G_Landuse = G.Landuse
  local i = 0
  local j = 0
  local p = 0
  local func = 0
  local x = R.fill(4, 0.0)
  if (ntoks < 3) then
    do return 0 end
  end
  do
    i = 0
    while (i < 4) do
      do
        x[i] = 0.0
      end
      i = i + 1
    end
  end
  func = NO_WASHOFF
  j = F.project_findObject(LANDUSE, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  p = F.project_findObject(POLLUT, tok[1])
  if (p < 0) then
    do return F.error_setInpError(ERR_NAME, tok[1]) end
  end
  if (ntoks > 2) then
    func = F.findmatch(tok[2], G.WashoffTypeWords)
    if (func < 0) then
      do return F.error_setInpError(ERR_KEYWORD, tok[2]) end
    end
    if (func ~= NO_WASHOFF) then
      if (ntoks < 5) then
        do return F.error_setInpError(ERR_ITEMS, S[0]) end
      end
      if (not (F.getDouble(tok[3], x, 0) ~= 0)) then
        do return F.error_setInpError(ERR_NUMBER, tok[3]) end
      end
      if (not (F.getDouble(tok[4], x, 1) ~= 0)) then
        do return F.error_setInpError(ERR_NUMBER, tok[4]) end
      end
      if (ntoks >= 6) then
        if (not (F.getDouble(tok[5], x, 2) ~= 0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[5]) end
        end
      end
      if (ntoks >= 7) then
        if (not (F.getDouble(tok[6], x, 3) ~= 0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[6]) end
        end
      end
    end
  end
  if (x[0] < 0.0) then
    do return F.error_setInpError(ERR_NUMBER, tok[3]) end
  end
  if ((x[1] < (-10.0)) or (x[1] > 10.0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[4]) end
  end
  if ((x[2] < 0.0) or (x[2] > 100.0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[5]) end
  end
  if ((x[3] < 0.0) or (x[3] > 100.0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[6]) end
  end
  if (func == EXPON_WASHOFF) then
    x[0] = (x[0] / 3600.0)
  end
  if (func == RATING_WASHOFF) then
    x[0] = (x[0] * (R.pow(F.UCF(FLOW), x[1])))
  end
  if (func == EMC_WASHOFF) then
    x[0] = (x[0] * 28.317)
  end
  G_Landuse[j].washoffFunc[p].funcType = func
  G_Landuse[j].washoffFunc[p].coeff = x[0]
  G_Landuse[j].washoffFunc[p].expon = x[1]
  G_Landuse[j].washoffFunc[p].sweepEffic = (x[2] / 100.0)
  G_Landuse[j].washoffFunc[p].bmpEffic = (x[3] / 100.0)
  do return 0 end
end

-- landuse.c:355
F.landuse_getInitBuildup = function(landFactor, initBuildup, area, curb)
  local G_Nobjects, G_Landuse = G.Nobjects, G.Landuse
  local i = 0
  local p = 0
  local startDrySeconds = 0.0
  local f = 0.0
  local fArea = 0.0
  local fCurb = 0.0
  local buildup = 0.0
  startDrySeconds = (G.StartDryDays * 86400.0)
  do
    i = 0
    while (i < G_Nobjects[LANDUSE]) do
      do
        landFactor[i].lastSwept = (G.StartDateTime - G_Landuse[i].sweepDays0)
        f = landFactor[i].fraction
        fArea = ((f * area) * F.UCF(LANDAREA))
        fCurb = (f * curb)
        do
          p = 0
          while (p < G_Nobjects[POLLUT]) do
            do
              buildup = 0.0
              if (initBuildup[p] > 0.0) then
                buildup = (initBuildup[p] * fArea)
              else
                buildup = F.landuse_getBuildup(i, p, fArea, fCurb, buildup, startDrySeconds)
              end
              landFactor[i].buildup[p] = buildup
            end
            p = p + 1
          end
        end
      end
      i = i + 1
    end
  end
end

-- landuse.c:411
F.landuse_getBuildup = function(i, p, area, curb, buildup, tStep)
  local G_Landuse = G.Landuse
  local n = 0
  local days = 0.0
  local perUnit = 0.0
  if ((G_Landuse[i].buildupFunc[p].funcType == NO_BUILDUP) or (tStep == 0.0)) then
    do return buildup end
  end
  n = G_Landuse[i].buildupFunc[p].normalizer
  perUnit = 1.0
  if (n == PER_AREA) then
    perUnit = area
  end
  if (n == PER_CURB) then
    perUnit = curb
  end
  if (perUnit == 0.0) then
    do return 0.0 end
  end
  if (G_Landuse[i].buildupFunc[p].funcType == EXTERNAL_BUILDUP) then
    do return (F.landuse_getExternalBuildup(i, p, (buildup / perUnit), tStep) * perUnit) end
  end
  days = F.landuse_getBuildupDays(i, p, (buildup / perUnit))
  days = (days + (tStep / 86400.0))
  do return (F.landuse_getBuildupMass(i, p, days) * perUnit) end
end

-- landuse.c:458
F.landuse_getBuildupDays = function(i, p, buildup)
  local G_Landuse = G.Landuse
  local c0 = G_Landuse[i].buildupFunc[p].coeff[0]
  local c1 = G_Landuse[i].buildupFunc[p].coeff[1]
  local c2 = G_Landuse[i].buildupFunc[p].coeff[2]
  if (buildup == 0.0) then
    do return 0.0 end
  end
  if (buildup >= c0) then
    do return G_Landuse[i].buildupFunc[p].maxDays end
  end
  do
    local __sw1 = G_Landuse[i].buildupFunc[p].funcType
    if __sw1 == POWER_BUILDUP then goto case2
    elseif __sw1 == EXPON_BUILDUP then goto case3
    elseif __sw1 == SATUR_BUILDUP then goto case4
    else goto case5 end
    ::case2::
    do
      if ((c1 * c2) == 0.0) then
        do return 0.0 end
      else
        do return R.pow(((buildup / c1)), ((1.0 / c2))) end
      end
    end
    ::case3::
    do
      if ((c0 * c1) == 0.0) then
        do return 0.0 end
      else
        do return ((-(R.log((1.0 - (buildup / c0))))) / c1) end
      end
    end
    ::case4::
    do
      if (c0 == 0.0) then
        do return 0.0 end
      else
        do return ((buildup * c2) / ((c0 - buildup))) end
      end
    end
    ::case5::
    do
      do return 0.0 end
    end
    ::swend1::
  end
end

-- landuse.c:494
F.landuse_getBuildupMass = function(i, p, days)
  local G_Landuse = G.Landuse
  local b = 0.0
  local c0 = G_Landuse[i].buildupFunc[p].coeff[0]
  local c1 = G_Landuse[i].buildupFunc[p].coeff[1]
  local c2 = G_Landuse[i].buildupFunc[p].coeff[2]
  if (days == 0.0) then
    do return 0.0 end
  end
  if (days >= G_Landuse[i].buildupFunc[p].maxDays) then
    do return c0 end
  end
  do
    local __sw1 = G_Landuse[i].buildupFunc[p].funcType
    if __sw1 == POWER_BUILDUP then goto case2
    elseif __sw1 == EXPON_BUILDUP then goto case3
    elseif __sw1 == SATUR_BUILDUP then goto case4
    else goto case5 end
    ::case2::
    do
      b = (c1 * R.pow(days, c2))
      if (b > c0) then
        b = c0
      end
      goto swend1
    end
    ::case3::
    do
      b = (c0 * ((1.0 - m_exp(((-days) * c1)))))
      goto swend1
    end
    ::case4::
    do
      b = ((days * c0) / ((c2 + days)))
      goto swend1
    end
    ::case5::
    do
      b = 0.0
    end
    ::swend1::
  end
  do return b end
end

-- landuse.c:532
F.landuse_getAvgBmpEffic = function(j, p)
  local G_Nobjects, G_Subcatch, G_Landuse = G.Nobjects, G.Subcatch, G.Landuse
  local i = 0
  local r = 0.0
  do
    i = 0
    while (i < G_Nobjects[LANDUSE]) do
      do
        r = (r + (G_Subcatch[j].landFactor[i].fraction * G_Landuse[i].washoffFunc[p].bmpEffic))
      end
      i = i + 1
    end
  end
  do return r end
end

-- landuse.c:553
F.landuse_getWashoffLoad = function(i, p, area, landFactor, runoff, vOutflow)
  local G_Pollut, G_Landuse = G.Pollut, G.Landuse
  local landuseArea = 0.0
  local buildup = 0.0
  local washoffQual = 0.0
  local washoffLoad = 0.0
  local bmpRemoval = 0.0
  buildup = landFactor[i].buildup[p]
  landuseArea = (landFactor[i].fraction * area)
  washoffQual = F.landuse_getWashoffQual(i, p, buildup, runoff, landuseArea)
  washoffLoad = ((((washoffQual * vOutflow) * landuseArea) / area) * G_Pollut[p].mcf)
  if ((G_Landuse[i].buildupFunc[p].funcType ~= NO_BUILDUP) or (buildup > washoffLoad)) then
    washoffLoad = (((((washoffLoad) <= (buildup))) and (washoffLoad) or (buildup)))
    buildup = (buildup - washoffLoad)
    landFactor[i].buildup[p] = buildup
  else
    F.massbal_updateLoadingTotals(BUILDUP_LOAD, p, washoffLoad)
    landFactor[i].buildup[p] = 0.0
  end
  bmpRemoval = (G_Landuse[i].washoffFunc[p].bmpEffic * washoffLoad)
  if (bmpRemoval > 0.0) then
    F.massbal_updateLoadingTotals(BMP_REMOVAL_LOAD, p, bmpRemoval)
    washoffLoad = (washoffLoad - bmpRemoval)
  end
  do return (washoffLoad / G_Pollut[p].mcf) end
end

-- landuse.c:612
F.landuse_getWashoffQual = function(i, p, buildup, runoff, area)
  local G_Landuse = G.Landuse
  local cWashoff = 0.0
  local coeff = G_Landuse[i].washoffFunc[p].coeff
  local expon = G_Landuse[i].washoffFunc[p].expon
  local func = G_Landuse[i].washoffFunc[p].funcType
  if ((func == NO_WASHOFF) or (runoff == 0.0)) then
    do return 0.0 end
  end
  if ((G_Landuse[i].buildupFunc[p].funcType ~= NO_BUILDUP) and (buildup == 0.0)) then
    do return 0.0 end
  end
  if (func == EXPON_WASHOFF) then
    cWashoff = (((coeff * R.pow((runoff * F.UCF(RAINFALL)), expon)) * buildup) / G.Pollut[p].mcf)
    cWashoff = (cWashoff / (runoff * area))
  elseif (func == RATING_WASHOFF) then
    cWashoff = (coeff * R.pow((runoff * area), (expon - 1.0)))
  elseif (func == EMC_WASHOFF) then
    cWashoff = coeff
  end
  do return cWashoff end
end

-- landuse.c:665
F.landuse_getCoPollutLoad = function(p, washoff)
  local G_Pollut = G.Pollut
  local k = 0
  local w = 0.0
  k = G_Pollut[p].coPollut
  if (k >= 0) then
    w = (G_Pollut[p].coFraction * washoff[k])
    F.massbal_updateLoadingTotals(BUILDUP_LOAD, p, (w * G_Pollut[p].mcf))
    do return w end
  end
  do return 0.0 end
end

-- landuse.c:693
F.landuse_getExternalBuildup = function(i, p, buildup, tStep)
  local G_Landuse = G.Landuse
  local maxBuildup = G_Landuse[i].buildupFunc[p].coeff[0]
  local sf = G_Landuse[i].buildupFunc[p].coeff[1]
  local ts = R.D2I(R.floor(G_Landuse[i].buildupFunc[p].coeff[2]))
  local rate = 0.0
  if (G.NewRunoffTime == 0.0) then
    do return 0.0 end
  end
  if (ts >= 0) then
    rate = (sf * F.table_tseriesLookup(G.Tseries[ts], F.getDateTime(G.NewRunoffTime), 0))
  end
  buildup = (buildup + ((rate * tStep) / 86400.0))
  buildup = (((((buildup) <= (maxBuildup))) and (buildup) or (maxBuildup)))
  do return buildup end
end

