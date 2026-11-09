-- Generated from EPA SWMM 5.2.4 (dynwave.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local NODE <const> = 2
local ERR_MEMORY <const> = 101
local LINK <const> = 3
local DRY <const> = 0
local SLOT <const> = 1
local LENGTH <const> = 3
local CONDUIT <const> = 0
local DUMMY <const> = 0
local PUMP <const> = 1
local STORAGE <const> = 2
local TYPE1_PUMP <const> = 0
local TYPE2_PUMP <const> = 1
local TYPE4_PUMP <const> = 3
local TYPE3_PUMP <const> = 2
local ORIFICE <const> = 2
local UP_CRITICAL <const> = 5
local DN_CRITICAL <const> = 6
local OUTFALL <const> = 1
local EXTRAN <const> = 0
local _ENV = R.strict

G.MINTIMESTEP = 0.001
G.dynwave_OMEGA = 0.5
G.DEFAULT_SURFAREA = 12.566
G.DEFAULT_HEADTOL = 0.005
G.EXTRAN_CROWN_CUTOFF = 0.96
G.SLOT_CROWN_CUTOFF = 0.985257
G.DEFAULT_MAXTRIALS = 8
G.VariableStep = 0.0
G.Xnode = nil
G.Omega = 0.0
G.Steps = 0

-- dynwave.c:117
F.dynwave_init = function()
  local G_Nobjects, G_Node, G_Link = G.Nobjects, G.Node, G.Link
  local i = 0
  local j = 0
  local z = 0.0
  G.VariableStep = 0.0
  G.Xnode = R.recs(G_Nobjects[NODE], T.TXnode)
  if (G.Xnode == (nil)) then
    F.report_writeErrorMsg(ERR_MEMORY, S[45])
    do return end
  end
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        G.Xnode[i].newSurfArea = 0.0
        G.Xnode[i].oldSurfArea = 0.0
        G_Node[i].crownElev = G_Node[i].invertElev
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        j = G_Link[i].node1
        z = ((G_Node[j].invertElev + G_Link[i].offset1) + G_Link[i].xsect.yFull)
        G_Node[j].crownElev = (((((G_Node[j].crownElev) >= (z))) and (G_Node[j].crownElev) or (z)))
        j = G_Link[i].node2
        z = ((G_Node[j].invertElev + G_Link[i].offset2) + G_Link[i].xsect.yFull)
        G_Node[j].crownElev = (((((G_Node[j].crownElev) >= (z))) and (G_Node[j].crownElev) or (z)))
        G_Link[i].flowClass = DRY
        G_Link[i].dqdh = 0.0
      end
      i = i + 1
    end
  end
  if (G.SurchargeMethod == SLOT) then
    G.CrownCutoff = G.SLOT_CROWN_CUTOFF
  else
    G.CrownCutoff = G.EXTRAN_CROWN_CUTOFF
  end
end

-- dynwave.c:165
F.dynwave_close = function()
  do
    if (G.Xnode ~= nil) then
      local _ = nil
      G.Xnode = (nil)
    end
  end
end

-- dynwave.c:177
F.dynwave_validate = function()
  if (G.MinRouteStep > G.RouteStep) then
    G.MinRouteStep = G.RouteStep
  end
  if (G.MinRouteStep < G.MINTIMESTEP) then
    G.MinRouteStep = G.MINTIMESTEP
  end
  if (G.MinSurfArea == 0.0) then
    G.MinSurfArea = G.DEFAULT_SURFAREA
  else
    G.MinSurfArea = (G.MinSurfArea / (F.UCF(LENGTH) * F.UCF(LENGTH)))
  end
  if (G.HeadTol == 0.0) then
    G.HeadTol = G.DEFAULT_HEADTOL
  else
    G.HeadTol = (G.HeadTol / (F.UCF(LENGTH)))
  end
  if (G.MaxTrials == 0) then
    G.MaxTrials = G.DEFAULT_MAXTRIALS
  end
end

-- dynwave.c:195
F.dynwave_getRoutingStep = function(fixedStep)
  if (G.CourantFactor == 0.0) then
    do return fixedStep end
  end
  if (fixedStep < G.MINTIMESTEP) then
    do return fixedStep end
  end
  if (G.VariableStep == 0.0) then
    G.VariableStep = G.MinRouteStep
  else
    G.VariableStep = F.getVariableStep(fixedStep)
  end
  G.VariableStep = (R.floor((1000.0 * G.VariableStep)) / 1000.0)
  do return G.VariableStep end
end

-- dynwave.c:224
F.dynwave_execute = function(tStep)
  local converged = 0
  if (G.ErrorCode ~= 0) then
    do return 0 end
  end
  G.Steps = 0
  converged = 0
  G.Omega = G.dynwave_OMEGA
  F.initRoutingStep()
  while (G.Steps < G.MaxTrials) do
    do
      F.initNodeStates()
      F.findLinkFlows(tStep)
      converged = F.findNodeDepths(tStep)
      G.Steps = G.Steps + 1
      if (G.Steps > 1) then
        if (converged ~= 0) then
          break
        end
        F.findBypassedLinks()
      end
    end
  end
  if (not (converged ~= 0)) then
    F.updateConvergenceStats()
  end
  F.findLimitedLinks()
  do return G.Steps end
end

-- dynwave.c:266
F.updateConvergenceStats = function()
  local G_Nobjects, G_Xnode = G.Nobjects, G.Xnode
  local i = 0
  G.NonConvergeCount = G.NonConvergeCount + 1
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        F.stats_updateConvergenceStats(i, G_Xnode[i].converged)
      end
      i = i + 1
    end
  end
end

-- dynwave.c:276
F.initRoutingStep = function()
  local G_Nobjects, G_Xnode, G_Link, G_Nlinks, G_Conduit = G.Nobjects, G.Xnode, G.Link, G.Nlinks, G.Conduit
  local i = 0
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        G_Xnode[i].converged = 0
        G_Xnode[i].dYdT = 0.0
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        G_Link[i].bypassed = 0
        G_Link[i].surfArea1 = 0.0
        G_Link[i].surfArea2 = 0.0
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nlinks[CONDUIT]) do
      do
        G_Conduit[i].a2 = G_Conduit[i].a1
      end
      i = i + 1
    end
  end
