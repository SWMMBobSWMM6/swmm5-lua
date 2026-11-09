-- Generated from EPA SWMM 5.2.4 (flowrout.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local DW <const> = 4
local NO_FILE <const> = 0
local NODE <const> = 2
local STORAGE <const> = 2
local LINK <const> = 3
local SF <const> = 1
local DIVIDER <const> = 3
local OUTFALL <const> = 1
local ERR_DIVIDER <const> = 135
local ERR_OUTFALL <const> = 141
local ERR_MULTI_OUTLET <const> = 133
local CONDUIT <const> = 0
local ORIFICE <const> = 2
local WEIR <const> = 3
local OUTLET <const> = 4
local DUMMY <const> = 0
local ERR_SLOPE <const> = 115
local ERR_REGULATOR <const> = 139
local PUMP <const> = 1
local IDEAL_PUMP <const> = 5
local ERR_DUMMY_LINK <const> = 134
local ERR_NO_OUTLETS <const> = 145
local ALL_FULL <const> = 10
local _ENV = R.strict

G.flowrout_OMEGA = 0.55
G.MAXITER = 10
G.STOPTOL = 0.005

-- flowrout.c:75
F.flowrout_init = function(routingModel)
  if (routingModel == DW) then
    F.validateGeneralLayout()
    F.dynwave_init()
    if (G.Fhotstart1.mode == NO_FILE) then
      F.initNodeDepths()
      F.initLinkDepths()
    end
  else
    F.validateTreeLayout()
  end
  F.initNodes()
  F.initLinks(routingModel)
end

-- flowrout.c:107
F.flowrout_close = function(routingModel)
  if (routingModel == DW) then
    F.dynwave_close()
  end
end

-- flowrout.c:119
F.flowrout_getRoutingStep = function(routingModel, fixedStep)
  if (routingModel == DW) then
    do return F.dynwave_getRoutingStep(fixedStep) end
  end
  do return fixedStep end
end

-- flowrout.c:136
F.flowrout_execute = function(links, routingModel, tStep)
  local G_Nobjects, G_Node, G_Link = G.Nobjects, G.Node, G.Link
  local i = 0
  local j = 0
  local n1 = 0
  local qin = {0.0}
  local qout = {0.0}
  local steps = 0.0
  if (G.ErrorCode ~= 0) then
    do return 0 end
  end
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        G_Node[j].updated = 0
        G_Node[j].overflow = 0.0
        if ((G_Node[j].type_ ~= STORAGE) and (G_Node[j].newVolume > G_Node[j].fullVolume)) then
          G_Node[j].overflow = (((G_Node[j].newVolume - G_Node[j].fullVolume)) / tStep)
        end
      end
      j = j + 1
    end
  end
  if (routingModel == DW) then
    do return F.dynwave_execute(tStep) end
  end
  steps = 0.0
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        j = links[i]
        n1 = G_Link[j].node1
        if (G_Node[n1].type_ == STORAGE) then
          F.updateStorageState(n1, i, links, tStep)
        end
        qin[1] = F.getLinkInflow(j, tStep)
        if (routingModel == SF) then
          steps = (steps + (F.steadyflow_execute(j, qin, 1, qout, 1, tStep) * 1.0))
        else
          steps = (steps + (F.kinwave_execute(j, qin, 1, qout, 1, tStep) * 1.0))
        end
        G_Link[j].newFlow = qout[1]
        G_Node[G_Link[j].node1].outflow = (G_Node[G_Link[j].node1].outflow + qin[1])
        G_Node[G_Link[j].node2].inflow = (G_Node[G_Link[j].node2].inflow + qout[1])
      end
      i = i + 1
    end
  end
  if (G_Nobjects[LINK] > 0) then
    steps = (steps / (G_Nobjects[LINK] * 1.0))
  end
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        F.setNewNodeState(j, tStep)
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        F.setNewLinkState(j)
      end
      j = j + 1
    end
  end
  do return R.D2I(((steps + 0.5))) end
end

-- flowrout.c:203
F.validateTreeLayout = function()
  local G_Nobjects, G_Node, G_Link, G_Conduit = G.Nobjects, G.Node, G.Link, G.Conduit
  local j = 0
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        do
          local __sw1 = G_Node[j].type_
          if __sw1 == DIVIDER then goto case3
          elseif __sw1 == OUTFALL then goto case4
          elseif __sw1 == STORAGE then goto case5
          else goto case6 end
          ::case3::
          do
            if (G_Node[j].degree > 2) then
              F.report_writeErrorMsg(ERR_DIVIDER, G_Node[j].ID)
            end
            goto swend2
          end
          ::case4::
          do
            if (G_Node[j].degree > 0) then
              F.report_writeErrorMsg(ERR_OUTFALL, G_Node[j].ID)
            end
            goto swend2
          end
          ::case5::
          do
            goto swend2
          end
          ::case6::
          do
            if (G_Node[j].degree > 1) then
              F.report_writeErrorMsg(ERR_MULTI_OUTLET, G_Node[j].ID)
            end
          end
          ::swend2::
        end
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        do
          local __sw2 = G_Link[j].type_
          if __sw2 == CONDUIT then goto case9
          elseif __sw2 == ORIFICE or __sw2 == WEIR or __sw2 == OUTLET then goto case10
          else goto swend8 end
          ::case9::
          do
            if ((G_Conduit[G_Link[j].subIndex].slope < 0.0) and (G_Link[j].xsect.type_ ~= DUMMY)) then
              F.report_writeErrorMsg(ERR_SLOPE, G_Link[j].ID)
            end
            goto swend8
          end
          ::case10::
          do
            if (G_Node[G_Link[j].node1].type_ ~= STORAGE) then
              F.report_writeErrorMsg(ERR_REGULATOR, G_Link[j].ID)
            end
          end
          ::swend8::
        end
      end
      j = j + 1
    end
  end
end

-- flowrout.c:274
F.validateGeneralLayout = function()
  local G_Nobjects, G_Node, G_Link, G_Pump = G.Nobjects, G.Node, G.Link, G.Pump
  local i = 0
  local j = 0
  local outletCount = 0
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        G_Node[i].inflow = 0.0
      end
      i = i + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        i = G_Link[j].node1
        if (G_Node[i].type_ ~= OUTFALL) then
          i = G_Link[j].node2
        end
        G_Node[i].inflow = (G_Node[i].inflow + 1.0)
        if ((((G_Link[j].type_ == CONDUIT) and (G_Link[j].xsect.type_ == DUMMY))) or (((G_Link[j].type_ == PUMP) and (G_Pump[G_Link[j].subIndex].type_ == IDEAL_PUMP)))) then
          i = G_Link[j].node1
          if (G_Link[j].direction < 0) then
            i = G_Link[j].node2
          end
          if (G_Node[i].degree > 1) then
            F.report_writeErrorMsg(ERR_DUMMY_LINK, G_Node[i].ID)
          end
        end
      end
      j = j + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        if (G_Node[i].type_ == OUTFALL) then
          if ((G_Node[i].degree + R.D2I(G_Node[i].inflow)) > 1) then
            F.report_writeErrorMsg(ERR_OUTFALL, G_Node[i].ID)
          else
            outletCount = outletCount + 1
          end
        end
      end
      i = i + 1
    end
  end
  if (outletCount == 0) then
    F.report_writeErrorMsg(ERR_NO_OUTLETS, S[0])
  end
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        if (G_Node[i].inflow == 0.0) then
          G_Node[i].degree = (-G_Node[i].degree)
        end
        G_Node[i].inflow = 0.0
      end
      i = i + 1
    end
  end
end

-- flowrout.c:337
F.initNodeDepths = function()
  local G_Nobjects, G_Node, G_Link = G.Nobjects, G.Node, G.Link
  local i = 0
  local n = 0
  local y = 0.0
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        G_Node[i].inflow = 0.0
        G_Node[i].outflow = 0.0
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        if (G_Link[i].newDepth > 0.0001) then
          y = (G_Link[i].newDepth + G_Link[i].offset1)
        else
          y = 0.0
        end
        n = G_Link[i].node1
        G_Node[n].inflow = (G_Node[n].inflow + y)
        G_Node[n].outflow = (G_Node[n].outflow + 1.0)
        n = G_Link[i].node2
        G_Node[n].inflow = (G_Node[n].inflow + y)
        G_Node[n].outflow = (G_Node[n].outflow + 1.0)
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        if (G_Node[i].type_ == OUTFALL) then
          goto continue3
        end
        if (G_Node[i].type_ == STORAGE) then
          goto continue3
        end
        if (G_Node[i].initDepth > 0.0) then
          goto continue3
        end
        if (G_Node[i].outflow > 0.0) then
          G_Node[i].newDepth = (G_Node[i].inflow / G_Node[i].outflow)
        end
      end
      ::continue3::
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        F.link_setOutfallDepth(i)
      end
      i = i + 1
    end
  end
end

-- flowrout.c:389
F.initLinkDepths = function()
  local G_Nobjects, G_Link, G_Node = G.Nobjects, G.Link, G.Node
  local i = 0
  local y = 0.0
  local y1 = 0.0
  local y2 = 0.0
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        if (G_Link[i].type_ == CONDUIT) then
          if (G_Link[i].q0 ~= 0.0) then
            goto continue1
          end
          y1 = (G_Node[G_Link[i].node1].newDepth - G_Link[i].offset1)
          y1 = (((((y1) >= (0.0))) and (y1) or (0.0)))
          y1 = (((((y1) <= (G_Link[i].xsect.yFull))) and (y1) or (G_Link[i].xsect.yFull)))
          y2 = (G_Node[G_Link[i].node2].newDepth - G_Link[i].offset2)
          y2 = (((((y2) >= (0.0))) and (y2) or (0.0)))
          y2 = (((((y2) <= (G_Link[i].xsect.yFull))) and (y2) or (G_Link[i].xsect.yFull)))
          y = (0.5 * ((y1 + y2)))
          y = (((((y) >= (0.0001))) and (y) or (0.0001)))
          G_Link[i].newDepth = y
        end
      end
      ::continue1::
      i = i + 1
    end
  end
end

-- flowrout.c:425
F.initNodes = function()
  local G_Nobjects, G_Node, G_Link = G.Nobjects, G.Node, G.Link
  local i = 0
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        G_Node[i].inflow = G_Node[i].newLatFlow
        G_Node[i].outflow = 0.0
        G_Node[i].newVolume = 0.0
        if (((G.AllowPonding ~= 0) and (G_Node[i].pondedArea > 0.0)) and (G_Node[i].newDepth > G_Node[i].fullDepth)) then
          G_Node[i].newVolume = (G_Node[i].fullVolume + (((G_Node[i].newDepth - G_Node[i].fullDepth)) * G_Node[i].pondedArea))
        else
          G_Node[i].newVolume = F.node_getVolume(i, G_Node[i].newDepth)
        end
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        if (G_Link[i].newFlow >= 0.0) then
          G_Node[G_Link[i].node1].outflow = (G_Node[G_Link[i].node1].outflow + G_Link[i].newFlow)
          G_Node[G_Link[i].node2].inflow = (G_Node[G_Link[i].node2].inflow + G_Link[i].newFlow)
        else
          G_Node[G_Link[i].node1].inflow = (G_Node[G_Link[i].node1].inflow - G_Link[i].newFlow)
          G_Node[G_Link[i].node2].outflow = (G_Node[G_Link[i].node2].outflow - G_Link[i].newFlow)
        end
      end
      i = i + 1
    end
  end
end

-- flowrout.c:472
F.initLinks = function(routingModel)
  local G_Nobjects, G_Link, G_Conduit = G.Nobjects, G.Link, G.Conduit
  local i = 0
  local k = 0
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        if (routingModel == SF) then
          G_Link[i].newFlow = 0.0
        elseif (G_Link[i].type_ == CONDUIT) then
          k = G_Link[i].subIndex
          G_Conduit[k].q1 = (G_Link[i].newFlow / (G_Conduit[k].barrels * 1.0))
          G_Conduit[k].q2 = G_Conduit[k].q1
          G_Conduit[k].a1 = F.xsect_getAofY(G_Link[i].xsect, G_Link[i].newDepth)
          G_Conduit[k].a2 = G_Conduit[k].a1
          do
            G_Link[i].newVolume = ((G_Conduit[k].a1 * F.link_getLength(i)) * (G_Conduit[k].barrels * 1.0))
          end
          G_Link[i].oldVolume = G_Link[i].newVolume
        end
      end
      i = i + 1
    end
  end
end

-- flowrout.c:511
F.getLinkInflow = function(j, dt)
  local G_Link = G.Link
  local n1 = G_Link[j].node1
  local q = 0.0
  if (((G_Link[j].type_ == CONDUIT) or (G_Link[j].type_ == PUMP)) or (G.Node[n1].type_ == STORAGE)) then
    q = F.link_getInflow(j)
  else
    q = 0.0
  end
  do return F.node_getMaxOutflow(n1, q, dt) end
end

-- flowrout.c:531
F.updateStorageState = function(i, j, links, dt)
  local G_Node = G.Node
  local iter = 0
  local stopped = 0
  local vFixed = 0.0
  local v2 = 0.0
  local d1 = 0.0
  local d2 = 0.0
  if (G_Node[i].type_ ~= STORAGE) then
    do return end
  end
  if (G_Node[i].updated ~= 0) then
    do return end
  end
  vFixed = (G_Node[i].oldVolume + ((0.5 * (((G_Node[i].oldNetInflow + G_Node[i].inflow) - G_Node[i].outflow))) * dt))
  d1 = G_Node[i].newDepth
  iter = 1
  stopped = 0
  while ((iter < G.MAXITER) and (not (stopped ~= 0))) do
    do
      v2 = (vFixed - ((0.5 * F.getStorageOutflow(i, j, links, dt)) * dt))
      v2 = (((((0.0) >= (v2))) and (0.0) or (v2)))
      G_Node[i].overflow = 0.0
      if (v2 > G_Node[i].fullVolume) then
        G_Node[i].overflow = (((v2 - (((((G_Node[i].oldVolume) >= (G_Node[i].fullVolume))) and (G_Node[i].oldVolume) or (G_Node[i].fullVolume))))) / dt)
        if (G_Node[i].overflow < 0.0001) then
          G_Node[i].overflow = 0.0
        end
        if ((not (G.AllowPonding ~= 0)) or (G_Node[i].pondedArea == 0.0)) then
          v2 = G_Node[i].fullVolume
        end
      end
      G_Node[i].newVolume = v2
      d2 = F.node_getDepth(i, v2)
      G_Node[i].newDepth = d2
      d2 = ((((1.0 - G.flowrout_OMEGA)) * d1) + (G.flowrout_OMEGA * d2))
      if (m_abs((d2 - d1)) <= G.STOPTOL) then
        stopped = 1
      end
      d1 = d2
      iter = iter + 1
    end
  end
  G_Node[i].updated = 1
end

-- flowrout.c:605
F.getStorageOutflow = function(i, j, links, dt)
  local G_Nobjects, G_Link = G.Nobjects, G.Link
  local k = 0
  local m = 0
  local outflow = 0.0
  do
    k = j
    while (k < G_Nobjects[LINK]) do
      do
        m = links[k]
        if (G_Link[m].node1 ~= i) then
          break
        end
        outflow = (outflow + (F.getLinkInflow(m, dt)))
      end
      k = k + 1
    end
  end
  do return outflow end
end

-- flowrout.c:629
F.setNewNodeState = function(j, dt)
  local G_Node = G.Node
  local canPond = 0
  local newNetInflow = 0.0
  if (G_Node[j].type_ == STORAGE) then
    if (G_Node[j].updated == 0) then
      F.updateStorageState(j, G.Nobjects[LINK], (nil), dt)
    end
    do return end
  end
  newNetInflow = ((G_Node[j].inflow - G_Node[j].outflow) - G_Node[j].losses)
  G_Node[j].newVolume = (G_Node[j].oldVolume + (newNetInflow * dt))
  if (G_Node[j].newVolume < 0.0001) then
    G_Node[j].newVolume = 0.0
  end
  G_Node[j].overflow = 0.0
  canPond = ((((G.AllowPonding ~= 0) and (G_Node[j].pondedArea > 0.0))) and 1 or 0)
  if (G_Node[j].newVolume > G_Node[j].fullVolume) then
    G_Node[j].overflow = (((G_Node[j].newVolume - (((((G_Node[j].oldVolume) >= (G_Node[j].fullVolume))) and (G_Node[j].oldVolume) or (G_Node[j].fullVolume))))) / dt)
    if (G_Node[j].overflow < 0.0001) then
      G_Node[j].overflow = 0.0
    end
    if (not (canPond ~= 0)) then
      G_Node[j].newVolume = G_Node[j].fullVolume
    end
  end
  G_Node[j].newDepth = F.node_getDepth(j, G_Node[j].newVolume)
end

-- flowrout.c:673
F.setNewLinkState = function(j)
  local G_Link, G_Conduit = G.Link, G.Conduit
  local k = 0
  local a = 0.0
  local y1 = 0.0
  local y2 = 0.0
  G_Link[j].newDepth = 0.0
  G_Link[j].newVolume = 0.0
  if (G_Link[j].type_ == CONDUIT) then
    k = G_Link[j].subIndex
    a = (0.5 * ((G_Conduit[k].a1 + G_Conduit[k].a2)))
    G_Link[j].newVolume = ((a * F.link_getLength(j)) * (G_Conduit[k].barrels * 1.0))
    y1 = F.xsect_getYofA(G_Link[j].xsect, G_Conduit[k].a1)
    y2 = F.xsect_getYofA(G_Link[j].xsect, G_Conduit[k].a2)
    G_Link[j].newDepth = (0.5 * ((y1 + y2)))
    F.updateNodeDepth(G_Link[j].node1, (y1 + G_Link[j].offset1))
    F.updateNodeDepth(G_Link[j].node2, (y2 + G_Link[j].offset2))
    if (G_Conduit[k].a1 >= G_Link[j].xsect.aFull) then
      G_Conduit[k].capacityLimited = 1
      G_Conduit[k].fullState = ALL_FULL
    else
      G_Conduit[k].capacityLimited = 0
      G_Conduit[k].fullState = 0
    end
  end
end

-- flowrout.c:717
F.updateNodeDepth = function(i, y)
  local G_Node = G.Node
  if (G_Node[i].type_ == STORAGE) then
    do return end
  end
  if (((G_Node[i].type_ ~= OUTFALL) and (G_Node[i].degree > 0)) and (G_Node[i].overflow > 0.0)) then
    y = G_Node[i].fullDepth
  end
  if (G_Node[i].newDepth < y) then
    G_Node[i].newDepth = y
    if ((G_Node[i].fullDepth > 0.0) and (y > G_Node[i].fullDepth)) then
      G_Node[i].newDepth = G_Node[i].fullDepth
    end
  end
end

-- flowrout.c:748
F.steadyflow_execute = function(j, qin, qin__k, qout, qout__k, tStep)
  local G_Link, G_Conduit = G.Link, G.Conduit
  local k = 0
  local s = 0.0
  local q = 0.0
  if (G_Link[j].type_ == CONDUIT) then
    k = G_Link[j].subIndex
    q = ((qin[qin__k]) / (G_Conduit[k].barrels * 1.0))
    if (G_Link[j].xsect.type_ == DUMMY) then
      G_Conduit[k].a1 = 0.0
    else
      q = (q - (F.link_getLossRate(j, SF, q, tStep)))
      if (q > G_Link[j].qFull) then
        q = G_Link[j].qFull
        G_Conduit[k].a1 = G_Link[j].xsect.aFull
        qin[qin__k] = (q * (G_Conduit[k].barrels * 1.0))
      else
        s = (q / G_Conduit[k].beta)
        G_Conduit[k].a1 = F.xsect_getAofS(G_Link[j].xsect, s)
      end
    end
    G_Conduit[k].a2 = G_Conduit[k].a1
    G_Conduit[k].q1Old = G_Conduit[k].q1
    G_Conduit[k].q2Old = G_Conduit[k].q2
    G_Conduit[k].q1 = q
    G_Conduit[k].q2 = q
    qout[qout__k] = (q * (G_Conduit[k].barrels * 1.0))
  else
    qout[qout__k] = (qin[qin__k])
  end
  do return 1 end
end

