-- Generated from EPA SWMM 5.2.4 (input.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local MAX_OBJ_TYPES <const> = 18
local ERR_KEYWORD <const> = 205
local s_OPTION <const> = 1
local ERR_INPUT <const> = 200
local TSERIES <const> = 8
local ERR_LINE_LENGTH <const> = 201
local s_TRANSECT <const> = 22
local TRANSECT <const> = 10
local s_RAINGAGE <const> = 3
local s_SUBCATCH <const> = 6
local s_AQUIFER <const> = 9
local s_UNITHYD <const> = 34
local s_SNOWMELT <const> = 11
local s_JUNCTION <const> = 12
local s_OUTFALL <const> = 13
local s_STORAGE <const> = 14
local s_DIVIDER <const> = 15
local s_CONDUIT <const> = 16
local s_PUMP <const> = 17
local s_ORIFICE <const> = 18
local s_WEIR <const> = 19
local s_OUTLET <const> = 20
local s_POLLUTANT <const> = 25
local s_LANDUSE <const> = 26
local s_PATTERN <const> = 32
local s_CURVE <const> = 37
local s_TIMESERIES <const> = 38
local s_CONTROL <const> = 24
local s_LID_CONTROL <const> = 49
local s_EVENT <const> = 53
local s_STREET <const> = 54
local s_INLET <const> = 56
local GAGE <const> = 0
local ERR_DUP_NAME <const> = 207
local SUBCATCH <const> = 1
local AQUIFER <const> = 11
local UNITHYD <const> = 12
local SNOWMELT <const> = 13
local NODE <const> = 2
local JUNCTION <const> = 0
local OUTFALL <const> = 1
local STORAGE <const> = 2
local DIVIDER <const> = 3
local LINK <const> = 3
local CONDUIT <const> = 0
local PUMP <const> = 1
local ORIFICE <const> = 2
local WEIR <const> = 3
local OUTLET <const> = 4
local POLLUT <const> = 4
local LANDUSE <const> = 5
local TIMEPATTERN <const> = 6
local CURVE <const> = 7
local SHAPE_CURVE <const> = 5
local SHAPE <const> = 14
local CONTROL <const> = 9
local LID <const> = 15
local STREET <const> = 16
local INLET <const> = 17
local s_TITLE <const> = 0
local s_TEMP <const> = 4
local s_EVAP <const> = 5
local s_ADJUST <const> = 52
local s_SUBAREA <const> = 7
local s_INFIL <const> = 8
local s_GROUNDWATER <const> = 10
local s_GWF <const> = 51
local s_XSECTION <const> = 21
local s_LOSSES <const> = 23
local s_BUILDUP <const> = 27
local s_WASHOFF <const> = 28
local s_COVERAGE <const> = 29
local s_INFLOW <const> = 30
local s_DWF <const> = 31
local s_RDII <const> = 33
local s_LOADING <const> = 35
local s_TREATMENT <const> = 36
local s_REPORT <const> = 39
local s_FILE <const> = 2
local s_LID_USAGE <const> = 50
local s_INLET_USAGE <const> = 55
local ERR_ITEMS <const> = 203
local ERR_RULE <const> = 217
local ERR_DATETIME <const> = 213
local _ENV = R.strict

G.MAXERRS = 100
G.Tok = {}
G.Ntokens = 0
G.Mobjects = R.fill(18, 0)
G.Mnodes = R.fill(5, 0)
G.Mlinks = R.fill(5, 0)
G.Mevents = 0

-- input.c:69
F.input_countObjects = function()
  local G_Nobjects, G_Nnodes, G_Nlinks, G_Finp, G_SectWords = G.Nobjects, G.Nnodes, G.Nlinks, G.Finp, G.SectWords
  local line = R.buf(1025)
  local wLine = R.buf(1025)
  local tok = nil
  local sect = (-1)
  local newsect = 0
  local errcode = 0
  local errsum = 0
  local i = 0
  local lineCount = 0
  if (G.ErrorCode ~= 0) then
    do return G.ErrorCode end
  end
  F.error_setInpError(0, S[0])
  do
    i = 0
    while (i < MAX_OBJ_TYPES) do
      do
        G_Nobjects[i] = 0
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < 5) do
      do
        G_Nnodes[i] = 0
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < 5) do
      do
        G_Nlinks[i] = 0
      end
      i = i + 1
    end
  end
  F.controls_init()
  while not R.peq(R.fgets(line, 1024, G_Finp.file), (nil)) do
    do
      lineCount = lineCount + 1
      F.sstrncpy(wLine, line, 1024)
      tok = R.strtok(wLine, S[184])
      if R.peq(tok, (nil)) then
        goto continue4
      end
      if (tok.b[tok.o] == 59) then
        goto continue4
      end
      if (tok.b[tok.o] == 91) then
        newsect = F.findmatch(tok, G_SectWords)
        if (newsect >= 0) then
          sect = newsect
          goto continue4
        else
          sect = (-1)
          errcode = ERR_KEYWORD
        end
      end
      if (sect == s_OPTION) then
        errcode = F.readOption(line)
      elseif (sect >= 0) then
        errcode = F.addObject(sect, tok)
      end
      if (errcode ~= 0) then
        F.report_writeInputErrorMsg(errcode, sect, line, lineCount)
        errsum = errsum + 1
        if (errsum >= G.MAXERRS) then
          break
        end
      end
    end
    ::continue4::
  end
  if (errsum > 0) then
    G.ErrorCode = ERR_INPUT
  end
  do return G.ErrorCode end