end

-- dynwave.c:297
F.initNodeStates = function()
  local G_Nobjects, G_Node, G_Xnode = G.Nobjects, G.Node, G.Xnode
  local i = 0
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        if (G.AllowPonding ~= 0) then
          G_Xnode[i].newSurfArea = F.node_getPondedArea(i, G_Node[i].newDepth)
        else
          G_Xnode[i].newSurfArea = F.node_getSurfArea(i, G_Node[i].newDepth)
        end
        G_Node[i].inflow = 0.0
        G_Node[i].outflow = G_Node[i].losses
        if (G_Node[i].newLatFlow >= 0.0) then
          G_Node[i].inflow = (G_Node[i].inflow + G_Node[i].newLatFlow)
        else
          G_Node[i].outflow = (G_Node[i].outflow - G_Node[i].newLatFlow)
        end
        G_Xnode[i].sumdqdh = 0.0
      end
      i = i + 1
    end
  end
end

-- dynwave.c:335
F.findBypassedLinks = function()
  local G_Nobjects, G_Xnode, G_Link = G.Nobjects, G.Xnode, G.Link
  local i = 0
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        if ((G_Xnode[G_Link[i].node1].converged ~= 0) and (G_Xnode[G_Link[i].node2].converged ~= 0)) then
          G_Link[i].bypassed = 1
        else
          G_Link[i].bypassed = 0
        end
      end
      i = i + 1
    end
  end
end

