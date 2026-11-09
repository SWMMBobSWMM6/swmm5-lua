-- Generated from EPA SWMM 5.2.4 (project.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local ERR_START_DATE <const> = 191
local ERR_REPORT_DATE <const> = 193
local ERR_REPORT_STEP <const> = 195
local CURVE <const> = 7
local ERR_CURVE_SEQUENCE <const> = 171
local TSERIES <const> = 8
local SNOWMELT <const> = 13
local AQUIFER <const> = 11
local SUBCATCH <const> = 1
local GAGE <const> = 0
local SHAPE_CURVE <const> = 5
local NODE <const> = 2
local LINK <const> = 3
local ALL <const> = 1
local DW <const> = 4
local ERR_KEYWORD <const> = 205
local FLOW_UNITS <const> = 0
local INFIL_MODEL <const> = 1
local ROUTE_MODEL <const> = 2
local START_DATE <const> = 3
local START_TIME <const> = 4
local END_DATE <const> = 5
local END_TIME <const> = 6
local REPORT_START_DATE <const> = 7
local REPORT_START_TIME <const> = 8
local SWEEP_START <const> = 9
local SWEEP_END <const> = 10
local START_DRY_DAYS <const> = 11
local WET_STEP <const> = 12
local DRY_STEP <const> = 13
local REPORT_STEP <const> = 16
local RULE_STEP <const> = 15
local INERT_DAMPING <const> = 18
local ALLOW_PONDING <const> = 17
local SLOPE_WEIGHTING <const> = 19
local SKIP_STEADY_STATE <const> = 25
local IGNORE_RAINFALL <const> = 27
local IGNORE_SNOWMELT <const> = 31
local IGNORE_GWATER <const> = 32
local IGNORE_ROUTING <const> = 33
local IGNORE_QUALITY <const> = 34
local IGNORE_RDII <const> = 39
local NORMAL_FLOW_LTD <const> = 21
local FORCE_MAIN_EQN <const> = 28
local LINK_OFFSETS <const> = 29
local COMPATIBILITY <const> = 24
local ROUTE_STEP <const> = 14
local LENGTHENING_STEP <const> = 22
local MIN_ROUTE_STEP <const> = 40
local NUM_THREADS <const> = 41
local VARIABLE_STEP <const> = 20
local MIN_SURFAREA <const> = 23
local MIN_SLOPE <const> = 30
local MAX_TRIALS <const> = 35
local HEAD_TOL <const> = 36
local SYS_FLOW_TOL <const> = 37
local LAT_FLOW_TOL <const> = 38
local SURCHARGE_METHOD <const> = 42
local TEMPDIR <const> = 26
local MGD <const> = 2
local US <const> = 0
local SI <const> = 1
local NO_ROUTING <const> = 0
local EKW <const> = 3
local KW <const> = 2
local ERR_DATETIME <const> = 213
local ERR_NUMBER <const> = 211
local SWMM3 <const> = 1
local SWMM4 <const> = 2
local SWMM5 <const> = 0
local SCRATCH_FILE <const> = 1
local NO_FILE <const> = 0
local CFS <const> = 0
local HORTON <const> = 0
local EXTRAN <const> = 0
local PARTIAL_DAMPING <const> = 1
local BOTH <const> = 2
local H_W <const> = 0
local DEPTH_OFFSET <const> = 0
local NO_TEMP <const> = 0
local MONTHLY_WIND <const> = 0
local CONSTANT_EVAP <const> = 0
local ERR_FILE_NAME <const> = 301
local ERR_INP_FILE <const> = 303
local ERR_RPT_FILE <const> = 305
local OUTFALL <const> = 1
local DIVIDER <const> = 3
local STORAGE <const> = 2
local CONDUIT <const> = 0
local PUMP <const> = 1
local ORIFICE <const> = 2
local WEIR <const> = 3
local OUTLET <const> = 4
local POLLUT <const> = 4
local LANDUSE <const> = 5
local TIMEPATTERN <const> = 6
local UNITHYD <const> = 12
local SHAPE <const> = 14
local LID <const> = 15
local CONTROL <const> = 9
local TRANSECT <const> = 10
local STREET <const> = 16
local INLET <const> = 17
local NO_BUILDUP <const> = 0
local PER_AREA <const> = 0
local NO_WASHOFF <const> = 0
local MAX_OBJ_TYPES <const> = 18
local ERR_MEMORY <const> = 101
local _ENV = R.strict

G.Htable = {}
G.MemPoolAllocated = 0

-- project.c:70
F.omp_get_max_threads = function()
  do return 1 end
end

-- project.c:113
F.project_open = function(f1, f2, f3)
  F.initPointers()
  F.setDefaults()
  F.openFiles(f1, f2, f3)
end

-- project.c:129
F.project_readInput = function()
  F.createHashTables()
  F.input_countObjects()
  F.createObjects()
  F.input_readData()
  if (G.ErrorCode ~= 0) then
    do return end
  end
  G.StartDateTime = (G.StartDate + G.StartTime)
  G.EndDateTime = (G.EndDate + G.EndTime)
  G.ReportStart = (G.ReportStartDate + G.ReportStartTime)
  G.ReportStart = (((((G.ReportStart) >= (G.StartDateTime))) and (G.ReportStart) or (G.StartDateTime)))
  if (G.EndDateTime <= G.StartDateTime) then
    F.report_writeErrorMsg(ERR_START_DATE, S[0])
  elseif (G.EndDateTime <= G.ReportStart) then
    F.report_writeErrorMsg(ERR_REPORT_DATE, S[0])
  else
    G.TotalDuration = R.floor((((G.EndDateTime - G.StartDateTime)) * 86400.0))
    if ((G.ReportStep * 1.0) > G.TotalDuration) then
      G.ReportStep = R.D2I((G.TotalDuration))
    end
    if ((G.ReportStep * 1.0) < G.RouteStep) then
      F.report_writeErrorMsg(ERR_REPORT_STEP, S[0])
    end
    G.TotalDuration = (G.TotalDuration * 1000.0)
  end
end

-- project.c:186
F.project_validate = function()
  local G_Nobjects, G_Curve, G_Tseries, G_Shape, G_Node, G_RptFlags = G.Nobjects, G.Curve, G.Tseries, G.Shape, G.Node, G.RptFlags
  local G_Subcatch, G_Link = G.Subcatch, G.Link
  local i = 0
  local j = 0
  local err = 0
  do
    i = 0
    while (i < G_Nobjects[CURVE]) do
      do
        err = F.table_validate(G_Curve[i])
        if (err ~= 0) then
          F.report_writeErrorMsg(ERR_CURVE_SEQUENCE, G_Curve[i].ID)
        end
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[TSERIES]) do
      do
        err = F.table_validate(G_Tseries[i])
        if (err ~= 0) then
          F.report_writeTseriesErrorMsg(err, G_Tseries[i])
        end
      end
      i = i + 1
    end
  end
  F.climate_validate()
  F.lid_validate()
  if (G_Nobjects[SNOWMELT] == 0) then
    G.IgnoreSnowmelt = 1
  end
  if (G_Nobjects[AQUIFER] == 0) then
    G.IgnoreGwater = 1
  end
  do
    i = 0
    while (i < G_Nobjects[AQUIFER]) do
      do
        F.gwater_validateAquifer(i)
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[SUBCATCH]) do
      do
        F.subcatch_validate(i)
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[GAGE]) do
      do
        F.gage_validate(i)
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[SNOWMELT]) do
      do
        F.snow_validateSnowmelt(i)
      end
      i = i + 1
    end
  end
  j = 0
  do
    i = 0
    while (i < G_Nobjects[CURVE]) do
      do
        if (G_Curve[i].curveType == SHAPE_CURVE) then
          G_Curve[i].refersTo = j
          G_Shape[j].curve = i
          if (not (F.shape_validate(G_Shape[j], G_Curve[i]) ~= 0)) then
            F.report_writeErrorMsg(ERR_CURVE_SEQUENCE, G_Curve[i].ID)
          end
          j = j + 1
        end
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        G_Node[i].oldDepth = G_Node[i].fullDepth
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        F.link_validate(i)
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        F.node_validate(i)
      end
      i = i + 1
    end
  end
  if (G.DryStep < G.WetStep) then
    F.report_writeWarningMsg(S[319], S[0])
    G.DryStep = G.WetStep
  end
  if (G.RouteStep > (G.WetStep * 1.0)) then
    F.report_writeWarningMsg(S[320], S[0])
    G.RouteStep = (G.WetStep * 1.0)
  end
  if (G_RptFlags.subcatchments == ALL) then
    do
      i = 0
      while (i < G_Nobjects[SUBCATCH]) do
        do
          G_Subcatch[i].rptFlag = 1
        end
        i = i + 1
      end
    end
  end
  if (G_RptFlags.nodes == ALL) then
    do
      i = 0
      while (i < G_Nobjects[NODE]) do
        do
          G_Node[i].rptFlag = 1
        end
        i = i + 1
      end
    end
  end
  if (G_RptFlags.links == ALL) then
    do
      i = 0
      while (i < G_Nobjects[LINK]) do
        do
          G_Link[i].rptFlag = 1
        end
        i = i + 1
      end
    end
  end
  if (G.RouteModel == DW) then
    F.dynwave_validate()
  end
  F.inlet_validate()
  if (G.NumThreads == 0) then
    G.NumThreads = F.omp_get_max_threads()
  else
    G.NumThreads = (((((G.NumThreads) <= (F.omp_get_max_threads()))) and (G.NumThreads) or (F.omp_get_max_threads())))
  end
  if (G_Nobjects[LINK] < (4 * G.NumThreads)) then
    G.NumThreads = 1
  end
