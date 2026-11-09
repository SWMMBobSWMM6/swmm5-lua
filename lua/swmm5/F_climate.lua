-- Generated from EPA SWMM 5.2.4 (climate.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local ERR_KEYWORD <const> = 205
local ERR_ITEMS <const> = 203
local TSERIES <const> = 8
local ERR_NAME <const> = 209
local TSERIES_TEMP <const> = 1
local FILE_TEMP <const> = 2
local USE_FILE <const> = 2
local ERR_DATETIME <const> = 213
local DEG_F <const> = 2
local SI <const> = 1
local DEG_C <const> = 1
local FILE_WIND <const> = 1
local MONTHLY_WIND <const> = 0
local ERR_NUMBER <const> = 211
local LENGTH <const> = 3
local RECOVERY <const> = 5
local TIMEPATTERN <const> = 6
local DRYONLY <const> = 6
local TEMPERATURE_EVAP <const> = 3
local CONSTANT_EVAP <const> = 0
local MONTHLY_EVAP <const> = 1
local TIMESERIES_EVAP <const> = 2
local FILE_EVAP <const> = 4
local SUBCATCH <const> = 1
local NO_FILE <const> = 0
local ERR_NO_CLIMATE_FILE <const> = 336
local ERR_SNOWMELT_PARAMS <const> = 181
local EVAPRATE <const> = 2
local ERR_CLIMATE_FILE_OPEN <const> = 337
local TMIN <const> = 0
local TMAX <const> = 1
local EVAP <const> = 2
local WIND <const> = 3
local UNKNOWN_FORMAT <const> = 0
local ERR_CLIMATE_FILE_READ <const> = 338
local ERR_CLIMATE_END_OF_FILE <const> = 339
local NO_TEMP <const> = 0
local SNOWMELT <const> = 13
local MONTHLY_PATTERN <const> = 0
local WINDSPEED <const> = 6
local US <const> = 0
local TD3200 <const> = 3
local DLY0204 <const> = 4
local USER_PREPARED <const> = 1
local GHCND <const> = 2
local WDMV <const> = 0
local AWND <const> = 1
local DEG_C10 <const> = 0
local _ENV = R.strict

G.MAXCLIMATEVARS = 4
G.MAXDAYSPERMONTH = 32
G.ClimateVarWords = {[0] = S[22], S[23], S[7], S[24], S[25], (nil)}
G.TempUnitsWords = {[0] = S[653], S[654], S[655], (nil)}
G.Tmin = 0.0
G.Tmax = 0.0
G.Trng = 0.0
G.Trng1 = 0.0
G.Tave = 0.0
G.Hrsr = 0.0
G.Hrss = 0.0
G.Hrday = 0.0
G.Dhrdy = 0.0
G.Dydif = 0.0
G.LastDay = 0.0
G.Tma = T.TMovAve()
G.NextEvapDate = 0.0
G.NextEvapRate = 0.0
G.FileFormat = 0
G.FileYear = 0
G.FileMonth = 0
G.FileDay = 0
G.FileLastDay = 0
G.FileElapsedDays = 0
G.FileValue = R.fill(4, 0.0)
G.FileData = R.grid(4, 32, 0.0)
G.FileLine = R.buf(1025)
G.FileFieldPos = R.fill(4, 0)
G.FileDateFieldPos = 0
G.FileWindType = 0
G.FileTempUnits = 0

-- climate.c:153
F.climate_readParams = function(tok, ntoks)
  local G_Temp, G_Fclimate, G_Wind, G_Snow = G.Temp, G.Fclimate, G.Wind, G.Snow
  local i = 0
  local j = 0
  local k = 0
  local x = R.fill(6, 0.0)
  local y = {0.0}
  local aDate = {0.0}
  local fname = R.buf(260)
  k = F.findmatch(tok[0], G.TempKeyWords)
  if (k < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[0]) end
  end
  do
    local __sw1 = k
    if __sw1 == 0 then goto case2
    elseif __sw1 == 1 then goto case3
    elseif __sw1 == 2 then goto case4
    elseif __sw1 == 3 then goto case5
    elseif __sw1 == 4 then goto case6
    else goto swend1 end
    ::case2::
    do
      if (ntoks < 2) then
        do return F.error_setInpError(ERR_ITEMS, S[0]) end
      end
      i = F.project_findObject(TSERIES, tok[1])
      if (i < 0) then
        do return F.error_setInpError(ERR_NAME, tok[1]) end
      end
      G_Temp.dataSource = TSERIES_TEMP
      G_Temp.tSeries = i
      G.Tseries[i].refersTo = TSERIES_TEMP
      goto swend1
    end
    ::case3::
    do
      if (ntoks < 2) then
        do return F.error_setInpError(ERR_ITEMS, S[0]) end
      end
      G_Temp.dataSource = FILE_TEMP
      G_Fclimate.mode = USE_FILE
      F.sstrncpy(fname, tok[1], 259)
      F.sstrncpy(G_Fclimate.name, F.addAbsolutePath(fname), 259)
      G_Temp.fileStartDate = ((-693594) * 1.0)
      if (ntoks > 2) then
        if (tok[2].b[tok[2].o] ~= 42) then
          if (not (F.datetime_strToDate(tok[2], aDate, 1) ~= 0)) then
            do return F.error_setInpError(ERR_DATETIME, tok[2]) end
          end
          G_Temp.fileStartDate = aDate[1]
        end
      end
      G.FileTempUnits = DEG_F
      if (G.UnitSystem == SI) then
        G.FileTempUnits = DEG_C
      end
      if (ntoks > 3) then
        i = F.findmatch(tok[3], G.TempUnitsWords)
        if (i < 0) then
          do return F.error_setInpError(ERR_KEYWORD, tok[3]) end
        end
        G.FileTempUnits = i
      end
      goto swend1
    end
    ::case4::
    do
      if (F.strcomp(tok[1], S[1]) ~= 0) then
        G_Wind.type_ = FILE_WIND
      else
        if (ntoks < 14) then
          do return F.error_setInpError(ERR_ITEMS, S[0]) end
        end
        G_Wind.type_ = MONTHLY_WIND
        do
          i = 0
          while (i < 12) do
            do
              if (not (F.getDouble(tok[(i + 2)], y, 1) ~= 0)) then
                do return F.error_setInpError(ERR_NUMBER, tok[(i + 2)]) end
              end
              G_Wind.aws[i] = y[1]
            end
            i = i + 1
          end
        end
      end
      goto swend1
    end
    ::case5::
    do
      if (ntoks < 7) then
        do return F.error_setInpError(ERR_ITEMS, S[0]) end
      end
      do
        i = 1
        while (i < 7) do
          do
            if (not (F.getDouble(tok[i], x, (i - 1)) ~= 0)) then
              do return F.error_setInpError(ERR_NUMBER, tok[i]) end
            end
          end
          i = i + 1
        end
      end
      if (G.UnitSystem == SI) then
        x[0] = (((9.0 / 5.0) * x[0]) + 32.0)
      end
      G_Snow.snotmp = x[0]
      G_Snow.tipm = x[1]
      G_Snow.rnm = x[2]
      G_Temp.elev = (x[3] / F.UCF(LENGTH))
      G_Temp.anglat = x[4]
      G_Temp.dtlong = (x[5] / 60.0)
      goto swend1
    end
    ::case6::
    do
      if (ntoks < 12) then
        do return F.error_setInpError(ERR_ITEMS, S[0]) end
      end
      if (F.match(tok[1], S[2]) ~= 0) then
        i = 0
      elseif (F.match(tok[1], S[3]) ~= 0) then
        i = 1
      else
        do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
      end
      do
        j = 0
        while (j < 10) do
          do
            if (((not (F.getDouble(tok[(j + 2)], y, 1) ~= 0)) or (y[1] < 0.0)) or (y[1] > 1.0)) then
              do return F.error_setInpError(ERR_NUMBER, tok[(j + 2)]) end
            end
            G_Snow.adc[i][j] = y[1]
          end
          j = j + 1
        end
      end
      goto swend1
    end
    ::swend1::
  end
  do return 0 end
end

-- climate.c:285
F.climate_readEvapParams = function(tok, ntoks)
  local G_Evap = G.Evap
  local i = 0
  local k = 0
  local x = {0.0}
  k = F.findmatch(tok[0], G.EvapTypeWords)
  if (k < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[0]) end
  end
  if (k == RECOVERY) then
    if (ntoks < 2) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    i = F.project_findObject(TIMEPATTERN, tok[1])
    if (i < 0) then
      do return F.error_setInpError(ERR_NAME, tok[1]) end
    end
    G_Evap.recoveryPattern = i
    do return 0 end
  end
  if (k == DRYONLY) then
    if (ntoks < 2) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    if (F.strcomp(tok[1], S[4]) ~= 0) then
      G_Evap.dryOnly = 0
    elseif (F.strcomp(tok[1], S[5]) ~= 0) then
      G_Evap.dryOnly = 1
    else
      do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
    end
    do return 0 end
  end
  G_Evap.type_ = k
  if ((k ~= TEMPERATURE_EVAP) and (ntoks < 2)) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  do
    local __sw1 = k
    if __sw1 == CONSTANT_EVAP then goto case2
    elseif __sw1 == MONTHLY_EVAP then goto case3
    elseif __sw1 == TIMESERIES_EVAP then goto case4
    elseif __sw1 == FILE_EVAP then goto case5
    else goto swend1 end
    ::case2::
    do
      if (not (F.getDouble(tok[1], x, 1) ~= 0)) then
        do return F.error_setInpError(ERR_NUMBER, tok[1]) end
      end
      do
        i = 0
        while (i < 12) do
          do
            G_Evap.monthlyEvap[i] = x[1]
          end
          i = i + 1
        end
      end
      goto swend1
    end
    ::case3::
    do
      if (ntoks < 13) then
        do return F.error_setInpError(ERR_ITEMS, S[0]) end
      end
      do
        i = 0
        while (i < 12) do
          do
            if (not (F.getDouble(tok[(i + 1)], G_Evap.monthlyEvap, i) ~= 0)) then
              do return F.error_setInpError(ERR_NUMBER, tok[(i + 1)]) end
            end
          end
          i = i + 1
        end
      end
      goto swend1
    end
    ::case4::
    do
      i = F.project_findObject(TSERIES, tok[1])
      if (i < 0) then
        do return F.error_setInpError(ERR_NAME, tok[1]) end
      end
      G_Evap.tSeries = i
      G.Tseries[i].refersTo = TIMESERIES_EVAP
      goto swend1
    end
    ::case5::
    do
      if (ntoks > 1) then
        if (ntoks < 13) then
          do return F.error_setInpError(ERR_ITEMS, S[0]) end
        end
        do
          i = 0
          while (i < 12) do
            do
              if (not (F.getDouble(tok[(i + 1)], G_Evap.panCoeff, i) ~= 0)) then
                do return F.error_setInpError(ERR_NUMBER, tok[(i + 1)]) end
              end
            end
            i = i + 1
          end
        end
      end
      goto swend1
    end
    ::swend1::
  end
  do return 0 end
end

-- climate.c:377
F.climate_readAdjustments = function(tok, ntoks)
  local G_Adjust, G_Subcatch = G.Adjust, G.Subcatch
  local i = 0
  local j = 0
  if (ntoks == 1) then
    do return 0 end
  end
  if (F.match(tok[0], S[6]) ~= 0) then
    if (ntoks < 13) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    do
      i = 1
      while (i < 13) do
        do
          if (not (F.getDouble(tok[i], G_Adjust.temp, (i - 1)) ~= 0)) then
            do return F.error_setInpError(ERR_NUMBER, tok[i]) end
          end
        end
        i = i + 1
      end
    end
    do return 0 end
  end
  if (F.match(tok[0], S[7]) ~= 0) then
    if (ntoks < 13) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    do
      i = 1
      while (i < 13) do
        do
          if (not (F.getDouble(tok[i], G_Adjust.evap, (i - 1)) ~= 0)) then
            do return F.error_setInpError(ERR_NUMBER, tok[i]) end
          end
        end
        i = i + 1
      end
    end
    do return 0 end
  end
  if (F.match(tok[0], S[8]) ~= 0) then
    if (ntoks < 13) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    do
      i = 1
      while (i < 13) do
        do
          if (not (F.getDouble(tok[i], G_Adjust.rain, (i - 1)) ~= 0)) then
            do return F.error_setInpError(ERR_NUMBER, tok[i]) end
          end
        end
        i = i + 1
      end
    end
    do return 0 end
  end
  if (F.match(tok[0], S[9]) ~= 0) then
    if (ntoks < 13) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    do
      i = 1
      while (i < 13) do
        do
          if (not (F.getDouble(tok[i], G_Adjust.hydcon, (i - 1)) ~= 0)) then
            do return F.error_setInpError(ERR_NUMBER, tok[i]) end
          end
          if (G_Adjust.hydcon[(i - 1)] <= 0.0) then
            G_Adjust.hydcon[(i - 1)] = 1.0
          end
        end
        i = i + 1
      end
    end
    do return 0 end
  end
  if (F.match(tok[0], S[10]) ~= 0) then
    if (ntoks < 3) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    i = F.project_findObject(SUBCATCH, tok[1])
    if (i < 0) then
      do return F.error_setInpError(ERR_NAME, tok[1]) end
    end
    j = F.project_findObject(TIMEPATTERN, tok[2])
    if (j < 0) then
      do return F.error_setInpError(ERR_NAME, tok[2]) end
    end
    G_Subcatch[i].nPervPattern = j
    do return 0 end
  end
  if (F.match(tok[0], S[11]) ~= 0) then
    if (ntoks < 3) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    i = F.project_findObject(SUBCATCH, tok[1])
    if (i < 0) then
      do return F.error_setInpError(ERR_NAME, tok[1]) end
    end
    j = F.project_findObject(TIMEPATTERN, tok[2])
    if (j < 0) then
      do return F.error_setInpError(ERR_NAME, tok[2]) end
    end
    G_Subcatch[i].dStorePattern = j
    do return 0 end
  end
  if (F.match(tok[0], S[12]) ~= 0) then
    if (ntoks < 3) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    i = F.project_findObject(SUBCATCH, tok[1])
    if (i < 0) then
      do return F.error_setInpError(ERR_NAME, tok[1]) end
    end
    j = F.project_findObject(TIMEPATTERN, tok[2])
    if (j < 0) then
      do return F.error_setInpError(ERR_NAME, tok[2]) end
    end
    G_Subcatch[i].infilPattern = j
    do return 0 end
  end
  do return F.error_setInpError(ERR_KEYWORD, tok[0]) end
end

-- climate.c:480
F.climate_validate = function()
  local G_Evap, G_Fclimate, G_Snow, G_Temp, G_Adjust = G.Evap, G.Fclimate, G.Snow, G.Temp, G.Adjust
  local i = 0
  local a = 0.0
  local z = 0.0
  local pa = 0.0
  if (((G.Wind.type_ == FILE_WIND) or (G_Evap.type_ == FILE_EVAP)) or (G_Evap.type_ == TEMPERATURE_EVAP)) then
    if (G_Fclimate.mode == NO_FILE) then
      F.report_writeErrorMsg(ERR_NO_CLIMATE_FILE, S[0])
    end
  end
  if (G_Fclimate.mode == USE_FILE) then
    F.climate_openFile()
  end
  if ((((G_Snow.tipm < 0.0) or (G_Snow.tipm > 1.0)) or (G_Snow.rnm < 0.0)) or (G_Snow.rnm > 1.0)) then
    F.report_writeErrorMsg(ERR_SNOWMELT_PARAMS, S[0])
  end
  a = G_Temp.anglat
  if ((a <= (-89.99)) or (a >= 89.99)) then
    F.report_writeErrorMsg(ERR_SNOWMELT_PARAMS, S[0])
  else
    G_Temp.tanAnglat = m_tan(((a * 3.141592654) / 180.0))
  end
  z = (G_Temp.elev / 1000.0)
  if (z <= 0.0) then
    pa = 29.9
  else
    pa = ((29.9 - (1.02 * z)) + (0.0032 * (z ^ 2.4)))
  end
  G_Temp.gamma = (0.000359 * pa)
  do
    i = 0
    while (i < 12) do
      do
        if (G.UnitSystem == SI) then
          G_Adjust.temp[i] = (G_Adjust.temp[i] * (9.0 / 5.0))
        end
        G_Adjust.evap[i] = (G_Adjust.evap[i] / (F.UCF(EVAPRATE)))
      end
      i = i + 1
    end
  end
end

-- climate.c:531
F.climate_openFile = function()
  local G_Fclimate, G_Temp, G_FileValue, G_FileLine, G_FileData = G.Fclimate, G.Temp, G.FileValue, G.FileLine, G.FileData
  local i = 0
  local m = {0}
  local y = {0}
  G_Fclimate.file = R.fopen(G_Fclimate.name, S[13])
  if ((G_Fclimate.file) == (nil)) then
    F.report_writeErrorMsg(ERR_CLIMATE_FILE_OPEN, G_Fclimate.name)
    do return end
  end
  G_FileValue[TMIN] = G_Temp.ta
  G_FileValue[TMAX] = G_Temp.ta
  G_FileValue[EVAP] = 0.0
  G_FileValue[WIND] = 0.0
  G.FileFormat = F.getFileFormat()
  if (G.FileFormat == UNKNOWN_FORMAT) then
    F.report_writeErrorMsg(ERR_CLIMATE_FILE_READ, G_Fclimate.name)
    do return end
  end
  R.rewind(G_Fclimate.file)
  F.sstrncpy(G_FileLine, S[0], 0)
  if (G_Temp.fileStartDate == ((-693594) * 1.0)) then
    F.datetime_decodeDate(G.StartDate, G, "FileYear", G, "FileMonth", G, "FileDay")
  else
    F.datetime_decodeDate(G_Temp.fileStartDate, G, "FileYear", G, "FileMonth", G, "FileDay")
  end
  while (not (R.feof(G_Fclimate.file) ~= 0)) do
    do
      F.sstrncpy(G_FileLine, S[0], 0)
      F.readFileLine(y, 1, m, 1)
      if ((y[1] == G.FileYear) and (m[1] == G.FileMonth)) then
        break
      end
    end
  end
  if (R.feof(G_Fclimate.file) ~= 0) then
    F.report_writeErrorMsg(ERR_CLIMATE_END_OF_FILE, G_Fclimate.name)
    do return end
  end
  if (not (G.ErrorCode ~= 0)) then
    G.FileElapsedDays = 0
    G.FileLastDay = F.datetime_daysPerMonth(G.FileYear, G.FileMonth)
    F.readFileValues()
    do
      i = TMIN
      while (i <= WIND) do
        do
          if (G_FileData[i][G.FileDay] == (-10000000000.0)) then
            goto continue2
          end
          G_FileValue[i] = G_FileData[i][G.FileDay]
        end
        ::continue2::
        i = i + 1
      end
    end
  end
end

-- climate.c:598
F.climate_initState = function()
  local G_Evap, G_Tma = G.Evap, G.Tma
  G.LastDay = ((-693594) * 1.0)
  G.Temp.tmax = (-10000000000.0)
  G.Snow.removed = 0.0
  G.NextEvapDate = G.StartDate
  G.NextEvapRate = 0.0
  if ((G_Evap.type_ == TIMESERIES_EVAP) and (G_Evap.tSeries >= 0)) then
    F.table_getFirstEntry(G.Tseries[G_Evap.tSeries], G, "NextEvapDate", G, "NextEvapRate")
    if (G.NextEvapDate < G.StartDate) then
      F.setNextEvapDate(G.StartDate)
    end
    G_Evap.rate = (G.NextEvapRate / F.UCF(EVAPRATE))
    F.setNextEvapDate(G.NextEvapDate)
  end
  if (G_Evap.type_ == TEMPERATURE_EVAP) then
    G_Tma.maxCount = R.i32(R.idiv(56, 8))
    G_Tma.count = 0
    G_Tma.front = 0
    G_Tma.tAve = 0.0
    G_Tma.tRng = 0.0
  end
end

-- climate.c:641
F.climate_setState = function(theDate)
  local G_Adjust = G.Adjust
  if (G.Fclimate.mode == USE_FILE) then
    F.updateFileValues(theDate)
  end
  if (G.Temp.dataSource ~= NO_TEMP) then
    F.setTemp(theDate)
  end
  F.setEvap(theDate)
  F.setWind(theDate)
  G_Adjust.rainFactor = G_Adjust.rain[(F.datetime_monthOfYear(theDate) - 1)]
  G_Adjust.hydconFactor = G_Adjust.hydcon[(F.datetime_monthOfYear(theDate) - 1)]
  F.setNextEvapDate(theDate)
end

-- climate.c:659
F.climate_getNextEvapDate = function()
  do return G.NextEvapDate end
end

-- climate.c:671
F.setNextEvapDate = function(theDate)
  local G_Evap, G_Tseries = G.Evap, G.Tseries
  local yr = {0}
  local mon = {0}
  local day = {0}
  local k = 0
  local d = {0.0}
  local e = {0.0}
  if (G.NextEvapDate > theDate) then
    do return end
  end
  do
    local __sw1 = G_Evap.type_
    if __sw1 == CONSTANT_EVAP then goto case2
    elseif __sw1 == MONTHLY_EVAP then goto case3
    elseif __sw1 == TIMESERIES_EVAP then goto case4
    elseif __sw1 == FILE_EVAP then goto case5
    else goto case6 end
    ::case2::
    do
      G.NextEvapDate = (theDate + 365.0)
      goto swend1
    end
    ::case3::
    do
      F.datetime_decodeDate(theDate, yr, 1, mon, 1, day, 1)
      if (mon[1] == 12) then
        mon[1] = 1
        yr[1] = yr[1] + 1
      else
        mon[1] = mon[1] + 1
      end
      G.NextEvapDate = F.datetime_encodeDate(yr[1], mon[1], 1)
      goto swend1
    end
    ::case4::
    do
      k = G_Evap.tSeries
      if (k >= 0) then
        G.NextEvapDate = (theDate + 365.0)
        while ((F.table_getNextEntry(G_Tseries[k], d, 1, e, 1) ~= 0) and (d[1] <= G.EndDateTime)) do
          do
            if (d[1] >= theDate) then
              G.NextEvapDate = d[1]
              G.NextEvapRate = e[1]
              break
            end
          end
        end
      end
      goto swend1
    end
    ::case5::
    do
      G.NextEvapDate = (R.floor(theDate) + 1.0)
      goto swend1
    end
    ::case6::
    do
      G.NextEvapDate = (theDate + 365.0)
    end
    ::swend1::
  end
end

-- climate.c:734
F.updateFileValues = function(theDate)
  local G_FileData, G_FileValue = G.FileData, G.FileValue
  local i = 0
  local deltaDays = 0
  deltaDays = R.D2I(((R.floor(theDate) - R.floor(G.StartDateTime))))
  if (deltaDays > G.FileElapsedDays) then
    G.FileElapsedDays = G.FileElapsedDays + 1
    G.FileDay = G.FileDay + 1
    if (G.FileDay > G.FileLastDay) then
      G.FileMonth = G.FileMonth + 1
      if (G.FileMonth > 12) then
        G.FileMonth = 1
        G.FileYear = G.FileYear + 1
      end
      F.readFileValues()
      G.FileDay = 1
      G.FileLastDay = F.datetime_daysPerMonth(G.FileYear, G.FileMonth)
    end
    do
      i = TMIN
      while (i <= WIND) do
        do
          if (G_FileData[i][G.FileDay] == (-10000000000.0)) then
            goto continue1
          end
          G_FileValue[i] = G_FileData[i][G.FileDay]
        end
        ::continue1::
        i = i + 1
      end
    end
  end
end

-- climate.c:782
F.setTemp = function(theDate)
  local G_Temp, G_FileValue, G_Adjust, G_Tma, G_Snow, G_Nobjects = G.Temp, G.FileValue, G.Adjust, G.Tma, G.Snow, G.Nobjects
  local j = 0
  local k = 0
  local mon = 0
  local day = 0
  local theDay = 0.0
  local hour = 0.0
  local tmp = 0.0
  mon = F.datetime_monthOfYear(theDate)
  theDay = R.floor(theDate)
  if (theDay > G.LastDay) then
    day = F.datetime_dayOfYear(theDate)
    if (G_Temp.dataSource == FILE_TEMP) then
      G.Tmin = (G_FileValue[TMIN] + G_Adjust.temp[(mon - 1)])
      G.Tmax = (G_FileValue[TMAX] + G_Adjust.temp[(mon - 1)])
      if (G.Tmin > G.Tmax) then
        tmp = G.Tmin
        G.Tmin = G.Tmax
        G.Tmax = tmp
      end
      F.updateTempTimes(day)
      if (G.Evap.type_ == TEMPERATURE_EVAP) then
        F.updateTempMoveAve(G.Tmin, G.Tmax)
        G_FileValue[EVAP] = F.getTempEvap(day, G_Tma.tAve, G_Tma.tRng)
      end
    end
    G_Snow.season = m_sin((0.0172615 * (((day * 1.0) - 81.0))))
    do
      j = 0
      while (j < G_Nobjects[SNOWMELT]) do
        do
          F.snow_setMeltCoeffs(j, G_Snow.season)
        end
        j = j + 1
      end
    end
    G.LastDay = theDate
  end
  if (G_Temp.dataSource == FILE_TEMP) then
    hour = (((theDate - theDay)) * 24.0)
    if (hour < G.Hrsr) then
      G_Temp.ta = (G.Tmin + ((G.Trng1 / 2.0) * m_sin(((3.141592654 / G.Dydif) * ((G.Hrsr - hour))))))
    elseif ((hour >= G.Hrsr) and (hour <= G.Hrss)) then
      G_Temp.ta = (G.Tave + (G.Trng * m_sin(((3.141592654 / G.Dhrdy) * ((G.Hrday - hour))))))
    else
      G_Temp.ta = (G.Tmax - (G.Trng * m_sin(((3.141592654 / G.Dydif) * ((hour - G.Hrss))))))
    end
  end
  if (G_Temp.dataSource == TSERIES_TEMP) then
    k = G_Temp.tSeries
    if (k >= 0) then
      G_Temp.ta = F.table_tseriesLookup(G.Tseries[k], theDate, 1)
      if (G.UnitSystem == SI) then
        G_Temp.ta = ((((9.0 / 5.0)) * G_Temp.ta) + 32.0)
      end
      G_Temp.ta = (G_Temp.ta + (G_Adjust.temp[(mon - 1)]))
    end
  end
  G_Temp.ea = (8117500.0 * m_exp(((-7701.544) / ((G_Temp.ta + 405.0265)))))
end

-- climate.c:872
F.setEvap = function(theDate)
  local G_Evap, G_FileValue, G_Pattern = G.Evap, G.FileValue, G.Pattern
  local k = 0
  local mon = F.datetime_monthOfYear(theDate)
  do
    local __sw1 = G_Evap.type_
    if __sw1 == CONSTANT_EVAP then goto case2
    elseif __sw1 == MONTHLY_EVAP then goto case3
    elseif __sw1 == TIMESERIES_EVAP then goto case4
    elseif __sw1 == FILE_EVAP then goto case5
    elseif __sw1 == TEMPERATURE_EVAP then goto case6
    else goto case7 end
    ::case2::
    do
      G_Evap.rate = (G_Evap.monthlyEvap[0] / F.UCF(EVAPRATE))
      goto swend1
    end
    ::case3::
    do
      G_Evap.rate = (G_Evap.monthlyEvap[(mon - 1)] / F.UCF(EVAPRATE))
      goto swend1
    end
    ::case4::
    do
      if (theDate >= G.NextEvapDate) then
        G_Evap.rate = (G.NextEvapRate / F.UCF(EVAPRATE))
      end
      goto swend1
    end
    ::case5::
    do
      G_Evap.rate = (G_FileValue[EVAP] / F.UCF(EVAPRATE))
      G_Evap.rate = (G_Evap.rate * (G_Evap.panCoeff[(mon - 1)]))
      goto swend1
    end
    ::case6::
    do
      G_Evap.rate = (G_FileValue[EVAP] / F.UCF(EVAPRATE))
      goto swend1
    end
    ::case7::
    do
      G_Evap.rate = 0.0
    end
    ::swend1::
  end
  G_Evap.rate = (G_Evap.rate + (G.Adjust.evap[(mon - 1)]))
  G_Evap.recoveryFactor = 1.0
  k = G_Evap.recoveryPattern
  if ((k >= 0) and (G_Pattern[k].type_ == MONTHLY_PATTERN)) then
    G_Evap.recoveryFactor = G_Pattern[k].factor[(mon - 1)]
  end
end

-- climate.c:923
F.setWind = function(theDate)
  local G_Wind = G.Wind
  local yr = {0}
  local mon = {0}
  local day = {0}
  do
    local __sw1 = G_Wind.type_
    if __sw1 == MONTHLY_WIND then goto case2
    elseif __sw1 == FILE_WIND then goto case3
    else goto case4 end
    ::case2::
    do
      F.datetime_decodeDate(theDate, yr, 1, mon, 1, day, 1)
      G_Wind.ws = (G_Wind.aws[(mon[1] - 1)] / F.UCF(WINDSPEED))
      goto swend1
    end
    ::case3::
    do
      G_Wind.ws = G.FileValue[WIND]
      goto swend1
    end
    ::case4::
    do
      G_Wind.ws = 0.0
    end
    ::swend1::
  end
end

-- climate.c:949
F.updateTempTimes = function(day)
  local G_Temp = G.Temp
  local decl = 0.0
  local hrang = 0.0
  local arg = 0.0
  decl = (0.40928 * m_cos((0.017202 * ((172.0 - (day * 1.0))))))
  arg = ((-(m_tan(decl))) * G_Temp.tanAnglat)
  if (arg <= (-1.0)) then
    arg = 3.141592654
  elseif (arg >= 1.0) then
    arg = 0.0
  else
    arg = m_acos(arg)
  end
  hrang = (3.8197 * arg)
  G.Hrsr = ((12.0 - hrang) + G_Temp.dtlong)
  G.Hrss = (((12.0 + hrang) + G_Temp.dtlong) - 3.0)
  G.Dhrdy = (G.Hrsr - G.Hrss)
  G.Dydif = ((24.0 + G.Hrsr) - G.Hrss)
  G.Hrday = (((G.Hrsr + G.Hrss)) / 2.0)
  G.Tave = (((G.Tmin + G.Tmax)) / 2.0)
  G.Trng = (((G.Tmax - G.Tmin)) / 2.0)
  if (G_Temp.tmax == (-10000000000.0)) then
    G.Trng1 = (G.Tmax - G.Tmin)
  else
    G.Trng1 = (G_Temp.tmax - G.Tmin)
  end
  G_Temp.tmax = G.Tmax
end

-- climate.c:981
F.getTempEvap = function(day, tave, trng)
  local a = ((2.0 * 3.141592654) / 365.0)
  local ta = ((((tave - 32.0)) * 5.0) / 9.0)
  local tr = ((trng * 5.0) / 9.0)
  local lamda = (2.5 - (0.002361 * ta))
  local dr = (1.0 + (0.033 * m_cos((a * (day * 1.0)))))
  local phi = (((G.Temp.anglat * 2.0) * 3.141592654) / 360.0)
  local del = (0.4093 * m_sin((a * ((284.0 + (day * 1.0))))))
  local omega = m_acos(((-(m_tan(phi))) * m_tan(del)))
  local ra = ((37.6 * dr) * ((((omega * m_sin(phi)) * m_sin(del)) + ((m_cos(phi) * m_cos(del)) * m_sin(omega)))))
  local e = ((((0.0023 * ra) / lamda) * m_sqrt(tr)) * ((ta + 17.8)))
  if (e < 0.0) then
    e = 0.0
  end
  if (G.UnitSystem == US) then
    e = (e / 25.4)
  end
  do return e end
end

-- climate.c:1010
F.getFileFormat = function()
  local recdType = R.bufFrom(S[0], 4)
  local elemType = R.bufFrom(S[0], 4)
  local filler = R.bufFrom(S[0], 5)
  local staID = R.buf(80)
  local s = R.buf(80)
  local line = R.buf(1024)
  local y = {0}
  local m = {0}
  local d = {0}
  local n = 0
  if R.peq(R.fgets(line, 1024, G.Fclimate.file), (nil)) then
    do return UNKNOWN_FORMAT end
  end
  F.sstrncpy(recdType, line, 3)
  F.sstrncpy(filler, R.padd(line, 23), 4)
  if ((R.strcmp(recdType, S[14]) == 0) and (R.strcmp(filler, S[15]) == 0)) then
    do return TD3200 end
  end
  if (R.strlen(line) >= 233) then
    F.sstrncpy(elemType, R.padd(line, 13), 3)
    n = R.atoi(elemType)
    if (((n == 1) or (n == 2)) or (n == 151)) then
      do return DLY0204 end
    end
  end
  n = R.sscanf(line, S[16], staID, y, 1, m, 1, d, 1, s)
  if (n == 5) then
    do return USER_PREPARED end
  end
  if (F.isGhcndFormat(line) ~= 0) then
    do return GHCND end
  end
  do return UNKNOWN_FORMAT end
end

-- climate.c:1055
F.readFileLine = function(y, y__k, m, m__k)
  local G_FileLine, G_Fclimate = G.FileLine, G.Fclimate
  while (R.strlen(G_FileLine) == 0) do
    do
      if R.peq(R.fgets(G_FileLine, 1024, G_Fclimate.file), (nil)) then
        do return end
      end
      if (G_FileLine.b[G_FileLine.o] == 10) then
        R.cset(G_FileLine, 0, 0)
      end
    end
  end
  do
    local __sw1 = G.FileFormat
    if __sw1 == USER_PREPARED then goto case3
    elseif __sw1 == TD3200 then goto case4
    elseif __sw1 == DLY0204 then goto case5
    elseif __sw1 == GHCND then goto case6
    else goto swend2 end
    ::case3::
    do
      F.readUserFileLine(y, y__k, m, m__k)
      goto swend2
    end
    ::case4::
    do
      F.readTD3200FileLine(y, y__k, m, m__k)
      goto swend2
    end
    ::case5::
    do
      F.readDLY0204FileLine(y, y__k, m, m__k)
      goto swend2
    end
    ::case6::
    do
      F.readGhcndFileLine(y, y__k, m, m__k)
      goto swend2
    end
    ::swend2::
  end
end

-- climate.c:1082
F.readUserFileLine = function(y, y__k, m, m__k)
  local n = 0
  local staID = R.buf(80)
  n = R.sscanf(G.FileLine, S[17], staID, y, y__k, m, m__k)
  if (n < 3) then
    F.report_writeErrorMsg(ERR_CLIMATE_FILE_READ, G.Fclimate.name)
  end
end

-- climate.c:1101
F.readTD3200FileLine = function(y, y__k, m, m__k)
  local G_FileLine, G_Fclimate = G.FileLine, G.Fclimate
  local recdType = R.bufFrom(S[0], 4)
  local year = R.bufFrom(S[0], 5)
  local month = R.bufFrom(S[0], 3)
  if (R.strlen(G_FileLine) < 30) then
    F.report_writeErrorMsg(ERR_CLIMATE_FILE_READ, G_Fclimate.name)
    do return end
  end
  F.sstrncpy(recdType, G_FileLine, 3)
  if (R.strcmp(recdType, S[14]) ~= 0) then
    F.report_writeErrorMsg(ERR_CLIMATE_FILE_READ, G_Fclimate.name)
    do return end
  end
  F.sstrncpy(year, R.padd(G_FileLine, 17), 4)
  F.sstrncpy(month, R.padd(G_FileLine, 21), 2)
  y[y__k] = R.atoi(year)
  m[m__k] = R.atoi(month)
end

-- climate.c:1137
F.readDLY0204FileLine = function(y, y__k, m, m__k)
  local G_FileLine = G.FileLine
  local year = R.bufFrom(S[0], 5)
  local month = R.bufFrom(S[0], 3)
  if (R.strlen(G_FileLine) < 16) then
    F.report_writeErrorMsg(ERR_CLIMATE_FILE_READ, G.Fclimate.name)
    do return end
  end
  F.sstrncpy(year, R.padd(G_FileLine, 7), 4)
  F.sstrncpy(month, R.padd(G_FileLine, 11), 2)
  y[y__k] = R.atoi(year)
  m[m__k] = R.atoi(month)
end

-- climate.c:1164
F.readFileValues = function()
  local G_FileData, G_Fclimate, G_FileLine = G.FileData, G.Fclimate, G.FileLine
  local i = 0
  local j = 0
  local y = {0}
  local m = {0}
  do
    i = 0
    while (i < G.MAXCLIMATEVARS) do
      do
        do
          j = 0
          while (j < G.MAXDAYSPERMONTH) do
            do
              G_FileData[i][j] = (-10000000000.0)
            end
            j = j + 1
          end
        end
      end
      i = i + 1
    end
  end
  while (not (G.ErrorCode ~= 0)) do
    do
      if (R.feof(G_Fclimate.file) ~= 0) then
        do return end
      end
      F.readFileLine(y, 1, m, 1)
      if ((y[1] > G.FileYear) or (m[1] > G.FileMonth)) then
        do return end
      end
      do
        local __sw1 = G.FileFormat
        if __sw1 == USER_PREPARED then goto case5
        elseif __sw1 == TD3200 then goto case6
        elseif __sw1 == DLY0204 then goto case7
        elseif __sw1 == GHCND then goto case8
        else goto swend4 end
        ::case5::
        do
          F.parseUserFileLine()
          goto swend4
        end
        ::case6::
        do
          F.parseTD3200FileLine()
          goto swend4
        end
        ::case7::
        do
          F.parseDLY0204FileLine()
          goto swend4
        end
        ::case8::
        do
          F.parseGhcndFileLine()
          goto swend4
        end
        ::swend4::
      end
      F.sstrncpy(G_FileLine, S[0], 0)
    end
  end
end

-- climate.c:1201
F.parseUserFileLine = function()
  local G_FileData = G.FileData
  local n = 0
  local y = {0}
  local m = {0}
  local d = {0}
  local staID = R.buf(80)
  local s0 = R.bufFrom(S[0], 80)
  local s1 = R.bufFrom(S[0], 80)
  local s2 = R.bufFrom(S[0], 80)
  local s3 = R.bufFrom(S[0], 80)
  local x = 0.0
  n = R.sscanf(G.FileLine, S[18], staID, y, 1, m, 1, d, 1, s0, s1, s2, s3)
  if (n < 4) then
    do return end
  end
  if ((d[1] < 1) or (d[1] > 31)) then
    do return end
  end
  if ((R.strlen(s0) > 0) and (s0.b[s0.o] ~= 42)) then
    x = R.atof(s0)
    if (G.UnitSystem == SI) then
      x = (((9.0 / 5.0) * x) + 32.0)
    end
    G_FileData[TMAX][d[1]] = x
  end
  if ((R.strlen(s1) > 0) and (s1.b[s1.o] ~= 42)) then
    x = R.atof(s1)
    if (G.UnitSystem == SI) then
      x = (((9.0 / 5.0) * x) + 32.0)
    end
    G_FileData[TMIN][d[1]] = x
  end
  if ((R.strlen(s2) > 0) and (s2.b[s2.o] ~= 42)) then
    G_FileData[EVAP][d[1]] = R.atof(s2)
  end
  if ((R.strlen(s3) > 0) and (s3.b[s3.o] ~= 42)) then
    G_FileData[WIND][d[1]] = R.atof(s3)
  end
end

-- climate.c:1249
F.parseTD3200FileLine = function()
  local G_ClimateVarWords = G.ClimateVarWords
  local i = 0
  local param = R.bufFrom(S[0], 5)
  F.sstrncpy(param, R.padd(G.FileLine, 11), 4)
  do
    i = 0
    while (i < G.MAXCLIMATEVARS) do
      do
        if (R.strcmp(param, G_ClimateVarWords[i]) == 0) then
          F.setTD3200FileValues(i)
        end
      end
      i = i + 1
    end
  end
end

-- climate.c:1271
F.setTD3200FileValues = function(i)
  local G_FileLine, G_FileData = G.FileLine, G.FileData
  local valCount = R.bufFrom(S[0], 4)
  local day = R.bufFrom(S[0], 3)
  local sign = R.bufFrom(S[0], 2)
  local value = R.bufFrom(S[0], 6)
  local flag2 = R.bufFrom(S[0], 2)
  local x = 0.0
  local nValues = 0
  local j = 0
  local k = 0
  local d = 0
  F.sstrncpy(valCount, R.padd(G_FileLine, 27), 3)
  nValues = R.atoi(valCount)
  if (R.i32(R.strlen(G_FileLine)) >= ((12 * nValues) + 30)) then
    do
      j = 0
      while (j < nValues) do
        do
          k = (30 + (j * 12))
          F.sstrncpy(day, R.padd(G_FileLine, k), 2)
          F.sstrncpy(sign, R.padd(G_FileLine, (k + 4)), 1)
          F.sstrncpy(value, R.padd(G_FileLine, (k + 5)), 5)
          F.sstrncpy(flag2, R.padd(G_FileLine, (k + 11)), 1)
          d = R.atoi(day)
          if ((((R.strcmp(value, S[19]) ~= 0) and (((flag2.b[flag2.o] == 48) or (flag2.b[flag2.o] == 49)))) and (d > 0)) and (d <= 31)) then
            x = R.atof(value)
            if (sign.b[sign.o] == 45) then
              x = (-x)
            end
            if (i == EVAP) then
              x = (x / 100.0)
              if (G.UnitSystem == SI) then
                x = (x * 25.4)
              end
            end
            if (i == WIND) then
              x = (x / 24.0)
            end
            G_FileData[i][d] = x
          end
        end
        j = j + 1
      end
    end
  end
end

-- climate.c:1336
F.parseDLY0204FileLine = function()
  local G_FileLine, G_FileData = G.FileLine, G.FileData
  local j = 0
  local k = 0
  local p = 0
  local param = R.bufFrom(S[0], 4)
  local sign = R.bufFrom(S[0], 2)
  local value = R.bufFrom(S[0], 6)
  local code = R.bufFrom(S[0], 2)
  local x = 0.0
  F.sstrncpy(param, R.padd(G_FileLine, 13), 3)
  p = R.atoi(param)
  if (p == 1) then
    p = TMAX
  elseif (p == 2) then
    p = TMIN
  elseif (p == 151) then
    p = EVAP
  else
    do return end
  end
  if (R.strlen(G_FileLine) < 233) then
    do return end
  end
  k = 16
  do
    j = 1
    while (j <= 31) do
      do
        F.sstrncpy(sign, R.padd(G_FileLine, k), 1)
        F.sstrncpy(value, R.padd(G_FileLine, (k + 1)), 5)
        F.sstrncpy(code, R.padd(G_FileLine, (k + 6)), 1)
        k = (k + 7)
        if ((R.strcmp(value, S[19]) ~= 0) and (R.strcmp(value, S[20]) ~= 0)) then
          do
            local __sw1 = p
            if __sw1 == TMAX or __sw1 == TMIN then goto case3
            elseif __sw1 == EVAP then goto case4
            else goto case5 end
            ::case3::
            do
              x = (R.atof(value) / 10.0)
              if (sign.b[sign.o] == 45) then
                x = (-x)
              end
              x = (((9.0 / 5.0) * x) + 32.0)
              goto swend2
            end
            ::case4::
            do
              x = (R.atof(value) / 10.0)
              if (G.UnitSystem == US) then
                x = (x / 25.4)
              end
              goto swend2
            end
            ::case5::
            do
              do return end
            end
            ::swend2::
          end
          G_FileData[p][j] = x
        end
      end
      j = j + 1
    end
  end
end

-- climate.c:1401
F.isGhcndFormat = function(line)
  local G_FileFieldPos = G.FileFieldPos
  local i = 0
  local ptr = nil
  ptr = R.strstr(line, S[21])
  if R.peq(ptr, (nil)) then
    do return 0 end
  end
  G.FileDateFieldPos = R.i32(((ptr.o - line.o)))
  do
    i = TMIN
    while (i <= WIND) do
      do
        G_FileFieldPos[i] = (-1)
      end
      i = i + 1
    end
  end
  ptr = R.strstr(line, S[22])
  if (ptr ~= nil) then
    G_FileFieldPos[TMIN] = R.i32(((ptr.o - line.o)))
  end
  ptr = R.strstr(line, S[23])
  if (ptr ~= nil) then
    G_FileFieldPos[TMAX] = R.i32(((ptr.o - line.o)))
  end
  ptr = R.strstr(line, S[7])
  if (ptr ~= nil) then
    G_FileFieldPos[EVAP] = R.i32(((ptr.o - line.o)))
  end
  G.FileWindType = WDMV
  ptr = R.strstr(line, S[24])
  if R.peq(ptr, (nil)) then
    G.FileWindType = AWND
    ptr = R.strstr(line, S[25])
  end
  if (ptr ~= nil) then
    G_FileFieldPos[WIND] = R.i32(((ptr.o - line.o)))
  end
  do
    i = TMIN
    while (i <= WIND) do
      do
        if (G_FileFieldPos[i] >= 0) then
          do return 1 end
        end
      end
      i = i + 1
    end
  end
  do return 0 end
end

-- climate.c:1445
F.readGhcndFileLine = function(y, y__k, m, m__k)
  local n = R.sscanf(R.padd(G.FileLine, G.FileDateFieldPos), S[26], y, y__k, m, m__k)
  if (n ~= 2) then
    y[y__k] = (-99999)
    m[m__k] = (-99999)
  end
end

-- climate.c:1463
F.parseGhcndFileLine = function()
  local G_FileLine, G_FileFieldPos, G_FileData = G.FileLine, G.FileFieldPos, G.FileData
  local y = {0}
  local m = {0}
  local d = {0}
  local n = 0
  local i = 0
  local v = {0.0}
  n = R.sscanf(R.padd(G_FileLine, G.FileDateFieldPos), S[27], y, 1, m, 1, d, 1)
  if (n < 3) then
    do return end
  end
  if ((d[1] < 1) or (d[1] > 31)) then
    do return end
  end
  do
    i = TMIN
    while (i <= WIND) do
      do
        if (G_FileFieldPos[i] >= 0) then
          if (R.sscanf(R.padd(G_FileLine, G_FileFieldPos[i]), S[28], v, 1) > 0) then
            if (m_abs(v[1]) < 9999.0) then
              G_FileData[i][d[1]] = F.convertGhcndValue(i, v[1])
            end
          end
        end
      end
      i = i + 1
    end
  end
end

-- climate.c:1496
F.convertGhcndValue = function(var, v)
  do
    local __sw1 = var
    if __sw1 == TMIN or __sw1 == TMAX then goto case2
    elseif __sw1 == EVAP then goto case3
    elseif __sw1 == WIND then goto case4
    else goto case5 end
    ::case2::
    do
      do
        local __sw2 = G.FileTempUnits
        if __sw2 == DEG_C10 then goto case7
        elseif __sw2 == DEG_C then goto case8
        else goto case9 end
        ::case7::
        do
          do return ((((v / 10.0) * 9.0) / 5.0) + 32.0) end
        end
        ::case8::
        do
          do return (((v * 9.0) / 5.0) + 32.0) end
        end
        ::case9::
        do
          do return v end
        end
        ::swend6::
      end
    end
    ::case3::
    do
      do
        local __sw3 = G.FileTempUnits
        if __sw3 == DEG_C10 then goto case11
        elseif __sw3 == DEG_C then goto case12
        else goto case13 end
        ::case11::
        do
          v = (v / 10.0)
          if (G.UnitSystem == US) then
            v = (v / 25.4)
          end
          do return v end
        end
        ::case12::
        do
          if (G.UnitSystem == US) then
            v = (v / 25.4)
          end
          do return v end
        end
        ::case13::
        do
          if (G.UnitSystem == SI) then
            v = (v * 25.4)
          end
          do return v end
        end
        ::swend10::
      end
    end
    ::case4::
    do
      do
        local __sw4 = G.FileTempUnits
        if __sw4 == DEG_C10 then goto case15
        elseif __sw4 == DEG_C then goto case16
        else goto case17 end
        ::case15::
        do
          if (G.FileWindType == WDMV) then
            do return ((v * 0.62137) / 24.0) end
          else
            do return ((((v / 10.0) / 1000.0) * 0.62137) * 3600.0) end
          end
        end
        ::case16::
        do
          if (G.FileWindType == WDMV) then
            do return ((v * 0.62137) / 24.0) end
          else
            do return (((v / 1000.0) * 0.62137) * 3600.0) end
          end
        end
        ::case17::
        do
          if (G.FileWindType == WDMV) then
            do return (v / 24.0) end
          else
            do return v end
          end
        end
        ::swend14::
      end
    end
    ::case5::
    do
      do return v end
    end
    ::swend1::
  end
end

-- climate.c:1569
F.updateTempMoveAve = function(tmin, tmax)
  local G_Tma = G.Tma
  local ta = 0.0
  local tr = 0.0
  local kount = G_Tma.count
  local count = (kount * 1.0)
  ta = (((tmin + tmax)) / 2.0)
  tr = m_abs((tmax - tmin))
  if (kount == G_Tma.maxCount) then
    G_Tma.tAve = (((((G_Tma.tAve * count) + ta) - G_Tma.ta[G_Tma.front])) / count)
    G_Tma.tRng = (((((G_Tma.tRng * count) + tr) - G_Tma.tr[G_Tma.front])) / count)
    G_Tma.ta[G_Tma.front] = ta
    G_Tma.tr[G_Tma.front] = tr
    G_Tma.front = G_Tma.front + 1
    if ((G_Tma.front * 1.0) == count) then
      G_Tma.front = 0
    end
  else
    G_Tma.tAve = ((((G_Tma.tAve * count) + ta)) / ((count + 1.0)))
    G_Tma.tRng = ((((G_Tma.tRng * count) + tr)) / ((count + 1.0)))
    G_Tma.ta[G_Tma.front] = ta
    G_Tma.tr[G_Tma.front] = tr
    G_Tma.count = G_Tma.count + 1
    G_Tma.front = G_Tma.front + 1
    if (G_Tma.count == G_Tma.maxCount) then
      G_Tma.front = 0
    end
  end
end