end

-- input.c:141
F.input_readData = function()
  local G_Mobjects, G_Mnodes, G_Mlinks, G_Nobjects, G_Tseries, G_Finp = G.Mobjects, G.Mnodes, G.Mlinks, G.Nobjects, G.Tseries, G.Finp
  local G_Tok, G_SectWords = G.Tok, G.SectWords
  local line = R.buf(1025)
  local wLine = R.buf(1025)
  local comment = nil
  local sect = 0
  local newsect = 0
  local inperr = 0
  local errsum = 0
  local lineLength = 0
  local i = 0
  local lineCount = 0
  if (G.ErrorCode ~= 0) then
    do return G.ErrorCode end
  end
  F.error_setInpError(0, S[0])
  do
    i = 0
    while (i < MAX_OBJ_TYPES) do
      do
        G_Mobjects[i] = 0
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < 5) do
      do
        G_Mnodes[i] = 0
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < 5) do
      do
        G_Mlinks[i] = 0
      end
      i = i + 1
    end
  end
  G.Mevents = 0
  do
    i = 0
    while (i < G_Nobjects[TSERIES]) do
      do
        G_Tseries[i].lastDate = (G.StartDate + G.StartTime)
      end
      i = i + 1
    end
  end
  sect = 0
  errsum = 0
  R.rewind(G_Finp.file)
  while not R.peq(R.fgets(line, 1024, G_Finp.file), (nil)) do
    do
      lineCount = lineCount + 1
      F.sstrncpy(wLine, line, 1024)
      G.Ntokens = F.getTokens(wLine)
      if (G.Ntokens == 0) then
        goto continue5
      end
      if (G_Tok[0].b[G_Tok[0].o] == 59) then
        goto continue5
      end
      lineLength = R.i32(R.strlen(line))
      if (lineLength >= 1024) then
        comment = R.strchr(line, 59)
        if (comment ~= nil) then
          lineLength = R.i32(((comment.o - line.o)))
        end
        if (lineLength >= 1024) then
          inperr = ERR_LINE_LENGTH
          F.report_writeInputErrorMsg(inperr, sect, line, lineCount)
          errsum = errsum + 1
        end
      end
      if (G_Tok[0].b[G_Tok[0].o] == 91) then
        newsect = F.findmatch(G_Tok[0], G_SectWords)
        if (newsect >= 0) then
          if (sect == s_TRANSECT) then
            F.transect_validate((G_Nobjects[TRANSECT] - 1))
          end
          sect = newsect
          goto continue5
        else
          inperr = F.error_setInpError(ERR_KEYWORD, G_Tok[0])
          F.report_writeInputErrorMsg(inperr, sect, line, lineCount)
          errsum = errsum + 1
          break
        end
      else
        inperr = F.parseLine(sect, line)
        if (inperr > 0) then
          errsum = errsum + 1
          if (errsum > G.MAXERRS) then
            F.report_writeLine(S[201])
          else
            F.report_writeInputErrorMsg(inperr, sect, line, lineCount)
          end
        end
      end
      if (errsum > G.MAXERRS) then
        break
      end
    end
    ::continue5::
  end
  if (errsum > 0) then
    G.ErrorCode = ERR_INPUT
  end
  do return G.ErrorCode end
end