-- dynwave.c:349
F.findLimitedLinks = function()
  local G_Nobjects, G_Link, G_Conduit, G_Node = G.Nobjects, G.Link, G.Conduit, G.Node
  local j = 0
  local n1 = 0
  local n2 = 0
  local k = 0
  local h1 = 0.0
  local h2 = 0.0
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        if (not (F.isTrueConduit(j) ~= 0)) then
          goto continue1
        end
        k = G_Link[j].subIndex
        G_Conduit[k].capacityLimited = 0
        if (G_Conduit[k].a1 >= G_Link[j].xsect.aFull) then
          n1 = G_Link[j].node1
          n2 = G_Link[j].node2
          h1 = (G_Node[n1].newDepth + G_Node[n1].invertElev)
          h2 = (G_Node[n2].newDepth + G_Node[n2].invertElev)
          if (((h1 - h2)) > (m_abs(G_Conduit[k].slope) * G_Conduit[k].length)) then
            G_Conduit[k].capacityLimited = 1
          end
        end
      end
      ::continue1::
      j = j + 1
    end
  end
end

-- dynwave.c:382
F.findLinkFlows = function(dt)
  local G_Nobjects, G_Link = G.Nobjects, G.Link
  local i = 0
  do
    do
      i = 0
      while (i < G_Nobjects[LINK]) do
        do
          if ((F.isTrueConduit(i) ~= 0) and (not (G_Link[i].bypassed ~= 0))) then
            F.dwflow_findConduitFlow(i, G.Steps, G.Omega, dt)
          end
        end
        i = i + 1
      end
    end
  end
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        if (F.isTrueConduit(i) ~= 0) then
          F.updateNodeFlows(i)
        end
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        if (not (F.isTrueConduit(i) ~= 0)) then
          if (not (G_Link[i].bypassed ~= 0)) then
            F.findNonConduitFlow(i, dt)
          end
          F.updateNodeFlows(i)
        end
      end
      i = i + 1
    end
  end
end

-- dynwave.c:416
F.isTrueConduit = function(j)
  local G_Link = G.Link
  do return ((((G_Link[j].type_ == CONDUIT) and (G_Link[j].xsect.type_ ~= DUMMY))) and 1 or 0) end
end

-- dynwave.c:423
F.findNonConduitFlow = function(i, dt)
  local G_Link = G.Link
  local qLast = 0.0
  local qNew = 0.0
  qLast = G_Link[i].newFlow
  G_Link[i].dqdh = 0.0
  qNew = F.link_getInflow(i)
  if (G_Link[i].type_ == PUMP) then
    qNew = F.getModPumpFlow(i, qNew, dt)
  end
  F.findNonConduitSurfArea(i)
  if ((G.Steps > 0) and (G_Link[i].type_ ~= PUMP)) then
    qNew = ((((1.0 - G.Omega)) * qLast) + (G.Omega * qNew))
    if ((qNew * qLast) < 0.0) then
      qNew = (0.001 * ((((((qNew) < 0.0)) and ((-1)) or (1))) * 1.0))
    end
  end
  G_Link[i].newFlow = qNew
end

-- dynwave.c:458
F.getModPumpFlow = function(i, q, dt)
  local G_Link, G_Node = G.Link, G.Node
  local j = G_Link[i].node1
  local k = G_Link[i].subIndex
  local newNetInflow = 0.0
  local netFlowVolume = 0.0
  local y = 0.0
  if (q == 0.0) then
    do return q end
  end
  if (G_Node[j].type_ == STORAGE) then
    do return F.node_getMaxOutflow(j, q, dt) end
  end
  do
    local __sw1 = G.Pump[k].type_
    if __sw1 == TYPE1_PUMP then goto case2
    elseif __sw1 == TYPE2_PUMP or __sw1 == TYPE4_PUMP or __sw1 == TYPE3_PUMP then goto case3
    else goto swend1 end
    ::case2::
    do
      do return F.node_getMaxOutflow(j, q, dt) end
    end
    ::case3::
    do
      newNetInflow = ((G_Node[j].inflow - G_Node[j].outflow) - q)
      netFlowVolume = ((0.5 * ((G_Node[j].oldNetInflow + newNetInflow))) * dt)
      y = (G_Node[j].oldDepth + (netFlowVolume / G.Xnode[j].newSurfArea))
      if (y <= 0.0) then
        do return G_Node[j].inflow end
      end
    end
    ::swend1::
  end
  do return q end
end

