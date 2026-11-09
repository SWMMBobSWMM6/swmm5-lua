-- Generated from EPA SWMM 5.2.4 (subcatch.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local ERR_ITEMS <const> = 203
local SUBCATCH <const> = 1
local ERR_NAME <const> = 209
local GAGE <const> = 0
local NODE <const> = 2
local ERR_NUMBER <const> = 211
local SNOWMELT <const> = 13
local LANDAREA <const> = 4
local LENGTH <const> = 3
local ERR_MEMORY <const> = 101
local ERR_KEYWORD <const> = 205
local IMPERV0 <const> = 0
local IMPERV1 <const> = 1
local PERV <const> = 2
local RAINDEPTH <const> = 1
local TO_OUTLET <const> = 0
local TO_IMPERV <const> = 1
local TO_PERV <const> = 2
local LANDUSE <const> = 5
local POLLUT <const> = 4
local ERR_SUBCATCH_OUTLET <const> = 108
local RUNOFF_RAINFALL <const> = 0
local RUNOFF_EVAP <const> = 1
local RUNOFF_INFIL <const> = 2
local RUNOFF_RUNOFF <const> = 3
local SUBCATCH_RAINFALL <const> = 0
local SUBCATCH_SNOWDEPTH <const> = 1
local EVAPRATE <const> = 2
local SUBCATCH_EVAP <const> = 2
local RAINFALL <const> = 0
local SUBCATCH_INFIL <const> = 3
local PREVIOUS <const> = 0
local CURRENT <const> = 1
local FLOW <const> = 10
local SUBCATCH_RUNOFF <const> = 4
local SUBCATCH_GW_FLOW <const> = 5
local SUBCATCH_GW_ELEV <const> = 6
local SUBCATCH_SOIL_MOIST <const> = 7
local SUBCATCH_WASHOFF <const> = 8
local MONTHLY_PATTERN <const> = 0
local _ENV = R.strict

G.MCOEFF = 1.49
G.MEXP = 1.6666667
G.ODETOL = 0.0001
G.Vevap = 0.0
G.Vpevap = 0.0
G.Vinfil = 0.0
G.Vinflow = 0.0
G.Voutflow = 0.0
G.VlidIn = 0.0
G.VlidInfil = 0.0
G.VlidOut = 0.0
G.VlidDrain = 0.0
G.VlidReturn = 0.0
G.theSubarea = nil
G.Dstore = 0.0
G.Alpha = 0.0
G.RunoffRoutingWords = {[0] = S[663], S[2], S[3], (nil)}

-- subcatch.c:119
F.subcatch_readParams = function(j, tok, ntoks)
  local G_Subcatch = G.Subcatch
  local i = 0
  local k = 0
  local m = 0
  local id = nil
  local x = R.fill(9, 0.0)
  if (ntoks < 8) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  id = F.project_findID(SUBCATCH, tok[0])
  if R.peq(id, (nil)) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  k = F.project_findObject(GAGE, tok[1])
  if (k < 0) then
    do return F.error_setInpError(ERR_NAME, tok[1]) end
  end
  x[0] = (k * 1.0)
  m = F.project_findObject(NODE, tok[2])
  x[1] = (m * 1.0)
  m = F.project_findObject(SUBCATCH, tok[2])
  x[2] = (m * 1.0)
  if ((x[1] < 0.0) and (x[2] < 0.0)) then
    do return F.error_setInpError(ERR_NAME, tok[2]) end
  end
  do
    i = 3
    while (i < 8) do
      do
        if ((not (F.getDouble(tok[i], x, i) ~= 0)) or (x[i] < 0.0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[i]) end
        end
      end
      i = i + 1
    end
  end
  x[8] = ((-1) * 1.0)
  if (ntoks > 8) then
    k = F.project_findObject(SNOWMELT, tok[8])
    if (k < 0) then
      do return F.error_setInpError(ERR_NAME, tok[8]) end
    end
    x[8] = (k * 1.0)
  end
  G_Subcatch[j].ID = id
  G_Subcatch[j].gage = R.D2I(x[0])
  G_Subcatch[j].outNode = R.D2I(x[1])
  G_Subcatch[j].outSubcatch = R.D2I(x[2])
  G_Subcatch[j].area = (x[3] / F.UCF(LANDAREA))
  G_Subcatch[j].fracImperv = ((((((x[4]) <= (100.0))) and (x[4]) or (100.0))) / 100.0)
  G_Subcatch[j].width = (x[5] / F.UCF(LENGTH))
  G_Subcatch[j].slope = (x[6] / 100.0)
  G_Subcatch[j].curbLength = x[7]
  G_Subcatch[j].nPervPattern = (-1)
  G_Subcatch[j].dStorePattern = (-1)
  G_Subcatch[j].infilPattern = (-1)
  if (x[8] >= 0.0) then
    if (not (F.snow_createSnowpack(j, R.D2I(x[8])) ~= 0)) then
      do return F.error_setInpError(ERR_MEMORY, S[0]) end
    end
  end
  do return 0 end
end

-- subcatch.c:196
F.subcatch_readSubareaParams = function(tok, ntoks)
  local G_Subcatch = G.Subcatch
  local i = 0
  local j = 0
  local k = 0
  local m = 0
  local x = R.fill(7, 0.0)
  if (ntoks < 7) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  j = F.project_findObject(SUBCATCH, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  do
    i = 0
    while (i < 5) do
      do
        if ((not (F.getDouble(tok[(i + 1)], x, i) ~= 0)) or (x[i] < 0.0)) then
          do return F.error_setInpError(ERR_NAME, tok[(i + 1)]) end
        end
      end
      i = i + 1
    end
  end
  m = F.findmatch(tok[6], G.RunoffRoutingWords)
  if (m < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[6]) end
  end
  x[5] = (m * 1.0)
  x[6] = 1.0
  if (ntoks >= 8) then
    if (((not (F.getDouble(tok[7], x, 6) ~= 0)) or (x[6] < 0.0)) or (x[6] > 100.0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[7]) end
    end
    x[6] = (x[6] / 100.0)
  end
  G_Subcatch[j].subArea[IMPERV0].N = x[0]
  G_Subcatch[j].subArea[IMPERV1].N = x[0]
  G_Subcatch[j].subArea[PERV].N = x[1]
  G_Subcatch[j].subArea[IMPERV0].dStore = 0.0
  G_Subcatch[j].subArea[IMPERV1].dStore = (x[2] / F.UCF(RAINDEPTH))
  G_Subcatch[j].subArea[PERV].dStore = (x[3] / F.UCF(RAINDEPTH))
  G_Subcatch[j].subArea[IMPERV0].fArea = ((G_Subcatch[j].fracImperv * x[4]) / 100.0)
  G_Subcatch[j].subArea[IMPERV1].fArea = (G_Subcatch[j].fracImperv * ((1.0 - (x[4] / 100.0))))
  G_Subcatch[j].subArea[PERV].fArea = ((1.0 - G_Subcatch[j].fracImperv))
  do
    i = IMPERV0
    while (i <= PERV) do
      do
        G_Subcatch[j].subArea[i].routeTo = TO_OUTLET
        G_Subcatch[j].subArea[i].fOutlet = 1.0
      end
      i = i + 1
    end
  end
  k = R.D2I(x[5])
  if ((G_Subcatch[j].fracImperv == 0.0) or (G_Subcatch[j].fracImperv == 1.0)) then
    k = TO_OUTLET
  end
  if ((k == TO_IMPERV) and (G_Subcatch[j].fracImperv ~= 0.0)) then
    G_Subcatch[j].subArea[PERV].routeTo = k
    G_Subcatch[j].subArea[PERV].fOutlet = (1.0 - x[6])
  end
  if (k == TO_PERV) then
    G_Subcatch[j].subArea[IMPERV0].routeTo = k
    G_Subcatch[j].subArea[IMPERV1].routeTo = k
    G_Subcatch[j].subArea[IMPERV0].fOutlet = (1.0 - x[6])
    G_Subcatch[j].subArea[IMPERV1].fOutlet = (1.0 - x[6])
  end
  do return 0 end
end

-- subcatch.c:284
F.subcatch_readLanduseParams = function(tok, ntoks)
  local G_Subcatch = G.Subcatch
  local j = 0
  local k = 0
  local m = 0
  local f = {0.0}
  if (ntoks < 3) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  j = F.project_findObject(SUBCATCH, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  do
    k = 2
    while (k <= ntoks) do
      do
        m = F.project_findObject(LANDUSE, tok[(k - 1)])
        if (m < 0) then
          do return F.error_setInpError(ERR_NAME, tok[(k - 1)]) end
        end
        if ((k + 1) > ntoks) then
          do return F.error_setInpError(ERR_ITEMS, S[0]) end
        end
        if (not (F.getDouble(tok[k], f, 1) ~= 0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[k]) end
        end
        G_Subcatch[j].landFactor[m].fraction = (f[1] / 100.0)
      end
      k = (k + 2)
    end
  end
  do return 0 end
end

-- subcatch.c:324
F.subcatch_readInitBuildup = function(tok, ntoks)
  local G_Subcatch = G.Subcatch
  local j = 0
  local k = 0
  local m = 0
  local x = {0.0}
  if (ntoks < 3) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  j = F.project_findObject(SUBCATCH, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  do
    k = 2
    while (k <= ntoks) do
      do
        m = F.project_findObject(POLLUT, tok[(k - 1)])
        if (m < 0) then
          do return F.error_setInpError(ERR_NAME, tok[(k - 1)]) end
        end
        if ((k + 1) > ntoks) then
          do return F.error_setInpError(ERR_ITEMS, S[0]) end
        end
        if (not (F.getDouble(tok[k], x, 1) ~= 0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[k]) end
        end
        G_Subcatch[j].initBuildup[m] = x[1]
      end
      k = (k + 2)
    end
  end
  do return 0 end
end

-- subcatch.c:364
F.subcatch_validate = function(j)
  local G_Subcatch = G.Subcatch
  local i = 0
  local area = 0.0
  local nonLidArea = G_Subcatch[j].area
  if ((G_Subcatch[j].outNode >= 0) and (G_Subcatch[j].outSubcatch >= 0)) then
    F.report_writeErrorMsg(ERR_SUBCATCH_OUTLET, G_Subcatch[j].ID)
  end
  F.gwater_validate(j)
  nonLidArea = (nonLidArea - G_Subcatch[j].lidArea)
  do
    i = IMPERV0
    while (i <= PERV) do
      do
        if (i == PERV) then
          area = (((1.0 - G_Subcatch[j].fracImperv)) * nonLidArea)
        else
          area = (G_Subcatch[j].fracImperv * nonLidArea)
        end
        G_Subcatch[j].subArea[i].alpha = 0.0
        if ((area > 0.0) and (G_Subcatch[j].subArea[i].N > 0.0)) then
          G_Subcatch[j].subArea[i].alpha = ((((G.MCOEFF * G_Subcatch[j].width) / area) * m_sqrt(G_Subcatch[j].slope)) / G_Subcatch[j].subArea[i].N)
        end
      end
      i = i + 1
    end
  end
  i = G_Subcatch[j].gage
  if (i >= 0) then
    G.Gage[i].isUsed = 1
  end
end

-- subcatch.c:419
F.subcatch_initState = function(j)
  local G_Subcatch = G.Subcatch
  local i = 0
  G_Subcatch[j].rainfall = 0.0
  G_Subcatch[j].oldRunoff = 0.0
  G_Subcatch[j].newRunoff = 0.0
  G_Subcatch[j].oldSnowDepth = 0.0
  G_Subcatch[j].newSnowDepth = 0.0
  G_Subcatch[j].runon = 0.0
  G_Subcatch[j].evapLoss = 0.0
  G_Subcatch[j].infilLoss = 0.0
  if (G_Subcatch[j].infil == j) then
    F.infil_initState(j)
  end
  if (G_Subcatch[j].groundwater ~= nil) then
    F.gwater_initState(j)
  end
  if (G_Subcatch[j].snowpack ~= nil) then
    F.snow_initSnowpack(j)
  end
  do
    i = IMPERV0
    while (i <= PERV) do
      do
        G_Subcatch[j].subArea[i].depth = 0.0
        G_Subcatch[j].subArea[i].inflow = 0.0
        G_Subcatch[j].subArea[i].runoff = 0.0
      end
      i = i + 1
    end
  end
  F.surfqual_initState(j)
end

-- subcatch.c:457
F.subcatch_setOldState = function(j)
  local G_Subcatch, G_Nobjects = G.Subcatch, G.Nobjects
  local i = 0
  G_Subcatch[j].oldRunoff = G_Subcatch[j].newRunoff
  G_Subcatch[j].oldSnowDepth = G_Subcatch[j].newSnowDepth
  do
    i = IMPERV0
    while (i <= PERV) do
      do
        G_Subcatch[j].subArea[i].inflow = 0.0
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[POLLUT]) do
      do
        G_Subcatch[j].oldQual[i] = G_Subcatch[j].newQual[i]
        G_Subcatch[j].newQual[i] = 0.0
      end
      i = i + 1
    end
  end
  F.lid_setOldGroupState(j)
end

-- subcatch.c:481
F.subcatch_getFracPerv = function(j)
  local G_Subcatch = G.Subcatch
  local fracPerv = (1.0 - G_Subcatch[j].fracImperv)
  if (G_Subcatch[j].lidArea > 0.0) then
    fracPerv = ((((fracPerv * ((G_Subcatch[j].area - G_Subcatch[j].lidArea))) + F.lid_getPervArea(j))) / G_Subcatch[j].area)
    fracPerv = (((((fracPerv) <= (1.0))) and (fracPerv) or (1.0)))
  end
  do return fracPerv end
end

-- subcatch.c:502
F.subcatch_getStorage = function(j)
  local G_Subcatch = G.Subcatch
  local i = 0
  local v = 0.0
  do
    i = IMPERV0
    while (i <= PERV) do
      do
        v = (v + (G_Subcatch[j].subArea[i].depth * G_Subcatch[j].subArea[i].fArea))
      end
      i = i + 1
    end
  end
  do return ((v * ((G_Subcatch[j].area - G_Subcatch[j].lidArea))) + F.lid_getStoredVolume(j)) end
end

-- subcatch.c:523
F.subcatch_getRunon = function(j)
  local G_Subcatch, G_Nobjects = G.Subcatch, G.Nobjects
  local k = 0
  local p = 0
  local q = 0.0
  local q1 = 0.0
  local q2 = 0.0
  local pervArea = 0.0
  k = G_Subcatch[j].outSubcatch
  q = G_Subcatch[j].oldRunoff
  if ((k >= 0) and (k ~= j)) then
    F.subcatch_addRunonFlow(k, q)
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          G_Subcatch[k].newQual[p] = (G_Subcatch[k].newQual[p] + ((q * G_Subcatch[j].oldQual[p]) * 28.317))
        end
        p = p + 1
      end
    end
  end
  if (G_Subcatch[j].lidArea > 0.0) then
    F.lid_addDrainRunon(j)
  end
  if ((G_Subcatch[j].fracImperv < 1.0) and (G_Subcatch[j].subArea[IMPERV0].routeTo == TO_PERV)) then
    q1 = (G_Subcatch[j].subArea[IMPERV0].runoff * G_Subcatch[j].subArea[IMPERV0].fArea)
    q2 = (G_Subcatch[j].subArea[IMPERV1].runoff * G_Subcatch[j].subArea[IMPERV1].fArea)
    q = (q1 + q2)
    G_Subcatch[j].subArea[PERV].inflow = (G_Subcatch[j].subArea[PERV].inflow + ((q * ((1.0 - G_Subcatch[j].subArea[IMPERV0].fOutlet))) / G_Subcatch[j].subArea[PERV].fArea))
  end
  if (((G_Subcatch[j].fracImperv > 0.0) and (G_Subcatch[j].subArea[PERV].routeTo == TO_IMPERV)) and (G_Subcatch[j].subArea[IMPERV1].fArea > 0.0)) then
    q = G_Subcatch[j].subArea[PERV].runoff
    G_Subcatch[j].subArea[IMPERV1].inflow = (G_Subcatch[j].subArea[IMPERV1].inflow + (((q * ((1.0 - G_Subcatch[j].subArea[PERV].fOutlet))) * G_Subcatch[j].subArea[PERV].fArea) / G_Subcatch[j].subArea[IMPERV1].fArea))
  end
  if ((G_Subcatch[j].lidArea > 0.0) and (G_Subcatch[j].fracImperv < 1.0)) then
    pervArea = (G_Subcatch[j].subArea[PERV].fArea * ((G_Subcatch[j].area - G_Subcatch[j].lidArea)))
    q = F.lid_getFlowToPerv(j)
    if (pervArea > 0.0) then
      G_Subcatch[j].subArea[PERV].inflow = (G_Subcatch[j].subArea[PERV].inflow + (q / pervArea))
    end
  end
end

-- subcatch.c:600
F.subcatch_addRunonFlow = function(k, q)
  local G_Subcatch = G.Subcatch
  local i = 0
  local nonLidArea = 0.0
  if (G_Subcatch[k].area <= 0.0) then
    do return end
  end
  nonLidArea = (G_Subcatch[k].area - G_Subcatch[k].lidArea)
  if (nonLidArea > 0.0) then
    q = (q / nonLidArea)
  else
    q = (q / G_Subcatch[k].area)
  end
  G_Subcatch[k].runon = (G_Subcatch[k].runon + q)
  do
    i = IMPERV0
    while (i <= PERV) do
      do
        G_Subcatch[k].subArea[i].inflow = (G_Subcatch[k].subArea[i].inflow + q)
      end
      i = i + 1
    end
  end
end

-- subcatch.c:629
F.subcatch_getRunoff = function(j, tStep)
  local G_Subcatch, G_Evap = G.Subcatch, G.Evap
  local i = 0
  local nonLidArea = 0.0
  local area = 0.0
  local netPrecip = R.fill(3, 0.0)
  local vRain = 0.0
  local vRunon = 0.0
  local vOutflow = 0.0
  local runoff = 0.0
  local evapRate = 0.0
  local subAreaRunoff = 0.0
  local vImpervRunoff = 0.0
  local vPervRunoff = 0.0
  G.Vevap = 0.0
  G.Vpevap = 0.0
  G.Vinfil = 0.0
  G.Voutflow = 0.0
  G.VlidIn = 0.0
  G.VlidInfil = 0.0
  G.VlidOut = 0.0
  G.VlidDrain = 0.0
  G.VlidReturn = 0.0
  nonLidArea = (G_Subcatch[j].area - G_Subcatch[j].lidArea)
  vRunon = ((G_Subcatch[j].runon * tStep) * nonLidArea)
  G.Vinflow = (vRunon + (F.subcatch_getDepth(j) * nonLidArea))
  if (nonLidArea == 0.0) then
    vRunon = ((G_Subcatch[j].runon * tStep) * G_Subcatch[j].area)
  end
  F.getNetPrecip(j, netPrecip, tStep)
  if ((G_Evap.dryOnly ~= 0) and (G_Subcatch[j].rainfall > 0.0)) then
    evapRate = 0.0
  else
    evapRate = G_Evap.rate
  end
  F.infil_setInfilFactor(j)
  if (nonLidArea > 0.0) then
    do
      i = IMPERV0
      while (i <= PERV) do
        do
          area = (nonLidArea * G_Subcatch[j].subArea[i].fArea)
          G_Subcatch[j].subArea[i].runoff = F.getSubareaRunoff(j, i, area, netPrecip[i], evapRate, tStep)
          subAreaRunoff = (G_Subcatch[j].subArea[i].runoff * area)
          if (i == PERV) then
            vPervRunoff = (subAreaRunoff * tStep)
          else
            vImpervRunoff = (vImpervRunoff + (subAreaRunoff * tStep))
          end
          runoff = (runoff + subAreaRunoff)
        end
        i = i + 1
      end
    end
  end
  if (G_Subcatch[j].lidArea > 0.0) then
    F.lid_getRunoff(j, tStep)
  end
  if ((not (G.IgnoreGwater ~= 0)) and (G_Subcatch[j].groundwater ~= nil)) then
    F.gwater_getGroundwater(j, G.Vpevap, (G.Vinfil + G.VlidInfil), tStep)
  end
  area = G_Subcatch[j].area
  G_Subcatch[j].evapLoss = ((G.Vevap / tStep) / area)
  G_Subcatch[j].infilLoss = ((((G.Vinfil + G.VlidInfil)) / tStep) / area)
  vOutflow = ((G.Voutflow - G.VlidIn) + G.VlidOut)
  G_Subcatch[j].newRunoff = (vOutflow / tStep)
  vRain = ((G_Subcatch[j].rainfall * tStep) * area)
  F.stats_updateSubcatchStats(j, vRain, vRunon, G.Vevap, (G.Vinfil + G.VlidInfil), vImpervRunoff, vPervRunoff, (vOutflow + G.VlidDrain), (G_Subcatch[j].newRunoff + (G.VlidDrain / tStep)))
  if ((G_Subcatch[j].outNode == (-1)) and (G_Subcatch[j].outSubcatch ~= j)) then
    vOutflow = 0.0
  end
  F.massbal_updateRunoffTotals(RUNOFF_RAINFALL, vRain)
  F.massbal_updateRunoffTotals(RUNOFF_EVAP, G.Vevap)
  F.massbal_updateRunoffTotals(RUNOFF_INFIL, (G.Vinfil + G.VlidInfil))
  F.massbal_updateRunoffTotals(RUNOFF_RUNOFF, vOutflow)
  do return (runoff / area) end
end

-- subcatch.c:758
F.getNetPrecip = function(j, netPrecip, tStep)
  local G_Subcatch = G.Subcatch
  local i = 0
  local k = 0
  local rainfall = {0.0}
  local snowfall = {0.0}
  k = G_Subcatch[j].gage
  if (k >= 0) then
    F.gage_getPrecip(k, rainfall, 1, snowfall, 1)
  end
  G_Subcatch[j].rainfall = (rainfall[1] + snowfall[1])
  if ((G_Subcatch[j].snowpack ~= nil) and (not (G.IgnoreSnowmelt ~= 0))) then
    G_Subcatch[j].newSnowDepth = F.snow_getSnowMelt(j, rainfall[1], snowfall[1], tStep, netPrecip)
  else
    do
      i = IMPERV0
      while (i <= PERV) do
        do
          netPrecip[i] = (rainfall[1] + snowfall[1])
        end
        i = i + 1
      end
    end
  end
end

-- subcatch.c:798
F.subcatch_getDepth = function(j)
  local G_Subcatch = G.Subcatch
  local i = 0
  local fArea = 0.0
  local depth = 0.0
  do
    i = IMPERV0
    while (i <= PERV) do
      do
        fArea = G_Subcatch[j].subArea[i].fArea
        if (fArea > 0.0) then
          depth = (depth + (G_Subcatch[j].subArea[i].depth * fArea))
        end
      end
      i = i + 1
    end
  end
  do return depth end
end

-- subcatch.c:820
F.subcatch_getWtdOutflow = function(j, f)
  local G_Subcatch = G.Subcatch
  if (G_Subcatch[j].area == 0.0) then
    do return 0.0 end
  end
  do return ((((1.0 - f)) * G_Subcatch[j].oldRunoff) + (f * G_Subcatch[j].newRunoff)) end
end

-- subcatch.c:834
F.subcatch_getResults = function(j, f, x)
  local G_Subcatch, G_Nobjects = G.Subcatch, G.Nobjects
  local p = 0
  local k = 0
  local f1 = (1.0 - f)
  local z = 0.0
  local runoff = 0.0
  local gw = nil
  k = G_Subcatch[j].gage
  if (k >= 0) then
    x[SUBCATCH_RAINFALL] = R.f32(G.Gage[k].reportRainfall)
  else
    x[SUBCATCH_RAINFALL] = 0.0
  end
  z = ((((f1 * G_Subcatch[j].oldSnowDepth) + (f * G_Subcatch[j].newSnowDepth))) * F.UCF(RAINDEPTH))
  x[SUBCATCH_SNOWDEPTH] = R.f32(z)
  x[SUBCATCH_EVAP] = R.f32(((G_Subcatch[j].evapLoss * F.UCF(EVAPRATE))))
  x[SUBCATCH_INFIL] = R.f32(((G_Subcatch[j].infilLoss * F.UCF(RAINFALL))))
  runoff = ((f1 * G_Subcatch[j].oldRunoff) + (f * G_Subcatch[j].newRunoff))
  if (G_Subcatch[j].lidArea > 0.0) then
    runoff = (runoff + ((f1 * F.lid_getDrainFlow(j, PREVIOUS)) + (f * F.lid_getDrainFlow(j, CURRENT))))
  end
  if (runoff < (2.31481e-08 * G_Subcatch[j].area)) then
    runoff = 0.0
  end
  x[SUBCATCH_RUNOFF] = R.f32(((runoff * F.UCF(FLOW))))
  gw = G_Subcatch[j].groundwater
  if (gw ~= nil) then
    z = (((((f1 * gw.oldFlow) + (f * gw.newFlow))) * G_Subcatch[j].area) * F.UCF(FLOW))
    x[SUBCATCH_GW_FLOW] = R.f32(z)
    z = (((gw.bottomElev + gw.lowerDepth)) * F.UCF(LENGTH))
    x[SUBCATCH_GW_ELEV] = R.f32(z)
    z = gw.theta
    x[SUBCATCH_SOIL_MOIST] = R.f32(z)
  else
    x[SUBCATCH_GW_FLOW] = 0.0
    x[SUBCATCH_GW_ELEV] = 0.0
    x[SUBCATCH_SOIL_MOIST] = 0.0
  end
  if (not (G.IgnoreQuality ~= 0)) then
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          if (runoff == 0.0) then
            z = 0.0
          else
            z = ((f1 * G_Subcatch[j].oldQual[p]) + (f * G_Subcatch[j].newQual[p]))
          end
          x[(SUBCATCH_WASHOFF + p)] = R.f32(z)
        end
        p = p + 1
      end
    end
  end
end

-- subcatch.c:907
F.getSubareaRunoff = function(j, i, area, precip, evap, tStep)
  local tRunoff = {0.0}
  local surfMoisture = 0.0
  local surfEvap = 0.0
  local infil = 0.0
  local runoff = 0.0
  local subarea = nil
  if (area == 0.0) then
    do return 0.0 end
  end
  subarea = G.Subcatch[j].subArea[i]
  tRunoff[1] = tStep
  surfMoisture = (subarea.depth / tStep)
  surfEvap = (((((surfMoisture) <= (evap))) and (surfMoisture) or (evap)))
  if (i == PERV) then
    infil = F.getSubareaInfil(j, subarea, precip, tStep)
  end
  subarea.inflow = (subarea.inflow + precip)
  surfMoisture = (surfMoisture + subarea.inflow)
  G.Vinflow = (G.Vinflow + ((precip * area) * tStep))
  G.Vevap = (G.Vevap + ((surfEvap * area) * tStep))
  if (i == PERV) then
    G.Vpevap = (G.Vpevap + G.Vevap)
  end
  G.Vinfil = (G.Vinfil + ((infil * area) * tStep))
  G.Alpha = subarea.alpha
  G.Dstore = subarea.dStore
  F.adjustSubareaParams(i, j)
  if ((surfEvap + infil) >= surfMoisture) then
    subarea.depth = 0.0
  else
    subarea.inflow = (subarea.inflow - (surfEvap + infil))
    F.updatePondedDepth(subarea, tRunoff, 1)
  end
  runoff = F.findSubareaRunoff(subarea, tRunoff[1])
  G.Voutflow = (G.Voutflow + (((subarea.fOutlet * runoff) * area) * tStep))
  do return runoff end
end

-- subcatch.c:985
F.getSubareaInfil = function(j, subarea, precip, tStep)
  local G_Subcatch = G.Subcatch
  local infil = 0.0
  infil = F.infil_getInfil(j, tStep, precip, subarea.inflow, subarea.depth)
  if ((not (G.IgnoreGwater ~= 0)) and (G_Subcatch[j].groundwater ~= nil)) then
    infil = (((((infil) <= ((G_Subcatch[j].groundwater.maxInfilVol / tStep)))) and (infil) or ((G_Subcatch[j].groundwater.maxInfilVol / tStep))))
  end
  do return infil end
end

-- subcatch.c:1013
F.findSubareaRunoff = function(subarea, tRunoff)
  local xDepth = (subarea.depth - G.Dstore)
  local runoff = 0.0
  if (xDepth > 1e-10) then
    if (subarea.N > 0.0) then
      runoff = (G.Alpha * (xDepth ^ G.MEXP))
    else
      runoff = (xDepth / tRunoff)
      subarea.depth = G.Dstore
    end
  else
    runoff = 0.0
  end
  do return runoff end
end

-- subcatch.c:1048
F.updatePondedDepth = function(subarea, dt, dt__k)
  local ix = subarea.inflow
  local dx = 0.0
  local tx = dt[dt__k]
  if ((subarea.depth + (ix * tx)) <= G.Dstore) then
    subarea.depth = (subarea.depth + (ix * tx))
  else
    dx = (G.Dstore - subarea.depth)
    if ((dx > 0.0) and (ix > 0.0)) then
      tx = (tx - (dx / ix))
      subarea.depth = G.Dstore
    end
    if ((G.Alpha > 0.0) and (tx > 0.0)) then
      G.theSubarea = subarea
      local __a1 = {[0] = subarea.depth}
      F.odesolve_integrate(__a1, 1, 0.0, tx, G.ODETOL, tx, F.getDdDt)
      subarea.depth = __a1[0]
    else
      if (tx < 0.0) then
        tx = 0.0
      end
      subarea.depth = (subarea.depth + (ix * tx))
    end
  end
  if (subarea.depth < 0.0) then
    subarea.depth = 0.0
  end
  dt[dt__k] = tx
end

-- subcatch.c:1101
F.getDdDt = function(t, d, dddt)
  local ix = G.theSubarea.inflow
  local rx = (d[0] - G.Dstore)
  if (rx < 0.0) then
    rx = 0.0
  else
    rx = (G.Alpha * (rx ^ G.MEXP))
  end
  dddt[0] = (ix - rx)
end

-- subcatch.c:1125
F.adjustSubareaParams = function(i, j)
  local G_Subcatch, G_Pattern = G.Subcatch, G.Pattern
  local p = 0
  local m = 0
  local f = 0.0
  if (i == PERV) then
    p = G_Subcatch[j].dStorePattern
    if ((p >= 0) and (G_Pattern[p].type_ == MONTHLY_PATTERN)) then
      m = (F.datetime_monthOfYear(F.getDateTime(G.OldRunoffTime)) - 1)
      f = G_Pattern[p].factor[m]
      if (f >= 0.0) then
        G.Dstore = (G.Dstore * f)
      end
    end
    p = G_Subcatch[j].nPervPattern
    if ((p >= 0) and (G_Pattern[p].type_ == MONTHLY_PATTERN)) then
      m = (F.datetime_monthOfYear(F.getDateTime(G.OldRunoffTime)) - 1)
      f = G_Pattern[p].factor[m]
      if (f <= 0.0) then
        G.Alpha = 0.0
      else
        G.Alpha = (G.Alpha / f)
      end
    end
  end
end