-- input.c:251
F.addObject = function(objType, id)
  local G_Nobjects, G_Nnodes, G_Nlinks = G.Nobjects, G.Nnodes, G.Nlinks
  local errcode = 0
  do
    local __sw1 = objType
    if __sw1 < s_OUTLET then
      if __sw1 < s_STORAGE then
        if __sw1 < s_SNOWMELT then
          if __sw1 == s_RAINGAGE then goto case2
          elseif __sw1 == s_SUBCATCH then goto case3
          elseif __sw1 == s_AQUIFER then goto case4
          end
        else
          if __sw1 == s_SNOWMELT then goto case6
          elseif __sw1 == s_JUNCTION then goto case7
          elseif __sw1 == s_OUTFALL then goto case8
          end
        end
      else
        if __sw1 < s_PUMP then
          if __sw1 == s_STORAGE then goto case9
          elseif __sw1 == s_DIVIDER then goto case10
          elseif __sw1 == s_CONDUIT then goto case11
          end
        else
          if __sw1 == s_PUMP then goto case12
          elseif __sw1 == s_ORIFICE then goto case13
          elseif __sw1 == s_WEIR then goto case14
          end
        end
      end
    else
      if __sw1 < s_UNITHYD then
        if __sw1 < s_POLLUTANT then
          if __sw1 == s_OUTLET then goto case15
          elseif __sw1 == s_TRANSECT then goto case22
          elseif __sw1 == s_CONTROL then goto case21
          end
        else
          if __sw1 == s_POLLUTANT then goto case16
          elseif __sw1 == s_LANDUSE then goto case17
          elseif __sw1 == s_PATTERN then goto case18
          end
        end
      else
        if __sw1 < s_LID_CONTROL then
          if __sw1 == s_UNITHYD then goto case5
          elseif __sw1 == s_CURVE then goto case19
          elseif __sw1 == s_TIMESERIES then goto case20
          end
        else
          if __sw1 < s_STREET then
            if __sw1 == s_LID_CONTROL then goto case23
            elseif __sw1 == s_EVENT then goto case24
            end
          else
            if __sw1 == s_STREET then goto case25
            elseif __sw1 == s_INLET then goto case26
            end
          end
        end
      end
    end
    goto swend1
    ::case2::
    do
      if (not (F.project_addObject(GAGE, id, G_Nobjects[GAGE]) ~= 0)) then
        errcode = F.error_setInpError(ERR_DUP_NAME, id)
      end
      G_Nobjects[GAGE] = G_Nobjects[GAGE] + 1
      goto swend1
    end
    ::case3::
    do
      if (not (F.project_addObject(SUBCATCH, id, G_Nobjects[SUBCATCH]) ~= 0)) then
        errcode = F.error_setInpError(ERR_DUP_NAME, id)
      end
      G_Nobjects[SUBCATCH] = G_Nobjects[SUBCATCH] + 1
      goto swend1
    end
    ::case4::
    do
      if (not (F.project_addObject(AQUIFER, id, G_Nobjects[AQUIFER]) ~= 0)) then
        errcode = F.error_setInpError(ERR_DUP_NAME, id)
      end
      G_Nobjects[AQUIFER] = G_Nobjects[AQUIFER] + 1
      goto swend1
    end
    ::case5::
    do
      if (F.project_findObject(UNITHYD, id) < 0) then
        if (not (F.project_addObject(UNITHYD, id, G_Nobjects[UNITHYD]) ~= 0)) then
          errcode = F.error_setInpError(ERR_DUP_NAME, id)
        end
        G_Nobjects[UNITHYD] = G_Nobjects[UNITHYD] + 1
      end
      goto swend1
    end
    ::case6::
    do
      if (F.project_findObject(SNOWMELT, id) < 0) then
        if (not (F.project_addObject(SNOWMELT, id, G_Nobjects[SNOWMELT]) ~= 0)) then
          errcode = F.error_setInpError(ERR_DUP_NAME, id)
        end
        G_Nobjects[SNOWMELT] = G_Nobjects[SNOWMELT] + 1
      end
      goto swend1
    end
    ::case7::
    do
      if (not (F.project_addObject(NODE, id, G_Nobjects[NODE]) ~= 0)) then
        errcode = F.error_setInpError(ERR_DUP_NAME, id)
      end
      G_Nobjects[NODE] = G_Nobjects[NODE] + 1
      G_Nnodes[JUNCTION] = G_Nnodes[JUNCTION] + 1
      goto swend1
    end
    ::case8::
    do
      if (not (F.project_addObject(NODE, id, G_Nobjects[NODE]) ~= 0)) then
        errcode = F.error_setInpError(ERR_DUP_NAME, id)
      end
      G_Nobjects[NODE] = G_Nobjects[NODE] + 1
      G_Nnodes[OUTFALL] = G_Nnodes[OUTFALL] + 1
      goto swend1
    end
    ::case9::
    do
      if (not (F.project_addObject(NODE, id, G_Nobjects[NODE]) ~= 0)) then
        errcode = F.error_setInpError(ERR_DUP_NAME, id)
      end
      G_Nobjects[NODE] = G_Nobjects[NODE] + 1
      G_Nnodes[STORAGE] = G_Nnodes[STORAGE] + 1
      goto swend1
    end
    ::case10::
    do
      if (not (F.project_addObject(NODE, id, G_Nobjects[NODE]) ~= 0)) then
        errcode = F.error_setInpError(ERR_DUP_NAME, id)
      end
      G_Nobjects[NODE] = G_Nobjects[NODE] + 1
      G_Nnodes[DIVIDER] = G_Nnodes[DIVIDER] + 1
      goto swend1
    end
    ::case11::
    do
      if (not (F.project_addObject(LINK, id, G_Nobjects[LINK]) ~= 0)) then
        errcode = F.error_setInpError(ERR_DUP_NAME, id)
      end
      G_Nobjects[LINK] = G_Nobjects[LINK] + 1
      G_Nlinks[CONDUIT] = G_Nlinks[CONDUIT] + 1
      goto swend1
    end
    ::case12::
    do
      if (not (F.project_addObject(LINK, id, G_Nobjects[LINK]) ~= 0)) then
        errcode = F.error_setInpError(ERR_DUP_NAME, id)
      end
      G_Nobjects[LINK] = G_Nobjects[LINK] + 1
      G_Nlinks[PUMP] = G_Nlinks[PUMP] + 1
      goto swend1
    end
    ::case13::
    do
      if (not (F.project_addObject(LINK, id, G_Nobjects[LINK]) ~= 0)) then
        errcode = F.error_setInpError(ERR_DUP_NAME, id)
      end
      G_Nobjects[LINK] = G_Nobjects[LINK] + 1
      G_Nlinks[ORIFICE] = G_Nlinks[ORIFICE] + 1
      goto swend1
    end
    ::case14::
    do
      if (not (F.project_addObject(LINK, id, G_Nobjects[LINK]) ~= 0)) then
        errcode = F.error_setInpError(ERR_DUP_NAME, id)
      end
      G_Nobjects[LINK] = G_Nobjects[LINK] + 1
      G_Nlinks[WEIR] = G_Nlinks[WEIR] + 1
      goto swend1
    end
    ::case15::
    do
      if (not (F.project_addObject(LINK, id, G_Nobjects[LINK]) ~= 0)) then
        errcode = F.error_setInpError(ERR_DUP_NAME, id)
      end
      G_Nobjects[LINK] = G_Nobjects[LINK] + 1
      G_Nlinks[OUTLET] = G_Nlinks[OUTLET] + 1
      goto swend1
    end
    ::case16::
    do
      if (not (F.project_addObject(POLLUT, id, G_Nobjects[POLLUT]) ~= 0)) then
        errcode = F.error_setInpError(ERR_DUP_NAME, id)
      end
      G_Nobjects[POLLUT] = G_Nobjects[POLLUT] + 1
      goto swend1
    end
    ::case17::
    do
      if (not (F.project_addObject(LANDUSE, id, G_Nobjects[LANDUSE]) ~= 0)) then
        errcode = F.error_setInpError(ERR_DUP_NAME, id)
      end
      G_Nobjects[LANDUSE] = G_Nobjects[LANDUSE] + 1
      goto swend1
    end
    ::case18::
    do
      if (F.project_findObject(TIMEPATTERN, id) < 0) then
        if (not (F.project_addObject(TIMEPATTERN, id, G_Nobjects[TIMEPATTERN]) ~= 0)) then
          errcode = F.error_setInpError(ERR_DUP_NAME, id)
        end
        G_Nobjects[TIMEPATTERN] = G_Nobjects[TIMEPATTERN] + 1
      end
      goto swend1
    end
    ::case19::
    do
      if (F.project_findObject(CURVE, id) < 0) then
        if (not (F.project_addObject(CURVE, id, G_Nobjects[CURVE]) ~= 0)) then
          errcode = F.error_setInpError(ERR_DUP_NAME, id)
        end
        G_Nobjects[CURVE] = G_Nobjects[CURVE] + 1
        id = R.strtok((nil), S[184])
        if (F.findmatch(id, G.CurveTypeWords) == SHAPE_CURVE) then
          G_Nobjects[SHAPE] = G_Nobjects[SHAPE] + 1
        end
      end
      goto swend1
    end
    ::case20::
    do
      if (F.project_findObject(TSERIES, id) < 0) then
        if (not (F.project_addObject(TSERIES, id, G_Nobjects[TSERIES]) ~= 0)) then
          errcode = F.error_setInpError(ERR_DUP_NAME, id)
        end
        G_Nobjects[TSERIES] = G_Nobjects[TSERIES] + 1
      end
      goto swend1
    end
    ::case21::
    do
      if (F.match(id, S[202]) ~= 0) then
        G_Nobjects[CONTROL] = G_Nobjects[CONTROL] + 1
      else
        F.controls_addToCount(id)
      end
      goto swend1
    end
    ::case22::
    do
      if (F.match(id, S[203]) ~= 0) then
        id = R.strtok((nil), S[184])
        if (id ~= nil) then
          if (not (F.project_addObject(TRANSECT, id, G_Nobjects[TRANSECT]) ~= 0)) then
            errcode = F.error_setInpError(ERR_DUP_NAME, id)
          end
          G_Nobjects[TRANSECT] = G_Nobjects[TRANSECT] + 1
        end
      end
      goto swend1
    end
    ::case23::
    do
      if (F.project_findObject(LID, id) < 0) then
        if (not (F.project_addObject(LID, id, G_Nobjects[LID]) ~= 0)) then
          errcode = F.error_setInpError(ERR_DUP_NAME, id)
        end
        G_Nobjects[LID] = G_Nobjects[LID] + 1
      end
      goto swend1
    end
    ::case24::
    do
      G.NumEvents = G.NumEvents + 1
      goto swend1
    end
    ::case25::
    do
      if (not (F.project_addObject(STREET, id, G_Nobjects[STREET]) ~= 0)) then
        errcode = F.error_setInpError(ERR_DUP_NAME, id)
      end
      G_Nobjects[STREET] = G_Nobjects[STREET] + 1
      goto swend1
    end
    ::case26::
    do
      if (F.project_findObject(INLET, id) < 0) then
        if (not (F.project_addObject(INLET, id, G_Nobjects[INLET]) ~= 0)) then
          errcode = F.error_setInpError(ERR_DUP_NAME, id)
        end
        G_Nobjects[INLET] = G_Nobjects[INLET] + 1
      end
      goto swend1
    end
    ::swend1::
  end
  do return errcode end
