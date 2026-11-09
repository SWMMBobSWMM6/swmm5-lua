-- Generated from EPA SWMM 5.2.4 (gage.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local ERR_ITEMS <const> = 203
local GAGE <const> = 0
local ERR_NAME <const> = 209
local RAIN_TSERIES <const> = 0
local RAIN_FILE <const> = 1
local ERR_KEYWORD <const> = 205
local ERR_DATETIME <const> = 213
local TSERIES <const> = 8
local ERR_NUMBER <const> = 211
local ERR_RAIN_GAGE_FORMAT <const> = 157
local ERR_RAIN_GAGE_TSERIES <const> = 158
local ERR_RAIN_GAGE_INTERVAL <const> = 159
local SI <const> = 1
local RAINFALL <const> = 0
local RAINFALL_INTENSITY <const> = 0
local RAINFALL_VOLUME <const> = 1
local CUMULATIVE_RAINFALL <const> = 2
local _ENV = R.strict

G.OneSecond = 1.1574074e-05

-- gage.c:58
F.gage_readParams = function(j, tok, ntoks)
  local G_Gage = G.Gage
  local k = 0
  local err = 0
  local id = nil
  local fname = R.buf(260)
  local staID = R.buf(1025)
  local x = R.fill(7, 0.0)
  if (ntoks < 2) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  id = F.project_findID(GAGE, tok[0])
  if R.peq(id, (nil)) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  x[0] = (-1.0)
  x[1] = 1.0
  x[2] = 3600.0
  x[3] = 1.0
  x[4] = ((-693594) * 1.0)
  x[5] = ((-693594) * 1.0)
  x[6] = 0.0
  R.cset(fname, 0, 0)
  R.cset(staID, 0, 0)
  if (ntoks < 5) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  k = F.findmatch(tok[4], G.GageDataWords)
  if (k == RAIN_TSERIES) then
    err = F.readGageSeriesFormat(tok, ntoks, x)
  elseif (k == RAIN_FILE) then
    if (ntoks < 8) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    F.sstrncpy(fname, tok[5], 259)
    F.sstrncpy(staID, tok[6], 1024)
    err = F.readGageFileFormat(tok, ntoks, x)
  else
    do return F.error_setInpError(ERR_KEYWORD, tok[4]) end
  end
  if (err > 0) then
    do return err end
  end
  G_Gage[j].ID = id
  G_Gage[j].tSeries = R.D2I(x[0])
  G_Gage[j].rainType = R.D2I(x[1])
  G_Gage[j].rainInterval = R.D2I(x[2])
  G_Gage[j].snowFactor = x[3]
  G_Gage[j].rainUnits = R.D2I(x[6])
  if (G_Gage[j].tSeries >= 0) then
    G_Gage[j].dataSource = RAIN_TSERIES
  else
    G_Gage[j].dataSource = RAIN_FILE
  end
  if (G_Gage[j].dataSource == RAIN_FILE) then
    F.sstrncpy(G_Gage[j].fname, F.addAbsolutePath(fname), 259)
    F.sstrncpy(G_Gage[j].staID, staID, 1024)
    G_Gage[j].startFileDate = x[4]
    G_Gage[j].endFileDate = x[5]
  end
  G_Gage[j].unitsFactor = 1.0
  G_Gage[j].coGage = (-1)
  G_Gage[j].isUsed = 0
  do return 0 end
end

-- gage.c:133
F.readGageSeriesFormat = function(tok, ntoks, x)
  local m = 0
  local ts = 0
  local aTime = {0.0}
  if (ntoks < 6) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  m = F.findmatch(tok[1], G.RainTypeWords)
  if (m < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
  end
  x[1] = (m * 1.0)
  if (F.getDouble(tok[2], x, 2) ~= 0) then
    x[2] = R.floor(((x[2] * 3600.0) + 0.5))
  elseif (F.datetime_strToTime(tok[2], aTime, 1) ~= 0) then
    x[2] = R.floor(((aTime[1] * 86400.0) + 0.5))
  else
    do return F.error_setInpError(ERR_DATETIME, tok[2]) end
  end
  if (x[2] <= 0.0) then
    do return F.error_setInpError(ERR_DATETIME, tok[2]) end
  end
  if (not (F.getDouble(tok[3], x, 3) ~= 0)) then
    do return F.error_setInpError(ERR_DATETIME, tok[3]) end
  end
  ts = F.project_findObject(TSERIES, tok[5])
  if (ts < 0) then
    do return F.error_setInpError(ERR_NAME, tok[5]) end
  end
  x[0] = (ts * 1.0)
  F.sstrncpy(tok[2], S[0], 0)
  do return 0 end
end

-- gage.c:168
F.readGageFileFormat = function(tok, ntoks, x)
  local m = 0
  local u = 0
  local aDate = {0.0}
  local aTime = {0.0}
  m = F.findmatch(tok[1], G.RainTypeWords)
  if (m < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
  end
  x[1] = (m * 1.0)
  if (F.getDouble(tok[2], x, 2) ~= 0) then
    x[2] = (x[2] * 3600.0)
  elseif (F.datetime_strToTime(tok[2], aTime, 1) ~= 0) then
    x[2] = R.floor(((aTime[1] * 86400.0) + 0.5))
  else
    do return F.error_setInpError(ERR_DATETIME, tok[2]) end
  end
  if (x[2] <= 0.0) then
    do return F.error_setInpError(ERR_DATETIME, tok[2]) end
  end
  if (not (F.getDouble(tok[3], x, 3) ~= 0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[3]) end
  end
  u = F.findmatch(tok[7], G.RainUnitsWords)
  if (u < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[7]) end
  end
  x[6] = (u * 1.0)
  if ((ntoks > 8) and (tok[8].b[tok[8].o] ~= 42)) then
    if (not (F.datetime_strToDate(tok[8], aDate, 1) ~= 0)) then
      do return F.error_setInpError(ERR_DATETIME, tok[8]) end
    end
    x[4] = R.f32(aDate[1])
  end
  do return 0 end
end

-- gage.c:209
F.gage_validate = function(j)
  local G_Gage, G_Tseries = G.Gage, G.Tseries
  local i = 0
  local k = 0
  local gageInterval = 0
  if (G_Gage[j].dataSource == RAIN_TSERIES) then
    if (not (G_Gage[j].isUsed ~= 0)) then
      do return end
    end
    k = G_Gage[j].tSeries
    do
      i = 0
      while (i < j) do
        do
          if (((G_Gage[i].dataSource == RAIN_TSERIES) and (G_Gage[i].tSeries == k)) and (G_Gage[i].isUsed ~= 0)) then
            G_Gage[j].coGage = i
            if (G_Gage[j].rainType ~= G_Gage[i].rainType) then
              F.report_writeErrorMsg(ERR_RAIN_GAGE_FORMAT, G_Gage[j].ID)
            end
            do return end
          end
        end
        i = i + 1
      end
    end
    if (G_Tseries[k].refersTo >= 0) then
      F.report_writeErrorMsg(ERR_RAIN_GAGE_TSERIES, G_Gage[j].ID)
    end
    gageInterval = R.D2I((R.floor(((G_Tseries[k].dxMin * 86400.0) + 0.5))))
    if ((gageInterval > 0) and (G_Gage[j].rainInterval > gageInterval)) then
      F.report_writeErrorMsg(ERR_RAIN_GAGE_INTERVAL, G_Gage[j].ID)
    end
    if (G_Gage[j].rainInterval < gageInterval) then
      F.report_writeWarningMsg(S[156], G_Gage[j].ID)
    end
    if (G_Gage[j].rainInterval < G.WetStep) then
      F.report_writeWarningMsg(S[157], G_Gage[j].ID)
      G.WetStep = G_Gage[j].rainInterval
    end
  end
end

-- gage.c:270
F.gage_initState = function(j)
  local G_Gage = G.Gage
  G_Gage[j].rainfall = 0.0
  G_Gage[j].apiRainfall = (-10000000000.0)
  G_Gage[j].reportRainfall = 0.0
  if (G.IgnoreRainfall ~= 0) then
    do return end
  end
  if (G_Gage[j].dataSource == RAIN_FILE) then
    G_Gage[j].currentFilePos = G_Gage[j].startFilePos
    if (G.UnitSystem == SI) then
      G_Gage[j].unitsFactor = 25.4
    end
  end
  if (F.getFirstRainfall(j) ~= 0) then
    G_Gage[j].endDate = F.datetime_addSeconds(G_Gage[j].startDate, (G_Gage[j].rainInterval * 1.0))
    if (G_Gage[j].startDate > G.StartDateTime) then
      G_Gage[j].nextDate = G_Gage[j].startDate
      G_Gage[j].nextRainfall = G_Gage[j].rainfall
      G_Gage[j].startDate = G.StartDateTime
      G_Gage[j].endDate = G_Gage[j].nextDate
      G_Gage[j].rainfall = 0.0
    elseif (not (F.getNextRainfall(j) ~= 0)) then
      G_Gage[j].nextDate = ((-693594) * 1.0)
    end
  else
    G_Gage[j].startDate = ((-693594) * 1.0)
  end
  F.initPastRain(j)
end

-- gage.c:323
F.gage_setState = function(j, t)
  local G_Gage = G.Gage
  if (G_Gage[j].isUsed == 0) then
    do return end
  end
  if (G.IgnoreRainfall ~= 0) then
    G_Gage[j].rainfall = 0.0
    do return end
  end
  if (G_Gage[j].coGage >= 0) then
    G_Gage[j].rainfall = G_Gage[G_Gage[j].coGage].rainfall
    do return end
  end
  if (G_Gage[j].apiRainfall ~= (-10000000000.0)) then
    G_Gage[j].rainfall = G_Gage[j].apiRainfall
    do return end
  end
  t = (t + G.OneSecond)
  do
    while true do
      do
        if (G_Gage[j].startDate == ((-693594) * 1.0)) then
          G_Gage[j].rainfall = 0.0
          do return end
        end
        if (t < G_Gage[j].startDate) then
          G_Gage[j].rainfall = 0.0
          do return end
        end
        if (t < G_Gage[j].endDate) then
          do return end
        end
        if (G_Gage[j].nextDate == ((-693594) * 1.0)) then
          G_Gage[j].rainfall = 0.0
          do return end
        end
        if (t < G_Gage[j].nextDate) then
          G_Gage[j].rainfall = 0.0
          do return end
        end
        G_Gage[j].startDate = G_Gage[j].nextDate
        G_Gage[j].endDate = F.datetime_addSeconds(G_Gage[j].startDate, (G_Gage[j].rainInterval * 1.0))
        G_Gage[j].rainfall = G_Gage[j].nextRainfall
        if (not (F.getNextRainfall(j) ~= 0)) then
          G_Gage[j].nextDate = ((-693594) * 1.0)
        end
      end
    end
  end
end

-- gage.c:406
F.initPastRain = function(j)
  local G_Gage = G.Gage
  local i = 0
  do
    i = 0
    while (i <= 48) do
      do
        G_Gage[j].pastRain[i] = 0.0
      end
      i = i + 1
    end
  end
  G_Gage[j].pastInterval = 0
end

-- gage.c:417
F.gage_updatePastRain = function(j, tStep)
  local G_Gage = G.Gage
  local i = 0
  local t = 0
  local r = 0.0
  r = (G_Gage[j].rainfall / 3600.0)
  while (tStep > 0) do
    do
      t = (3600 - G_Gage[j].pastInterval)
      if (tStep > t) then
        G_Gage[j].pastRain[0] = (G_Gage[j].pastRain[0] + ((t * 1.0) * r))
        do
          i = 48
          while (i > 0) do
            do
              G_Gage[j].pastRain[i] = G_Gage[j].pastRain[(i - 1)]
            end
            i = i - 1
          end
        end
        G_Gage[j].pastInterval = 0
        G_Gage[j].pastRain[0] = 0.0
        tStep = (tStep - t)
      else
        G_Gage[j].pastRain[0] = (G_Gage[j].pastRain[0] + ((tStep * 1.0) * r))
        G_Gage[j].pastInterval = (G_Gage[j].pastInterval + tStep)
        tStep = 0
      end
    end
  end
end

-- gage.c:468
F.gage_getPastRain = function(j, n)
  local G_Gage = G.Gage
  local i = 0
  local result = 0.0
  if ((n < 1) or (n > 48)) then
    do return 0.0 end
  end
  do
    i = 1
    while (i <= n) do
      do
        result = (result + G_Gage[j].pastRain[i])
      end
      i = i + 1
    end
  end
  do return result end
end

-- gage.c:486
F.gage_getNextRainDate = function(j, aDate)
  local G_Gage = G.Gage
  if (G_Gage[j].isUsed == 0) then
    do return aDate end
  end
  aDate = (aDate + G.OneSecond)
  if (aDate < G_Gage[j].startDate) then
    do return G_Gage[j].startDate end
  end
  if (aDate < G_Gage[j].endDate) then
    do return G_Gage[j].endDate end
  end
  do return G_Gage[j].nextDate end
end

-- gage.c:503
F.gage_getPrecip = function(j, rainfall, rainfall__k, snowfall, snowfall__k)
  local G_Gage = G.Gage
  rainfall[rainfall__k] = 0.0
  snowfall[snowfall__k] = 0.0
  if ((not (G.IgnoreSnowmelt ~= 0)) and (G.Temp.ta <= G.Snow.snotmp)) then
    snowfall[snowfall__k] = ((G_Gage[j].rainfall * G_Gage[j].snowFactor) / F.UCF(RAINFALL))
  else
    rainfall[rainfall__k] = (G_Gage[j].rainfall / F.UCF(RAINFALL))
  end
  do return ((rainfall[rainfall__k]) + (snowfall[snowfall__k])) end
end

-- gage.c:524
F.gage_setReportRainfall = function(j, reportDate)
  local G_Gage = G.Gage
  local result = 0.0
  if (G_Gage[j].coGage >= 0) then
    G_Gage[j].reportRainfall = G_Gage[G_Gage[j].coGage].reportRainfall
    do return end
  end
  if (G_Gage[j].apiRainfall ~= (-10000000000.0)) then
    G_Gage[j].reportRainfall = G_Gage[j].apiRainfall
    do return end
  end
  reportDate = (reportDate + G.OneSecond)
  if (reportDate < G_Gage[j].endDate) then
    result = G_Gage[j].rainfall
  elseif (reportDate < G_Gage[j].nextDate) then
    result = 0.0
  else
    result = G_Gage[j].nextRainfall
  end
  G_Gage[j].reportRainfall = result
end

-- gage.c:567
F.getFirstRainfall = function(j)
  local G_Gage, G_Frain = G.Gage, G.Frain
  local k = 0
  local vFirst = {0.0}
  local rFirst = {0.0}
  G_Gage[j].startDate = ((-693594) * 1.0)
  G_Gage[j].rainfall = 0.0
  G_Gage[j].rainAccum = 0.0
  if (G_Gage[j].dataSource == RAIN_FILE) then
    if ((G_Frain.file ~= nil) and (G_Gage[j].endFilePos > G_Gage[j].startFilePos)) then
      R.fseek(G_Frain.file, G_Gage[j].startFilePos, 0)
      R.fread1("d", 8, G_Gage[j], "startDate", G_Frain.file)
      R.fread1("f", 4, vFirst, 1, G_Frain.file)
      G_Gage[j].currentFilePos = R.ftell(G_Frain.file)
      G_Gage[j].rainfall = F.convertRainfall(j, vFirst[1])
      do return 1 end
    end
    do return 0 end
  else
    k = G_Gage[j].tSeries
    if (k >= 0) then
      if (F.table_getFirstEntry(G.Tseries[k], G_Gage[j], "startDate", rFirst, 1) ~= 0) then
        G_Gage[j].rainfall = F.convertRainfall(j, rFirst[1])
        do return 1 end
      end
    end
    do return 0 end
  end
end

-- gage.c:624
F.getNextRainfall = function(j)
  local G_Gage, G_Frain, G_Tseries = G.Gage, G.Frain, G.Tseries
  local k = 0
  local vNext = {0.0}
  local rNext = {0.0}
  G_Gage[j].nextRainfall = 0.0
  repeat
    do
      if (G_Gage[j].dataSource == RAIN_FILE) then
        if ((G_Frain.file ~= nil) and (G_Gage[j].currentFilePos < G_Gage[j].endFilePos)) then
          R.fseek(G_Frain.file, G_Gage[j].currentFilePos, 0)
          R.fread1("d", 8, G_Gage[j], "nextDate", G_Frain.file)
          R.fread1("f", 4, vNext, 1, G_Frain.file)
          G_Gage[j].currentFilePos = R.ftell(G_Frain.file)
          rNext[1] = F.convertRainfall(j, vNext[1])
        else
          do return 0 end
        end
      else
        k = G_Gage[j].tSeries
        if (k >= 0) then
          if (not (F.table_getNextEntry(G_Tseries[k], G_Gage[j], "nextDate", rNext, 1) ~= 0)) then
            do return 0 end
          end
          rNext[1] = F.convertRainfall(j, rNext[1])
        else
          do return 0 end
        end
      end
    end
  until not (rNext[1] == 0.0)
  G_Gage[j].nextRainfall = rNext[1]
  do return 1 end
end

-- gage.c:674
F.convertRainfall = function(j, r)
  local G_Gage = G.Gage
  local r1 = 0.0
  do
    local __sw1 = G_Gage[j].rainType
    if __sw1 == RAINFALL_INTENSITY then goto case2
    elseif __sw1 == RAINFALL_VOLUME then goto case3
    elseif __sw1 == CUMULATIVE_RAINFALL then goto case4
    else goto case5 end
    ::case2::
    do
      r1 = r
      goto swend1
    end
    ::case3::
    do
      r1 = ((r / (G_Gage[j].rainInterval * 1.0)) * 3600.0)
      goto swend1
    end
    ::case4::
    do
      if (r < G_Gage[j].rainAccum) then
        r1 = ((r / (G_Gage[j].rainInterval * 1.0)) * 3600.0)
      else
        r1 = ((((r - G_Gage[j].rainAccum)) / (G_Gage[j].rainInterval * 1.0)) * 3600.0)
      end
      G_Gage[j].rainAccum = r
      goto swend1
    end
    ::case5::
    do
      r1 = r
    end
    ::swend1::
  end
  do return ((r1 * G_Gage[j].unitsFactor) * G.Adjust.rainFactor) end
end