end

-- project.c:274
F.project_close = function()
  F.deleteObjects()
  F.deleteHashTables()
end

-- project.c:287
F.project_init = function()
  local G_Nobjects, G_Tseries, G_Subcatch, G_Node, G_Link = G.Nobjects, G.Tseries, G.Subcatch, G.Node, G.Link
  local j = 0
  local k = 0
  F.climate_initState()
  F.lid_initState()
  do
    j = 0
    while (j < G_Nobjects[TSERIES]) do
      do
        F.table_tseriesInit(G_Tseries[j])
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[GAGE]) do
      do
        F.gage_initState(j)
      end
      j = j + 1
    end
  end
  k = 1
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        F.subcatch_initState(j)
        if (G_Subcatch[j].rptFlag > 0) then
          G_Subcatch[j].rptFlag = k
          k = k + 1
        end
      end
      j = j + 1
    end
  end
  k = 1
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        F.node_initState(j)
        if (G_Node[j].rptFlag > 0) then
          G_Node[j].rptFlag = k
          k = k + 1
        end
      end
      j = j + 1
    end
  end
  k = 1
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        F.link_initState(j)
        if (G_Link[j].rptFlag > 0) then
          G_Link[j].rptFlag = k
          k = k + 1
        end
      end
      j = j + 1
    end
  end
  do return G.ErrorCode end
end

-- project.c:334
F.project_addObject = function(type_, id, n)
  local result = 0
  local len = 0
  local newID = nil
  if (F.project_findObject(type_, id) >= 0) then
    do return 0 end
  end
  len = R.strlen(id)
  newID = F.Alloc((((len + 1)) * 1))
  F.sstrncpy(newID, id, len)
  result = F.HTinsert(G.Htable[type_], newID, n)
  if (result == 0) then
    result = (-1)
  end
  do return result end
end

-- project.c:364
F.project_findObject = function(type_, id)
  do return F.HTfind(G.Htable[type_], id) end
end

-- project.c:377
F.project_findID = function(type_, id)
  do return F.HTfindKey(G.Htable[type_], id) end
end

