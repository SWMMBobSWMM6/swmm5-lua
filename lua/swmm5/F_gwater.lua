-- Generated from EPA SWMM 5.2.4 (gwater.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local ERR_ITEMS <const> = 203
local AQUIFER <const> = 11
local ERR_NAME <const> = 209
local ERR_NUMBER <const> = 211
local TIMEPATTERN <const> = 6
local RAINFALL <const> = 0
local LENGTH <const> = 3
local SUBCATCH <const> = 1
local NODE <const> = 2
local ERR_MEMORY <const> = 101
local ERR_KEYWORD <const> = 205
local ERR_MATH_EXPR <const> = 233
local ERR_AQUIFER_PARAMS <const> = 109
local MONTHLY_PATTERN <const> = 0
local ERR_GROUND_ELEV <const> = 110
local THETA <const> = 0
local LOWERDEPTH <const> = 1
local GWFLOW <const> = 9
local gwvHGW <const> = 0
local gwvHSW <const> = 1
local gwvHCB <const> = 2
local gwvHGS <const> = 3
local gwvKS <const> = 4
local gwvK <const> = 5
local gwvTHETA <const> = 6
local gwvPHI <const> = 7
local gwvFI <const> = 8
local gwvFU <const> = 9
local gwvA <const> = 10
local LANDAREA <const> = 4
local _ENV = R.strict

G.GWTOL = 0.0001
G.XTOL = 0.001
G.GWVarWords = {[0] = S[707], S[708], S[709], S[710], S[711], S[712], S[713], S[714], S[715], S[716], S[717], (nil)}
G.Area = 0.0
G.gwater_Infil = 0.0
G.MaxEvap = 0.0
G.AvailEvap = 0.0
G.UpperEvap = 0.0
G.LowerEvap = 0.0
G.UpperPerc = 0.0
G.LowerLoss = 0.0
G.GWFlow = 0.0
G.MaxUpperPerc = 0.0
G.MaxGWFlowPos = 0.0
G.MaxGWFlowNeg = 0.0
G.FracPerv = 0.0
G.TotalDepth = 0.0
G.Theta = 0.0
G.HydCon = 0.0
G.Hgw = 0.0
G.Hstar = 0.0
G.Hsw = 0.0
G.gwater_Tstep = 0.0
G.A = T.TAquifer()
G.GW = nil
G.LatFlowExpr = nil
G.DeepFlowExpr = nil

-- gwater.c:119
F.gwater_readAquiferParams = function(j, tok, ntoks)
  local G_Aquifer = G.Aquifer
  local i = 0
  local p = 0
  local x = R.fill(12, 0.0)
  local id = nil
  if (ntoks < 13) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  id = F.project_findID(AQUIFER, tok[0])
  if R.peq(id, (nil)) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  do
    i = 0
    while (i < 11) do
      do
        x[i] = 0.0
      end
      i = i + 1
    end
  end
  do
    i = 1
    while (i < 13) do
      do
        if (not (F.getDouble(tok[i], x, (i - 1)) ~= 0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[i]) end
        end
      end
      i = i + 1
    end
  end
  p = (-1)
  if (ntoks > 13) then
    p = F.project_findObject(TIMEPATTERN, tok[13])
    if (p < 0) then
      do return F.error_setInpError(ERR_NAME, tok[13]) end
    end
  end
  G_Aquifer[j].ID = id
  G_Aquifer[j].porosity = x[0]
  G_Aquifer[j].wiltingPoint = x[1]
  G_Aquifer[j].fieldCapacity = x[2]
  G_Aquifer[j].conductivity = (x[3] / F.UCF(RAINFALL))
  G_Aquifer[j].conductSlope = x[4]
  G_Aquifer[j].tensionSlope = (x[5] / F.UCF(LENGTH))
  G_Aquifer[j].upperEvapFrac = x[6]
  G_Aquifer[j].lowerEvapDepth = (x[7] / F.UCF(LENGTH))
  G_Aquifer[j].lowerLossCoeff = (x[8] / F.UCF(RAINFALL))
  G_Aquifer[j].bottomElev = (x[9] / F.UCF(LENGTH))
  G_Aquifer[j].waterTableElev = (x[10] / F.UCF(LENGTH))
  G_Aquifer[j].upperMoisture = x[11]
  G_Aquifer[j].upperEvapPat = p
  do return 0 end
end

-- gwater.c:179
F.gwater_readGroundwaterParams = function(tok, ntoks)
  local G_Subcatch = G.Subcatch
  local i = 0
  local j = 0
  local k = 0
  local m = 0
  local n = 0
  local x = R.fill(11, 0.0)
  local gw = nil
  if (ntoks < 3) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  j = F.project_findObject(SUBCATCH, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  if (ntoks < 11) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  k = F.project_findObject(AQUIFER, tok[1])
  if (k < 0) then
    do return F.error_setInpError(ERR_NAME, tok[1]) end
  end
  n = F.project_findObject(NODE, tok[2])
  if (n < 0) then
    do return F.error_setInpError(ERR_NAME, tok[2]) end
  end
  do
    i = 0
    while (i < 7) do
      do
        if (not (F.getDouble(tok[(i + 3)], x, i) ~= 0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[(i + 3)]) end
        end
      end
      i = i + 1
    end
  end
  do
    i = 7
    while (i < 11) do
      do
        x[i] = (-10000000000.0)
        m = (i + 3)
        if ((ntoks > m) and (tok[m].b[tok[m].o] ~= 42)) then
          if (not (F.getDouble(tok[m], x, i) ~= 0)) then
            do return F.error_setInpError(ERR_NUMBER, tok[m]) end
          end
          if (i < 10) then
            x[i] = (x[i] / (F.UCF(LENGTH)))
          end
        end
      end
      i = i + 1
    end
  end
  if (not (G_Subcatch[j].groundwater ~= nil)) then
    gw = T.TGroundwater()
    if (not (gw ~= nil)) then
      do return F.error_setInpError(ERR_MEMORY, S[0]) end
    end
    G_Subcatch[j].groundwater = gw
  else
    gw = G_Subcatch[j].groundwater
  end
  gw.aquifer = k
  gw.node = n
  gw.surfElev = (x[0] / F.UCF(LENGTH))
  gw.a1 = x[1]
  gw.b1 = x[2]
  gw.a2 = x[3]
  gw.b2 = x[4]
  gw.a3 = x[5]
  gw.fixedDepth = (x[6] / F.UCF(LENGTH))
  gw.nodeElev = x[7]
  gw.bottomElev = x[8]
  gw.waterTableElev = x[9]
  gw.upperMoisture = x[10]
  do return 0 end
end

-- gwater.c:258
F.gwater_readFlowExpression = function(tok, ntoks)
  local G_Subcatch = G.Subcatch
  local i = 0
  local j = 0
  local k = 0
  local exprStr = R.buf(1025)
  local expr = nil
  if (ntoks < 3) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  j = F.project_findObject(SUBCATCH, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  k = 1
  if (F.match(tok[1], S[158]) ~= 0) then
    k = 1
  elseif (F.match(tok[1], S[159]) ~= 0) then
    k = 2
  else
    do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
  end
  F.sstrncpy(exprStr, tok[2], 1024)
  do
    i = 3
    while (i < ntoks) do
      do
        F.sstrcat(exprStr, S[33], (1024 + 1))
        F.sstrcat(exprStr, tok[i], (1024 + 1))
      end
      i = i + 1
    end
  end
  if (k == 1) then
    F.mathexpr_delete(G_Subcatch[j].gwLatFlowExpr)
  else
    F.mathexpr_delete(G_Subcatch[j].gwDeepFlowExpr)
  end
  expr = F.mathexpr_create(exprStr, F.gwater_getVariableIndex)
  if (expr == (nil)) then
    do return F.error_setInpError(ERR_MATH_EXPR, S[0]) end
  end
  if (k == 1) then
    G_Subcatch[j].gwLatFlowExpr = expr
  else
    G_Subcatch[j].gwDeepFlowExpr = expr
  end
  do return 0 end
end

-- gwater.c:315
F.gwater_deleteFlowExpression = function(j)
  local G_Subcatch = G.Subcatch
  F.mathexpr_delete(G_Subcatch[j].gwLatFlowExpr)
  F.mathexpr_delete(G_Subcatch[j].gwDeepFlowExpr)
end

-- gwater.c:328
F.gwater_validateAquifer = function(j)
  local G_Aquifer = G.Aquifer
  local p = 0
  if (((((((((((G_Aquifer[j].porosity <= 0.0) or (G_Aquifer[j].fieldCapacity >= G_Aquifer[j].porosity)) or (G_Aquifer[j].wiltingPoint >= G_Aquifer[j].fieldCapacity)) or (G_Aquifer[j].conductivity <= 0.0)) or (G_Aquifer[j].conductSlope < 0.0)) or (G_Aquifer[j].tensionSlope < 0.0)) or (G_Aquifer[j].upperEvapFrac < 0.0)) or (G_Aquifer[j].lowerEvapDepth < 0.0)) or (G_Aquifer[j].waterTableElev < G_Aquifer[j].bottomElev)) or (G_Aquifer[j].upperMoisture > G_Aquifer[j].porosity)) or (G_Aquifer[j].upperMoisture < G_Aquifer[j].wiltingPoint)) then
    F.report_writeErrorMsg(ERR_AQUIFER_PARAMS, G_Aquifer[j].ID)
  end
  p = G_Aquifer[j].upperEvapPat
  if ((p >= 0) and (G.Pattern[p].type_ ~= MONTHLY_PATTERN)) then
    F.report_writeErrorMsg(ERR_AQUIFER_PARAMS, G_Aquifer[j].ID)
  end
end

-- gwater.c:359
F.gwater_validate = function(j)
  local G_Subcatch = G.Subcatch
  local a = T.TAquifer()
  local gw = nil
  gw = G_Subcatch[j].groundwater
  if (gw ~= nil) then
    a = T.copy_TAquifer(G.Aquifer[gw.aquifer])
    if (gw.bottomElev == (-10000000000.0)) then
      gw.bottomElev = a.bottomElev
    end
    if (gw.waterTableElev == (-10000000000.0)) then
      gw.waterTableElev = a.waterTableElev
    end
    if (gw.upperMoisture == (-10000000000.0)) then
      gw.upperMoisture = a.upperMoisture
    end
    if (gw.surfElev < gw.waterTableElev) then
      F.report_writeErrorMsg(ERR_GROUND_ELEV, G_Subcatch[j].ID)
    end
  end
end

-- gwater.c:382
F.gwater_initState = function(j)
  local a = T.TAquifer()
  local gw = nil
  gw = G.Subcatch[j].groundwater
  if (gw ~= nil) then
    a = T.copy_TAquifer(G.Aquifer[gw.aquifer])
    gw.theta = gw.upperMoisture
    if (gw.theta >= a.porosity) then
      gw.theta = (a.porosity - G.XTOL)
    end
    gw.lowerDepth = (gw.waterTableElev - gw.bottomElev)
    if (gw.lowerDepth >= (gw.surfElev - gw.bottomElev)) then
      gw.lowerDepth = ((gw.surfElev - gw.bottomElev) - G.XTOL)
    end
    gw.oldFlow = 0.0
    gw.newFlow = 0.0
    gw.evapLoss = 0.0
    gw.maxInfilVol = ((((gw.surfElev - gw.waterTableElev)) * ((a.porosity - gw.theta))) / F.subcatch_getFracPerv(j))
  end
end

-- gwater.c:425
F.gwater_getState = function(j, x)
  local gw = G.Subcatch[j].groundwater
  x[0] = gw.theta
  x[1] = (gw.bottomElev + gw.lowerDepth)
  x[2] = gw.newFlow
  x[3] = gw.maxInfilVol
end

-- gwater.c:441
F.gwater_setState = function(j, x)
  local gw = G.Subcatch[j].groundwater
  if (gw == (nil)) then
    do return end
  end
  gw.theta = x[0]
  gw.lowerDepth = (x[1] - gw.bottomElev)
  gw.oldFlow = x[2]
  if (x[3] ~= (-10000000000.0)) then
    gw.maxInfilVol = x[3]
  end
end

-- gwater.c:458
F.gwater_getVolume = function(j)
  local a = T.TAquifer()
  local gw = nil
  local upperDepth = 0.0
  gw = G.Subcatch[j].groundwater
  if (gw == (nil)) then
    do return 0.0 end
  end
  a = T.copy_TAquifer(G.Aquifer[gw.aquifer])
  upperDepth = ((gw.surfElev - gw.bottomElev) - gw.lowerDepth)
  do return (((upperDepth * gw.theta)) + ((gw.lowerDepth * a.porosity))) end
end

-- gwater.c:477
F.gwater_getGroundwater = function(j, evap, infil, tStep)
  local G_Subcatch, G_Node = G.Subcatch, G.Node
  local n = 0
  local x = R.fill(2, 0.0)
  local vUpper = 0.0
  local nodeFlow = 0.0
  G.GW = G_Subcatch[j].groundwater
  if (G.GW == (nil)) then
    do return end
  end
  G.LatFlowExpr = G_Subcatch[j].gwLatFlowExpr
  G.DeepFlowExpr = G_Subcatch[j].gwDeepFlowExpr
  G.A = T.copy_TAquifer(G.Aquifer[G.GW.aquifer])
  G.FracPerv = F.subcatch_getFracPerv(j)
  if (G.FracPerv <= 0.0) then
    do return end
  end
  G.Area = G_Subcatch[j].area
  infil = ((infil / G.Area) / tStep)
  G.gwater_Infil = infil
  G.gwater_Tstep = tStep
  evap = ((evap / G.Area) / tStep)
  G.MaxEvap = (G.Evap.rate * G.FracPerv)
  G.AvailEvap = (((((((G.MaxEvap - evap))) >= (0.0))) and (((G.MaxEvap - evap))) or (0.0)))
  G.TotalDepth = (G.GW.surfElev - G.GW.bottomElev)
  if (G.TotalDepth <= 0.0) then
    do return end
  end
  n = G.GW.node
  if (G.GW.nodeElev ~= (-10000000000.0)) then
    G.Hstar = (G.GW.nodeElev - G.GW.bottomElev)
  else
    G.Hstar = (G_Node[n].invertElev - G.GW.bottomElev)
  end
  if (G.GW.fixedDepth > 0.0) then
    G.Hsw = ((G.GW.fixedDepth + G_Node[n].invertElev) - G.GW.bottomElev)
  else
    G.Hsw = ((G_Node[n].newDepth + G_Node[n].invertElev) - G.GW.bottomElev)
  end
  x[THETA] = G.GW.theta
  x[LOWERDEPTH] = G.GW.lowerDepth
  vUpper = (((G.TotalDepth - x[LOWERDEPTH])) * ((x[THETA] - G.A.fieldCapacity)))
  vUpper = (((((0.0) >= (vUpper))) and (0.0) or (vUpper)))
  G.MaxUpperPerc = (vUpper / tStep)
  G.MaxGWFlowPos = ((x[LOWERDEPTH] * G.A.porosity) / tStep)
  G.MaxGWFlowNeg = ((((G.TotalDepth - x[LOWERDEPTH])) * ((G.A.porosity - x[THETA]))) / tStep)
  nodeFlow = (((G_Node[n].inflow + (G_Node[n].newVolume / tStep))) / G.Area)
  G.MaxGWFlowNeg = (-(((((G.MaxGWFlowNeg) <= (nodeFlow))) and (G.MaxGWFlowNeg) or (nodeFlow))))
  F.odesolve_integrate(x, 2, 0.0, tStep, G.GWTOL, tStep, F.getDxDt)
  x[THETA] = (((((x[THETA]) >= (G.A.wiltingPoint))) and (x[THETA]) or (G.A.wiltingPoint)))
  if (x[THETA] >= G.A.porosity) then
    x[THETA] = (G.A.porosity - G.XTOL)
    x[LOWERDEPTH] = (G.TotalDepth - G.XTOL)
  end
  x[LOWERDEPTH] = (((((x[LOWERDEPTH]) >= (0.0))) and (x[LOWERDEPTH]) or (0.0)))
  if (x[LOWERDEPTH] >= G.TotalDepth) then
    x[LOWERDEPTH] = (G.TotalDepth - G.XTOL)
  end
  G.GW.theta = x[THETA]
  G.GW.lowerDepth = x[LOWERDEPTH]
  F.getFluxes(G.GW.theta, G.GW.lowerDepth)
  G.GW.oldFlow = G.GW.newFlow
  G.GW.newFlow = G.GWFlow
  G.GW.evapLoss = (G.UpperEvap + G.LowerEvap)
  G.GW.maxInfilVol = ((((G.TotalDepth - x[LOWERDEPTH])) * ((G.A.porosity - x[THETA]))) / G.FracPerv)
  F.updateMassBal(G.Area, tStep)
  F.stats_updateGwaterStats(j, infil, G.GW.evapLoss, G.GWFlow, G.LowerLoss, G.GW.theta, (G.GW.lowerDepth + G.GW.bottomElev), tStep)
end

-- gwater.c:605
F.updateMassBal = function(area, tStep)
  local G_GW = G.GW
  local vInfil = 0.0
  local vUpperEvap = 0.0
  local vLowerEvap = 0.0
  local vLowerPerc = 0.0
  local vGwater = 0.0
  local ft2sec = (area * tStep)
  vInfil = (G.gwater_Infil * ft2sec)
  vUpperEvap = (G.UpperEvap * ft2sec)
  vLowerEvap = (G.LowerEvap * ft2sec)
  vLowerPerc = (G.LowerLoss * ft2sec)
  vGwater = ((0.5 * ((G_GW.oldFlow + G_GW.newFlow))) * ft2sec)
  F.massbal_updateGwaterTotals(vInfil, vUpperEvap, vLowerEvap, vLowerPerc, vGwater)
end

-- gwater.c:631
F.getFluxes = function(theta, lowerDepth)
  local G_DeepFlowExpr, G_LatFlowExpr = G.DeepFlowExpr, G.LatFlowExpr
  local upperDepth = 0.0
  lowerDepth = (((((lowerDepth) >= (0.0))) and (lowerDepth) or (0.0)))
  lowerDepth = (((((lowerDepth) <= (G.TotalDepth))) and (lowerDepth) or (G.TotalDepth)))
  upperDepth = (G.TotalDepth - lowerDepth)
  G.Hgw = lowerDepth
  G.Theta = theta
  F.gwater_getEvapRates(theta, upperDepth)
  G.UpperPerc = F.getUpperPerc(theta, upperDepth)
  G.UpperPerc = (((((G.UpperPerc) <= (G.MaxUpperPerc))) and (G.UpperPerc) or (G.MaxUpperPerc)))
  if (G_DeepFlowExpr ~= (nil)) then
    G.LowerLoss = (F.mathexpr_eval(G_DeepFlowExpr, F.gwater_getVariableValue) / F.UCF(RAINFALL))
  else
    G.LowerLoss = ((G.A.lowerLossCoeff * lowerDepth) / G.TotalDepth)
  end
  G.LowerLoss = (((((G.LowerLoss) <= ((lowerDepth / G.gwater_Tstep)))) and (G.LowerLoss) or ((lowerDepth / G.gwater_Tstep))))
  G.GWFlow = F.getGWFlow(lowerDepth)
  if (G_LatFlowExpr ~= (nil)) then
    G.GWFlow = (G.GWFlow + (F.mathexpr_eval(G_LatFlowExpr, F.gwater_getVariableValue) / F.UCF(GWFLOW)))
  end
  if (G.GWFlow >= 0.0) then
    G.GWFlow = (((((G.GWFlow) <= (G.MaxGWFlowPos))) and (G.GWFlow) or (G.MaxGWFlowPos)))
  else
    G.GWFlow = (((((G.GWFlow) >= (G.MaxGWFlowNeg))) and (G.GWFlow) or (G.MaxGWFlowNeg)))
  end
end

-- gwater.c:677
F.getDxDt = function(t, x, dxdt)
  local qUpper = 0.0
  local qLower = 0.0
  local denom = 0.0
  F.getFluxes(x[THETA], x[LOWERDEPTH])
  qUpper = ((G.gwater_Infil - G.UpperEvap) - G.UpperPerc)
  qLower = (((G.UpperPerc - G.LowerLoss) - G.LowerEvap) - G.GWFlow)
  denom = (G.TotalDepth - x[LOWERDEPTH])
  if (denom > 0.0) then
    dxdt[THETA] = (qUpper / denom)
  else
    dxdt[THETA] = 0.0
  end
  denom = (G.A.porosity - x[THETA])
  if (denom > 0.0) then
    dxdt[LOWERDEPTH] = (qLower / denom)
  else
    dxdt[LOWERDEPTH] = 0.0
  end
end

-- gwater.c:713
F.gwater_getEvapRates = function(theta, upperDepth)
  local G_A = G.A
  local p = 0
  local month = 0
  local f = 0.0
  local lowerFrac = 0.0
  local upperFrac = 0.0
  G.UpperEvap = 0.0
  G.LowerEvap = 0.0
  if (G.gwater_Infil > 0.0) then
    do return end
  end
  upperFrac = G_A.upperEvapFrac
  f = 1.0
  p = G_A.upperEvapPat
  if (p >= 0) then
    month = F.datetime_monthOfYear(F.getDateTime(G.NewRunoffTime))
    f = G.Pattern[p].factor[(month - 1)]
  end
  upperFrac = (upperFrac * f)
  if (theta > G_A.wiltingPoint) then
    G.UpperEvap = (upperFrac * G.MaxEvap)
    G.UpperEvap = (((((G.UpperEvap) <= (G.AvailEvap))) and (G.UpperEvap) or (G.AvailEvap)))
  end
  if (G_A.lowerEvapDepth > 0.0) then
    lowerFrac = (((G_A.lowerEvapDepth - upperDepth)) / G_A.lowerEvapDepth)
    lowerFrac = (((((0.0) >= (lowerFrac))) and (0.0) or (lowerFrac)))
    lowerFrac = (((((lowerFrac) <= (1.0))) and (lowerFrac) or (1.0)))
    G.LowerEvap = ((lowerFrac * ((1.0 - upperFrac))) * G.MaxEvap)
    G.LowerEvap = (((((G.LowerEvap) <= (((G.AvailEvap - G.UpperEvap))))) and (G.LowerEvap) or (((G.AvailEvap - G.UpperEvap)))))
  end
end

-- gwater.c:769
F.getUpperPerc = function(theta, upperDepth)
  local G_A = G.A
  local delta = 0.0
  local dhdz = 0.0
  local hydcon = 0.0
  if ((upperDepth <= 0.0) or (theta <= G_A.fieldCapacity)) then
    do return 0.0 end
  end
  delta = (theta - G_A.porosity)
  hydcon = (G_A.conductivity * m_exp((delta * G_A.conductSlope)))
  delta = (theta - G_A.fieldCapacity)
  dhdz = (1.0 + (((G_A.tensionSlope * 2.0) * delta) / upperDepth))
  G.HydCon = hydcon
  do return (hydcon * dhdz) end
end

-- gwater.c:799
F.getGWFlow = function(lowerDepth)
  local G_GW = G.GW
  local q = 0.0
  local t1 = 0.0
  local t2 = 0.0
  local t3 = 0.0
  if (lowerDepth <= G.Hstar) then
    do return 0.0 end
  end
  if (G_GW.b1 == 0.0) then
    t1 = G_GW.a1
  else
    t1 = (G_GW.a1 * R.pow((((lowerDepth - G.Hstar)) * F.UCF(LENGTH)), G_GW.b1))
  end
  if (G_GW.b2 == 0.0) then
    t2 = G_GW.a2
  elseif (G.Hsw > G.Hstar) then
    t2 = (G_GW.a2 * R.pow((((G.Hsw - G.Hstar)) * F.UCF(LENGTH)), G_GW.b2))
  else
    t2 = 0.0
  end
  t3 = ((((G_GW.a3 * lowerDepth) * G.Hsw) * F.UCF(LENGTH)) * F.UCF(LENGTH))
  q = ((((t1 - t2) + t3)) / F.UCF(GWFLOW))
  if ((q < 0.0) and (G_GW.a3 ~= 0.0)) then
    q = 0.0
  end
  do return q end
end

-- gwater.c:834
F.gwater_getVariableIndex = function(s)
  local k = 0
  k = F.findmatch(s, G.GWVarWords)
  if (k >= 0) then
    do return k end
  end
  do return (-1) end
end

-- gwater.c:850
F.gwater_getVariableValue = function(varIndex)
  local G_A = G.A
  do
    local __sw1 = varIndex
    if __sw1 < gwvK then
      if __sw1 < gwvHCB then
        if __sw1 == gwvHGW then goto case2
        elseif __sw1 == gwvHSW then goto case3
        end
      else
        if __sw1 == gwvHCB then goto case4
        elseif __sw1 == gwvHGS then goto case5
        elseif __sw1 == gwvKS then goto case6
        end
      end
    else
      if __sw1 < gwvFI then
        if __sw1 == gwvK then goto case7
        elseif __sw1 == gwvTHETA then goto case8
        elseif __sw1 == gwvPHI then goto case9
        end
      else
        if __sw1 == gwvFI then goto case10
        elseif __sw1 == gwvFU then goto case11
        elseif __sw1 == gwvA then goto case12
        end
      end
    end
    goto case13
    ::case2::
    do
      do return (G.Hgw * F.UCF(LENGTH)) end
    end
    ::case3::
    do
      do return (G.Hsw * F.UCF(LENGTH)) end
    end
    ::case4::
    do
      do return (G.Hstar * F.UCF(LENGTH)) end
    end
    ::case5::
    do
      do return (G.TotalDepth * F.UCF(LENGTH)) end
    end
    ::case6::
    do
      do return (G_A.conductivity * F.UCF(RAINFALL)) end
    end
    ::case7::
    do
      do return (G.HydCon * F.UCF(RAINFALL)) end
    end
    ::case8::
    do
      do return G.Theta end
    end
    ::case9::
    do
      do return G_A.porosity end
    end
    ::case10::
    do
      do return (G.gwater_Infil * F.UCF(RAINFALL)) end
    end
    ::case11::
    do
      do return (G.UpperPerc * F.UCF(RAINFALL)) end
    end
    ::case12::
    do
      do return (G.Area * F.UCF(LANDAREA)) end
    end
    ::case13::
    do
      do return 0.0 end
    end
    ::swend1::
  end
end

