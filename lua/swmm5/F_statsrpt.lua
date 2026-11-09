-- Generated from EPA SWMM 5.2.4 (statsrpt.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local MGD <const> = 2
local CMS <const> = 3
local US <const> = 0
local SUBCATCH <const> = 1
local SNOWMELT <const> = 13
local AQUIFER <const> = 11
local POLLUT <const> = 4
local LINK <const> = 3
local DW <const> = 4
local RAINDEPTH <const> = 1
local FLOW <const> = 10
local LENGTH <const> = 3
local COUNT <const> = 2
local NODE <const> = 2
local OUTFALL <const> = 1
local VOLUME <const> = 5
local STORAGE <const> = 2
local DUMMY <const> = 0
local IRREGULAR <const> = 22
local PUMP <const> = 1
local OUTLET <const> = 4
local CONDUIT <const> = 0
local ORIFICE <const> = 2
local BOTTOM_ORIFICE <const> = 1
local MAX_FLOW_CLASSES <const> = 7
local _ENV = R.strict

G.FlowFmt = R.buf(6)
G.Vcf = 0.0

-- statsrpt.c:84
F.statsrpt_writeReport = function()
  local G_FlowFmt, G_Nobjects = G.FlowFmt, G.Nobjects
  if ((G.FlowUnits == MGD) or (G.FlowUnits == CMS)) then
    F.sstrncpy(G_FlowFmt, S[534], 5)
  else
    F.sstrncpy(G_FlowFmt, S[535], 5)
  end
  if (G.UnitSystem == US) then
    G.Vcf = (7.48 / 1000000.0)
  else
    G.Vcf = (28.317 / 1000000.0)
  end
  if (G_Nobjects[SUBCATCH] > 0) then
    if (((not (G.IgnoreRainfall ~= 0)) or (((G_Nobjects[SNOWMELT] > 0) and (not (G.IgnoreSnowmelt ~= 0))))) or (((G_Nobjects[AQUIFER] > 0) and (not (G.IgnoreGwater ~= 0))))) then
      F.writeSubcatchRunoff()
      F.lid_writeWaterBalance()
      if (not (G.IgnoreGwater ~= 0)) then
        F.writeGroundwater()
      end
      if ((G_Nobjects[POLLUT] > 0) and (not (G.IgnoreQuality ~= 0))) then
        F.writeSubcatchLoads()
      end
    end
  end
  if ((G_Nobjects[LINK] > 0) and (not (G.IgnoreRouting ~= 0))) then
    F.writeNodeDepths()
    F.writeNodeFlows()
    if (G.RouteModel == DW) then
      F.writeNodeSurcharge()
    end
    F.writeNodeFlooding()
    F.writeStorageVolumes()
    F.writeOutfallLoads()
    F.inlet_writeStatsReport()
    F.writeLinkFlows()
    F.writeFlowClass()
    F.writeLinkSurcharge()
    F.writePumpFlows()
    if ((G_Nobjects[POLLUT] > 0) and (not (G.IgnoreQuality ~= 0))) then
      F.writeLinkLoads()
    end
  end
end

-- statsrpt.c:133
F.writeSubcatchRunoff = function()
  local G_Nobjects, G_Frpt, G_VolUnitsWords, G_FlowUnitWords, G_Subcatch, G_SubcatchStats = G.Nobjects, G.Frpt, G.VolUnitsWords, G.FlowUnitWords, G.Subcatch, G.SubcatchStats
  local j = 0
  local a = 0.0
  local x = 0.0
  local r = 0.0
  if (G_Nobjects[SUBCATCH] == 0) then
    do return end
  end
  F.report_writeLine((S[0]))
  F.report_writeLine((S[473]))
  F.report_writeLine((S[536]))
  F.report_writeLine((S[473]))
  F.report_writeLine((S[0]))
  R.fprintf(G_Frpt.file, S[537])
  if (G.UnitSystem == US) then
    R.fprintf(G_Frpt.file, S[538], G_VolUnitsWords[G.UnitSystem], G_FlowUnitWords[G.FlowUnits])
  else
    R.fprintf(G_Frpt.file, S[539], G_VolUnitsWords[G.UnitSystem], G_FlowUnitWords[G.FlowUnits])
  end
  R.fprintf(G_Frpt.file, S[540])
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        a = G_Subcatch[j].area
        if (a == 0.0) then
          goto continue1
        end
        R.fprintf(G_Frpt.file, S[541], G_Subcatch[j].ID)
        x = (G_SubcatchStats[j].precip * F.UCF(RAINDEPTH))
        R.fprintf(G_Frpt.file, S[542], (x / a))
        x = (G_SubcatchStats[j].runon * F.UCF(RAINDEPTH))
        R.fprintf(G_Frpt.file, S[542], (x / a))
        x = (G_SubcatchStats[j].evap * F.UCF(RAINDEPTH))
        R.fprintf(G_Frpt.file, S[542], (x / a))
        x = (G_SubcatchStats[j].infil * F.UCF(RAINDEPTH))
        R.fprintf(G_Frpt.file, S[542], (x / a))
        x = (G_SubcatchStats[j].impervRunoff * F.UCF(RAINDEPTH))
        R.fprintf(G_Frpt.file, S[542], (x / a))
        x = (G_SubcatchStats[j].pervRunoff * F.UCF(RAINDEPTH))
        R.fprintf(G_Frpt.file, S[542], (x / a))
        x = (G_SubcatchStats[j].runoff * F.UCF(RAINDEPTH))
        R.fprintf(G_Frpt.file, S[542], (x / a))
        x = (G_SubcatchStats[j].runoff * G.Vcf)
        R.fprintf(G_Frpt.file, S[543], x)
        x = (G_SubcatchStats[j].maxFlow * F.UCF(FLOW))
        R.fprintf(G_Frpt.file, S[544], x)
        r = (G_SubcatchStats[j].precip + G_SubcatchStats[j].runon)
        if (r > 0.0) then
          r = (G_SubcatchStats[j].runoff / r)
        end
        R.fprintf(G_Frpt.file, S[545], r)
      end
      ::continue1::
      j = j + 1
    end
  end
  F.report_writeLine((S[0]))
end

-- statsrpt.c:190
F.writeGroundwater = function()
  local G_Nobjects, G_Subcatch, G_Frpt, G_FlowUnitWords = G.Nobjects, G.Subcatch, G.Frpt, G.FlowUnitWords
  local i = 0
  local j = 0
  local count = 0
  local totalSeconds = (G.NewRunoffTime / 1000.0)
  local x = R.fill(9, 0.0)
  if (G_Nobjects[SUBCATCH] == 0) then
    do return end
  end
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        if (G_Subcatch[j].groundwater ~= (nil)) then
          count = count + 1
        end
      end
      j = j + 1
    end
  end
  if (count == 0) then
    do return end
  end
  F.report_writeLine((S[0]))
  F.report_writeLine((S[188]))
  F.report_writeLine((S[546]))
  F.report_writeLine((S[188]))
  F.report_writeLine((S[0]))
  R.fprintf(G_Frpt.file, S[547])
  if (G.UnitSystem == US) then
    R.fprintf(G_Frpt.file, S[548], G_FlowUnitWords[G.FlowUnits])
  else
    R.fprintf(G_Frpt.file, S[549], G_FlowUnitWords[G.FlowUnits])
  end
  R.fprintf(G_Frpt.file, S[550])
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        if ((G_Subcatch[j].area == 0.0) or (G_Subcatch[j].groundwater == (nil))) then
          goto continue2
        end
        R.fprintf(G_Frpt.file, S[541], G_Subcatch[j].ID)
        x[0] = (G_Subcatch[j].groundwater.stats.infil * F.UCF(RAINDEPTH))
        x[1] = (G_Subcatch[j].groundwater.stats.evap * F.UCF(RAINDEPTH))
        x[2] = (G_Subcatch[j].groundwater.stats.deepFlow * F.UCF(RAINDEPTH))
        x[3] = (G_Subcatch[j].groundwater.stats.latFlow * F.UCF(RAINDEPTH))
        x[4] = ((G_Subcatch[j].groundwater.stats.maxFlow * F.UCF(FLOW)) * G_Subcatch[j].area)
        x[5] = (G_Subcatch[j].groundwater.stats.avgUpperMoist / totalSeconds)
        x[6] = ((G_Subcatch[j].groundwater.stats.avgWaterTable * F.UCF(LENGTH)) / totalSeconds)
        x[7] = G_Subcatch[j].groundwater.stats.finalUpperMoist
        x[8] = (G_Subcatch[j].groundwater.stats.finalWaterTable * F.UCF(LENGTH))
        do
          i = 0
          while (i < 9) do
            do
              R.fprintf(G_Frpt.file, S[544], x[i])
            end
            i = i + 1
          end
        end
      end
      ::continue2::
      j = j + 1
    end
  end
  F.report_writeLine((S[0]))
end

-- statsrpt.c:245
F.writeSubcatchLoads = function()
  local G_Nobjects, G_Frpt, G_Pollut, G_LoadUnitsWords, G_Subcatch = G.Nobjects, G.Frpt, G.Pollut, G.LoadUnitsWords, G.Subcatch
  local i = 0
  local j = 0
  local p = 0
  local x = 0.0
  local totals = nil
  local units = R.buf(15)
  local subcatchLine = R.bufFrom(S[551], 21)
  local pollutLine = R.bufFrom(S[552], 15)
  totals = R.fill(G_Nobjects[POLLUT], 0.0)
  if (totals ~= nil) then
    F.report_writeLine((S[0]))
    F.report_writeLine((S[553]))
    F.report_writeLine((S[554]))
    F.report_writeLine((S[553]))
    F.report_writeLine((S[0]))
    R.fprintf(G_Frpt.file, S[356], subcatchLine)
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[169], pollutLine)
        end
        p = p + 1
      end
    end
    R.fprintf(G_Frpt.file, S[555])
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[423], G_Pollut[p].ID)
        end
        p = p + 1
      end
    end
    R.fprintf(G_Frpt.file, S[556])
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          i = G.UnitSystem
          if (G_Pollut[p].units == COUNT) then
            i = 2
          end
          F.sstrncpy(units, G_LoadUnitsWords[i], 14)
          R.fprintf(G_Frpt.file, S[423], units)
          totals[p] = 0.0
        end
        p = p + 1
      end
    end
    R.fprintf(G_Frpt.file, S[356], subcatchLine)
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[169], pollutLine)
        end
        p = p + 1
      end
    end
    do
      j = 0
      while (j < G_Nobjects[SUBCATCH]) do
        do
          R.fprintf(G_Frpt.file, S[541], G_Subcatch[j].ID)
          do
            p = 0
            while (p < G_Nobjects[POLLUT]) do
              do
                x = G_Subcatch[j].totalLoad[p]
                totals[p] = (totals[p] + x)
                if (G_Pollut[p].units == COUNT) then
                  x = ((((x) > 0.0) and R.log10((x)) or (x)))
                end
                R.fprintf(G_Frpt.file, S[427], x)
              end
              p = p + 1
            end
          end
        end
        j = j + 1
      end
    end
    R.fprintf(G_Frpt.file, S[356], subcatchLine)
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[169], pollutLine)
        end
        p = p + 1
      end
    end
    R.fprintf(G_Frpt.file, S[557])
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          x = totals[p]
          if (G_Pollut[p].units == COUNT) then
            x = ((((x) > 0.0) and R.log10((x)) or (x)))
          end
          R.fprintf(G_Frpt.file, S[427], x)
        end
        p = p + 1
      end
    end
    local _ = nil
    F.report_writeLine((S[0]))
  end