-- project.c:445
F.project_readOption = function(s1, s2)
  local k = 0
  local m = {0}
  local h = {0}
  local s = {0}
  local tStep = {0.0}
  local strDate = R.buf(25)
  local aTime = {0.0}
  local aDate = {0.0}
  k = F.findmatch(s1, G.OptionWords)
  if (k < 0) then
    do return F.error_setInpError(ERR_KEYWORD, s1) end
  end
  do
    local __sw1 = k
    if __sw1 < NORMAL_FLOW_LTD then
      if __sw1 < SWEEP_END then
        if __sw1 < END_DATE then
          if __sw1 < ROUTE_MODEL then
            if __sw1 == FLOW_UNITS then goto case2
            elseif __sw1 == INFIL_MODEL then goto case3
            end
          else
            if __sw1 == ROUTE_MODEL then goto case4
            elseif __sw1 == START_DATE then goto case5
            elseif __sw1 == START_TIME then goto case6
            end
          end
        else
          if __sw1 < REPORT_START_DATE then
            if __sw1 == END_DATE then goto case7
            elseif __sw1 == END_TIME then goto case8
            end
          else
            if __sw1 == REPORT_START_DATE then goto case9
            elseif __sw1 == REPORT_START_TIME then goto case10
            elseif __sw1 == SWEEP_START then goto case11
            end
          end
        end
      else
        if __sw1 < RULE_STEP then
          if __sw1 < WET_STEP then
            if __sw1 == SWEEP_END then goto case11
            elseif __sw1 == START_DRY_DAYS then goto case12
            end
          else
            if __sw1 == WET_STEP then goto case13
            elseif __sw1 == DRY_STEP then goto case13
            elseif __sw1 == ROUTE_STEP then goto case20
            end
          end
        else
          if __sw1 < INERT_DAMPING then
            if __sw1 == RULE_STEP then goto case13
            elseif __sw1 == REPORT_STEP then goto case13
            elseif __sw1 == ALLOW_PONDING then goto case15
            end
          else
            if __sw1 == INERT_DAMPING then goto case14
            elseif __sw1 == SLOPE_WEIGHTING then goto case15
            elseif __sw1 == VARIABLE_STEP then goto case23
            end
          end
        end
      end
    else
      if __sw1 < IGNORE_GWATER then
        if __sw1 < TEMPDIR then
          if __sw1 < MIN_SURFAREA then
            if __sw1 == NORMAL_FLOW_LTD then goto case16
            elseif __sw1 == LENGTHENING_STEP then goto case20
            end
          else
            if __sw1 == MIN_SURFAREA then goto case24
            elseif __sw1 == COMPATIBILITY then goto case19
            elseif __sw1 == SKIP_STEADY_STATE then goto case15
            end
          end
        else
          if __sw1 < LINK_OFFSETS then
            if __sw1 == TEMPDIR then goto case31
            elseif __sw1 == IGNORE_RAINFALL then goto case15
            elseif __sw1 == FORCE_MAIN_EQN then goto case17
            end
          else
            if __sw1 == LINK_OFFSETS then goto case18
            elseif __sw1 == MIN_SLOPE then goto case25
            elseif __sw1 == IGNORE_SNOWMELT then goto case15
            end
          end
        end
      else
        if __sw1 < SYS_FLOW_TOL then
          if __sw1 < IGNORE_QUALITY then
            if __sw1 == IGNORE_GWATER then goto case15
            elseif __sw1 == IGNORE_ROUTING then goto case15
            end
          else
            if __sw1 == IGNORE_QUALITY then goto case15
            elseif __sw1 == MAX_TRIALS then goto case26
            elseif __sw1 == HEAD_TOL then goto case27
            end
          end
        else
          if __sw1 < MIN_ROUTE_STEP then
            if __sw1 == SYS_FLOW_TOL then goto case28
            elseif __sw1 == LAT_FLOW_TOL then goto case29
            elseif __sw1 == IGNORE_RDII then goto case15
            end
          else
            if __sw1 == MIN_ROUTE_STEP then goto case21
            elseif __sw1 == NUM_THREADS then goto case22
            elseif __sw1 == SURCHARGE_METHOD then goto case30
            end
          end
        end
      end
    end
    goto swend1
    ::case2::
    do
      m[1] = F.findmatch(s2, G.FlowUnitWords)
      if (m[1] < 0) then
        do return F.error_setInpError(ERR_KEYWORD, s2) end
      end
      G.FlowUnits = m[1]
      if (G.FlowUnits <= MGD) then
        G.UnitSystem = US
      else
        G.UnitSystem = SI
      end
      goto swend1
    end
    ::case3::
    do
      m[1] = F.findmatch(s2, G.InfilModelWords)
      if (m[1] < 0) then
        do return F.error_setInpError(ERR_KEYWORD, s2) end
      end
      G.InfilModel = m[1]
      goto swend1
    end
    ::case4::
    do
      m[1] = F.findmatch(s2, G.RouteModelWords)
      if (m[1] < 0) then
        m[1] = F.findmatch(s2, G.OldRouteModelWords)
      end
      if (m[1] < 0) then
        do return F.error_setInpError(ERR_KEYWORD, s2) end
      end
      if (m[1] == NO_ROUTING) then
        G.IgnoreRouting = 1
      else
        G.RouteModel = m[1]
      end
      if (G.RouteModel == EKW) then
        G.RouteModel = KW
      end
      goto swend1
    end
    ::case5::
    do
      if (not (F.datetime_strToDate(s2, G, "StartDate") ~= 0)) then
        do return F.error_setInpError(ERR_DATETIME, s2) end
      end
      goto swend1
    end
    ::case6::
    do
      if (not (F.datetime_strToTime(s2, G, "StartTime") ~= 0)) then
        do return F.error_setInpError(ERR_DATETIME, s2) end
      end
      goto swend1
    end
    ::case7::
    do
      if (not (F.datetime_strToDate(s2, G, "EndDate") ~= 0)) then
        do return F.error_setInpError(ERR_DATETIME, s2) end
      end
      goto swend1
    end
    ::case8::
    do
      if (not (F.datetime_strToTime(s2, G, "EndTime") ~= 0)) then
        do return F.error_setInpError(ERR_DATETIME, s2) end
      end
      goto swend1
    end
    ::case9::
    do
      if (not (F.datetime_strToDate(s2, G, "ReportStartDate") ~= 0)) then
        do return F.error_setInpError(ERR_DATETIME, s2) end
      end
      goto swend1
    end
    ::case10::
    do
      if (not (F.datetime_strToTime(s2, G, "ReportStartTime") ~= 0)) then
        do return F.error_setInpError(ERR_DATETIME, s2) end
      end
      goto swend1
    end
    ::case11::
    do
      F.sstrncpy(strDate, s2, 24)
      F.sstrcat(strDate, S[35], 25)
      if (not (F.datetime_strToDate(strDate, aDate, 1) ~= 0)) then
        do return F.error_setInpError(ERR_DATETIME, s2) end
      end
      m[1] = F.datetime_dayOfYear(aDate[1])
      if (k == SWEEP_START) then
        G.SweepStart = m[1]
      else
        G.SweepEnd = m[1]
      end
      goto swend1
    end
    ::case12::
    do
      G.StartDryDays = R.atof(s2)
      if (G.StartDryDays < 0.0) then
        do return F.error_setInpError(ERR_NUMBER, s2) end
      end
      goto swend1
    end
    ::case13::
    do
      if (not (F.datetime_strToTime(s2, aTime, 1) ~= 0)) then
        do return F.error_setInpError(ERR_DATETIME, s2) end
      end
      F.datetime_decodeTime(aTime[1], h, 1, m, 1, s, 1)
      h[1] = (h[1] + (24 * R.D2I(aTime[1])))
      s[1] = ((s[1] + (60 * m[1])) + (3600 * h[1]))
      if (k == RULE_STEP) then
        if (s[1] < 0) then
          do return F.error_setInpError(ERR_NUMBER, s2) end
        end
      elseif (s[1] <= 0) then
        do return F.error_setInpError(ERR_NUMBER, s2) end
      end
      do
        local __sw2 = k
        if __sw2 == WET_STEP then goto case33
        elseif __sw2 == DRY_STEP then goto case34
        elseif __sw2 == REPORT_STEP then goto case35
        elseif __sw2 == RULE_STEP then goto case36
        else goto swend32 end
        ::case33::
        do
          G.WetStep = s[1]
          goto swend32
        end
        ::case34::
        do
          G.DryStep = s[1]
          goto swend32
        end
        ::case35::
        do
          G.ReportStep = s[1]
          goto swend32
        end
        ::case36::
        do
          G.RuleStep = s[1]
          goto swend32
        end
        ::swend32::
      end
      goto swend1
    end
    ::case14::
    do
      m[1] = F.findmatch(s2, G.InertDampingWords)
      if (m[1] < 0) then
        do return F.error_setInpError(ERR_KEYWORD, s2) end
      else
        G.InertDamping = m[1]
      end
      goto swend1
    end
    ::case15::
    do
      m[1] = F.findmatch(s2, G.NoYesWords)
      if (m[1] < 0) then
        do return F.error_setInpError(ERR_KEYWORD, s2) end
      end
      do
        local __sw3 = k
        if __sw3 < IGNORE_SNOWMELT then
          if __sw3 < SKIP_STEADY_STATE then
            if __sw3 == ALLOW_PONDING then goto case38
            elseif __sw3 == SLOPE_WEIGHTING then goto case39
            end
          else
            if __sw3 == SKIP_STEADY_STATE then goto case40
            elseif __sw3 == IGNORE_RAINFALL then goto case41
            end
          end
        else
          if __sw3 < IGNORE_ROUTING then
            if __sw3 == IGNORE_SNOWMELT then goto case42
            elseif __sw3 == IGNORE_GWATER then goto case43
            end
          else
            if __sw3 == IGNORE_ROUTING then goto case44
            elseif __sw3 == IGNORE_QUALITY then goto case45
            elseif __sw3 == IGNORE_RDII then goto case46
            end
          end
        end
        goto swend37
        ::case38::
        do
          G.AllowPonding = m[1]
          goto swend37
        end
        ::case39::
        do
          G.SlopeWeighting = m[1]
          goto swend37
        end
        ::case40::
        do
          G.SkipSteadyState = m[1]
          goto swend37
        end
        ::case41::
        do
          G.IgnoreRainfall = m[1]
          goto swend37
        end
        ::case42::
        do
          G.IgnoreSnowmelt = m[1]
          goto swend37
        end
        ::case43::
        do
          G.IgnoreGwater = m[1]
          goto swend37
        end
        ::case44::
        do
          G.IgnoreRouting = m[1]
          goto swend37
        end
        ::case45::
        do
          G.IgnoreQuality = m[1]
          goto swend37
        end
        ::case46::
        do
          G.IgnoreRDII = m[1]
          goto swend37
        end
        ::swend37::
      end
      goto swend1
    end
    ::case16::
    do
      m[1] = F.findmatch(s2, G.NormalFlowWords)
      if (m[1] < 0) then
        do return F.error_setInpError(ERR_KEYWORD, s2) end
      end
      G.NormalFlowLtd = m[1]
      goto swend1
    end
    ::case17::
    do
      m[1] = F.findmatch(s2, G.ForceMainEqnWords)
      if (m[1] < 0) then
        do return F.error_setInpError(ERR_KEYWORD, s2) end
      end
      G.ForceMainEqn = m[1]
      goto swend1
    end
    ::case18::
    do
      m[1] = F.findmatch(s2, G.LinkOffsetWords)
      if (m[1] < 0) then
        do return F.error_setInpError(ERR_KEYWORD, s2) end
      end
      G.LinkOffsets = m[1]
      goto swend1
    end
    ::case19::
    do
      if (F.strcomp(s2, S[321]) ~= 0) then
        G.Compatibility = SWMM3
      elseif (F.strcomp(s2, S[322]) ~= 0) then
        G.Compatibility = SWMM4
      elseif (F.strcomp(s2, S[323]) ~= 0) then
        G.Compatibility = SWMM5
      else
        do return F.error_setInpError(ERR_KEYWORD, s2) end
      end
      goto swend1
    end
    ::case20::
    do
      if (not (F.getDouble(s2, tStep, 1) ~= 0)) then
        if (not (F.datetime_strToTime(s2, aTime, 1) ~= 0)) then
          do return F.error_setInpError(ERR_NUMBER, s2) end
        else
          F.datetime_decodeTime(aTime[1], h, 1, m, 1, s, 1)
          h[1] = (h[1] + (24 * R.D2I(aTime[1])))
          s[1] = ((s[1] + (60 * m[1])) + (3600 * h[1]))
          tStep[1] = (s[1] * 1.0)
        end
      end
      if (k == ROUTE_STEP) then
        if (tStep[1] <= 0.0) then
          do return F.error_setInpError(ERR_NUMBER, s2) end
        end
        G.RouteStep = tStep[1]
      else
        G.LengtheningStep = (((((0.0) >= (tStep[1]))) and (0.0) or (tStep[1])))
      end
      goto swend1
    end
    ::case21::
    do
      if ((not (F.getDouble(s2, G, "MinRouteStep") ~= 0)) or (G.MinRouteStep < 0.0)) then
        do return F.error_setInpError(ERR_NUMBER, s2) end
      end
      goto swend1
    end
    ::case22::
    do
      m[1] = R.atoi(s2)
      if (m[1] < 0) then
        do return F.error_setInpError(ERR_NUMBER, s2) end
      end
      G.NumThreads = m[1]
      goto swend1
    end
    ::case23::
    do
      if (not (F.getDouble(s2, G, "CourantFactor") ~= 0)) then
        do return F.error_setInpError(ERR_NUMBER, s2) end
      end
      if ((G.CourantFactor < 0.0) or (G.CourantFactor > 2.0)) then
        do return F.error_setInpError(ERR_NUMBER, s2) end
      end
      goto swend1
    end
    ::case24::
    do
      if (not (F.getDouble(s2, G, "MinSurfArea") ~= 0)) then
        do return F.error_setInpError(ERR_NUMBER, s2) end
      end
      if (G.MinSurfArea < 0.0) then
        do return F.error_setInpError(ERR_NUMBER, s2) end
      end
      goto swend1
    end
    ::case25::
    do
      if (not (F.getDouble(s2, G, "MinSlope") ~= 0)) then
        do return F.error_setInpError(ERR_NUMBER, s2) end
      end
      if ((G.MinSlope < 0.0) or (G.MinSlope >= 100.0)) then
        do return F.error_setInpError(ERR_NUMBER, s2) end
      end
      G.MinSlope = (G.MinSlope / 100.0)
      goto swend1
    end
    ::case26::
    do
      m[1] = R.atoi(s2)
      if (m[1] < 0) then
        do return F.error_setInpError(ERR_NUMBER, s2) end
      end
      G.MaxTrials = m[1]
      goto swend1
    end
    ::case27::
    do
      if (not (F.getDouble(s2, G, "HeadTol") ~= 0)) then
        do return F.error_setInpError(ERR_NUMBER, s2) end
      end
      goto swend1
    end
    ::case28::
    do
      if (not (F.getDouble(s2, G, "SysFlowTol") ~= 0)) then
        do return F.error_setInpError(ERR_NUMBER, s2) end
      end
      G.SysFlowTol = (G.SysFlowTol / 100.0)
      goto swend1
    end
    ::case29::
    do
      if (not (F.getDouble(s2, G, "LatFlowTol") ~= 0)) then
        do return F.error_setInpError(ERR_NUMBER, s2) end
      end
      G.LatFlowTol = (G.LatFlowTol / 100.0)
      goto swend1
    end
    ::case30::
    do
      m[1] = F.findmatch(s2, G.SurchargeWords)
      if (m[1] < 0) then
        do return F.error_setInpError(ERR_KEYWORD, s2) end
      end
      G.SurchargeMethod = m[1]
      goto swend1
    end
    ::case31::
    do
      F.sstrncpy(G.TempDir, s2, 259)
      goto swend1
    end
    ::swend1::
  end
  do return 0 end