end

-- input.c:464
F.parseLine = function(sect, line)
  local G_Mobjects, G_Tok = G.Mobjects, G.Tok
  local j = 0
  local err = 0
  do
    local __sw1 = sect
    if __sw1 < s_CONTROL then
      if __sw1 < s_JUNCTION then
        if __sw1 < s_SUBCATCH then
          if __sw1 < s_RAINGAGE then
            if __sw1 == s_TITLE then goto case2
            elseif __sw1 == s_FILE then goto case42
            end
          else
            if __sw1 == s_RAINGAGE then goto case3
            elseif __sw1 == s_TEMP then goto case4
            elseif __sw1 == s_EVAP then goto case5
            end
          end
        else
          if __sw1 < s_AQUIFER then
            if __sw1 == s_SUBCATCH then goto case7
            elseif __sw1 == s_SUBAREA then goto case8
            elseif __sw1 == s_INFIL then goto case9
            end
          else
            if __sw1 == s_AQUIFER then goto case10
            elseif __sw1 == s_GROUNDWATER then goto case11
            elseif __sw1 == s_SNOWMELT then goto case13
            end
          end
        end
      else
        if __sw1 < s_ORIFICE then
          if __sw1 < s_DIVIDER then
            if __sw1 == s_JUNCTION then goto case14
            elseif __sw1 == s_OUTFALL then goto case15
            elseif __sw1 == s_STORAGE then goto case16
            end
          else
            if __sw1 == s_DIVIDER then goto case17
            elseif __sw1 == s_CONDUIT then goto case18
            elseif __sw1 == s_PUMP then goto case19
            end
          end
        else
          if __sw1 < s_XSECTION then
            if __sw1 == s_ORIFICE then goto case20
            elseif __sw1 == s_WEIR then goto case21
            elseif __sw1 == s_OUTLET then goto case22
            end
          else
            if __sw1 == s_XSECTION then goto case23
            elseif __sw1 == s_TRANSECT then goto case24
            elseif __sw1 == s_LOSSES then goto case25
            end
          end
        end
      end
    else
      if __sw1 < s_TREATMENT then
        if __sw1 < s_INFLOW then
          if __sw1 < s_BUILDUP then
            if __sw1 == s_CONTROL then goto case40
            elseif __sw1 == s_POLLUTANT then goto case26
            elseif __sw1 == s_LANDUSE then goto case27
            end
          else
            if __sw1 == s_BUILDUP then goto case28
            elseif __sw1 == s_WASHOFF then goto case29
            elseif __sw1 == s_COVERAGE then goto case30
            end
          end
        else
          if __sw1 < s_RDII then
            if __sw1 == s_INFLOW then goto case31
            elseif __sw1 == s_DWF then goto case32
            elseif __sw1 == s_PATTERN then goto case33
            end
          else
            if __sw1 == s_RDII then goto case34
            elseif __sw1 == s_UNITHYD then goto case35
            elseif __sw1 == s_LOADING then goto case36
            end
          end
        end
      else
        if __sw1 < s_GWF then
          if __sw1 < s_REPORT then
            if __sw1 == s_TREATMENT then goto case37
            elseif __sw1 == s_CURVE then goto case38
            elseif __sw1 == s_TIMESERIES then goto case39
            end
          else
            if __sw1 == s_REPORT then goto case41
            elseif __sw1 == s_LID_CONTROL then goto case43
            elseif __sw1 == s_LID_USAGE then goto case44
            end
          end
        else
          if __sw1 < s_STREET then
            if __sw1 == s_GWF then goto case12
            elseif __sw1 == s_ADJUST then goto case6
            elseif __sw1 == s_EVENT then goto case45
            end
          else
            if __sw1 == s_STREET then goto case46
            elseif __sw1 == s_INLET_USAGE then goto case48
            elseif __sw1 == s_INLET then goto case47
            end
          end
        end
      end
    end
    goto case49
    ::case2::
    do
      do return F.readTitle(line) end
    end
    ::case3::
    do
      j = G_Mobjects[GAGE]
      err = F.gage_readParams(j, G_Tok, G.Ntokens)
      G_Mobjects[GAGE] = G_Mobjects[GAGE] + 1
      do return err end
    end
    ::case4::
    do
      do return F.climate_readParams(G_Tok, G.Ntokens) end
    end
    ::case5::
    do
      do return F.climate_readEvapParams(G_Tok, G.Ntokens) end
    end
    ::case6::
    do
      do return F.climate_readAdjustments(G_Tok, G.Ntokens) end
    end
    ::case7::
    do
      j = G_Mobjects[SUBCATCH]
      err = F.subcatch_readParams(j, G_Tok, G.Ntokens)
      G_Mobjects[SUBCATCH] = G_Mobjects[SUBCATCH] + 1
      do return err end
    end
    ::case8::
    do
      do return F.subcatch_readSubareaParams(G_Tok, G.Ntokens) end
    end
    ::case9::
    do
      do return F.infil_readParams(G.InfilModel, G_Tok, G.Ntokens) end
    end
    ::case10::
    do
      j = G_Mobjects[AQUIFER]
      err = F.gwater_readAquiferParams(j, G_Tok, G.Ntokens)
      G_Mobjects[AQUIFER] = G_Mobjects[AQUIFER] + 1
      do return err end
    end
    ::case11::
    do
      do return F.gwater_readGroundwaterParams(G_Tok, G.Ntokens) end
    end
    ::case12::
    do
      do return F.gwater_readFlowExpression(G_Tok, G.Ntokens) end
    end
    ::case13::
    do
      do return F.snow_readMeltParams(G_Tok, G.Ntokens) end
    end
    ::case14::
    do
      do return F.readNode(JUNCTION) end
    end
    ::case15::
    do
      do return F.readNode(OUTFALL) end
    end
    ::case16::
    do
      do return F.readNode(STORAGE) end
    end
    ::case17::
    do
      do return F.readNode(DIVIDER) end
    end
    ::case18::
    do
      do return F.readLink(CONDUIT) end
    end
    ::case19::
    do
      do return F.readLink(PUMP) end
    end
    ::case20::
    do
      do return F.readLink(ORIFICE) end
    end
    ::case21::
    do
      do return F.readLink(WEIR) end
    end
    ::case22::
    do
      do return F.readLink(OUTLET) end
    end
    ::case23::
    do
      do return F.link_readXsectParams(G_Tok, G.Ntokens) end
    end
    ::case24::
    do
      do return F.transect_readParams(G_Mobjects, TRANSECT, G_Tok, G.Ntokens) end
    end
    ::case25::
    do
      do return F.link_readLossParams(G_Tok, G.Ntokens) end
    end
    ::case26::
    do
      j = G_Mobjects[POLLUT]
      err = F.landuse_readPollutParams(j, G_Tok, G.Ntokens)
      G_Mobjects[POLLUT] = G_Mobjects[POLLUT] + 1
      do return err end
    end
    ::case27::
    do
      j = G_Mobjects[LANDUSE]
      err = F.landuse_readParams(j, G_Tok, G.Ntokens)
      G_Mobjects[LANDUSE] = G_Mobjects[LANDUSE] + 1
      do return err end
    end
    ::case28::
    do
      do return F.landuse_readBuildupParams(G_Tok, G.Ntokens) end
    end
    ::case29::
    do
      do return F.landuse_readWashoffParams(G_Tok, G.Ntokens) end
    end
    ::case30::
    do
      do return F.subcatch_readLanduseParams(G_Tok, G.Ntokens) end
    end
    ::case31::
    do
      do return F.inflow_readExtInflow(G_Tok, G.Ntokens) end
    end
    ::case32::
    do
      do return F.inflow_readDwfInflow(G_Tok, G.Ntokens) end
    end
    ::case33::
    do
      do return F.inflow_readDwfPattern(G_Tok, G.Ntokens) end
    end
    ::case34::
    do
      do return F.rdii_readRdiiInflow(G_Tok, G.Ntokens) end
    end
    ::case35::
    do
      do return F.rdii_readUnitHydParams(G_Tok, G.Ntokens) end
    end
    ::case36::
    do
      do return F.subcatch_readInitBuildup(G_Tok, G.Ntokens) end
    end
    ::case37::
    do
      do return F.treatmnt_readExpression(G_Tok, G.Ntokens) end
    end
    ::case38::
    do
      do return F.table_readCurve(G_Tok, G.Ntokens) end
    end
    ::case39::
    do
      do return F.table_readTimeseries(G_Tok, G.Ntokens) end
    end
    ::case40::
    do
      do return F.readControl(G_Tok, G.Ntokens) end
    end
    ::case41::
    do
      do return F.report_readOptions(G_Tok, G.Ntokens) end
    end
    ::case42::
    do
      do return F.iface_readFileParams(G_Tok, G.Ntokens) end
    end
    ::case43::
    do
      do return F.lid_readProcParams(G_Tok, G.Ntokens) end
    end
    ::case44::
    do
      do return F.lid_readGroupParams(G_Tok, G.Ntokens) end
    end
    ::case45::
    do
      do return F.readEvent(G_Tok, G.Ntokens) end
    end
    ::case46::
    do
      do return F.street_readParams(G_Tok, G.Ntokens) end
    end
    ::case47::
    do
      do return F.inlet_readDesignParams(G_Tok, G.Ntokens) end
    end
    ::case48::
    do
      do return F.inlet_readUsageParams(G_Tok, G.Ntokens) end
    end
    ::case49::
    do
      do return 0 end
    end
    ::swend1::
  end
