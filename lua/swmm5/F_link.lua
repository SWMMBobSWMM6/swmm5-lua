-- Generated from EPA SWMM 5.2.4 (link.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local CONDUIT <const> = 0
local PUMP <const> = 1
local ORIFICE <const> = 2
local WEIR <const> = 3
local OUTLET <const> = 4
local ERR_ITEMS <const> = 203
local LINK <const> = 3
local ERR_NAME <const> = 209
local ERR_KEYWORD <const> = 205
local IRREGULAR <const> = 22
local TRANSECT <const> = 10
local STREET_XSECT <const> = 25
local STREET <const> = 16
local CUSTOM <const> = 23
local ERR_NUMBER <const> = 211
local CURVE <const> = 7
local LENGTH <const> = 3
local RECT_OPEN <const> = 4
local RAINFALL <const> = 0
local FLOW <const> = 10
local DUMMY <const> = 0
local ELEV_OFFSET <const> = 1
local DW <const> = 4
local BOTTOM_ORIFICE <const> = 1
local STORAGE <const> = 2
local POLLUT <const> = 4
local OUTFALL <const> = 1
local VOLUME <const> = 5
local LINK_DEPTH <const> = 1
local LINK_FLOW <const> = 0
local LINK_VELOCITY <const> = 2
local LINK_VOLUME <const> = 3
local LINK_CAPACITY <const> = 4
local LINK_QUAL <const> = 5
local ALL_FULL <const> = 10
local UP_FULL <const> = 8
local DN_FULL <const> = 9
local NODE <const> = 2
local ERR_DUMMY_LINK <const> = 134
local FORCE_MAIN <const> = 24
local D_W <const> = 1
local RAINDEPTH <const> = 1
local ERR_XSECT <const> = 119
local ERR_LENGTH <const> = 111
local ERR_ROUGHNESS <const> = 113
local ERR_BARRELS <const> = 114
local ERR_NO_XSECT <const> = 117
local FILLED_CIRCULAR <const> = 2
local SF <const> = 1
local KW <const> = 2
local RECT_CLOSED <const> = 3
local IDEAL_PUMP <const> = 5
local PUMP1_CURVE <const> = 7
local PUMP5_CURVE <const> = 11
local ERR_NO_CURVE <const> = 121
local ERR_PUMP_LIMITS <const> = 122
local TYPE1_PUMP <const> = 0
local NO <const> = 0
local PUMP2_CURVE <const> = 8
local PUMP3_CURVE <const> = 9
local PUMP4_CURVE <const> = 10
local YES <const> = 1
local DN_DRY <const> = 2
local UP_DRY <const> = 1
local CIRCULAR <const> = 1
local ERR_REGULATOR_SHAPE <const> = 143
local DRY <const> = 0
local SUBCRITICAL <const> = 3
local DN_CRITICAL <const> = 6
local UP_CRITICAL <const> = 5
local SIDE_ORIFICE <const> = 0
local ROADWAY_WEIR <const> = 4
local TRANSVERSE_WEIR <const> = 0
local SIDEFLOW_WEIR <const> = 1
local VNOTCH_WEIR <const> = 2
local TRAPEZOIDAL_WEIR <const> = 3
local TRIANGULAR <const> = 6
local TRAPEZOIDAL <const> = 5
local SI <const> = 1
local DEPTH_OFFSET <const> = 0
local NODE_DEPTH <const> = 0
local NODE_HEAD <const> = 1
local FUNCTIONAL <const> = 1
local _ENV = R.strict

G.MIN_DELTA_Z = 0.001

-- link.c:137
F.link_readParams = function(j, type_, k, tok, ntoks)
  do
    local __sw1 = type_
    if __sw1 == CONDUIT then goto case2
    elseif __sw1 == PUMP then goto case3
    elseif __sw1 == ORIFICE then goto case4
    elseif __sw1 == WEIR then goto case5
    elseif __sw1 == OUTLET then goto case6
    else goto case7 end
    ::case2::
    do
      do return F.conduit_readParams(j, k, tok, ntoks) end
    end
    ::case3::
    do
      do return F.pump_readParams(j, k, tok, ntoks) end
    end
    ::case4::
    do
      do return F.orifice_readParams(j, k, tok, ntoks) end
    end
    ::case5::
    do
      do return F.weir_readParams(j, k, tok, ntoks) end
    end
    ::case6::
    do
      do return F.outlet_readParams(j, k, tok, ntoks) end
    end
    ::case7::
    do
      do return 0 end
    end
    ::swend1::
  end
end

-- link.c:162
F.link_readXsectParams = function(tok, ntoks)
  local G_Link, G_Conduit = G.Link, G.Conduit
  local i = 0
  local j = 0
  local k = 0
  local x = R.fill(4, 0.0)
  if (ntoks < 3) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  j = F.project_findObject(LINK, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  k = F.findmatch(tok[1], G.XsectTypeWords)
  if (k < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
  end
  if (G_Link[j].type_ == CONDUIT) then
    G_Conduit[G_Link[j].subIndex].barrels = 1
  end
  G_Link[j].xsect.culvertCode = 0
  if (k == IRREGULAR) then
    i = F.project_findObject(TRANSECT, tok[2])
    if (i < 0) then
      do return F.error_setInpError(ERR_NAME, tok[2]) end
    end
    G_Link[j].xsect.type_ = k
    G_Link[j].xsect.transect = i
    do return 0 end
  elseif (k == STREET_XSECT) then
    i = F.project_findObject(STREET, tok[2])
    if (i < 0) then
      do return F.error_setInpError(ERR_NAME, tok[2]) end
    end
    G_Link[j].xsect.type_ = k
    G_Link[j].xsect.transect = i
    do return 0 end
  else
    if (ntoks < 6) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    if (k == CUSTOM) then
      if ((not (F.getDouble(tok[2], x, 0) ~= 0)) or (x[0] <= 0.0)) then
        do return F.error_setInpError(ERR_NUMBER, tok[2]) end
      end
      i = F.project_findObject(CURVE, tok[3])
      if (i < 0) then
        do return F.error_setInpError(ERR_NAME, tok[3]) end
      end
      G_Link[j].xsect.type_ = k
      G_Link[j].xsect.transect = i
      G_Link[j].xsect.yFull = (x[0] / F.UCF(LENGTH))
    else
      do
        i = 2
        while (i <= 5) do
          do
            if (not (F.getDouble(tok[i], x, (i - 2)) ~= 0)) then
              do return F.error_setInpError(ERR_NUMBER, tok[i]) end
            end
          end
          i = i + 1
        end
      end
    end
    if ((G_Link[j].type_ ~= CONDUIT) and (k == RECT_OPEN)) then
      x[2] = 0.0
      x[3] = 0.0
    end
    if (not (F.xsect_setParams(G_Link[j].xsect, k, x, F.UCF(LENGTH)) ~= 0)) then
      do return F.error_setInpError(ERR_NUMBER, S[0]) end
    end
    if ((G_Link[j].type_ == CONDUIT) and (ntoks >= 7)) then
      i = R.atoi(tok[6])
      if (i <= 0) then
        do return F.error_setInpError(ERR_NUMBER, tok[6]) end
      else
        G_Conduit[G_Link[j].subIndex].barrels = R.i8(i)
      end
    end
    if ((G_Link[j].type_ == CONDUIT) and (ntoks >= 8)) then
      i = R.atoi(tok[7])
      if (i < 0) then
        do return F.error_setInpError(ERR_NUMBER, tok[7]) end
      else
        G_Link[j].xsect.culvertCode = i
      end
    end
  end
  do return 0 end
end

-- link.c:271
F.link_readLossParams = function(tok, ntoks)
  local G_Link = G.Link
  local i = 0
  local j = 0
  local k = 0
  local x = R.fill(3, 0.0)
  local seepRate = {0.0}
  if (ntoks < 4) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  j = F.project_findObject(LINK, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  do
    i = 1
    while (i <= 3) do
      do
        if ((not (F.getDouble(tok[i], x, (i - 1)) ~= 0)) or (x[(i - 1)] < 0.0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[i]) end
        end
      end
      i = i + 1
    end
  end
  k = 0
  if (ntoks >= 5) then
    k = F.findmatch(tok[4], G.NoYesWords)
    if (k < 0) then
      do return F.error_setInpError(ERR_KEYWORD, tok[4]) end
    end
  end
  if (ntoks >= 6) then
    if (not (F.getDouble(tok[5], seepRate, 1) ~= 0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[5]) end
    end
  end
  G_Link[j].cLossInlet = x[0]
  G_Link[j].cLossOutlet = x[1]
  G_Link[j].cLossAvg = x[2]
  G_Link[j].hasFlapGate = k
  G_Link[j].seepRate = (seepRate[1] / F.UCF(RAINFALL))
  do return 0 end
end

-- link.c:315
F.link_setParams = function(j, type_, n1, n2, k, x)
  local G_Link, G_Conduit, G_Pump, G_Orifice, G_Weir, G_Outlet = G.Link, G.Conduit, G.Pump, G.Orifice, G.Weir, G.Outlet
  G_Link[j].node1 = n1
  G_Link[j].node2 = n2
  G_Link[j].type_ = type_
  G_Link[j].subIndex = k
  G_Link[j].offset1 = 0.0
  G_Link[j].offset2 = 0.0
  G_Link[j].q0 = 0.0
  G_Link[j].qFull = 0.0
  G_Link[j].setting = 1.0
  G_Link[j].targetSetting = 1.0
  G_Link[j].hasFlapGate = 0
  G_Link[j].qLimit = 0.0
  G_Link[j].direction = 1
  do
    local __sw1 = type_
    if __sw1 == CONDUIT then goto case2
    elseif __sw1 == PUMP then goto case3
    elseif __sw1 == ORIFICE then goto case4
    elseif __sw1 == WEIR then goto case5
    elseif __sw1 == OUTLET then goto case6
    else goto swend1 end
    ::case2::
    do
      G_Conduit[k].length = (x[0] / F.UCF(LENGTH))
      G_Conduit[k].modLength = G_Conduit[k].length
      G_Conduit[k].roughness = x[1]
      G_Link[j].offset1 = (x[2] / F.UCF(LENGTH))
      G_Link[j].offset2 = (x[3] / F.UCF(LENGTH))
      G_Link[j].q0 = (x[4] / F.UCF(FLOW))
      G_Link[j].qLimit = (x[5] / F.UCF(FLOW))
      goto swend1
    end
    ::case3::
    do
      G_Pump[k].pumpCurve = R.D2I(x[0])
      G_Link[j].hasFlapGate = 0
      G_Pump[k].initSetting = x[1]
      G_Pump[k].yOn = (x[2] / F.UCF(LENGTH))
      G_Pump[k].yOff = (x[3] / F.UCF(LENGTH))
      G_Pump[k].xMin = 0.0
      G_Pump[k].xMax = 0.0
      goto swend1
    end
    ::case4::
    do
      G_Orifice[k].type_ = R.D2I(x[0])
      G_Link[j].offset1 = (x[1] / F.UCF(LENGTH))
      G_Link[j].offset2 = G_Link[j].offset1
      G_Orifice[k].cDisch = x[2]
      G_Link[j].hasFlapGate = (((x[3] > 0.0)) and 1 or 0)
      G_Orifice[k].orate = (x[4] * 3600.0)
      goto swend1
    end
    ::case5::
    do
      G_Weir[k].type_ = R.D2I(x[0])
      G_Link[j].offset1 = (x[1] / F.UCF(LENGTH))
      G_Link[j].offset2 = G_Link[j].offset1
      G_Weir[k].cDisch1 = x[2]
      G_Link[j].hasFlapGate = (((x[3] > 0.0)) and 1 or 0)
      G_Weir[k].endCon = x[4]
      G_Weir[k].cDisch2 = x[5]
      G_Weir[k].canSurcharge = R.D2I(x[6])
      G_Weir[k].roadWidth = (x[7] / F.UCF(LENGTH))
      G_Weir[k].roadSurface = R.D2I(x[8])
      G_Weir[k].cdCurve = R.D2I(x[9])
      goto swend1
    end
    ::case6::
    do
      G_Link[j].offset1 = (x[0] / F.UCF(LENGTH))
      G_Link[j].offset2 = G_Link[j].offset1
      G_Outlet[k].qCoeff = x[1]
      G_Outlet[k].qExpon = x[2]
      G_Outlet[k].qCurve = R.D2I(x[3])
      G_Link[j].hasFlapGate = (((x[4] > 0.0)) and 1 or 0)
      G_Outlet[k].curveType = R.D2I(x[5])
      F.xsect_setParams(G_Link[j].xsect, DUMMY, (nil), 0.0)
      goto swend1
    end
    ::swend1::
  end
end

-- link.c:403
F.link_validate = function(j)
  local G_Link, G_Node = G.Link, G.Node
  local n = 0
  if (G.LinkOffsets == ELEV_OFFSET) then
    F.link_convertOffsets(j)
  end
  do
    local __sw1 = G_Link[j].type_
    if __sw1 == CONDUIT then goto case2
    elseif __sw1 == PUMP then goto case3
    elseif __sw1 == ORIFICE then goto case4
    elseif __sw1 == WEIR then goto case5
    else goto swend1 end
    ::case2::
    do
      F.conduit_validate(j, G_Link[j].subIndex)
      goto swend1
    end
    ::case3::
    do
      F.pump_validate(j, G_Link[j].subIndex)
      goto swend1
    end
    ::case4::
    do
      F.orifice_validate(j, G_Link[j].subIndex)
      goto swend1
    end
    ::case5::
    do
      F.weir_validate(j, G_Link[j].subIndex)
      goto swend1
    end
    ::swend1::
  end
  do
    local __sw2 = G_Link[j].type_
    if __sw2 == ORIFICE or __sw2 == WEIR or __sw2 == OUTLET then goto case7
    else goto swend6 end
    ::case7::
    do
      if ((G_Node[G_Link[j].node1].invertElev + G_Link[j].offset1) < G_Node[G_Link[j].node2].invertElev) then
        if (G.RouteModel == DW) then
          G_Link[j].offset1 = (G_Node[G_Link[j].node2].invertElev - G_Node[G_Link[j].node1].invertElev)
          F.report_writeWarningMsg(S[305], G_Link[j].ID)
        else
          F.report_writeWarningMsg(S[306], G_Link[j].ID)
        end
      end
    end
    ::swend6::
  end
  if ((G_Link[j].type_ == PUMP) or (((G_Link[j].type_ == ORIFICE) and (G.Orifice[G_Link[j].subIndex].type_ == BOTTOM_ORIFICE)))) then
    do return end
  end
  n = G_Link[j].node1
  if ((G_Node[n].type_ ~= STORAGE) or (G_Node[n].surDepth > 0.0)) then
    G_Node[n].fullDepth = (((((G_Node[n].fullDepth) >= ((G_Link[j].offset1 + G_Link[j].xsect.yFull)))) and (G_Node[n].fullDepth) or ((G_Link[j].offset1 + G_Link[j].xsect.yFull))))
  end
  n = G_Link[j].node2
  if ((((G_Node[n].type_ ~= STORAGE) or (G_Node[n].surDepth > 0.0))) and (G_Link[j].type_ == CONDUIT)) then
    G_Node[n].fullDepth = (((((G_Node[n].fullDepth) >= ((G_Link[j].offset2 + G_Link[j].xsect.yFull)))) and (G_Node[n].fullDepth) or ((G_Link[j].offset2 + G_Link[j].xsect.yFull))))
  end
end

-- link.c:468
F.link_convertOffsets = function(j)
  local G_Node, G_Link = G.Node, G.Link
  local elev = 0.0
  elev = G_Node[G_Link[j].node1].invertElev
  G_Link[j].offset1 = F.link_getOffsetHeight(j, G_Link[j].offset1, elev)
  if (G_Link[j].type_ == CONDUIT) then
    elev = G_Node[G_Link[j].node2].invertElev
    G_Link[j].offset2 = F.link_getOffsetHeight(j, G_Link[j].offset2, elev)
  else
    G_Link[j].offset2 = G_Link[j].offset1
  end
end

-- link.c:489
F.link_getOffsetHeight = function(j, offset, elev)
  local G_Link = G.Link
  if ((offset <= (-10000000000.0)) or (G_Link[j].type_ == PUMP)) then
    do return 0.0 end
  end
  offset = (offset - elev)
  if (offset >= 0.0) then
    do return offset end
  end
  if (offset >= (-G.MIN_DELTA_Z)) then
    do return 0.0 end
  end
  F.report_writeWarningMsg(S[307], G_Link[j].ID)
  do return 0.0 end
end

-- link.c:508
F.link_initState = function(j)
  local G_Link, G_Nobjects = G.Link, G.Nobjects
  local p = 0
  G_Link[j].oldFlow = G_Link[j].q0
  G_Link[j].newFlow = G_Link[j].q0
  G_Link[j].oldDepth = 0.0
  G_Link[j].newDepth = 0.0
  G_Link[j].oldVolume = 0.0
  G_Link[j].newVolume = 0.0
  G_Link[j].setting = 1.0
  G_Link[j].targetSetting = 1.0
  G_Link[j].timeLastSet = G.StartDate
  G_Link[j].inletControl = 0
  G_Link[j].normalFlow = 0
  if (G_Link[j].type_ == CONDUIT) then
    F.conduit_initState(j, G_Link[j].subIndex)
  end
  if (G_Link[j].type_ == PUMP) then
    F.pump_initState(j, G_Link[j].subIndex)
  end
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        G_Link[j].oldQual[p] = 0.0
        G_Link[j].newQual[p] = 0.0
        G_Link[j].totalLoad[p] = 0.0
      end
      p = p + 1
    end
  end
end

-- link.c:543
F.link_getInflow = function(j)
  local G_Link = G.Link
  if (G_Link[j].setting == 0.0) then
    do return 0.0 end
  end
  do
    local __sw1 = G_Link[j].type_
    if __sw1 == CONDUIT then goto case2
    elseif __sw1 == PUMP then goto case3
    elseif __sw1 == ORIFICE then goto case4
    elseif __sw1 == WEIR then goto case5
    elseif __sw1 == OUTLET then goto case6
    else goto case7 end
    ::case2::
    do
      do return F.conduit_getInflow(j) end
    end
    ::case3::
    do
      do return F.pump_getInflow(j) end
    end
    ::case4::
    do
      do return F.orifice_getInflow(j) end
    end
    ::case5::
    do
      do return F.weir_getInflow(j) end
    end
    ::case6::
    do
      do return F.outlet_getInflow(j) end
    end
    ::case7::
    do
      do return F.node_getOutflow(G_Link[j].node1, j) end
    end
    ::swend1::
  end
end

-- link.c:564
F.link_setOldHydState = function(j)
  local G_Link, G_Conduit = G.Link, G.Conduit
  local k = 0
  G_Link[j].oldDepth = G_Link[j].newDepth
  G_Link[j].oldFlow = G_Link[j].newFlow
  G_Link[j].oldVolume = G_Link[j].newVolume
  if (G_Link[j].type_ == CONDUIT) then
    k = G_Link[j].subIndex
    G_Conduit[k].q1Old = G_Conduit[k].q1
    G_Conduit[k].q2Old = G_Conduit[k].q2
  end
end

-- link.c:587
F.link_setOldQualState = function(j)
  local G_Nobjects, G_Link = G.Nobjects, G.Link
  local p = 0
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        G_Link[j].oldQual[p] = G_Link[j].newQual[p]
        G_Link[j].newQual[p] = 0.0
      end
      p = p + 1
    end
  end
end

-- link.c:604
F.link_setTargetSetting = function(j)
  local G_Link, G_Pump, G_Node = G.Link, G.Pump, G.Node
  local k = 0
  local n1 = 0
  if (G_Link[j].type_ == PUMP) then
    k = G_Link[j].subIndex
    n1 = G_Link[j].node1
    G_Link[j].targetSetting = G_Link[j].setting
    if (((G_Pump[k].yOff > 0.0) and (G_Link[j].setting > 0.0)) and (G_Node[n1].newDepth < G_Pump[k].yOff)) then
      G_Link[j].targetSetting = 0.0
    end
    if (((G_Pump[k].yOn > 0.0) and (G_Link[j].setting == 0.0)) and (G_Node[n1].newDepth > G_Pump[k].yOn)) then
      G_Link[j].targetSetting = 1.0
    end
  end
end

-- link.c:628
F.link_setSetting = function(j, tstep)
  local G_Link = G.Link
  if (G_Link[j].type_ == ORIFICE) then
    F.orifice_setSetting(j, tstep)
  elseif (G_Link[j].type_ == WEIR) then
    F.weir_setSetting(j)
  else
    G_Link[j].setting = G_Link[j].targetSetting
  end
end

-- link.c:643
F.link_setFlapGate = function(j, n1, n2, q)
  local G_Link, G_Node = G.Link, G.Node
  local n = (-1)
  if (G_Link[j].hasFlapGate ~= 0) then
    if ((q * (G_Link[j].direction * 1.0)) < 0.0) then
      do return 1 end
    end
  end
  if (q < 0.0) then
    n = n2
  end
  if (q > 0.0) then
    n = n1
  end
  if (((n >= 0) and (G_Node[n].type_ == OUTFALL)) and (G.Outfall[G_Node[n].subIndex].hasFlapGate ~= 0)) then
    do return 1 end
  end
  do return 0 end
end

-- link.c:674
F.link_getResults = function(j, f, x)
  local G_Link, G_Nobjects = G.Link, G.Nobjects
  local p = 0
  local y = 0.0
  local q = 0.0
  local u = 0.0
  local v = 0.0
  local c = 0.0
  local f1 = (1.0 - f)
  y = ((f1 * G_Link[j].oldDepth) + (f * G_Link[j].newDepth))
  q = ((f1 * G_Link[j].oldFlow) + (f * G_Link[j].newFlow))
  v = ((f1 * G_Link[j].oldVolume) + (f * G_Link[j].newVolume))
  u = F.link_getVelocity(j, q, y)
  c = 0.0
  if (G_Link[j].type_ == CONDUIT) then
    if (G_Link[j].xsect.type_ ~= DUMMY) then
      c = (F.xsect_getAofY(G_Link[j].xsect, y) / G_Link[j].xsect.aFull)
    end
  else
    c = G_Link[j].setting
  end
  if ((G_Link[j].type_ == PUMP) and ((G_Link[j].oldFlow * G_Link[j].newFlow) == 0.0)) then
    if (f >= f1) then
      q = G_Link[j].newFlow
    else
      q = G_Link[j].oldFlow
    end
  end
  y = (y * (F.UCF(LENGTH)))
  v = (v * (F.UCF(VOLUME)))
  q = (q * (F.UCF(FLOW) * (G_Link[j].direction * 1.0)))
  u = (u * (F.UCF(LENGTH) * (G_Link[j].direction * 1.0)))
  x[LINK_DEPTH] = R.f32(y)
  x[LINK_FLOW] = R.f32(q)
  x[LINK_VELOCITY] = R.f32(u)
  x[LINK_VOLUME] = R.f32(v)
  x[LINK_CAPACITY] = R.f32(c)
  if (not (G.IgnoreQuality ~= 0)) then
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          c = ((f1 * G_Link[j].oldQual[p]) + (f * G_Link[j].newQual[p]))
          x[(LINK_QUAL + p)] = R.f32(c)
        end
        p = p + 1
      end
    end
  end
end

-- link.c:728
F.link_setOutfallDepth = function(j)
  local G_Node, G_Link = G.Node, G.Link
  local k = 0
  local n = 0
  local z = 0.0
  local q = 0.0
  local yCrit = 0.0
  local yNorm = 0.0
  if (G_Node[G_Link[j].node2].type_ == OUTFALL) then
    n = G_Link[j].node2
    z = G_Link[j].offset2
  elseif (G_Node[G_Link[j].node1].type_ == OUTFALL) then
    n = G_Link[j].node1
    z = G_Link[j].offset1
  else
    do return end
  end
  if (G_Link[j].type_ == CONDUIT) then
    k = G_Link[j].subIndex
    q = m_abs((G_Link[j].newFlow / (G.Conduit[k].barrels * 1.0)))
    yNorm = F.link_getYnorm(j, q)
    yCrit = F.link_getYcrit(j, q)
  end
  F.node_setOutletDepth(n, yNorm, yCrit, z)
end

-- link.c:770
F.link_getYcrit = function(j, q)
  do return F.xsect_getYcrit(G.Link[j].xsect, q) end
end

-- link.c:783
F.link_getYnorm = function(j, q)
  local G_Link, G_Conduit = G.Link, G.Conduit
  local k = 0
  local s = 0.0
  local a = 0.0
  local y = 0.0
  if (G_Link[j].type_ ~= CONDUIT) then
    do return 0.0 end
  end
  if (G_Link[j].xsect.type_ == DUMMY) then
    do return 0.0 end
  end
  q = m_abs(q)
  k = G_Link[j].subIndex
  if (q > G_Conduit[k].qMax) then
    q = G_Conduit[k].qMax
  end
  if (q <= 0.0) then
    do return 0.0 end
  end
  s = (q / G_Conduit[k].beta)
  a = F.xsect_getAofS(G_Link[j].xsect, s)
  y = F.xsect_getYofA(G_Link[j].xsect, a)
  do return y end
end

-- link.c:808
F.link_getLength = function(j)
  if (G.Link[j].type_ == CONDUIT) then
    do return F.conduit_getLength(j) end
  end
  do return 0.0 end
end

-- link.c:821
F.link_getVelocity = function(j, flow, depth)
  local G_Link = G.Link
  local area = 0.0
  local veloc = 0.0
  local k = 0
  if (depth <= 0.01) then
    do return 0.0 end
  end
  if (G_Link[j].type_ == CONDUIT) then
    k = G_Link[j].subIndex
    flow = (flow / (G.Conduit[k].barrels * 1.0))
    area = F.xsect_getAofY(G_Link[j].xsect, depth)
    if (area > 0.0001) then
      veloc = (flow / area)
    end
  end
  do return veloc end
end

-- link.c:847
F.link_getFroude = function(j, v, y)
  local G_Link = G.Link
  local xsect = G_Link[j].xsect
  if (G_Link[j].type_ ~= CONDUIT) then
    do return 0.0 end
  end
  if (y <= 0.0001) then
    do return 0.0 end
  end
  if ((not (F.xsect_isOpen(xsect.type_) ~= 0)) and ((xsect.yFull - y) <= 0.0001)) then
    do return 0.0 end
  end
  y = (F.xsect_getAofY(xsect, y) / F.xsect_getWofY(xsect, y))
  do return (m_abs(v) / m_sqrt((32.2 * y))) end
end

-- link.c:875
F.link_getPower = function(j)
  local G_Link, G_Node = G.Link, G.Node
  local n1 = G_Link[j].node1
  local n2 = G_Link[j].node2
  local dh = (((G_Node[n1].invertElev + G_Node[n1].newDepth)) - ((G_Node[n2].invertElev + G_Node[n2].newDepth)))
  local q = m_abs(G_Link[j].newFlow)
  do return (((m_abs(dh) * q) / 8.814) * 0.7457) end
end

-- link.c:893
F.link_getLossRate = function(j, routeModel, q, tstep)
  if (G.Link[j].type_ == CONDUIT) then
    do return F.conduit_getLossRate(j, routeModel, q, tstep) end
  else
    do return 0.0 end
  end
end

-- link.c:911
F.link_getFullState = function(a1, a2, aFull)
  if (a1 >= aFull) then
    if (a2 >= aFull) then
      do return ALL_FULL end
    else
      do return UP_FULL end
    end
  end
  if (a2 >= aFull) then
    do return DN_FULL end
  end
  do return 0 end
end

-- link.c:933
F.conduit_readParams = function(j, k, tok, ntoks)
  local n1 = 0
  local n2 = 0
  local x = R.fill(6, 0.0)
  local id = nil
  if (ntoks < 7) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  id = F.project_findID(LINK, tok[0])
  if R.peq(id, (nil)) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  n1 = F.project_findObject(NODE, tok[1])
  if (n1 < 0) then
    do return F.error_setInpError(ERR_NAME, tok[1]) end
  end
  n2 = F.project_findObject(NODE, tok[2])
  if (n2 < 0) then
    do return F.error_setInpError(ERR_NAME, tok[2]) end
  end
  if (not (F.getDouble(tok[3], x, 0) ~= 0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[3]) end
  end
  if (not (F.getDouble(tok[4], x, 1) ~= 0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[4]) end
  end
  if ((G.LinkOffsets == ELEV_OFFSET) and (tok[5].b[tok[5].o] == 42)) then
    x[2] = (-10000000000.0)
  elseif (not (F.getDouble(tok[5], x, 2) ~= 0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[5]) end
  end
  if ((G.LinkOffsets == ELEV_OFFSET) and (tok[6].b[tok[6].o] == 42)) then
    x[3] = (-10000000000.0)
  elseif (not (F.getDouble(tok[6], x, 3) ~= 0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[6]) end
  end
  x[4] = 0.0
  if (ntoks >= 8) then
    if (not (F.getDouble(tok[7], x, 4) ~= 0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[7]) end
    end
  end
  x[5] = 0.0
  if (ntoks >= 9) then
    if (not (F.getDouble(tok[8], x, 5) ~= 0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[8]) end
    end
  end
  G.Link[j].ID = id
  F.link_setParams(j, CONDUIT, n1, n2, k, x)
  do return 0 end
end

-- link.c:992
F.conduit_validate = function(j, k)
  local G_Link, G_Node, G_Transect, G_Conduit = G.Link, G.Node, G.Transect, G.Conduit
  local aa = 0.0
  local lengthFactor = 0.0
  local roughness = 0.0
  local slope = 0.0
  if ((G_Link[j].xsect.type_ == DUMMY) and (G.RouteModel == DW)) then
    if (G_Node[G_Link[j].node1].type_ == STORAGE) then
      F.report_writeErrorMsg(ERR_DUMMY_LINK, G_Node[G_Link[j].node1].ID)
      do return end
    end
  end
  if (G_Link[j].xsect.type_ == CUSTOM) then
    F.xsect_setCustomXsectParams(G_Link[j].xsect)
  end
  if (G_Link[j].xsect.type_ == IRREGULAR) then
    F.xsect_setIrregXsectParams(G_Link[j].xsect)
    G_Conduit[k].roughness = G_Transect[G_Link[j].xsect.transect].roughness
  end
  if (G_Link[j].xsect.type_ == STREET_XSECT) then
    F.xsect_setStreetXsectParams(G_Link[j].xsect)
    G_Conduit[k].roughness = G.Street[G_Link[j].xsect.transect].roughness
  end
  if (G_Link[j].xsect.type_ == FORCE_MAIN) then
    if (G.ForceMainEqn == D_W) then
      G_Link[j].xsect.rBot = (G_Link[j].xsect.rBot / (F.UCF(RAINDEPTH)))
    end
    if (G_Link[j].xsect.rBot <= 0.0) then
      F.report_writeErrorMsg(ERR_XSECT, G_Link[j].ID)
    end
  end
  if (G_Conduit[k].length <= 0.0) then
    F.report_writeErrorMsg(ERR_LENGTH, G_Link[j].ID)
  end
  if (G_Conduit[k].roughness <= 0.0) then
    F.report_writeErrorMsg(ERR_ROUGHNESS, G_Link[j].ID)
  end
  if (G_Conduit[k].barrels <= 0) then
    F.report_writeErrorMsg(ERR_BARRELS, G_Link[j].ID)
  end
  if (G_Link[j].xsect.type_ ~= DUMMY) then
    if (G_Link[j].xsect.type_ < 0) then
      F.report_writeErrorMsg(ERR_NO_XSECT, G_Link[j].ID)
    elseif (G_Link[j].xsect.aFull <= 0.0) then
      F.report_writeErrorMsg(ERR_XSECT, G_Link[j].ID)
    end
  end
  if (G.ErrorCode ~= 0) then
    do return end
  end
  if (G_Link[j].offset1 < 0.0) then
    F.report_writeWarningMsg(S[307], G_Link[j].ID)
    G_Link[j].offset1 = 0.0
  end
  if (G_Link[j].offset2 < 0.0) then
    F.report_writeWarningMsg(S[307], G_Link[j].ID)
    G_Link[j].offset2 = 0.0
  end
  if (G_Link[j].xsect.type_ == FILLED_CIRCULAR) then
    G_Link[j].offset1 = (G_Link[j].offset1 + G_Link[j].xsect.yBot)
    G_Link[j].offset2 = (G_Link[j].offset2 + G_Link[j].xsect.yBot)
  end
  slope = F.conduit_getSlope(j)
  G_Conduit[k].slope = slope
  if (((G.RouteModel == DW) and (slope < 0.0)) and (G_Link[j].xsect.type_ ~= DUMMY)) then
    F.conduit_reverse(j, k)
  end
  roughness = G_Conduit[k].roughness
  if ((G.RouteModel == DW) and (G_Link[j].xsect.type_ == FORCE_MAIN)) then
    roughness = F.forcemain_getEquivN(j, k)
  end
  if (G_Link[j].xsect.type_ == IRREGULAR) then
    lengthFactor = G_Transect[G_Link[j].xsect.transect].lengthFactor
    roughness = (roughness * (m_sqrt(lengthFactor)))
  end
  lengthFactor = 1.0
  if (((G.RouteModel == DW) and (G.LengtheningStep > 0.0)) and (G_Link[j].xsect.type_ ~= DUMMY)) then
    lengthFactor = F.conduit_getLengthFactor(j, k, roughness)
  end
  if (lengthFactor ~= 1.0) then
    G_Conduit[k].modLength = (lengthFactor * F.conduit_getLength(j))
    slope = (slope / lengthFactor)
    roughness = (roughness / m_sqrt(lengthFactor))
  end
  if ((G.RouteModel == DW) and (G_Link[j].xsect.type_ == FORCE_MAIN)) then
    G_Link[j].xsect.sBot = F.forcemain_getRoughFactor(j, lengthFactor)
  end
  G_Conduit[k].roughFactor = (32.2 * ((((roughness / 1.486)) * ((roughness / 1.486)))))
  if (G_Link[j].xsect.type_ == DUMMY) then
    G_Conduit[k].beta = 0.0
  else
    G_Conduit[k].beta = ((1.486 * m_sqrt(m_abs(slope))) / roughness)
  end
  G_Link[j].qFull = (G_Link[j].xsect.sFull * G_Conduit[k].beta)
  G_Conduit[k].qMax = (G_Link[j].xsect.sMax * G_Conduit[k].beta)
  aa = (((G_Conduit[k].beta / m_sqrt(32.2)) * (G_Link[j].xsect.yFull ^ 0.1666667)) * 0.3)
  if (aa >= 1.0) then
    G_Conduit[k].superCritical = 1
  else
    G_Conduit[k].superCritical = 0
  end
  if (((G_Link[j].cLossInlet == 0.0) and (G_Link[j].cLossOutlet == 0.0)) and (G_Link[j].cLossAvg == 0.0)) then
    G_Conduit[k].hasLosses = 0
  else
    G_Conduit[k].hasLosses = 1
  end
end

-- link.c:1158
F.conduit_reverse = function(j, k)
  local G_Link, G_Conduit = G.Link, G.Conduit
  local i = 0
  local z = 0.0
  local cLoss = 0.0
  i = G_Link[j].node1
  G_Link[j].node1 = G_Link[j].node2
  G_Link[j].node2 = i
  z = G_Link[j].offset1
  G_Link[j].offset1 = G_Link[j].offset2
  G_Link[j].offset2 = z
  cLoss = G_Link[j].cLossInlet
  G_Link[j].cLossInlet = G_Link[j].cLossOutlet
  G_Link[j].cLossOutlet = cLoss
  G_Conduit[k].slope = (-G_Conduit[k].slope)
  G_Link[j].direction = (G_Link[j].direction * (R.i8((-1))))
  G_Link[j].q0 = (-G_Link[j].q0)
end

-- link.c:1195
F.conduit_getLength = function(j)
  local G_Link, G_Conduit = G.Link, G.Conduit
  local k = G_Link[j].subIndex
  local t = 0
  if (G_Link[j].xsect.type_ ~= IRREGULAR) then
    do return G_Conduit[k].length end
  end
  t = G_Link[j].xsect.transect
  if ((t < 0) or (t >= G.Nobjects[TRANSECT])) then
    do return G_Conduit[k].length end
  end
  do return (G_Conduit[k].length / G.Transect[t].lengthFactor) end
end

-- link.c:1217
F.conduit_getLengthFactor = function(j, k, roughness)
  local G_Link = G.Link
  local ratio = 0.0
  local yFull = 0.0
  local vFull = 0.0
  local tStep = 0.0
  yFull = G_Link[j].xsect.yFull
  if (F.xsect_isOpen(G_Link[j].xsect.type_) ~= 0) then
    yFull = (G_Link[j].xsect.aFull / F.xsect_getWofY(G_Link[j].xsect, yFull))
  end
  vFull = ((((1.486 / roughness) * G_Link[j].xsect.sFull) * m_sqrt(m_abs(G.Conduit[k].slope))) / G_Link[j].xsect.aFull)
  if (G.LengtheningStep == 0.0) then
    tStep = G.RouteStep
  else
    tStep = (((((G.RouteStep) <= (G.LengtheningStep))) and (G.RouteStep) or (G.LengtheningStep)))
  end
  ratio = ((((m_sqrt((32.2 * yFull)) + vFull)) * tStep) / F.conduit_getLength(j))
  if (ratio > 1.0) then
    do return ratio end
  else
    do return 1.0 end
  end
end

-- link.c:1258
F.conduit_getSlope = function(j)
  local G_Link, G_Node = G.Link, G.Node
  local elev1 = 0.0
  local elev2 = 0.0
  local delta = 0.0
  local slope = 0.0
  local length = F.conduit_getLength(j)
  elev1 = (G_Link[j].offset1 + G_Node[G_Link[j].node1].invertElev)
  elev2 = (G_Link[j].offset2 + G_Node[G_Link[j].node2].invertElev)
  delta = m_abs((elev1 - elev2))
  if (delta < G.MIN_DELTA_Z) then
    F.report_writeWarningMsg(S[308], G_Link[j].ID)
    delta = G.MIN_DELTA_Z
  end
  if (delta >= length) then
    F.report_writeWarningMsg(S[309], G_Link[j].ID)
    slope = (delta / length)
  else
    slope = (delta / m_sqrt(((((length) * (length))) - (((delta) * (delta))))))
  end
  if ((G.MinSlope > 0.0) and (slope < G.MinSlope)) then
    F.report_writeWarningMsg(S[310], G_Link[j].ID)
    slope = G.MinSlope
    if ((G.RouteModel == SF) or (G.RouteModel == KW)) then
      do return slope end
    end
  end
  if (elev1 < elev2) then
    slope = (-slope)
  end
  do return slope end
end

-- link.c:1304
F.conduit_initState = function(j, k)
  local G_Link, G_Conduit = G.Link, G.Conduit
  G_Link[j].newDepth = F.link_getYnorm(j, (G_Link[j].q0 / (G_Conduit[k].barrels * 1.0)))
  G_Link[j].oldDepth = G_Link[j].newDepth
  G_Conduit[k].evapLossRate = 0.0
  G_Conduit[k].seepLossRate = 0.0
end

-- link.c:1320
F.conduit_getInflow = function(j)
  local G_Link = G.Link
  local qIn = F.node_getOutflow(G_Link[j].node1, j)
  if (G_Link[j].qLimit > 0.0) then
    qIn = (((((qIn) <= (G_Link[j].qLimit))) and (qIn) or (G_Link[j].qLimit)))
  end
  do return qIn end
end

-- link.c:1334
F.conduit_getLossRate = function(j, routeModel, q, tstep)
  local G_Link, G_Evap, G_Conduit = G.Link, G.Evap, G.Conduit
  local xsect = nil
  local depth = (0.5 * ((G_Link[j].oldDepth + G_Link[j].newDepth)))
  local length = 0.0
  local width = 0.0
  local topWidth = 0.0
  local evapLossRate = 0.0
  local seepLossRate = 0.0
  local totalLossRate = 0.0
  if (depth > 0.0001) then
    xsect = G_Link[j].xsect
    length = F.conduit_getLength(j)
    if ((F.xsect_isOpen(xsect.type_) ~= 0) and (G_Evap.rate > 0.0)) then
      topWidth = F.xsect_getWofY(xsect, depth)
      evapLossRate = ((topWidth * length) * G_Evap.rate)
    end
    if (G_Link[j].seepRate > 0.0) then
      if (xsect.type_ == RECT_CLOSED) then
        width = xsect.wMax
      else
        if (depth >= xsect.ywMax) then
          depth = xsect.ywMax
        end
        width = F.xsect_getWofY(xsect, depth)
      end
      seepLossRate = ((G_Link[j].seepRate * width) * length)
      seepLossRate = (seepLossRate * G.Adjust.hydconFactor)
    end
    totalLossRate = (evapLossRate + seepLossRate)
    if (routeModel == DW) then
      q = (G_Link[j].newVolume / tstep)
    else
      q = (((((q) < 0.0)) and (-(q)) or (q)))
    end
    if (totalLossRate > q) then
      evapLossRate = ((evapLossRate * q) / totalLossRate)
      seepLossRate = ((seepLossRate * q) / totalLossRate)
      totalLossRate = q
    end
  end
  G_Conduit[G_Link[j].subIndex].evapLossRate = evapLossRate
  G_Conduit[G_Link[j].subIndex].seepLossRate = seepLossRate
  do return totalLossRate end
end

-- link.c:1406
F.pump_readParams = function(j, k, tok, ntoks)
  local m = 0
  local n1 = 0
  local n2 = 0
  local x = R.fill(4, 0.0)
  local id = nil
  if (ntoks < 3) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  id = F.project_findID(LINK, tok[0])
  if R.peq(id, (nil)) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  n1 = F.project_findObject(NODE, tok[1])
  if (n1 < 0) then
    do return F.error_setInpError(ERR_NAME, tok[1]) end
  end
  n2 = F.project_findObject(NODE, tok[2])
  if (n2 < 0) then
    do return F.error_setInpError(ERR_NAME, tok[2]) end
  end
  x[0] = (-1.0)
  if (ntoks >= 4) then
    if (not (F.strcomp(tok[3], S[275]) ~= 0)) then
      m = F.project_findObject(CURVE, tok[3])
      if (m < 0) then
        do return F.error_setInpError(ERR_NAME, tok[3]) end
      end
      x[0] = (m * 1.0)
    end
  end
  x[1] = 1.0
  if (ntoks >= 5) then
    m = F.findmatch(tok[4], G.OffOnWords)
    if (m < 0) then
      do return F.error_setInpError(ERR_KEYWORD, tok[4]) end
    end
    x[1] = (m * 1.0)
  end
  x[2] = 0.0
  if (ntoks >= 6) then
    if ((not (F.getDouble(tok[5], x, 2) ~= 0)) or (x[2] < 0.0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[5]) end
    end
  end
  x[3] = 0.0
  if (ntoks >= 7) then
    if ((not (F.getDouble(tok[6], x, 3) ~= 0)) or (x[3] < 0.0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[6]) end
    end
  end
  G.Link[j].ID = id
  F.link_setParams(j, PUMP, n1, n2, k, x)
  do return 0 end
end

-- link.c:1473
F.pump_validate = function(j, k)
  local G_Link, G_Pump, G_Curve, G_Node = G.Link, G.Pump, G.Curve, G.Node
  local m = 0
  local n1 = 0
  local x = {0.0}
  local y = {0.0}
  G_Link[j].xsect.yFull = 0.0
  m = G_Pump[k].pumpCurve
  if (m < 0) then
    G_Pump[k].type_ = IDEAL_PUMP
  else
    if ((G_Curve[m].curveType < PUMP1_CURVE) or (G_Curve[m].curveType > PUMP5_CURVE)) then
      F.report_writeErrorMsg(ERR_NO_CURVE, G_Link[j].ID)
    else
      G_Pump[k].type_ = (G_Curve[m].curveType - PUMP1_CURVE)
      if (F.table_getFirstEntry(G_Curve[m], x, 1, y, 1) ~= 0) then
        G_Link[j].qFull = y[1]
        G_Pump[k].xMin = x[1]
        G_Pump[k].xMax = x[1]
        while (F.table_getNextEntry(G_Curve[m], x, 1, y, 1) ~= 0) do
          do
            G_Link[j].qFull = (((((y[1]) >= (G_Link[j].qFull))) and (y[1]) or (G_Link[j].qFull)))
            G_Pump[k].xMax = x[1]
          end
        end
      end
      G_Link[j].qFull = (G_Link[j].qFull / (F.UCF(FLOW)))
    end
  end
  if ((G_Pump[k].yOn > 0.0) and (G_Pump[k].yOn <= G_Pump[k].yOff)) then
    F.report_writeErrorMsg(ERR_PUMP_LIMITS, G_Link[j].ID)
  end
  if (G_Pump[k].type_ == TYPE1_PUMP) then
    n1 = G_Link[j].node1
    if (G_Node[n1].type_ ~= STORAGE) then
      G_Node[n1].fullVolume = (((((G_Node[n1].fullVolume) >= ((G_Pump[k].xMax / F.UCF(VOLUME))))) and (G_Node[n1].fullVolume) or ((G_Pump[k].xMax / F.UCF(VOLUME)))))
    end
  end
end

-- link.c:1534
F.pump_initState = function(j, k)
  local G_Pump, G_Link = G.Pump, G.Link
  G_Link[j].setting = G_Pump[k].initSetting
  G_Link[j].targetSetting = G_Pump[k].initSetting
end

-- link.c:1548
F.pump_getInflow = function(j)
  local G_Link, G_Pump, G_Node, G_Curve = G.Link, G.Pump, G.Node, G.Curve
  local k = 0
  local m = 0
  local n1 = 0
  local n2 = 0
  local vol = 0.0
  local depth = 0.0
  local head = 0.0
  local qIn = 0.0
  local qIn1 = 0.0
  local dh = 0.001
  local s = 1.0
  k = G_Link[j].subIndex
  m = G_Pump[k].pumpCurve
  n1 = G_Link[j].node1
  n2 = G_Link[j].node2
  G_Link[j].flowClass = NO
  G_Link[j].setting = G_Link[j].targetSetting
  if (G_Link[j].setting == 0.0) then
    do return 0.0 end
  end
  if (G_Pump[k].type_ == IDEAL_PUMP) then
    qIn = (G_Node[n1].inflow + G_Node[n1].overflow)
  else
    do
      local __sw1 = G_Curve[m].curveType
      if __sw1 == PUMP1_CURVE then goto case2
      elseif __sw1 == PUMP2_CURVE then goto case3
      elseif __sw1 == PUMP3_CURVE or __sw1 == PUMP5_CURVE then goto case4
      elseif __sw1 == PUMP4_CURVE then goto case5
      else goto case6 end
      ::case2::
      do
        vol = (G_Node[n1].newVolume * F.UCF(VOLUME))
        qIn = (F.table_intervalLookup(G_Curve[m], vol) / F.UCF(FLOW))
        if ((vol < G_Pump[k].xMin) or (vol > G_Pump[k].xMax)) then
          G_Link[j].flowClass = YES
        end
        goto swend1
      end
      ::case3::
      do
        depth = (G_Node[n1].newDepth * F.UCF(LENGTH))
        qIn = (F.table_intervalLookup(G_Curve[m], depth) / F.UCF(FLOW))
        if ((depth < G_Pump[k].xMin) or (depth > G_Pump[k].xMax)) then
          G_Link[j].flowClass = YES
        end
        goto swend1
      end
      ::case4::
      do
        if (G_Curve[m].curveType == PUMP5_CURVE) then
          s = G_Link[j].setting
        end
        head = ((((((G_Node[n2].newDepth + G_Node[n2].invertElev)) - ((G_Node[n1].newDepth + G_Node[n1].invertElev)))) / s) / s)
        head = ((((((head) >= (0.0))) and (head) or (0.0))) * F.UCF(LENGTH))
        qIn = (F.table_lookup(G_Curve[m], head) / F.UCF(FLOW))
        G_Link[j].dqdh = ((((-(F.table_getSlope(G_Curve[m], head))) * F.UCF(LENGTH)) / F.UCF(FLOW)) / s)
        if ((head < G_Pump[k].xMin) or (head > G_Pump[k].xMax)) then
          G_Link[j].flowClass = YES
        end
        goto swend1
      end
      ::case5::
      do
        depth = G_Node[n1].newDepth
        qIn = (F.table_lookup(G_Curve[m], (depth * F.UCF(LENGTH))) / F.UCF(FLOW))
        qIn1 = (F.table_lookup(G_Curve[m], (((depth + dh)) * F.UCF(LENGTH))) / F.UCF(FLOW))
        G_Link[j].dqdh = (((qIn1 - qIn)) / dh)
        depth = (depth * (F.UCF(LENGTH)))
        if (depth < G_Pump[k].xMin) then
          G_Link[j].flowClass = DN_DRY
        end
        if (depth > G_Pump[k].xMax) then
          G_Link[j].flowClass = UP_DRY
        end
        goto swend1
      end
      ::case6::
      do
        qIn = 0.0
      end
      ::swend1::
    end
  end
  if (qIn < 0.0) then
    qIn = 0.0
  end
  do return (qIn * G_Link[j].setting) end
end

-- link.c:1641
F.orifice_readParams = function(j, k, tok, ntoks)
  local m = 0
  local n1 = 0
  local n2 = 0
  local x = R.fill(5, 0.0)
  local id = nil
  if (ntoks < 6) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  id = F.project_findID(LINK, tok[0])
  if R.peq(id, (nil)) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  n1 = F.project_findObject(NODE, tok[1])
  if (n1 < 0) then
    do return F.error_setInpError(ERR_NAME, tok[1]) end
  end
  n2 = F.project_findObject(NODE, tok[2])
  if (n2 < 0) then
    do return F.error_setInpError(ERR_NAME, tok[2]) end
  end
  m = F.findmatch(tok[3], G.OrificeTypeWords)
  if (m < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[3]) end
  end
  x[0] = (m * 1.0)
  if ((G.LinkOffsets == ELEV_OFFSET) and (tok[4].b[tok[4].o] == 42)) then
    x[1] = (-10000000000.0)
  elseif (not (F.getDouble(tok[4], x, 1) ~= 0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[4]) end
  end
  if ((not (F.getDouble(tok[5], x, 2) ~= 0)) or (x[2] < 0.0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[5]) end
  end
  x[3] = 0.0
  if (ntoks >= 7) then
    m = F.findmatch(tok[6], G.NoYesWords)
    if (m < 0) then
      do return F.error_setInpError(ERR_KEYWORD, tok[6]) end
    end
    x[3] = (m * 1.0)
  end
  x[4] = 0.0
  if (ntoks >= 8) then
    if ((not (F.getDouble(tok[7], x, 4) ~= 0)) or (x[4] < 0.0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[7]) end
    end
  end
  G.Link[j].ID = id
  F.link_setParams(j, ORIFICE, n1, n2, k, x)
  do return 0 end
end

-- link.c:1696
F.orifice_validate = function(j, k)
  local G_Link, G_Orifice = G.Link, G.Orifice
  local err = 0
  if ((G_Link[j].xsect.type_ ~= RECT_CLOSED) and (G_Link[j].xsect.type_ ~= CIRCULAR)) then
    err = ERR_REGULATOR_SHAPE
  end
  if (err > 0) then
    F.report_writeErrorMsg(err, G_Link[j].ID)
    do return end
  end
  if (G_Link[j].offset1 < 0.0) then
    G_Link[j].offset1 = 0.0
  end
  F.orifice_setSetting(j, 0.0)
  G_Orifice[k].length = ((2.0 * G.RouteStep) * m_sqrt((32.2 * G_Link[j].xsect.yFull)))
  G_Orifice[k].length = (((((200.0) >= (G_Orifice[k].length))) and (200.0) or (G_Orifice[k].length)))
  G_Orifice[k].surfArea = 0.0
end

-- link.c:1729
F.orifice_setSetting = function(j, tstep)
  local G_Link, G_Orifice = G.Link, G.Orifice
  local k = G_Link[j].subIndex
  local delta = 0.0
  local step = 0.0
  local h = 0.0
  local f = 0.0
  if ((G_Orifice[k].orate == 0.0) or (tstep == 0.0)) then
    G_Link[j].setting = G_Link[j].targetSetting
  else
    delta = (G_Link[j].targetSetting - G_Link[j].setting)
    step = (tstep / G_Orifice[k].orate)
    if ((step + 0.001) >= m_abs(delta)) then
      G_Link[j].setting = G_Link[j].targetSetting
    else
      G_Link[j].setting = (G_Link[j].setting + (((((((delta) < 0.0)) and ((-1)) or (1))) * 1.0) * step))
    end
  end
  h = (G_Link[j].setting * G_Link[j].xsect.yFull)
  f = (F.xsect_getAofY(G_Link[j].xsect, h) * m_sqrt((2.0 * 32.2)))
  G_Orifice[k].cOrif = (G_Orifice[k].cDisch * f)
  G_Orifice[k].cWeir = (F.orifice_getWeirCoeff(j, k, h) * f)
end

-- link.c:1766
F.orifice_getWeirCoeff = function(j, k, h)
  local G_Orifice, G_Link = G.Orifice, G.Link
  local w = 0.0
  local aOverL = 0.0
  if (G_Orifice[k].type_ == BOTTOM_ORIFICE) then
    if (G_Link[j].xsect.type_ == CIRCULAR) then
      aOverL = (h / 4.0)
    else
      w = G_Link[j].xsect.wMax
      aOverL = (((h * w)) / ((2.0 * ((h + w)))))
    end
    h = ((G_Orifice[k].cDisch / 0.414) * aOverL)
    G_Orifice[k].hCrit = h
  else
    G_Orifice[k].hCrit = h
    h = (h / 2.0)
  end
  do return (G_Orifice[k].cDisch * m_sqrt(h)) end
end

-- link.c:1812
F.orifice_getInflow = function(j)
  local G_Link, G_Node, G_Orifice = G.Link, G.Node, G.Orifice
  local k = 0
  local n1 = 0
  local n2 = 0
  local head = 0.0
  local h1 = 0.0
  local h2 = 0.0
  local y1 = 0.0
  local dir = 0.0
  local f = 0.0
  local hcrest = 0.0
  local hcrown = 0.0
  local hmidpt = 0.0
  local q = 0.0
  local ratio = 0.0
  n1 = G_Link[j].node1
  n2 = G_Link[j].node2
  k = G_Link[j].subIndex
  if (G.RouteModel == DW) then
    h1 = (G_Node[n1].newDepth + G_Node[n1].invertElev)
    h2 = (G_Node[n2].newDepth + G_Node[n2].invertElev)
  else
    h1 = (G_Node[n1].newDepth + G_Node[n1].invertElev)
    h2 = G_Node[n1].invertElev
  end
  dir = (((h1 >= h2)) and 1.0 or (-1.0))
  y1 = G_Node[n1].newDepth
  if (dir < 0.0) then
    head = h1
    h1 = h2
    h2 = head
    y1 = G_Node[n2].newDepth
  end
  if (G_Orifice[k].type_ == BOTTOM_ORIFICE) then
    hcrest = (G_Node[n1].invertElev + G_Link[j].offset1)
    if (h1 < hcrest) then
      head = 0.0
    elseif (h2 > hcrest) then
      head = (h1 - h2)
    else
      head = (h1 - hcrest)
    end
    f = (head / G_Orifice[k].hCrit)
    f = (((((f) <= (1.0))) and (f) or (1.0)))
  else
    hcrest = (G_Node[n1].invertElev + G_Link[j].offset1)
    hcrown = (hcrest + (G_Link[j].xsect.yFull * G_Link[j].setting))
    hmidpt = (((hcrest + hcrown)) / 2.0)
    if ((h1 < hcrown) and (hcrown > hcrest)) then
      f = (((h1 - hcrest)) / ((hcrown - hcrest)))
    else
      f = 1.0
    end
    if (f < 1.0) then
      head = (h1 - hcrest)
    elseif (h2 < hmidpt) then
      head = (h1 - hmidpt)
    else
      head = (h1 - h2)
    end
  end
  if (((head <= 0.0001) or (y1 <= 0.0001)) or (F.link_setFlapGate(j, n1, n2, dir) ~= 0)) then
    G_Link[j].newDepth = 0.0
    G_Link[j].flowClass = DRY
    G_Orifice[k].surfArea = (0.0001 * G_Orifice[k].length)
    G_Link[j].dqdh = 0.0
    do return 0.0 end
  end
  G_Link[j].flowClass = SUBCRITICAL
  if (hcrest > h2) then
    if (dir == 1.0) then
      G_Link[j].flowClass = DN_CRITICAL
    else
      G_Link[j].flowClass = UP_CRITICAL
    end
  end
  y1 = (G_Link[j].xsect.yFull * G_Link[j].setting)
  if (G_Orifice[k].type_ == SIDE_ORIFICE) then
    G_Link[j].newDepth = (y1 * f)
    G_Orifice[k].surfArea = (F.xsect_getWofY(G_Link[j].xsect, G_Link[j].newDepth) * G_Orifice[k].length)
  else
    G_Link[j].newDepth = y1
    G_Orifice[k].surfArea = F.xsect_getAofY(G_Link[j].xsect, y1)
  end
  q = (dir * F.orifice_getFlow(j, k, head, f, G_Link[j].hasFlapGate))
  if ((f < 1.0) and (h2 > hcrest)) then
    ratio = (((h2 - hcrest)) / ((h1 - hcrest)))
    q = (q * (((1.0 - (ratio ^ 1.5))) ^ 0.385))
  end
  do return q end
end

-- link.c:1938
F.orifice_getFlow = function(j, k, head, f, hasFlapGate)
  local G_Link, G_Orifice = G.Link, G.Orifice
  local area = 0.0
  local q = 0.0
  local veloc = 0.0
  local hLoss = 0.0
  if ((head == 0.0) or (f <= 0.0)) then
    G_Link[j].dqdh = 0.0
    do return 0.0 end
  elseif (f < 1.0) then
    q = (G_Orifice[k].cWeir * (f ^ 1.5))
    G_Link[j].dqdh = ((1.5 * q) / ((f * G_Orifice[k].hCrit)))
  else
    q = (G_Orifice[k].cOrif * m_sqrt(head))
    G_Link[j].dqdh = (q / ((2.0 * head)))
  end
  if (hasFlapGate ~= 0) then
    area = F.xsect_getAofY(G_Link[j].xsect, (G_Link[j].setting * G_Link[j].xsect.yFull))
    veloc = (q / area)
    hLoss = (((((4.0 / 32.2)) * veloc) * veloc) * m_exp((((-1.15) * veloc) / m_sqrt(head))))
    if (f < 1.0) then
      f = (f - (hLoss / G_Orifice[k].hCrit))
      if (f < 0.0) then
        f = 0.0
      end
    else
      head = (head - hLoss)
      if (head < 0.0) then
        head = 0.0
      end
    end
    q = F.orifice_getFlow(j, k, head, f, 0)
  end
  do return q end
end

-- link.c:2010
F.weir_readParams = function(j, k, tok, ntoks)
  local G_NoYesWords = G.NoYesWords
  local m = 0
  local n1 = 0
  local n2 = 0
  local x = R.fill(10, 0.0)
  local id = nil
  if (ntoks < 6) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  id = F.project_findID(LINK, tok[0])
  if R.peq(id, (nil)) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  n1 = F.project_findObject(NODE, tok[1])
  if (n1 < 0) then
    do return F.error_setInpError(ERR_NAME, tok[1]) end
  end
  n2 = F.project_findObject(NODE, tok[2])
  if (n2 < 0) then
    do return F.error_setInpError(ERR_NAME, tok[2]) end
  end
  m = F.findmatch(tok[3], G.WeirTypeWords)
  if (m < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[3]) end
  end
  x[0] = (m * 1.0)
  if ((G.LinkOffsets == ELEV_OFFSET) and (tok[4].b[tok[4].o] == 42)) then
    x[1] = (-10000000000.0)
  elseif (not (F.getDouble(tok[4], x, 1) ~= 0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[4]) end
  end
  if ((not (F.getDouble(tok[5], x, 2) ~= 0)) or (x[2] < 0.0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[5]) end
  end
  x[3] = 0.0
  x[4] = 0.0
  x[5] = 0.0
  x[6] = 1.0
  x[7] = 0.0
  x[8] = 0.0
  x[9] = (-1.0)
  if ((ntoks >= 7) and (tok[6].b[tok[6].o] ~= 42)) then
    m = F.findmatch(tok[6], G_NoYesWords)
    if (m < 0) then
      do return F.error_setInpError(ERR_KEYWORD, tok[6]) end
    end
    x[3] = (m * 1.0)
  end
  if ((ntoks >= 8) and (tok[7].b[tok[7].o] ~= 42)) then
    if ((not (F.getDouble(tok[7], x, 4) ~= 0)) or (x[4] < 0.0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[7]) end
    end
  end
  if ((ntoks >= 9) and (tok[8].b[tok[8].o] ~= 42)) then
    if ((not (F.getDouble(tok[8], x, 5) ~= 0)) or (x[5] < 0.0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[8]) end
    end
  end
  if ((ntoks >= 10) and (tok[9].b[tok[9].o] ~= 42)) then
    m = F.findmatch(tok[9], G_NoYesWords)
    if (m < 0) then
      do return F.error_setInpError(ERR_KEYWORD, tok[9]) end
    end
    x[6] = (m * 1.0)
  end
  m = R.D2I(x[0])
  if ((m) == ROADWAY_WEIR) then
    if (ntoks >= 11) then
      if ((not (F.getDouble(tok[10], x, 7) ~= 0)) or (x[7] < 0.0)) then
        do return F.error_setInpError(ERR_NUMBER, tok[10]) end
      end
    end
    if (ntoks >= 12) then
      if (F.strcomp(tok[11], S[311]) ~= 0) then
        x[8] = 1.0
      elseif (F.strcomp(tok[11], S[312]) ~= 0) then
        x[8] = 2.0
      end
    end
  end
  if ((ntoks >= 13) and (tok[12].b[tok[12].o] ~= 42)) then
    m = F.project_findObject(CURVE, tok[12])
    if (m < 0) then
      do return F.error_setInpError(ERR_NAME, tok[12]) end
    end
    x[9] = (m * 1.0)
  end
  G.Link[j].ID = id
  F.link_setParams(j, WEIR, n1, n2, k, x)
  do return 0 end
end

-- link.c:2103
F.weir_validate = function(j, k)
  local G_Weir, G_Link = G.Weir, G.Link
  local err = 0
  local q = 0.0
  local q1 = {0.0}
  local q2 = {0.0}
  local head = 0.0
  do
    local __sw1 = G_Weir[k].type_
    if __sw1 == TRANSVERSE_WEIR or __sw1 == SIDEFLOW_WEIR or __sw1 == ROADWAY_WEIR then goto case2
    elseif __sw1 == VNOTCH_WEIR then goto case3
    elseif __sw1 == TRAPEZOIDAL_WEIR then goto case4
    else goto swend1 end
    ::case2::
    do
      if (G_Link[j].xsect.type_ ~= RECT_OPEN) then
        err = ERR_REGULATOR_SHAPE
      end
      G_Weir[k].slope = 0.0
      goto swend1
    end
    ::case3::
    do
      if (G_Link[j].xsect.type_ ~= TRIANGULAR) then
        err = ERR_REGULATOR_SHAPE
      else
        G_Weir[k].slope = G_Link[j].xsect.sBot
      end
      goto swend1
    end
    ::case4::
    do
      if (G_Link[j].xsect.type_ ~= TRAPEZOIDAL) then
        err = ERR_REGULATOR_SHAPE
      else
        G_Weir[k].slope = G_Link[j].xsect.sBot
      end
      goto swend1
    end
    ::swend1::
  end
  if (err > 0) then
    F.report_writeErrorMsg(err, G_Link[j].ID)
    do return end
  end
  if (G_Link[j].offset1 < 0.0) then
    G_Link[j].offset1 = 0.0
  end
  G_Weir[k].length = ((2.0 * G.RouteStep) * m_sqrt((32.2 * G_Link[j].xsect.yFull)))
  G_Weir[k].length = (((((200.0) >= (G_Weir[k].length))) and (200.0) or (G_Weir[k].length)))
  G_Weir[k].surfArea = 0.0
  head = G_Link[j].xsect.yFull
  F.weir_getFlow(j, k, head, 1.0, 0, q1, 1, q2, 1)
  q = (q1[1] + q2[1])
  head = (head / 2.0)
  G_Weir[k].cSurcharge = (q / m_sqrt(head))
end

-- link.c:2166
F.weir_setSetting = function(j)
  local G_Link, G_Weir = G.Link, G.Weir
  local k = G_Link[j].subIndex
  local h = 0.0
  local q = 0.0
  local q1 = {0.0}
  local q2 = {0.0}
  G_Link[j].setting = G_Link[j].targetSetting
  if (not (G_Weir[k].canSurcharge ~= 0)) then
    do return end
  end
  if (G_Weir[k].type_ == ROADWAY_WEIR) then
    do return end
  end
  if (G_Link[j].setting == 0.0) then
    G_Weir[k].cSurcharge = 0.0
  else
    h = (G_Link[j].setting * G_Link[j].xsect.yFull)
    F.weir_getFlow(j, k, h, 1.0, 0, q1, 1, q2, 1)
    q = (q1[1] + q2[1])
    h = (h / 2.0)
    G_Weir[k].cSurcharge = (q / m_sqrt(h))
  end
end

-- link.c:2198
F.weir_getInflow = function(j)
  local G_Link, G_Node, G_Weir = G.Link, G.Node, G.Weir
  local n1 = 0
  local n2 = 0
  local k = 0
  local q1 = {0.0}
  local q2 = {0.0}
  local head = 0.0
  local h1 = 0.0
  local h2 = 0.0
  local hcrest = 0.0
  local hcrown = 0.0
  local y = 0.0
  local dir = 0.0
  local ratio = 0.0
  local weirPower = {[0] = 1.5, (5.0 / 3.0), 2.5, 1.5}
  n1 = G_Link[j].node1
  n2 = G_Link[j].node2
  k = G_Link[j].subIndex
  if (G.RouteModel == DW) then
    h1 = (G_Node[n1].newDepth + G_Node[n1].invertElev)
    h2 = (G_Node[n2].newDepth + G_Node[n2].invertElev)
  else
    h1 = (G_Node[n1].newDepth + G_Node[n1].invertElev)
    h2 = G_Node[n1].invertElev
  end
  dir = (((h1 > h2)) and 1.0 or (-1.0))
  if (dir < 0.0) then
    head = h1
    h1 = h2
    h2 = head
  end
  hcrest = (G_Node[n1].invertElev + G_Link[j].offset1)
  hcrown = (hcrest + G_Link[j].xsect.yFull)
  if (G_Weir[k].type_ == ROADWAY_WEIR) then
    do return F.roadway_getInflow(j, dir, hcrest, h1, h2) end
  end
  hcrest = (hcrest + (((1.0 - G_Link[j].setting)) * G_Link[j].xsect.yFull))
  head = (h1 - hcrest)
  G_Link[j].dqdh = 0.0
  if (((head <= 0.0001) or (hcrest >= hcrown)) or (F.link_setFlapGate(j, n1, n2, dir) ~= 0)) then
    G_Link[j].newDepth = 0.0
    G_Link[j].flowClass = DRY
    do return 0.0 end
  end
  G_Link[j].flowClass = SUBCRITICAL
  if (hcrest > h2) then
    if (dir == 1.0) then
      G_Link[j].flowClass = DN_CRITICAL
    else
      G_Link[j].flowClass = UP_CRITICAL
    end
  end
  y = (G_Link[j].xsect.yFull - ((hcrown - (((((h1) <= (hcrown))) and (h1) or (hcrown))))))
  G_Weir[k].surfArea = (F.xsect_getWofY(G_Link[j].xsect, y) * G_Weir[k].length)
  if (h1 >= hcrown) then
    if (G_Weir[k].canSurcharge ~= 0) then
      y = (((hcrest + hcrown)) / 2.0)
      if (h2 < y) then
        head = (h1 - y)
      else
        head = (h1 - h2)
      end
      y = (hcrown - hcrest)
      q1[1] = F.weir_getOrificeFlow(j, head, y, G_Weir[k].cSurcharge)
      G_Link[j].newDepth = y
      do return (dir * q1[1]) end
    else
      head = (hcrown - hcrest)
    end
  end
  F.weir_getFlow(j, k, head, dir, G_Link[j].hasFlapGate, q1, 1, q2, 1)
  if (h2 > hcrest) then
    ratio = (((h2 - hcrest)) / ((h1 - hcrest)))
    q1[1] = (q1[1] * (((1.0 - R.pow(ratio, weirPower[G_Weir[k].type_]))) ^ 0.385))
    if (q2[1] > 0.0) then
      q2[1] = (q2[1] * (((1.0 - R.pow(ratio, weirPower[VNOTCH_WEIR]))) ^ 0.385))
    end
  end
  G_Link[j].newDepth = (((((((h1 - hcrest))) <= (G_Link[j].xsect.yFull))) and (((h1 - hcrest))) or (G_Link[j].xsect.yFull)))
  do return (dir * ((q1[1] + q2[1]))) end
end

-- link.c:2321
F.weir_getFlow = function(j, k, head, dir, hasFlapGate, q1, q1__k, q2, q2__k)
  local G_Weir, G_Link = G.Weir, G.Link
  local length = 0.0
  local h = 0.0
  local y = 0.0
  local hLoss = 0.0
  local area = 0.0
  local veloc = 0.0
  local wType = 0
  local cdCurve = G_Weir[k].cdCurve
  local cDisch1 = G_Weir[k].cDisch1
  q1[q1__k] = 0.0
  q2[q2__k] = 0.0
  G_Link[j].dqdh = 0.0
  if (head <= 0.0) then
    do return end
  end
  length = (G_Link[j].xsect.wMax * F.UCF(LENGTH))
  h = (head * F.UCF(LENGTH))
  if (cdCurve >= 0) then
    cDisch1 = F.table_lookup(G.Curve[cdCurve], h)
  end
  wType = G_Weir[k].type_
  if ((wType == VNOTCH_WEIR) and (G_Link[j].setting < 1.0)) then
    wType = TRAPEZOIDAL_WEIR
  end
  do
    local __sw1 = wType
    if __sw1 == TRANSVERSE_WEIR then goto case2
    elseif __sw1 == SIDEFLOW_WEIR then goto case3
    elseif __sw1 == VNOTCH_WEIR then goto case4
    elseif __sw1 == TRAPEZOIDAL_WEIR then goto case5
    else goto swend1 end
    ::case2::
    do
      length = (length - ((0.1 * G_Weir[k].endCon) * h))
      length = (((((length) >= (0.0))) and (length) or (0.0)))
      q1[q1__k] = ((cDisch1 * length) * (h ^ 1.5))
      goto swend1
    end
    ::case3::
    do
      length = (length - ((0.1 * G_Weir[k].endCon) * h))
      length = (((((length) >= (0.0))) and (length) or (0.0)))
      if (dir < 0.0) then
        q1[q1__k] = ((cDisch1 * length) * (h ^ 1.5))
      else
        q1[q1__k] = ((cDisch1 * (length ^ 0.83)) * (h ^ 1.67))
      end
      goto swend1
    end
    ::case4::
    do
      q1[q1__k] = ((cDisch1 * G_Weir[k].slope) * (h ^ 2.5))
      goto swend1
    end
    ::case5::
    do
      y = (((1.0 - G_Link[j].setting)) * G_Link[j].xsect.yFull)
      length = (F.xsect_getWofY(G_Link[j].xsect, y) * F.UCF(LENGTH))
      q1[q1__k] = ((cDisch1 * length) * (h ^ 1.5))
      q2[q2__k] = ((G_Weir[k].cDisch2 * G_Weir[k].slope) * (h ^ 2.5))
    end
    ::swend1::
  end
  if (G.UnitSystem == SI) then
    q1[q1__k] = (q1[q1__k] / 0.028317)
    q2[q2__k] = (q2[q2__k] / 0.028317)
  end
  if (hasFlapGate ~= 0) then
    area = F.weir_getOpenArea(j, head)
    if (area > 1e-06) then
      veloc = (((q1[q1__k] + q2[q2__k])) / area)
      hLoss = (((((4.0 / 32.2)) * veloc) * veloc) * m_exp((((-1.15) * veloc) / m_sqrt(head))))
      head = (head - hLoss)
      if (head < 0.0) then
        head = 0.0
      end
      F.weir_getFlow(j, k, head, dir, 0, q1, q1__k, q2, q2__k)
    end
  end
  G_Link[j].dqdh = F.weir_getdqdh(k, dir, head, q1[q1__k], q2[q2__k])
end

-- link.c:2432
F.weir_getOrificeFlow = function(j, head, y, cOrif)
  local G_Link = G.Link
  local a = 0.0
  local q = 0.0
  local v = 0.0
  local hloss = 0.0
  q = (cOrif * m_sqrt(head))
  if (G_Link[j].hasFlapGate ~= 0) then
    a = F.weir_getOpenArea(j, y)
    if (a > 0.0) then
      v = (q / a)
      hloss = (((((4.0 / 32.2)) * v) * v) * m_exp((((-1.15) * v) / m_sqrt(y))))
      head = (head - hloss)
      head = (((((head) >= (0.0))) and (head) or (0.0)))
      q = (cOrif * m_sqrt(head))
    end
  end
  if (head > 0.0) then
    G_Link[j].dqdh = (q / ((2.0 * head)))
  else
    G_Link[j].dqdh = 0.0
  end
  do return q end
end

-- link.c:2467
F.weir_getOpenArea = function(j, y)
  local G_Link = G.Link
  local z = 0.0
  local zy = 0.0
  z = (((1.0 - G_Link[j].setting)) * G_Link[j].xsect.yFull)
  zy = (z + y)
  zy = (((((zy) <= (G_Link[j].xsect.yFull))) and (zy) or (G_Link[j].xsect.yFull)))
  do return (F.xsect_getAofY(G_Link[j].xsect, zy) - F.xsect_getAofY(G_Link[j].xsect, z)) end
end

-- link.c:2492
F.weir_getdqdh = function(k, dir, h, q1, q2)
  local q1h = 0.0
  local q2h = 0.0
  if (m_abs(h) < 0.0001) then
    do return 0.0 end
  end
  q1h = m_abs((q1 / h))
  q2h = m_abs((q2 / h))
  do
    local __sw1 = G.Weir[k].type_
    if __sw1 == TRANSVERSE_WEIR then goto case2
    elseif __sw1 == SIDEFLOW_WEIR then goto case3
    elseif __sw1 == VNOTCH_WEIR then goto case4
    elseif __sw1 == TRAPEZOIDAL_WEIR then goto case5
    else goto swend1 end
    ::case2::
    do
      do return (1.5 * q1h) end
    end
    ::case3::
    do
      if (dir < 0.0) then
        do return (1.5 * q1h) end
      else
        do return (1.67 * q1h) end
      end
    end
    ::case4::
    do
      if (q2h == 0.0) then
        do return (2.5 * q1h) end
      else
        do return ((1.5 * q1h) + (2.5 * q2h)) end
      end
    end
    ::case5::
    do
      do return ((1.5 * q1h) + (2.5 * q2h)) end
    end
    ::swend1::
  end
  do return 0.0 end
end

-- link.c:2524
F.outlet_readParams = function(j, k, tok, ntoks)
  local i = 0
  local m = 0
  local n = 0
  local n1 = 0
  local n2 = 0
  local x = R.fill(6, 0.0)
  local id = nil
  local s = nil
  if (ntoks < 6) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  id = F.project_findID(LINK, tok[0])
  if R.peq(id, (nil)) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  n1 = F.project_findObject(NODE, tok[1])
  if (n1 < 0) then
    do return F.error_setInpError(ERR_NAME, tok[1]) end
  end
  n2 = F.project_findObject(NODE, tok[2])
  if (n2 < 0) then
    do return F.error_setInpError(ERR_NAME, tok[2]) end
  end
  if ((G.LinkOffsets == ELEV_OFFSET) and (tok[3].b[tok[3].o] == 42)) then
    x[0] = (-10000000000.0)
  else
    if (not (F.getDouble(tok[3], x, 0) ~= 0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[3]) end
    end
    if ((G.LinkOffsets == DEPTH_OFFSET) and (x[0] < 0.0)) then
      x[0] = 0.0
    end
  end
  m = F.findmatch(tok[4], G.RelationWords)
  if (m < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[4]) end
  end
  x[1] = 0.0
  x[2] = 0.0
  x[3] = (-1.0)
  x[4] = 0.0
  x[5] = (NODE_DEPTH * 1.0)
  s = R.strtok(tok[4], S[313])
  s = R.strtok((nil), S[313])
  if (F.strcomp(s, S[314]) ~= 0) then
    x[5] = (NODE_HEAD * 1.0)
  end
  if (m == FUNCTIONAL) then
    if (ntoks < 7) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    if (not (F.getDouble(tok[5], x, 1) ~= 0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[5]) end
    end
    if (not (F.getDouble(tok[6], x, 2) ~= 0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[6]) end
    end
    n = 7
  else
    i = F.project_findObject(CURVE, tok[5])
    if (i < 0) then
      do return F.error_setInpError(ERR_NAME, tok[5]) end
    end
    x[3] = (i * 1.0)
    n = 6
  end
  if (ntoks > n) then
    i = F.findmatch(tok[n], G.NoYesWords)
    if (i < 0) then
      do return F.error_setInpError(ERR_KEYWORD, tok[n]) end
    end
    x[4] = (i * 1.0)
  end
  G.Link[j].ID = id
  F.link_setParams(j, OUTLET, n1, n2, k, x)
  do return 0 end
end

-- link.c:2608
F.outlet_getInflow = function(j)
  local G_Link, G_Node = G.Link, G.Node
  local k = 0
  local n1 = 0
  local n2 = 0
  local head = 0.0
  local hcrest = 0.0
  local h1 = 0.0
  local h2 = 0.0
  local y1 = 0.0
  local dir = 0.0
  n1 = G_Link[j].node1
  n2 = G_Link[j].node2
  k = G_Link[j].subIndex
  if (G.RouteModel == DW) then
    h1 = (G_Node[n1].newDepth + G_Node[n1].invertElev)
    h2 = (G_Node[n2].newDepth + G_Node[n2].invertElev)
  else
    h1 = (G_Node[n1].newDepth + G_Node[n1].invertElev)
    h2 = G_Node[n1].invertElev
  end
  dir = (((h1 >= h2)) and 1.0 or (-1.0))
  y1 = G_Node[n1].newDepth
  if (dir < 0.0) then
    y1 = h1
    h1 = h2
    h2 = y1
    y1 = G_Node[n2].newDepth
  end
  hcrest = (G_Node[n1].invertElev + G_Link[j].offset1)
  if ((G.Outlet[k].curveType == NODE_HEAD) and (G.RouteModel == DW)) then
    head = (h1 - (((((h2) >= (hcrest))) and (h2) or (hcrest))))
  else
    head = (h1 - hcrest)
  end
  if (((head <= 0.0001) or (y1 <= 0.0001)) or (F.link_setFlapGate(j, n1, n2, dir) ~= 0)) then
    G_Link[j].newDepth = 0.0
    G_Link[j].flowClass = DRY
    do return 0.0 end
  end
  G_Link[j].newDepth = head
  G_Link[j].flowClass = SUBCRITICAL
  do return ((dir * G_Link[j].setting) * F.outlet_getFlow(k, head)) end
end

-- link.c:2672
F.outlet_getFlow = function(k, head)
  local G_Outlet = G.Outlet
  local m = 0
  local h = 0.0
  h = (head * F.UCF(LENGTH))
  m = G_Outlet[k].qCurve
  if (m >= 0) then
    do return (F.table_lookup(G.Curve[m], h) / F.UCF(FLOW)) end
  else
    do return ((G_Outlet[k].qCoeff * R.pow(h, G_Outlet[k].qExpon)) / F.UCF(FLOW)) end
  end
end