end

-- project.c:773
F.initPointers = function()
  G.Gage = (nil)
  G.Subcatch = (nil)
  G.Node = (nil)
  G.Outfall = (nil)
  G.Divider = (nil)
  G.Storage = (nil)
  G.Link = (nil)
  G.Conduit = (nil)
  G.Pump = (nil)
  G.Orifice = (nil)
  G.Weir = (nil)
  G.Outlet = (nil)
  G.Pollut = (nil)
  G.Landuse = (nil)
  G.Pattern = (nil)
  G.Curve = (nil)
  G.Tseries = (nil)
  G.Transect = (nil)
  G.Shape = (nil)
  G.Aquifer = (nil)
  G.UnitHyd = (nil)
  G.Snowmelt = (nil)
  G.Event = (nil)
  G.MemPoolAllocated = 0
end

-- project.c:808
F.setDefaults = function()
  local G_Title, G_Frain, G_Fclimate, G_Frunoff, G_Frdii, G_Fhotstart1 = G.Title, G.Frain, G.Fclimate, G.Frunoff, G.Frdii, G.Fhotstart1
  local G_Fhotstart2, G_Finflows, G_Foutflows, G_Fout, G_RptFlags, G_Temp = G.Fhotstart2, G.Finflows, G.Foutflows, G.Fout, G.RptFlags, G.Temp
  local G_Wind, G_Snow, G_Evap, G_Adjust = G.Wind, G.Snow, G.Evap, G.Adjust
  local i = 0
  local j = 0
  do
    i = 0
    while (i < 3) do
      do
        F.sstrncpy(G_Title[i], S[0], 0)
      end
      i = i + 1
    end
  end
  F.sstrncpy(G.TempDir, S[0], 0)
  G_Frain.mode = SCRATCH_FILE
  G_Fclimate.mode = NO_FILE
  G_Frunoff.mode = NO_FILE
  G_Frdii.mode = NO_FILE
  G_Fhotstart1.mode = NO_FILE
  G_Fhotstart2.mode = NO_FILE
  G_Finflows.mode = NO_FILE
  G_Foutflows.mode = NO_FILE
  G_Frain.file = (nil)
  G_Fclimate.file = (nil)
  G_Frunoff.file = (nil)
  G_Frdii.file = (nil)
  G_Fhotstart1.file = (nil)
  G_Fhotstart2.file = (nil)
  G_Finflows.file = (nil)
  G_Foutflows.file = (nil)
  G_Fout.file = (nil)
  G_Fout.mode = NO_FILE
  G.UnitSystem = US
  G.FlowUnits = CFS
  G.InfilModel = HORTON
  G.RouteModel = DW
  G.SurchargeMethod = EXTRAN
  G.CrownCutoff = 0.96
  G.AllowPonding = 0
  G.InertDamping = PARTIAL_DAMPING
  G.NormalFlowLtd = BOTH
  G.ForceMainEqn = H_W
  G.LinkOffsets = DEPTH_OFFSET
  G.LengtheningStep = 0.0
  G.CourantFactor = 0.75
  G.MinSurfArea = 0.0
  G.MinSlope = 0.0
  G.SkipSteadyState = 0
  G.IgnoreRainfall = 0
  G.IgnoreRDII = 0
  G.IgnoreSnowmelt = 0
  G.IgnoreGwater = 0
  G.IgnoreRouting = 0
  G.IgnoreQuality = 0
  G.WetStep = 300
  G.DryStep = 3600
  G.RuleStep = 0
  G.RouteStep = 20.0
  G.MinRouteStep = 0.5
  G.ReportStep = 900
  G.StartDryDays = 0.0
  G.MaxTrials = 0
  G.HeadTol = 0.0
  G.SysFlowTol = 0.05
  G.LatFlowTol = 0.05
  G.NumThreads = 1
  G.NumEvents = 0
  G.SlopeWeighting = 1
  G.Compatibility = SWMM4
  G.StartDate = F.datetime_encodeDate(2004, 1, 1)
  G.StartTime = F.datetime_encodeTime(0, 0, 0)
  G.StartDateTime = (G.StartDate + G.StartTime)
  G.EndDate = G.StartDate
  G.EndTime = 0.0
  G.ReportStartDate = ((-693594) * 1.0)
  G.ReportStartTime = ((-693594) * 1.0)
  G.SweepStart = 1
  G.SweepEnd = 365
  G_RptFlags.disabled = 0
  G_RptFlags.input = 0
  G_RptFlags.continuity = 1
  G_RptFlags.flowStats = 1
  G_RptFlags.controls = 0
  G_RptFlags.subcatchments = 0
  G_RptFlags.nodes = 0
  G_RptFlags.links = 0
  G_RptFlags.averages = 0
  G_Temp.dataSource = NO_TEMP
  G_Temp.tSeries = (-1)
  G_Temp.ta = 70.0
  G_Temp.elev = 0.0
  G_Temp.anglat = 40.0
  G_Temp.dtlong = 0.0
  G_Temp.tmax = (-10000000000.0)
  G_Wind.type_ = MONTHLY_WIND
  do
    i = 0
    while (i < 12) do
      do
        G_Wind.aws[i] = 0.0
      end
      i = i + 1
    end
  end
  G_Snow.snotmp = 34.0
  G_Snow.tipm = 0.5
  G_Snow.rnm = 0.6
  do
    i = 0
    while (i < 2) do
      do
        do
          j = 0
          while (j < 10) do
            do
              G_Snow.adc[i][j] = 1.0
            end
            j = j + 1
          end
        end
      end
      i = i + 1
    end
  end
  G_Evap.type_ = CONSTANT_EVAP
  do
    i = 0
    while (i < 12) do
      do
        G_Evap.monthlyEvap[i] = 0.0
        G_Evap.panCoeff[i] = 1.0
      end
      i = i + 1
    end
  end
  G_Evap.recoveryPattern = (-1)
  G_Evap.recoveryFactor = 1.0
  G_Evap.tSeries = (-1)
  G_Evap.dryOnly = 0
  do
    i = 0
    while (i < 12) do
      do
        G_Adjust.temp[i] = 0.0
        G_Adjust.evap[i] = 0.0
        G_Adjust.rain[i] = 1.0
        G_Adjust.hydcon[i] = 1.0
      end
      i = i + 1
    end
  end
  G_Adjust.rainFactor = 1.0
  G_Adjust.hydconFactor = 1.0
