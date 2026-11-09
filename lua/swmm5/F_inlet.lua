-- Generated from EPA SWMM 5.2.4 (inlet.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local ERR_MEMORY <const> = 101
local NODE <const> = 2
local CUSTOM_INLET <const> = 6
local ERR_ITEMS <const> = 203
local INLET <const> = 17
local ERR_NAME <const> = 209
local GRATE_INLET <const> = 0
local DROP_GRATE_INLET <const> = 4
local CURB_INLET <const> = 1
local DROP_CURB_INLET <const> = 5
local SLOTTED_INLET <const> = 3
local ERR_KEYWORD <const> = 205
local AUTOMATIC <const> = 0
local LINK <const> = 3
local ERR_NUMBER <const> = 211
local FLOW <const> = 10
local LENGTH <const> = 3
local DIVERSION_CURVE <const> = 1
local RATING_CURVE <const> = 3
local TRAPEZOIDAL <const> = 5
local RECT_OPEN <const> = 4
local STREET_XSECT <const> = 25
local BYPASS <const> = 1
local CAPTURE <const> = 2
local DW <const> = 4
local ON_GRADE <const> = 1
local ON_SAG <const> = 2
local POLLUT <const> = 4
local STREET <const> = 16
local GENERIC <const> = 7
local COMBO_INLET <const> = 2
local VERTICAL_THROAT <const> = 2
local CURVE <const> = 7
local US <const> = 0
local HORIZONTAL_THROAT <const> = 0
local INCLINED_THROAT <const> = 1
local _ENV = R.strict

G.InletDesigns = nil
G.InletDesignCount = 0
G.UsesInlets = 0
G.InletTypeWords = {[0] = S[718], S[719], S[0], S[720], S[721], S[722], S[723], (nil)}
G.GrateTypeWords = {[0] = S[724], S[725], S[726], S[727], S[728], S[729], S[730], S[731], (nil)}
G.ThroatAngleWords = {[0] = S[732], S[733], S[734], (nil)}
G.PlacementTypeWords = {[0] = S[735], S[736], S[737], nil}
G.SplashCoeffs = {[0] = {[0] = 2.22, 4.03, 0.65, 0.06}, {[0] = 0.74, 2.44, 0.27, 0.02}, {[0] = 1.76, 3.12, 0.45, 0.03}, {[0] = 0.3, 4.85, 1.31, 0.15}, {[0] = 0.99, 2.64, 0.36, 0.03}, {[0] = 0.51, 2.34, 0.2, 0.01}, {[0] = 0.28, 2.28, 0.18, 0.01}}
G.GrateOpeningRatios = {[0] = 0.9, 0.8, 0.6, 0.35, 0.17, 0.34, 0.8, 1.0}
G.Sx = 0.0
G.SL = 0.0
G.Sw = 0.0
G.a = 0.0
G.W = 0.0
G.T_ = 0.0
G.n = 0.0
G.Nsides = 0
G.Tcrown = 0.0
G.Beta = 0.0
G.Qfactor = 0.0
G.xsect = nil
G.InletFlow = nil
G.FirstInlet = nil

-- inlet.c:257
F.inlet_create = function(numInlets)
  local i = 0
  G.InletDesigns = (nil)
  G.InletFlow = (nil)
  G.InletDesignCount = 0
  G.UsesInlets = 0
  G.FirstInlet = (nil)
  G.InletDesigns = R.recs(numInlets, T.TInletDesign)
  if (G.InletDesigns == (nil)) then
    do return ERR_MEMORY end
  end
  G.InletDesignCount = numInlets
  G.InletFlow = R.fill(G.Nobjects[NODE], 0.0)
  if (G.InletFlow == (nil)) then
    do return ERR_MEMORY end
  end
  do
    i = 0
    while (i < G.InletDesignCount) do
      do
        G.InletDesigns[i].customCurve = (-1)
        G.InletDesigns[i].curbInlet.length = 0.0
        G.InletDesigns[i].grateInlet.length = 0.0
        G.InletDesigns[i].slottedInlet.length = 0.0
        G.InletDesigns[i].type_ = CUSTOM_INLET
      end
      i = i + 1
    end
  end
  do return 0 end
end

-- inlet.c:291
F.inlet_delete = function()
  local inlet = G.FirstInlet
  local nextInlet = nil
  while (inlet ~= nil) do
    do
      nextInlet = inlet.nextInlet
      local _ = nil
      inlet = nextInlet
    end
  end
  G.FirstInlet = (nil)
  do
    if (G.InletFlow ~= nil) then
      local _ = nil
      G.InletFlow = (nil)
    end
  end
  do
    if (G.InletDesigns ~= nil) then
      local _ = nil
      G.InletDesigns = (nil)
    end
  end
end

-- inlet.c:313
F.inlet_readDesignParams = function(tok, ntoks)
  local G_InletDesigns = G.InletDesigns
  local i = 0
  if (ntoks < 3) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  i = F.project_findObject(INLET, tok[0])
  if (i < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  G_InletDesigns[i].ID = F.project_findID(INLET, tok[0])
  G_InletDesigns[i].type_ = F.findmatch(tok[1], G.InletTypeWords)
  do
    local __sw1 = G_InletDesigns[i].type_
    if __sw1 < DROP_GRATE_INLET then
      if __sw1 == GRATE_INLET then goto case2
      elseif __sw1 == CURB_INLET then goto case3
      elseif __sw1 == SLOTTED_INLET then goto case4
      end
    else
      if __sw1 == DROP_GRATE_INLET then goto case2
      elseif __sw1 == DROP_CURB_INLET then goto case3
      elseif __sw1 == CUSTOM_INLET then goto case5
      end
    end
    goto case6
    ::case2::
    do
      do return F.readGrateInletParams(i, tok, ntoks) end
    end
    ::case3::
    do
      do return F.readCurbInletParams(i, tok, ntoks) end
    end
    ::case4::
    do
      do return F.readSlottedInletParams(i, tok, ntoks) end
    end
    ::case5::
    do
      do return F.readCustomInletParams(i, tok, ntoks) end
    end
    ::case6::
    do
      do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
    end
    ::swend1::
  end
end

-- inlet.c:362
F.inlet_readUsageParams = function(tok, ntoks)
  local G_Link = G.Link
  local linkIndex = 0
  local designIndex = 0
  local nodeIndex = 0
  local numInlets = {1}
  local placement = AUTOMATIC
  local flowLimit = {0.0}
  local pctClogged = {0.0}
  local aLocal = {0.0}
  local wLocal = {0.0}
  local inlet = nil
  if (ntoks < 3) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  linkIndex = F.project_findObject(LINK, tok[0])
  if (linkIndex < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  designIndex = F.project_findObject(INLET, tok[1])
  if (designIndex < 0) then
    do return F.error_setInpError(ERR_NAME, tok[1]) end
  end
  nodeIndex = F.project_findObject(NODE, tok[2])
  if (nodeIndex < 0) then
    do return F.error_setInpError(ERR_NAME, tok[2]) end
  end
  if (ntoks > 3) then
    if ((not (F.getInt(tok[3], numInlets, 1) ~= 0)) or (numInlets[1] < 1)) then
      do return F.error_setInpError(ERR_NUMBER, tok[3]) end
    end
  end
  if (ntoks > 4) then
    if (((not (F.getDouble(tok[4], pctClogged, 1) ~= 0)) or (pctClogged[1] < 0.0)) or (pctClogged[1] > 99.0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[4]) end
    end
  end
  if (ntoks > 5) then
    if ((not (F.getDouble(tok[5], flowLimit, 1) ~= 0)) or (flowLimit[1] < 0.0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[5]) end
    end
  end
  if (ntoks > 6) then
    if ((not (F.getDouble(tok[6], aLocal, 1) ~= 0)) or (aLocal[1] < 0.0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[6]) end
    end
  end
  if (ntoks > 7) then
    if ((not (F.getDouble(tok[7], wLocal, 1) ~= 0)) or (wLocal[1] < 0.0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[7]) end
    end
  end
  if (ntoks > 8) then
    placement = F.findmatch(tok[8], G.PlacementTypeWords)
    if (placement < 0) then
      do return F.error_setInpError(ERR_KEYWORD, tok[8]) end
    end
  end
  inlet = G_Link[linkIndex].inlet
  if (inlet == (nil)) then
    inlet = T.TInlet()
    if (not (inlet ~= nil)) then
      do return F.error_setInpError(ERR_MEMORY, S[0]) end
    end
    G_Link[linkIndex].inlet = inlet
    inlet.nextInlet = G.FirstInlet
    G.FirstInlet = inlet
  end
  inlet.linkIndex = linkIndex
  inlet.designIndex = designIndex
  inlet.nodeIndex = nodeIndex
  inlet.numInlets = numInlets[1]
  inlet.placement = placement
  inlet.clogFactor = (1.0 - ((pctClogged[1] / 100.0)))
  inlet.flowLimit = (flowLimit[1] / F.UCF(FLOW))
  inlet.localDepress = (aLocal[1] / F.UCF(LENGTH))
  inlet.localWidth = (wLocal[1] / F.UCF(LENGTH))
  inlet.flowFactor = 0.0
  inlet.backflowRatio = 0.0
  F.initInletStats(inlet)
  G.UsesInlets = 1
  do return 0 end
end

-- inlet.c:464
F.inlet_validate = function()
  local G_Link, G_InletDesigns, G_Curve, G_Node = G.Link, G.InletDesigns, G.Curve, G.Node
  local i = 0
  local j = 0
  local inletType = 0
  local inletValid = 0
  local inlet = nil
  local prevInlet = nil
  if (not (G.UsesInlets ~= 0)) then
    do return end
  end
  prevInlet = G.FirstInlet
  inlet = G.FirstInlet
  while (inlet ~= nil) do
    do
      inletValid = 0
      i = inlet.linkIndex
      G.xsect = G_Link[i].xsect
      inletType = G_InletDesigns[inlet.designIndex].type_
      if (inletType == CUSTOM_INLET) then
        j = G_InletDesigns[inlet.designIndex].customCurve
        if (j >= 0) then
          if ((G_Curve[j].curveType == DIVERSION_CURVE) or (G_Curve[j].curveType == RATING_CURVE)) then
            inletValid = 1
          end
        end
      elseif ((((G.xsect.type_ == TRAPEZOIDAL) or (G.xsect.type_ == RECT_OPEN))) and (((inletType == DROP_GRATE_INLET) or (inletType == DROP_CURB_INLET)))) then
        inletValid = 1
      elseif (((G.xsect.type_ == STREET_XSECT) and (inletType ~= DROP_GRATE_INLET)) and (inletType ~= DROP_CURB_INLET)) then
        inletValid = 1
      end
      if (inletValid ~= 0) then
        G_Node[G_Link[i].node2].inlet = BYPASS
        G_Node[inlet.nodeIndex].inlet = CAPTURE
        inlet.backflow = 0.0
        F.getConduitGeometry(inlet)
        inlet.flowFactor = ((((0.56 / G.n)) * (G.SL ^ 0.5)) * (G.Sx ^ 1.67))
        prevInlet = inlet
        inlet = inlet.nextInlet
      else
        F.report_writeWarningMsg(S[187], G_Link[i].ID)
        if (inlet == G.FirstInlet) then
          G.FirstInlet = inlet.nextInlet
          prevInlet = G.FirstInlet
          local _ = nil
          inlet = G.FirstInlet
        else
          prevInlet.nextInlet = inlet.nextInlet
          local _ = nil
          inlet = prevInlet.nextInlet
        end
        G_Link[i].inlet = (nil)
      end
    end
  end
  F.getBackflowRatios()
end

-- inlet.c:555
F.inlet_findCapturedFlows = function(tStep)
  local G_InletFlow, G_Nobjects, G_Node, G_Link, G_FirstInlet, G_InletDesigns = G.InletFlow, G.Nobjects, G.Node, G.Link, G.FirstInlet, G.InletDesigns
  local i = 0
  local j = 0
  local m = 0
  local placement = 0
  local q = 0.0
  local inlet = nil
  if (not (G.UsesInlets ~= 0)) then
    do return end
  end
  R.memset(G_InletFlow, 0, (G_Nobjects[NODE] * 8))
  if (G.RouteModel ~= DW) then
    do
      j = 0
      while (j < G_Nobjects[NODE]) do
        do
          G_Node[j].inflow = (((((0.0) >= (G_Node[j].newLatFlow))) and (0.0) or (G_Node[j].newLatFlow)))
        end
        j = j + 1
      end
    end
    do
      i = 0
      while (i < G_Nobjects[LINK]) do
        do
          G_Node[G_Link[i].node2].inflow = (G_Node[G_Link[i].node2].inflow + (((((0.0) >= (G_Link[i].newFlow))) and (0.0) or (G_Link[i].newFlow))))
        end
        i = i + 1
      end
    end
  end
  do
    inlet = G_FirstInlet
    while (inlet ~= (nil)) do
      do
        i = inlet.linkIndex
        j = G_Link[i].node2
        m = inlet.nodeIndex
        placement = F.getInletPlacement(inlet, j)
        if (G_InletDesigns[inlet.designIndex].type_ == CUSTOM_INLET) then
          q = m_abs(G_Link[i].newFlow)
          inlet.flowCapture = F.getCustomCapturedFlow(inlet, q, G_Node[j].newDepth)
        elseif (placement == ON_GRADE) then
          q = m_abs(G_Link[i].newFlow)
          inlet.flowCapture = F.getOnGradeCapturedFlow(inlet, q, G_Node[j].newDepth)
        else
          q = G_Node[j].inflow
          inlet.flowCapture = F.getOnSagCapturedFlow(inlet, q, G_Node[j].newDepth)
        end
        if (m_abs(inlet.flowCapture) < 0.0001) then
          inlet.flowCapture = 0.0
        end
        G_InletFlow[j] = (G_InletFlow[j] + inlet.flowCapture)
        inlet.backflow = (G_Node[m].overflow * inlet.backflowRatio)
        if (m_abs(inlet.backflow) < 0.0001) then
          inlet.backflow = 0.0
        end
      end
      inlet = inlet.nextInlet
    end
  end
  do
    inlet = G_FirstInlet
    while (inlet ~= (nil)) do
      do
        i = inlet.linkIndex
        j = G_Link[i].node2
        m = inlet.nodeIndex
        if ((G.RouteModel ~= DW) and (F.getInletPlacement(inlet, j) == ON_SAG)) then
          q = (G_Node[j].newVolume / tStep)
          q = (q + (((((G_Node[j].inflow) >= (0.0))) and (G_Node[j].inflow) or (0.0))))
          if (G_InletFlow[j] > q) then
            inlet.flowCapture = (inlet.flowCapture * (q / G_InletFlow[j]))
          end
        end
        G_Node[j].newLatFlow = (G_Node[j].newLatFlow - ((inlet.flowCapture - inlet.backflow)))
        G_Node[m].newLatFlow = (G_Node[m].newLatFlow + inlet.flowCapture)
        if (F.getDateTime(G.NewRoutingTime) > G.ReportStart) then
          F.updateInletStats(inlet, m_abs(G_Link[i].newFlow))
        end
      end
      inlet = inlet.nextInlet
    end
  end
end

-- inlet.c:655
F.inlet_adjustQualInflows = function()
  local G_Nobjects, G_FirstInlet, G_Link, G_Node = G.Nobjects, G.FirstInlet, G.Link, G.Node
  local i = 0
  local j = 0
  local m = 0
  local p = 0
  local qNet = 0.0
  local inlet = nil
  if (not (G.UsesInlets ~= 0)) then
    do return end
  end
  if ((G.IgnoreQuality ~= 0) or (G_Nobjects[POLLUT] == 0)) then
    do return end
  end
  do
    inlet = G_FirstInlet
    while (inlet ~= (nil)) do
      do
        i = inlet.linkIndex
        j = G_Link[i].node2
        m = inlet.nodeIndex
        qNet = (inlet.flowCapture - inlet.backflow)
        if (qNet > 0.0) then
          G_Node[m].qualInflow = (G_Node[m].qualInflow + qNet)
          do
            p = 0
            while (p < G_Nobjects[POLLUT]) do
              do
                G_Node[m].newQual[p] = (G_Node[m].newQual[p] + (qNet * G_Node[j].oldQual[p]))
              end
              p = p + 1
            end
          end
        else
          qNet = (-qNet)
          G_Node[j].qualInflow = (G_Node[j].qualInflow + qNet)
          do
            p = 0
            while (p < G_Nobjects[POLLUT]) do
              do
                G_Node[j].newQual[p] = (G_Node[j].newQual[p] + (qNet * G_Node[m].oldQual[p]))
              end
              p = p + 1
            end
          end
        end
      end
      inlet = inlet.nextInlet
    end
  end
end

-- inlet.c:706
F.inlet_adjustQualOutflows = function()
  local G_Nobjects, G_Node, G_StepFlowTotals, G_StepQualTotals, G_FirstInlet, G_Link = G.Nobjects, G.Node, G.StepFlowTotals, G.StepQualTotals, G.FirstInlet, G.Link
  local j = 0
  local p = 0
  local q = 0.0
  local w = 0.0
  local inlet = nil
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        if (G_Node[j].inlet == CAPTURE) then
          q = G_Node[j].overflow
          if (q > 0.0) then
            G_StepFlowTotals.flooding = (G_StepFlowTotals.flooding - q)
            if (not (G.IgnoreQuality ~= 0)) then
              do
                p = 0
                while (p < G_Nobjects[POLLUT]) do
                  do
                    w = (q * G_Node[j].newQual[p])
                    G_StepQualTotals[p].flooding = (G_StepQualTotals[p].flooding - w)
                  end
                  p = p + 1
                end
              end
            end
          end
        end
      end
      j = j + 1
    end
  end
  if ((not (G.IgnoreQuality ~= 0)) and (G_Nobjects[POLLUT] > 0)) then
    do
      inlet = G_FirstInlet
      while (inlet ~= (nil)) do
        do
          j = G_Link[inlet.linkIndex].node2
          q = (inlet.flowCapture - inlet.backflow)
          if ((q > 0.0) and (G_Node[j].newLatFlow < 0.0)) then
            do
              p = 0
              while (p < G_Nobjects[POLLUT]) do
                do
                  w = (q * G_Node[j].newQual[p])
                  G_StepQualTotals[p].outflow = (G_StepQualTotals[p].outflow - w)
                end
                p = p + 1
              end
            end
          end
        end
        inlet = inlet.nextInlet
      end
    end
  end
end

-- inlet.c:774
F.inlet_writeStatsReport = function()
  local G_Nobjects, G_Link = G.Nobjects, G.Link
  local j = 0
  local header = 0
  if (G_Nobjects[STREET] == 0) then
    do return end
  end
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        if (G_Link[j].xsect.type_ == STREET_XSECT) then
          if (not (header ~= 0)) then
            F.writeStreetStatsHeader()
            header = 1
          end
          F.writeStreetStats(j)
        end
      end
      j = j + 1
    end
  end
  F.report_writeLine(S[0])
end

-- inlet.c:801
F.inlet_capturedFlow = function(i)
  local G_Link = G.Link
  if (G_Link[i].inlet ~= nil) then
    do return G_Link[i].inlet.flowCapture end
  end
  do return 0.0 end
end

-- inlet.c:814
F.readGrateInletParams = function(i, tok, ntoks)
  local G_InletDesigns = G.InletDesigns
  local grateType = 0
  local width = {0.0}
  local length = {0.0}
  local areaRatio = {0.0}
  local vSplash = {0.0}
  if (ntoks < 5) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  if ((not (F.getDouble(tok[2], length, 1) ~= 0)) or (length[1] <= 0.0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[2]) end
  end
  if ((not (F.getDouble(tok[3], width, 1) ~= 0)) or (width[1] <= 0.0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[3]) end
  end
  grateType = F.findmatch(tok[4], G.GrateTypeWords)
  if (grateType < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[4]) end
  end
  if (grateType == GENERIC) then
    if (ntoks < 6) then
      do return F.error_setInpError(ERR_ITEMS, S[0]) end
    end
    if (((not (F.getDouble(tok[5], areaRatio, 1) ~= 0)) or (areaRatio[1] <= 0.0)) or (areaRatio[1] > 1.0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[5]) end
    end
    if (ntoks > 6) then
      if ((not (F.getDouble(tok[6], vSplash, 1) ~= 0)) or (vSplash[1] < 0.0)) then
        do return F.error_setInpError(ERR_NUMBER, tok[6]) end
      end
    end
  end
  G_InletDesigns[i].grateInlet.length = (length[1] / F.UCF(LENGTH))
  G_InletDesigns[i].grateInlet.width = (width[1] / F.UCF(LENGTH))
  G_InletDesigns[i].grateInlet.type_ = grateType
  G_InletDesigns[i].grateInlet.fracOpenArea = areaRatio[1]
  G_InletDesigns[i].grateInlet.splashVeloc = (vSplash[1] / F.UCF(LENGTH))
  if ((G_InletDesigns[i].type_ == GRATE_INLET) and (G_InletDesigns[i].curbInlet.length > 0.0)) then
    G_InletDesigns[i].type_ = COMBO_INLET
  end
  do return 0 end
end

-- inlet.c:868
F.readCurbInletParams = function(i, tok, ntoks)
  local G_InletDesigns = G.InletDesigns
  local throatAngle = 0
  local height = {0.0}
  local length = {0.0}
  if (ntoks < 4) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  if ((not (F.getDouble(tok[2], length, 1) ~= 0)) or (length[1] <= 0.0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[2]) end
  end
  if ((not (F.getDouble(tok[3], height, 1) ~= 0)) or (height[1] <= 0.0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[3]) end
  end
  throatAngle = VERTICAL_THROAT
  if ((G_InletDesigns[i].type_ == CURB_INLET) and (ntoks > 4)) then
    throatAngle = F.findmatch(tok[4], G.ThroatAngleWords)
    if (throatAngle < 0) then
      do return F.error_setInpError(ERR_KEYWORD, tok[4]) end
    end
  end
  G_InletDesigns[i].curbInlet.length = (length[1] / F.UCF(LENGTH))
  G_InletDesigns[i].curbInlet.height = (height[1] / F.UCF(LENGTH))
  G_InletDesigns[i].curbInlet.throatAngle = throatAngle
  if ((G_InletDesigns[i].type_ == CURB_INLET) and (G_InletDesigns[i].grateInlet.length > 0.0)) then
    G_InletDesigns[i].type_ = COMBO_INLET
  end
  do return 0 end
end

-- inlet.c:911
F.readSlottedInletParams = function(i, tok, ntoks)
  local G_InletDesigns = G.InletDesigns
  local width = {0.0}
  local length = {0.0}
  if (ntoks < 4) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  if ((not (F.getDouble(tok[2], length, 1) ~= 0)) or (length[1] <= 0.0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[2]) end
  end
  if ((not (F.getDouble(tok[3], width, 1) ~= 0)) or (width[1] <= 0.0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[3]) end
  end
  G_InletDesigns[i].slottedInlet.length = (length[1] / F.UCF(LENGTH))
  G_InletDesigns[i].slottedInlet.width = (width[1] / F.UCF(LENGTH))
  do return 0 end
end

-- inlet.c:939
F.readCustomInletParams = function(i, tok, ntoks)
  local c = 0
  if (ntoks < 3) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  else
    c = F.project_findObject(CURVE, tok[2])
    if (c < 0) then
      do return F.error_setInpError(ERR_NAME, tok[2]) end
    end
  end
  G.InletDesigns[i].customCurve = c
  do return 0 end
end

-- inlet.c:962
F.initInletStats = function(inlet)
  if (inlet ~= nil) then
    inlet.flowCapture = 0.0
    inlet.backflow = 0.0
    inlet.stats.flowPeriods = 0
    inlet.stats.capturePeriods = 0
    inlet.stats.backflowPeriods = 0
    inlet.stats.peakFlow = 0.0
    inlet.stats.peakFlowCapture = 0.0
    inlet.stats.avgFlowCapture = 0.0
    inlet.stats.bypassFreq = 0.0
  end
end

-- inlet.c:985
F.updateInletStats = function(inlet, q)
  local qCapture = inlet.flowCapture
  local qBackflow = inlet.backflow
  local qNet = (qCapture - qBackflow)
  local qBypass = (q - qNet)
  local fCapture = 0.0
  if ((q < 0.001) and (qBackflow <= 0.0)) then
    do return end
  end
  inlet.stats.flowPeriods = inlet.stats.flowPeriods + 1
  if (qNet > 0.0) then
    inlet.stats.capturePeriods = inlet.stats.capturePeriods + 1
    fCapture = (qNet / q)
    fCapture = (((((fCapture) <= (1.0))) and (fCapture) or (1.0)))
    inlet.stats.avgFlowCapture = (inlet.stats.avgFlowCapture + fCapture)
    if (qBypass > 0.001) then
      inlet.stats.bypassFreq = inlet.stats.bypassFreq + 1.0
    end
  else
    inlet.stats.backflowPeriods = inlet.stats.backflowPeriods + 1
  end
  if (q > inlet.stats.peakFlow) then
    inlet.stats.peakFlow = q
    inlet.stats.peakFlowCapture = (fCapture * 100.0)
  end
end

-- inlet.c:1026
F.writeStreetStatsHeader = function()
  local G_Frpt, G_FlowUnitWords = G.Frpt, G.FlowUnitWords
  F.report_writeLine(S[0])
  F.report_writeLine(S[188])
  F.report_writeLine(S[189])
  F.report_writeLine(S[188])
  F.report_writeLine(S[0])
  R.fprintf(G_Frpt.file, S[190])
  if (G.UnitSystem == US) then
    R.fprintf(G_Frpt.file, S[191], G_FlowUnitWords[G.FlowUnits], G_FlowUnitWords[G.FlowUnits], G_FlowUnitWords[G.FlowUnits])
  else
    R.fprintf(G_Frpt.file, S[192], G_FlowUnitWords[G.FlowUnits], G_FlowUnitWords[G.FlowUnits], G_FlowUnitWords[G.FlowUnits])
  end
  R.fprintf(G_Frpt.file, S[193])
end

-- inlet.c:1055
F.writeStreetStats = function(link)
  local G_Link, G_LinkStats, G_Street, G_Frpt = G.Link, G.LinkStats, G.Street, G.Frpt
  local k = 0
  local t = 0
  local placement = 0
  local maxSpread = 0.0
  local maxDepth = 0.0
  local maxFlow = 0.0
  local fp = 0.0
  local cp = 0.0
  local afc = 0.0
  local bpf = 0.0
  local inlet = nil
  k = G_Link[link].subIndex
  t = G_Link[link].xsect.transect
  inlet = G_Link[link].inlet
  maxFlow = G_LinkStats[link].maxFlow
  maxDepth = G_LinkStats[link].maxDepth
  maxSpread = (F.xsect_getWofY(G_Link[link].xsect, maxDepth) / (G_Street[t].sides * 1.0))
  maxSpread = (((((maxSpread) <= (G_Street[t].width))) and (maxSpread) or (G_Street[t].width)))
  R.fprintf(G_Frpt.file, S[194], G_Link[link].ID)
  R.fprintf(G_Frpt.file, S[195], (maxFlow * F.UCF(FLOW)))
  R.fprintf(G_Frpt.file, S[195], (maxSpread * F.UCF(LENGTH)))
  R.fprintf(G_Frpt.file, S[195], (maxDepth * F.UCF(LENGTH)))
  if (inlet ~= nil) then
    R.fprintf(G_Frpt.file, S[196], G.InletDesigns[inlet.designIndex].ID)
    placement = F.getInletPlacement(inlet, G_Link[inlet.linkIndex].node2)
    if (placement == ON_GRADE) then
      R.fprintf(G_Frpt.file, S[197])
    else
      R.fprintf(G_Frpt.file, S[198])
    end
    R.fprintf(G_Frpt.file, S[199], inlet.numInlets)
    fp = ((inlet.stats.flowPeriods * 1.0) / 100.0)
    if (fp > 0.0) then
      cp = ((inlet.stats.capturePeriods * 1.0) / 100.0)
      R.fprintf(G_Frpt.file, S[200], inlet.stats.peakFlowCapture)
      if (cp > 0.0) then
        afc = (inlet.stats.avgFlowCapture / cp)
        bpf = (inlet.stats.bypassFreq / cp)
      end
      R.fprintf(G_Frpt.file, S[200], afc)
      R.fprintf(G_Frpt.file, S[200], bpf)
      R.fprintf(G_Frpt.file, S[200], ((inlet.stats.backflowPeriods * 1.0) / fp))
      R.fprintf(G_Frpt.file, S[200], ((((((maxFlow / (G_Street[t].sides * 1.0))) * F.UCF(FLOW)) * 0.01) * inlet.stats.peakFlowCapture) / (inlet.numInlets * 1.0)))
      R.fprintf(G_Frpt.file, S[200], (((maxFlow * F.UCF(FLOW)) * 0.01) * ((100.0 - inlet.stats.peakFlowCapture))))
    end
  end
end

-- inlet.c:1129
F.getInletPlacement = function(inlet, j)
  if (inlet.placement == AUTOMATIC) then
    if (G.Node[j].degree > 0) then
      do return ON_GRADE end
    else
      do return ON_SAG end
    end
  else
    do return inlet.placement end
  end
end

-- inlet.c:1147
F.getConduitGeometry = function(inlet)
  local G_Link, G_Conduit, G_Street = G.Link, G.Conduit, G.Street
  local linkIndex = inlet.linkIndex
  local t = 0
  local k = G_Link[linkIndex].subIndex
  G.SL = G_Conduit[k].slope
  G.Beta = G_Conduit[k].beta
  G.xsect = G_Link[linkIndex].xsect
  if (G.xsect.type_ == STREET_XSECT) then
    t = G.xsect.transect
    G.Sx = G_Street[t].slope
    G.a = G_Street[t].gutterDepression
    G.W = G_Street[t].gutterWidth
    G.n = G_Street[t].roughness
    G.Nsides = G_Street[t].sides
    G.Tcrown = G_Street[t].width
    G.Qfactor = inlet.flowFactor
    if ((inlet ~= nil) and ((inlet.localDepress * inlet.localWidth) > 0.0)) then
      G.a = (G.a + inlet.localDepress)
      G.W = inlet.localWidth
    end
    if ((G.W * G.a) > 0.0) then
      G.Sw = (G.Sx + (G.a / G.W))
    else
      G.Sw = G.Sx
    end
  else
    G.a = 0.0
    G.W = 0.0
    G.n = G_Conduit[k].roughness
    G.Nsides = 1
    G.Sx = 0.01
    G.Sw = G.Sx
  end
end

-- inlet.c:1200
F.getFlowSpread = function(Q)
  local iter = 0
  local f = 0.0
  local f1 = 0.0
  local Sr = 0.0
  local Ts1 = 0.0
  local Ts2 = 0.0
  local Tw = 0.0
  local Qs = 0.0
  local Eo = 0.0
  f = G.Qfactor
  if (G.a == 0.0) then
    Ts1 = ((Q / f) ^ 0.375)
  else
    f1 = (f * ((((G.a / G.W)) / G.Sx) ^ 1.67))
    Tw = ((Q / f1) ^ 0.375)
    if (Tw <= G.W) then
      Ts1 = Tw
    else
      Sr = (((G.Sx + (G.a / G.W))) / G.Sx)
      iter = 1
      Ts1 = (((Q / f) ^ 0.375) - G.W)
      if (Ts1 <= 0.0) then
        Ts1 = (Tw - G.W)
      end
      while (iter < 11) do
        do
          Eo = F.getEo(Sr, Ts1, G.W)
          Qs = (((1.0 - Eo)) * Q)
          Ts2 = ((Qs / f) ^ 0.375)
          if (m_abs((Ts2 - Ts1)) < 0.01) then
            break
          end
          Ts1 = Ts2
          iter = iter + 1
        end
      end
      Ts1 = (Ts2 + G.W)
    end
  end
  do return (((((Ts1) <= (G.Tcrown))) and (Ts1) or (G.Tcrown))) end
end

-- inlet.c:1248
F.getEo = function(Sr, Ts, w)
  local x = 0.0
  x = (Sr / ((Ts / w)))
  x = ((((1.0 + x)) ^ 2.67) - 1.0)
  x = (1.0 + (Sr / x))
  do return (1.0 / x) end
end

-- inlet.c:1267
F.getOnGradeCapturedFlow = function(inlet, q, d)
  local i = 0
  local linkIndex = 0
  local qApproach = 0.0
  local qc = 0.0
  local qCaptured = 0.0
  local qBypassed = 0.0
  local qMax = 0.0
  if (inlet.numInlets == 0) then
    do return 0.0 end
  end
  linkIndex = inlet.linkIndex
  qApproach = q
  if (qApproach < 0.001) then
    do return 0.0 end
  end
  F.getConduitGeometry(inlet)
  qApproach = (qApproach / (G.Nsides * 1.0))
  qBypassed = qApproach
  qCaptured = 0.0
  qMax = 10000000000.0
  if (inlet.flowLimit > 0.0) then
    qMax = inlet.flowLimit
  end
  do
    i = 1
    while (i <= inlet.numInlets) do
      do
        qc = (F.getOnGradeInletCapture(inlet.designIndex, qBypassed, d) * inlet.clogFactor)
        qc = (((((qc) <= (qMax))) and (qc) or (qMax)))
        qc = (((((qc) <= (qBypassed))) and (qc) or (qBypassed)))
        qCaptured = (qCaptured + qc)
        qBypassed = (qBypassed - qc)
        if (qBypassed < 0.001) then
          break
        end
      end
      i = i + 1
    end
  end
  qCaptured = (qCaptured * (G.Nsides * 1.0))
  do return qCaptured end
end

-- inlet.c:1325
F.getOnGradeInletCapture = function(i, Q, d)
  local G_InletDesigns = G.InletDesigns
  local Q1 = Q
  local Qc = 0.0
  local Lsweep = 0.0
  local Lcurb = 0.0
  local Lgrate = 0.0
  if (G_InletDesigns[i].type_ == DROP_CURB_INLET) then
    Qc = F.getOnSagInletCapture(i, d)
    do return (((((Qc) <= (Q))) and (Qc) or (Q))) end
  end
  if (G_InletDesigns[i].type_ == DROP_GRATE_INLET) then
    Qc = F.getGrateInletCapture(i, Q)
    do return (((((Qc) <= (Q))) and (Qc) or (Q))) end
  end
  G.T_ = F.getFlowSpread(Q)
  if (G_InletDesigns[i].type_ == SLOTTED_INLET) then
    Qc = F.getCurbInletCapture(Q, G_InletDesigns[i].slottedInlet.length)
    do return (((((Qc) <= (Q))) and (Qc) or (Q))) end
  end
  Lcurb = G_InletDesigns[i].curbInlet.length
  Lgrate = G_InletDesigns[i].grateInlet.length
  if (Lcurb > 0.0) then
    Lsweep = (Lcurb - Lgrate)
    if (Lsweep > 0.0) then
      Qc = F.getCurbInletCapture(Q1, Lsweep)
      Q1 = (Q1 - Qc)
    end
  end
  if ((Lgrate > 0.0) and (Q1 > 0.0)) then
    if (Q1 ~= Q) then
      G.T_ = F.getFlowSpread(Q1)
    end
    Qc = (Qc + (F.getGrateInletCapture(i, Q1)))
  end
  do return Qc end
end

-- inlet.c:1387
F.getGrateInletCapture = function(i, Q)
  local G_InletDesigns, G_xsect = G.InletDesigns, G.xsect
  local grateType = 0
  local Lg = 0.0
  local Wg = 0.0
  local A = 0.0
  local Y = 0.0
  local Eo = 0.0
  local V = 0.0
  local Vo = 0.0
  local Qo = Q
  local Rf = 1.0
  local Rs = 0.0
  Lg = G_InletDesigns[i].grateInlet.length
  Wg = G_InletDesigns[i].grateInlet.width
  if ((G_xsect.type_ == TRAPEZOIDAL) or (G_xsect.type_ == RECT_OPEN)) then
    A = F.xsect_getAofS(G_xsect, (Q / G.Beta))
    Y = F.xsect_getYofA(G_xsect, A)
    G.T_ = F.xsect_getWofY(G_xsect, Y)
    Eo = (((G.Beta * ((Y * Wg) ^ 1.67)) / ((Wg + (2.0 * Y)) ^ 0.67)) / Q)
    if (((Wg > (0.99 * G_xsect.yBot)) and (G_xsect.type_ == TRAPEZOIDAL)) and (G_xsect.sBot > 0.0)) then
      Wg = G_xsect.yBot
      G.Sx = (1.0 / G_xsect.sBot)
    end
  elseif (G.a == 0.0) then
    A = (((G.T_ * G.T_) * G.Sx) / 2.0)
    Eo = F.getGutterFlowRatio(Wg)
    if (G.T_ >= G.Tcrown) then
      Qo = (G.Qfactor * (G.Tcrown ^ 2.67))
    end
  else
    if (G.T_ <= G.W) then
      A = (((G.T_ * G.T_) * G.Sw) / 2.0)
    else
      A = (((((G.T_ * G.T_) * G.Sx) + (G.a * G.W))) / 2.0)
    end
    Eo = F.getGutterFlowRatio(G.W)
    if (Eo < 1.0) then
      if (G.T_ >= G.Tcrown) then
        Qo = ((G.Qfactor * (G.Tcrown ^ 2.67)) / ((1.0 - Eo)))
      end
      Eo = (Eo * F.getGutterAreaRatio(Wg, A))
    end
  end
  V = (Qo / A)
  grateType = G_InletDesigns[i].grateInlet.type_
  if ((grateType < 0) or (grateType == GENERIC)) then
    Vo = G_InletDesigns[i].grateInlet.splashVeloc
  else
    Vo = F.getSplashOverVelocity(grateType, Lg)
  end
  if (V > Vo) then
    Rf = (1.0 - (0.09 * ((V - Vo))))
  end
  if (Eo < 1.0) then
    Rs = (1.0 / ((1.0 + ((((0.15 * (V ^ 1.8)) / G.Sx) / (Lg ^ 2.3))))))
  end
  do return (Q * (((Rf * Eo) + (Rs * ((1.0 - Eo)))))) end
end

-- inlet.c:1477
F.getCurbInletCapture = function(Q, L)
  local Se = G.Sx
  local Lt = 0.0
  local Sr = 0.0
  local Eo = 0.0
  local E = 1.0
  if (G.a > 0.0) then
    Sr = (G.Sw / G.Sx)
    Eo = F.getEo(Sr, (G.T_ - G.W), G.W)
    Se = (G.Sx + (((G.a / G.W)) * Eo))
  end
  Lt = (((0.6 * (Q ^ 0.42)) * (G.SL ^ 0.3)) * ((1.0 / ((G.n * Se))) ^ 0.6))
  if (L < Lt) then
    E = (1.0 - ((L / Lt)))
    E = (1.0 - (E ^ 1.8))
  end
  E = (((((E) <= (1.0))) and (E) or (1.0)))
  E = (((((E) >= (0.0))) and (E) or (0.0)))
  do return (E * Q) end
end

-- inlet.c:1518
F.getGutterFlowRatio = function(w)
  if (G.T_ <= w) then
    do return 1.0 end
  elseif (G.a > 0.0) then
    do return F.getEo((G.Sw / G.Sx), (G.T_ - w), w) end
  else
    do return (1.0 - (((1.0 - (w / G.T_))) ^ 2.67)) end
  end
end

-- inlet.c:1535
F.getGutterAreaRatio = function(Wg, A)
  local As = 0.0
  local Ag = 0.0
  if (Wg >= G.W) then
    do return 1.0 end
  end
  if (G.T_ <= Wg) then
    do return 1.0 end
  end
  if (G.T_ <= G.W) then
    do return (Wg / G.T_) end
  end
  As = ((0.5 * (((((G.T_ - G.W))) * (((G.T_ - G.W)))))) * G.Sx)
  Ag = (Wg * (((((G.T_ * G.Sx)) + G.a) - (((Wg * G.Sw) / 2.0)))))
  do return (Ag / ((A - As))) end
end

-- inlet.c:1557
F.getSplashOverVelocity = function(grateType, L)
  local G_SplashCoeffs = G.SplashCoeffs
  do return (((G_SplashCoeffs[grateType][0] + (G_SplashCoeffs[grateType][1] * L)) - ((G_SplashCoeffs[grateType][2] * L) * L)) + (((G_SplashCoeffs[grateType][3] * L) * L) * L)) end
end

-- inlet.c:1574
F.getOnSagCapturedFlow = function(inlet, q, d)
  local linkIndex = 0
  local designIndex = 0
  local totalInlets = 0
  local qCaptured = 0.0
  local qMax = 10000000000.0
  if (inlet.numInlets == 0) then
    do return 0.0 end
  end
  totalInlets = (G.Nsides * inlet.numInlets)
  linkIndex = inlet.linkIndex
  designIndex = inlet.designIndex
  F.getConduitGeometry(inlet)
  if (inlet.flowLimit > 0.0) then
    qMax = inlet.flowLimit
  end
  qCaptured = F.getOnSagInletCapture(designIndex, m_abs(d))
  qCaptured = (qCaptured * inlet.clogFactor)
  qCaptured = (((((qCaptured) <= (qMax))) and (qCaptured) or (qMax)))
  qCaptured = (qCaptured * (totalInlets * 1.0))
  do return qCaptured end
end

-- inlet.c:1610
F.getOnSagInletCapture = function(i, d)
  local G_InletDesigns = G.InletDesigns
  local Lsweep = 0.0
  local Lcurb = 0.0
  local Lgrate = 0.0
  local Qsw = {0.0}
  local Qso = {0.0}
  local Qgw = {0.0}
  local Qgo = {0.0}
  local Qcw = {0.0}
  local Qco = {0.0}
  if (G_InletDesigns[i].slottedInlet.length > 0.0) then
    do return F.getOnSagSlottedFlow(i, d) end
  end
  Lgrate = G_InletDesigns[i].grateInlet.length
  if (Lgrate > 0.0) then
    F.findOnSagGrateFlows(i, d, Qgw, 1, Qgo, 1)
  end
  Lcurb = G_InletDesigns[i].curbInlet.length
  if (Lcurb > 0.0) then
    Lsweep = (Lcurb - Lgrate)
    if (Lsweep > 0.0) then
      F.findOnSagCurbFlows(i, d, Lsweep, Qsw, 1, Qso, 1)
    end
    if (Qgo[1] > 0.0) then
      F.findOnSagCurbFlows(i, d, Lgrate, Qcw, 1, Qco, 1)
    end
  end
  do return ((((Qgw[1] + Qgo[1]) + Qsw[1]) + Qso[1]) + Qco[1]) end
end

-- inlet.c:1644
F.findOnSagGrateFlows = function(i, d, Qw, Qw__k, Qo, Qo__k)
  local G_InletDesigns = G.InletDesigns
  local grateType = G_InletDesigns[i].grateInlet.type_
  local Lg = G_InletDesigns[i].grateInlet.length
  local Wg = G_InletDesigns[i].grateInlet.width
  local P = 0.0
  local Ao = 0.0
  local di = 0.0
  if (G_InletDesigns[i].type_ == DROP_GRATE_INLET) then
    di = d
    P = (2.0 * ((Lg + Wg)))
  else
    if (d <= (Wg * G.Sw)) then
      Wg = (d / G.Sw)
    end
    di = (d - (((Wg / 2.0)) * G.Sw))
    P = (Lg + (2.0 * Wg))
  end
  if (grateType == GENERIC) then
    Ao = ((Lg * Wg) * G_InletDesigns[i].grateInlet.fracOpenArea)
  else
    Ao = ((Lg * Wg) * G.GrateOpeningRatios[grateType])
  end
  if (d <= ((1.79 * Ao) / P)) then
    Qw[Qw__k] = ((3.0 * P) * (di ^ 1.5))
  else
    Qo[Qo__k] = ((0.67 * Ao) * m_sqrt(((2.0 * 32.16) * di)))
  end
end

-- inlet.c:1703
F.findOnSagCurbFlows = function(i, d, L, Qw, Qw__k, Qo, Qo__k)
  local G_InletDesigns = G.InletDesigns
  local throatAngle = G_InletDesigns[i].curbInlet.throatAngle
  local h = G_InletDesigns[i].curbInlet.height
  local Qweir = 0.0
  local Qorif = 0.0
  local P = 0.0
  local dweir = 0.0
  local dorif = 0.0
  local r = 0.0
  if (L <= 0.0) then
    do return end
  end
  if (G_InletDesigns[i].type_ == DROP_CURB_INLET) then
    L = (L * 4.0)
  end
  dorif = (1.4 * h)
  if (d > dorif) then
    Qo[Qo__k] = F.getCurbOrificeFlow(d, h, L, throatAngle)
    do return end
  end
  if ((G.a == 0.0) or (L > 12.0)) then
    dweir = h
    if (d < dweir) then
      Qw[Qw__k] = ((3.0 * L) * (d ^ 1.5))
      do return end
    else
      Qweir = ((3.0 * L) * (dweir ^ 1.5))
    end
  else
    P = (L + (1.8 * G.W))
    dweir = (h + G.a)
    if (d < dweir) then
      Qw[Qw__k] = ((2.3 * P) * (d ^ 1.5))
      do return end
    else
      Qweir = ((2.3 * P) * (dweir ^ 1.5))
    end
  end
  Qorif = F.getCurbOrificeFlow(dorif, h, L, throatAngle)
  r = (((d - dweir)) / ((dorif - dweir)))
  Qw[Qw__k] = (((1.0 - r)) * Qweir)
  Qo[Qo__k] = (r * Qorif)
end

-- inlet.c:1764
F.getCurbOrificeFlow = function(di, h, L, throatAngle)
  local d = di
  if (throatAngle == HORIZONTAL_THROAT) then
    d = (di - (h / 2.0))
  elseif (throatAngle == INCLINED_THROAT) then
    d = (di - (((h / 2.0)) * 0.7071))
  end
  do return (((0.67 * h) * L) * m_sqrt(((2.0 * 32.16) * d))) end
end

-- inlet.c:1785
F.getOnSagSlottedFlow = function(i, d)
  local G_InletDesigns = G.InletDesigns
  local L = G_InletDesigns[i].slottedInlet.length
  local w = G_InletDesigns[i].slottedInlet.width
  if (d <= (2.587 * w)) then
    do return ((2.48 * L) * (d ^ 1.5)) end
  else
    do return (((0.8 * L) * w) * m_sqrt((64.32 * d))) end
  end
end

-- inlet.c:1805
F.getBackflowRatios = function()
  local G_FirstInlet = G.FirstInlet
  local inlet = nil
  local area = 0.0
  local f = 0.0
  local n = 0
  local inletNodes = R.recs(G.Nobjects[NODE], T.TInletNode)
  if (inletNodes == (nil)) then
    do return end
  end
  do
    inlet = G_FirstInlet
    while (inlet ~= (nil)) do
      do
        n = inlet.nodeIndex
        inletNodes[n].numInletLinks = inletNodes[n].numInletLinks + 1
        area = F.getInletArea(inlet)
        if (area > 0.0) then
          inletNodes[n].numStdInletLinks = inletNodes[n].numStdInletLinks + 1
          inletNodes[n].totalInletArea = (inletNodes[n].totalInletArea + area)
        else
          inletNodes[n].numCustomInlets = (inletNodes[n].numCustomInlets + inlet.numInlets)
        end
      end
      inlet = inlet.nextInlet
    end
  end
  do
    inlet = G_FirstInlet
    while (inlet ~= (nil)) do
      do
        n = inlet.nodeIndex
        f = ((inletNodes[n].numStdInletLinks * 1.0) / (inletNodes[n].numInletLinks * 1.0))
        area = F.getInletArea(inlet)
        if (area == 0.0) then
          inlet.backflowRatio = (((inlet.numInlets * 1.0) / (inletNodes[n].numCustomInlets * 1.0)) * ((1.0 - f)))
        else
          inlet.backflowRatio = ((area / inletNodes[n].totalInletArea) * f)
        end
      end
      inlet = inlet.nextInlet
    end
  end
  local _ = nil
end

-- inlet.c:1870
F.getInletArea = function(inlet)
  local G_InletDesigns = G.InletDesigns
  local area = 0.0
  local curbLength = 0.0
  local i = inlet.designIndex
  local grateType = G_InletDesigns[i].grateInlet.type_
  if (G_InletDesigns[i].grateInlet.length > 0.0) then
    area = (G_InletDesigns[i].grateInlet.length * G_InletDesigns[i].grateInlet.width)
    if (grateType == GENERIC) then
      area = (area * G_InletDesigns[i].grateInlet.fracOpenArea)
    else
      area = (area * G.GrateOpeningRatios[grateType])
    end
  end
  curbLength = (G_InletDesigns[i].curbInlet.length - G_InletDesigns[i].grateInlet.length)
  if (curbLength > 0.0) then
    area = (area + (curbLength * G_InletDesigns[i].curbInlet.height))
  end
  if (G_InletDesigns[i].slottedInlet.length > 0.0) then
    area = (G_InletDesigns[i].slottedInlet.length * G_InletDesigns[i].slottedInlet.width)
  end
  do return ((area * (inlet.numInlets * 1.0)) * inlet.clogFactor) end
end

-- inlet.c:1902
F.getCustomCapturedFlow = function(inlet, q, d)
  local G_Curve = G.Curve
  local i = inlet.designIndex
  local j = 0
  local sides = 1
  local c = 0
  local qApproach = 0.0
  local qBypassed = 0.0
  local qCaptured = 0.0
  local qIncrement = 0.0
  local qMax = 10000000000.0
  if (inlet.numInlets == 0) then
    do return 0.0 end
  end
  qMax = 10000000000.0
  if (inlet.flowLimit > 0.0) then
    qMax = inlet.flowLimit
  end
  G.xsect = G.Link[inlet.linkIndex].xsect
  if (G.xsect.type_ == STREET_XSECT) then
    sides = G.Street[G.xsect.transect].sides
  end
  qApproach = (q / (sides * 1.0))
  qBypassed = qApproach
  qCaptured = 0.0
  c = G.InletDesigns[i].customCurve
  if (c >= 0) then
    if (G_Curve[c].curveType == DIVERSION_CURVE) then
      do
        j = 1
        while (j <= inlet.numInlets) do
          do
            qIncrement = ((inlet.clogFactor * F.table_lookupEx(G_Curve[c], (qBypassed * F.UCF(FLOW)))) / F.UCF(FLOW))
            qIncrement = (((((qIncrement) <= (qMax))) and (qIncrement) or (qMax)))
            qIncrement = (((((qIncrement) <= (qBypassed))) and (qIncrement) or (qBypassed)))
            qCaptured = (qCaptured + qIncrement)
            qBypassed = (qBypassed - qIncrement)
            if (qBypassed < 0.001) then
              break
            end
          end
          j = j + 1
        end
      end
    elseif (G_Curve[c].curveType == RATING_CURVE) then
      qCaptured = ((((inlet.numInlets * 1.0) * inlet.clogFactor) * F.table_lookupEx(G_Curve[c], (d * F.UCF(LENGTH)))) / F.UCF(FLOW))
    end
    qCaptured = (qCaptured * (sides * 1.0))
  end
  do return qCaptured end
end