end

-- statsrpt.c:310
F.writeNodeDepths = function()
  local G_Nobjects, G_Frpt, G_Node, G_NodeTypeWords, G_NodeStats = G.Nobjects, G.Frpt, G.Node, G.NodeTypeWords, G.NodeStats
  local j = 0
  local days = {0}
  local hrs = {0}
  local mins = {0}
  if (G_Nobjects[LINK] == 0) then
    do return end
  end
  F.report_writeLine((S[0]))
  F.report_writeLine((S[558]))
  F.report_writeLine((S[559]))
  F.report_writeLine((S[558]))
  F.report_writeLine((S[0]))
  R.fprintf(G_Frpt.file, S[560])
  if (G.UnitSystem == US) then
    R.fprintf(G_Frpt.file, S[561])
  else
    R.fprintf(G_Frpt.file, S[562])
  end
  R.fprintf(G_Frpt.file, S[563])
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        R.fprintf(G_Frpt.file, S[541], G_Node[j].ID)
        R.fprintf(G_Frpt.file, S[564], G_NodeTypeWords[G_Node[j].type_])
        F.getElapsedTime(G_NodeStats[j].maxDepthDate, days, 1, hrs, 1, mins, 1)
        R.fprintf(G_Frpt.file, S[565], ((G_NodeStats[j].avgDepth / (G.ReportStepCount * 1.0)) * F.UCF(LENGTH)), (G_NodeStats[j].maxDepth * F.UCF(LENGTH)), (((G_NodeStats[j].maxDepth + G_Node[j].invertElev)) * F.UCF(LENGTH)), days[1], hrs[1], mins[1], G_NodeStats[j].maxRptDepth)
      end
      j = j + 1
    end
  end
  F.report_writeLine((S[0]))