end

-- input.c:637
F.readControl = function(tok, ntoks)
  local G_Mobjects, G_Tok = G.Mobjects, G.Tok
  local index = 0
  local keyword = 0
  if (ntoks < 2) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  if (F.match(tok[0], S[29]) ~= 0) then
    do return F.controls_addVariable(tok, ntoks) end
  end
  if (F.match(tok[0], S[30]) ~= 0) then
    do return F.controls_addExpression(tok, ntoks) end
  end
  keyword = F.findmatch(tok[0], G.RuleKeyWords)
  if (keyword < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[0]) end
  end
  if (keyword == 0) then
    if (not (F.project_addObject(CONTROL, tok[1], G_Mobjects[CONTROL]) ~= 0)) then
      do return F.error_setInpError(ERR_DUP_NAME, G_Tok[1]) end
    end
    G_Mobjects[CONTROL] = G_Mobjects[CONTROL] + 1
  end
  index = (G_Mobjects[CONTROL] - 1)
  if (index < 0) then
    do return F.error_setInpError(ERR_RULE, S[0]) end
  end
  do return F.controls_addRuleClause(index, keyword, G_Tok, G.Ntokens) end
end

-- input.c:680
F.readOption = function(line)
  local G_Tok = G.Tok
  G.Ntokens = F.getTokens(line)
  if (G.Ntokens < 2) then
    do return 0 end
  end
  do return F.project_readOption(G_Tok[0], G_Tok[1]) end