-- dynwave.c:503
F.findNonConduitSurfArea = function(i)
  local G_Link, G_Node = G.Link, G.Node
  if (G_Link[i].type_ == ORIFICE) then
    G_Link[i].surfArea1 = (G.Orifice[G_Link[i].subIndex].surfArea / 2.0)
  else
    G_Link[i].surfArea1 = 0.0
  end
  G_Link[i].surfArea2 = G_Link[i].surfArea1
  if ((G_Link[i].flowClass == UP_CRITICAL) or (G_Node[G_Link[i].node1].type_ == STORAGE)) then
    G_Link[i].surfArea1 = 0.0
  end
  if ((G_Link[i].flowClass == DN_CRITICAL) or (G_Node[G_Link[i].node2].type_ == STORAGE)) then
    G_Link[i].surfArea2 = 0.0
  end
end

-- dynwave.c:528
F.updateNodeFlows = function(i)
  local G_Link, G_Node, G_Conduit, G_Xnode = G.Link, G.Node, G.Conduit, G.Xnode
  local k = 0
  local barrels = 1
  local n1 = G_Link[i].node1
  local n2 = G_Link[i].node2
  local q = G_Link[i].newFlow
  local conduitLossRate = 0.0
  if (q >= 0.0) then
    G_Node[n1].outflow = (G_Node[n1].outflow + q)
    G_Node[n2].inflow = (G_Node[n2].inflow + q)
  else
    G_Node[n1].inflow = (G_Node[n1].inflow - q)
    G_Node[n2].outflow = (G_Node[n2].outflow - q)
  end
  if (G_Link[i].type_ == CONDUIT) then
    k = G_Link[i].subIndex
    barrels = G_Conduit[k].barrels
    conduitLossRate = (((G_Conduit[k].evapLossRate + G_Conduit[k].seepLossRate)) * (barrels * 1.0))
    if (conduitLossRate > 0.0) then
      if ((G_Node[n1].type_ ~= OUTFALL) and (G_Node[n2].type_ ~= OUTFALL)) then
        conduitLossRate = (conduitLossRate / 2.0)
      end
      if (G_Node[n1].type_ ~= OUTFALL) then
        G_Node[n1].outflow = (G_Node[n1].outflow + conduitLossRate)
      end
      if (G_Node[n2].type_ ~= OUTFALL) then
        G_Node[n2].outflow = (G_Node[n2].outflow + conduitLossRate)
      end
    end
  end
  G_Xnode[G_Link[i].node1].newSurfArea = (G_Xnode[G_Link[i].node1].newSurfArea + (G_Link[i].surfArea1 * (barrels * 1.0)))
  G_Xnode[G_Link[i].node2].newSurfArea = (G_Xnode[G_Link[i].node2].newSurfArea + (G_Link[i].surfArea2 * (barrels * 1.0)))
  G_Xnode[G_Link[i].node1].sumdqdh = (G_Xnode[G_Link[i].node1].sumdqdh + G_Link[i].dqdh)
  if (G_Link[i].type_ == PUMP) then
    k = G_Link[i].subIndex
    if (G.Pump[k].type_ ~= TYPE4_PUMP) then
      G_Xnode[n2].sumdqdh = (G_Xnode[n2].sumdqdh + G_Link[i].dqdh)
    end
  else
    G_Xnode[n2].sumdqdh = (G_Xnode[n2].sumdqdh + G_Link[i].dqdh)
  end
end

-- dynwave.c:593
F.findNodeDepths = function(dt)
  local G_Nobjects, G_Node, G_Xnode = G.Nobjects, G.Node, G.Xnode
  local i = 0
  local yOld = 0.0
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        F.link_setOutfallDepth(i)
      end
      i = i + 1
    end
  end
  do
    do
      i = 0
      while (i < G_Nobjects[NODE]) do
        do
          if (G_Node[i].type_ == OUTFALL) then
            goto continue2
          end
          yOld = G_Node[i].newDepth
          F.setNodeDepth(i, dt)
          G_Xnode[i].converged = 1
          if (m_abs((yOld - G_Node[i].newDepth)) > G.HeadTol) then
            G_Xnode[i].converged = 0
          end
        end
        ::continue2::
        i = i + 1
      end
    end
  end
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        if (G_Node[i].type_ == OUTFALL) then
          goto continue3
        end
        if (G_Xnode[i].converged == 0) then
          do return 0 end
        end
      end
      ::continue3::
      i = i + 1
    end
  end
  do return 1 end