end

-- statsrpt.c:353
F.writeNodeFlows = function()
  local G_Frpt, G_FlowUnitWords, G_VolUnitsWords, G_Nobjects, G_Node, G_NodeTypeWords = G.Frpt, G.FlowUnitWords, G.VolUnitsWords, G.Nobjects, G.Node, G.NodeTypeWords
  local G_NodeStats, G_FlowFmt, G_NodeInflow, G_NodeOutflow, G_VolUnitsWords2 = G.NodeStats, G.FlowFmt, G.NodeInflow, G.NodeOutflow, G.VolUnitsWords2
  local j = 0
  local days1 = {0}
  local hrs1 = {0}
  local mins1 = {0}
  F.report_writeLine((S[0]))
  F.report_writeLine((S[188]))
  F.report_writeLine((S[566]))
  F.report_writeLine((S[188]))
  F.report_writeLine((S[0]))
  R.fprintf(G_Frpt.file, S[567], G_FlowUnitWords[G.FlowUnits], G_FlowUnitWords[G.FlowUnits], G_VolUnitsWords[G.UnitSystem], G_VolUnitsWords[G.UnitSystem])
  R.fprintf(G_Frpt.file, S[568])
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        R.fprintf(G_Frpt.file, S[541], G_Node[j].ID)
        R.fprintf(G_Frpt.file, S[569], G_NodeTypeWords[G_Node[j].type_])
        F.getElapsedTime(G_NodeStats[j].maxInflowDate, days1, 1, hrs1, 1, mins1, 1)
        R.fprintf(G_Frpt.file, G_FlowFmt, (G_NodeStats[j].maxLatFlow * F.UCF(FLOW)))
        R.fprintf(G_Frpt.file, G_FlowFmt, (G_NodeStats[j].maxInflow * F.UCF(FLOW)))
        R.fprintf(G_Frpt.file, S[570], days1[1], hrs1[1], mins1[1])
        R.fprintf(G_Frpt.file, S[571], (G_NodeStats[j].totLatFlow * G.Vcf))
        R.fprintf(G_Frpt.file, S[571], (G_NodeInflow[j] * G.Vcf))
        if (m_abs(G_NodeOutflow[j]) < 1.0) then
          R.fprintf(G_Frpt.file, S[572], ((((G_NodeInflow[j] - G_NodeOutflow[j])) * G.Vcf) * 1000000.0), G_VolUnitsWords2[G.UnitSystem])
        else
          R.fprintf(G_Frpt.file, S[573], ((((G_NodeInflow[j] - G_NodeOutflow[j])) / G_NodeOutflow[j]) * 100.0))
        end
      end
      j = j + 1
    end
  end
  F.report_writeLine((S[0]))
