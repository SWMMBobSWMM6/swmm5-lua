-- Generated from EPA SWMM 5.2.4 (rain.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local GAGE <const> = 0
local RAIN_FILE <const> = 1
local NO_FILE <const> = 0
local SCRATCH_FILE <const> = 1
local USE_FILE <const> = 2
local SAVE_FILE <const> = 3
local ERR_RAIN_FILE_SCRATCH <const> = 313
local ERR_RAIN_FILE_OPEN <const> = 315
local ERR_RAIN_FILE_CONFLICT <const> = 156
local ERR_RAIN_FILE_DATA <const> = 317
local UNKNOWN_FORMAT <const> = 0
local ERR_RAIN_FILE_FORMAT <const> = 319
local ERR_RAIN_IFACE_FORMAT <const> = 320
local ERR_RAIN_FILE_GAGE <const> = 321
local RAINFALL_VOLUME <const> = 1
local NWS_SPACE_DELIMITED <const> = 2
local NWS_COMMA_DELIMITED <const> = 3
local NWS_TAPE <const> = 1
local AES_HLY <const> = 6
local CMC_FIF <const> = 8
local CMC_HLY <const> = 7
local STD_SPACE_DELIMITED <const> = 9
local SI <const> = 1
local NWS_ONLINE_60 <const> = 4
local NWS_ONLINE_15 <const> = 5
local DELETED_PERIOD <const> = 2
local MISSING_PERIOD <const> = 3
local ACCUMULATED_PERIOD <const> = 1
local NO_CONDITION <const> = 0
local ERR_RAIN_FILE_SEQUENCE <const> = 318
local RAINFALL_INTENSITY <const> = 0
local CUMULATIVE_RAINFALL <const> = 2
local _ENV = R.strict

G.RainStats = T.TRainStats()
G.Condition = 0
G.TimeOffset = 0
G.DataOffset = 0
G.ValueOffset = 0
G.RainType = 0
G.Interval = 0
G.UnitsFactor = 0.0
G.RainAccum = 0.0
G.StationID = nil
G.AccumStartDate = 0.0
G.PreviousDate = 0.0
G.GageIndex = 0
G.hasStationName = 0

-- rain.c:118
F.rain_open = function()
  local G_Nobjects, G_Gage, G_Frain = G.Nobjects, G.Gage, G.Frain
  local i = 0
  local count = 0
  count = 0
  do
    i = 0
    while (i < G_Nobjects[GAGE]) do
      do
        if (G_Gage[i].dataSource == RAIN_FILE) then
          count = count + 1
        end
      end
      i = i + 1
    end
  end
  G_Frain.file = (nil)
  if (count == 0) then
    G_Frain.mode = NO_FILE
  else
    do
      local __sw1 = G_Frain.mode
      if __sw1 == SCRATCH_FILE then goto case3
      elseif __sw1 == USE_FILE then goto case4
      elseif __sw1 == SAVE_FILE then goto case5
      else goto swend2 end
      ::case3::
      do
        F.getTempFileName(G_Frain.name)
        G_Frain.file = R.fopen(G_Frain.name, S[166])
        if ((G_Frain.file) == (nil)) then
          F.report_writeErrorMsg(ERR_RAIN_FILE_SCRATCH, S[0])
          do return end
        end
        goto swend2
      end
      ::case4::
      do
        G_Frain.file = R.fopen(G_Frain.name, S[165])
        if ((G_Frain.file) == (nil)) then
          F.report_writeErrorMsg(ERR_RAIN_FILE_OPEN, G_Frain.name)
          do return end
        end
        goto swend2
      end
      ::case5::
      do
        G_Frain.file = R.fopen(G_Frain.name, S[166])
        if ((G_Frain.file) == (nil)) then
          F.report_writeErrorMsg(ERR_RAIN_FILE_OPEN, G_Frain.name)
          do return end
        end
        goto swend2
      end
      ::swend2::
    end
  end
  if ((G_Frain.mode == SCRATCH_FILE) or (G_Frain.mode == SAVE_FILE)) then
    F.createRainFile(count)
  end
  if (G_Frain.mode ~= NO_FILE) then
    F.initRainFile()
  end
  F.rdii_openRdii()
end

-- rain.c:184
F.rain_close = function()
  local G_Frain = G.Frain
  if (G_Frain.file ~= nil) then
    R.fclose(G_Frain.file)
    if (G_Frain.mode == SCRATCH_FILE) then
      R.remove(G_Frain.name)
    end
  end
  G_Frain.file = (nil)
  F.rdii_closeRdii()
end

-- rain.c:202
F.createRainFile = function(count)
  local G_Frain, G_Nobjects, G_Gage = G.Frain, G.Nobjects, G.Gage
  local i = 0
  local k = 0
  local kount = {count}
  local filePos1 = 0
  local filePos2 = {0}
  local filePos3 = {0}
  local interval = {0}
  local dummy = {(-1)}
  local staID = R.buf(1025)
  local fileStamp = R.bufFrom(S[327], 11)
  if ((G.ErrorCode ~= 0) or (not (G_Frain.file ~= nil))) then
    do return end
  end
  R.fwrite_arr("c", fileStamp, 0, R.strlen(fileStamp), G_Frain.file)
  R.fwrite1("i", 4, kount[1], G_Frain.file)
  filePos1 = R.i32(R.ftell(G_Frain.file))
  if (count > 0) then
    F.report_writeRainStats((-1), G.RainStats)
  end
  R.strcpy(staID, S[33])
  do
    i = 0
    while (i < count) do
      do
        R.fwrite_arr("c", staID, 0, (1024 + 1), G_Frain.file)
        do
          k = 1
          while (k <= 3) do
            do
              R.fwrite1("i", 4, dummy[1], G_Frain.file)
            end
            k = k + 1
          end
        end
      end
      i = i + 1
    end
  end
  filePos2[1] = R.i32(R.ftell(G_Frain.file))
  do
    i = 0
    while (i < G_Nobjects[GAGE]) do
      do
        if ((G.ErrorCode ~= 0) or (G_Gage[i].dataSource ~= RAIN_FILE)) then
          goto continue3
        end
        if (F.rainFileConflict(i) ~= 0) then
          break
        end
        R.fseek(G_Frain.file, filePos2[1], 0)
        if (F.addGageToRainFile(i) ~= 0) then
          filePos3[1] = R.i32(R.ftell(G_Frain.file))
          R.fseek(G_Frain.file, filePos1, 0)
          F.sstrncpy(staID, G_Gage[i].staID, 1024)
          interval[1] = G.Interval
          R.fwrite_arr("c", staID, 0, (1024 + 1), G_Frain.file)
          R.fwrite1("i", 4, interval[1], G_Frain.file)
          R.fwrite1("i", 4, filePos2[1], G_Frain.file)
          R.fwrite1("i", 4, filePos3[1], G_Frain.file)
          filePos1 = R.i32(R.ftell(G_Frain.file))
          filePos2[1] = filePos3[1]
          F.report_writeRainStats(i, G.RainStats)
        end
      end
      ::continue3::
      i = i + 1
    end
  end
  if (G.ErrorCode ~= 0) then
    R.fclose(G_Frain.file)
    G_Frain.file = (nil)
    R.remove(G_Frain.name)
  end
end

-- rain.c:278
F.rainFileConflict = function(i)
  local G_Gage = G.Gage
  local j = 0
  local staID = G_Gage[i].staID
  local fname = G_Gage[i].fname
  do
    j = 0
    while (j < i) do
      do
        if ((F.strcomp(G_Gage[j].staID, staID) ~= 0) and (not (F.strcomp(G_Gage[j].fname, fname) ~= 0))) then
          F.report_writeErrorMsg(ERR_RAIN_FILE_CONFLICT, G_Gage[i].ID)
          do return 1 end
        end
      end
      j = j + 1
    end
  end
  do return 0 end
end

-- rain.c:302
F.addGageToRainFile = function(i)
  local G_Gage = G.Gage
  local f = nil
  local fileFormat = 0
  local hdrLines = {0}
  G.StationID = (nil)
  f = R.fopen(G_Gage[i].fname, S[13])
  if ((f) == (nil)) then
    F.report_writeErrorMsg(ERR_RAIN_FILE_DATA, G_Gage[i].fname)
  else
    fileFormat = F.findFileFormat(f, i, hdrLines, 1)
    if (fileFormat == UNKNOWN_FORMAT) then
      F.report_writeErrorMsg(ERR_RAIN_FILE_FORMAT, G_Gage[i].fname)
    else
      G.GageIndex = i
      F.readFile(f, fileFormat, hdrLines[1], G_Gage[i].startFileDate, G_Gage[i].endFileDate)
    end
    R.fclose(f)
  end
  if (G.ErrorCode ~= 0) then
    do return 0 end
  else
    do return 1 end
  end
end

-- rain.c:341
F.initRainFile = function()
  local G_Frain, G_Nobjects, G_Gage = G.Frain, G.Nobjects, G.Gage
  local fileStamp = R.bufFrom(S[327], 11)
  local fStamp = R.bufFrom(S[327], 11)
  local i = 0
  local kount = {0}
  local filePos = 0
  if ((G.ErrorCode ~= 0) or (not (G_Frain.file ~= nil))) then
    do return end
  end
  R.rewind(G_Frain.file)
  R.fread_arr("c", fStamp, 0, R.strlen(fileStamp), G_Frain.file)
  if (R.strcmp(fStamp, fileStamp) ~= 0) then
    F.report_writeErrorMsg(ERR_RAIN_IFACE_FORMAT, S[0])
    do return end
  end
  R.fread1("i", 4, kount, 1, G_Frain.file)
  filePos = R.ftell(G_Frain.file)
  do
    i = 0
    while (i < G_Nobjects[GAGE]) do
      do
        if ((G.ErrorCode ~= 0) or (G_Gage[i].dataSource ~= RAIN_FILE)) then
          goto continue1
        end
        R.fseek(G_Frain.file, filePos, 0)
        if ((not (F.findGageInFile(i, kount[1]) ~= 0)) or (G_Gage[i].startFilePos == G_Gage[i].endFilePos)) then
          F.report_writeErrorMsg(ERR_RAIN_FILE_GAGE, G_Gage[i].ID)
        end
      end
      ::continue1::
      i = i + 1
    end
  end
end

-- rain.c:385
F.findGageInFile = function(i, kount)
  local G_Frain, G_Gage = G.Frain, G.Gage
  local k = 0
  local interval = {0}
  local filePos1 = {0}
  local filePos2 = {0}
  local staID = R.bufFrom(S[0], 1025)
  do
    k = 1
    while (k <= kount) do
      do
        R.fread_arr("c", staID, 0, (1024 + 1), G_Frain.file)
        R.fread1("i", 4, interval, 1, G_Frain.file)
        R.fread1("i", 4, filePos1, 1, G_Frain.file)
        R.fread1("i", 4, filePos2, 1, G_Frain.file)
        if (R.strcmp(staID, G_Gage[i].staID) == 0) then
          G_Gage[i].rainType = RAINFALL_VOLUME
          G_Gage[i].rainInterval = interval[1]
          G_Gage[i].startFilePos = filePos1[1]
          G_Gage[i].endFilePos = filePos2[1]
          G_Gage[i].currentFilePos = G_Gage[i].startFilePos
          do return 1 end
        end
      end
      k = k + 1
    end
  end
  do return 0 end
end

-- rain.c:420
F.findFileFormat = function(f, i, hdrLines, hdrLines__k)
  local G_Gage = G.Gage
  local fileFormat = 0
  local lineCount = 0
  local maxCount = 5
  local n = 0
  local div = {0}
  local sn2 = {0}
  local recdType = R.buf(4)
  local elemType = R.buf(5)
  local coopID = R.bufFrom(S[0], 6)
  local line = R.buf(1024)
  local year = {0}
  local month = {0}
  local day = {0}
  local hour = {0}
  local minute = {0}
  local elem = {0}
  local x = {0.0}
  fileFormat = UNKNOWN_FORMAT
  G.hasStationName = 0
  G.UnitsFactor = 1.0
  G.Interval = 0
  hdrLines[hdrLines__k] = 0
  do
    lineCount = 1
    while (lineCount <= maxCount) do
      do
        if R.peq(R.fgets(line, 1024, f), (nil)) then
          do return fileFormat end
        end
        n = R.sscanf(line, S[328], sn2, 1, div, 1, elemType)
        if (n == 3) then
          G.Interval = F.getNWSInterval(elemType)
          G.TimeOffset = G.Interval
          if (G.Interval > 0) then
            fileFormat = NWS_SPACE_DELIMITED
            break
          end
        end
        n = R.sscanf(R.padd(line, 37), S[329], div, 1, elemType, recdType, year, 1)
        if (n == 4) then
          G.Interval = F.getNWSInterval(elemType)
          G.TimeOffset = G.Interval
          if (G.Interval > 0) then
            fileFormat = NWS_SPACE_DELIMITED
            G.hasStationName = 1
            break
          end
        end
        n = R.sscanf(line, S[330], sn2, 1, div, 1, elemType)
        if (n == 3) then
          G.Interval = F.getNWSInterval(elemType)
          G.TimeOffset = G.Interval
          if (G.Interval > 0) then
            fileFormat = NWS_COMMA_DELIMITED
            break
          end
        end
        n = R.sscanf(R.padd(line, 37), S[331], div, 1, elemType, recdType, year, 1)
        if (n == 4) then
          G.Interval = F.getNWSInterval(elemType)
          G.TimeOffset = G.Interval
          if (G.Interval > 0) then
            fileFormat = NWS_COMMA_DELIMITED
            G.hasStationName = 1
            break
          end
        end
        n = R.sscanf(line, S[332], recdType, sn2, 1, div, 1, elemType)
        if (n == 4) then
          G.Interval = F.getNWSInterval(elemType)
          G.TimeOffset = G.Interval
          if (G.Interval > 0) then
            fileFormat = NWS_TAPE
            break
          end
        end
        n = R.sscanf(line, S[333], coopID, sn2, 1)
        if ((n == 2) and (R.strcmp(coopID, S[334]) == 0)) then
          fileFormat = F.findNWSOnlineFormat(f, line)
          break
        end
        n = R.sscanf(line, S[335], sn2, 1, year, 1, month, 1, day, 1, elem, 1)
        if (n == 5) then
          if ((elem[1] == 123) and (R.strlen(line) >= 185)) then
            fileFormat = AES_HLY
            G.Interval = 3600
            G.TimeOffset = G.Interval
            G.UnitsFactor = (1.0 / 25.4)
            break
          end
        end
        n = R.sscanf(line, S[336], sn2, 1, year, 1, month, 1, day, 1, elem, 1)
        if (n == 5) then
          if ((elem[1] == 159) and (R.strlen(line) >= 691)) then
            fileFormat = CMC_FIF
            G.Interval = 900
          elseif ((elem[1] == 123) and (R.strlen(line) >= 186)) then
            fileFormat = CMC_HLY
            G.Interval = 3600
          end
          if ((fileFormat == CMC_FIF) or (fileFormat == CMC_HLY)) then
            G.TimeOffset = G.Interval
            G.UnitsFactor = (1.0 / 25.4)
            break
          end
        end
        if (F.parseStdLine(line, year, 1, month, 1, day, 1, hour, 1, minute, 1, x, 1) ~= 0) then
          fileFormat = STD_SPACE_DELIMITED
          G.RainType = G_Gage[i].rainType
          G.Interval = G_Gage[i].rainInterval
          if (G_Gage[i].rainUnits == SI) then
            G.UnitsFactor = (1.0 / 25.4)
          end
          G.TimeOffset = 0
          G.StationID = G_Gage[i].staID
          break
        end
        hdrLines[hdrLines__k] = hdrLines[hdrLines__k] + 1
      end
      lineCount = lineCount + 1
    end
  end
  if (fileFormat ~= UNKNOWN_FORMAT) then
    G_Gage[i].rainInterval = G.Interval
  end
  do return fileFormat end
end

-- rain.c:584
F.findNWSOnlineFormat = function(f, line)
  local n = 0
  local fileFormat = UNKNOWN_FORMAT
  local str = nil
  R.rewind(f)
  R.fgets(line, 1024, f)
  str = R.strstr(line, S[337])
  if not R.peq((str), (nil)) then
    G.Interval = 3600
    G.TimeOffset = G.Interval
    G.ValueOffset = R.i32(((str.o - line.o)))
    fileFormat = NWS_ONLINE_60
  else
    str = R.strstr(line, S[338])
    if not R.peq((str), (nil)) then
      G.Interval = 900
      G.TimeOffset = G.Interval
      G.ValueOffset = R.i32(((str.o - line.o)))
      fileFormat = NWS_ONLINE_15
    else
      do return UNKNOWN_FORMAT end
    end
  end
  do
    n = 1
    while (n <= 5) do
      do
        if R.peq(R.fgets(line, 1024, f), (nil)) then
          do return UNKNOWN_FORMAT end
        end
        if R.peq(R.strstr(line, S[334]), (nil)) then
          goto continue1
        end
        str = R.strrchr(line, 58)
        if R.peq(str, (nil)) then
          do return UNKNOWN_FORMAT end
        end
        n = R.i32(((str.o - line.o)))
        G.DataOffset = (n - 11)
        do return fileFormat end
      end
      ::continue1::
      n = n + 1
    end
  end
  do return UNKNOWN_FORMAT end
end

-- rain.c:641
F.getNWSInterval = function(elemType)
  if (R.strcmp(elemType, S[337]) == 0) then
    do return 3600 end
  elseif (R.strcmp(elemType, S[338]) == 0) then
    do return 900 end
  elseif (R.strcmp(elemType, S[339]) == 0) then
    do return 900 end
  else
    do return 0 end
  end
end

-- rain.c:656
F.readFile = function(f, fileFormat, hdrLines, day1, day2)
  local line = R.buf(1024)
  local i = 0
  local n = 0
  R.rewind(f)
  G.RainStats.startDate = ((-693594) * 1.0)
  G.RainStats.endDate = ((-693594) * 1.0)
  G.RainStats.periodsRain = 0
  G.RainStats.periodsMissing = 0
  G.RainStats.periodsMalfunc = 0
  G.RainAccum = R.f32(0.0)
  G.AccumStartDate = ((-693594) * 1.0)
  G.PreviousDate = ((-693594) * 1.0)
  do
    i = 1
    while (i <= hdrLines) do
      do
        if R.peq(R.fgets(line, 1024, f), (nil)) then
          do return end
        end
      end
      i = i + 1
    end
  end
  while not R.peq(R.fgets(line, 1024, f), (nil)) do
    do
      do
        local __sw1 = fileFormat
        if __sw1 < NWS_ONLINE_15 then
          if __sw1 < NWS_COMMA_DELIMITED then
            if __sw1 == NWS_TAPE then goto case5
            elseif __sw1 == NWS_SPACE_DELIMITED then goto case5
            end
          else
            if __sw1 == NWS_COMMA_DELIMITED then goto case5
            elseif __sw1 == NWS_ONLINE_60 then goto case5
            end
          end
        else
          if __sw1 < CMC_HLY then
            if __sw1 == NWS_ONLINE_15 then goto case5
            elseif __sw1 == AES_HLY then goto case6
            end
          else
            if __sw1 == CMC_HLY then goto case6
            elseif __sw1 == CMC_FIF then goto case6
            elseif __sw1 == STD_SPACE_DELIMITED then goto case4
            end
          end
        end
        goto case7
        ::case4::
        do
          n = F.readStdLine(line, day1, day2)
          goto swend3
        end
        ::case5::
        do
          n = F.readNWSLine(line, fileFormat, day1, day2)
          goto swend3
        end
        ::case6::
        do
          n = F.readCMCLine(line, fileFormat, day1, day2)
          goto swend3
        end
        ::case7::
        do
          n = (-1)
          goto swend3
        end
        ::swend3::
      end
      if (n < 0) then
        break
      end
    end
  end
end

-- rain.c:717
F.readNWSLine = function(line, fileFormat, day1, day2)
  local flag1 = {0}
  local flag2 = {0}
  local isMissing = 0
  local date1 = 0.0
  local result = 1
  local k = 0
  local y = {0}
  local m = {0}
  local d = {0}
  local n = {0}
  local hour = {0}
  local minute = {0}
  local v = {0}
  local x = 0.0
  local lineLength = (R.i32(R.strlen(line)) - 1)
  local nameLength = 0
  do
    local __sw1 = fileFormat
    if __sw1 == NWS_TAPE then goto case2
    elseif __sw1 == NWS_SPACE_DELIMITED then goto case3
    elseif __sw1 == NWS_COMMA_DELIMITED then goto case4
    elseif __sw1 == NWS_ONLINE_60 or __sw1 == NWS_ONLINE_15 then goto case5
    else goto case6 end
    ::case2::
    do
      if (lineLength <= 30) then
        do return 0 end
      end
      if (R.sscanf(R.padd(line, 17), S[340], y, 1, m, 1, d, 1, n, 1) < 4) then
        do return 0 end
      end
      k = 30
      goto swend1
    end
    ::case3::
    do
      if (G.hasStationName ~= 0) then
        nameLength = 31
      end
      if (lineLength <= (28 + nameLength)) then
        do return 0 end
      end
      k = (18 + nameLength)
      if (R.sscanf(R.padd(line, k), S[341], y, 1, m, 1, d, 1) < 3) then
        do return 0 end
      end
      k = (k + 10)
      goto swend1
    end
    ::case4::
    do
      if (lineLength <= 28) then
        do return 0 end
      end
      if (R.sscanf(R.padd(line, 18), S[342], y, 1, m, 1, d, 1) < 3) then
        do return 0 end
      end
      k = 28
      goto swend1
    end
    ::case5::
    do
      if (lineLength <= (G.DataOffset + 23)) then
        do return 0 end
      end
      if (R.sscanf(R.padd(line, G.DataOffset), S[27], y, 1, m, 1, d, 1) < 3) then
        do return 0 end
      end
      k = (G.DataOffset + 8)
      goto swend1
    end
    ::case6::
    do
      do return 0 end
    end
    ::swend1::
  end
  date1 = F.datetime_encodeDate(y[1], m[1], d[1])
  if ((day1 ~= ((-693594) * 1.0)) and (date1 < day1)) then
    do return 0 end
  end
  if ((day2 ~= ((-693594) * 1.0)) and (date1 > day2)) then
    do return (-1) end
  end
  while (k < lineLength) do
    do
      flag1[1] = 0
      flag2[1] = 0
      v[1] = 99999
      hour[1] = 25
      minute[1] = 0
      do
        local __sw2 = fileFormat
        if __sw2 == NWS_TAPE then goto case9
        elseif __sw2 == NWS_SPACE_DELIMITED then goto case10
        elseif __sw2 == NWS_COMMA_DELIMITED then goto case11
        elseif __sw2 == NWS_ONLINE_60 or __sw2 == NWS_ONLINE_15 then goto case12
        else goto case13 end
        ::case9::
        do
          n[1] = R.sscanf(R.padd(line, k), S[343], hour, 1, minute, 1, v, 1, flag1, 1, flag2, 1)
          k = (k + 12)
          goto swend8
        end
        ::case10::
        do
          n[1] = R.sscanf(R.padd(line, k), S[344], hour, 1, minute, 1, v, 1, flag1, 1, flag2, 1)
          k = (k + 16)
          goto swend8
        end
        ::case11::
        do
          n[1] = R.sscanf(R.padd(line, k), S[345], hour, 1, minute, 1, v, 1, flag1, 1, flag2, 1)
          k = (k + 16)
          goto swend8
        end
        ::case12::
        do
          n[1] = R.sscanf(R.padd(line, k), S[346], hour, 1, minute, 1)
          local __c3 = R.buf(2); R.cset(__c3, 0, flag1[1])
          n[1] = (n[1] + (F.readNwsOnlineValue(R.padd(line, G.ValueOffset), v, 1, __c3)))
          flag1[1] = __c3.b[0]
          if (hour[1] == 0) then
            hour[1] = 24
            date1 = (date1 - 1.0)
          end
          k = (k + lineLength)
          goto swend8
        end
        ::case13::
        do
          n[1] = 0
        end
        ::swend8::
      end
      if ((n[1] < 3) or (hour[1] >= 25)) then
        break
      end
      F.setCondition(flag1[1])
      if (((G.Condition == DELETED_PERIOD) or (G.Condition == MISSING_PERIOD)) or (flag1[1] == 77)) then
        isMissing = 1
      elseif (v[1] >= 9999) then
        isMissing = 1
      else
        isMissing = 0
      end
      if (flag1[1] == 97) then
        G.AccumStartDate = (date1 + F.datetime_encodeTime(hour[1], minute[1], 0))
      elseif (flag1[1] == 65) then
        F.saveAccumRainfall(date1, hour[1], minute[1], v[1])
      else
        x = R.f32(R.f32((v[1] * 1.0)) / 100.0)
        if ((x > R.f32(0.0)) or (isMissing ~= 0)) then
          F.saveRainfall(date1, hour[1], minute[1], x, isMissing)
        end
      end
      if (((flag1[1] == 65) or (flag1[1] == 125)) or (flag1[1] == 93)) then
        G.Condition = 0
      end
    end
  end
  do return R.i32(result) end
end

-- rain.c:862
F.readNwsOnlineValue = function(s, v, v__k, flag)
  local n = 0
  local x = {99.98999786376953}
  if (R.strchr(s, 46) ~= nil) then
    n = R.sscanf(s, S[347], R.FLOAT, x, 1, flag)
    v[v__k] = R.D2L((R.f32(R.f32(100.0 * x[1]) + 0.5)))
  else
    n = R.sscanf(s, S[348], v, v__k, flag)
  end
  do return n end
end

-- rain.c:891
F.setCondition = function(flag)
  do
    local __sw1 = flag
    if __sw1 < 97 then
      if __sw1 == 65 then goto case2
      elseif __sw1 == 91 then goto case4
      elseif __sw1 == 93 then goto case4
      end
    else
      if __sw1 == 97 then goto case2
      elseif __sw1 == 123 then goto case3
      elseif __sw1 == 125 then goto case3
      end
    end
    goto case5
    ::case2::
    do
      G.Condition = ACCUMULATED_PERIOD
      goto swend1
    end
    ::case3::
    do
      G.Condition = DELETED_PERIOD
      goto swend1
    end
    ::case4::
    do
      G.Condition = MISSING_PERIOD
      goto swend1
    end
    ::case5::
    do
      G.Condition = NO_CONDITION
    end
    ::swend1::
  end
end

-- rain.c:914
F.readCMCLine = function(line, fileFormat, day1, day2)
  local flag = {0}
  local isMissing = 0
  local date1 = 0.0
  local sn = {0}
  local v = {0}
  local col = 0
  local j = 0
  local jMax = 0
  local elem = {0}
  local y = {0}
  local m = {0}
  local d = {0}
  local hour = 0
  local minute = 0
  local x = 0.0
  if (fileFormat == AES_HLY) then
    if (R.sscanf(line, S[335], sn, 1, y, 1, m, 1, d, 1, elem, 1) < 5) then
      do return 0 end
    end
    if (y[1] < 100) then
      y[1] = (y[1] + 2000)
    else
      y[1] = (y[1] + 1000)
    end
    col = 17
  else
    if (R.sscanf(line, S[336], sn, 1, y, 1, m, 1, d, 1, elem, 1) < 5) then
      do return 0 end
    end
    col = 18
  end
  date1 = F.datetime_encodeDate(y[1], m[1], d[1])
  if ((day1 ~= ((-693594) * 1.0)) and (date1 < day1)) then
    do return 0 end
  end
  if ((day2 ~= ((-693594) * 1.0)) and (date1 > day2)) then
    do return (-1) end
  end
  if ((fileFormat == AES_HLY) and (elem[1] ~= 123)) then
    do return 0 end
  elseif ((fileFormat == CMC_FIF) and (elem[1] ~= 159)) then
    do return 0 end
  elseif ((fileFormat == CMC_HLY) and (elem[1] ~= 123)) then
    do return 0 end
  end
  hour = 0
  minute = 0
  jMax = 24
  if (fileFormat == CMC_FIF) then
    jMax = 96
  end
  do
    j = 1
    while (j <= jMax) do
      do
        if (R.sscanf(R.padd(line, col), S[349], v, 1, flag, 1) < 2) then
          do return 0 end
        end
        col = (col + 7)
        if (v[1] == (-99999)) then
          isMissing = 1
        else
          isMissing = 0
        end
        x = R.f32(((((v[1] * 1.0) / 10.0) / 25.4)))
        if ((x > R.f32(0.0)) or (isMissing ~= 0)) then
          F.saveRainfall(date1, hour, minute, x, isMissing)
        end
        if (fileFormat == CMC_FIF) then
          minute = (minute + 15)
          if (minute == 60) then
            minute = 0
            hour = hour + 1
          end
        else
          hour = hour + 1
        end
      end
      j = j + 1
    end
  end
  do return 1 end
end

-- rain.c:994
F.readStdLine = function(line, day1, day2)
  local date1 = 0.0
  local date2 = 0.0
  local year = {0}
  local month = {0}
  local day = {0}
  local hour = {0}
  local minute = {0}
  local x = {0.0}
  if (not (F.parseStdLine(line, year, 1, month, 1, day, 1, hour, 1, minute, 1, x, 1) ~= 0)) then
    do return 0 end
  end
  date1 = F.datetime_encodeDate(year[1], month[1], day[1])
  if ((day1 ~= ((-693594) * 1.0)) and (date1 < day1)) then
    do return 0 end
  end
  if ((day2 ~= ((-693594) * 1.0)) and (date1 > day2)) then
    do return (-1) end
  end
  date2 = (date1 + F.datetime_encodeTime(hour[1], minute[1], 0))
  if (date2 <= G.PreviousDate) then
    F.report_writeErrorMsg(ERR_RAIN_FILE_SEQUENCE, G.Gage[G.GageIndex].fname)
    F.report_writeLine(line)
    do return (-1) end
  end
  G.PreviousDate = date2
  do
    local __sw1 = G.RainType
    if __sw1 == RAINFALL_INTENSITY then goto case2
    elseif __sw1 == CUMULATIVE_RAINFALL then goto case3
    else goto swend1 end
    ::case2::
    do
      x[1] = R.f32(R.f32(x[1] * R.f32((G.Interval * 1.0))) / 3600.0)
      goto swend1
    end
    ::case3::
    do
      if (x[1] >= G.RainAccum) then
        x[1] = R.f32(x[1] - G.RainAccum)
        G.RainAccum = R.f32(G.RainAccum + x[1])
      else
        G.RainAccum = x[1]
      end
      goto swend1
    end
    ::swend1::
  end
  x[1] = R.f32(x[1] * (R.f32(G.UnitsFactor)))
  F.saveRainfall(date1, hour[1], minute[1], x[1], 0)
  do return 1 end
end

-- rain.c:1052
F.parseStdLine = function(line, year, year__k, month, month__k, day, day__k, hour, hour__k, minute, minute__k, value, value__k)
  local G_StationID = G.StationID
  local n = 0
  local token = R.buf(1024)
  n = R.sscanf(line, S[350], token, year, year__k, month, month__k, day, day__k, hour, hour__k, minute, minute__k, R.FLOAT, value, value__k)
  if (n < 7) then
    do return 0 end
  end
  if ((not R.peq(G_StationID, (nil))) and (not (F.strcomp(token, G_StationID) ~= 0))) then
    do return 0 end
  end
  do return 1 end
end

-- rain.c:1078
F.saveAccumRainfall = function(date1, hour, minute, v)
  local G_Frain = G.Frain
  local date2 = {0.0}
  local n = 0
  local j = 0
  local x = {0.0}
  if (G.AccumStartDate == ((-693594) * 1.0)) then
    do return end
  end
  date2[1] = (date1 + F.datetime_encodeTime(hour, minute, 0))
  n = R.i32(((R.idiv(F.datetime_timeDiff(date2[1], G.AccumStartDate), G.Interval)) + 1))
  if (v == 99999) then
    G.RainStats.periodsMissing = (G.RainStats.periodsMissing + n)
    do return end
  end
  G.RainStats.periodsRain = (G.RainStats.periodsRain + n)
  x[1] = R.f32(R.f32(R.f32((v * 1.0)) / R.f32((n * 1.0))) / 100.0)
  if (x[1] > 0.0) then
    date2[1] = F.datetime_addSeconds(G.AccumStartDate, ((-G.TimeOffset) * 1.0))
    if (G.RainStats.startDate == ((-693594) * 1.0)) then
      G.RainStats.startDate = date2[1]
    end
    do
      j = 0
      while (j < n) do
        do
          R.fwrite1("d", 8, date2[1], G_Frain.file)
          R.fwrite1("f", 4, x[1], G_Frain.file)
          date2[1] = F.datetime_addSeconds(date2[1], (G.Interval * 1.0))
          G.RainStats.endDate = date2[1]
        end
        j = j + 1
      end
    end
  end
  G.AccumStartDate = ((-693594) * 1.0)
end

-- rain.c:1133
F.saveRainfall = function(date1, hour, minute, x, isMissing)
  x = {x}
  local G_Frain = G.Frain
  local date2 = {0.0}
  local seconds = 0
  if (isMissing ~= 0) then
    G.RainStats.periodsMissing = G.RainStats.periodsMissing + 1
  else
    G.RainStats.periodsRain = G.RainStats.periodsRain + 1
  end
  if (not (isMissing ~= 0)) then
    seconds = (((3600 * hour) + (60 * minute)) - G.TimeOffset)
    date2[1] = F.datetime_addSeconds(date1, (seconds * 1.0))
    R.fwrite1("d", 8, date2[1], G_Frain.file)
    R.fwrite1("f", 4, x[1], G_Frain.file)
    if (G.RainStats.startDate == ((-693594) * 1.0)) then
      G.RainStats.startDate = date2[1]
    end
    G.RainStats.endDate = date2[1]
  end
end