end

-- input.c:694
F.readTitle = function(line)
  local G_Title = G.Title
  local i = 0
  local n = 0
  do
    i = 0
    while (i < 3) do
      do
        if (R.strlen(G_Title[i]) == 0) then
          n = R.i32(R.strlen(line))
          if (line.b[line.o + (n - 1)] == 10) then
            R.cset(line, (n - 1), 32)
          end
          F.sstrncpy(G_Title[i], line, 1024)
          break
        end
      end
      i = i + 1
    end
  end
  do return 0 end
end

-- input.c:721
F.readNode = function(type_)
  local G_Mobjects, G_Mnodes = G.Mobjects, G.Mnodes
  local j = G_Mobjects[NODE]
  local k = G_Mnodes[type_]
  local err = F.node_readParams(j, type_, k, G.Tok, G.Ntokens)
  G_Mobjects[NODE] = G_Mobjects[NODE] + 1
  G_Mnodes[type_] = G_Mnodes[type_] + 1
  do return err end
end

-- input.c:738
F.readLink = function(type_)
  local G_Mobjects, G_Mlinks = G.Mobjects, G.Mlinks
  local j = G_Mobjects[LINK]
  local k = G_Mlinks[type_]
  local err = F.link_readParams(j, type_, k, G.Tok, G.Ntokens)
  G_Mobjects[LINK] = G_Mobjects[LINK] + 1
  G_Mlinks[type_] = G_Mlinks[type_] + 1
  do return err end