end

-- project.c:954
F.openFiles = function(f1, f2, f3)
  local G_Finp, G_Frpt, G_Fout = G.Finp, G.Frpt, G.Fout
  G_Finp.file = (nil)
  G_Frpt.file = (nil)
  G_Fout.file = (nil)
  F.sstrncpy(G_Finp.name, f1, 259)
  F.sstrncpy(G_Frpt.name, f2, 259)
  F.sstrncpy(G_Fout.name, f3, 259)
  if (((F.strcomp(f1, f2) ~= 0) or (F.strcomp(f1, f3) ~= 0)) or (F.strcomp(f2, f3) ~= 0)) then
    F.writecon(S[324])
    G.ErrorCode = ERR_FILE_NAME
    do return end
  end
  G_Finp.file = R.fopen(f1, S[13])
  if ((G_Finp.file) == (nil)) then
    F.writecon(S[325])
    F.writecon(f1)
    G.ErrorCode = ERR_INP_FILE
    do return end
  end
  G_Frpt.file = R.fopen(f2, S[171])
  if ((G_Frpt.file) == (nil)) then
    F.writecon(S[326])
    G.ErrorCode = ERR_RPT_FILE
    do return end
  end
end

-- project.c:999
F.createObjects = function()
  local G_Nobjects, G_Nnodes, G_Nlinks = G.Nobjects, G.Nnodes, G.Nlinks
  local j = 0
  local k = 0
  if (G.ErrorCode ~= 0) then
    do return end
  end
  G.Gage = R.recs(G_Nobjects[GAGE], T.TGage)
  G.Subcatch = R.recs(G_Nobjects[SUBCATCH], T.TSubcatch)
  G.Node = R.recs(G_Nobjects[NODE], T.TNode)
  G.Outfall = R.recs(G_Nnodes[OUTFALL], T.TOutfall)
  G.Divider = R.recs(G_Nnodes[DIVIDER], T.TDivider)
  G.Storage = R.recs(G_Nnodes[STORAGE], T.TStorage)
  G.Link = R.recs(G_Nobjects[LINK], T.TLink)
  G.Conduit = R.recs(G_Nlinks[CONDUIT], T.TConduit)
  G.Pump = R.recs(G_Nlinks[PUMP], T.TPump)
  G.Orifice = R.recs(G_Nlinks[ORIFICE], T.TOrifice)
  G.Weir = R.recs(G_Nlinks[WEIR], T.TWeir)
  G.Outlet = R.recs(G_Nlinks[OUTLET], T.TOutlet)
  G.Pollut = R.recs(G_Nobjects[POLLUT], T.TPollut)
  G.Landuse = R.recs(G_Nobjects[LANDUSE], T.TLanduse)
  G.Pattern = R.recs(G_Nobjects[TIMEPATTERN], T.TPattern)
  G.Curve = R.recs(G_Nobjects[CURVE], T.TTable)
  G.Tseries = R.recs(G_Nobjects[TSERIES], T.TTable)
  G.Aquifer = R.recs(G_Nobjects[AQUIFER], T.TAquifer)
  G.UnitHyd = R.recs(G_Nobjects[UNITHYD], T.TUnitHyd)
  G.Snowmelt = R.recs(G_Nobjects[SNOWMELT], T.TSnowmelt)
  G.Shape = R.recs(G_Nobjects[SHAPE], T.TShape)
  G.Event = R.recs((G.NumEvents + 1), T.TEvent)
  G.Event[G.NumEvents].start = 10000000000.0
  G.Event[G.NumEvents].end_ = (10000000000.0 + 1.0)
  F.lid_create(G_Nobjects[LID], G_Nobjects[SUBCATCH])
  G.ErrorCode = F.controls_create(G_Nobjects[CONTROL])
  if (G.ErrorCode ~= 0) then
    do return end
  end
  G.ErrorCode = F.transect_create(G_Nobjects[TRANSECT])
  if (G.ErrorCode ~= 0) then
    do return end
  end
  G.ErrorCode = F.street_create(G_Nobjects[STREET])
  if (G.ErrorCode ~= 0) then
    do return end
  end
  G.ErrorCode = F.inlet_create(G_Nobjects[INLET])
  if (G.ErrorCode ~= 0) then
    do return end
  end
  F.infil_create(G_Nobjects[SUBCATCH])
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        G.Subcatch[j].initBuildup = R.fill(G_Nobjects[POLLUT], 0.0)
        G.Subcatch[j].oldQual = R.fill(G_Nobjects[POLLUT], 0.0)
        G.Subcatch[j].newQual = R.fill(G_Nobjects[POLLUT], 0.0)
        G.Subcatch[j].pondedQual = R.fill(G_Nobjects[POLLUT], 0.0)
        G.Subcatch[j].totalLoad = R.fill(G_Nobjects[POLLUT], 0.0)
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        G.Node[j].oldQual = R.fill(G_Nobjects[POLLUT], 0.0)
        G.Node[j].newQual = R.fill(G_Nobjects[POLLUT], 0.0)
        G.Node[j].extInflow = (nil)
        G.Node[j].dwfInflow = (nil)
        G.Node[j].rdiiInflow = (nil)
        G.Node[j].treatment = (nil)
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        G.Link[j].inlet = (nil)
        G.Link[j].oldQual = R.fill(G_Nobjects[POLLUT], 0.0)
        G.Link[j].newQual = R.fill(G_Nobjects[POLLUT], 0.0)
        G.Link[j].totalLoad = R.fill(G_Nobjects[POLLUT], 0.0)
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[LANDUSE]) do
      do
        G.Landuse[j].buildupFunc = R.recs(G_Nobjects[POLLUT], T.TBuildup)
        G.Landuse[j].washoffFunc = R.recs(G_Nobjects[POLLUT], T.TWashoff)
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        G.Subcatch[j].landFactor = R.recs(G_Nobjects[LANDUSE], T.TLandFactor)
        do
          k = 0
          while (k < G_Nobjects[LANDUSE]) do
            do
              G.Subcatch[j].landFactor[k].buildup = R.fill(G_Nobjects[POLLUT], 0.0)
            end
            k = k + 1
          end
        end
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[LANDUSE]) do
      do
        do
          k = 0
          while (k < G_Nobjects[POLLUT]) do
            do
              G.Landuse[j].buildupFunc[k].funcType = NO_BUILDUP
              G.Landuse[j].buildupFunc[k].normalizer = PER_AREA
              G.Landuse[j].washoffFunc[k].funcType = NO_WASHOFF
            end
            k = k + 1
          end
        end
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[GAGE]) do
      do
        G.Gage[j].tSeries = (-1)
        F.sstrncpy(G.Gage[j].fname, S[0], 0)
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        G.Subcatch[j].outSubcatch = (-1)
        G.Subcatch[j].outNode = (-1)
        G.Subcatch[j].infil = (-1)
        G.Subcatch[j].groundwater = (nil)
        G.Subcatch[j].gwLatFlowExpr = (nil)
        G.Subcatch[j].gwDeepFlowExpr = (nil)
        G.Subcatch[j].snowpack = (nil)
        G.Subcatch[j].lidArea = 0.0
        do
          k = 0
          while (k < G_Nobjects[POLLUT]) do
            do
              G.Subcatch[j].initBuildup[k] = 0.0
            end
            k = k + 1
          end
        end
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[UNITHYD]) do
      do
        F.rdii_initUnitHyd(j)
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[SNOWMELT]) do
      do
        F.snow_initSnowmelt(j)
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nnodes[STORAGE]) do
      do
        G.Storage[j].exfil = (nil)
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        G.Link[j].xsect.type_ = (-1)
        G.Link[j].cLossInlet = 0.0
        G.Link[j].cLossOutlet = 0.0
        G.Link[j].cLossAvg = 0.0
        G.Link[j].hasFlapGate = 0
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nlinks[PUMP]) do
      do
        G.Pump[j].pumpCurve = (-1)
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        G.Subcatch[j].rptFlag = 0
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        G.Node[j].rptFlag = 0
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        G.Link[j].rptFlag = 0
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[CURVE]) do
      do
        F.table_init(G.Curve[j])
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[TSERIES]) do
      do
        F.table_init(G.Tseries[j])
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[TIMEPATTERN]) do
      do
        F.inflow_initDwfPattern(j)
      end
      j = j + 1
    end
  end
