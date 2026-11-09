-- Generated from EPA SWMM 5.2.4 (dwflow.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local SLOT <const> = 1
local DRY <const> = 0
local UP_DRY <const> = 1
local DN_DRY <const> = 2
local SUBCRITICAL <const> = 3
local SUPCRITICAL <const> = 4
local NO_DAMPING <const> = 0
local FULL_DAMPING <const> = 2
local FORCE_MAIN <const> = 24
local DW <const> = 4
local NEITHER <const> = 3
local OUTFALL <const> = 1
local UP_CRITICAL <const> = 5
local DN_CRITICAL <const> = 6
local SLOPE <const> = 0
local BOTH <const> = 2
local FROUDE <const> = 1
local _ENV = R.strict

G.MAXVELOCITY = 50.0

-- dwflow.c:57
F.dwflow_findConduitFlow = function(j, steps, omega, dt)
  local G_Link, G_Conduit, G_Node = G.Link, G.Conduit, G.Node
  local k = 0
  local n1 = 0
  local n2 = 0
  local z1 = 0.0
  local z2 = 0.0
  local h1 = {0.0}
  local h2 = {0.0}
  local y1 = {0.0}
  local y2 = {0.0}
  local a1 = 0.0
  local a2 = 0.0
  local r1 = 0.0
  local yMid = 0.0
  local rMid = 0.0
  local aMid = 0.0
  local aWtd = 0.0
  local rWtd = 0.0
  local qLast = 0.0
  local qOld = 0.0
  local aOld = 0.0
  local v = 0.0
  local rho = 0.0
  local sigma = 0.0
  local length = 0.0
  local wSlot = 0.0
  local dq1 = 0.0
  local dq2 = 0.0
  local dq3 = 0.0
  local dq4 = 0.0
  local dq5 = 0.0
  local dq6 = 0.0
  local denom = 0.0
  local q = 0.0
  local barrels = 0.0
  local xsect = G_Link[j].xsect
  local isFull = 0
  local isClosed = 0
  if (G_Link[j].setting == 0.0) then
    isClosed = 1
  end
  k = G_Link[j].subIndex
  barrels = (G_Conduit[k].barrels * 1.0)
  qOld = (G_Link[j].oldFlow / barrels)
  qLast = G_Conduit[k].q1
  G_Conduit[k].evapLossRate = 0.0
  G_Conduit[k].seepLossRate = 0.0
  n1 = G_Link[j].node1
  n2 = G_Link[j].node2
  z1 = (G_Node[n1].invertElev + G_Link[j].offset1)
  z2 = (G_Node[n2].invertElev + G_Link[j].offset2)
  h1[1] = (G_Node[n1].newDepth + G_Node[n1].invertElev)
  h2[1] = (G_Node[n2].newDepth + G_Node[n2].invertElev)
  h1[1] = (((((h1[1]) >= (z1))) and (h1[1]) or (z1)))
  h2[1] = (((((h2[1]) >= (z2))) and (h2[1]) or (z2)))
  y1[1] = (h1[1] - z1)
  y2[1] = (h2[1] - z2)
  y1[1] = (((((y1[1]) >= (0.0001))) and (y1[1]) or (0.0001)))
  y2[1] = (((((y2[1]) >= (0.0001))) and (y2[1]) or (0.0001)))
  if (G.SurchargeMethod ~= SLOT) then
    y1[1] = (((((y1[1]) <= (xsect.yFull))) and (y1[1]) or (xsect.yFull)))
    y2[1] = (((((y2[1]) <= (xsect.yFull))) and (y2[1]) or (xsect.yFull)))
  end
  aOld = G_Conduit[k].a2
  aOld = (((((aOld) >= (0.0001))) and (aOld) or (0.0001)))
  length = G_Conduit[k].modLength
  F.findSurfArea(j, qLast, length, h1, 1, h2, 1, y1, 1, y2, 1)
  wSlot = F.getSlotWidth(xsect, y1[1])
  a1 = F.dwflow_getArea(xsect, y1[1], wSlot)
  r1 = F.getHydRad(xsect, y1[1])
  wSlot = F.getSlotWidth(xsect, y2[1])
  a2 = F.dwflow_getArea(xsect, y2[1], wSlot)
  yMid = (0.5 * ((y1[1] + y2[1])))
  wSlot = F.getSlotWidth(xsect, yMid)
  aMid = F.dwflow_getArea(xsect, yMid, wSlot)
  rMid = F.getHydRad(xsect, yMid)
  if ((y1[1] >= xsect.yFull) and (y2[1] >= xsect.yFull)) then
    isFull = 1
  end
  if (((((G_Link[j].flowClass == DRY) or (G_Link[j].flowClass == UP_DRY)) or (G_Link[j].flowClass == DN_DRY)) or (isClosed ~= 0)) or (aMid <= 0.0001)) then
    G_Conduit[k].a1 = (0.5 * ((a1 + a2)))
    G_Conduit[k].q1 = 0.0
    G_Conduit[k].q2 = 0.0
    G_Link[j].dqdh = ((((32.2 * dt) * aMid) / length) * barrels)
    G_Link[j].froude = 0.0
    G_Link[j].newDepth = (((((yMid) <= (G_Link[j].xsect.yFull))) and (yMid) or (G_Link[j].xsect.yFull)))
    G_Link[j].newVolume = ((G_Conduit[k].a1 * F.link_getLength(j)) * barrels)
    G_Link[j].newFlow = 0.0
    do return end
  end
  v = (qLast / aMid)
  if (m_abs(v) > G.MAXVELOCITY) then
    v = (G.MAXVELOCITY * ((((((qLast) < 0.0)) and ((-1)) or (1))) * 1.0))
  end
  G_Link[j].froude = F.link_getFroude(j, v, yMid)
  if ((G_Link[j].flowClass == SUBCRITICAL) and (G_Link[j].froude > 1.0)) then
    G_Link[j].flowClass = SUPCRITICAL
  end
  if (G_Link[j].froude <= 0.5) then
    sigma = 1.0
  elseif (G_Link[j].froude >= 1.0) then
    sigma = 0.0
  else
    sigma = (2.0 * ((1.0 - G_Link[j].froude)))
  end
  rho = 1.0
  if (((not (isFull ~= 0)) and (qLast > 0.0)) and (h1[1] >= h2[1])) then
    rho = sigma
  end
  aWtd = (a1 + (((aMid - a1)) * rho))
  rWtd = (r1 + (((rMid - r1)) * rho))
  if (G.InertDamping == NO_DAMPING) then
    sigma = 1.0
  elseif (G.InertDamping == FULL_DAMPING) then
    sigma = 0.0
  end
  if ((isFull ~= 0) and (not (F.xsect_isOpen(xsect.type_) ~= 0))) then
    sigma = 0.0
  end
  if ((xsect.type_ == FORCE_MAIN) and (isFull ~= 0)) then
    dq1 = (dt * F.forcemain_getFricSlope(j, m_abs(v), rMid))
  else
    dq1 = (((dt * G_Conduit[k].roughFactor) / (rWtd ^ 1.33333)) * m_abs(v))
  end
  dq2 = ((((dt * 32.2) * aWtd) * ((h2[1] - h1[1]))) / length)
  dq3 = 0.0
  dq4 = 0.0
  if (sigma > 0.0) then
    dq3 = (((2.0 * v) * ((aMid - aOld))) * sigma)
    dq4 = (((((dt * v) * v) * ((a2 - a1))) / length) * sigma)
  end
  dq5 = 0.0
  if (G_Conduit[k].hasLosses ~= 0) then
    dq5 = (((F.findLocalLosses(j, a1, a2, aMid, qLast) / 2.0) / length) * dt)
  end
  dq6 = ((((F.link_getLossRate(j, DW, qLast, dt) * 2.5) * dt) * v) / F.link_getLength(j))
  denom = ((1.0 + dq1) + dq5)
  q = ((((((qOld - dq2) + dq3) + dq4) + dq6)) / denom)
  G_Link[j].dqdh = ((((((1.0 / denom) * 32.2) * dt) * aWtd) / length) * barrels)
  G_Link[j].inletControl = 0
  G_Link[j].normalFlow = 0
  if (q > 0.0) then
    if ((xsect.culvertCode > 0) and (not (isFull ~= 0))) then
      q = F.culvert_getInflow(j, q, h1[1])
    elseif (((G.NormalFlowLtd ~= NEITHER) and (y1[1] < G_Link[j].xsect.yFull)) and (((G_Link[j].flowClass == SUBCRITICAL) or (G_Link[j].flowClass == SUPCRITICAL)))) then
      q = F.checkNormalFlow(j, q, y1[1], y2[1], a1, r1)
    end
  end
  if (steps > 0) then
    q = ((((1.0 - omega)) * qLast) + (omega * q))
    if ((q * qLast) < 0.0) then
      q = (0.001 * ((((((q) < 0.0)) and ((-1)) or (1))) * 1.0))
    end
  end
  if (G_Link[j].qLimit > 0.0) then
    if (m_abs(q) > G_Link[j].qLimit) then
      q = (((((((q) < 0.0)) and ((-1)) or (1))) * 1.0) * G_Link[j].qLimit)
    end
  end
  if (F.link_setFlapGate(j, n1, n2, q) ~= 0) then
    q = 0.0
  end
  if ((q > 0.0001) and (G_Node[n1].newDepth <= 0.0001)) then
    q = 0.0001
  end
  if ((q < (-0.0001)) and (G_Node[n2].newDepth <= 0.0001)) then
    q = (-0.0001)
  end
  G_Conduit[k].a1 = aMid
  G_Conduit[k].q1 = q
  G_Conduit[k].q2 = q
  G_Link[j].newDepth = (((((yMid) <= (xsect.yFull))) and (yMid) or (xsect.yFull)))
  aMid = (((a1 + a2)) / 2.0)
  G_Conduit[k].fullState = F.link_getFullState(a1, a2, xsect.aFull)
  G_Link[j].newVolume = ((aMid * F.link_getLength(j)) * barrels)
  G_Link[j].newFlow = (q * barrels)
end

-- dwflow.c:297
F.getFlowClass = function(j, q, h1, h2, y1, y2, yC, yC__k, yN, yN__k, fasnh, fasnh__k)
  local G_Link, G_Node = G.Link, G.Node
  local n1 = 0
  local n2 = 0
  local flowClass = 0
  local ycMin = 0.0
  local ycMax = 0.0
  local z1 = 0.0
  local z2 = 0.0
  n1 = G_Link[j].node1
  n2 = G_Link[j].node2
  z1 = G_Link[j].offset1
  z2 = G_Link[j].offset2
  if (G_Node[n1].type_ == OUTFALL) then
    z1 = (((((0.0) >= (((z1 - G_Node[n1].newDepth))))) and (0.0) or (((z1 - G_Node[n1].newDepth)))))
  end
  if (G_Node[n2].type_ == OUTFALL) then
    z2 = (((((0.0) >= (((z2 - G_Node[n2].newDepth))))) and (0.0) or (((z2 - G_Node[n2].newDepth)))))
  end
  flowClass = SUBCRITICAL
  fasnh[fasnh__k] = 1.0
  if ((y1 > 0.0001) and (y2 > 0.0001)) then
    if (q < 0.0) then
      if (z1 > 0.0) then
        yN[yN__k] = F.link_getYnorm(j, m_abs(q))
        yC[yC__k] = F.link_getYcrit(j, m_abs(q))
        ycMin = (((((yN[yN__k]) <= (yC[yC__k]))) and (yN[yN__k]) or (yC[yC__k])))
        if (y1 < ycMin) then
          flowClass = UP_CRITICAL
        end
      end
    else
      if (z2 > 0.0) then
        yN[yN__k] = F.link_getYnorm(j, m_abs(q))
        yC[yC__k] = F.link_getYcrit(j, m_abs(q))
        ycMin = (((((yN[yN__k]) <= (yC[yC__k]))) and (yN[yN__k]) or (yC[yC__k])))
        ycMax = (((((yN[yN__k]) >= (yC[yC__k]))) and (yN[yN__k]) or (yC[yC__k])))
        if (y2 < ycMin) then
          flowClass = DN_CRITICAL
        elseif (y2 < ycMax) then
          if ((ycMax - ycMin) < 0.0001) then
            fasnh[fasnh__k] = 0.0
          else
            fasnh[fasnh__k] = (((ycMax - y2)) / ((ycMax - ycMin)))
          end
        end
      end
    end
  elseif ((y1 <= 0.0001) and (y2 <= 0.0001)) then
    flowClass = DRY
  elseif (y2 > 0.0001) then
    if (h2 < (G_Node[n1].invertElev + G_Link[j].offset1)) then
      flowClass = UP_DRY
    elseif (z1 > 0.0) then
      yN[yN__k] = F.link_getYnorm(j, m_abs(q))
      yC[yC__k] = F.link_getYcrit(j, m_abs(q))
      flowClass = UP_CRITICAL
    end
  else
    if (h1 < (G_Node[n2].invertElev + G_Link[j].offset2)) then
      flowClass = DN_DRY
    elseif (z2 > 0.0) then
      yN[yN__k] = F.link_getYnorm(j, m_abs(q))
      yC[yC__k] = F.link_getYcrit(j, m_abs(q))
      flowClass = DN_CRITICAL
    end
  end
  do return flowClass end
end

-- dwflow.c:417
F.findSurfArea = function(j, q, length, h1, h1__k, h2, h2__k, y1, y1__k, y2, y2__k)
  local G_Link, G_Node = G.Link, G.Node
  local n1 = 0
  local n2 = 0
  local flowDepth1 = 0.0
  local flowDepth2 = 0.0
  local flowDepthMid = 0.0
  local width1 = 0.0
  local width2 = 0.0
  local widthMid = 0.0
  local surfArea1 = 0.0
  local surfArea2 = 0.0
  local criticalDepth = {0.0}
  local normalDepth = {0.0}
  local fullDepth = 0.0
  local fasnh = {1.0}
  local xsect = G_Link[j].xsect
  n1 = G_Link[j].node1
  n2 = G_Link[j].node2
  flowDepth1 = y1[y1__k]
  flowDepth2 = y2[y2__k]
  normalDepth[1] = (((flowDepth1 + flowDepth2)) / 2.0)
  criticalDepth[1] = normalDepth[1]
  fullDepth = xsect.yFull
  if ((flowDepth1 >= fullDepth) and (flowDepth2 >= fullDepth)) then
    G_Link[j].flowClass = SUBCRITICAL
  else
    G_Link[j].flowClass = F.getFlowClass(j, q, h1[h1__k], h2[h2__k], y1[y1__k], y2[y2__k], criticalDepth, 1, normalDepth, 1, fasnh, 1)
  end
  do
    local __sw1 = G_Link[j].flowClass
    if __sw1 < SUBCRITICAL then
      if __sw1 == DRY then goto case7
      elseif __sw1 == UP_DRY then goto case5
      elseif __sw1 == DN_DRY then goto case6
      end
    else
      if __sw1 == SUBCRITICAL then goto case2
      elseif __sw1 == UP_CRITICAL then goto case3
      elseif __sw1 == DN_CRITICAL then goto case4
      end
    end
    goto swend1
    ::case2::
    do
      flowDepthMid = (0.5 * ((flowDepth1 + flowDepth2)))
      if (flowDepthMid < 0.0001) then
        flowDepthMid = 0.0001
      end
      width1 = F.dwflow_getWidth(xsect, flowDepth1)
      width2 = F.dwflow_getWidth(xsect, flowDepth2)
      widthMid = F.dwflow_getWidth(xsect, flowDepthMid)
      surfArea1 = ((((width1 + widthMid)) * length) / 4.0)
      surfArea2 = (((((widthMid + width2)) * length) / 4.0) * fasnh[1])
      goto swend1
    end
    ::case3::
    do
      flowDepth1 = criticalDepth[1]
      if (normalDepth[1] < criticalDepth[1]) then
        flowDepth1 = normalDepth[1]
      end
      flowDepth1 = (((((flowDepth1) >= (0.0001))) and (flowDepth1) or (0.0001)))
      h1[h1__k] = ((G_Node[n1].invertElev + G_Link[j].offset1) + flowDepth1)
      flowDepthMid = (0.5 * ((flowDepth1 + flowDepth2)))
      if (flowDepthMid < 0.0001) then
        flowDepthMid = 0.0001
      end
      width2 = F.dwflow_getWidth(xsect, flowDepth2)
      widthMid = F.dwflow_getWidth(xsect, flowDepthMid)
      surfArea2 = ((((widthMid + width2)) * length) * 0.5)
      goto swend1
    end
    ::case4::
    do
      flowDepth2 = criticalDepth[1]
      if (normalDepth[1] < criticalDepth[1]) then
        flowDepth2 = normalDepth[1]
      end
      flowDepth2 = (((((flowDepth2) >= (0.0001))) and (flowDepth2) or (0.0001)))
      h2[h2__k] = ((G_Node[n2].invertElev + G_Link[j].offset2) + flowDepth2)
      width1 = F.dwflow_getWidth(xsect, flowDepth1)
      flowDepthMid = (0.5 * ((flowDepth1 + flowDepth2)))
      if (flowDepthMid < 0.0001) then
        flowDepthMid = 0.0001
      end
      widthMid = F.dwflow_getWidth(xsect, flowDepthMid)
      surfArea1 = ((((width1 + widthMid)) * length) * 0.5)
      goto swend1
    end
    ::case5::
    do
      flowDepth1 = 0.0001
      flowDepthMid = (0.5 * ((flowDepth1 + flowDepth2)))
      if (flowDepthMid < 0.0001) then
        flowDepthMid = 0.0001
      end
      width1 = F.dwflow_getWidth(xsect, flowDepth1)
      width2 = F.dwflow_getWidth(xsect, flowDepth2)
      widthMid = F.dwflow_getWidth(xsect, flowDepthMid)
      surfArea2 = ((((widthMid + width2)) * length) / 4.0)
      if (G_Link[j].offset1 <= 0.0) then
        surfArea1 = ((((width1 + widthMid)) * length) / 4.0)
      end
      goto swend1
    end
    ::case6::
    do
      flowDepth2 = 0.0001
      flowDepthMid = (0.5 * ((flowDepth1 + flowDepth2)))
      if (flowDepthMid < 0.0001) then
        flowDepthMid = 0.0001
      end
      width1 = F.dwflow_getWidth(xsect, flowDepth1)
      width2 = F.dwflow_getWidth(xsect, flowDepth2)
      widthMid = F.dwflow_getWidth(xsect, flowDepthMid)
      surfArea1 = ((((widthMid + width1)) * length) / 4.0)
      if (G_Link[j].offset2 <= 0.0) then
        surfArea2 = ((((width2 + widthMid)) * length) / 4.0)
      end
      goto swend1
    end
    ::case7::
    do
      surfArea1 = ((0.0001 * length) / 2.0)
      surfArea2 = surfArea1
      goto swend1
    end
    ::swend1::
  end
  G_Link[j].surfArea1 = surfArea1
  G_Link[j].surfArea2 = surfArea2
  y1[y1__k] = flowDepth1
  y2[y2__k] = flowDepth2
end

-- dwflow.c:554
F.findLocalLosses = function(j, a1, a2, aMid, q)
  local G_Link = G.Link
  local losses = 0.0
  q = m_abs(q)
  if (a1 > 0.0001) then
    losses = (losses + (G_Link[j].cLossInlet * ((q / a1))))
  end
  if (a2 > 0.0001) then
    losses = (losses + (G_Link[j].cLossOutlet * ((q / a2))))
  end
  if (aMid > 0.0001) then
    losses = (losses + (G_Link[j].cLossAvg * ((q / aMid))))
  end
  do return losses end
end

-- dwflow.c:575
F.getSlotWidth = function(xsect, y)
  local yNorm = (y / xsect.yFull)
  if (((G.SurchargeMethod ~= SLOT) or (F.xsect_isOpen(xsect.type_) ~= 0)) or (yNorm < G.CrownCutoff)) then
    do return 0.0 end
  end
  if (yNorm > 1.78) then
    do return (0.01 * xsect.wMax) end
  end
  do return ((xsect.wMax * 0.5423) * m_exp((-(yNorm ^ 2.4)))) end
end

-- dwflow.c:592
F.dwflow_getWidth = function(xsect, y)
  local wSlot = F.getSlotWidth(xsect, y)
  if (wSlot > 0.0) then
    do return wSlot end
  end
  if (((y / xsect.yFull) >= G.CrownCutoff) and (not (F.xsect_isOpen(xsect.type_) ~= 0))) then
    y = (G.CrownCutoff * xsect.yFull)
  end
  do return F.xsect_getWofY(xsect, y) end
end

-- dwflow.c:609
F.dwflow_getArea = function(xsect, y, wSlot)
  if (y >= xsect.yFull) then
    do return (xsect.aFull + (((y - xsect.yFull)) * wSlot)) end
  end
  do return F.xsect_getAofY(xsect, y) end
end

-- dwflow.c:623
F.getHydRad = function(xsect, y)
  if (y >= xsect.yFull) then
    do return xsect.rFull end
  end
  do return F.xsect_getRofY(xsect, y) end
end

-- dwflow.c:637
F.checkNormalFlow = function(j, q, y1, y2, a1, r1)
  local G_Link, G_Node = G.Link, G.Node
  local check = 0
  local k = G_Link[j].subIndex
  local n1 = G_Link[j].node1
  local n2 = G_Link[j].node2
  local hasOutfall = ((((G_Node[n1].type_ == OUTFALL) or (G_Node[n2].type_ == OUTFALL))) and 1 or 0)
  local qNorm = 0.0
  local f1 = 0.0
  if (((G.NormalFlowLtd == SLOPE) or (G.NormalFlowLtd == BOTH)) or (hasOutfall ~= 0)) then
    if (y1 < y2) then
      check = 1
    end
  end
  if (((not (check ~= 0)) and (((G.NormalFlowLtd == FROUDE) or (G.NormalFlowLtd == BOTH)))) and (not (hasOutfall ~= 0))) then
    if ((y1 > 0.0001) and (y2 > 0.0001)) then
      f1 = F.link_getFroude(j, (q / a1), y1)
      if (f1 >= 1.0) then
        check = 1
      end
    end
  end
  if (check ~= 0) then
    qNorm = ((G.Conduit[k].beta * a1) * (r1 ^ (2.0 / 3.0)))
    if (qNorm < q) then
      G_Link[j].normalFlow = 1
      do return qNorm end
    end
  end
  do return q end
end