end

-- dynwave.c:636
F.setNodeDepth = function(i, dt)
  local G_Node, G_Xnode = G.Node, G.Xnode
  local canPond = 0
  local isPonded = 0
  local isSurcharged = 0
  local dQ = 0.0
  local dV = 0.0
  local dy = 0.0
  local yMax = 0.0
  local yOld = 0.0
  local yLast = 0.0
  local yNew = 0.0
  local yCrown = 0.0
  local surfArea = 0.0
  local denom = 0.0
  local corr = 0.0
  local f = 0.0
  canPond = ((((G.AllowPonding ~= 0) and (G_Node[i].pondedArea > 0.0))) and 1 or 0)
  isPonded = ((((canPond ~= 0) and (G_Node[i].newDepth > G_Node[i].fullDepth))) and 1 or 0)
  yCrown = (G_Node[i].crownElev - G_Node[i].invertElev)
  yOld = G_Node[i].oldDepth
  yLast = G_Node[i].newDepth
  G_Node[i].overflow = 0.0
  surfArea = G_Xnode[i].newSurfArea
  surfArea = (((((surfArea) >= (G.MinSurfArea))) and (surfArea) or (G.MinSurfArea)))
  dQ = (G_Node[i].inflow - G_Node[i].outflow)
  dV = ((0.5 * ((G_Node[i].oldNetInflow + dQ))) * dt)
  if (G.SurchargeMethod == EXTRAN) then
    if (isPonded ~= 0) then
      isSurcharged = 0
    elseif (G_Node[i].type_ == STORAGE) then
      isSurcharged = ((((G_Node[i].surDepth > 0.0) and (yLast > G_Node[i].fullDepth))) and 1 or 0)
    else
      isSurcharged = ((((yCrown > 0.0) and (yLast > yCrown))) and 1 or 0)
    end
  end
  if (not (isSurcharged ~= 0)) then
    dy = (dV / surfArea)
    yNew = (yOld + dy)
    if (not (isPonded ~= 0)) then
      G_Xnode[i].oldSurfArea = surfArea
    end
    if (G.Steps > 0) then
      yNew = ((((1.0 - G.Omega)) * yLast) + (G.Omega * yNew))
    end
    if ((isPonded ~= 0) and (yNew < G_Node[i].fullDepth)) then
      yNew = (G_Node[i].fullDepth - 0.0001)
    end
  else
    corr = 1.0
    if (G_Node[i].degree < 0) then
      corr = 0.6
    end
    denom = G_Xnode[i].sumdqdh
    if (yLast < (1.25 * yCrown)) then
      f = (((yLast - yCrown)) / yCrown)
      denom = (denom + ((((G_Xnode[i].oldSurfArea / dt) - G_Xnode[i].sumdqdh)) * m_exp(((-15.0) * f))))
    end
    if (denom == 0.0) then
      dy = 0.0
    else
      dy = ((corr * dQ) / denom)
    end
    yNew = (yLast + dy)
    if (yNew < yCrown) then
      yNew = (yCrown - 0.0001)
    end
    if ((canPond ~= 0) and (yNew > G_Node[i].fullDepth)) then
      yNew = (G_Node[i].fullDepth + 0.0001)
    end
  end
  if (yNew < 0.0) then
    yNew = 0.0
  end
  yMax = G_Node[i].fullDepth
  if (canPond == 0) then
    yMax = (yMax + G_Node[i].surDepth)
  end
  if (yNew > yMax) then
    yNew = F.getFloodedDepth(i, canPond, dV, yNew, yMax, dt)
  else
    G_Node[i].newVolume = F.node_getVolume(i, yNew)
  end
  G_Xnode[i].dYdT = (m_abs((yNew - yOld)) / dt)
  G_Node[i].newDepth = yNew