end

-- input.c:755
F.readEvent = function(tok, ntoks)
  local G_Event = G.Event
  local x = R.fill(4, 0.0)
  if (ntoks < 4) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  if (not (F.datetime_strToDate(tok[0], x, 0) ~= 0)) then
    do return F.error_setInpError(ERR_DATETIME, tok[0]) end
  end
  if (not (F.datetime_strToTime(tok[1], x, 1) ~= 0)) then
    do return F.error_setInpError(ERR_DATETIME, tok[1]) end
  end
  if (not (F.datetime_strToDate(tok[2], x, 2) ~= 0)) then
    do return F.error_setInpError(ERR_DATETIME, tok[2]) end
  end
  if (not (F.datetime_strToTime(tok[3], x, 3) ~= 0)) then
    do return F.error_setInpError(ERR_DATETIME, tok[3]) end
  end
  G_Event[G.Mevents].start = (x[0] + x[1])
  G_Event[G.Mevents].end_ = (x[2] + x[3])
  if (G_Event[G.Mevents].start >= G_Event[G.Mevents].end_) then
    do return F.error_setInpError(ERR_DATETIME, S[204]) end
  end
  G.Mevents = G.Mevents + 1
  do return 0 end
end

-- input.c:779
F.findmatch = function(s, keyword)
  local i = 0
  while not R.peq(keyword[i], (nil)) do
    do
      if (F.match(s, keyword[i]) ~= 0) then
        do return (i) end
      end
      i = i + 1
    end
  end
  do return ((-1)) end
