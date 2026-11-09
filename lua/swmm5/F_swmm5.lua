-- Generated from EPA SWMM 5.2.4 (swmm5.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local SCRATCH_FILE <const> = 1
local ERR_API_NOT_OPEN <const> = 501
local ERR_API_NOT_ENDED <const> = 503
local SUBCATCH <const> = 1
local NODE <const> = 2
local ERR_API_NOT_STARTED <const> = 502
local ERR_TIMESTEP <const> = 107
local swmm_GAGE <const> = 0
local swmm_LINK <const> = 3
local GAGE <const> = 0
local LINK <const> = 3
local swmm_GAGE_RAINFALL <const> = 100
local swmm_SUBCATCH_RPTFLAG <const> = 206
local swmm_NODE_LATFLOW <const> = 306
local swmm_NODE_HEAD <const> = 304
local swmm_NODE_RPTFLAG <const> = 309
local swmm_LINK_SETTING <const> = 407
local swmm_LINK_RPTFLAG <const> = 414
local swmm_ROUTESTEP <const> = 3
local swmm_REPORTSTEP <const> = 5
local swmm_NOREPORT <const> = 7
local swmm_CURRENTDATE <const> = 1
local swmm_SUBCATCH_AREA <const> = 200
local swmm_SUBCATCH_RAINGAGE <const> = 201
local swmm_SUBCATCH_RAINFALL <const> = 202
local swmm_SUBCATCH_EVAP <const> = 203
local swmm_SUBCATCH_INFIL <const> = 204
local swmm_SUBCATCH_RUNOFF <const> = 205
local LANDAREA <const> = 4
local EVAPRATE <const> = 2
local RAINFALL <const> = 0
local FLOW <const> = 10
local swmm_NODE_TYPE <const> = 300
local swmm_NODE_ELEV <const> = 301
local swmm_NODE_MAXDEPTH <const> = 302
local swmm_NODE_DEPTH <const> = 303
local swmm_NODE_VOLUME <const> = 305
local swmm_NODE_INFLOW <const> = 307
local swmm_NODE_OVERFLOW <const> = 308
local LENGTH <const> = 3
local VOLUME <const> = 5
local swmm_LINK_TYPE <const> = 400
local swmm_LINK_NODE1 <const> = 401
local swmm_LINK_NODE2 <const> = 402
local swmm_LINK_LENGTH <const> = 403
local swmm_LINK_SLOPE <const> = 404
local swmm_LINK_FULLDEPTH <const> = 405
local swmm_LINK_FULLFLOW <const> = 406
local swmm_LINK_FLOW <const> = 410
local swmm_LINK_VELOCITY <const> = 412
local swmm_LINK_DEPTH <const> = 411
local swmm_LINK_TOPWIDTH <const> = 413
local swmm_LINK_TIMEOPEN <const> = 408
local swmm_LINK_TIMECLOSED <const> = 409
local CONDUIT <const> = 0
local swmm_STARTDATE <const> = 0
local swmm_ELAPSEDTIME <const> = 2
local swmm_MAXROUTESTEP <const> = 4
local swmm_TOTALSTEPS <const> = 6
local swmm_FLOWUNITS <const> = 8
local OUTFALL <const> = 1
local FIXED_OUTFALL <const> = 2
local PUMP <const> = 1
local SUBCATCH_RAINFALL <const> = 0
local SUBCATCH_EVAP <const> = 2
local SUBCATCH_INFIL <const> = 3
local SUBCATCH_RUNOFF <const> = 4
local NODE_DEPTH <const> = 0
local NODE_HEAD <const> = 1
local NODE_VOLUME <const> = 2
local NODE_LATFLOW <const> = 3
local NODE_INFLOW <const> = 4
local NODE_OVERFLOW <const> = 5
local LINK_FLOW <const> = 0
local LINK_DEPTH <const> = 1
local LINK_VELOCITY <const> = 2
local LINK_CAPACITY <const> = 4
local DW <const> = 4
local _ENV = R.strict

G.Finp = T.TFile()
G.Fout = T.TFile()
G.Frpt = T.TFile()
G.Fclimate = T.TFile()
G.Frain = T.TFile()
G.Frunoff = T.TFile()
G.Frdii = T.TFile()
G.Fhotstart1 = T.TFile()
G.Fhotstart2 = T.TFile()
G.Finflows = T.TFile()
G.Foutflows = T.TFile()
G.Nperiods = 0
G.TotalStepCount = 0
G.ReportStepCount = 0
G.NonConvergeCount = 0
G.Msg = R.buf(1025)
G.ErrorMsg = R.buf(1025)
G.Title = R.bufs(3, 1025)
G.TempDir = R.buf(260)
G.InpDir = R.buf(260)
G.RptFlags = T.TRptFlags()
G.Nobjects = R.fill(18, 0)
G.Nnodes = R.fill(5, 0)
G.Nlinks = R.fill(5, 0)
G.UnitSystem = 0
G.FlowUnits = 0
G.InfilModel = 0
G.RouteModel = 0
G.ForceMainEqn = 0
G.LinkOffsets = 0
G.SurchargeMethod = 0
G.AllowPonding = 0
G.InertDamping = 0
G.NormalFlowLtd = 0
G.SlopeWeighting = 0
G.Compatibility = 0
G.SkipSteadyState = 0
G.IgnoreRainfall = 0
G.IgnoreRDII = 0
G.IgnoreSnowmelt = 0
G.IgnoreGwater = 0
G.IgnoreRouting = 0
G.IgnoreQuality = 0
G.ErrorCode = 0
G.Warnings = 0
G.WetStep = 0
G.DryStep = 0
G.ReportStep = 0
G.RuleStep = 0
G.SweepStart = 0
G.SweepEnd = 0
G.MaxTrials = 0
G.NumThreads = 0
G.NumEvents = 0
G.RouteStep = 0.0
G.MinRouteStep = 0.0
G.LengtheningStep = 0.0
G.StartDryDays = 0.0
G.CourantFactor = 0.0
G.MinSurfArea = 0.0
G.MinSlope = 0.0
G.RunoffError = 0.0
G.GwaterError = 0.0
G.FlowError = 0.0
G.QualError = 0.0
G.HeadTol = 0.0
G.SysFlowTol = 0.0
G.LatFlowTol = 0.0
G.CrownCutoff = 0.0
G.StartDate = 0.0
G.StartTime = 0.0
G.StartDateTime = 0.0
G.EndDate = 0.0
G.EndTime = 0.0
G.EndDateTime = 0.0
G.ReportStartDate = 0.0
G.ReportStartTime = 0.0
G.ReportStart = 0.0
G.ReportTime = 0.0
G.OldRunoffTime = 0.0
G.NewRunoffTime = 0.0
G.OldRoutingTime = 0.0
G.NewRoutingTime = 0.0
G.TotalDuration = 0.0
G.ElapsedTime = 0.0
G.Temp = T.TTemp()
G.Evap = T.TEvap()
G.Wind = T.TWind()
G.Snow = T.TSnow()
G.Adjust = T.TAdjust()
G.Snowmelt = nil
G.Gage = nil
G.Subcatch = nil
G.Aquifer = nil
G.UnitHyd = nil
G.Node = nil
G.Outfall = nil
G.Divider = nil
G.Storage = nil
G.Link = nil
G.Conduit = nil
G.Pump = nil
G.Orifice = nil
G.Weir = nil
G.Outlet = nil
G.Pollut = nil
G.Landuse = nil
G.Pattern = nil
G.Curve = nil
G.Tseries = nil
G.Transect = nil
G.Street = nil
G.Shape = nil
G.Event = nil
G.Ucf = {[0] = {[0] = 43200.0, 1097280.0}, {[0] = 12.0, 304.8}, {[0] = 1036800.0, 26334720.0}, {[0] = 1.0, 0.3048}, {[0] = 2.2956e-05, 9.2903e-06}, {[0] = 1.0, 0.02832}, {[0] = 1.0, 1.608}, {[0] = 1.0, 1.8}, {[0] = 2.203e-06, 1e-06}, {[0] = 43560.0, 3048.0}}
G.Qcf = {[0] = 1.0, 448.831, 0.64632, 0.02832, 28.317, 2.4466}
G.IsOpenFlag = 0
G.IsStartedFlag = 0
G.SaveResultsFlag = 0
G.ExceptionCount = 0
G.DoRunoff = 0
G.DoRouting = 0
G.RoutingDuration = 0.0

-- swmm5.c:186
F.swmm_run = function(f1, f2, f3)
  local G_Msg = G.Msg
  local newHour = 0
  local oldHour = 0
  local theDay = 0
  local theHour = 0
  local elapsedTime = {0.0}
  G.IsOpenFlag = 0
  G.IsStartedFlag = 0
  G.SaveResultsFlag = 1
  G.ErrorCode = 0
  F.writecon(S[642])
  F.swmm_open(f1, f2, f3)
  if (not (G.ErrorCode ~= 0)) then
    F.swmm_start(1)
    if (not (G.ErrorCode ~= 0)) then
      F.writecon(S[643])
      repeat
        do
          F.swmm_step(elapsedTime, 1)
          newHour = R.D2L(((elapsedTime[1] * 24.0)))
          if (newHour > oldHour) then
            theDay = R.D2L(elapsedTime[1])
            theHour = R.D2L(((((elapsedTime[1] - R.floor(elapsedTime[1]))) * 24.0)))
            F.writecon(S[644])
            R.snprintf(G_Msg, 1024, S[645], theDay, theHour)
            F.writecon(G_Msg)
            oldHour = newHour
          end
        end
      until not ((elapsedTime[1] > 0.0) and (not (G.ErrorCode ~= 0)))
      F.writecon(S[646])
      F.writecon(S[647])
    end
    F.swmm_end()
  end
  if ((not (G.ErrorCode ~= 0)) and (G.Fout.mode == SCRATCH_FILE)) then
    F.writecon(S[648])
    F.swmm_report()
  end
  F.swmm_close()
  do return G.ErrorCode end
end

-- swmm5.c:256
F.swmm_open = function(f1, f2, f3)
  local G_InpDir = G.InpDir
  do
    F.datetime_setDateFormat(1)
    G.ErrorCode = 0
    R.cset(G.ErrorMsg, 0, 0)
    G.Warnings = 0
    G.IsOpenFlag = 0
    G.IsStartedFlag = 0
    G.ExceptionCount = 0
    R.strcpy(G_InpDir, S[0])
    F.project_open(f1, f2, f3)
    F.getAbsolutePath(f1, G_InpDir, 260)
    if (G.ErrorCode ~= 0) then
      do return G.ErrorCode end
    end
    G.IsOpenFlag = 1
    F.report_writeLogo()
    F.project_readInput()
    if (G.ErrorCode ~= 0) then
      do return G.ErrorCode end
    end
    F.report_writeTitle()
    F.project_validate()
  end
  do return G.ErrorCode end
end

-- swmm5.c:314
F.swmm_start = function(saveResults)
  local G_RptFlags, G_Nobjects = G.RptFlags, G.Nobjects
  if (G.ErrorCode ~= 0) then
    do return G.ErrorCode end
  end
  if (not (G.IsOpenFlag ~= 0)) then
    G.ErrorCode = ERR_API_NOT_OPEN
    do return (G.ErrorCode) end
  end
  if (G.IsStartedFlag ~= 0) then
    G.ErrorCode = ERR_API_NOT_ENDED
    do return (G.ErrorCode) end
  end
  if (not (G_RptFlags.disabled ~= 0)) then
    if (G_RptFlags.input ~= 0) then
      F.inputrpt_writeInput()
    end
    F.report_writeOptions()
  end
  G.SaveResultsFlag = saveResults
  G.ExceptionCount = 0
  do
    G.ElapsedTime = 0.0
    G.RoutingDuration = G.TotalDuration
    G.NewRunoffTime = 0.0
    G.NewRoutingTime = 0.0
    G.ReportTime = (1000.0 * (G.ReportStep * 1.0))
    G.TotalStepCount = 0
    G.ReportStepCount = 0
    G.NonConvergeCount = 0
    G.IsStartedFlag = 1
    G.RunoffError = 0.0
    G.GwaterError = 0.0
    G.FlowError = 0.0
    G.QualError = 0.0
    if (not (G.IgnoreRainfall ~= 0)) then
      F.rain_open()
    end
    if (G.ErrorCode ~= 0) then
      do return G.ErrorCode end
    end
    F.project_init()
    if (G_Nobjects[SUBCATCH] > 0) then
      G.DoRunoff = 1
    else
      G.DoRunoff = 0
    end
    if ((G_Nobjects[NODE] > 0) and (not (G.IgnoreRouting ~= 0))) then
      G.DoRouting = 1
    else
      G.DoRouting = 0
    end
    F.output_open()
    if (G.DoRunoff ~= 0) then
      F.runoff_open()
    end
    if (not (F.hotstart_open() ~= 0)) then
      do return G.ErrorCode end
    end
    if (G.DoRouting ~= 0) then
      F.routing_open()
    end
    F.massbal_open()
    F.stats_open()
    if ((not (G_RptFlags.disabled ~= 0)) and (G_RptFlags.controls ~= 0)) then
      F.report_writeControlActionsHeading()
    end
  end
  do return G.ErrorCode end
end

-- swmm5.c:410
F.swmm_step = function(elapsedTime, elapsedTime__k)
  elapsedTime[elapsedTime__k] = 0.0
  if (G.ErrorCode ~= 0) then
    do return G.ErrorCode end
  end
  if (not (G.IsOpenFlag ~= 0)) then
    G.ErrorCode = ERR_API_NOT_OPEN
    do return (G.ErrorCode) end
  end
  if (not (G.IsStartedFlag ~= 0)) then
    G.ErrorCode = ERR_API_NOT_STARTED
    do return (G.ErrorCode) end
  end
  do
    if (G.NewRoutingTime < G.RoutingDuration) then
      F.execRouting()
    end
    if (G.SaveResultsFlag ~= 0) then
      F.saveResults()
    end
    if (G.NewRoutingTime < G.RoutingDuration) then
      G.ElapsedTime = (G.NewRoutingTime / 86400000.0)
    else
      G.ElapsedTime = 0.0
    end
    elapsedTime[elapsedTime__k] = G.ElapsedTime
  end
  do return G.ErrorCode end
end

-- swmm5.c:466
F.swmm_stride = function(strideStep, elapsedTime, elapsedTime__k)
  local realRouteStep = G.RouteStep
  elapsedTime[elapsedTime__k] = 0.0
  if (G.ErrorCode ~= 0) then
    do return G.ErrorCode end
  end
  if (not (G.IsOpenFlag ~= 0)) then
    G.ErrorCode = ERR_API_NOT_OPEN
    do return (G.ErrorCode) end
  end
  if (not (G.IsStartedFlag ~= 0)) then
    G.ErrorCode = ERR_API_NOT_STARTED
    do return (G.ErrorCode) end
  end
  G.RoutingDuration = (G.NewRoutingTime + (1000.0 * (strideStep * 1.0)))
  G.RoutingDuration = (((((G.TotalDuration) <= (G.RoutingDuration))) and (G.TotalDuration) or (G.RoutingDuration)))
  if ((strideStep * 1.0) < G.RouteStep) then
    G.RouteStep = (strideStep * 1.0)
  end
  repeat
    do
      F.swmm_step(elapsedTime, elapsedTime__k)
    end
  until not ((elapsedTime[elapsedTime__k] > 0.0) and (not (G.ErrorCode ~= 0)))
  G.RouteStep = realRouteStep
  G.RoutingDuration = G.TotalDuration
  if (G.NewRoutingTime < G.TotalDuration) then
    G.ElapsedTime = (G.NewRoutingTime / 86400000.0)
  else
    G.ElapsedTime = 0.0
  end
  elapsedTime[elapsedTime__k] = G.ElapsedTime
  do return G.ErrorCode end
end

-- swmm5.c:514
F.execRouting = function()
  local nextRoutingTime = 0.0
  local routingStep = 0.0
  do
    G.TotalStepCount = G.TotalStepCount + 1
    if (not (G.DoRouting ~= 0)) then
      routingStep = ((((((G.WetStep) <= (G.ReportStep))) and (G.WetStep) or (G.ReportStep))) * 1.0)
    else
      routingStep = F.routing_getRoutingStep(G.RouteModel, G.RouteStep)
    end
    if (routingStep <= 0.0) then
      G.ErrorCode = ERR_TIMESTEP
      do return end
    end
    nextRoutingTime = (G.NewRoutingTime + (1000.0 * routingStep))
    if (nextRoutingTime > G.RoutingDuration) then
      routingStep = (((G.RoutingDuration - G.NewRoutingTime)) / 1000.0)
      routingStep = (((((routingStep) >= ((1.0 / 1000.0)))) and (routingStep) or ((1.0 / 1000.0))))
      nextRoutingTime = G.RoutingDuration
    end
    if (G.DoRunoff ~= 0) then
      while (G.NewRunoffTime < nextRoutingTime) do
        do
          F.runoff_execute()
          if (G.ErrorCode ~= 0) then
            do return end
          end
        end
      end
    else
      F.climate_setState(F.getDateTime(G.NewRoutingTime))
    end
    if (G.DoRouting ~= 0) then
      F.routing_execute(G.RouteModel, routingStep)
    else
      G.NewRoutingTime = nextRoutingTime
    end
  end
end

-- swmm5.c:579
F.saveResults = function()
  local G_RptFlags = G.RptFlags
  if (G.NewRoutingTime >= G.ReportTime) then
    if (G_RptFlags.averages ~= 0) then
      if (G.NewRoutingTime == G.ReportTime) then
        F.output_updateAvgResults()
      end
      F.output_saveResults(G.ReportTime)
      if (G.NewRoutingTime > G.ReportTime) then
        F.output_updateAvgResults()
      end
    else
      F.output_saveResults(G.ReportTime)
    end
    G.ReportTime = (G.ReportTime + (1000.0 * (G.ReportStep * 1.0)))
  elseif (G_RptFlags.averages ~= 0) then
    F.output_updateAvgResults()
  end
end

-- swmm5.c:618
F.swmm_end = function()
  if (not (G.IsOpenFlag ~= 0)) then
    G.ErrorCode = ERR_API_NOT_OPEN
    do return (G.ErrorCode) end
  end
  if (G.IsStartedFlag ~= 0) then
    if (G.Fout.file ~= nil) then
      F.output_end()
    end
    if ((not (G.ErrorCode ~= 0)) and (G.RptFlags.disabled == 0)) then
      F.massbal_report()
      F.stats_report()
    end
    F.stats_close()
    F.massbal_close()
    if (not (G.IgnoreRainfall ~= 0)) then
      F.rain_close()
    end
    if (G.DoRunoff ~= 0) then
      F.runoff_close()
    end
    if (G.DoRouting ~= 0) then
      F.routing_close(G.RouteModel)
    end
    F.hotstart_close()
    G.IsStartedFlag = 0
  end
  do return G.ErrorCode end
end

-- swmm5.c:655
F.swmm_report = function()
  if (not (G.ErrorCode ~= 0)) then
    F.report_writeReport()
  end
  do return G.ErrorCode end
end

-- swmm5.c:669
F.swmm_writeLine = function(line)
  if (G.IsOpenFlag ~= 0) then
    F.report_writeLine(line)
  end
end

-- swmm5.c:682
F.swmm_close = function()
  local G_Fout, G_Finp, G_Frpt = G.Fout, G.Finp, G.Frpt
  if (G_Fout.file ~= nil) then
    F.output_close()
  end
  if (G.IsOpenFlag ~= 0) then
    F.project_close()
  end
  F.report_writeSysTime()
  if (G_Finp.file ~= (nil)) then
    R.fclose(G_Finp.file)
  end
  if (G_Frpt.file ~= (nil)) then
    R.fclose(G_Frpt.file)
  end
  if (G_Fout.file ~= (nil)) then
    R.fclose(G_Fout.file)
    if (G_Fout.mode == SCRATCH_FILE) then
      R.remove(G_Fout.name)
    end
  end
  G.IsOpenFlag = 0
  G.IsStartedFlag = 0
  do return 0 end
end

-- swmm5.c:708
F.swmm_getMassBalErr = function(runoffErr, runoffErr__k, flowErr, flowErr__k, qualErr, qualErr__k)
  runoffErr[runoffErr__k] = R.f32(0.0)
  flowErr[flowErr__k] = R.f32(0.0)
  qualErr[qualErr__k] = R.f32(0.0)
  if ((G.IsOpenFlag ~= 0) and (not (G.IsStartedFlag ~= 0))) then
    runoffErr[runoffErr__k] = R.f32(G.RunoffError)
    flowErr[flowErr__k] = R.f32(G.FlowError)
    qualErr[qualErr__k] = R.f32(G.QualError)
  end
  do return 0 end
end

-- swmm5.c:734
F.swmm_getVersion = function()
  do return 52004 end
end

-- swmm5.c:749
F.swmm_getWarnings = function()
  do return G.Warnings end
end

-- swmm5.c:760
F.swmm_getError = function(errMsg, msgLen)
  local G_ErrorMsg = G.ErrorMsg
  if ((G.ErrorCode > 0) and (R.strlen(G_ErrorMsg) == 0)) then
    F.error_getMsg(G.ErrorCode, G_ErrorMsg)
  end
  F.sstrncpy(errMsg, G_ErrorMsg, msgLen)
  if ((msgLen > 0) and (errMsg.b[errMsg.o] == 10)) then
    R.cset(errMsg, 0, 32)
  end
  do return G.ErrorCode end
end

-- swmm5.c:780
F.swmm_getCount = function(objType)
  if (not (G.IsOpenFlag ~= 0)) then
    do return 0 end
  end
  if ((objType < swmm_GAGE) or (objType > swmm_LINK)) then
    do return 0 end
  end
  do return G.Nobjects[objType] end
end

-- swmm5.c:795
F.swmm_getName = function(objType, index, name, size)
  local idName = (nil)
  R.cset(name, 0, 0)
  if (not (G.IsOpenFlag ~= 0)) then
    do return end
  end
  if ((objType < swmm_GAGE) or (objType > swmm_LINK)) then
    do return end
  end
  if ((index < 0) or (index >= G.Nobjects[objType])) then
    do return end
  end
  do
    local __sw1 = objType
    if __sw1 == GAGE then goto case2
    elseif __sw1 == SUBCATCH then goto case3
    elseif __sw1 == NODE then goto case4
    elseif __sw1 == LINK then goto case5
    else goto swend1 end
    ::case2::
    do
      idName = G.Gage[index].ID
      goto swend1
    end
    ::case3::
    do
      idName = G.Subcatch[index].ID
      goto swend1
    end
    ::case4::
    do
      idName = G.Node[index].ID
      goto swend1
    end
    ::case5::
    do
      idName = G.Link[index].ID
      goto swend1
    end
    ::swend1::
  end
  if (idName ~= nil) then
    F.sstrncpy(name, idName, size)
  end
end

-- swmm5.c:826
F.swmm_getIndex = function(objType, name)
  if (not (G.IsOpenFlag ~= 0)) then
    do return (-1) end
  end
  if ((objType < swmm_GAGE) or (objType > swmm_LINK)) then
    do return (-1) end
  end
  do return F.project_findObject(objType, name) end
end

-- swmm5.c:842
F.swmm_getValue = function(property, index)
  if (not (G.IsOpenFlag ~= 0)) then
    do return 0.0 end
  end
  if (property < 100) then
    do return F.getSystemValue(property) end
  end
  if (property < 200) then
    do return F.getGageValue(property, index) end
  end
  if (property < 300) then
    do return F.getSubcatchValue(property, index) end
  end
  if (property < 400) then
    do return F.getNodeValue(property, index) end
  end
  if (property < 500) then
    do return F.getLinkValue(property, index) end
  end
  do return 0.0 end
end

-- swmm5.c:867
F.swmm_setValue = function(property, index, value)
  local G_Nobjects = G.Nobjects
  if (not (G.IsOpenFlag ~= 0)) then
    do return end
  end
  do
    local __sw1 = property
    if __sw1 < swmm_NODE_HEAD then
      if __sw1 < swmm_NOREPORT then
        if __sw1 == swmm_ROUTESTEP then goto case9
        elseif __sw1 == swmm_REPORTSTEP then goto case10
        end
      else
        if __sw1 == swmm_NOREPORT then goto case11
        elseif __sw1 == swmm_GAGE_RAINFALL then goto case2
        elseif __sw1 == swmm_SUBCATCH_RPTFLAG then goto case3
        end
      end
    else
      if __sw1 < swmm_NODE_RPTFLAG then
        if __sw1 == swmm_NODE_HEAD then goto case5
        elseif __sw1 == swmm_NODE_LATFLOW then goto case4
        end
      else
        if __sw1 == swmm_NODE_RPTFLAG then goto case6
        elseif __sw1 == swmm_LINK_SETTING then goto case7
        elseif __sw1 == swmm_LINK_RPTFLAG then goto case8
        end
      end
    end
    goto swend1
    ::case2::
    do
      if ((index < 0) or (index >= G_Nobjects[GAGE])) then
        do return end
      end
      if (value >= 0.0) then
        G.Gage[index].apiRainfall = value
      end
      do return end
    end
    ::case3::
    do
      if (((not (G.IsStartedFlag ~= 0)) and (index >= 0)) and (index < G_Nobjects[SUBCATCH])) then
        G.Subcatch[index].rptFlag = (((value > 0.0)) and 1 or 0)
      end
      do return end
    end
    ::case4::
    do
      F.setNodeLatFlow(index, value)
      do return end
    end
    ::case5::
    do
      F.setOutfallStage(index, value)
      do return end
    end
    ::case6::
    do
      if (((not (G.IsStartedFlag ~= 0)) and (index >= 0)) and (index < G_Nobjects[NODE])) then
        G.Node[index].rptFlag = (((value > 0.0)) and 1 or 0)
      end
      do return end
    end
    ::case7::
    do
      F.setLinkSetting(index, value)
      do return end
    end
    ::case8::
    do
      if (((not (G.IsStartedFlag ~= 0)) and (index >= 0)) and (index < G_Nobjects[LINK])) then
        G.Link[index].rptFlag = (((value > 0.0)) and 1 or 0)
      end
      do return end
    end
    ::case9::
    do
      F.setRoutingStep(value)
      do return end
    end
    ::case10::
    do
      if ((not (G.IsStartedFlag ~= 0)) and (value > 0.0)) then
        G.ReportStep = R.D2I(value)
      end
      do return end
    end
    ::case11::
    do
      if (not (G.IsStartedFlag ~= 0)) then
        G.RptFlags.disabled = (((value > 0.0)) and 1 or 0)
      end
      do return end
    end
    ::swend1::
  end
end

-- swmm5.c:922
F.swmm_getSavedValue = function(property, index, period)
  if (not (G.IsOpenFlag ~= 0)) then
    do return 0.0 end
  end
  if (G.IsStartedFlag ~= 0) then
    do return 0.0 end
  end
  if ((period < 1) or (period > G.Nperiods)) then
    do return 0.0 end
  end
  if (property == swmm_CURRENTDATE) then
    do return F.getSavedDate(period) end
  end
  if ((property >= 200) and (property < 300)) then
    do return F.getSavedSubcatchValue(property, index, period) end
  end
  if (property < 400) then
    do return F.getSavedNodeValue(property, index, period) end
  end
  if (property < 500) then
    do return F.getSavedLinkValue(property, index, period) end
  end
  do return 0.0 end
end

-- swmm5.c:949
F.swmm_decodeDate = function(date, year, year__k, month, month__k, day, day__k, hour, hour__k, minute, minute__k, second, second__k, dayOfWeek, dayOfWeek__k)
  F.datetime_decodeDate(date, year, year__k, month, month__k, day, day__k)
  F.datetime_decodeTime(date, hour, hour__k, minute, minute__k, second, second__k)
  dayOfWeek[dayOfWeek__k] = F.datetime_dayOfWeek(date)
end

-- swmm5.c:966
F.getGageValue = function(property, index)
  if ((index < 0) or (index >= G.Nobjects[GAGE])) then
    do return 0.0 end
  end
  if (property == swmm_GAGE_RAINFALL) then
    do return G.Gage[index].reportRainfall end
  end
  do return 0.0 end
end

-- swmm5.c:982
F.getSubcatchValue = function(property, index)
  local subcatch = nil
  if ((index < 0) or (index >= G.Nobjects[SUBCATCH])) then
    do return 0.0 end
  end
  subcatch = G.Subcatch[index]
  do
    local __sw1 = property
    if __sw1 < swmm_SUBCATCH_EVAP then
      if __sw1 == swmm_SUBCATCH_AREA then goto case2
      elseif __sw1 == swmm_SUBCATCH_RAINGAGE then goto case3
      elseif __sw1 == swmm_SUBCATCH_RAINFALL then goto case4
      end
    else
      if __sw1 < swmm_SUBCATCH_RUNOFF then
        if __sw1 == swmm_SUBCATCH_EVAP then goto case5
        elseif __sw1 == swmm_SUBCATCH_INFIL then goto case6
        end
      else
        if __sw1 == swmm_SUBCATCH_RUNOFF then goto case7
        elseif __sw1 == swmm_SUBCATCH_RPTFLAG then goto case8
        end
      end
    end
    goto case9
    ::case2::
    do
      do return (subcatch.area * F.UCF(LANDAREA)) end
    end
    ::case3::
    do
      do return (subcatch.gage * 1.0) end
    end
    ::case4::
    do
      if (subcatch.gage >= 0) then
        do return G.Gage[subcatch.gage].reportRainfall end
      else
        do return 0.0 end
      end
    end
    ::case5::
    do
      do return (subcatch.evapLoss * F.UCF(EVAPRATE)) end
    end
    ::case6::
    do
      do return (subcatch.infilLoss * F.UCF(RAINFALL)) end
    end
    ::case7::
    do
      do return (subcatch.newRunoff * F.UCF(FLOW)) end
    end
    ::case8::
    do
      do return ((((subcatch.rptFlag > 0)) and 1 or 0) * 1.0) end
    end
    ::case9::
    do
      do return 0.0 end
    end
    ::swend1::
  end
end

-- swmm5.c:1019
F.getNodeValue = function(property, index)
  local node = nil
  if ((index < 0) or (index >= G.Nobjects[NODE])) then
    do return 0.0 end
  end
  node = G.Node[index]
  do
    local __sw1 = property
    if __sw1 < swmm_NODE_VOLUME then
      if __sw1 < swmm_NODE_MAXDEPTH then
        if __sw1 == swmm_NODE_TYPE then goto case2
        elseif __sw1 == swmm_NODE_ELEV then goto case3
        end
      else
        if __sw1 == swmm_NODE_MAXDEPTH then goto case4
        elseif __sw1 == swmm_NODE_DEPTH then goto case5
        elseif __sw1 == swmm_NODE_HEAD then goto case6
        end
      end
    else
      if __sw1 < swmm_NODE_INFLOW then
        if __sw1 == swmm_NODE_VOLUME then goto case7
        elseif __sw1 == swmm_NODE_LATFLOW then goto case8
        end
      else
        if __sw1 == swmm_NODE_INFLOW then goto case9
        elseif __sw1 == swmm_NODE_OVERFLOW then goto case10
        elseif __sw1 == swmm_NODE_RPTFLAG then goto case11
        end
      end
    end
    goto case12
    ::case2::
    do
      do return (node.type_ * 1.0) end
    end
    ::case3::
    do
      do return (node.invertElev * F.UCF(LENGTH)) end
    end
    ::case4::
    do
      do return (node.fullDepth * F.UCF(LENGTH)) end
    end
    ::case5::
    do
      do return (node.newDepth * F.UCF(LENGTH)) end
    end
    ::case6::
    do
      do return (((node.newDepth + node.invertElev)) * F.UCF(LENGTH)) end
    end
    ::case7::
    do
      do return (node.newVolume * F.UCF(VOLUME)) end
    end
    ::case8::
    do
      do return (node.newLatFlow * F.UCF(FLOW)) end
    end
    ::case9::
    do
      do return (node.inflow * F.UCF(FLOW)) end
    end
    ::case10::
    do
      do return (node.overflow * F.UCF(FLOW)) end
    end
    ::case11::
    do
      do return ((((node.rptFlag > 0)) and 1 or 0) * 1.0) end
    end
    ::case12::
    do
      do return 0.0 end
    end
    ::swend1::
  end
end

-- swmm5.c:1059
F.getLinkValue = function(property, index)
  local G_Conduit = G.Conduit
  local link = nil
  if ((index < 0) or (index >= G.Nobjects[LINK])) then
    do return 0.0 end
  end
  link = G.Link[index]
  do
    local __sw1 = property
    if __sw1 < swmm_LINK_SETTING then
      if __sw1 < swmm_LINK_LENGTH then
        if __sw1 == swmm_LINK_TYPE then goto case2
        elseif __sw1 == swmm_LINK_NODE1 then goto case3
        elseif __sw1 == swmm_LINK_NODE2 then goto case4
        end
      else
        if __sw1 < swmm_LINK_FULLDEPTH then
          if __sw1 == swmm_LINK_LENGTH then goto case5
          elseif __sw1 == swmm_LINK_SLOPE then goto case6
          end
        else
          if __sw1 == swmm_LINK_FULLDEPTH then goto case7
          elseif __sw1 == swmm_LINK_FULLFLOW then goto case8
          end
        end
      end
    else
      if __sw1 < swmm_LINK_DEPTH then
        if __sw1 < swmm_LINK_TIMECLOSED then
          if __sw1 == swmm_LINK_SETTING then goto case13
          elseif __sw1 == swmm_LINK_TIMEOPEN then goto case14
          end
        else
          if __sw1 == swmm_LINK_TIMECLOSED then goto case15
          elseif __sw1 == swmm_LINK_FLOW then goto case9
          end
        end
      else
        if __sw1 < swmm_LINK_TOPWIDTH then
          if __sw1 == swmm_LINK_DEPTH then goto case11
          elseif __sw1 == swmm_LINK_VELOCITY then goto case10
          end
        else
          if __sw1 == swmm_LINK_TOPWIDTH then goto case12
          elseif __sw1 == swmm_LINK_RPTFLAG then goto case16
          end
        end
      end
    end
    goto case17
    ::case2::
    do
      do return (link.type_ * 1.0) end
    end
    ::case3::
    do
      do return (link.node1 * 1.0) end
    end
    ::case4::
    do
      do return (link.node2 * 1.0) end
    end
    ::case5::
    do
      if (link.type_ == CONDUIT) then
        do return (G_Conduit[link.subIndex].length * F.UCF(LENGTH)) end
      else
        do return 0.0 end
      end
    end
    ::case6::
    do
      if (link.type_ == CONDUIT) then
        do return G_Conduit[link.subIndex].slope end
      else
        do return 0.0 end
      end
    end
    ::case7::
    do
      do return (link.xsect.yFull * F.UCF(LENGTH)) end
    end
    ::case8::
    do
      do return (link.qFull * F.UCF(FLOW)) end
    end
    ::case9::
    do
      do return ((link.newFlow * F.UCF(FLOW)) * (link.direction * 1.0)) end
    end
    ::case10::
    do
      do return (F.link_getVelocity(index, m_abs(link.newFlow), link.newDepth) * F.UCF(LENGTH)) end
    end
    ::case11::
    do
      do return (link.newDepth * F.UCF(LENGTH)) end
    end
    ::case12::
    do
      if (link.type_ == CONDUIT) then
        do return (F.xsect_getWofY(link.xsect, link.newDepth) * F.UCF(LENGTH)) end
      else
        do return 0.0 end
      end
    end
    ::case13::
    do
      do return link.setting end
    end
    ::case14::
    do
      if (link.setting > 0.0) then
        do return (((F.getDateTime(G.NewRoutingTime) - link.timeLastSet)) * 24.0) end
      else
        do return 0.0 end
      end
    end
    ::case15::
    do
      if (link.setting == 0.0) then
        do return (((F.getDateTime(G.NewRoutingTime) - link.timeLastSet)) * 24.0) end
      else
        do return 0.0 end
      end
    end
    ::case16::
    do
      do return ((((link.rptFlag > 0)) and 1 or 0) * 1.0) end
    end
    ::case17::
    do
      do return 0.0 end
    end
    ::swend1::
  end
end

-- swmm5.c:1126
F.getSystemValue = function(property)
  do
    local __sw1 = property
    if __sw1 < swmm_MAXROUTESTEP then
      if __sw1 < swmm_ELAPSEDTIME then
        if __sw1 == swmm_STARTDATE then goto case2
        elseif __sw1 == swmm_CURRENTDATE then goto case3
        end
      else
        if __sw1 == swmm_ELAPSEDTIME then goto case4
        elseif __sw1 == swmm_ROUTESTEP then goto case5
        end
      end
    else
      if __sw1 < swmm_TOTALSTEPS then
        if __sw1 == swmm_MAXROUTESTEP then goto case6
        elseif __sw1 == swmm_REPORTSTEP then goto case7
        end
      else
        if __sw1 == swmm_TOTALSTEPS then goto case8
        elseif __sw1 == swmm_NOREPORT then goto case9
        elseif __sw1 == swmm_FLOWUNITS then goto case10
        end
      end
    end
    goto case11
    ::case2::
    do
      do return G.StartDateTime end
    end
    ::case3::
    do
      do return (G.StartDateTime + G.ElapsedTime) end
    end
    ::case4::
    do
      do return G.ElapsedTime end
    end
    ::case5::
    do
      do return G.RouteStep end
    end
    ::case6::
    do
      do return F.getMaxRouteStep() end
    end
    ::case7::
    do
      do return (G.ReportStep * 1.0) end
    end
    ::case8::
    do
      do return (G.Nperiods * 1.0) end
    end
    ::case9::
    do
      do return (G.RptFlags.disabled * 1.0) end
    end
    ::case10::
    do
      do return (G.FlowUnits * 1.0) end
    end
    ::case11::
    do
      do return 0.0 end
    end
    ::swend1::
  end
end

-- swmm5.c:1159
F.setNodeLatFlow = function(index, value)
  if ((index < 0) or (index >= G.Nobjects[NODE])) then
    do return end
  end
  G.Node[index].apiExtInflow = (value / F.UCF(FLOW))
end

-- swmm5.c:1173
F.setOutfallStage = function(index, value)
  local G_Outfall = G.Outfall
  local node = nil
  if ((index < 0) or (index >= G.Nobjects[NODE])) then
    do return end
  end
  node = G.Node[index]
  if (node.type_ ~= OUTFALL) then
    do return end
  end
  G_Outfall[node.subIndex].fixedStage = (value / F.UCF(LENGTH))
  G_Outfall[node.subIndex].type_ = FIXED_OUTFALL
end

-- swmm5.c:1192
F.setLinkSetting = function(index, value)
  local link = nil
  if ((index < 0) or (index >= G.Nobjects[LINK])) then
    do return end
  end
  link = G.Link[index]
  if ((value < 0.0) or (link.type_ == CONDUIT)) then
    do return end
  end
  if ((link.type_ ~= PUMP) and (value > 1.0)) then
    value = 1.0
  end
  if (link.targetSetting == value) then
    do return end
  end
  link.targetSetting = value
  if ((link.targetSetting * link.setting) == 0.0) then
    link.timeLastSet = (G.StartDateTime + G.ElapsedTime)
  end
  F.link_setSetting(index, 0.0)
end

-- swmm5.c:1217
F.getSavedDate = function(period)
  local days = {0.0}
  F.output_readDateTime(period, days, 1)
  do return days[1] end
end

-- swmm5.c:1230
F.getSavedSubcatchValue = function(property, index, period)
  local G_SubcatchResults = G.SubcatchResults
  local outIndex = (G.Subcatch[index].rptFlag - 1)
  if (outIndex < 0) then
    do return 0.0 end
  end
  F.output_readSubcatchResults(period, outIndex)
  do
    local __sw1 = property
    if __sw1 == swmm_SUBCATCH_RAINFALL then goto case2
    elseif __sw1 == swmm_SUBCATCH_EVAP then goto case3
    elseif __sw1 == swmm_SUBCATCH_INFIL then goto case4
    elseif __sw1 == swmm_SUBCATCH_RUNOFF then goto case5
    else goto case6 end
    ::case2::
    do
      do return G_SubcatchResults[SUBCATCH_RAINFALL] end
    end
    ::case3::
    do
      do return G_SubcatchResults[SUBCATCH_EVAP] end
    end
    ::case4::
    do
      do return G_SubcatchResults[SUBCATCH_INFIL] end
    end
    ::case5::
    do
      do return G_SubcatchResults[SUBCATCH_RUNOFF] end
    end
    ::case6::
    do
      do return 0.0 end
    end
    ::swend1::
  end
end

-- swmm5.c:1265
F.getSavedNodeValue = function(property, index, period)
  local G_NodeResults = G.NodeResults
  local outIndex = (G.Node[index].rptFlag - 1)
  if (outIndex < 0) then
    do return 0.0 end
  end
  F.output_readNodeResults(period, outIndex)
  do
    local __sw1 = property
    if __sw1 < swmm_NODE_LATFLOW then
      if __sw1 == swmm_NODE_DEPTH then goto case2
      elseif __sw1 == swmm_NODE_HEAD then goto case3
      elseif __sw1 == swmm_NODE_VOLUME then goto case4
      end
    else
      if __sw1 == swmm_NODE_LATFLOW then goto case5
      elseif __sw1 == swmm_NODE_INFLOW then goto case6
      elseif __sw1 == swmm_NODE_OVERFLOW then goto case7
      end
    end
    goto case8
    ::case2::
    do
      do return G_NodeResults[NODE_DEPTH] end
    end
    ::case3::
    do
      do return G_NodeResults[NODE_HEAD] end
    end
    ::case4::
    do
      do return G_NodeResults[NODE_VOLUME] end
    end
    ::case5::
    do
      do return G_NodeResults[NODE_LATFLOW] end
    end
    ::case6::
    do
      do return G_NodeResults[NODE_INFLOW] end
    end
    ::case7::
    do
      do return G_NodeResults[NODE_OVERFLOW] end
    end
    ::case8::
    do
      do return 0.0 end
    end
    ::swend1::
  end
end

-- swmm5.c:1304
F.getSavedLinkValue = function(property, index, period)
  local G_Link, G_LinkResults = G.Link, G.LinkResults
  local y = 0.0
  local w = 0.0
  local outIndex = (G_Link[index].rptFlag - 1)
  if (outIndex < 0) then
    do return 0.0 end
  end
  F.output_readLinkResults(period, outIndex)
  do
    local __sw1 = property
    if __sw1 == swmm_LINK_FLOW then goto case2
    elseif __sw1 == swmm_LINK_DEPTH then goto case3
    elseif __sw1 == swmm_LINK_VELOCITY then goto case4
    elseif __sw1 == swmm_LINK_TOPWIDTH then goto case5
    elseif __sw1 == swmm_LINK_SETTING then goto case6
    else goto case7 end
    ::case2::
    do
      do return G_LinkResults[LINK_FLOW] end
    end
    ::case3::
    do
      do return G_LinkResults[LINK_DEPTH] end
    end
    ::case4::
    do
      do return G_LinkResults[LINK_VELOCITY] end
    end
    ::case5::
    do
      y = (G_LinkResults[LINK_DEPTH] / F.UCF(LENGTH))
      w = F.xsect_getWofY(G_Link[index].xsect, y)
      do return (w * F.UCF(LENGTH)) end
    end
    ::case6::
    do
      do return G_LinkResults[LINK_CAPACITY] end
    end
    ::case7::
    do
      do return 0.0 end
    end
    ::swend1::
  end
end

-- swmm5.c:1345
F.getMaxRouteStep = function()
  local tmpCourantFactor = G.CourantFactor
  local result = G.RouteStep
  if ((not (G.IsStartedFlag ~= 0)) or (G.RouteModel ~= DW)) then
    do return result end
  end
  G.CourantFactor = 1.0
  result = F.routing_getRoutingStep(G.RouteModel, G.MinRouteStep)
  G.CourantFactor = tmpCourantFactor
  do return result end
end

-- swmm5.c:1360
F.setRoutingStep = function(value)
  if (value <= 0.0) then
    do return end
  end
  if (value <= G.MinRouteStep) then
    value = G.MinRouteStep
  end
  G.CourantFactor = 0.0
  G.RouteStep = value
end

-- swmm5.c:1378
F.UCF = function(u)
  if (u < FLOW) then
    do return G.Ucf[u][G.UnitSystem] end
  else
    do return G.Qcf[G.FlowUnits] end
  end
end

-- swmm5.c:1453
F.strcomp = function(s1, s2)
  local i = 0
  do
    i = 0
    while (((((((s1.b[s1.o + i]) >= 97) and ((s1.b[s1.o + i]) <= 122))) and (((s1.b[s1.o + i]) & (~32))) or (s1.b[s1.o + i]))) == ((((((s2.b[s2.o + i]) >= 97) and ((s2.b[s2.o + i]) <= 122))) and (((s2.b[s2.o + i]) & (~32))) or (s2.b[s2.o + i])))) do
      do
        if ((not (s1.b[s1.o + (i + 1)] ~= 0)) and (not (s2.b[s2.o + (i + 1)] ~= 0))) then
          do return (1) end
        end
      end
      i = i + 1
    end
  end
  do return (0) end
end

-- swmm5.c:1518
F.getElapsedTime = function(aDate, days, days__k, hrs, hrs__k, mins, mins__k)
  local x = 0.0
  local secs = {0}
  x = (aDate - G.ReportStart)
  if (x <= 0.0) then
    days[days__k] = 0
    hrs[hrs__k] = 0
    mins[mins__k] = 0
  else
    days[days__k] = R.D2I(x)
    F.datetime_decodeTime(x, hrs, hrs__k, mins, mins__k, secs, 1)
  end
end

-- swmm5.c:1543
F.getDateTime = function(elapsedMsec)
  do return F.datetime_addSeconds(G.StartDateTime, (((elapsedMsec + 1.0)) / 1000.0)) end
end

-- swmm5.c:1556
F.isRelativePath = function(fname)
  if (R.strchr(fname, 58) ~= nil) then
    do return 0 end
  end
  if (fname.b[fname.o] == 92) then
    do return 0 end
  end
  if (fname.b[fname.o] == 47) then
    do return 0 end
  end
  do return 1 end
end

-- swmm5.c:1617
F.addAbsolutePath = function(fname)
  local n = 0
  local buffer = R.buf(259)
  if (F.isRelativePath(fname) ~= 0) then
    n = R.snprintf(buffer, 259, S[649], G.InpDir, fname)
    if (n > 0) then
      F.sstrncpy(fname, buffer, 259)
    end
  end
  do return fname end
end

-- swmm5.c:1638
F.writecon = function(s)
  R.fprintf(R.stdout, S[169], s)
  R.fflush(R.stdout)
end

