-- Generated from EPA SWMM 5.2.4 (node.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local JUNCTION <const> = 0
local OUTFALL <const> = 1
local STORAGE <const> = 2
local DIVIDER <const> = 3
local LENGTH <const> = 3
local NO_INLET <const> = 0
local POLLUT <const> = 4
local FLOW <const> = 10
local ERR_NODE_DEPTH <const> = 138
local ERR_STORAGE_VOLUME <const> = 140
local DW <const> = 4
local NODE_DEPTH <const> = 0
local NODE_HEAD <const> = 1
local VOLUME <const> = 5
local NODE_VOLUME <const> = 2
local NODE_LATFLOW <const> = 3
local NODE_INFLOW <const> = 4
local NODE_OVERFLOW <const> = 5
local NODE_QUAL <const> = 6
local ERR_ITEMS <const> = 203
local NODE <const> = 2
local ERR_NAME <const> = 209
local ERR_NUMBER <const> = 211
local ERR_KEYWORD <const> = 205
local TABULAR <const> = 0
local CURVE <const> = 7
local FUNCTIONAL <const> = 1
local CYLINDRICAL <const> = 2
local CONICAL <const> = 3
local PARABOLOID <const> = 4
local PYRAMIDAL <const> = 5
local CONDUIT <const> = 0
local LINK <const> = 3
local TABULAR_DIVIDER <const> = 1
local CUTOFF_DIVIDER <const> = 0
local WEIR_DIVIDER <const> = 2
local OVERFLOW_DIVIDER <const> = 3
local ERR_DIVIDER_LINK <const> = 136
local ERR_WEIR_DIVIDER <const> = 137
local FIXED_OUTFALL <const> = 2
local TIDAL_OUTFALL <const> = 3
local TIMESERIES_OUTFALL <const> = 4
local TSERIES <const> = 8
local SUBCATCH <const> = 1
local FREE_OUTFALL <const> = 0
local NORMAL_OUTFALL <const> = 1
local _ENV = R.strict


-- node.c:102
F.node_readParams = function(j, type_, k, tok, ntoks)
  do
    local __sw1 = type_
    if __sw1 == JUNCTION then goto case2
    elseif __sw1 == OUTFALL then goto case3
    elseif __sw1 == STORAGE then goto case4
    elseif __sw1 == DIVIDER then goto case5
    else goto case6 end
    ::case2::
    do
      do return F.junc_readParams(j, k, tok, ntoks) end
    end
    ::case3::
    do
      do return F.outfall_readParams(j, k, tok, ntoks) end
    end
    ::case4::
    do
      do return F.storage_readParams(j, k, tok, ntoks) end
    end
    ::case5::
    do
      do return F.divider_readParams(j, k, tok, ntoks) end
    end
    ::case6::
    do
      do return 0 end
    end
    ::swend1::
  end
end

-- node.c:125
F.node_setParams = function(j, type_, k, x)
  local G_Node, G_Outfall, G_Storage, G_Divider = G.Node, G.Outfall, G.Storage, G.Divider
  G_Node[j].type_ = type_
  G_Node[j].subIndex = k
  G_Node[j].invertElev = (x[0] / F.UCF(LENGTH))
  G_Node[j].crownElev = G_Node[j].invertElev
  G_Node[j].initDepth = 0.0
  G_Node[j].newVolume = 0.0
  G_Node[j].fullVolume = 0.0
  G_Node[j].fullDepth = 0.0
  G_Node[j].surDepth = 0.0
  G_Node[j].pondedArea = 0.0
  G_Node[j].degree = 0
  G_Node[j].inlet = NO_INLET
  do
    local __sw1 = type_
    if __sw1 == JUNCTION then goto case2
    elseif __sw1 == OUTFALL then goto case3
    elseif __sw1 == STORAGE then goto case4
    elseif __sw1 == DIVIDER then goto case5
    else goto swend1 end
    ::case2::
    do
      G_Node[j].fullDepth = (x[1] / F.UCF(LENGTH))
      G_Node[j].initDepth = (x[2] / F.UCF(LENGTH))
      G_Node[j].surDepth = (x[3] / F.UCF(LENGTH))
      G_Node[j].pondedArea = (x[4] / ((F.UCF(LENGTH) * F.UCF(LENGTH))))
      goto swend1
    end
    ::case3::
    do
      G_Outfall[k].type_ = R.D2I(x[1])
      G_Outfall[k].fixedStage = (x[2] / F.UCF(LENGTH))
      G_Outfall[k].tideCurve = R.D2I(x[3])
      G_Outfall[k].stageSeries = R.D2I(x[4])
      G_Outfall[k].hasFlapGate = R.i8(R.D2I(x[5]))
      G_Outfall[k].routeTo = R.D2I(x[6])
      G_Outfall[k].wRouted = (nil)
      if (G_Outfall[k].routeTo >= 0) then
        G_Outfall[k].wRouted = R.fill(G.Nobjects[POLLUT], 0.0)
      end
      goto swend1
    end
    ::case4::
    do
      G_Node[j].fullDepth = (x[1] / F.UCF(LENGTH))
      G_Node[j].initDepth = (x[2] / F.UCF(LENGTH))
      G_Storage[k].shape = R.D2I(x[3])
      G_Storage[k].a1 = x[4]
      G_Storage[k].a2 = x[5]
      G_Storage[k].a0 = x[6]
      G_Storage[k].aCurve = R.D2I(x[7])
      G_Node[j].surDepth = (x[8] / F.UCF(LENGTH))
      G_Storage[k].fEvap = x[9]
      goto swend1
    end
    ::case5::
    do
      G_Divider[k].link = R.D2I(x[1])
      G_Divider[k].type_ = R.D2I(x[2])
      G_Divider[k].flowCurve = R.D2I(x[3])
      G_Divider[k].qMin = (x[4] / F.UCF(FLOW))
      G_Divider[k].dhMax = x[5]
      G_Divider[k].cWeir = x[6]
      G_Node[j].fullDepth = (x[7] / F.UCF(LENGTH))
      G_Node[j].initDepth = (x[8] / F.UCF(LENGTH))
      G_Node[j].surDepth = (x[9] / F.UCF(LENGTH))
      G_Node[j].pondedArea = (x[10] / ((F.UCF(LENGTH) * F.UCF(LENGTH))))
      goto swend1
    end
    ::swend1::
  end
end

-- node.c:200
F.node_validate = function(j)
  local G_Node = G.Node
  local inflow = nil
  if ((G_Node[j].fullDepth > G_Node[j].oldDepth) and (G_Node[j].oldDepth > 0.0)) then
    F.report_writeWarningMsg(S[317], G_Node[j].ID)
  end
  if (G_Node[j].initDepth > (G_Node[j].fullDepth + G_Node[j].surDepth)) then
    F.report_writeErrorMsg(ERR_NODE_DEPTH, G_Node[j].ID)
  end
  if (G_Node[j].type_ == STORAGE) then
    if (F.node_getVolume(j, G_Node[j].fullDepth) < 0.0) then
      F.report_writeErrorMsg(ERR_STORAGE_VOLUME, G_Node[j].ID)
    end
  end
  if (G_Node[j].type_ == DIVIDER) then
    F.divider_validate(j)
  end
  inflow = G_Node[j].dwfInflow
  while (inflow ~= nil) do
    do
      F.inflow_initDwfInflow(inflow)
      inflow = inflow.next_
    end
  end
end

-- node.c:237
F.node_initState = function(j)
  local G_Node, G_Nobjects, G_Storage, G_Outfall = G.Node, G.Nobjects, G.Storage, G.Outfall
  local p = 0
  local k = 0
  G_Node[j].oldDepth = G_Node[j].initDepth
  G_Node[j].newDepth = G_Node[j].oldDepth
  G_Node[j].crownElev = G_Node[j].invertElev
  G_Node[j].fullVolume = F.node_getVolume(j, G_Node[j].fullDepth)
  G_Node[j].oldVolume = F.node_getVolume(j, G_Node[j].oldDepth)
  G_Node[j].newVolume = G_Node[j].oldVolume
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        G_Node[j].oldQual[p] = 0.0
        G_Node[j].newQual[p] = 0.0
      end
      p = p + 1
    end
  end
  G_Node[j].oldLatFlow = 0.0
  G_Node[j].newLatFlow = 0.0
  G_Node[j].apiExtInflow = 0.0
  G_Node[j].losses = 0.0
  if (G_Node[j].type_ == STORAGE) then
    k = G_Node[j].subIndex
    G_Storage[k].hrt = 0.0
    if (G_Storage[k].exfil ~= nil) then
      F.exfil_initState(k)
    end
  end
  if (G_Node[j].type_ == OUTFALL) then
    k = G_Node[j].subIndex
    if (G_Outfall[k].routeTo >= 0) then
      G_Outfall[k].vRouted = 0.0
      do
        p = 0
        while (p < G_Nobjects[POLLUT]) do
          do
            G_Outfall[k].wRouted[p] = 0.0
          end
          p = p + 1
        end
      end
    end
  end
end

-- node.c:293
F.node_setOldHydState = function(j)
  local G_Node = G.Node
  G_Node[j].oldDepth = G_Node[j].newDepth
  G_Node[j].oldVolume = G_Node[j].newVolume
  G_Node[j].oldFlowInflow = G_Node[j].inflow
  G_Node[j].oldNetInflow = (G_Node[j].inflow - G_Node[j].outflow)
end

-- node.c:308
F.node_setOldQualState = function(j)
  local G_Nobjects, G_Node = G.Nobjects, G.Node
  local p = 0
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        G_Node[j].oldQual[p] = G_Node[j].newQual[p]
        G_Node[j].newQual[p] = 0.0
      end
      p = p + 1
    end
  end
end

-- node.c:325
F.node_initFlows = function(j, tStep)
  local G_Node = G.Node
  G_Node[j].inflow = G_Node[j].newLatFlow
  G_Node[j].outflow = G_Node[j].losses
  if (G_Node[j].newVolume > G_Node[j].fullVolume) then
    G_Node[j].overflow = (((G_Node[j].newVolume - G_Node[j].fullVolume)) / tStep)
  else
    G_Node[j].overflow = 0.0
  end
end

-- node.c:345
F.node_getDepth = function(j, v)
  do
    local __sw1 = G.Node[j].type_
    if __sw1 == STORAGE then goto case2
    else goto case3 end
    ::case2::
    do
      do return F.storage_getDepth(j, v) end
    end
    ::case3::
    do
      do return 0.0 end
    end
    ::swend1::
  end
end

-- node.c:362
F.node_getVolume = function(j, d)
  local G_Node = G.Node
  do
    local __sw1 = G_Node[j].type_
    if __sw1 == STORAGE then goto case2
    else goto case3 end
    ::case2::
    do
      do return F.storage_getVolume(j, d) end
    end
    ::case3::
    do
      if (G_Node[j].fullDepth > 0.0) then
        do return (G_Node[j].fullVolume * ((d / G_Node[j].fullDepth))) end
      else
        do return 0.0 end
      end
    end
    ::swend1::
  end
end

-- node.c:383
F.node_getSurfArea = function(j, d)
  do
    local __sw1 = G.Node[j].type_
    if __sw1 == STORAGE then goto case2
    else goto case3 end
    ::case2::
    do
      do return F.storage_getSurfArea(j, d) end
    end
    ::case3::
    do
      do return 0.0 end
    end
    ::swend1::
  end
end

-- node.c:400
F.node_getOutflow = function(j, k)
  local G_Node = G.Node
  do
    local __sw1 = G_Node[j].type_
    if __sw1 == DIVIDER then goto case2
    elseif __sw1 == STORAGE then goto case3
    else goto case4 end
    ::case2::
    do
      do return F.divider_getOutflow(j, k) end
    end
    ::case3::
    do
      do return F.storage_getOutflow(j, k) end
    end
    ::case4::
    do
      do return (G_Node[j].inflow + G_Node[j].overflow) end
    end
    ::swend1::
  end
end

-- node.c:418
F.node_getMaxOutflow = function(j, q, tStep)
  local G_Node = G.Node
  local qMax = 0.0
  if (G_Node[j].fullVolume > 0.0) then
    qMax = (G_Node[j].inflow + (G_Node[j].oldVolume / tStep))
    if (q > qMax) then
      q = qMax
    end
  end
  do return (((((0.0) >= (q))) and (0.0) or (q))) end
end

-- node.c:438
F.node_getSystemOutflow = function(j, isFlooded, isFlooded__k)
  local G_Node = G.Node
  local outflow = 0.0
  isFlooded[isFlooded__k] = 0
  if (G_Node[j].type_ == OUTFALL) then
    if (G_Node[j].outflow == 0.0) then
      outflow = G_Node[j].inflow
    else
      if (G_Node[j].inflow == 0.0) then
        outflow = (-G_Node[j].outflow)
        G_Node[j].inflow = m_abs(outflow)
      end
    end
    G_Node[j].overflow = 0.0
    G_Node[j].newVolume = 0.0
  elseif (((G.RouteModel ~= DW) and (G_Node[j].degree == 0)) and (G_Node[j].type_ ~= STORAGE)) then
    if (G_Node[j].outflow == 0.0) then
      outflow = G_Node[j].inflow
    end
    G_Node[j].overflow = 0.0
    G_Node[j].newVolume = 0.0
  else
    if (G_Node[j].newVolume <= G_Node[j].fullVolume) then
      outflow = G_Node[j].overflow
    end
    if (outflow > 0.0) then
      isFlooded[isFlooded__k] = 1
    end
  end
  do return outflow end
end

-- node.c:497
F.node_getResults = function(j, f, x)
  local G_Node, G_Nobjects = G.Node, G.Nobjects
  local p = 0
  local z = 0.0
  local f1 = (1.0 - f)
  z = ((((f1 * G_Node[j].oldDepth) + (f * G_Node[j].newDepth))) * F.UCF(LENGTH))
  x[NODE_DEPTH] = R.f32(z)
  z = (G_Node[j].invertElev * F.UCF(LENGTH))
  x[NODE_HEAD] = R.f32(x[NODE_DEPTH] + R.f32(z))
  z = ((((f1 * G_Node[j].oldVolume) + (f * G_Node[j].newVolume))) * F.UCF(VOLUME))
  x[NODE_VOLUME] = R.f32(z)
  z = ((((f1 * G_Node[j].oldLatFlow) + (f * G_Node[j].newLatFlow))) * F.UCF(FLOW))
  x[NODE_LATFLOW] = R.f32(z)
  z = ((((f1 * G_Node[j].oldFlowInflow) + (f * G_Node[j].inflow))) * F.UCF(FLOW))
  x[NODE_INFLOW] = R.f32(z)
  z = (G_Node[j].overflow * F.UCF(FLOW))
  x[NODE_OVERFLOW] = R.f32(z)
  if (not (G.IgnoreQuality ~= 0)) then
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          z = ((f1 * G_Node[j].oldQual[p]) + (f * G_Node[j].newQual[p]))
          x[(NODE_QUAL + p)] = R.f32(z)
        end
        p = p + 1
      end
    end
  end
end

-- node.c:532
F.node_setOutletDepth = function(j, yNorm, yCrit, z)
  local G_Node = G.Node
  do
    local __sw1 = G_Node[j].type_
    if __sw1 == STORAGE then goto case2
    elseif __sw1 == OUTFALL then goto case3
    else goto case4 end
    ::case2::
    do
      do return end
    end
    ::case3::
    do
      F.outfall_setOutletDepth(j, yNorm, yCrit, z)
      goto swend1
    end
    ::case4::
    do
      if (z > 0.0) then
        G_Node[j].newDepth = 0.0
      else
        G_Node[j].newDepth = (((((yNorm) <= (yCrit))) and (yNorm) or (yCrit)))
      end
    end
    ::swend1::
  end
end

-- node.c:562
F.node_getPondedArea = function(j, d)
  local G_Node = G.Node
  local a = 0.0
  if ((d <= G_Node[j].fullDepth) or (G_Node[j].pondedArea == 0.0)) then
    do return F.node_getSurfArea(j, d) end
  end
  d = (d - G_Node[j].fullDepth)
  a = G_Node[j].pondedArea
  if (a <= 0.0) then
    a = F.node_getSurfArea(j, G_Node[j].fullDepth)
  end
  do return a end
end

-- node.c:589
F.node_getLosses = function(j, tStep)
  if (G.Node[j].type_ == STORAGE) then
    do return F.storage_getLosses(j, tStep) end
  else
    do return 0.0 end
  end
end

-- node.c:606
F.junc_readParams = function(j, k, tok, ntoks)
  local i = 0
  local x = R.fill(6, 0.0)
  local id = nil
  if (ntoks < 2) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  id = F.project_findID(NODE, tok[0])
  if R.peq(id, (nil)) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  do
    i = 1
    while (i <= 5) do
      do
        x[(i - 1)] = 0.0
        if (i < ntoks) then
          if (not (F.getDouble(tok[i], x, (i - 1)) ~= 0)) then
            do return F.error_setInpError(ERR_NUMBER, tok[i]) end
          end
        end
      end
      i = i + 1
    end
  end
  do
    i = 1
    while (i <= 4) do
      do
        if (x[i] < 0.0) then
          do return F.error_setInpError(ERR_NUMBER, tok[(i + 1)]) end
        end
      end
      i = i + 1
    end
  end
  G.Node[j].ID = id
  F.node_setParams(j, JUNCTION, k, x)
  do return 0 end
end

-- node.c:654
F.storage_readParams = function(j, k, tok, ntoks)
  local i = 0
  local m = 0
  local n = 0
  local x = R.fill(10, 0.0)
  local y = R.fill(3, 0.0)
  local A = 0.0
  local B = 0.0
  local L = 0.0
  local W = 0.0
  local Z = 0.0
  local id = nil
  if (ntoks < 6) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  id = F.project_findID(NODE, tok[0])
  if R.peq(id, (nil)) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  do
    i = 1
    while (i <= 3) do
      do
        if (not (F.getDouble(tok[i], x, (i - 1)) ~= 0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[i]) end
        end
      end
      i = i + 1
    end
  end
  m = F.findmatch(tok[4], G.RelationWords)
  if (m < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[4]) end
  end
  x[3] = (m * 1.0)
  x[4] = 0.0
  x[5] = 0.0
  x[6] = 0.0
  x[7] = (-1.0)
  x[8] = 0.0
  x[9] = 0.0
  if (m == TABULAR) then
    i = F.project_findObject(CURVE, tok[5])
    if (i < 0) then
      do return F.error_setInpError(ERR_NAME, tok[5]) end
    end
    x[7] = (i * 1.0)
    n = 6
  else
    if (ntoks < 8) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    do
      i = 5
      while (i <= 7) do
        do
          if (not (F.getDouble(tok[i], y, (i - 5)) ~= 0)) then
            do return F.error_setInpError(ERR_NUMBER, tok[i]) end
          end
        end
        i = i + 1
      end
    end
    n = 8
  end
  do
    local __sw1 = m
    if __sw1 == FUNCTIONAL then goto case4
    elseif __sw1 == CYLINDRICAL or __sw1 == CONICAL or __sw1 == PARABOLOID or __sw1 == PYRAMIDAL then goto case5
    else goto swend3 end
    ::case4::
    do
      if (y[2] < 0.0) then
        do return F.error_setInpError(ERR_NUMBER, tok[7]) end
      end
      goto swend3
    end
    ::case5::
    do
      if (y[0] <= 0.0) then
        do return F.error_setInpError(ERR_NUMBER, tok[5]) end
      end
      if (y[1] <= 0.0) then
        do return F.error_setInpError(ERR_NUMBER, tok[6]) end
      end
      if (y[2] < 0.0) then
        do return F.error_setInpError(ERR_NUMBER, tok[7]) end
      end
      goto swend3
    end
    ::swend3::
  end
  if ((m == PARABOLOID) and (y[2] == 0.0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[7]) end
  end
  do
    local __sw2 = m
    if __sw2 == FUNCTIONAL then goto case7
    elseif __sw2 == CYLINDRICAL then goto case8
    elseif __sw2 == CONICAL then goto case9
    elseif __sw2 == PARABOLOID then goto case10
    elseif __sw2 == PYRAMIDAL then goto case11
    else goto swend6 end
    ::case7::
    do
      x[4] = y[0]
      x[5] = y[1]
      x[6] = y[2]
      goto swend6
    end
    ::case8::
    do
      A = (y[0] / 2.0)
      B = (y[1] / 2.0)
      x[4] = 0.0
      x[5] = 0.0
      x[6] = ((3.141592654 * A) * B)
      goto swend6
    end
    ::case9::
    do
      A = (y[0] / 2.0)
      B = (y[1] / 2.0)
      Z = y[2]
      x[4] = (((2.0 * 3.141592654) * B) * Z)
      x[5] = ((((3.141592654 * B) / A) * Z) * Z)
      x[6] = ((3.141592654 * A) * B)
      goto swend6
    end
    ::case10::
    do
      A = (y[0] / 2.0)
      B = (y[1] / 2.0)
      Z = y[2]
      x[4] = (((3.141592654 * A) * B) / Z)
      x[5] = 0.0
      x[6] = 0.0
      goto swend6
    end
    ::case11::
    do
      L = y[0]
      W = y[1]
      Z = y[2]
      x[4] = ((2.0 * ((L + W))) * Z)
      x[5] = ((4.0 * Z) * Z)
      x[6] = (L * W)
      goto swend6
    end
    ::swend6::
  end
  if (ntoks > n) then
    if (not (F.getDouble(tok[n], x, 8) ~= 0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[n]) end
    end
    n = n + 1
  end
  if (ntoks > n) then
    if (not (F.getDouble(tok[n], x, 9) ~= 0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[n]) end
    end
    n = n + 1
  end
  G.Node[j].ID = id
  F.node_setParams(j, STORAGE, k, x)
  if (ntoks > n) then
    do return F.exfil_readStorageParams(k, tok, ntoks, n) end
  end
  do return 0 end
end

-- node.c:813
F.storage_getDepth = function(j, v)
  local G_Node, G_Storage = G.Node, G.Storage
  local k = G_Node[j].subIndex
  local i = G_Storage[k].aCurve
  local shape = G_Storage[k].shape
  local a0 = G_Storage[k].a0
  local a1 = G_Storage[k].a1
  local a2 = G_Storage[k].a2
  local d = {0.0}
  local e = 0.0
  local storageVol = T.TStorageVol()
  if ((G_Node[j].fullVolume > 0.0) and (v >= G_Node[j].fullVolume)) then
    do return G_Node[j].fullDepth end
  end
  if (v == 0.0) then
    do return 0.0 end
  end
  v = (v * (F.UCF(VOLUME)))
  storageVol.k = k
  storageVol.v = v
  do
    local __sw1 = shape
    if __sw1 < CONICAL then
      if __sw1 == TABULAR then goto case2
      elseif __sw1 == FUNCTIONAL then goto case5
      elseif __sw1 == CYLINDRICAL then goto case3
      end
    else
      if __sw1 == CONICAL then goto case6
      elseif __sw1 == PARABOLOID then goto case4
      elseif __sw1 == PYRAMIDAL then goto case6
      end
    end
    goto case7
    ::case2::
    do
      i = G_Storage[k].aCurve
      if (i >= 0) then
        d[1] = F.table_getStorageDepth(G.Curve[i], v)
      else
        d[1] = 0.0
      end
      goto swend1
    end
    ::case3::
    do
      d[1] = (v / a0)
      goto swend1
    end
    ::case4::
    do
      d[1] = m_sqrt(((2.0 * v) / a1))
      goto swend1
    end
    ::case5::
    do
      if (a2 == 0.0) then
        d[1] = (v / ((a0 + a1)))
      elseif (a0 == 0.0) then
        e = (1.0 / ((a2 + 1.0)))
        d[1] = R.pow((v / ((a1 * e))), e)
      elseif ((a2 == 1.0) and (a1 > 0.0)) then
        d[1] = (((m_sqrt(((a0 * a0) + ((2.0 * a1) * v))) - a0)) / a1)
      else
        d[1] = (v / ((a0 + a1)))
        F.findroot_Newton(0.0, (G_Node[j].fullDepth * F.UCF(LENGTH)), d, 1, 0.001, F.storage_getVolDiff, storageVol)
      end
      goto swend1
    end
    ::case6::
    do
      d[1] = (v / a0)
      F.findroot_Newton(0.0, (G_Node[j].fullDepth * F.UCF(LENGTH)), d, 1, 0.001, F.storage_getVolDiff, storageVol)
      goto swend1
    end
    ::case7::
    do
      d[1] = 0.0
    end
    ::swend1::
  end
  d[1] = (d[1] / (F.UCF(LENGTH)))
  if (d[1] > G_Node[j].fullDepth) then
    d[1] = G_Node[j].fullDepth
  end
  do return d[1] end
end

-- node.c:906
F.storage_getVolDiff = function(y, f, f__k, df, df__k, p)
  local k = 0
  local storageVol = nil
  storageVol = p
  k = storageVol.k
  f[f__k] = (F.storage_getVolume(k, y) - storageVol.v)
  df[df__k] = F.storage_getSurfArea(k, y)
end

-- node.c:930
F.storage_getVolume = function(j, d)
  local G_Node, G_Storage = G.Node, G.Storage
  local k = G_Node[j].subIndex
  local i = 0
  local n = 0.0
  local v = 0.0
  if (d == 0.0) then
    do return 0.0 end
  end
  if ((d >= G_Node[j].fullDepth) and (G_Node[j].fullVolume > 0.0)) then
    do return G_Node[j].fullVolume end
  end
  do
    local __sw1 = G_Storage[k].shape
    if __sw1 < CONICAL then
      if __sw1 == TABULAR then goto case2
      elseif __sw1 == FUNCTIONAL then goto case3
      elseif __sw1 == CYLINDRICAL then goto case4
      end
    else
      if __sw1 == CONICAL then goto case4
      elseif __sw1 == PARABOLOID then goto case4
      elseif __sw1 == PYRAMIDAL then goto case4
      end
    end
    goto case5
    ::case2::
    do
      i = G_Storage[k].aCurve
      if (i >= 0) then
        do return (F.table_getStorageVolume(G.Curve[i], (d * F.UCF(LENGTH))) / F.UCF(VOLUME)) end
      else
        do return 0.0 end
      end
    end
    ::case3::
    do
      d = (d * (F.UCF(LENGTH)))
      n = (G_Storage[k].a2 + 1.0)
      v = (((G_Storage[k].a0 * d)) + ((G_Storage[k].a1 / n) * R.pow(d, n)))
      do return (v / F.UCF(VOLUME)) end
    end
    ::case4::
    do
      d = (d * (F.UCF(LENGTH)))
      v = (d * ((G_Storage[k].a0 + (d * (((G_Storage[k].a1 / 2.0) + ((d * G_Storage[k].a2) / 3.0)))))))
      do return (v / F.UCF(VOLUME)) end
    end
    ::case5::
    do
      do return 0.0 end
    end
    ::swend1::
  end
end

-- node.c:979
F.storage_getSurfArea = function(j, d)
  local G_Storage = G.Storage
  local area = 0.0
  local k = G.Node[j].subIndex
  local i = 0
  do
    local __sw1 = G_Storage[k].shape
    if __sw1 < CONICAL then
      if __sw1 == TABULAR then goto case2
      elseif __sw1 == FUNCTIONAL then goto case3
      elseif __sw1 == CYLINDRICAL then goto case4
      end
    else
      if __sw1 == CONICAL then goto case4
      elseif __sw1 == PARABOLOID then goto case4
      elseif __sw1 == PYRAMIDAL then goto case4
      end
    end
    goto case5
    ::case2::
    do
      i = G_Storage[k].aCurve
      if (i >= 0) then
        area = F.table_lookupEx(G.Curve[i], (d * F.UCF(LENGTH)))
      end
      goto swend1
    end
    ::case3::
    do
      area = (G_Storage[k].a0 + (G_Storage[k].a1 * R.pow((d * F.UCF(LENGTH)), G_Storage[k].a2)))
      goto swend1
    end
    ::case4::
    do
      d = (d * (F.UCF(LENGTH)))
      area = (G_Storage[k].a0 + (d * ((G_Storage[k].a1 + (d * G_Storage[k].a2)))))
      goto swend1
    end
    ::case5::
    do
      do return 0.0 end
    end
    ::swend1::
  end
  do return ((area / F.UCF(LENGTH)) / F.UCF(LENGTH)) end
end

-- node.c:1022
F.storage_getOutflow = function(j, i)
  local G_Link = G.Link
  local k = 0
  local a = 0.0
  local y = 0.0
  if (G_Link[i].type_ ~= CONDUIT) then
    do return 0.0 end
  end
  y = (G.Node[j].newDepth - G_Link[i].offset1)
  if (y <= 0.0) then
    do return 0.0 end
  end
  if (y >= G_Link[i].xsect.yFull) then
    do return G_Link[i].qFull end
  end
  k = G_Link[i].subIndex
  a = F.xsect_getAofY(G_Link[i].xsect, y)
  do return (G.Conduit[k].beta * F.xsect_getSofA(G_Link[i].xsect, a)) end
end

-- node.c:1052
F.storage_getLosses = function(j, tStep)
  local G_Node, G_Storage = G.Node, G.Storage
  local k = 0
  local depth = 0.0
  local area = 0.0
  local evapRate = 0.0
  local exfilRate = 0.0
  local totalLoss = 0.0
  local lossRatio = 0.0
  local exfil = nil
  k = G_Node[j].subIndex
  evapRate = (G.Evap.rate * G_Storage[k].fEvap)
  exfil = G_Storage[k].exfil
  if ((evapRate > 0.0) or (exfil ~= (nil))) then
    depth = G_Node[j].newDepth
    area = F.storage_getSurfArea(j, depth)
    if (G_Node[j].newVolume > 0.0001) then
      evapRate = (area * evapRate)
    end
    if (exfil ~= (nil)) then
      exfilRate = F.exfil_getLoss(exfil, tStep, depth, area)
    end
    totalLoss = (((evapRate + exfilRate)) * tStep)
    if (totalLoss > G_Node[j].newVolume) then
      lossRatio = (G_Node[j].newVolume / totalLoss)
      evapRate = (evapRate * lossRatio)
      exfilRate = (exfilRate * lossRatio)
    end
  end
  G_Storage[G_Node[j].subIndex].evapLoss = (evapRate * tStep)
  G_Storage[G_Node[j].subIndex].exfilLoss = (exfilRate * tStep)
  do return (evapRate + exfilRate) end
end

-- node.c:1113
F.divider_readParams = function(j, k, tok, ntoks)
  local i = 0
  local m = 0
  local m1 = 0
  local m2 = 0
  local n = 0
  local x = R.fill(11, 0.0)
  local id = nil
  if (ntoks < 4) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  id = F.project_findID(NODE, tok[0])
  if R.peq(id, (nil)) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  if (not (F.getDouble(tok[1], x, 0) ~= 0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[1]) end
  end
  do
    i = 1
    while (i < 11) do
      do
        x[i] = 0.0
      end
      i = i + 1
    end
  end
  if ((R.strlen(tok[2]) == 0) or (R.strcmp(tok[2], S[275]) == 0)) then
    x[1] = (-1.0)
  else
    m1 = F.project_findObject(LINK, tok[2])
    if (m1 < 0) then
      do return F.error_setInpError(ERR_NAME, tok[2]) end
    end
    x[1] = (m1 * 1.0)
  end
  n = 4
  m1 = F.findmatch(tok[3], G.DividerTypeWords)
  if (m1 < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[3]) end
  end
  x[2] = (m1 * 1.0)
  x[3] = ((-1) * 1.0)
  if (m1 == TABULAR_DIVIDER) then
    if (ntoks < 5) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    m2 = F.project_findObject(CURVE, tok[4])
    if (m2 < 0) then
      do return F.error_setInpError(ERR_NAME, tok[4]) end
    end
    x[3] = (m2 * 1.0)
    n = 5
  end
  if (m1 == CUTOFF_DIVIDER) then
    if (ntoks < 5) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    if (not (F.getDouble(tok[4], x, 4) ~= 0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[4]) end
    end
    n = 5
  end
  if (m1 == WEIR_DIVIDER) then
    if (ntoks < 7) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    do
      i = 4
      while (i < 7) do
        do
          if (not (F.getDouble(tok[i], x, i) ~= 0)) then
            do return F.error_setInpError(ERR_NUMBER, tok[i]) end
          end
        end
        i = i + 1
      end
    end
    n = 7
  end
  if (m1 == OVERFLOW_DIVIDER) then
    n = 4
  end
  m = 7
  do
    i = n
    while ((i < ntoks) and (m < 11)) do
      do
        if (not (F.getDouble(tok[i], x, m) ~= 0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[i]) end
        end
        m = m + 1
      end
      i = i + 1
    end
  end
  G.Node[j].ID = id
  F.node_setParams(j, DIVIDER, k, x)
  do return 0 end
end

-- node.c:1216
F.divider_validate = function(j)
  local G_Node, G_Divider, G_Link = G.Node, G.Divider, G.Link
  local i = 0
  local k = 0
  k = G_Node[j].subIndex
  i = G_Divider[k].link
  if ((i < 0) or (((G_Link[i].node1 ~= j) and (G_Link[i].node2 ~= j)))) then
    F.report_writeErrorMsg(ERR_DIVIDER_LINK, G_Node[j].ID)
  end
  if (G_Divider[k].type_ == WEIR_DIVIDER) then
    if ((G_Divider[k].dhMax <= 0.0) or (G_Divider[k].cWeir <= 0.0)) then
      F.report_writeErrorMsg(ERR_WEIR_DIVIDER, G_Node[j].ID)
    else
      G_Divider[k].qMax = ((G_Divider[k].cWeir * (G_Divider[k].dhMax ^ 1.5)) / F.UCF(FLOW))
      if (G_Divider[k].qMin > G_Divider[k].qMax) then
        F.report_writeErrorMsg(ERR_WEIR_DIVIDER, G_Node[j].ID)
      end
    end
  end
end

-- node.c:1251
F.divider_getOutflow = function(j, k)
  local G_Node, G_Divider = G.Node, G.Divider
  local i = 0
  local m = 0
  local qIn = 0.0
  local qOut = 0.0
  local f = 0.0
  qIn = (G_Node[j].inflow + G_Node[j].overflow)
  i = G_Node[j].subIndex
  do
    local __sw1 = G_Divider[i].type_
    if __sw1 == CUTOFF_DIVIDER then goto case2
    elseif __sw1 == OVERFLOW_DIVIDER then goto case3
    elseif __sw1 == WEIR_DIVIDER then goto case4
    elseif __sw1 == TABULAR_DIVIDER then goto case5
    else goto case6 end
    ::case2::
    do
      if (qIn <= G_Divider[i].qMin) then
        qOut = 0.0
      else
        qOut = (qIn - G_Divider[i].qMin)
      end
      goto swend1
    end
    ::case3::
    do
      if (k ~= G_Divider[i].link) then
        qOut = qIn
      else
        qOut = (qIn - G_Node[j].outflow)
      end
      if (qOut < 1e-05) then
        qOut = 0.0
      end
      do return qOut end
    end
    ::case4::
    do
      if (qIn <= G_Divider[i].qMin) then
        qOut = 0.0
      else
        f = (((qIn - G_Divider[i].qMin)) / ((G_Divider[i].qMax - G_Divider[i].qMin)))
        if (f > 1.0) then
          qOut = (G_Divider[i].qMax * m_sqrt(f))
        else
          qOut = ((G_Divider[i].cWeir * ((f * G_Divider[i].dhMax) ^ 1.5)) / F.UCF(FLOW))
        end
      end
      goto swend1
    end
    ::case5::
    do
      m = G_Divider[i].flowCurve
      if (m >= 0) then
        qOut = (F.table_lookup(G.Curve[m], (qIn * F.UCF(FLOW))) / F.UCF(FLOW))
      else
        qOut = 0.0
      end
      goto swend1
    end
    ::case6::
    do
      qOut = 0.0
    end
    ::swend1::
  end
  if (qOut > qIn) then
    qOut = qIn
  end
  if (k ~= G_Divider[i].link) then
    qOut = (qIn - qOut)
  end
  do return qOut end
end

-- node.c:1333
F.outfall_readParams = function(j, k, tok, ntoks)
  local i = 0
  local m = 0
  local n = 0
  local x = R.fill(7, 0.0)
  local id = nil
  if (ntoks < 3) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  id = F.project_findID(NODE, tok[0])
  if R.peq(id, (nil)) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  if (not (F.getDouble(tok[1], x, 0) ~= 0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[1]) end
  end
  i = F.findmatch(tok[2], G.OutfallTypeWords)
  if (i < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[2]) end
  end
  x[1] = (i * 1.0)
  x[2] = 0.0
  x[3] = (-1.0)
  x[4] = (-1.0)
  x[5] = 0.0
  x[6] = (-1.0)
  n = 4
  if (i >= FIXED_OUTFALL) then
    if (ntoks < 4) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    n = 5
    do
      local __sw1 = i
      if __sw1 == FIXED_OUTFALL then goto case2
      elseif __sw1 == TIDAL_OUTFALL then goto case3
      elseif __sw1 == TIMESERIES_OUTFALL then goto case4
      else goto swend1 end
      ::case2::
      do
        if (not (F.getDouble(tok[3], x, 2) ~= 0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[3]) end
        end
        goto swend1
      end
      ::case3::
      do
        m = F.project_findObject(CURVE, tok[3])
        if (m < 0) then
          do return F.error_setInpError(ERR_NAME, tok[3]) end
        end
        x[3] = (m * 1.0)
        goto swend1
      end
      ::case4::
      do
        m = F.project_findObject(TSERIES, tok[3])
        if (m < 0) then
          do return F.error_setInpError(ERR_NAME, tok[3]) end
        end
        x[4] = (m * 1.0)
        G.Tseries[m].refersTo = TIMESERIES_OUTFALL
      end
      ::swend1::
    end
  end
  if (ntoks == n) then
    m = F.findmatch(tok[(n - 1)], G.NoYesWords)
    if (m < 0) then
      do return F.error_setInpError(ERR_KEYWORD, tok[(n - 1)]) end
    end
    x[5] = (m * 1.0)
  end
  if (ntoks == (n + 1)) then
    m = F.project_findObject(SUBCATCH, tok[n])
    if (m < 0) then
      do return F.error_setInpError(ERR_NAME, tok[n]) end
    end
    x[6] = (m * 1.0)
  end
  G.Node[j].ID = id
  F.node_setParams(j, OUTFALL, k, x)
  do return 0 end
end

-- node.c:1413
F.outfall_setOutletDepth = function(j, yNorm, yCrit, z)
  local G_Node, G_Outfall, G_Curve = G.Node, G.Outfall, G.Curve
  local x = {0.0}
  local y = {0.0}
  local yNew = 0.0
  local stage = 0.0
  local k = 0
  local i = G_Node[j].subIndex
  local currentDate = 0.0
  do
    local __sw1 = G_Outfall[i].type_
    if __sw1 == FREE_OUTFALL then goto case2
    elseif __sw1 == NORMAL_OUTFALL then goto case3
    elseif __sw1 == FIXED_OUTFALL then goto case4
    elseif __sw1 == TIDAL_OUTFALL then goto case5
    elseif __sw1 == TIMESERIES_OUTFALL then goto case6
    else goto case7 end
    ::case2::
    do
      if (z > 0.0) then
        G_Node[j].newDepth = 0.0
      else
        G_Node[j].newDepth = (((((yNorm) <= (yCrit))) and (yNorm) or (yCrit)))
      end
      do return end
    end
    ::case3::
    do
      if (z > 0.0) then
        G_Node[j].newDepth = 0.0
      else
        G_Node[j].newDepth = yNorm
      end
      do return end
    end
    ::case4::
    do
      stage = G_Outfall[i].fixedStage
      goto swend1
    end
    ::case5::
    do
      k = G_Outfall[i].tideCurve
      F.table_getFirstEntry(G_Curve[k], x, 1, y, 1)
      currentDate = (G.NewRoutingTime / 86400000.0)
      x[1] = (x[1] + (((currentDate - R.floor(currentDate))) * 24.0))
      stage = (F.table_lookup(G_Curve[k], x[1]) / F.UCF(LENGTH))
      goto swend1
    end
    ::case6::
    do
      k = G_Outfall[i].stageSeries
      currentDate = (G.StartDateTime + (G.NewRoutingTime / 86400000.0))
      stage = (F.table_tseriesLookup(G.Tseries[k], currentDate, 1) / F.UCF(LENGTH))
      goto swend1
    end
    ::case7::
    do
      stage = G_Node[j].invertElev
    end
    ::swend1::
  end
  yCrit = (((((yCrit) <= (yNorm))) and (yCrit) or (yNorm)))
  if (((yCrit + z) + G_Node[j].invertElev) < stage) then
    yNew = (stage - G_Node[j].invertElev)
  elseif (z > 0.0) then
    if (stage < (G_Node[j].invertElev + z)) then
      yNew = (((((0.0) >= (((stage - G_Node[j].invertElev))))) and (0.0) or (((stage - G_Node[j].invertElev)))))
    else
      yNew = (z + yCrit)
    end
  else
    yNew = yCrit
  end
  G_Node[j].newDepth = yNew
end