end

-- dynwave.c:766
F.getFloodedDepth = function(i, canPond, dV, yNew, yMax, dt)
  local G_Node = G.Node
  if (canPond == 0) then
    G_Node[i].overflow = (dV / dt)
    G_Node[i].newVolume = G_Node[i].fullVolume
    yNew = yMax
  else
    G_Node[i].newVolume = (((((((G_Node[i].oldVolume + dV))) >= (G_Node[i].fullVolume))) and (((G_Node[i].oldVolume + dV))) or (G_Node[i].fullVolume)))
    G_Node[i].overflow = (((G_Node[i].newVolume - (((((G_Node[i].oldVolume) >= (G_Node[i].fullVolume))) and (G_Node[i].oldVolume) or (G_Node[i].fullVolume))))) / dt)
  end
  if (G_Node[i].overflow < 0.0001) then
    G_Node[i].overflow = 0.0
  end
  do return yNew end
end

-- dynwave.c:799
F.getVariableStep = function(maxStep)
  local minLink = {(-1)}
  local minNode = {(-1)}
  local tMin = 0.0
  local tMinLink = 0.0
  local tMinNode = 0.0
  tMin = maxStep
  tMinLink = F.getLinkStep(tMin, minLink, 1)
  tMinNode = F.getNodeStep(tMinLink, minNode, 1)
  tMin = tMinLink
  if (tMinNode < tMin) then
    tMin = tMinNode
    minLink[1] = (-1)
  end
  F.stats_updateCriticalTimeCount(minNode[1], minLink[1])
  if (tMin < G.MinRouteStep) then
    tMin = G.MinRouteStep
  end
  do return tMin end
end

-- dynwave.c:836
F.getLinkStep = function(tMin, minLink, minLink__k)
  local G_Nobjects, G_Link, G_Conduit = G.Nobjects, G.Link, G.Conduit
  local i = 0
  local k = 0
  local q = 0.0
  local t = 0.0
  local tLink = tMin
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        if (G_Link[i].type_ == CONDUIT) then
          k = G_Link[i].subIndex
          q = (m_abs(G_Link[i].newFlow) / (G_Conduit[k].barrels * 1.0))
          if (((q <= 0.0001) or (G_Conduit[k].a1 <= 0.0001)) or (G_Link[i].froude <= 0.01)) then
            goto continue1
          end
          t = ((G_Link[i].newVolume / (G_Conduit[k].barrels * 1.0)) / q)
          t = ((t * G_Conduit[k].modLength) / F.link_getLength(i))
          t = (((t * G_Link[i].froude) / ((1.0 + G_Link[i].froude))) * G.CourantFactor)
          if (t < tLink) then
            tLink = t
            minLink[minLink__k] = i
          end
        end
      end
      ::continue1::
      i = i + 1
    end
  end
  do return tLink end
end

-- dynwave.c:881
F.getNodeStep = function(tMin, minNode, minNode__k)
  local G_Nobjects, G_Node, G_Xnode = G.Nobjects, G.Node, G.Xnode
  local i = 0
  local maxDepth = 0.0
  local dYdT = 0.0
  local t1 = 0.0
  local tNode = tMin
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        if (G_Node[i].type_ == OUTFALL) then
          goto continue1
        end
        if (G_Node[i].newDepth <= 0.0001) then
          goto continue1
        end
        if ((G_Node[i].newDepth + 0.0001) >= (G_Node[i].crownElev - G_Node[i].invertElev)) then
          goto continue1
        end
        maxDepth = (((G_Node[i].crownElev - G_Node[i].invertElev)) * 0.25)
        if (maxDepth < 0.0001) then
          goto continue1
        end
        dYdT = G_Xnode[i].dYdT
        if (dYdT < 0.0001) then
          goto continue1
        end
        t1 = (maxDepth / dYdT)
        if (t1 < tNode) then
          tNode = t1
          minNode[minNode__k] = i
        end
      end
      ::continue1::
      i = i + 1
    end
  end
  do return tNode end
end