end

-- input.c:798
F.match = function(str, substr)
  local i = 0
  local j = 0
  local k = 0
  if (not (substr.b[substr.o] ~= 0)) then
    do return (0) end
  end
  do
    k = 0
    while (str.b[str.o + k] ~= 0) do
      do
        if (str.b[str.o + k] ~= 32) then
          break
        end
      end
      k = k + 1
    end
  end
  do
    i = k; j = 0
    while (substr.b[substr.o + j] ~= 0) do
      do
        if ((not (str.b[str.o + i] ~= 0)) or (((((((str.b[str.o + i]) >= 97) and ((str.b[str.o + i]) <= 122))) and (((str.b[str.o + i]) & (~32))) or (str.b[str.o + i]))) ~= ((((((substr.b[substr.o + j]) >= 97) and ((substr.b[substr.o + j]) <= 122))) and (((substr.b[substr.o + j]) & (~32))) or (substr.b[substr.o + j]))))) then
          do return (0) end
        end
      end
      i = i + 1; j = j + 1
    end
  end
  do return (1) end
end

-- input.c:828
F.getInt = function(s, y, y__k)
  local x = {0.0}
  if (F.getDouble(s, x, 1) ~= 0) then
    if (x[1] < 0.0) then
      x[1] = (x[1] - 0.01)
    else
      x[1] = (x[1] + 0.01)
    end
    y[y__k] = R.D2I(x[1])
    do return 1 end
  end
  y[y__k] = 0
  do return 0 end
end

-- input.c:850
F.getFloat = function(s, y, y__k)
  local endptr = {nil}
  y[y__k] = R.f32(R.strtod(s, endptr, 1))
  if (endptr[1].b[endptr[1].o] > 0) then
    do return (0) end
  end
  do return (1) end
end

-- input.c:866
F.getDouble = function(s, y, y__k)
  local endptr = {nil}
  y[y__k] = R.strtod(s, endptr, 1)
  if (endptr[1].b[endptr[1].o] > 0) then
    do return (0) end
  end
  do return (1) end
end

-- input.c:882
F.getTokens = function(s)
  local G_Tok = G.Tok
  local len = 0
  local n = 0
  local m = 0
  local c = nil
  do
    n = 0
    while (n < 40) do
      do
        G_Tok[n] = (nil)
      end
      n = n + 1
    end
  end
  n = 0
  c = R.strchr(s, 59)
  if (c ~= nil) then
    R.cset(c, 0, 0)
  end
  len = R.i32(R.strlen(s))
  while ((len > 0) and (n < 40)) do
    do
      m = R.i32(R.strcspn(s, S[184]))
      if (m == 0) then
        s = R.padd(s, 1)
      else
        if (s.b[s.o] == 34) then
          s = R.padd(s, 1)
          len = len - 1
          m = R.i32(R.strcspn(s, S[205]))
        end
        R.cset(s, m, 0)
        G_Tok[n] = s
        n = n + 1
        s = R.padd(s, (m + 1))
      end
      len = (len - (m + 1))
    end
  end
  do return n end
end