end

-- statsrpt.c:403
F.writeNodeSurcharge = function()
  local G_Nobjects, G_Node, G_NodeStats, G_Frpt, G_NodeTypeWords = G.Nobjects, G.Node, G.NodeStats, G.Frpt, G.NodeTypeWords
  local j = 0
  local n = 0
  local t = 0.0
  local d1 = 0.0
  local d2 = 0.0
  F.report_writeLine((S[0]))
  F.report_writeLine((S[574]))
  F.report_writeLine((S[575]))
  F.report_writeLine((S[574]))
  F.report_writeLine((S[0]))
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        if (G_Node[j].type_ == OUTFALL) then
          goto continue1
        end
        if (G_NodeStats[j].timeSurcharged == 0.0) then
          goto continue1
        end
        t = (((((0.01) >= (((G_NodeStats[j].timeSurcharged / 3600.0))))) and (0.01) or (((G_NodeStats[j].timeSurcharged / 3600.0)))))
        if (n == 0) then
          F.report_writeLine((S[576]))
          R.fprintf(G_Frpt.file, S[577])
          if (G.UnitSystem == US) then
            R.fprintf(G_Frpt.file, S[578])
          else
            R.fprintf(G_Frpt.file, S[579])
          end
          R.fprintf(G_Frpt.file, S[580])
          n = 1
        end
        R.fprintf(G_Frpt.file, S[541], G_Node[j].ID)
        R.fprintf(G_Frpt.file, S[569], G_NodeTypeWords[G_Node[j].type_])
        d1 = ((G_NodeStats[j].maxDepth + G_Node[j].invertElev) - G_Node[j].crownElev)
        if (d1 < 0.0) then
          d1 = 0.0
        end
        d2 = (G_Node[j].fullDepth - G_NodeStats[j].maxDepth)
        if (d2 < 0.0) then
          d2 = 0.0
        end
        R.fprintf(G_Frpt.file, S[581], t, (d1 * F.UCF(LENGTH)), (d2 * F.UCF(LENGTH)))
      end
      ::continue1::
      j = j + 1
    end
  end
  if (n == 0) then
    F.report_writeLine((S[582]))
  end
  F.report_writeLine((S[0]))
end

-- statsrpt.c:449
F.writeNodeFlooding = function()
  local G_Nobjects, G_Node, G_NodeStats, G_Frpt, G_FlowUnitWords, G_VolUnitsWords = G.Nobjects, G.Node, G.NodeStats, G.Frpt, G.FlowUnitWords, G.VolUnitsWords
  local G_PondingUnitsWords, G_FlowFmt = G.PondingUnitsWords, G.FlowFmt
  local j = 0
  local n = 0
  local days = {0}
  local hrs = {0}
  local mins = {0}
  local t = 0.0
  F.report_writeLine((S[0]))
  F.report_writeLine((S[255]))
  F.report_writeLine((S[583]))
  F.report_writeLine((S[255]))
  F.report_writeLine((S[0]))
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        if (G_Node[j].type_ == OUTFALL) then
          goto continue1
        end
        if (G_NodeStats[j].timeFlooded == 0.0) then
          goto continue1
        end
        t = (((((0.01) >= (((G_NodeStats[j].timeFlooded / 3600.0))))) and (0.01) or (((G_NodeStats[j].timeFlooded / 3600.0)))))
        if (n == 0) then
          F.report_writeLine((S[584]))
          R.fprintf(G_Frpt.file, S[585])
          if (G.RouteModel == DW) then
            R.fprintf(G_Frpt.file, S[586])
          else
            R.fprintf(G_Frpt.file, S[587])
          end
          R.fprintf(G_Frpt.file, S[588], G_FlowUnitWords[G.FlowUnits], G_VolUnitsWords[G.UnitSystem])
          if (G.RouteModel == DW) then
            R.fprintf(G_Frpt.file, S[589], G_PondingUnitsWords[G.UnitSystem])
          elseif (G.UnitSystem == US) then
            R.fprintf(G_Frpt.file, S[590])
          else
            R.fprintf(G_Frpt.file, S[591])
          end
          R.fprintf(G_Frpt.file, S[592])
          n = 1
        end
        R.fprintf(G_Frpt.file, S[541], G_Node[j].ID)
        R.fprintf(G_Frpt.file, S[593], t)
        R.fprintf(G_Frpt.file, G_FlowFmt, (G_NodeStats[j].maxOverflow * F.UCF(FLOW)))
        F.getElapsedTime(G_NodeStats[j].maxOverflowDate, days, 1, hrs, 1, mins, 1)
        R.fprintf(G_Frpt.file, S[594], days[1], hrs[1], mins[1])
        R.fprintf(G_Frpt.file, S[573], (G_NodeStats[j].volFlooded * G.Vcf))
        if (G.RouteModel == DW) then
          R.fprintf(G_Frpt.file, S[195], (((G_NodeStats[j].maxDepth - G_Node[j].fullDepth)) * F.UCF(LENGTH)))
        else
          R.fprintf(G_Frpt.file, S[195], ((G_NodeStats[j].maxPondedVol / 1000.0) * F.UCF(VOLUME)))
        end
      end
      ::continue1::
      j = j + 1
    end
  end
  if (n == 0) then
    F.report_writeLine((S[595]))
  end
  F.report_writeLine((S[0]))
