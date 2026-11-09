-- Generated from EPA SWMM 5.2.4 (routing.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local LINK <const> = 3
local ERR_MEMORY <const> = 101
local NO_FILE <const> = 0
local POLLUT <const> = 4
local NODE <const> = 2
local FLOW_INFLOW <const> = 5
local EXTERNAL_INFLOW <const> = 0
local OUTFALL <const> = 1
local CONCEN_INFLOW <const> = 6
local DRY_WEATHER_INFLOW <const> = 1
local SUBCATCH <const> = 1
local WET_WEATHER_INFLOW <const> = 2
local GROUNDWATER_INFLOW <const> = 3
local RDII_INFLOW <const> = 4
local USE_FILE <const> = 2
local STORAGE <const> = 2
local CONDUIT <const> = 0
local _ENV = R.strict

G.SortedLinks = nil
G.NextEvent = 0
G.BetweenEvents = 0
G.NewRuleTime = 0.0

-- routing.c:93
F.routing_open = function()
  local G_Nobjects = G.Nobjects
  if (not (F.treatmnt_open() ~= 0)) then
    do return G.ErrorCode end
  end
  G.SortedLinks = (nil)
  if (G_Nobjects[LINK] > 0) then
    G.SortedLinks = R.fill(G_Nobjects[LINK], 0)
    if (not (G.SortedLinks ~= nil)) then
      F.report_writeErrorMsg(ERR_MEMORY, S[0])
      do return G.ErrorCode end
    end
    F.toposort_sortLinks(G.SortedLinks)
    if (G.ErrorCode ~= 0) then
      do return G.ErrorCode end
    end
  end
  F.iface_openRoutingFiles()
  F.flowrout_init(G.RouteModel)
  if (G.Fhotstart1.mode == NO_FILE) then
    F.qualrout_init()
  end
  if (G.NumEvents > 0) then
    F.sortEvents()
  end
  G.NextEvent = 0
  G.BetweenEvents = (((G.NumEvents > 0)) and 1 or 0)
  G.NewRuleTime = 0.0
  do return G.ErrorCode end
end

-- routing.c:134
F.routing_close = function(routingModel)
  F.iface_closeRoutingFiles()
  F.flowrout_close(routingModel)
  F.treatmnt_close()
  do
    if (G.SortedLinks ~= nil) then
      local _ = nil
      G.SortedLinks = (nil)
    end
  end
end

-- routing.c:152
F.routing_getRoutingStep = function(routingModel, fixedStep)
  local G_Event = G.Event
  local date1 = 0.0
  local date2 = 0.0
  local nextTime = 0.0
  local routingStep = 0.0
  local nextRuleTime = 0.0
  local nextRoutingTime = 0.0
  if (G.Nobjects[LINK] == 0) then
    do return fixedStep end
  end
  if ((G.NumEvents > 0) and (G.BetweenEvents ~= 0)) then
    nextTime = (((((G.NewRunoffTime) <= (G.ReportTime))) and (G.NewRunoffTime) or (G.ReportTime)))
    date1 = F.getDateTime(G.NewRoutingTime)
    date2 = F.getDateTime(nextTime)
    if ((date2 > date1) and (date2 < G_Event[G.NextEvent].start)) then
      routingStep = (((nextTime - G.NewRoutingTime)) / 1000.0)
    else
      date1 = F.getDateTime((G.NewRoutingTime + (1000.0 * fixedStep)))
      if (date1 < G_Event[G.NextEvent].start) then
        do return fixedStep end
      end
    end
  end
  if (routingStep == 0.0) then
    routingStep = F.flowrout_getRoutingStep(routingModel, fixedStep)
  end
  if (G.RuleStep > 0) then
    nextRuleTime = (G.NewRuleTime + (1000.0 * (G.RuleStep * 1.0)))
    nextRoutingTime = (G.NewRoutingTime + (1000.0 * routingStep))
    if (nextRoutingTime >= nextRuleTime) then
      routingStep = (((nextRuleTime - G.NewRoutingTime)) / 1000.0)
    end
  end
  do return routingStep end
end

-- routing.c:203
F.routing_execute = function(routingModel, routingStep)
  local G_Nobjects = G.Nobjects
  local trialsCount = 1
  local actionCount = 0
  local inSteadyState = 1
  local currentDate = 0.0
  local stepFlowError = 0.0
  if (G.ErrorCode ~= 0) then
    do return end
  end
  F.massbal_updateRoutingTotals((routingStep / 2.0))
  currentDate = F.getDateTime(G.NewRoutingTime)
  actionCount = F.evaluateControlRules(currentDate, routingStep)
  stepFlowError = F.massbal_getStepFlowError()
  F.massbal_initTimeStepTotals()
  F.initSystemInflows()
  G.BetweenEvents = F.isBetweenEvents(currentDate)
  if (G.BetweenEvents == 0) then
    F.addSystemInflows(currentDate, routingStep)
    F.inlet_findCapturedFlows(routingStep)
    inSteadyState = F.isInSteadyState(actionCount, stepFlowError)
    if (inSteadyState == 0) then
      trialsCount = F.routeFlow(routingModel, routingStep)
    end
    if ((G_Nobjects[POLLUT] > 0) and (not (G.IgnoreQuality ~= 0))) then
      F.inlet_adjustQualInflows()
      F.qualrout_execute(routingStep)
    end
    F.removeSystemOutflows(routingStep)
    F.inlet_adjustQualOutflows()
    if (G_Nobjects[LINK] > 0) then
      F.stats_updateFlowStats(routingStep, F.getDateTime(G.NewRoutingTime))
      F.stats_updateTimeStepStats(routingStep, trialsCount, inSteadyState)
    end
  end
  F.massbal_updateRoutingTotals((routingStep / 2.0))
end

-- routing.c:269
F.evaluateControlRules = function(currentDate, routingStep)
  local G_Nobjects, G_Link = G.Nobjects, G.Link
  local j = 0
  local actionCount = 0
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        F.link_setTargetSetting(j)
      end
      j = j + 1
    end
  end
  if ((G.RuleStep == 0) or (m_abs((G.NewRoutingTime - G.NewRuleTime)) < 1.0)) then
    F.controls_evaluate(currentDate, (currentDate - G.StartDateTime), (routingStep / 86400.0))
  end
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        if (G_Link[j].targetSetting ~= G_Link[j].setting) then
          if ((G_Link[j].targetSetting * G_Link[j].setting) == 0.0) then
            G_Link[j].timeLastSet = currentDate
          end
          F.link_setSetting(j, routingStep)
          actionCount = actionCount + 1
        end
      end
      j = j + 1
    end
  end
  G.OldRoutingTime = G.NewRoutingTime
  G.NewRoutingTime = (G.NewRoutingTime + (1000.0 * routingStep))
  if (m_abs((G.NewRoutingTime - ((G.NewRuleTime + (1000.0 * (G.RuleStep * 1.0)))))) < 1.0) then
    G.NewRuleTime = (G.NewRuleTime + (1000.0 * (G.RuleStep * 1.0)))
  end
  do return actionCount end
end

-- routing.c:312
F.initSystemInflows = function()
  local G_Nobjects, G_Node = G.Nobjects, G.Node
  local j = 0
  if (G_Nobjects[POLLUT] > 0) then
    do
      j = 0
      while (j < G_Nobjects[NODE]) do
        do
          F.node_setOldQualState(j)
        end
        j = j + 1
      end
    end
    do
      j = 0
      while (j < G_Nobjects[LINK]) do
        do
          F.link_setOldQualState(j)
        end
        j = j + 1
      end
    end
  end
  F.infil_setInfilFactor((-1))
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        G_Node[j].oldLatFlow = G_Node[j].newLatFlow
        G_Node[j].newLatFlow = 0.0
      end
      j = j + 1
    end
  end
end

-- routing.c:337
F.isBetweenEvents = function(currentDate)
  local G_Event = G.Event
  if (G.NumEvents == 0) then
    do return 0 end
  end
  if (currentDate > G_Event[G.NextEvent].end_) then
    G.NextEvent = G.NextEvent + 1
    do return 1 end
  elseif (currentDate >= G_Event[G.NextEvent].start) then
    do return 0 end
  end
  do return 1 end
end

-- routing.c:359
F.addSystemInflows = function(currentDate, routingStep)
  local G_Nobjects, G_Node = G.Nobjects, G.Node
  local j = 0
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        G_Node[j].losses = F.node_getLosses(j, routingStep)
      end
      j = j + 1
    end
  end
  F.addExternalInflows(currentDate)
  F.addDryWeatherInflows(currentDate)
  F.addWetWeatherInflows(G.OldRoutingTime)
  F.addGroundwaterInflows(G.OldRoutingTime)
  F.addLidDrainInflows(G.OldRoutingTime)
  F.addRdiiInflows(currentDate)
  F.addIfaceInflows(currentDate)
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        G_Node[j].qualInflow = (((((0.0) >= (G_Node[j].newLatFlow))) and (0.0) or (G_Node[j].newLatFlow)))
      end
      j = j + 1
    end
  end
end

-- routing.c:383
F.isInSteadyState = function(actionCount, stepFlowError)
  if (G.SkipSteadyState ~= 0) then
    if ((((G.OldRoutingTime == 0.0) or (actionCount > 0)) or (m_abs(stepFlowError) > G.SysFlowTol)) or (F.inflowHasChanged() ~= 0)) then
      do return 0 end
    else
      do return 1 end
    end
  end
  do return 0 end
end

-- routing.c:399
F.routeFlow = function(routingModel, routingStep)
  local G_Nobjects = G.Nobjects
  local j = 0
  local stepCount = 1
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        F.link_setOldHydState(j)
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        F.node_setOldHydState(j)
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        F.node_initFlows(j, routingStep)
      end
      j = j + 1
    end
  end
  if (G_Nobjects[LINK] > 0) then
    stepCount = F.flowrout_execute(G.SortedLinks, routingModel, routingStep)
  end
  do return stepCount end
end

-- routing.c:425
F.removeSystemOutflows = function(routingStep)
  F.removeStorageLosses(routingStep)
  F.removeConduitLosses()
  F.removeOutflows(routingStep)
end

-- routing.c:435
F.addExternalInflows = function(currentDate)
  local G_Nobjects, G_Node = G.Nobjects, G.Node
  local j = 0
  local p = 0
  local q = 0.0
  local w = 0.0
  local inflow = nil
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        q = G_Node[j].apiExtInflow
        inflow = G_Node[j].extInflow
        while (inflow ~= nil) do
          do
            if (inflow.type_ == FLOW_INFLOW) then
              q = (q + (F.inflow_getExtInflow(inflow, currentDate)))
              break
            else
              inflow = inflow.next_
            end
          end
        end
        if (m_abs(q) < 1e-05) then
          q = 0.0
        end
        G_Node[j].newLatFlow = (G_Node[j].newLatFlow + q)
        if (q >= 0.0) then
          F.massbal_addInflowFlow(EXTERNAL_INFLOW, q)
        else
          F.massbal_addOutflowFlow((-q), 0)
          goto continue1
        end
        if ((G_Node[j].type_ == OUTFALL) and (G_Node[j].oldNetInflow < 0.0)) then
          q = (q - G_Node[j].oldNetInflow)
        end
        inflow = G_Node[j].extInflow
        while (inflow ~= nil) do
          do
            if (inflow.type_ ~= FLOW_INFLOW) then
              p = inflow.param
              w = F.inflow_getExtInflow(inflow, currentDate)
              if (inflow.type_ == CONCEN_INFLOW) then
                w = (w * q)
              end
              G_Node[j].newQual[p] = (G_Node[j].newQual[p] + w)
              F.massbal_addInflowQual(EXTERNAL_INFLOW, p, w)
            end
            inflow = inflow.next_
          end
        end
      end
      ::continue1::
      j = j + 1
    end
  end
end

-- routing.c:498
F.addDryWeatherInflows = function(currentDate)
  local G_Nobjects, G_Node, G_Pollut = G.Nobjects, G.Node, G.Pollut
  local j = 0
  local p = 0
  local month = 0
  local day = 0
  local hour = 0
  local q = 0.0
  local w = 0.0
  local inflow = nil
  month = (F.datetime_monthOfYear(currentDate) - 1)
  day = (F.datetime_dayOfWeek(currentDate) - 1)
  hour = F.datetime_hourOfDay(currentDate)
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        inflow = G_Node[j].dwfInflow
        if (not (inflow ~= nil)) then
          goto continue1
        end
        q = 0.0
        while (inflow ~= nil) do
          do
            if (inflow.param < 0) then
              q = F.inflow_getDwfInflow(inflow, month, day, hour)
              break
            end
            inflow = inflow.next_
          end
        end
        if (m_abs(q) < 1e-05) then
          q = 0.0
        end
        G_Node[j].newLatFlow = (G_Node[j].newLatFlow + q)
        F.massbal_addInflowFlow(DRY_WEATHER_INFLOW, q)
        if (q <= 0.0) then
          goto continue1
        end
        do
          p = 0
          while (p < G_Nobjects[POLLUT]) do
            do
              if (G_Pollut[p].dwfConcen > 0.0) then
                w = (q * G_Pollut[p].dwfConcen)
                G_Node[j].newQual[p] = (G_Node[j].newQual[p] + w)
                F.massbal_addInflowQual(DRY_WEATHER_INFLOW, p, w)
              end
            end
            p = p + 1
          end
        end
        inflow = G_Node[j].dwfInflow
        while (inflow ~= nil) do
          do
            if (inflow.param >= 0) then
              p = inflow.param
              w = (q * F.inflow_getDwfInflow(inflow, month, day, hour))
              G_Node[j].newQual[p] = (G_Node[j].newQual[p] + w)
              F.massbal_addInflowQual(DRY_WEATHER_INFLOW, p, w)
              if (G_Pollut[p].dwfConcen > 0.0) then
                w = (q * G_Pollut[p].dwfConcen)
                G_Node[j].newQual[p] = (G_Node[j].newQual[p] - w)
                F.massbal_addInflowQual(DRY_WEATHER_INFLOW, p, (-w))
              end
            end
            inflow = inflow.next_
          end
        end
      end
      ::continue1::
      j = j + 1
    end
  end
end

-- routing.c:579
F.addWetWeatherInflows = function(routingTime)
  local G_Nobjects, G_Subcatch, G_Node = G.Nobjects, G.Subcatch, G.Node
  local i = 0
  local j = 0
  local p = 0
  local q = 0.0
  local w = 0.0
  local f = 0.0
  if (G_Nobjects[SUBCATCH] == 0) then
    do return end
  end
  f = (((routingTime - G.OldRunoffTime)) / ((G.NewRunoffTime - G.OldRunoffTime)))
  if (f < 0.0) then
    f = 0.0
  end
  if (f > 1.0) then
    f = 1.0
  end
  do
    i = 0
    while (i < G_Nobjects[SUBCATCH]) do
      do
        j = G_Subcatch[i].outNode
        if (j >= 0) then
          q = F.subcatch_getWtdOutflow(i, f)
          G_Node[j].newLatFlow = (G_Node[j].newLatFlow + q)
          F.massbal_addInflowFlow(WET_WEATHER_INFLOW, q)
          do
            p = 0
            while (p < G_Nobjects[POLLUT]) do
              do
                w = F.surfqual_getWtdWashoff(i, p, f)
                G_Node[j].newQual[p] = (G_Node[j].newQual[p] + w)
                F.massbal_addInflowQual(WET_WEATHER_INFLOW, p, w)
              end
              p = p + 1
            end
          end
        end
      end
      i = i + 1
    end
  end
end

-- routing.c:621
F.addGroundwaterInflows = function(routingTime)
  local G_Nobjects, G_Subcatch, G_Node, G_Pollut = G.Nobjects, G.Subcatch, G.Node, G.Pollut
  local i = 0
  local j = 0
  local p = 0
  local q = 0.0
  local w = 0.0
  local f = 0.0
  local gw = nil
  if (G_Nobjects[SUBCATCH] == 0) then
    do return end
  end
  f = (((routingTime - G.OldRunoffTime)) / ((G.NewRunoffTime - G.OldRunoffTime)))
  if (f < 0.0) then
    f = 0.0
  end
  if (f > 1.0) then
    f = 1.0
  end
  do
    i = 0
    while (i < G_Nobjects[SUBCATCH]) do
      do
        gw = G_Subcatch[i].groundwater
        if (gw ~= nil) then
          j = gw.node
          if (j >= 0) then
            q = ((((((1.0 - f)) * (gw.oldFlow)) + (f * (gw.newFlow)))) * G_Subcatch[i].area)
            if (m_abs(q) < 1e-05) then
              goto continue1
            end
            G_Node[j].newLatFlow = (G_Node[j].newLatFlow + q)
            F.massbal_addInflowFlow(GROUNDWATER_INFLOW, q)
            if (q > 0.0) then
              do
                p = 0
                while (p < G_Nobjects[POLLUT]) do
                  do
                    w = (q * G_Pollut[p].gwConcen)
                    G_Node[j].newQual[p] = (G_Node[j].newQual[p] + w)
                    F.massbal_addInflowQual(GROUNDWATER_INFLOW, p, w)
                  end
                  p = p + 1
                end
              end
            end
          end
        end
      end
      ::continue1::
      i = i + 1
    end
  end
end

-- routing.c:674
F.addLidDrainInflows = function(routingTime)
  local G_Nobjects, G_Subcatch = G.Nobjects, G.Subcatch
  local j = 0
  local f = 0.0
  if (G_Nobjects[SUBCATCH] == 0) then
    do return end
  end
  f = (((routingTime - G.OldRunoffTime)) / ((G.NewRunoffTime - G.OldRunoffTime)))
  if (f < 0.0) then
    f = 0.0
  end
  if (f > 1.0) then
    f = 1.0
  end
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        if ((G_Subcatch[j].area > 0.0) and (G_Subcatch[j].lidArea > 0.0)) then
          F.lid_addDrainInflow(j, f)
        end
      end
      j = j + 1
    end
  end
end

-- routing.c:698
F.addRdiiInflows = function(currentDate)
  local G_Node, G_Nobjects, G_Pollut = G.Node, G.Nobjects, G.Pollut
  local i = 0
  local j = {0}
  local p = 0
  local q = {0.0}
  local w = 0.0
  local numRdiiNodes = 0
  numRdiiNodes = F.rdii_getNumRdiiFlows(currentDate)
  do
    i = 0
    while (i < numRdiiNodes) do
      do
        F.rdii_getRdiiFlow(i, j, 1, q, 1)
        if (j[1] < 0) then
          goto continue1
        end
        if (m_abs(q[1]) < 1e-05) then
          goto continue1
        end
        G_Node[j[1]].newLatFlow = (G_Node[j[1]].newLatFlow + q[1])
        F.massbal_addInflowFlow(RDII_INFLOW, q[1])
        if (q[1] > 0.0) then
          do
            p = 0
            while (p < G_Nobjects[POLLUT]) do
              do
                w = (q[1] * G_Pollut[p].rdiiConcen)
                G_Node[j[1]].newQual[p] = (G_Node[j[1]].newQual[p] + w)
                F.massbal_addInflowQual(RDII_INFLOW, p, w)
              end
              p = p + 1
            end
          end
        end
      end
      ::continue1::
      i = i + 1
    end
  end
end

-- routing.c:736
F.addIfaceInflows = function(currentDate)
  local G_Node, G_Nobjects = G.Node, G.Nobjects
  local i = 0
  local j = 0
  local p = 0
  local q = 0.0
  local w = 0.0
  local numIfaceNodes = 0
  if (G.Finflows.mode ~= USE_FILE) then
    do return end
  end
  numIfaceNodes = F.iface_getNumIfaceNodes(currentDate)
  do
    i = 0
    while (i < numIfaceNodes) do
      do
        j = F.iface_getIfaceNode(i)
        if (j < 0) then
          goto continue1
        end
        q = F.iface_getIfaceFlow(i)
        if (m_abs(q) < 1e-05) then
          goto continue1
        end
        G_Node[j].newLatFlow = (G_Node[j].newLatFlow + q)
        F.massbal_addInflowFlow(EXTERNAL_INFLOW, q)
        if (q > 0.0) then
          do
            p = 0
            while (p < G_Nobjects[POLLUT]) do
              do
                w = (q * F.iface_getIfaceQual(i, p))
                G_Node[j].newQual[p] = (G_Node[j].newQual[p] + w)
                F.massbal_addInflowQual(EXTERNAL_INFLOW, p, w)
              end
              p = p + 1
            end
          end
        end
      end
      ::continue1::
      i = i + 1
    end
  end
end

-- routing.c:776
F.inflowHasChanged = function()
  local G_Nobjects, G_Node = G.Nobjects, G.Node
  local j = 0
  local diff = 0.0
  local qOld = 0.0
  local qNew = 0.0
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        qOld = G_Node[j].oldLatFlow
        qNew = G_Node[j].newLatFlow
        if (m_abs(qOld) > 1e-06) then
          diff = (((qNew / qOld)) - 1.0)
        elseif (m_abs(qNew) > 1e-06) then
          diff = 1.0
        else
          diff = 0.0
        end
        if (m_abs(diff) > G.LatFlowTol) then
          do return 1 end
        end
        if ((G_Node[j].type_ == OUTFALL) or (G_Node[j].degree == 0)) then
          qOld = G_Node[j].oldFlowInflow
          qNew = G_Node[j].inflow
          if (m_abs(qOld) > 1e-06) then
            diff = (((qNew / qOld)) - 1.0)
          elseif (m_abs(qNew) > 1e-06) then
            diff = 1.0
          else
            diff = 0.0
          end
          if (m_abs(diff) > G.LatFlowTol) then
            do return 1 end
          end
        end
      end
      j = j + 1
    end
  end
  do return 0 end
end

-- routing.c:812
F.removeStorageLosses = function(tStep)
  local G_Nobjects, G_Node, G_Storage = G.Nobjects, G.Node, G.Storage
  local i = 0
  local evapLoss = 0.0
  local exfilLoss = 0.0
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        if (G_Node[i].type_ == STORAGE) then
          evapLoss = (evapLoss + G_Storage[G_Node[i].subIndex].evapLoss)
          exfilLoss = (exfilLoss + G_Storage[G_Node[i].subIndex].exfilLoss)
        end
      end
      i = i + 1
    end
  end
  F.massbal_addNodeLosses((evapLoss / tStep), (exfilLoss / tStep))
end

-- routing.c:841
F.removeConduitLosses = function()
  local G_Nobjects, G_Link, G_Conduit = G.Nobjects, G.Link, G.Conduit
  local i = 0
  local k = 0
  local barrels = 0.0
  local evapLoss = 0.0
  local seepLoss = 0.0
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        if (G_Link[i].type_ == CONDUIT) then
          k = G_Link[i].subIndex
          barrels = (G_Conduit[k].barrels * 1.0)
          evapLoss = (evapLoss + (G_Conduit[k].evapLossRate * barrels))
          seepLoss = (seepLoss + (G_Conduit[k].seepLossRate * barrels))
        end
      end
      i = i + 1
    end
  end
  F.massbal_addLinkLosses(evapLoss, seepLoss)
end

-- routing.c:872
F.removeOutflows = function(tStep)
  local G_Nobjects, G_Node, G_Outfall = G.Nobjects, G.Node, G.Outfall
  local i = 0
  local p = 0
  local k = 0
  local isFlooded = {0}
  local q = 0.0
  local w = 0.0
  local v = 0.0
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        if ((G_Node[i].type_ == OUTFALL) and (G_Node[i].inflow > 0.0)) then
          k = G_Node[i].subIndex
          if (G_Outfall[k].routeTo >= 0) then
            v = (G_Node[i].inflow * tStep)
            G_Outfall[k].vRouted = (G_Outfall[k].vRouted + v)
            do
              p = 0
              while (p < G_Nobjects[POLLUT]) do
                do
                  G_Outfall[k].wRouted[p] = (G_Outfall[k].wRouted[p] + (G_Node[i].newQual[p] * v))
                end
                p = p + 1
              end
            end
          end
        end
        q = F.node_getSystemOutflow(i, isFlooded, 1)
        if (q > 0.0) then
          F.massbal_addOutflowFlow(q, isFlooded[1])
          do
            p = 0
            while (p < G_Nobjects[POLLUT]) do
              do
                w = (q * G_Node[i].newQual[p])
                F.massbal_addOutflowQual(p, w, isFlooded[1])
              end
              p = p + 1
            end
          end
        else
          F.massbal_addInflowFlow(EXTERNAL_INFLOW, (-q))
        end
        q = G_Node[i].newLatFlow
        if (q < 0.0) then
          do
            p = 0
            while (p < G_Nobjects[POLLUT]) do
              do
                w = ((-q) * G_Node[i].newQual[p])
                F.massbal_addOutflowQual(p, w, 0)
              end
              p = p + 1
            end
          end
        end
      end
      i = i + 1
    end
  end
end

-- routing.c:929
F.sortEvents = function()
  local G_Event = G.Event
  local i = 0
  local j = 0
  local gap = 0
  local temp = T.TEvent()
  do
    gap = R.idiv(G.NumEvents, 2)
    while (gap >= 1) do
      do
        do
          i = gap
          while (i < G.NumEvents) do
            do
              temp = T.copy_TEvent(G_Event[i])
              j = (i - gap)
              while ((j >= 0) and (G_Event[j].start > temp.start)) do
                do
                  G_Event[(j + gap)] = T.copy_TEvent(G_Event[j])
                  j = (j - gap)
                end
              end
              if (j ~= (i - gap)) then
                G_Event[(j + gap)] = T.copy_TEvent(temp)
              end
            end
            i = (i + gap)
          end
        end
      end
      gap = R.idiv(gap, 2)
    end
  end
  do
    i = 0
    while (i < (G.NumEvents - 1)) do
      do
        if (G_Event[i].end_ > (G_Event[(i + 1)]).start) then
          G_Event[i].end_ = (G_Event[(i + 1)]).start
        end
      end
      i = i + 1
    end
  end
end

