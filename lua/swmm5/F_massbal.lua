-- Generated from EPA SWMM 5.2.4 (massbal.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local SUBCATCH <const> = 1
local NODE <const> = 2
local LINK <const> = 3
local POLLUT <const> = 4
local ERR_MEMORY <const> = 101
local AQUIFER <const> = 11
local LANDUSE <const> = 5
local RUNOFF_RAINFALL <const> = 0
local RUNOFF_EVAP <const> = 1
local RUNOFF_INFIL <const> = 2
local RUNOFF_RUNOFF <const> = 3
local RUNOFF_DRAINS <const> = 4
local RUNOFF_RUNON <const> = 5
local DRY_WEATHER_INFLOW <const> = 1
local WET_WEATHER_INFLOW <const> = 2
local GROUNDWATER_INFLOW <const> = 3
local RDII_INFLOW <const> = 4
local EXTERNAL_INFLOW <const> = 0
local BUILDUP_LOAD <const> = 0
local DEPOSITION_LOAD <const> = 1
local SWEEPING_LOAD <const> = 2
local INFIL_LOAD <const> = 4
local BMP_REMOVAL_LOAD <const> = 3
local RUNOFF_LOAD <const> = 5
local FINAL_LOAD <const> = 6
local OUTFALL <const> = 1
local STORAGE <const> = 2
local SF <const> = 1
local FLOW <const> = 10
local SYS_DWFLOW <const> = 5
local SYS_GWFLOW <const> = 6
local SYS_IIFLOW <const> = 7
local SYS_EXFLOW <const> = 8
local SYS_FLOODING <const> = 10
local SYS_OUTFLOW <const> = 11
local VOLUME <const> = 5
local SYS_STORAGE <const> = 12
local COUNT <const> = 2
local MASS <const> = 8
local UG <const> = 1
local _ENV = R.strict

G.MAX_RUNOFF_BALANCE_ERR = 10.0
G.MAX_FLOW_BALANCE_ERR = 10.0
G.RunoffTotals = T.TRunoffTotals()
G.LoadingTotals = nil
G.GwaterTotals = T.TGwaterTotals()
G.FlowTotals = T.TRoutingTotals()
G.QualTotals = nil
G.StepFlowTotals = T.TRoutingTotals()
G.OldStepFlowTotals = T.TRoutingTotals()
G.StepQualTotals = nil
G.NodeInflow = nil
G.NodeOutflow = nil
G.TotalArea = 0.0

-- massbal.c:100
F.massbal_open = function()
  local G_Nobjects, G_Subcatch, G_Node, G_Link = G.Nobjects, G.Subcatch, G.Node, G.Link
  local j = 0
  local n = 0
  G.RunoffError = 0.0
  G.GwaterError = 0.0
  G.FlowError = 0.0
  G.QualError = 0.0
  G.RunoffTotals.rainfall = 0.0
  G.RunoffTotals.evap = 0.0
  G.RunoffTotals.infil = 0.0
  G.RunoffTotals.runoff = 0.0
  G.RunoffTotals.runon = 0.0
  G.RunoffTotals.drains = 0.0
  G.RunoffTotals.snowRemoved = 0.0
  G.RunoffTotals.initStorage = 0.0
  G.RunoffTotals.initSnowCover = 0.0
  G.TotalArea = 0.0
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        G.RunoffTotals.initStorage = (G.RunoffTotals.initStorage + (F.subcatch_getStorage(j)))
        G.RunoffTotals.initSnowCover = (G.RunoffTotals.initSnowCover + (F.snow_getSnowCover(j)))
        G.TotalArea = (G.TotalArea + G_Subcatch[j].area)
      end
      j = j + 1
    end
  end
  G.GwaterTotals.infil = 0.0
  G.GwaterTotals.upperEvap = 0.0
  G.GwaterTotals.lowerEvap = 0.0
  G.GwaterTotals.lowerPerc = 0.0
  G.GwaterTotals.gwater = 0.0
  G.GwaterTotals.initStorage = 0.0
  G.GwaterTotals.finalStorage = 0.0
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        G.GwaterTotals.initStorage = (G.GwaterTotals.initStorage + (F.gwater_getVolume(j) * G_Subcatch[j].area))
      end
      j = j + 1
    end
  end
  G.FlowTotals.dwInflow = 0.0
  G.FlowTotals.wwInflow = 0.0
  G.FlowTotals.gwInflow = 0.0
  G.FlowTotals.iiInflow = 0.0
  G.FlowTotals.exInflow = 0.0
  G.FlowTotals.flooding = 0.0
  G.FlowTotals.outflow = 0.0
  G.FlowTotals.evapLoss = 0.0
  G.FlowTotals.seepLoss = 0.0
  G.FlowTotals.reacted = 0.0
  G.FlowTotals.initStorage = 0.0
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        G.FlowTotals.initStorage = (G.FlowTotals.initStorage + G_Node[j].newVolume)
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        G.FlowTotals.initStorage = (G.FlowTotals.initStorage + G_Link[j].newVolume)
      end
      j = j + 1
    end
  end
  G.StepFlowTotals = T.copy_TRoutingTotals(G.FlowTotals)
  G.LoadingTotals = (nil)
  G.QualTotals = (nil)
  G.StepQualTotals = (nil)
  G.NodeInflow = (nil)
  G.NodeOutflow = (nil)
  n = G_Nobjects[POLLUT]
  if (n > 0) then
    G.LoadingTotals = R.recs(n, T.TLoadingTotals)
    if (G.LoadingTotals == (nil)) then
      F.report_writeErrorMsg(ERR_MEMORY, S[0])
      do return G.ErrorCode end
    end
    do
      j = 0
      while (j < n) do
        do
          G.LoadingTotals[j].initLoad = F.massbal_getBuildup(j)
          G.LoadingTotals[j].buildup = 0.0
          G.LoadingTotals[j].deposition = 0.0
          G.LoadingTotals[j].sweeping = 0.0
          G.LoadingTotals[j].infil = 0.0
          G.LoadingTotals[j].bmpRemoval = 0.0
          G.LoadingTotals[j].runoff = 0.0
          G.LoadingTotals[j].finalLoad = 0.0
        end
        j = j + 1
      end
    end
  end
  if (n > 0) then
    G.QualTotals = R.recs(n, T.TRoutingTotals)
    G.StepQualTotals = R.recs(n, T.TRoutingTotals)
    if ((G.QualTotals == (nil)) or (G.StepQualTotals == (nil))) then
      F.report_writeErrorMsg(ERR_MEMORY, S[0])
      do return G.ErrorCode end
    end
  end
  do
    j = 0
    while (j < n) do
      do
        G.QualTotals[j].dwInflow = 0.0
        G.QualTotals[j].wwInflow = 0.0
        G.QualTotals[j].gwInflow = 0.0
        G.QualTotals[j].exInflow = 0.0
        G.QualTotals[j].flooding = 0.0
        G.QualTotals[j].outflow = 0.0
        G.QualTotals[j].evapLoss = 0.0
        G.QualTotals[j].seepLoss = 0.0
        G.QualTotals[j].reacted = 0.0
        G.QualTotals[j].initStorage = F.massbal_getStoredMass(j)
      end
      j = j + 1
    end
  end
  F.massbal_initTimeStepTotals()
  if (G_Nobjects[NODE] > 0) then
    G.NodeInflow = R.fill(G_Nobjects[NODE], 0.0)
    if (G.NodeInflow == (nil)) then
      F.report_writeErrorMsg(ERR_MEMORY, S[0])
      do return G.ErrorCode end
    end
    G.NodeOutflow = R.fill(G_Nobjects[NODE], 0.0)
    if (G.NodeOutflow == (nil)) then
      F.report_writeErrorMsg(ERR_MEMORY, S[0])
      do return G.ErrorCode end
    end
    do
      j = 0
      while (j < G_Nobjects[NODE]) do
        do
          G.NodeInflow[j] = G_Node[j].newVolume
        end
        j = j + 1
      end
    end
  end
  do return G.ErrorCode end
end

-- massbal.c:246
F.massbal_close = function()
  do
    if (G.LoadingTotals ~= nil) then
      local _ = nil
      G.LoadingTotals = (nil)
    end
  end
  do
    if (G.QualTotals ~= nil) then
      local _ = nil
      G.QualTotals = (nil)
    end
  end
  do
    if (G.StepQualTotals ~= nil) then
      local _ = nil
      G.StepQualTotals = (nil)
    end
  end
  do
    if (G.NodeInflow ~= nil) then
      local _ = nil
      G.NodeInflow = (nil)
    end
  end
  do
    if (G.NodeOutflow ~= nil) then
      local _ = nil
      G.NodeOutflow = (nil)
    end
  end
end

-- massbal.c:262
F.massbal_report = function()
  local G_Nobjects, G_RptFlags, G_Subcatch = G.Nobjects, G.RptFlags, G.Subcatch
  local j = 0
  local gwArea = 0.0
  if (G_Nobjects[SUBCATCH] > 0) then
    if ((F.massbal_getRunoffError() > G.MAX_RUNOFF_BALANCE_ERR) or (G_RptFlags.continuity == 1)) then
      F.report_writeRunoffError(G.RunoffTotals, G.TotalArea)
    end
    if ((G_Nobjects[POLLUT] > 0) and (not (G.IgnoreQuality ~= 0))) then
      if ((F.massbal_getLoadingError() > G.MAX_RUNOFF_BALANCE_ERR) or (G_RptFlags.continuity == 1)) then
        F.report_writeLoadingError(G.LoadingTotals)
      end
    end
  end
  if ((G_Nobjects[AQUIFER] > 0) and (not (G.IgnoreGwater ~= 0))) then
    if ((F.massbal_getGwaterError() > G.MAX_RUNOFF_BALANCE_ERR) or (G_RptFlags.continuity == 1)) then
      do
        j = 0
        while (j < G_Nobjects[SUBCATCH]) do
          do
            if (G_Subcatch[j].groundwater ~= nil) then
              gwArea = (gwArea + G_Subcatch[j].area)
            end
          end
          j = j + 1
        end
      end
      if (gwArea > 0.0) then
        F.report_writeGwaterError(G.GwaterTotals, gwArea)
      end
    end
  end
  if ((G_Nobjects[NODE] > 0) and (not (G.IgnoreRouting ~= 0))) then
    if ((F.massbal_getFlowError() > G.MAX_FLOW_BALANCE_ERR) or (G_RptFlags.continuity == 1)) then
      F.report_writeFlowError(G.FlowTotals)
    end
    if ((G_Nobjects[POLLUT] > 0) and (not (G.IgnoreQuality ~= 0))) then
      if ((F.massbal_getQualError() > G.MAX_FLOW_BALANCE_ERR) or (G_RptFlags.continuity == 1)) then
        F.report_writeQualError(G.QualTotals)
      end
    end
  end
end

-- massbal.c:316
F.massbal_getBuildup = function(p)
  local G_Nobjects, G_Subcatch, G_Pollut = G.Nobjects, G.Subcatch, G.Pollut
  local i = 0
  local j = 0
  local load_ = 0.0
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        do
          i = 0
          while (i < G_Nobjects[LANDUSE]) do
            do
              load_ = (load_ + G_Subcatch[j].landFactor[i].buildup[p])
            end
            i = i + 1
          end
        end
        load_ = (load_ + (G_Subcatch[j].pondedQual[p] * G_Pollut[p].mcf))
      end
      j = j + 1
    end
  end
  do return load_ end
end

-- massbal.c:339
F.massbal_updateRunoffTotals = function(flowType, v)
  do
    local __sw1 = flowType
    if __sw1 < RUNOFF_RUNOFF then
      if __sw1 == RUNOFF_RAINFALL then goto case2
      elseif __sw1 == RUNOFF_EVAP then goto case3
      elseif __sw1 == RUNOFF_INFIL then goto case4
      end
    else
      if __sw1 == RUNOFF_RUNOFF then goto case5
      elseif __sw1 == RUNOFF_DRAINS then goto case6
      elseif __sw1 == RUNOFF_RUNON then goto case7
      end
    end
    goto swend1
    ::case2::
    do
      G.RunoffTotals.rainfall = (G.RunoffTotals.rainfall + v)
      goto swend1
    end
    ::case3::
    do
      G.RunoffTotals.evap = (G.RunoffTotals.evap + v)
      goto swend1
    end
    ::case4::
    do
      G.RunoffTotals.infil = (G.RunoffTotals.infil + v)
      goto swend1
    end
    ::case5::
    do
      G.RunoffTotals.runoff = (G.RunoffTotals.runoff + v)
      goto swend1
    end
    ::case6::
    do
      G.RunoffTotals.drains = (G.RunoffTotals.drains + v)
      goto swend1
    end
    ::case7::
    do
      G.RunoffTotals.runon = (G.RunoffTotals.runon + v)
      goto swend1
    end
    ::swend1::
  end
end

-- massbal.c:360
F.massbal_updateGwaterTotals = function(vInfil, vUpperEvap, vLowerEvap, vLowerPerc, vGwater)
  G.GwaterTotals.infil = (G.GwaterTotals.infil + vInfil)
  G.GwaterTotals.upperEvap = (G.GwaterTotals.upperEvap + vUpperEvap)
  G.GwaterTotals.lowerEvap = (G.GwaterTotals.lowerEvap + vLowerEvap)
  G.GwaterTotals.lowerPerc = (G.GwaterTotals.lowerPerc + vLowerPerc)
  G.GwaterTotals.gwater = (G.GwaterTotals.gwater + vGwater)
end

-- massbal.c:381
F.massbal_initTimeStepTotals = function()
  local G_StepFlowTotals, G_Nobjects, G_StepQualTotals = G.StepFlowTotals, G.Nobjects, G.StepQualTotals
  local j = 0
  G.OldStepFlowTotals = T.copy_TRoutingTotals(G_StepFlowTotals)
  G_StepFlowTotals.dwInflow = 0.0
  G_StepFlowTotals.wwInflow = 0.0
  G_StepFlowTotals.gwInflow = 0.0
  G_StepFlowTotals.iiInflow = 0.0
  G_StepFlowTotals.exInflow = 0.0
  G_StepFlowTotals.flooding = 0.0
  G_StepFlowTotals.outflow = 0.0
  G_StepFlowTotals.evapLoss = 0.0
  G_StepFlowTotals.seepLoss = 0.0
  G_StepFlowTotals.reacted = 0.0
  do
    j = 0
    while (j < G_Nobjects[POLLUT]) do
      do
        G_StepQualTotals[j].dwInflow = 0.0
        G_StepQualTotals[j].wwInflow = 0.0
        G_StepQualTotals[j].gwInflow = 0.0
        G_StepQualTotals[j].iiInflow = 0.0
        G_StepQualTotals[j].exInflow = 0.0
        G_StepQualTotals[j].flooding = 0.0
        G_StepQualTotals[j].outflow = 0.0
        G_StepQualTotals[j].reacted = 0.0
        G_StepQualTotals[j].seepLoss = 0.0
        G_StepQualTotals[j].initStorage = 0.0
        G_StepQualTotals[j].finalStorage = 0.0
      end
      j = j + 1
    end
  end
end

-- massbal.c:418
F.massbal_addInflowFlow = function(type_, q)
  local G_StepFlowTotals = G.StepFlowTotals
  do
    local __sw1 = type_
    if __sw1 == DRY_WEATHER_INFLOW then goto case2
    elseif __sw1 == WET_WEATHER_INFLOW then goto case3
    elseif __sw1 == GROUNDWATER_INFLOW then goto case4
    elseif __sw1 == RDII_INFLOW then goto case5
    elseif __sw1 == EXTERNAL_INFLOW then goto case6
    else goto swend1 end
    ::case2::
    do
      G_StepFlowTotals.dwInflow = (G_StepFlowTotals.dwInflow + q)
      goto swend1
    end
    ::case3::
    do
      G_StepFlowTotals.wwInflow = (G_StepFlowTotals.wwInflow + q)
      goto swend1
    end
    ::case4::
    do
      G_StepFlowTotals.gwInflow = (G_StepFlowTotals.gwInflow + q)
      goto swend1
    end
    ::case5::
    do
      G_StepFlowTotals.iiInflow = (G_StepFlowTotals.iiInflow + q)
      goto swend1
    end
    ::case6::
    do
      G_StepFlowTotals.exInflow = (G_StepFlowTotals.exInflow + q)
      goto swend1
    end
    ::swend1::
  end
end

-- massbal.c:438
F.massbal_updateLoadingTotals = function(type_, p, w)
  local G_LoadingTotals = G.LoadingTotals
  do
    local __sw1 = type_
    if __sw1 < BMP_REMOVAL_LOAD then
      if __sw1 == BUILDUP_LOAD then goto case2
      elseif __sw1 == DEPOSITION_LOAD then goto case3
      elseif __sw1 == SWEEPING_LOAD then goto case4
      end
    else
      if __sw1 < RUNOFF_LOAD then
        if __sw1 == BMP_REMOVAL_LOAD then goto case6
        elseif __sw1 == INFIL_LOAD then goto case5
        end
      else
        if __sw1 == RUNOFF_LOAD then goto case7
        elseif __sw1 == FINAL_LOAD then goto case8
        end
      end
    end
    goto swend1
    ::case2::
    do
      G_LoadingTotals[p].buildup = (G_LoadingTotals[p].buildup + w)
      goto swend1
    end
    ::case3::
    do
      G_LoadingTotals[p].deposition = (G_LoadingTotals[p].deposition + w)
      goto swend1
    end
    ::case4::
    do
      G_LoadingTotals[p].sweeping = (G_LoadingTotals[p].sweeping + w)
      goto swend1
    end
    ::case5::
    do
      G_LoadingTotals[p].infil = (G_LoadingTotals[p].infil + w)
      goto swend1
    end
    ::case6::
    do
      G_LoadingTotals[p].bmpRemoval = (G_LoadingTotals[p].bmpRemoval + w)
      goto swend1
    end
    ::case7::
    do
      G_LoadingTotals[p].runoff = (G_LoadingTotals[p].runoff + w)
      goto swend1
    end
    ::case8::
    do
      G_LoadingTotals[p].finalLoad = (G_LoadingTotals[p].finalLoad + w)
      goto swend1
    end
    ::swend1::
  end
end

-- massbal.c:461
F.massbal_addInflowQual = function(type_, p, w)
  local G_StepQualTotals = G.StepQualTotals
  if ((p < 0) or (p >= G.Nobjects[POLLUT])) then
    do return end
  end
  do
    local __sw1 = type_
    if __sw1 == DRY_WEATHER_INFLOW then goto case2
    elseif __sw1 == WET_WEATHER_INFLOW then goto case3
    elseif __sw1 == GROUNDWATER_INFLOW then goto case4
    elseif __sw1 == EXTERNAL_INFLOW then goto case5
    elseif __sw1 == RDII_INFLOW then goto case6
    else goto swend1 end
    ::case2::
    do
      G_StepQualTotals[p].dwInflow = (G_StepQualTotals[p].dwInflow + w)
      goto swend1
    end
    ::case3::
    do
      G_StepQualTotals[p].wwInflow = (G_StepQualTotals[p].wwInflow + w)
      goto swend1
    end
    ::case4::
    do
      G_StepQualTotals[p].gwInflow = (G_StepQualTotals[p].gwInflow + w)
      goto swend1
    end
    ::case5::
    do
      G_StepQualTotals[p].exInflow = (G_StepQualTotals[p].exInflow + w)
      goto swend1
    end
    ::case6::
    do
      G_StepQualTotals[p].iiInflow = (G_StepQualTotals[p].iiInflow + w)
      goto swend1
    end
    ::swend1::
  end
end

-- massbal.c:483
F.massbal_addOutflowFlow = function(q, isFlooded)
  local G_StepFlowTotals = G.StepFlowTotals
  if (isFlooded ~= 0) then
    G_StepFlowTotals.flooding = (G_StepFlowTotals.flooding + q)
  else
    G_StepFlowTotals.outflow = (G_StepFlowTotals.outflow + q)
  end
end

-- massbal.c:497
F.massbal_addOutflowQual = function(p, w, isFlooded)
  local G_StepQualTotals = G.StepQualTotals
  if ((p < 0) or (p >= G.Nobjects[POLLUT])) then
    do return end
  end
  if (w >= 0.0) then
    if (isFlooded ~= 0) then
      G_StepQualTotals[p].flooding = (G_StepQualTotals[p].flooding + w)
    else
      G_StepQualTotals[p].outflow = (G_StepQualTotals[p].outflow + w)
    end
  else
    G_StepQualTotals[p].exInflow = (G_StepQualTotals[p].exInflow - w)
  end
end

-- massbal.c:517
F.massbal_addReactedMass = function(p, w)
  local G_StepQualTotals = G.StepQualTotals
  if ((p < 0) or (p >= G.Nobjects[POLLUT])) then
    do return end
  end
  G_StepQualTotals[p].reacted = (G_StepQualTotals[p].reacted + w)
end

-- massbal.c:531
F.massbal_addSeepageLoss = function(p, w)
  local G_StepQualTotals = G.StepQualTotals
  if ((p < 0) or (p >= G.Nobjects[POLLUT])) then
    do return end
  end
  G_StepQualTotals[p].seepLoss = (G_StepQualTotals[p].seepLoss + w)
end

-- massbal.c:545
F.massbal_addToFinalStorage = function(p, w)
  local G_StepQualTotals = G.StepQualTotals
  if ((p < 0) or (p >= G.Nobjects[POLLUT])) then
    do return end
  end
  G_StepQualTotals[p].finalStorage = (G_StepQualTotals[p].finalStorage + w)
end

-- massbal.c:559
F.massbal_addNodeLosses = function(evapLoss, seepLoss)
  local G_StepFlowTotals = G.StepFlowTotals
  G_StepFlowTotals.evapLoss = (G_StepFlowTotals.evapLoss + evapLoss)
  G_StepFlowTotals.seepLoss = (G_StepFlowTotals.seepLoss + seepLoss)
end

-- massbal.c:573
F.massbal_addLinkLosses = function(evapLoss, seepLoss)
  local G_StepFlowTotals = G.StepFlowTotals
  G_StepFlowTotals.evapLoss = (G_StepFlowTotals.evapLoss + evapLoss)
  G_StepFlowTotals.seepLoss = (G_StepFlowTotals.seepLoss + seepLoss)
end

-- massbal.c:587
F.massbal_updateRoutingTotals = function(tStep)
  local G_StepFlowTotals, G_Nobjects, G_StepQualTotals, G_QualTotals, G_Node, G_NodeInflow = G.StepFlowTotals, G.Nobjects, G.StepQualTotals, G.QualTotals, G.Node, G.NodeInflow
  local G_NodeOutflow = G.NodeOutflow
  local j = 0
  G.FlowTotals.dwInflow = (G.FlowTotals.dwInflow + (G_StepFlowTotals.dwInflow * tStep))
  G.FlowTotals.wwInflow = (G.FlowTotals.wwInflow + (G_StepFlowTotals.wwInflow * tStep))
  G.FlowTotals.gwInflow = (G.FlowTotals.gwInflow + (G_StepFlowTotals.gwInflow * tStep))
  G.FlowTotals.iiInflow = (G.FlowTotals.iiInflow + (G_StepFlowTotals.iiInflow * tStep))
  G.FlowTotals.exInflow = (G.FlowTotals.exInflow + (G_StepFlowTotals.exInflow * tStep))
  G.FlowTotals.flooding = (G.FlowTotals.flooding + (G_StepFlowTotals.flooding * tStep))
  G.FlowTotals.outflow = (G.FlowTotals.outflow + (G_StepFlowTotals.outflow * tStep))
  G.FlowTotals.evapLoss = (G.FlowTotals.evapLoss + (G_StepFlowTotals.evapLoss * tStep))
  G.FlowTotals.seepLoss = (G.FlowTotals.seepLoss + (G_StepFlowTotals.seepLoss * tStep))
  do
    j = 0
    while (j < G_Nobjects[POLLUT]) do
      do
        G_QualTotals[j].dwInflow = (G_QualTotals[j].dwInflow + (G_StepQualTotals[j].dwInflow * tStep))
        G_QualTotals[j].wwInflow = (G_QualTotals[j].wwInflow + (G_StepQualTotals[j].wwInflow * tStep))
        G_QualTotals[j].gwInflow = (G_QualTotals[j].gwInflow + (G_StepQualTotals[j].gwInflow * tStep))
        G_QualTotals[j].iiInflow = (G_QualTotals[j].iiInflow + (G_StepQualTotals[j].iiInflow * tStep))
        G_QualTotals[j].exInflow = (G_QualTotals[j].exInflow + (G_StepQualTotals[j].exInflow * tStep))
        G_QualTotals[j].flooding = (G_QualTotals[j].flooding + (G_StepQualTotals[j].flooding * tStep))
        G_QualTotals[j].outflow = (G_QualTotals[j].outflow + (G_StepQualTotals[j].outflow * tStep))
        G_QualTotals[j].reacted = (G_QualTotals[j].reacted + (G_StepQualTotals[j].reacted * tStep))
        G_QualTotals[j].seepLoss = (G_QualTotals[j].seepLoss + (G_StepQualTotals[j].seepLoss * tStep))
        G_QualTotals[j].finalStorage = (G_QualTotals[j].finalStorage + G_StepQualTotals[j].finalStorage)
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        G_NodeInflow[j] = (G_NodeInflow[j] + (G_Node[j].inflow * tStep))
        if ((G_Node[j].type_ == OUTFALL) or (((G_Node[j].degree == 0) and (G_Node[j].type_ ~= STORAGE)))) then
          G_NodeOutflow[j] = (G_NodeOutflow[j] + (G_Node[j].inflow * tStep))
        else
          G_NodeOutflow[j] = (G_NodeOutflow[j] + (G_Node[j].outflow * tStep))
          if (G_Node[j].newVolume <= G_Node[j].fullVolume) then
            G_NodeOutflow[j] = (G_NodeOutflow[j] + (G_Node[j].overflow * tStep))
          end
        end
      end
      j = j + 1
    end
  end
end

-- massbal.c:638
F.massbal_getStorage = function(isFinalStorage)
  local G_Nobjects, G_Node, G_NodeOutflow, G_Link = G.Nobjects, G.Node, G.NodeOutflow, G.Link
  local j = 0
  local totalStorage = 0.0
  local nodeStorage = 0.0
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        nodeStorage = G_Node[j].newVolume
        if (isFinalStorage ~= 0) then
          G_NodeOutflow[j] = (G_NodeOutflow[j] + nodeStorage)
        end
        totalStorage = (totalStorage + nodeStorage)
      end
      j = j + 1
    end
  end
  if ((isFinalStorage ~= 0) and (G.RouteModel == SF)) then
    do return totalStorage end
  end
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        totalStorage = (totalStorage + G_Link[j].newVolume)
      end
      j = j + 1
    end
  end
  do return totalStorage end
end

-- massbal.c:670
F.massbal_getSysFlows = function(f, sysFlows)
  local G_OldStepFlowTotals, G_StepFlowTotals = G.OldStepFlowTotals, G.StepFlowTotals
  local f1 = (1.0 - f)
  sysFlows[SYS_DWFLOW] = ((((f1 * G_OldStepFlowTotals.dwInflow) + (f * G_StepFlowTotals.dwInflow))) * F.UCF(FLOW))
  sysFlows[SYS_GWFLOW] = ((((f1 * G_OldStepFlowTotals.gwInflow) + (f * G_StepFlowTotals.gwInflow))) * F.UCF(FLOW))
  sysFlows[SYS_IIFLOW] = ((((f1 * G_OldStepFlowTotals.iiInflow) + (f * G_StepFlowTotals.iiInflow))) * F.UCF(FLOW))
  sysFlows[SYS_EXFLOW] = ((((f1 * G_OldStepFlowTotals.exInflow) + (f * G_StepFlowTotals.exInflow))) * F.UCF(FLOW))
  sysFlows[SYS_FLOODING] = ((((f1 * G_OldStepFlowTotals.flooding) + (f * G_StepFlowTotals.flooding))) * F.UCF(FLOW))
  sysFlows[SYS_OUTFLOW] = ((((f1 * G_OldStepFlowTotals.outflow) + (f * G_StepFlowTotals.outflow))) * F.UCF(FLOW))
  sysFlows[SYS_STORAGE] = ((((f1 * G_OldStepFlowTotals.finalStorage) + (f * G_StepFlowTotals.finalStorage))) * F.UCF(VOLUME))
end

-- massbal.c:696
F.massbal_getRunoffError = function()
  local G_Nobjects = G.Nobjects
  local j = 0
  local totalInflow = 0.0
  local totalOutflow = 0.0
  G.RunoffTotals.finalStorage = 0.0
  G.RunoffTotals.finalSnowCover = 0.0
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        G.RunoffTotals.finalStorage = (G.RunoffTotals.finalStorage + (F.subcatch_getStorage(j)))
        G.RunoffTotals.finalSnowCover = (G.RunoffTotals.finalSnowCover + (F.snow_getSnowCover(j)))
      end
      j = j + 1
    end
  end
  G.RunoffTotals.snowRemoved = G.Snow.removed
  totalInflow = (((G.RunoffTotals.rainfall + G.RunoffTotals.runon) + G.RunoffTotals.initStorage) + G.RunoffTotals.initSnowCover)
  totalOutflow = ((((((G.RunoffTotals.evap + G.RunoffTotals.infil) + G.RunoffTotals.runoff) + G.RunoffTotals.drains) + G.RunoffTotals.snowRemoved) + G.RunoffTotals.finalStorage) + G.RunoffTotals.finalSnowCover)
  G.RunoffTotals.pctError = 0.0
  if (m_abs((totalInflow - totalOutflow)) < 1.0) then
    G.RunoffTotals.pctError = 1e-06
  elseif (totalInflow > 0.0) then
    G.RunoffTotals.pctError = (100.0 * ((1.0 - (totalOutflow / totalInflow))))
  elseif (totalOutflow > 0.0) then
    G.RunoffTotals.pctError = (100.0 * (((totalInflow / totalOutflow) - 1.0)))
  end
  G.RunoffError = G.RunoffTotals.pctError
  do return G.RunoffTotals.pctError end
end

-- massbal.c:750
F.massbal_getLoadingError = function()
  local G_Nobjects, G_LoadingTotals, G_Pollut = G.Nobjects, G.LoadingTotals, G.Pollut
  local j = 0
  local loadIn = 0.0
  local loadOut = 0.0
  local maxError = 0.0
  do
    j = 0
    while (j < G_Nobjects[POLLUT]) do
      do
        G_LoadingTotals[j].finalLoad = (G_LoadingTotals[j].finalLoad + (F.massbal_getBuildup(j)))
        loadIn = ((G_LoadingTotals[j].initLoad + G_LoadingTotals[j].buildup) + G_LoadingTotals[j].deposition)
        loadOut = ((((G_LoadingTotals[j].sweeping + G_LoadingTotals[j].infil) + G_LoadingTotals[j].bmpRemoval) + G_LoadingTotals[j].runoff) + G_LoadingTotals[j].finalLoad)
        G_LoadingTotals[j].pctError = 0.0
        if (m_abs((loadIn - loadOut)) < 0.001) then
          G_LoadingTotals[j].pctError = 1e-06
        elseif (loadIn > 0.0) then
          G_LoadingTotals[j].pctError = (100.0 * ((1.0 - (loadOut / loadIn))))
        elseif (loadOut > 0.0) then
          G_LoadingTotals[j].pctError = (100.0 * (((loadIn / loadOut) - 1.0)))
        end
        maxError = (((((maxError) >= (G_LoadingTotals[j].pctError))) and (maxError) or (G_LoadingTotals[j].pctError)))
        if (G_Pollut[j].units == COUNT) then
          G_LoadingTotals[j].initLoad = ((((G_LoadingTotals[j].initLoad) > 0.0) and R.log10((G_LoadingTotals[j].initLoad)) or (G_LoadingTotals[j].initLoad)))
          G_LoadingTotals[j].buildup = ((((G_LoadingTotals[j].buildup) > 0.0) and R.log10((G_LoadingTotals[j].buildup)) or (G_LoadingTotals[j].buildup)))
          G_LoadingTotals[j].deposition = ((((G_LoadingTotals[j].deposition) > 0.0) and R.log10((G_LoadingTotals[j].deposition)) or (G_LoadingTotals[j].deposition)))
          G_LoadingTotals[j].sweeping = ((((G_LoadingTotals[j].sweeping) > 0.0) and R.log10((G_LoadingTotals[j].sweeping)) or (G_LoadingTotals[j].sweeping)))
          G_LoadingTotals[j].infil = ((((G_LoadingTotals[j].infil) > 0.0) and R.log10((G_LoadingTotals[j].infil)) or (G_LoadingTotals[j].infil)))
          G_LoadingTotals[j].bmpRemoval = ((((G_LoadingTotals[j].bmpRemoval) > 0.0) and R.log10((G_LoadingTotals[j].bmpRemoval)) or (G_LoadingTotals[j].bmpRemoval)))
          G_LoadingTotals[j].runoff = ((((G_LoadingTotals[j].runoff) > 0.0) and R.log10((G_LoadingTotals[j].runoff)) or (G_LoadingTotals[j].runoff)))
          G_LoadingTotals[j].finalLoad = ((((G_LoadingTotals[j].finalLoad) > 0.0) and R.log10((G_LoadingTotals[j].finalLoad)) or (G_LoadingTotals[j].finalLoad)))
        end
      end
      j = j + 1
    end
  end
  do return maxError end
end

-- massbal.c:813
F.massbal_getGwaterError = function()
  local G_Nobjects, G_Subcatch = G.Nobjects, G.Subcatch
  local j = 0
  local totalInflow = 0.0
  local totalOutflow = 0.0
  G.GwaterTotals.finalStorage = 0.0
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        G.GwaterTotals.finalStorage = (G.GwaterTotals.finalStorage + (F.gwater_getVolume(j) * G_Subcatch[j].area))
      end
      j = j + 1
    end
  end
  totalInflow = (G.GwaterTotals.infil + G.GwaterTotals.initStorage)
  totalOutflow = ((((G.GwaterTotals.upperEvap + G.GwaterTotals.lowerEvap) + G.GwaterTotals.lowerPerc) + G.GwaterTotals.gwater) + G.GwaterTotals.finalStorage)
  G.GwaterTotals.pctError = 0.0
  if (m_abs((totalInflow - totalOutflow)) < 1.0) then
    G.GwaterTotals.pctError = 1e-06
  elseif (totalInflow > 0.0) then
    G.GwaterTotals.pctError = (100.0 * ((1.0 - (totalOutflow / totalInflow))))
  elseif (totalOutflow > 0.0) then
    G.GwaterTotals.pctError = (100.0 * (((totalInflow / totalOutflow) - 1.0)))
  end
  G.GwaterError = G.GwaterTotals.pctError
  do return G.GwaterTotals.pctError end
end

-- massbal.c:858
F.massbal_getFlowError = function()
  local totalInflow = 0.0
  local totalOutflow = 0.0
  G.FlowTotals.finalStorage = F.massbal_getStorage(1)
  totalInflow = ((G.FlowTotals.initStorage + G.FlowTotals.wwInflow) + G.FlowTotals.iiInflow)
  totalOutflow = ((((G.FlowTotals.finalStorage + G.FlowTotals.flooding) + G.FlowTotals.evapLoss) + G.FlowTotals.seepLoss) + G.FlowTotals.reacted)
  if (G.FlowTotals.dwInflow >= 0.0) then
    totalInflow = (totalInflow + G.FlowTotals.dwInflow)
  else
    totalOutflow = (totalOutflow - G.FlowTotals.dwInflow)
  end
  if (G.FlowTotals.gwInflow >= 0.0) then
    totalInflow = (totalInflow + G.FlowTotals.gwInflow)
  else
    totalOutflow = (totalOutflow - G.FlowTotals.gwInflow)
  end
  if (G.FlowTotals.exInflow >= 0.0) then
    totalInflow = (totalInflow + G.FlowTotals.exInflow)
  else
    totalOutflow = (totalOutflow - G.FlowTotals.exInflow)
  end
  if (G.FlowTotals.outflow >= 0.0) then
    totalOutflow = (totalOutflow + G.FlowTotals.outflow)
  else
    totalInflow = (totalInflow - G.FlowTotals.outflow)
  end
  G.FlowTotals.pctError = 0.0
  if (m_abs((totalInflow - totalOutflow)) < 1.0) then
    G.FlowTotals.pctError = 1e-06
  elseif (m_abs(totalInflow) > 0.0) then
    G.FlowTotals.pctError = (100.0 * ((1.0 - (totalOutflow / totalInflow))))
  elseif (m_abs(totalOutflow) > 0.0) then
    G.FlowTotals.pctError = (100.0 * (((totalInflow / totalOutflow) - 1.0)))
  end
  G.FlowError = G.FlowTotals.pctError
  do return G.FlowTotals.pctError end
end

-- massbal.c:906
F.massbal_getQualError = function()
  local G_Nobjects, G_QualTotals, G_Pollut = G.Nobjects, G.QualTotals, G.Pollut
  local p = 0
  local maxQualError = 0.0
  local totalInflow = 0.0
  local totalOutflow = 0.0
  local cf = 0.0
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        G_QualTotals[p].finalStorage = (G_QualTotals[p].finalStorage + (F.massbal_getStoredMass(p)))
        totalInflow = (((((G_QualTotals[p].dwInflow + G_QualTotals[p].wwInflow) + G_QualTotals[p].gwInflow) + G_QualTotals[p].iiInflow) + G_QualTotals[p].exInflow) + G_QualTotals[p].initStorage)
        totalOutflow = ((((G_QualTotals[p].flooding + G_QualTotals[p].outflow) + G_QualTotals[p].reacted) + G_QualTotals[p].seepLoss) + G_QualTotals[p].finalStorage)
        G_QualTotals[p].pctError = 0.0
        if (m_abs((totalInflow - totalOutflow)) < 0.001) then
          G_QualTotals[p].pctError = 1e-06
        elseif (totalInflow > 0.0) then
          G_QualTotals[p].pctError = (100.0 * ((1.0 - (totalOutflow / totalInflow))))
        elseif (totalOutflow > 0.0) then
          G_QualTotals[p].pctError = (100.0 * (((totalInflow / totalOutflow) - 1.0)))
        end
        if (m_abs(G_QualTotals[p].pctError) > m_abs(maxQualError)) then
          maxQualError = G_QualTotals[p].pctError
        end
        cf = 28.317
        if (G_Pollut[p].units == COUNT) then
          G_QualTotals[p].dwInflow = (((((cf * G_QualTotals[p].dwInflow)) > 0.0) and R.log10(((cf * G_QualTotals[p].dwInflow))) or ((cf * G_QualTotals[p].dwInflow))))
          G_QualTotals[p].wwInflow = (((((cf * G_QualTotals[p].wwInflow)) > 0.0) and R.log10(((cf * G_QualTotals[p].wwInflow))) or ((cf * G_QualTotals[p].wwInflow))))
          G_QualTotals[p].gwInflow = (((((cf * G_QualTotals[p].gwInflow)) > 0.0) and R.log10(((cf * G_QualTotals[p].gwInflow))) or ((cf * G_QualTotals[p].gwInflow))))
          G_QualTotals[p].iiInflow = (((((cf * G_QualTotals[p].iiInflow)) > 0.0) and R.log10(((cf * G_QualTotals[p].iiInflow))) or ((cf * G_QualTotals[p].iiInflow))))
          G_QualTotals[p].exInflow = (((((cf * G_QualTotals[p].exInflow)) > 0.0) and R.log10(((cf * G_QualTotals[p].exInflow))) or ((cf * G_QualTotals[p].exInflow))))
          G_QualTotals[p].flooding = (((((cf * G_QualTotals[p].flooding)) > 0.0) and R.log10(((cf * G_QualTotals[p].flooding))) or ((cf * G_QualTotals[p].flooding))))
          G_QualTotals[p].outflow = (((((cf * G_QualTotals[p].outflow)) > 0.0) and R.log10(((cf * G_QualTotals[p].outflow))) or ((cf * G_QualTotals[p].outflow))))
          G_QualTotals[p].reacted = (((((cf * G_QualTotals[p].reacted)) > 0.0) and R.log10(((cf * G_QualTotals[p].reacted))) or ((cf * G_QualTotals[p].reacted))))
          G_QualTotals[p].seepLoss = (((((cf * G_QualTotals[p].seepLoss)) > 0.0) and R.log10(((cf * G_QualTotals[p].seepLoss))) or ((cf * G_QualTotals[p].seepLoss))))
          G_QualTotals[p].initStorage = (((((cf * G_QualTotals[p].initStorage)) > 0.0) and R.log10(((cf * G_QualTotals[p].initStorage))) or ((cf * G_QualTotals[p].initStorage))))
          G_QualTotals[p].finalStorage = (((((cf * G_QualTotals[p].finalStorage)) > 0.0) and R.log10(((cf * G_QualTotals[p].finalStorage))) or ((cf * G_QualTotals[p].finalStorage))))
        else
          cf = (cf * F.UCF(MASS))
          if (G_Pollut[p].units == UG) then
            cf = (cf / 1000.0)
          end
          G_QualTotals[p].dwInflow = (G_QualTotals[p].dwInflow * cf)
          G_QualTotals[p].wwInflow = (G_QualTotals[p].wwInflow * cf)
          G_QualTotals[p].gwInflow = (G_QualTotals[p].gwInflow * cf)
          G_QualTotals[p].iiInflow = (G_QualTotals[p].iiInflow * cf)
          G_QualTotals[p].exInflow = (G_QualTotals[p].exInflow * cf)
          G_QualTotals[p].flooding = (G_QualTotals[p].flooding * cf)
          G_QualTotals[p].outflow = (G_QualTotals[p].outflow * cf)
          G_QualTotals[p].reacted = (G_QualTotals[p].reacted * cf)
          G_QualTotals[p].seepLoss = (G_QualTotals[p].seepLoss * cf)
          G_QualTotals[p].initStorage = (G_QualTotals[p].initStorage * cf)
          G_QualTotals[p].finalStorage = (G_QualTotals[p].finalStorage * cf)
        end
      end
      p = p + 1
    end
  end
  G.QualError = maxQualError
  do return maxQualError end
end

-- massbal.c:995
F.massbal_getStepFlowError = function()
  local G_StepFlowTotals = G.StepFlowTotals
  local totalInflow = 0.0
  local totalOutflow = 0.0
  totalInflow = ((((G_StepFlowTotals.dwInflow + G_StepFlowTotals.wwInflow) + G_StepFlowTotals.gwInflow) + G_StepFlowTotals.iiInflow) + G_StepFlowTotals.exInflow)
  totalOutflow = ((((G_StepFlowTotals.flooding + G_StepFlowTotals.outflow) + G_StepFlowTotals.evapLoss) + G_StepFlowTotals.seepLoss) + G_StepFlowTotals.reacted)
  if (m_abs(totalInflow) > 0.0) then
    do return (1.0 - (totalOutflow / totalInflow)) end
  elseif (m_abs(totalOutflow) > 0.0) then
    do return ((totalInflow / totalOutflow) - 1.0) end
  else
    do return 0.0 end
  end
end

-- massbal.c:1025
F.massbal_getStoredMass = function(p)
  local G_Nobjects, G_Node, G_Link = G.Nobjects, G.Node, G.Link
  local j = 0
  local storedMass = 0.0
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        storedMass = (storedMass + (G_Node[j].newVolume * G_Node[j].newQual[p]))
      end
      j = j + 1
    end
  end
  if (G.RouteModel ~= SF) then
    do
      j = 0
      while (j < G_Nobjects[LINK]) do
        do
          storedMass = (storedMass + (G_Link[j].newVolume * G_Link[j].newQual[p]))
        end
        j = j + 1
      end
    end
  end
  do return storedMass end
end