end

-- statsrpt.c:508
F.writeStorageVolumes = function()
  local G_Frpt, G_Nobjects, G_Node, G_StorageStats, G_NodeInflow, G_FlowFmt = G.Frpt, G.Nobjects, G.Node, G.StorageStats, G.NodeInflow, G.FlowFmt
  local j = 0
  local k = 0
  local days = {0}
  local hrs = {0}
  local mins = {0}
  local avgVol = 0.0
  local maxVol = 0.0
  local pctAvgVol = 0.0
  local pctMaxVol = 0.0
  local pctEvapLoss = 0.0
  local pctSeepLoss = 0.0
  if (G.Nnodes[STORAGE] > 0) then
    F.report_writeLine((S[0]))
    F.report_writeLine((S[574]))
    F.report_writeLine((S[596]))
    F.report_writeLine((S[574]))
    F.report_writeLine((S[0]))
    R.fprintf(G_Frpt.file, S[597])
    if (G.UnitSystem == US) then
      R.fprintf(G_Frpt.file, S[598])
    else
      R.fprintf(G_Frpt.file, S[599])
    end
    R.fprintf(G_Frpt.file, S[600], G.FlowUnitWords[G.FlowUnits])
    R.fprintf(G_Frpt.file, S[601])
    do
      j = 0
      while (j < G_Nobjects[NODE]) do
        do
          if (G_Node[j].type_ ~= STORAGE) then
            goto continue1
          end
          k = G_Node[j].subIndex
          R.fprintf(G_Frpt.file, S[541], G_Node[j].ID)
          avgVol = (G_StorageStats[k].avgVol / (G.ReportStepCount * 1.0))
          maxVol = G_StorageStats[k].maxVol
          pctMaxVol = 0.0
          pctAvgVol = 0.0
          if (G_Node[j].fullVolume > 0.0) then
            pctAvgVol = ((avgVol / G_Node[j].fullVolume) * 100.0)
            pctMaxVol = ((maxVol / G_Node[j].fullVolume) * 100.0)
          end
          pctEvapLoss = 0.0
          pctSeepLoss = 0.0
          if (G_NodeInflow[j] > 0.0) then
            pctEvapLoss = ((G_StorageStats[k].evapLosses / G_NodeInflow[j]) * 100.0)
            pctSeepLoss = ((G_StorageStats[k].exfilLosses / G_NodeInflow[j]) * 100.0)
          end
          R.fprintf(G_Frpt.file, S[602], ((avgVol * F.UCF(VOLUME)) / 1000.0), pctAvgVol, pctEvapLoss, pctSeepLoss, ((maxVol * F.UCF(VOLUME)) / 1000.0), pctMaxVol)
          F.getElapsedTime(G_StorageStats[k].maxVolDate, days, 1, hrs, 1, mins, 1)
          R.fprintf(G_Frpt.file, S[603], days[1], hrs[1], mins[1])
          R.fprintf(G_Frpt.file, G_FlowFmt, (G_StorageStats[k].maxFlow * F.UCF(FLOW)))
        end
        ::continue1::
        j = j + 1
      end
    end
    F.report_writeLine((S[0]))
  end
end