end

-- project.c:1176
F.deleteObjects = function()
  local G_Nobjects, G_Nnodes = G.Nobjects, G.Nnodes
  local j = 0
  local k = 0
  if (G.Subcatch ~= nil) then
    do
      j = 0
      while (j < G_Nobjects[SUBCATCH]) do
        do
          do
            k = 0
            while (k < G_Nobjects[LANDUSE]) do
              do
                do
                  if (G.Subcatch[j].landFactor[k].buildup ~= nil) then
                    local _ = nil
                    G.Subcatch[j].landFactor[k].buildup = (nil)
                  end
                end
              end
              k = k + 1
            end
          end
          do
            if (G.Subcatch[j].landFactor ~= nil) then
              local _ = nil
              G.Subcatch[j].landFactor = (nil)
            end
          end
          do
            if (G.Subcatch[j].groundwater ~= nil) then
              local _ = nil
              G.Subcatch[j].groundwater = (nil)
            end
          end
          F.gwater_deleteFlowExpression(j)
          do
            if (G.Subcatch[j].snowpack ~= nil) then
              local _ = nil
              G.Subcatch[j].snowpack = (nil)
            end
          end
        end
        j = j + 1
      end
    end
  end
  if (G.Landuse ~= nil) then
    do
      j = 0
      while (j < G_Nobjects[LANDUSE]) do
        do
          do
            if (G.Landuse[j].buildupFunc ~= nil) then
              local _ = nil
              G.Landuse[j].buildupFunc = (nil)
            end
          end
          do
            if (G.Landuse[j].washoffFunc ~= nil) then
              local _ = nil
              G.Landuse[j].washoffFunc = (nil)
            end
          end
        end
        j = j + 1
      end
    end
  end
  if (G.Subcatch ~= nil) then
    do
      j = 0
      while (j < G_Nobjects[SUBCATCH]) do
        do
          do
            if (G.Subcatch[j].initBuildup ~= nil) then
              local _ = nil
              G.Subcatch[j].initBuildup = (nil)
            end
          end
          do
            if (G.Subcatch[j].oldQual ~= nil) then
              local _ = nil
              G.Subcatch[j].oldQual = (nil)
            end
          end
          do
            if (G.Subcatch[j].newQual ~= nil) then
              local _ = nil
              G.Subcatch[j].newQual = (nil)
            end
          end
          do
            if (G.Subcatch[j].pondedQual ~= nil) then
              local _ = nil
              G.Subcatch[j].pondedQual = (nil)
            end
          end
          do
            if (G.Subcatch[j].totalLoad ~= nil) then
              local _ = nil
              G.Subcatch[j].totalLoad = (nil)
            end
          end
        end
        j = j + 1
      end
    end
  end
  if (G.Node ~= nil) then
    do
      j = 0
      while (j < G_Nobjects[NODE]) do
        do
          do
            if (G.Node[j].oldQual ~= nil) then
              local _ = nil
              G.Node[j].oldQual = (nil)
            end
          end
          do
            if (G.Node[j].newQual ~= nil) then
              local _ = nil
              G.Node[j].newQual = (nil)
            end
          end
        end
        j = j + 1
      end
    end
  end
  if (G.Link ~= nil) then
    do
      j = 0
      while (j < G_Nobjects[LINK]) do
        do
          do
            if (G.Link[j].oldQual ~= nil) then
              local _ = nil
              G.Link[j].oldQual = (nil)
            end
          end
          do
            if (G.Link[j].newQual ~= nil) then
              local _ = nil
              G.Link[j].newQual = (nil)
            end
          end
          do
            if (G.Link[j].totalLoad ~= nil) then
              local _ = nil
              G.Link[j].totalLoad = (nil)
            end
          end
        end
        j = j + 1
      end
    end
  end
  F.infil_delete()
  if (G.Node ~= nil) then
    do
      j = 0
      while (j < G_Nnodes[STORAGE]) do
        do
          if (G.Storage[j].exfil ~= nil) then
            do
              if (G.Storage[j].exfil.btmExfil ~= nil) then
                local _ = nil
                G.Storage[j].exfil.btmExfil = (nil)
              end
            end
            do
              if (G.Storage[j].exfil.bankExfil ~= nil) then
                local _ = nil
                G.Storage[j].exfil.bankExfil = (nil)
              end
            end
            do
              if (G.Storage[j].exfil ~= nil) then
                local _ = nil
                G.Storage[j].exfil = (nil)
              end
            end
          end
        end
        j = j + 1
      end
    end
  end
  if (G.Node ~= nil) then
    do
      j = 0
      while (j < G_Nnodes[OUTFALL]) do
        do
          if (G.Outfall[j].wRouted ~= nil) then
            local _ = nil
            G.Outfall[j].wRouted = (nil)
          end
        end
        j = j + 1
      end
    end
  end
  if (G.Node ~= nil) then
    do
      j = 0
      while (j < G_Nobjects[NODE]) do
        do
          F.inflow_deleteExtInflows(j)
          F.inflow_deleteDwfInflows(j)
          F.rdii_deleteRdiiInflow(j)
          F.treatmnt_delete(j)
        end
        j = j + 1
      end
    end
  end
  if (G.Tseries ~= nil) then
    do
      j = 0
      while (j < G_Nobjects[TSERIES]) do
        do
          F.table_deleteEntries(G.Tseries[j])
        end
        j = j + 1
      end
    end
  end
  if (G.Curve ~= nil) then
    do
      j = 0
      while (j < G_Nobjects[CURVE]) do
        do
          F.table_deleteEntries(G.Curve[j])
        end
        j = j + 1
      end
    end
  end
  F.transect_delete()
  F.street_delete()
  F.inlet_delete()
  F.controls_delete()
  F.lid_delete()
  do
    if (G.Gage ~= nil) then
      local _ = nil
      G.Gage = (nil)
    end
  end
  do
    if (G.Subcatch ~= nil) then
      local _ = nil
      G.Subcatch = (nil)
    end
  end
  do
    if (G.Node ~= nil) then
      local _ = nil
      G.Node = (nil)
    end
  end
  do
    if (G.Outfall ~= nil) then
      local _ = nil
      G.Outfall = (nil)
    end
  end
  do
    if (G.Divider ~= nil) then
      local _ = nil
      G.Divider = (nil)
    end
  end
  do
    if (G.Storage ~= nil) then
      local _ = nil
      G.Storage = (nil)
    end
  end
  do
    if (G.Link ~= nil) then
      local _ = nil
      G.Link = (nil)
    end
  end
  do
    if (G.Conduit ~= nil) then
      local _ = nil
      G.Conduit = (nil)
    end
  end
  do
    if (G.Pump ~= nil) then
      local _ = nil
      G.Pump = (nil)
    end
  end
  do
    if (G.Orifice ~= nil) then
      local _ = nil
      G.Orifice = (nil)
    end
  end
  do
    if (G.Weir ~= nil) then
      local _ = nil
      G.Weir = (nil)
    end
  end
  do
    if (G.Outlet ~= nil) then
      local _ = nil
      G.Outlet = (nil)
    end
  end
  do
    if (G.Pollut ~= nil) then
      local _ = nil
      G.Pollut = (nil)
    end
  end
  do
    if (G.Landuse ~= nil) then
      local _ = nil
      G.Landuse = (nil)
    end
  end
  do
    if (G.Pattern ~= nil) then
      local _ = nil
      G.Pattern = (nil)
    end
  end
  do
    if (G.Curve ~= nil) then
      local _ = nil
      G.Curve = (nil)
    end
  end
  do
    if (G.Tseries ~= nil) then
      local _ = nil
      G.Tseries = (nil)
    end
  end
  do
    if (G.Aquifer ~= nil) then
      local _ = nil
      G.Aquifer = (nil)
    end
  end
  do
    if (G.UnitHyd ~= nil) then
      local _ = nil
      G.UnitHyd = (nil)
    end
  end
  do
    if (G.Snowmelt ~= nil) then
      local _ = nil
      G.Snowmelt = (nil)
    end
  end
  do
    if (G.Shape ~= nil) then
      local _ = nil
      G.Shape = (nil)
    end
  end
  do
    if (G.Event ~= nil) then
      local _ = nil
      G.Event = (nil)
    end
  end
end

-- project.c:1304
F.createHashTables = function()
  local G_Htable = G.Htable
  local j = 0
  G.MemPoolAllocated = 0
  do
    j = 0
    while (j < MAX_OBJ_TYPES) do
      do
        G_Htable[j] = F.HTcreate()
        if (G_Htable[j] == (nil)) then
          F.report_writeErrorMsg(ERR_MEMORY, S[0])
        end
      end
      j = j + 1
    end
  end
  if (F.AllocInit() == (nil)) then
    F.report_writeErrorMsg(ERR_MEMORY, S[0])
  else
    G.MemPoolAllocated = 1
  end
end

-- project.c:1325
F.deleteHashTables = function()
  local G_Htable = G.Htable
  local j = 0
  do
    j = 0
    while (j < MAX_OBJ_TYPES) do
      do
        if (G_Htable[j] ~= (nil)) then
          F.HTfree(G_Htable[j])
        end
      end
      j = j + 1
    end
  end
  if (G.MemPoolAllocated ~= 0) then
    F.AllocFreePool()
  end
end

