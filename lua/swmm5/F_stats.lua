-- Generated from EPA SWMM 5.2.4 (stats.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local SUBCATCH <const> = 1
local ERR_MEMORY <const> = 101
local LINK <const> = 3
local NODE <const> = 2
local MAX_FLOW_CLASSES <const> = 7
local STORAGE <const> = 2
local OUTFALL <const> = 1
local POLLUT <const> = 4
local PUMP <const> = 1
local NO_ROUTING <const> = 0
local DW <const> = 4
local DN_DRY <const> = 2
local UP_DRY <const> = 1
local CONDUIT <const> = 0
local ALL_FULL <const> = 10
local UP_FULL <const> = 8
local DN_FULL <const> = 9
local STREET_XSECT <const> = 25
local _ENV = R.strict

G.TimeStepStats = T.TTimeStepStats()
G.MaxMassBalErrs = R.recs(5, T.TMaxStats)
G.MaxCourantCrit = R.recs(5, T.TMaxStats)
G.MaxFlowTurns = R.recs(5, T.TMaxStats)
G.MaxNonConverged = R.recs(5, T.TMaxStats)
G.SysOutfallFlow = 0.0
G.SubcatchStats = nil
G.NodeStats = nil
G.LinkStats = nil
G.StorageStats = nil
G.OutfallStats = nil
G.PumpStats = nil
G.MaxOutfallFlow = 0.0
G.MaxRunoffFlow = 0.0
G.RoutingTimeSpan = 0.0

-- stats.c:102
F.stats_open = function()
  local G_Nobjects, G_Subcatch, G_Nnodes, G_Node, G_Nlinks = G.Nobjects, G.Subcatch, G.Nnodes, G.Node, G.Nlinks
  local j = 0
  local k = 0
  local timeStepDelta = 0.0
  local logMaxTimeStep = 0.0
  local logMinTimeStep = 0.0
  G.NodeStats = (nil)
  G.LinkStats = (nil)
  G.StorageStats = (nil)
  G.OutfallStats = (nil)
  G.PumpStats = (nil)
  G.SubcatchStats = (nil)
  if (G_Nobjects[SUBCATCH] > 0) then
    G.SubcatchStats = R.recs(G_Nobjects[SUBCATCH], T.TSubcatchStats)
    if (not (G.SubcatchStats ~= nil)) then
      F.report_writeErrorMsg(ERR_MEMORY, S[0])
      do return G.ErrorCode end
    end
    do
      j = 0
      while (j < G_Nobjects[SUBCATCH]) do
        do
          G.SubcatchStats[j].precip = 0.0
          G.SubcatchStats[j].runon = 0.0
          G.SubcatchStats[j].evap = 0.0
          G.SubcatchStats[j].infil = 0.0
          G.SubcatchStats[j].runoff = 0.0
          G.SubcatchStats[j].maxFlow = 0.0
          G.SubcatchStats[j].impervRunoff = 0.0
          G.SubcatchStats[j].pervRunoff = 0.0
        end
        j = j + 1
      end
    end
    do
      j = 0
      while (j < G_Nobjects[SUBCATCH]) do
        do
          if (G_Subcatch[j].groundwater == (nil)) then
            goto continue2
          end
          G_Subcatch[j].groundwater.stats.avgUpperMoist = 0.0
          G_Subcatch[j].groundwater.stats.avgWaterTable = 0.0
          G_Subcatch[j].groundwater.stats.infil = 0.0
          G_Subcatch[j].groundwater.stats.latFlow = 0.0
          G_Subcatch[j].groundwater.stats.deepFlow = 0.0
          G_Subcatch[j].groundwater.stats.evap = 0.0
          G_Subcatch[j].groundwater.stats.maxFlow = 0.0
          G_Subcatch[j].groundwater.stats.finalUpperMoist = 0.0
          G_Subcatch[j].groundwater.stats.finalWaterTable = 0.0
        end
        ::continue2::
        j = j + 1
      end
    end
  end
  if (G_Nobjects[LINK] > 0) then
    G.NodeStats = R.recs(G_Nobjects[NODE], T.TNodeStats)
    G.LinkStats = R.recs(G_Nobjects[LINK], T.TLinkStats)
    if ((not (G.NodeStats ~= nil)) or (not (G.LinkStats ~= nil))) then
      F.report_writeErrorMsg(ERR_MEMORY, S[0])
      do return G.ErrorCode end
    end
  end
  if (G.NodeStats ~= nil) then
    do
      j = 0
      while (j < G_Nobjects[NODE]) do
        do
          G.NodeStats[j].avgDepth = 0.0
          G.NodeStats[j].maxDepth = 0.0
          G.NodeStats[j].maxDepthDate = G.StartDateTime
          G.NodeStats[j].maxRptDepth = 0.0
          G.NodeStats[j].volFlooded = 0.0
          G.NodeStats[j].timeFlooded = 0.0
          G.NodeStats[j].timeSurcharged = 0.0
          G.NodeStats[j].timeCourantCritical = 0.0
          G.NodeStats[j].totLatFlow = 0.0
          G.NodeStats[j].maxLatFlow = 0.0
          G.NodeStats[j].maxInflow = 0.0
          G.NodeStats[j].maxOverflow = 0.0
          G.NodeStats[j].maxPondedVol = 0.0
          G.NodeStats[j].nonConvergedCount = 0
          G.NodeStats[j].maxInflowDate = G.StartDateTime
          G.NodeStats[j].maxOverflowDate = G.StartDateTime
        end
        j = j + 1
      end
    end
  end
  if (G.LinkStats ~= nil) then
    do
      j = 0
      while (j < G_Nobjects[LINK]) do
        do
          G.LinkStats[j].maxFlow = 0.0
          G.LinkStats[j].maxVeloc = 0.0
          G.LinkStats[j].maxDepth = 0.0
          G.LinkStats[j].maxStreetFilled = 0.0
          G.LinkStats[j].timeSurcharged = 0.0
          G.LinkStats[j].timeFullUpstream = 0.0
          G.LinkStats[j].timeFullDnstream = 0.0
          G.LinkStats[j].timeFullFlow = 0.0
          G.LinkStats[j].timeCapacityLimited = 0.0
          G.LinkStats[j].timeCourantCritical = 0.0
          do
            k = 0
            while (k < MAX_FLOW_CLASSES) do
              do
                G.LinkStats[j].timeInFlowClass[k] = 0.0
              end
              k = k + 1
            end
          end
          G.LinkStats[j].flowTurns = 0
          G.LinkStats[j].flowTurnSign = 0
        end
        j = j + 1
      end
    end
  end
  if (G_Nnodes[STORAGE] > 0) then
    G.StorageStats = R.recs(G_Nnodes[STORAGE], T.TStorageStats)
    if (not (G.StorageStats ~= nil)) then
      F.report_writeErrorMsg(ERR_MEMORY, S[0])
      do return G.ErrorCode end
    else
      do
        k = 0
        while (k < G_Nobjects[NODE]) do
          do
            if (G_Node[k].type_ ~= STORAGE) then
              goto continue6
            end
            j = G_Node[k].subIndex
            G.StorageStats[j].initVol = G_Node[k].newVolume
            G.StorageStats[j].avgVol = 0.0
            G.StorageStats[j].maxVol = 0.0
            G.StorageStats[j].maxFlow = 0.0
            G.StorageStats[j].evapLosses = 0.0
            G.StorageStats[j].exfilLosses = 0.0
            G.StorageStats[j].maxVolDate = G.StartDateTime
          end
          ::continue6::
          k = k + 1
        end
      end
    end
  end
  if (G_Nnodes[OUTFALL] > 0) then
    G.OutfallStats = R.recs(G_Nnodes[OUTFALL], T.TOutfallStats)
    if (not (G.OutfallStats ~= nil)) then
      F.report_writeErrorMsg(ERR_MEMORY, S[0])
      do return G.ErrorCode end
    else
      do
        j = 0
        while (j < G_Nnodes[OUTFALL]) do
          do
            G.OutfallStats[j].avgFlow = 0.0
            G.OutfallStats[j].maxFlow = 0.0
            G.OutfallStats[j].totalPeriods = 0
            if (G_Nobjects[POLLUT] > 0) then
              G.OutfallStats[j].totalLoad = R.fill(G_Nobjects[POLLUT], 0.0)
              if (not (G.OutfallStats[j].totalLoad ~= nil)) then
                F.report_writeErrorMsg(ERR_MEMORY, S[0])
                do return G.ErrorCode end
              end
              do
                k = 0
                while (k < G_Nobjects[POLLUT]) do
                  do
                    G.OutfallStats[j].totalLoad[k] = 0.0
                  end
                  k = k + 1
                end
              end
            else
              G.OutfallStats[j].totalLoad = (nil)
            end
          end
          j = j + 1
        end
      end
    end
  end
  if (G_Nlinks[PUMP] > 0) then
    G.PumpStats = R.recs(G_Nlinks[PUMP], T.TPumpStats)
    if (not (G.PumpStats ~= nil)) then
      F.report_writeErrorMsg(ERR_MEMORY, S[0])
      do return G.ErrorCode end
    else
      do
        j = 0
        while (j < G_Nlinks[PUMP]) do
          do
            G.PumpStats[j].utilized = 0.0
            G.PumpStats[j].minFlow = 0.0
            G.PumpStats[j].avgFlow = 0.0
            G.PumpStats[j].maxFlow = 0.0
            G.PumpStats[j].volume = 0.0
            G.PumpStats[j].energy = 0.0
            G.PumpStats[j].startUps = 0
            G.PumpStats[j].offCurveLow = 0.0
            G.PumpStats[j].offCurveHigh = 0.0
          end
          j = j + 1
        end
      end
    end
  end
  G.MaxRunoffFlow = 0.0
  G.MaxOutfallFlow = 0.0
  G.TimeStepStats.maxTimeStep = 0.0
  G.TimeStepStats.minTimeStep = G.RouteStep
  G.TimeStepStats.routingTime = 0.0
  G.TimeStepStats.trialsCount = 0.0
  G.TimeStepStats.steadyStateTime = 0.0
  G.TimeStepStats.timeStepCount = 0
  logMaxTimeStep = R.log10(G.RouteStep)
  logMinTimeStep = R.log10(G.MinRouteStep)
  timeStepDelta = (((logMaxTimeStep - logMinTimeStep)) / (((6 - 1)) * 1.0))
  G.TimeStepStats.timeStepIntervals[0] = G.RouteStep
  do
    j = 1
    while (j < 6) do
      do
        G.TimeStepStats.timeStepIntervals[j] = R.pow(10.0, (logMaxTimeStep - ((j * 1.0) * timeStepDelta)))
        G.TimeStepStats.timeStepCounts[j] = 0
      end
      j = j + 1
    end
  end
  G.TimeStepStats.timeStepIntervals[(6 - 1)] = G.MinRouteStep
  G.RoutingTimeSpan = 0.0
  do return 0 end
end

-- stats.c:318
F.stats_close = function()
  local G_Nnodes = G.Nnodes
  local j = 0
  do
    if (G.SubcatchStats ~= nil) then
      local _ = nil
      G.SubcatchStats = (nil)
    end
  end
  do
    if (G.NodeStats ~= nil) then
      local _ = nil
      G.NodeStats = (nil)
    end
  end
  do
    if (G.LinkStats ~= nil) then
      local _ = nil
      G.LinkStats = (nil)
    end
  end
  do
    if (G.StorageStats ~= nil) then
      local _ = nil
      G.StorageStats = (nil)
    end
  end
  if (G.OutfallStats ~= nil) then
    do
      j = 0
      while (j < G_Nnodes[OUTFALL]) do
        do
          if (G.OutfallStats[j].totalLoad ~= nil) then
            local _ = nil
            G.OutfallStats[j].totalLoad = (nil)
          end
        end
        j = j + 1
      end
    end
    do
      if (G.OutfallStats ~= nil) then
        local _ = nil
        G.OutfallStats = (nil)
      end
    end
  end
  do
    if (G.PumpStats ~= nil) then
      local _ = nil
      G.PumpStats = (nil)
    end
  end
end

-- stats.c:342
F.stats_report = function()
  local G_RptFlags = G.RptFlags
  if ((G.Nobjects[LINK] > 0) and (G.RouteModel ~= NO_ROUTING)) then
    F.stats_findMaxStats()
    if ((not (G_RptFlags.disabled ~= 0)) and (G_RptFlags.flowStats ~= 0)) then
      F.report_writeMaxStats(G.MaxMassBalErrs, G.MaxCourantCrit, 5)
      F.report_writeMaxFlowTurns(G.MaxFlowTurns, 5)
      F.report_writeNonconvergedStats(G.MaxNonConverged, 5)
      F.report_writeTimeStepStats(G.TimeStepStats)
    end
  end
  if (not (G_RptFlags.disabled ~= 0)) then
    F.statsrpt_writeReport()
  end
end

-- stats.c:369
F.stats_updateSubcatchStats = function(j, rainVol, runonVol, evapVol, infilVol, impervVol, pervVol, runoffVol, runoff)
  local G_SubcatchStats = G.SubcatchStats
  G_SubcatchStats[j].precip = (G_SubcatchStats[j].precip + rainVol)
  G_SubcatchStats[j].runon = (G_SubcatchStats[j].runon + runonVol)
  G_SubcatchStats[j].evap = (G_SubcatchStats[j].evap + evapVol)
  G_SubcatchStats[j].infil = (G_SubcatchStats[j].infil + infilVol)
  G_SubcatchStats[j].runoff = (G_SubcatchStats[j].runoff + runoffVol)
  G_SubcatchStats[j].maxFlow = (((((G_SubcatchStats[j].maxFlow) >= (runoff))) and (G_SubcatchStats[j].maxFlow) or (runoff)))
  G_SubcatchStats[j].impervRunoff = (G_SubcatchStats[j].impervRunoff + impervVol)
  G_SubcatchStats[j].pervRunoff = (G_SubcatchStats[j].pervRunoff + pervVol)
end

-- stats.c:399
F.stats_updateGwaterStats = function(j, infil, evap, latFlow, deepFlow, theta, waterTable, tStep)
  local G_Subcatch = G.Subcatch
  G_Subcatch[j].groundwater.stats.infil = (G_Subcatch[j].groundwater.stats.infil + (infil * tStep))
  G_Subcatch[j].groundwater.stats.evap = (G_Subcatch[j].groundwater.stats.evap + (evap * tStep))
  G_Subcatch[j].groundwater.stats.latFlow = (G_Subcatch[j].groundwater.stats.latFlow + (latFlow * tStep))
  G_Subcatch[j].groundwater.stats.deepFlow = (G_Subcatch[j].groundwater.stats.deepFlow + (deepFlow * tStep))
  G_Subcatch[j].groundwater.stats.avgUpperMoist = (G_Subcatch[j].groundwater.stats.avgUpperMoist + (theta * tStep))
  G_Subcatch[j].groundwater.stats.avgWaterTable = (G_Subcatch[j].groundwater.stats.avgWaterTable + (waterTable * tStep))
  G_Subcatch[j].groundwater.stats.finalUpperMoist = theta
  G_Subcatch[j].groundwater.stats.finalWaterTable = waterTable
  if (m_abs(latFlow) > m_abs(G_Subcatch[j].groundwater.stats.maxFlow)) then
    G_Subcatch[j].groundwater.stats.maxFlow = latFlow
  end
end

-- stats.c:419
F.stats_updateMaxRunoff = function()
  local G_Nobjects, G_Subcatch = G.Nobjects, G.Subcatch
  local j = 0
  local sysRunoff = 0.0
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        sysRunoff = (sysRunoff + G_Subcatch[j].newRunoff)
      end
      j = j + 1
    end
  end
  G.MaxRunoffFlow = (((((G.MaxRunoffFlow) >= (sysRunoff))) and (G.MaxRunoffFlow) or (sysRunoff)))
end

-- stats.c:435
F.stats_updateMaxNodeDepth = function(j, depth)
  local G_NodeStats = G.NodeStats
  if (G_NodeStats ~= (nil)) then
    G_NodeStats[j].maxRptDepth = (((((G_NodeStats[j].maxRptDepth) >= (depth))) and (G_NodeStats[j].maxRptDepth) or (depth)))
  end
end

-- stats.c:449
F.stats_updateFlowStats = function(tStep, aDate)
  local G_Nobjects = G.Nobjects
  local j = 0
  if (aDate < G.ReportStart) then
    do return end
  end
  G.SysOutfallFlow = 0.0
  do
    do
      j = 0
      while (j < G_Nobjects[NODE]) do
        do
          F.stats_updateNodeStats(j, tStep, aDate)
        end
        j = j + 1
      end
    end
    do
      j = 0
      while (j < G_Nobjects[LINK]) do
        do
          F.stats_updateLinkStats(j, tStep, aDate)
        end
        j = j + 1
      end
    end
  end
  G.ReportStepCount = G.ReportStepCount + 1
  G.RoutingTimeSpan = (G.RoutingTimeSpan + tStep)
  G.MaxOutfallFlow = (((((G.MaxOutfallFlow) >= (G.SysOutfallFlow))) and (G.MaxOutfallFlow) or (G.SysOutfallFlow)))
end

-- stats.c:484
F.stats_updateTimeStepStats = function(tStep, trialsCount, steadyState)
  local j = 0
  G.TimeStepStats.steadyStateTime = (G.TimeStepStats.steadyStateTime + ((steadyState * 1.0) * tStep))
  if (steadyState == 0) then
    if (G.OldRoutingTime > 0.0) then
      G.TimeStepStats.minTimeStep = (((((G.TimeStepStats.minTimeStep) <= (tStep))) and (G.TimeStepStats.minTimeStep) or (tStep)))
      do
        j = 1
        while (j < 6) do
          do
            if (tStep >= G.TimeStepStats.timeStepIntervals[j]) then
              G.TimeStepStats.timeStepCounts[j] = G.TimeStepStats.timeStepCounts[j] + 1
              break
            end
          end
          j = j + 1
        end
      end
    end
    G.TimeStepStats.maxTimeStep = (((((G.TimeStepStats.maxTimeStep) >= (tStep))) and (G.TimeStepStats.maxTimeStep) or (tStep)))
    G.TimeStepStats.routingTime = (G.TimeStepStats.routingTime + tStep)
    G.TimeStepStats.timeStepCount = G.TimeStepStats.timeStepCount + 1
    G.TimeStepStats.trialsCount = (G.TimeStepStats.trialsCount + (trialsCount * 1.0))
  end
end

-- stats.c:522
F.stats_updateCriticalTimeCount = function(node, link)
  local G_NodeStats, G_LinkStats = G.NodeStats, G.LinkStats
  if (node >= 0) then
    G_NodeStats[node].timeCourantCritical = (G_NodeStats[node].timeCourantCritical + 1.0)
  elseif (link >= 0) then
    G_LinkStats[link].timeCourantCritical = (G_LinkStats[link].timeCourantCritical + 1.0)
  end
end

-- stats.c:536
F.stats_updateConvergenceStats = function(node, converged)
  local G_NodeStats = G.NodeStats
  if (converged == 0) then
    G_NodeStats[node].nonConvergedCount = G_NodeStats[node].nonConvergedCount + 1
  end
end

-- stats.c:543
F.stats_updateNodeStats = function(j, tStep, aDate)
  local G_Node, G_NodeStats, G_StorageStats, G_Storage, G_OutfallStats, G_Nobjects = G.Node, G.NodeStats, G.StorageStats, G.Storage, G.OutfallStats, G.Nobjects
  local k = 0
  local p = 0
  local newVolume = G_Node[j].newVolume
  local newDepth = G_Node[j].newDepth
  local canPond = ((((G.AllowPonding ~= 0) and (G_Node[j].pondedArea > 0.0))) and 1 or 0)
  G_NodeStats[j].avgDepth = (G_NodeStats[j].avgDepth + newDepth)
  if (newDepth > G_NodeStats[j].maxDepth) then
    G_NodeStats[j].maxDepth = newDepth
    G_NodeStats[j].maxDepthDate = aDate
  end
  if (G_Node[j].type_ ~= OUTFALL) then
    if ((newVolume > G_Node[j].fullVolume) or (G_Node[j].overflow > 0.0)) then
      G_NodeStats[j].timeFlooded = (G_NodeStats[j].timeFlooded + tStep)
      G_NodeStats[j].volFlooded = (G_NodeStats[j].volFlooded + (G_Node[j].overflow * tStep))
      if (canPond ~= 0) then
        G_NodeStats[j].maxPondedVol = (((((G_NodeStats[j].maxPondedVol) >= (((newVolume - G_Node[j].fullVolume))))) and (G_NodeStats[j].maxPondedVol) or (((newVolume - G_Node[j].fullVolume)))))
      end
    end
    if (G.RouteModel == DW) then
      if ((((G_Node[j].type_ ~= STORAGE) or (G_Node[j].surDepth > 0.0))) and (((newDepth + G_Node[j].invertElev) + 0.0001) >= G_Node[j].crownElev)) then
        G_NodeStats[j].timeSurcharged = (G_NodeStats[j].timeSurcharged + tStep)
      end
    end
  end
  if (G_Node[j].type_ == STORAGE) then
    k = G_Node[j].subIndex
    G_StorageStats[k].avgVol = (G_StorageStats[k].avgVol + newVolume)
    G_StorageStats[k].evapLosses = (G_StorageStats[k].evapLosses + G_Storage[G_Node[j].subIndex].evapLoss)
    G_StorageStats[k].exfilLosses = (G_StorageStats[k].exfilLosses + G_Storage[G_Node[j].subIndex].exfilLoss)
    newVolume = (((((newVolume) <= (G_Node[j].fullVolume))) and (newVolume) or (G_Node[j].fullVolume)))
    if (newVolume > G_StorageStats[k].maxVol) then
      G_StorageStats[k].maxVol = newVolume
      G_StorageStats[k].maxVolDate = aDate
    end
    G_StorageStats[k].maxFlow = (((((G_StorageStats[k].maxFlow) >= (G_Node[j].outflow))) and (G_StorageStats[k].maxFlow) or (G_Node[j].outflow)))
  end
  if (G_Node[j].type_ == OUTFALL) then
    k = G_Node[j].subIndex
    if (G_Node[j].inflow >= 0.001) then
      G_OutfallStats[k].avgFlow = (G_OutfallStats[k].avgFlow + G_Node[j].inflow)
      G_OutfallStats[k].maxFlow = (((((G_OutfallStats[k].maxFlow) >= (G_Node[j].inflow))) and (G_OutfallStats[k].maxFlow) or (G_Node[j].inflow)))
      G_OutfallStats[k].totalPeriods = G_OutfallStats[k].totalPeriods + 1
    end
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          G_OutfallStats[k].totalLoad[p] = (G_OutfallStats[k].totalLoad[p] + ((G_Node[j].inflow * G_Node[j].newQual[p]) * tStep))
        end
        p = p + 1
      end
    end
    G.SysOutfallFlow = (G.SysOutfallFlow + G_Node[j].inflow)
  end
  G_NodeStats[j].totLatFlow = (G_NodeStats[j].totLatFlow + (((((G_Node[j].oldLatFlow + G_Node[j].newLatFlow)) * 0.5) * tStep)))
  if (m_abs(G_Node[j].newLatFlow) > m_abs(G_NodeStats[j].maxLatFlow)) then
    G_NodeStats[j].maxLatFlow = G_Node[j].newLatFlow
  end
  if (G_Node[j].inflow > G_NodeStats[j].maxInflow) then
    G_NodeStats[j].maxInflow = G_Node[j].inflow
    G_NodeStats[j].maxInflowDate = aDate
  end
  if (G_Node[j].overflow > G_NodeStats[j].maxOverflow) then
    G_NodeStats[j].maxOverflow = G_Node[j].overflow
    G_NodeStats[j].maxOverflowDate = aDate
  end
end

-- stats.c:647
F.stats_updateLinkStats = function(j, tStep, aDate)
  local G_Link, G_LinkStats, G_PumpStats, G_Conduit = G.Link, G.LinkStats, G.PumpStats, G.Conduit
  local k = 0
  local q = 0.0
  local v = 0.0
  local dq = 0.0
  dq = (G_Link[j].newFlow - G_Link[j].oldFlow)
  q = m_abs(G_Link[j].newFlow)
  if (q > G_LinkStats[j].maxFlow) then
    G_LinkStats[j].maxFlow = q
    G_LinkStats[j].maxFlowDate = aDate
  end
  v = F.link_getVelocity(j, q, G_Link[j].newDepth)
  if (v > G_LinkStats[j].maxVeloc) then
    G_LinkStats[j].maxVeloc = v
  end
  if (G_Link[j].newDepth > G_LinkStats[j].maxDepth) then
    G_LinkStats[j].maxDepth = G_Link[j].newDepth
  end
  if (G_Link[j].type_ == PUMP) then
    if (q >= G_Link[j].qFull) then
      G_LinkStats[j].timeFullFlow = (G_LinkStats[j].timeFullFlow + tStep)
    end
    if (q > 0.001) then
      k = G_Link[j].subIndex
      G_PumpStats[k].minFlow = (((((G_PumpStats[k].minFlow) <= (q))) and (G_PumpStats[k].minFlow) or (q)))
      G_PumpStats[k].maxFlow = G_LinkStats[j].maxFlow
      G_PumpStats[k].avgFlow = (G_PumpStats[k].avgFlow + q)
      G_PumpStats[k].volume = (G_PumpStats[k].volume + (q * tStep))
      G_PumpStats[k].utilized = (G_PumpStats[k].utilized + tStep)
      G_PumpStats[k].energy = (G_PumpStats[k].energy + ((F.link_getPower(j) * tStep) / 3600.0))
      if (G_Link[j].flowClass == DN_DRY) then
        G_PumpStats[k].offCurveLow = (G_PumpStats[k].offCurveLow + tStep)
      end
      if (G_Link[j].flowClass == UP_DRY) then
        G_PumpStats[k].offCurveHigh = (G_PumpStats[k].offCurveHigh + tStep)
      end
      if (G_Link[j].oldFlow < 0.001) then
        G_PumpStats[k].startUps = G_PumpStats[k].startUps + 1
      end
      G_PumpStats[k].totalPeriods = G_PumpStats[k].totalPeriods + 1
      G_LinkStats[j].timeSurcharged = (G_LinkStats[j].timeSurcharged + tStep)
      G_LinkStats[j].timeFullUpstream = (G_LinkStats[j].timeFullUpstream + tStep)
      G_LinkStats[j].timeFullDnstream = (G_LinkStats[j].timeFullDnstream + tStep)
    end
  elseif (G_Link[j].type_ == CONDUIT) then
    if (G_Link[j].normalFlow ~= 0) then
      G_LinkStats[j].timeNormalFlow = (G_LinkStats[j].timeNormalFlow + tStep)
    end
    if (G_Link[j].inletControl ~= 0) then
      G_LinkStats[j].timeInletControl = (G_LinkStats[j].timeInletControl + tStep)
    end
    k = G_Link[j].flowClass
    if ((k >= 0) and (k < MAX_FLOW_CLASSES)) then
      G_LinkStats[j].timeInFlowClass[k] = (G_LinkStats[j].timeInFlowClass[k] + tStep)
    end
    k = G_Link[j].subIndex
    if (q >= (G_Link[j].qFull * (G_Conduit[k].barrels * 1.0))) then
      G_LinkStats[j].timeFullFlow = (G_LinkStats[j].timeFullFlow + tStep)
    end
    if (G_Conduit[k].capacityLimited ~= 0) then
      G_LinkStats[j].timeCapacityLimited = (G_LinkStats[j].timeCapacityLimited + tStep)
    end
    do
      local __sw1 = G_Conduit[k].fullState
      if __sw1 == ALL_FULL then goto case2
      elseif __sw1 == UP_FULL then goto case3
      elseif __sw1 == DN_FULL then goto case4
      else goto swend1 end
      ::case2::
      do
        G_LinkStats[j].timeSurcharged = (G_LinkStats[j].timeSurcharged + tStep)
        G_LinkStats[j].timeFullUpstream = (G_LinkStats[j].timeFullUpstream + tStep)
        G_LinkStats[j].timeFullDnstream = (G_LinkStats[j].timeFullDnstream + tStep)
        goto swend1
      end
      ::case3::
      do
        G_LinkStats[j].timeFullUpstream = (G_LinkStats[j].timeFullUpstream + tStep)
        goto swend1
      end
      ::case4::
      do
        G_LinkStats[j].timeFullDnstream = (G_LinkStats[j].timeFullDnstream + tStep)
      end
      ::swend1::
    end
    if (G_Link[j].xsect.type_ == STREET_XSECT) then
      G_LinkStats[j].maxStreetFilled = (((((G_LinkStats[j].maxStreetFilled) >= (F.street_getExtentFilled(j)))) and (G_LinkStats[j].maxStreetFilled) or (F.street_getExtentFilled(j))))
    end
  end
  k = G_LinkStats[j].flowTurnSign
  G_LinkStats[j].flowTurnSign = (((((dq) < 0.0)) and ((-1)) or (1)))
  if ((m_abs(dq) > 0.001) and ((k * G_LinkStats[j].flowTurnSign) < 0)) then
    G_LinkStats[j].flowTurns = G_LinkStats[j].flowTurns + 1
  end
end

-- stats.c:756
F.stats_findMaxStats = function()
  local G_MaxMassBalErrs, G_MaxCourantCrit, G_MaxFlowTurns, G_MaxNonConverged, G_Nobjects, G_LinkStats = G.MaxMassBalErrs, G.MaxCourantCrit, G.MaxFlowTurns, G.MaxNonConverged, G.Nobjects, G.LinkStats
  local G_Node, G_NodeInflow, G_NodeOutflow, G_NodeStats = G.Node, G.NodeInflow, G.NodeOutflow, G.NodeStats
  local j = 0
  local x = 0.0
  local z = 0.0
  local stepCount = 0.0
  do
    j = 0
    while (j < 5) do
      do
        G_MaxMassBalErrs[j].objType = NODE
        G_MaxMassBalErrs[j].index = (-1)
        G_MaxMassBalErrs[j].value = (-1.0)
        G_MaxCourantCrit[j].index = (-1)
        G_MaxCourantCrit[j].value = (-1.0)
        G_MaxFlowTurns[j].index = (-1)
        G_MaxFlowTurns[j].value = (-1.0)
        G_MaxNonConverged[j].index = (-1)
        G_MaxNonConverged[j].value = 0.0
      end
      j = j + 1
    end
  end
  if (G.ReportStepCount > 2) then
    stepCount = (G.ReportStepCount * 1.0)
    z = (100.0 / (((2.0 / 3.0) * ((stepCount - 2.0)))))
    do
      j = 0
      while (j < G_Nobjects[LINK]) do
        do
          x = ((G_LinkStats[j].flowTurns * 1.0) * z)
          F.stats_updateMaxStats(G_MaxFlowTurns, LINK, j, x)
        end
        j = j + 1
      end
    end
  end
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        if (G_Node[j].degree <= 0) then
          goto continue3
        end
        if (G_NodeInflow[j] <= 0.1) then
          goto continue3
        end
        if (G_NodeInflow[j] > 0.0) then
          x = (1.0 - (G_NodeOutflow[j] / G_NodeInflow[j]))
        elseif (G_NodeOutflow[j] > 0.0) then
          x = (-1.0)
        else
          x = 0.0
        end
        F.stats_updateMaxStats(G_MaxMassBalErrs, NODE, j, (100.0 * x))
      end
      ::continue3::
      j = j + 1
    end
  end
  stepCount = (G.TimeStepStats.timeStepCount * 1.0)
  if (G.RouteModel == DW) then
    do
      j = 0
      while (j < G_Nobjects[NODE]) do
        do
          F.stats_updateMaxStats(G_MaxNonConverged, NODE, j, ((G_NodeStats[j].nonConvergedCount * 1.0) / stepCount))
        end
        j = j + 1
      end
    end
  end
  if ((G.RouteModel ~= DW) or (G.CourantFactor == 0.0)) then
    do return end
  end
  if (stepCount == 0.0) then
    do return end
  end
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        x = (G_NodeStats[j].timeCourantCritical / stepCount)
        F.stats_updateMaxStats(G_MaxCourantCrit, NODE, j, (100.0 * x))
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        x = (G_LinkStats[j].timeCourantCritical / stepCount)
        F.stats_updateMaxStats(G_MaxCourantCrit, LINK, j, (100.0 * x))
      end
      j = j + 1
    end
  end
end

-- stats.c:841
F.stats_updateMaxStats = function(maxStats, i, j, x)
  local k = 0
  local maxStats1 = T.TMaxStats()
  local maxStats2 = T.TMaxStats()
  maxStats1.objType = i
  maxStats1.index = j
  maxStats1.value = x
  do
    k = 0
    while (k < 5) do
      do
        if (m_abs(maxStats1.value) > m_abs(maxStats[k].value)) then
          maxStats2 = T.copy_TMaxStats(maxStats[k])
          maxStats[k] = T.copy_TMaxStats(maxStats1)
          maxStats1 = T.copy_TMaxStats(maxStats2)
        end
      end
      k = k + 1
    end
  end
end