-- statsrpt.c:575
F.writeOutfallLoads = function()
  local G_Nnodes, G_Nobjects, G_Frpt, G_Pollut, G_FlowUnitWords, G_LoadUnitsWords = G.Nnodes, G.Nobjects, G.Frpt, G.Pollut, G.FlowUnitWords, G.LoadUnitsWords
  local G_Node, G_OutfallStats, G_FlowFmt, G_NodeInflow = G.Node, G.OutfallStats, G.FlowFmt, G.NodeInflow
  local units = R.buf(15)
  local i = 0
  local j = 0
  local k = 0
  local p = 0
  local x = 0.0
  local outfallCount = 0.0
  local flowCount = 0.0
  local flowSum = 0.0
  local freqSum = 0.0
  local volSum = 0.0
  local totals = nil
  if (G_Nnodes[OUTFALL] > 0) then
    totals = R.fill(G_Nobjects[POLLUT], 0.0)
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          totals[p] = 0.0
        end
        p = p + 1
      end
    end
    flowSum = 0.0
    freqSum = 0.0
    volSum = 0.0
    F.report_writeLine((S[0]))
    F.report_writeLine((S[604]))
    F.report_writeLine((S[605]))
    F.report_writeLine((S[604]))
    F.report_writeLine((S[0]))
    R.fprintf(G_Frpt.file, S[606])
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[552])
        end
        p = p + 1
      end
    end
    R.fprintf(G_Frpt.file, S[607])
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[608])
        end
        p = p + 1
      end
    end
    R.fprintf(G_Frpt.file, S[609])
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[423], G_Pollut[p].ID)
        end
        p = p + 1
      end
    end
    R.fprintf(G_Frpt.file, S[610], G_FlowUnitWords[G.FlowUnits], G_FlowUnitWords[G.FlowUnits], G.VolUnitsWords[G.UnitSystem])
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          i = G.UnitSystem
          if (G_Pollut[p].units == COUNT) then
            i = 2
          end
          F.sstrncpy(units, G_LoadUnitsWords[i], 14)
          R.fprintf(G_Frpt.file, S[423], units)
        end
        p = p + 1
      end
    end
    R.fprintf(G_Frpt.file, S[606])
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[552])
        end
        p = p + 1
      end
    end
    do
      j = 0
      while (j < G_Nobjects[NODE]) do
        do
          if (G_Node[j].type_ ~= OUTFALL) then
            goto continue7
          end
          k = G_Node[j].subIndex
          flowCount = (G_OutfallStats[k].totalPeriods * 1.0)
          R.fprintf(G_Frpt.file, S[541], G_Node[j].ID)
          x = ((100.0 * flowCount) / (G.ReportStepCount * 1.0))
          R.fprintf(G_Frpt.file, S[611], x)
          freqSum = (freqSum + x)
          if (flowCount > 0.0) then
            x = ((G_OutfallStats[k].avgFlow * F.UCF(FLOW)) / flowCount)
          else
            x = 0.0
          end
          flowSum = (flowSum + x)
          R.fprintf(G_Frpt.file, S[33])
          R.fprintf(G_Frpt.file, G_FlowFmt, x)
          R.fprintf(G_Frpt.file, S[33])
          R.fprintf(G_Frpt.file, G_FlowFmt, (G_OutfallStats[k].maxFlow * F.UCF(FLOW)))
          R.fprintf(G_Frpt.file, S[573], (G_NodeInflow[j] * G.Vcf))
          volSum = (volSum + G_NodeInflow[j])
          do
            p = 0
            while (p < G_Nobjects[POLLUT]) do
              do
                x = ((G_OutfallStats[k].totalLoad[p] * 28.317) * G_Pollut[p].mcf)
                totals[p] = (totals[p] + x)
                if (G_Pollut[p].units == COUNT) then
                  x = ((((x) > 0.0) and R.log10((x)) or (x)))
                end
                R.fprintf(G_Frpt.file, S[427], x)
              end
              p = p + 1
            end
          end
        end
        ::continue7::
        j = j + 1
      end
    end
    outfallCount = (G_Nnodes[OUTFALL] * 1.0)
    R.fprintf(G_Frpt.file, S[606])
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[552])
        end
        p = p + 1
      end
    end
    R.fprintf(G_Frpt.file, S[612], (freqSum / outfallCount))
    R.fprintf(G_Frpt.file, G_FlowFmt, flowSum)
    R.fprintf(G_Frpt.file, S[33])
    R.fprintf(G_Frpt.file, G_FlowFmt, (G.MaxOutfallFlow * F.UCF(FLOW)))
    R.fprintf(G_Frpt.file, S[573], (volSum * G.Vcf))
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          x = totals[p]
          if (G_Pollut[p].units == COUNT) then
            x = ((((x) > 0.0) and R.log10((x)) or (x)))
          end
          R.fprintf(G_Frpt.file, S[427], x)
        end
        p = p + 1
      end
    end
    F.report_writeLine((S[0]))
    local _ = nil
  end
end

