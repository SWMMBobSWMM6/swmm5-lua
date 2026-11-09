-- Generated from EPA SWMM 5.2.4 (snow.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local ERR_ITEMS <const> = 203
local SNOWMELT <const> = 13
local ERR_NAME <const> = 209
local ERR_KEYWORD <const> = 205
local SNOW_REMOVAL <const> = 3
local ERR_NUMBER <const> = 211
local SUBCATCH <const> = 1
local SNOW_PLOWABLE <const> = 0
local SNOW_IMPERV <const> = 1
local SNOW_PERV <const> = 2
local ERR_SNOWPACK_PARAMS <const> = 182
local TEMPERATURE <const> = 7
local RAINFALL <const> = 0
local SI <const> = 1
local RAINDEPTH <const> = 1
local IMPERV0 <const> = 0
local IMPERV1 <const> = 1
local _ENV = R.strict


-- snow.c:68
F.snow_readMeltParams = function(tok, ntoks)
  local G_Snowmelt = G.Snowmelt
  local i = 0
  local j = 0
  local k = 0
  local m = 0
  local n = 0
  local x = R.fill(7, 0.0)
  if (ntoks < 8) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  j = F.project_findObject(SNOWMELT, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  if R.peq(G_Snowmelt[j].ID, (nil)) then
    G_Snowmelt[j].ID = F.project_findID(SNOWMELT, tok[0])
  end
  k = F.findmatch(tok[1], G.SnowmeltWords)
  if (k < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
  end
  n = 7
  if (k == SNOW_REMOVAL) then
    n = 6
  end
  if (ntoks < (n + 2)) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  do
    i = 0
    while (i < 7) do
      do
        x[i] = 0.0
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < n) do
      do
        if (not (F.getDouble(tok[(i + 2)], x, i) ~= 0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[(i + 2)]) end
        end
      end
      i = i + 1
    end
  end
  if (k == SNOW_REMOVAL) then
    x[6] = (-1.0)
    if (ntoks >= 9) then
      m = F.project_findObject(SUBCATCH, tok[8])
      if (m < 0) then
        do return F.error_setInpError(ERR_NAME, tok[8]) end
      end
      x[6] = (m * 1.0)
    end
  end
  F.setMeltParams(j, k, x)
  do return 0 end
end

-- snow.c:126
F.snow_createSnowpack = function(j, k)
  local snowpack = nil
  snowpack = T.TSnowpack()
  if (not (snowpack ~= nil)) then
    do return 0 end
  end
  G.Subcatch[j].snowpack = snowpack
  snowpack.snowmeltIndex = k
  do return 1 end
end

-- snow.c:144
F.snow_initSnowpack = function(j)
  local G_Subcatch, G_Snowmelt = G.Subcatch, G.Snowmelt
  local i = 0
  local k = 0
  local f = 0.0
  local snowDepth = 0.0
  local snowpack = nil
  snowpack = G_Subcatch[j].snowpack
  if (snowpack == (nil)) then
    do return end
  end
  k = G_Subcatch[j].snowpack.snowmeltIndex
  f = G_Snowmelt[k].snn
  snowpack.fArea[SNOW_PLOWABLE] = (f * G_Subcatch[j].fracImperv)
  snowpack.fArea[SNOW_IMPERV] = (((1.0 - f)) * G_Subcatch[j].fracImperv)
  snowpack.fArea[SNOW_PERV] = (1.0 - G_Subcatch[j].fracImperv)
  do
    i = SNOW_PLOWABLE
    while (i <= SNOW_PERV) do
      do
        if (snowpack.fArea[i] > 0.0) then
          snowpack.wsnow[i] = G_Snowmelt[k].wsnow[i]
          snowpack.fw[i] = G_Snowmelt[k].fwnow[i]
        else
          snowpack.wsnow[i] = 0.0
          snowpack.fw[i] = 0.0
        end
        snowpack.coldc[i] = 0.0
        snowpack.ati[i] = G_Snowmelt[k].tbase[i]
        snowpack.awe[i] = 1.0
        snowDepth = (snowDepth + (snowpack.wsnow[i] * snowpack.fArea[i]))
      end
      i = i + 1
    end
  end
  G_Subcatch[j].newSnowDepth = snowDepth
end

-- snow.c:193
F.snow_initSnowmelt = function(j)
  local G_Snowmelt = G.Snowmelt
  local i = 0
  local k = 0
  do
    i = 0
    while (i < 3) do
      do
        G_Snowmelt[j].snn = 0.0
        G_Snowmelt[j].si[i] = 0.0
        G_Snowmelt[j].dhmin[i] = 0.0
        G_Snowmelt[j].dhmax[i] = 0.0
        G_Snowmelt[j].tbase[i] = 0.0
        G_Snowmelt[j].fwfrac[i] = 0.0
        G_Snowmelt[j].wsnow[i] = 0.0
        G_Snowmelt[j].fwnow[i] = 0.0
        G_Snowmelt[j].weplow = 1000000.0
        do
          k = 0
          while (k < 5) do
            do
              G_Snowmelt[j].sfrac[k] = 0.0
            end
            k = k + 1
          end
        end
        G_Snowmelt[j].toSubcatch = (-1)
      end
      i = i + 1
    end
  end
end

-- snow.c:219
F.snow_validateSnowmelt = function(j)
  local G_Snowmelt = G.Snowmelt
  local k = 0
  local err = 0
  local sum = 0.0
  do
    k = SNOW_PLOWABLE
    while (k <= SNOW_PERV) do
      do
        if (G_Snowmelt[j].dhmin[k] > G_Snowmelt[j].dhmax[k]) then
          err = 1
        end
        if ((G_Snowmelt[j].fwfrac[k] < 0.0) or (G_Snowmelt[j].fwfrac[k] > 1.0)) then
          err = 1
        end
      end
      k = k + 1
    end
  end
  if ((G_Snowmelt[j].snn < 0.0) or (G_Snowmelt[j].snn > 1.0)) then
    err = 1
  end
  do
    k = 0
    while (k < 5) do
      do
        sum = (sum + G_Snowmelt[j].sfrac[k])
      end
      k = k + 1
    end
  end
  if (sum > 1.01) then
    err = 1
  end
  if (err ~= 0) then
    F.report_writeErrorMsg(ERR_SNOWPACK_PARAMS, G_Snowmelt[j].ID)
  end
end

-- snow.c:251
F.snow_getState = function(i, j, x)
  local snowpack = G.Subcatch[i].snowpack
  if (snowpack == (nil)) then
    do return end
  end
  x[0] = snowpack.wsnow[j]
  x[1] = snowpack.fw[j]
  x[2] = snowpack.coldc[j]
  x[3] = snowpack.ati[j]
  x[4] = snowpack.awe[j]
end

-- snow.c:270
F.snow_setState = function(i, j, x)
  local snowpack = G.Subcatch[i].snowpack
  if (snowpack == (nil)) then
    do return end
  end
  snowpack.wsnow[j] = x[0]
  snowpack.fw[j] = x[1]
  snowpack.coldc[j] = x[2]
  snowpack.ati[j] = x[3]
  snowpack.awe[j] = x[4]
end

-- snow.c:290
F.setMeltParams = function(j, k, x)
  local G_Snowmelt = G.Snowmelt
  local i = 0
  if ((k >= SNOW_PLOWABLE) and (k <= SNOW_PERV)) then
    G_Snowmelt[j].dhmin[k] = ((x[0] * F.UCF(TEMPERATURE)) / F.UCF(RAINFALL))
    G_Snowmelt[j].dhmax[k] = ((x[1] * F.UCF(TEMPERATURE)) / F.UCF(RAINFALL))
    G_Snowmelt[j].tbase[k] = x[2]
    if (G.UnitSystem == SI) then
      G_Snowmelt[j].tbase[k] = ((((9.0 / 5.0)) * G_Snowmelt[j].tbase[k]) + 32.0)
    end
    G_Snowmelt[j].fwfrac[k] = x[3]
    G_Snowmelt[j].wsnow[k] = (x[4] / F.UCF(RAINDEPTH))
    x[5] = (((((x[5]) <= (((x[3] * x[4]))))) and (x[5]) or (((x[3] * x[4])))))
    G_Snowmelt[j].fwnow[k] = (x[5] / F.UCF(RAINDEPTH))
    if (k == SNOW_PLOWABLE) then
      G_Snowmelt[j].snn = x[6]
    else
      G_Snowmelt[j].si[k] = (x[6] / F.UCF(RAINDEPTH))
    end
  elseif (k == SNOW_REMOVAL) then
    G_Snowmelt[j].weplow = (x[0] / F.UCF(RAINDEPTH))
    do
      i = 0
      while (i <= 4) do
        do
          G_Snowmelt[j].sfrac[i] = x[(i + 1)]
        end
        i = i + 1
      end
    end
    if (x[6] >= 0.0) then
      G_Snowmelt[j].toSubcatch = R.D2I(((x[6] + 0.01)))
    else
      G_Snowmelt[j].toSubcatch = (-1)
    end
  end
end

-- snow.c:341
F.snow_setMeltCoeffs = function(j, s)
  local G_Snowmelt = G.Snowmelt
  local k = 0
  do
    k = SNOW_PLOWABLE
    while (k <= SNOW_PERV) do
      do
        G_Snowmelt[j].dhm[k] = (0.5 * (((G_Snowmelt[j].dhmax[k] * ((1.0 + s))) + (G_Snowmelt[j].dhmin[k] * ((1.0 - s))))))
      end
      k = k + 1
    end
  end
end

-- snow.c:360
F.snow_plowSnow = function(j, tStep)
  local G_Subcatch, G_Snowmelt, G_Snow = G.Subcatch, G.Snowmelt, G.Snow
  local i = 0
  local k = 0
  local m = 0
  local rainfall = {0.0}
  local snowfall = {0.0}
  local exc = 0.0
  local f = 0.0
  local sfracTotal = 0.0
  local snowpack = nil
  snowpack = G_Subcatch[j].snowpack
  if (not (snowpack ~= nil)) then
    do return end
  end
  F.gage_getPrecip(G_Subcatch[j].gage, rainfall, 1, snowfall, 1)
  do
    i = SNOW_PLOWABLE
    while (i <= SNOW_PERV) do
      do
        if (snowpack.fArea[i] > 0.0) then
          snowpack.wsnow[i] = (snowpack.wsnow[i] + (snowfall[1] * tStep))
          snowpack.imelt[i] = 0.0
        end
      end
      i = i + 1
    end
  end
  if (snowpack.fArea[SNOW_PLOWABLE] > 0.0) then
    k = snowpack.snowmeltIndex
    if (snowpack.wsnow[SNOW_PLOWABLE] >= G_Snowmelt[k].weplow) then
      exc = snowpack.wsnow[SNOW_PLOWABLE]
      f = (snowpack.fArea[SNOW_PLOWABLE] * ((G_Subcatch[j].area - G_Subcatch[j].lidArea)))
      G_Snow.removed = (G_Snow.removed + ((G_Snowmelt[k].sfrac[0] * exc) * f))
      sfracTotal = G_Snowmelt[k].sfrac[0]
      if (snowpack.fArea[SNOW_IMPERV] > 0.0) then
        f = (snowpack.fArea[SNOW_PLOWABLE] / snowpack.fArea[SNOW_IMPERV])
        snowpack.wsnow[SNOW_IMPERV] = (snowpack.wsnow[SNOW_IMPERV] + ((G_Snowmelt[k].sfrac[1] * exc) * f))
        sfracTotal = (sfracTotal + G_Snowmelt[k].sfrac[1])
      end
      if (snowpack.fArea[SNOW_PERV] > 0.0) then
        f = (snowpack.fArea[SNOW_PLOWABLE] / snowpack.fArea[SNOW_PERV])
        snowpack.wsnow[SNOW_PERV] = (snowpack.wsnow[SNOW_PERV] + ((G_Snowmelt[k].sfrac[2] * exc) * f))
        sfracTotal = (sfracTotal + G_Snowmelt[k].sfrac[2])
      end
      snowpack.imelt[SNOW_PLOWABLE] = ((G_Snowmelt[k].sfrac[3] * exc) / tStep)
      sfracTotal = (sfracTotal + G_Snowmelt[k].sfrac[3])
      if (G_Snowmelt[k].sfrac[4] > 0.0) then
        m = G_Snowmelt[k].toSubcatch
        if (G_Subcatch[m].snowpack ~= nil) then
          f = G_Subcatch[m].snowpack.fArea[SNOW_PERV]
        else
          f = 0.0
        end
        if (f > 0.0) then
          f = (snowpack.fArea[SNOW_PLOWABLE] / f)
          G_Subcatch[m].snowpack.wsnow[SNOW_PERV] = (G_Subcatch[m].snowpack.wsnow[SNOW_PERV] + ((G_Snowmelt[k].sfrac[4] * exc) * f))
          sfracTotal = (sfracTotal + G_Snowmelt[k].sfrac[4])
        end
      end
      sfracTotal = (((((sfracTotal) <= (1.0))) and (sfracTotal) or (1.0)))
      snowpack.wsnow[SNOW_PLOWABLE] = (exc * ((1.0 - sfracTotal)))
    end
  end
end

-- snow.c:458
F.snow_getSnowMelt = function(j, rainfall, snowfall, tStep, netPrecip)
  local G_Subcatch = G.Subcatch
  local i = 0
  local rmelt = 0.0
  local smelt = 0.0
  local asc = 0.0
  local snowDepth = 0.0
  local impervPrecip = 0.0
  local snowpack = nil
  snowpack = G_Subcatch[j].snowpack
  rmelt = F.getRainmelt(rainfall)
  do
    i = SNOW_PLOWABLE
    while (i <= SNOW_PERV) do
      do
        if (snowpack.wsnow[i] <= (0.001 / 12.0)) then
          asc = 0.0
          smelt = 0.0
          snowpack.imelt[i] = (snowpack.imelt[i] + (((snowpack.wsnow[i] + snowpack.fw[i])) / tStep))
          snowpack.wsnow[i] = 0.0
          snowpack.fw[i] = 0.0
          snowpack.coldc[i] = 0.0
        else
          asc = F.getArealDepletion(snowpack, i, snowfall, tStep)
          smelt = F.meltSnowpack(snowpack, i, rmelt, asc, snowfall, tStep)
          smelt = F.routeSnowmelt(snowpack, i, smelt, asc, rainfall, tStep)
        end
        netPrecip[i] = ((smelt + snowpack.imelt[i]) + (rainfall * ((1.0 - asc))))
        snowDepth = (snowDepth + (snowpack.wsnow[i] * snowpack.fArea[i]))
      end
      i = i + 1
    end
  end
  if (G_Subcatch[j].fracImperv > 0.0) then
    impervPrecip = ((((netPrecip[SNOW_PLOWABLE] * snowpack.fArea[SNOW_PLOWABLE]) + (netPrecip[SNOW_IMPERV] * snowpack.fArea[SNOW_IMPERV]))) / G_Subcatch[j].fracImperv)
    netPrecip[IMPERV0] = impervPrecip
    netPrecip[IMPERV1] = impervPrecip
  end
  do return snowDepth end
end

-- snow.c:532
F.snow_getSnowCover = function(j)
  local G_Subcatch = G.Subcatch
  local i = 0
  local snowCover = 0.0
  local snowpack = nil
  snowpack = G_Subcatch[j].snowpack
  if (not (snowpack ~= nil)) then
    do return 0.0 end
  end
  do
    i = SNOW_PLOWABLE
    while (i <= SNOW_PERV) do
      do
        snowCover = (snowCover + (((snowpack.wsnow[i] + snowpack.fw[i])) * snowpack.fArea[i]))
      end
      i = i + 1
    end
  end
  do return (snowCover * ((G_Subcatch[j].area - G_Subcatch[j].lidArea))) end
end

-- snow.c:555
F.getArealDepletion = function(snowpack, i, snowfall, tStep)
  local k = 0
  local asc = 0.0
  local si = 0.0
  local awesi = 0.0
  local awe = 0.0
  local sba = 0.0
  local sbws = 0.0
  if (i == SNOW_PLOWABLE) then
    do return 1.0 end
  end
  k = snowpack.snowmeltIndex
  si = G.Snowmelt[k].si[i]
  if ((si == 0.0) or (snowpack.wsnow[i] >= si)) then
    snowpack.awe[i] = 1.0
    do return 1.0 end
  end
  if (snowpack.wsnow[i] == 0.0) then
    snowpack.awe[i] = 1.0
    do return 0.0 end
  end
  if (snowfall > 0.0) then
    awe = (((snowpack.wsnow[i] - (snowfall * tStep))) / si)
    awe = (((((awe) >= (0.0))) and (awe) or (0.0)))
    sba = F.getArealSnowCover(i, awe)
    sbws = (awe + ((((0.75 * snowfall) * tStep)) / si))
    sbws = (((((sbws) <= (1.0))) and (sbws) or (1.0)))
    snowpack.awe[i] = awe
    snowpack.sba[i] = sba
    snowpack.sbws[i] = sbws
    do return 1.0 end
  else
    awe = snowpack.awe[i]
    sba = snowpack.sba[i]
    sbws = snowpack.sbws[i]
    awesi = (snowpack.wsnow[i] / si)
    if (awesi < snowpack.awe[i]) then
      snowpack.awe[i] = 1.0
      asc = F.getArealSnowCover(i, awesi)
    elseif (awesi >= snowpack.sbws[i]) then
      asc = 1.0
    else
      asc = (sba + ((((1.0 - sba)) / ((sbws - awe))) * ((awesi - awe))))
    end
    do return asc end
  end
end

-- snow.c:636
F.getArealSnowCover = function(i, awesi)
  local G_Snow = G.Snow
  local k = 0
  local m = 0
  local asc1 = 0.0
  local asc2 = 0.0
  if (i == SNOW_IMPERV) then
    k = 0
  elseif (i == SNOW_PERV) then
    k = 1
  else
    do return 1.0 end
  end
  if (awesi <= 0.0) then
    do return 0.0 end
  end
  if (awesi >= 0.9999) then
    do return 1.0 end
  end
  m = R.D2I((((awesi * 10.0) + 1e-05)))
  asc1 = G_Snow.adc[k][m]
  if (m >= 9) then
    asc2 = 1.0
  else
    asc2 = G_Snow.adc[k][(m + 1)]
  end
  do return (asc1 + ((((asc2 - asc1)) / 0.1) * ((awesi - (0.1 * R.f32((m * 1.0))))))) end
end

-- snow.c:674
F.meltSnowpack = function(snowpack, i, rmelt, asc, snowfall, tStep)
  local G_Temp, G_Snowmelt = G.Temp, G.Snowmelt
  local k = 0
  local smelt = 0.0
  local ccFactor = 0.0
  k = snowpack.snowmeltIndex
  if (rmelt > 0.0) then
    smelt = rmelt
  elseif (G_Temp.ta >= G_Snowmelt[k].tbase[i]) then
    smelt = (G_Snowmelt[k].dhm[i] * ((G_Temp.ta - G_Snowmelt[k].tbase[i])))
  else
    F.updateColdContent(snowpack, i, asc, snowfall, tStep)
    do return 0.0 end
  end
  smelt = (smelt * asc)
  ccFactor = ((tStep * G.Snow.rnm) * asc)
  smelt = F.reduceColdContent(snowpack, i, smelt, ccFactor)
  snowpack.ati[i] = G_Snowmelt[k].tbase[i]
  do return smelt end
end

-- snow.c:720
F.getRainmelt = function(rainfall)
  local G_Temp = G.Temp
  local uadj = 0.0
  local t1 = 0.0
  local t2 = 0.0
  local t3 = 0.0
  local smelt = 0.0
  rainfall = (rainfall * 43200.0)
  if (rainfall > 0.02) then
    uadj = (0.006 * G.Wind.ws)
    t1 = (G_Temp.ta - 32.0)
    t2 = ((7.5 * G_Temp.gamma) * uadj)
    t3 = ((8.5 * uadj) * ((G_Temp.ea - 0.18)))
    smelt = ((t1 * (((0.001167 + t2) + (0.007 * rainfall)))) + t3)
    do return (smelt / 43200.0) end
  else
    do return 0.0 end
  end
end

-- snow.c:746
F.updateColdContent = function(snowpack, i, asc, snowfall, tStep)
  local G_Temp, G_Snow, G_Snowmelt = G.Temp, G.Snow, G.Snowmelt
  local k = 0
  local ati = 0.0
  local cc = 0.0
  local ccMax = 0.0
  local tipm = 0.0
  ati = snowpack.ati[i]
  cc = snowpack.coldc[i]
  if ((snowfall * 43200.0) > 0.02) then
    ati = G_Temp.ta
  else
    tipm = (1.0 - R.pow((1.0 - G_Snow.tipm), (tStep / ((6.0 * 3600.0)))))
    ati = (ati + (tipm * ((G_Temp.ta - ati))))
  end
  k = snowpack.snowmeltIndex
  ati = (((((ati) <= (G_Snowmelt[k].tbase[i]))) and (ati) or (G_Snowmelt[k].tbase[i])))
  cc = (cc + ((((G_Snow.rnm * G_Snowmelt[k].dhm[i]) * ((ati - G_Temp.ta))) * tStep) * asc))
  cc = (((((cc) >= (0.0))) and (cc) or (0.0)))
  ccMax = (((snowpack.wsnow[i] * 0.007) / 12.0) * ((G_Snowmelt[k].tbase[i] - ati)))
  cc = (((((cc) <= (ccMax))) and (cc) or (ccMax)))
  snowpack.coldc[i] = cc
  snowpack.ati[i] = ati
end

-- snow.c:799
F.reduceColdContent = function(snowpack, i, smelt, ccFactor)
  local cc = 0.0
  cc = snowpack.coldc[i]
  if ((smelt * ccFactor) > cc) then
    smelt = (smelt - (cc / ccFactor))
    cc = 0.0
  else
    cc = (cc - (smelt * ccFactor))
    smelt = 0.0
  end
  snowpack.coldc[i] = cc
  do return smelt end
end

-- snow.c:828
F.routeSnowmelt = function(snowpack, i, smelt, asc, rainfall, tStep)
  local k = 0
  local vmelt = 0.0
  k = snowpack.snowmeltIndex
  vmelt = (smelt * tStep)
  vmelt = (((((vmelt) <= (snowpack.wsnow[i]))) and (vmelt) or (snowpack.wsnow[i])))
  snowpack.wsnow[i] = (snowpack.wsnow[i] - vmelt)
  snowpack.fw[i] = (snowpack.fw[i] + (vmelt + ((rainfall * tStep) * asc)))
  vmelt = (snowpack.fw[i] - (G.Snowmelt[k].fwfrac[i] * snowpack.wsnow[i]))
  vmelt = (((((vmelt) >= (0.0))) and (vmelt) or (0.0)))
  snowpack.fw[i] = (snowpack.fw[i] - vmelt)
  do return (vmelt / tStep) end
end