-- statsrpt.c:691
F.writeLinkFlows = function()
  local G_Nobjects, G_Frpt, G_FlowUnitWords, G_Link, G_LinkTypeWords, G_LinkStats = G.Nobjects, G.Frpt, G.FlowUnitWords, G.Link, G.LinkTypeWords, G.LinkStats
  local G_FlowFmt, G_Conduit, G_Orifice = G.FlowFmt, G.Conduit, G.Orifice
  local j = 0
  local k = 0
  local days = {0}
  local hrs = {0}
  local mins = {0}
  local v = 0.0
  local fullDepth = 0.0
  if (G_Nobjects[LINK] == 0) then
    do return end
  end
  F.report_writeLine((S[0]))
  F.report_writeLine((S[235]))
  F.report_writeLine((S[613]))
  F.report_writeLine((S[235]))
  F.report_writeLine((S[0]))
  R.fprintf(G_Frpt.file, S[614])
  if (G.UnitSystem == US) then
    R.fprintf(G_Frpt.file, S[615], G_FlowUnitWords[G.FlowUnits])
  else
    R.fprintf(G_Frpt.file, S[616], G_FlowUnitWords[G.FlowUnits])
  end
  R.fprintf(G_Frpt.file, S[617])
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        k = G_Link[j].subIndex
        R.fprintf(G_Frpt.file, S[541], G_Link[j].ID)
        if (G_Link[j].xsect.type_ == DUMMY) then
          R.fprintf(G_Frpt.file, S[618])
        elseif (G_Link[j].xsect.type_ == IRREGULAR) then
          R.fprintf(G_Frpt.file, S[619])
        else
          R.fprintf(G_Frpt.file, S[620], G_LinkTypeWords[G_Link[j].type_])
        end
        F.getElapsedTime(G_LinkStats[j].maxFlowDate, days, 1, hrs, 1, mins, 1)
        R.fprintf(G_Frpt.file, G_FlowFmt, (G_LinkStats[j].maxFlow * F.UCF(FLOW)))
        R.fprintf(G_Frpt.file, S[570], days[1], hrs[1], mins[1])
        if ((G_Link[j].type_ == PUMP) and (G_Link[j].qFull > 0.0)) then
          R.fprintf(G_Frpt.file, S[621])
          R.fprintf(G_Frpt.file, S[622], (G_LinkStats[j].maxFlow / G_Link[j].qFull))
          goto continue1
        end
        if (G_Link[j].xsect.type_ == DUMMY) then
          goto continue1
        end
        if (G_Link[j].type_ == OUTLET) then
          goto continue1
        end
        if (G_Link[j].type_ == CONDUIT) then
          v = (G_LinkStats[j].maxVeloc * F.UCF(LENGTH))
          if (v > 50.0) then
            R.fprintf(G_Frpt.file, S[623])
          else
            R.fprintf(G_Frpt.file, S[624], v)
          end
          R.fprintf(G_Frpt.file, S[622], ((G_LinkStats[j].maxFlow / G_Link[j].qFull) / (G_Conduit[k].barrels * 1.0)))
        else
          R.fprintf(G_Frpt.file, S[625])
        end
        fullDepth = G_Link[j].xsect.yFull
        if ((G_Link[j].type_ == ORIFICE) and (G_Orifice[k].type_ == BOTTOM_ORIFICE)) then
          fullDepth = 0.0
        end
        if (fullDepth > 0.0) then
          R.fprintf(G_Frpt.file, S[622], (G_LinkStats[j].maxDepth / fullDepth))
        else
          R.fprintf(G_Frpt.file, S[626])
        end
      end
      ::continue1::
      j = j + 1
    end
  end
  F.report_writeLine((S[0]))
end

-- statsrpt.c:778
F.writeFlowClass = function()
  local G_Frpt, G_Nobjects, G_Link, G_Conduit, G_LinkStats = G.Frpt, G.Nobjects, G.Link, G.Conduit, G.LinkStats
  local i = 0
  local j = 0
  local k = 0
  local totalSeconds = G.RoutingTimeSpan
  if (G.RouteModel ~= DW) then
    do return end
  end
  F.report_writeLine((S[0]))
  F.report_writeLine((S[473]))
  F.report_writeLine((S[627]))
  F.report_writeLine((S[473]))
  F.report_writeLine((S[0]))
  R.fprintf(G_Frpt.file, S[628])
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        if (G_Link[j].type_ ~= CONDUIT) then
          goto continue1
        end
        if (G_Link[j].xsect.type_ == DUMMY) then
          goto continue1
        end
        k = G_Link[j].subIndex
        R.fprintf(G_Frpt.file, S[541], G_Link[j].ID)
        R.fprintf(G_Frpt.file, S[629], (G_Conduit[k].modLength / G_Conduit[k].length))
        do
          i = 0
          while (i < MAX_FLOW_CLASSES) do
            do
              G_LinkStats[j].timeInFlowClass[i] = (G_LinkStats[j].timeInFlowClass[i] / totalSeconds)
              R.fprintf(G_Frpt.file, S[630], G_LinkStats[j].timeInFlowClass[i])
            end
            i = i + 1
          end
        end
        R.fprintf(G_Frpt.file, S[630], (G_LinkStats[j].timeNormalFlow / totalSeconds))
        R.fprintf(G_Frpt.file, S[630], (G_LinkStats[j].timeInletControl / totalSeconds))
      end
      ::continue1::
      j = j + 1
    end
  end
  F.report_writeLine((S[0]))
end

-- statsrpt.c:821
F.writeLinkSurcharge = function()
  local G_Nobjects, G_Link, G_LinkStats, G_Frpt = G.Nobjects, G.Link, G.LinkStats, G.Frpt
  local i = 0
  local j = 0
  local n = 0
  local t = R.fill(5, 0.0)
  F.report_writeLine((S[0]))
  F.report_writeLine((S[470]))
  F.report_writeLine((S[631]))
  F.report_writeLine((S[470]))
  F.report_writeLine((S[0]))
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        if ((G_Link[j].type_ ~= CONDUIT) or (G_Link[j].xsect.type_ == DUMMY)) then
          goto continue1
        end
        t[0] = (G_LinkStats[j].timeSurcharged / 3600.0)
        t[1] = (G_LinkStats[j].timeFullUpstream / 3600.0)
        t[2] = (G_LinkStats[j].timeFullDnstream / 3600.0)
        t[3] = (G_LinkStats[j].timeFullFlow / 3600.0)
        if ((((t[0] + t[1]) + t[2]) + t[3]) == 0.0) then
          goto continue1
        end
        t[4] = (G_LinkStats[j].timeCapacityLimited / 3600.0)
        do
          i = 0
          while (i < 5) do
            do
              t[i] = (((((0.01) >= (t[i]))) and (0.01) or (t[i])))
            end
            i = i + 1
          end
        end
        if (n == 0) then
          R.fprintf(G_Frpt.file, S[632])
          n = 1
        end
        R.fprintf(G_Frpt.file, S[541], G_Link[j].ID)
        R.fprintf(G_Frpt.file, S[633], t[0], t[1], t[2], t[3], t[4])
      end
      ::continue1::
      j = j + 1
    end
  end
  if (n == 0) then
    F.report_writeLine((S[634]))
  end
  F.report_writeLine((S[0]))
end

-- statsrpt.c:862
F.writePumpFlows = function()
  local G_Frpt, G_FlowUnitWords, G_Nobjects, G_Link, G_PumpStats = G.Frpt, G.FlowUnitWords, G.Nobjects, G.Link, G.PumpStats
  local j = 0
  local k = 0
  local avgFlow = 0.0
  local pctUtilized = 0.0
  local pctOffCurve1 = 0.0
  local pctOffCurve2 = 0.0
  local totalSeconds = G.RoutingTimeSpan
  if (G.Nlinks[PUMP] == 0) then
    do return end
  end
  F.report_writeLine((S[0]))
  F.report_writeLine((S[221]))
  F.report_writeLine((S[635]))
  F.report_writeLine((S[221]))
  F.report_writeLine((S[0]))
  R.fprintf(G_Frpt.file, S[636], G_FlowUnitWords[G.FlowUnits], G_FlowUnitWords[G.FlowUnits], G_FlowUnitWords[G.FlowUnits], G.VolUnitsWords[G.UnitSystem])
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        if (G_Link[j].type_ ~= PUMP) then
          goto continue1
        end
        k = G_Link[j].subIndex
        R.fprintf(G_Frpt.file, S[541], G_Link[j].ID)
        pctUtilized = ((G_PumpStats[k].utilized / totalSeconds) * 100.0)
        avgFlow = G_PumpStats[k].avgFlow
        if (G_PumpStats[k].totalPeriods > 0) then
          avgFlow = (avgFlow / (G_PumpStats[k].totalPeriods * 1.0))
        end
        R.fprintf(G_Frpt.file, S[637], pctUtilized, G_PumpStats[k].startUps, (G_PumpStats[k].minFlow * F.UCF(FLOW)), (avgFlow * F.UCF(FLOW)), (G_PumpStats[k].maxFlow * F.UCF(FLOW)), (G_PumpStats[k].volume * G.Vcf), G_PumpStats[k].energy)
        pctOffCurve1 = G_PumpStats[k].offCurveLow
        pctOffCurve2 = G_PumpStats[k].offCurveHigh
        if (G_PumpStats[k].utilized > 0.0) then
          pctOffCurve1 = ((pctOffCurve1 / G_PumpStats[k].utilized) * 100.0)
          pctOffCurve2 = ((pctOffCurve2 / G_PumpStats[k].utilized) * 100.0)
        end
        R.fprintf(G_Frpt.file, S[638], pctOffCurve1, pctOffCurve2)
      end
      ::continue1::
      j = j + 1
    end
  end
  F.report_writeLine((S[0]))
end

-- statsrpt.c:916
F.writeLinkLoads = function()
  local G_Frpt, G_Nobjects, G_Pollut, G_LoadUnitsWords, G_Link = G.Frpt, G.Nobjects, G.Pollut, G.LoadUnitsWords, G.Link
  local i = 0
  local j = 0
  local p = 0
  local x = 0.0
  local units = R.buf(15)
  local linkLine = R.bufFrom(S[551], 21)
  local pollutLine = R.bufFrom(S[552], 15)
  F.report_writeLine((S[0]))
  F.report_writeLine((S[473]))
  F.report_writeLine((S[639]))
  F.report_writeLine((S[473]))
  F.report_writeLine((S[0]))
  R.fprintf(G_Frpt.file, S[356], linkLine)
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        R.fprintf(G_Frpt.file, S[169], pollutLine)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[555])
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        R.fprintf(G_Frpt.file, S[423], G_Pollut[p].ID)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[640])
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        i = G.UnitSystem
        if (G_Pollut[p].units == COUNT) then
          i = 2
        end
        F.sstrncpy(units, G_LoadUnitsWords[i], 14)
        R.fprintf(G_Frpt.file, S[423], units)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[356], linkLine)
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        R.fprintf(G_Frpt.file, S[169], pollutLine)
      end
      p = p + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        R.fprintf(G_Frpt.file, S[541], G_Link[j].ID)
        do
          p = 0
          while (p < G_Nobjects[POLLUT]) do
            do
              x = ((G_Link[j].totalLoad[p] * 28.317) * G_Pollut[p].mcf)
              if (G_Pollut[p].units == COUNT) then
                x = ((((x) > 0.0) and R.log10((x)) or (x)))
              end
              if (x < 10000.0) then
                R.fprintf(G_Frpt.file, S[427], x)
              else
                R.fprintf(G_Frpt.file, S[641], x)
              end
            end
            p = p + 1
          end
        end
      end
      j = j + 1
    end
  end
  F.report_writeLine((S[0]))
end

