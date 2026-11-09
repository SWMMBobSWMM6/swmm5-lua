-- Generated from EPA SWMM 5.2.4 (output.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local POLLUT <const> = 4
local SUBCATCH <const> = 1
local NODE <const> = 2
local LINK <const> = 3
local ERR_MEMORY <const> = 101
local INPUT_AREA <const> = 1
local LANDAREA <const> = 4
local INPUT_TYPE_CODE <const> = 0
local INPUT_INVERT <const> = 2
local INPUT_MAX_DEPTH <const> = 3
local LENGTH <const> = 3
local INPUT_OFFSET <const> = 4
local INPUT_LENGTH <const> = 5
local PUMP <const> = 1
local OUTLET <const> = 4
local CONDUIT <const> = 0
local SUBCATCH_RAINFALL <const> = 0
local SUBCATCH_SNOWDEPTH <const> = 1
local SUBCATCH_EVAP <const> = 2
local SUBCATCH_INFIL <const> = 3
local SUBCATCH_RUNOFF <const> = 4
local SUBCATCH_GW_FLOW <const> = 5
local SUBCATCH_GW_ELEV <const> = 6
local SUBCATCH_SOIL_MOIST <const> = 7
local SUBCATCH_WASHOFF <const> = 8
local NODE_DEPTH <const> = 0
local NODE_HEAD <const> = 1
local NODE_VOLUME <const> = 2
local NODE_LATFLOW <const> = 3
local NODE_INFLOW <const> = 4
local NODE_OVERFLOW <const> = 5
local NODE_QUAL <const> = 6
local LINK_FLOW <const> = 0
local LINK_DEPTH <const> = 1
local LINK_VELOCITY <const> = 2
local LINK_VOLUME <const> = 3
local LINK_CAPACITY <const> = 4
local LINK_QUAL <const> = 5
local ERR_OUT_WRITE <const> = 309
local SAVE_FILE <const> = 3
local SCRATCH_FILE <const> = 1
local ERR_OUT_FILE <const> = 307
local FLOW <const> = 10
local SYS_FLOODING <const> = 10
local SYS_OUTFLOW <const> = 11
local SYS_DWFLOW <const> = 5
local SYS_GWFLOW <const> = 6
local SYS_IIFLOW <const> = 7
local SYS_EXFLOW <const> = 8
local SYS_RUNOFF <const> = 4
local SYS_INFLOW <const> = 9
local GAGE <const> = 0
local SYS_RAINFALL <const> = 1
local SYS_SNOWDEPTH <const> = 2
local SYS_EVAP <const> = 13
local EVAPRATE <const> = 2
local SYS_INFIL <const> = 3
local SI <const> = 1
local SYS_TEMPERATURE <const> = 0
local SYS_PET <const> = 14
local SYS_STORAGE <const> = 12
local VOLUME <const> = 5
local _ENV = R.strict

G.IDStartPos = 0
G.InputStartPos = 0
G.OutputStartPos = 0
G.BytesPerPeriod = 0
G.NumSubcatchVars = 0
G.NumNodeVars = 0
G.NumLinkVars = 0
G.NumSubcatch = 0
G.NumNodes = 0
G.NumLinks = 0
G.NumPolluts = 0
G.SysResults = R.fill(15, 0.0)
G.AvgLinkResults = nil
G.AvgNodeResults = nil
G.output_Nsteps = 0
G.SubcatchResults = nil
G.NodeResults = nil
G.LinkResults = nil

-- output.c:121
F.output_open = function()
  local G_Nobjects, G_Subcatch, G_Node, G_Link, G_Fout, G_Pollut = G.Nobjects, G.Subcatch, G.Node, G.Link, G.Fout, G.Pollut
  local G_Conduit = G.Conduit
  local j = 0
  local m = 0
  local k = {0}
  local x = 0.0
  local z = {0.0}
  local numResults = 0
  F.output_openOutFile()
  if (G.ErrorCode ~= 0) then
    do return G.ErrorCode end
  end
  if (G.IgnoreQuality ~= 0) then
    G.NumPolluts = 0
  else
    G.NumPolluts = G_Nobjects[POLLUT]
  end
  G.NumSubcatchVars = ((9 - 1) + G.NumPolluts)
  G.NumNodeVars = ((7 - 1) + G.NumPolluts)
  G.NumLinkVars = ((6 - 1) + G.NumPolluts)
  G.NumSubcatch = 0
  G.NumNodes = 0
  G.NumLinks = 0
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        if (G_Subcatch[j].rptFlag ~= 0) then
          G.NumSubcatch = G.NumSubcatch + 1
        end
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        if (G_Node[j].rptFlag ~= 0) then
          G.NumNodes = G.NumNodes + 1
        end
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        if (G_Link[j].rptFlag ~= 0) then
          G.NumLinks = G.NumLinks + 1
        end
      end
      j = j + 1
    end
  end
  numResults = (((((G.NumSubcatch * G.NumSubcatchVars)) + ((G.NumNodes * G.NumNodeVars))) + ((G.NumLinks * G.NumLinkVars))) + 15)
  G.BytesPerPeriod = (8 + ((numResults * 4)))
  G.Nperiods = 0
  G.SubcatchResults = (nil)
  G.NodeResults = (nil)
  G.LinkResults = (nil)
  G.SubcatchResults = R.fill(G.NumSubcatchVars, 0.0)
  G.NodeResults = R.fill(G.NumNodeVars, 0.0)
  G.LinkResults = R.fill(G.NumLinkVars, 0.0)
  if (((not (G.SubcatchResults ~= nil)) or (not (G.NodeResults ~= nil))) or (not (G.LinkResults ~= nil))) then
    F.report_writeErrorMsg(ERR_MEMORY, S[0])
    do return G.ErrorCode end
  end
  G.AvgNodeResults = (nil)
  G.AvgLinkResults = (nil)
  if ((G.RptFlags.averages ~= 0) and (not (F.output_openAvgResults() ~= 0))) then
    F.report_writeErrorMsg(ERR_MEMORY, S[0])
    do return G.ErrorCode end
  end
  R.fseek(G_Fout.file, 0, 0)
  k[1] = 516114522
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = 52004
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = G.FlowUnits
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = G.NumSubcatch
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = G.NumNodes
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = G.NumLinks
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = G.NumPolluts
  R.fwrite1("i", 4, k[1], G_Fout.file)
  G.IDStartPos = R.ftell(G_Fout.file)
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        if (G_Subcatch[j].rptFlag ~= 0) then
          F.output_saveID(G_Subcatch[j].ID, G_Fout.file)
        end
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        if (G_Node[j].rptFlag ~= 0) then
          F.output_saveID(G_Node[j].ID, G_Fout.file)
        end
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        if (G_Link[j].rptFlag ~= 0) then
          F.output_saveID(G_Link[j].ID, G_Fout.file)
        end
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G.NumPolluts) do
      do
        F.output_saveID(G_Pollut[j].ID, G_Fout.file)
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G.NumPolluts) do
      do
        k[1] = G_Pollut[j].units
        R.fwrite1("i", 4, k[1], G_Fout.file)
      end
      j = j + 1
    end
  end
  G.InputStartPos = R.ftell(G_Fout.file)
  k[1] = 1
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = INPUT_AREA
  R.fwrite1("i", 4, k[1], G_Fout.file)
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        if (not (G_Subcatch[j].rptFlag ~= 0)) then
          goto continue9
        end
        G.SubcatchResults[0] = R.f32(((G_Subcatch[j].area * F.UCF(LANDAREA))))
        R.fwrite_arr("f", G.SubcatchResults, 0, 1, G_Fout.file)
      end
      ::continue9::
      j = j + 1
    end
  end
  k[1] = 3
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = INPUT_TYPE_CODE
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = INPUT_INVERT
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = INPUT_MAX_DEPTH
  R.fwrite1("i", 4, k[1], G_Fout.file)
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        if (not (G_Node[j].rptFlag ~= 0)) then
          goto continue10
        end
        k[1] = G_Node[j].type_
        G.NodeResults[0] = R.f32(((G_Node[j].invertElev * F.UCF(LENGTH))))
        G.NodeResults[1] = R.f32(((G_Node[j].fullDepth * F.UCF(LENGTH))))
        R.fwrite1("i", 4, k[1], G_Fout.file)
        R.fwrite_arr("f", G.NodeResults, 0, 2, G_Fout.file)
      end
      ::continue10::
      j = j + 1
    end
  end
  k[1] = 5
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = INPUT_TYPE_CODE
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = INPUT_OFFSET
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = INPUT_OFFSET
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = INPUT_MAX_DEPTH
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = INPUT_LENGTH
  R.fwrite1("i", 4, k[1], G_Fout.file)
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        if (not (G_Link[j].rptFlag ~= 0)) then
          goto continue11
        end
        k[1] = G_Link[j].type_
        if (k[1] == PUMP) then
          do
            m = 0
            while (m < 4) do
              do
                G.LinkResults[m] = 0.0
              end
              m = m + 1
            end
          end
        else
          G.LinkResults[0] = R.f32(((G_Link[j].offset1 * F.UCF(LENGTH))))
          G.LinkResults[1] = R.f32(((G_Link[j].offset2 * F.UCF(LENGTH))))
          if (G_Link[j].direction < 0) then
            x = G.LinkResults[0]
            G.LinkResults[0] = G.LinkResults[1]
            G.LinkResults[1] = x
          end
          if (k[1] == OUTLET) then
            G.LinkResults[2] = 0.0
          else
            G.LinkResults[2] = R.f32(((G_Link[j].xsect.yFull * F.UCF(LENGTH))))
          end
          if (k[1] == CONDUIT) then
            m = G_Link[j].subIndex
            G.LinkResults[3] = R.f32(((G_Conduit[m].length * F.UCF(LENGTH))))
          else
            G.LinkResults[3] = 0.0
          end
        end
        R.fwrite1("i", 4, k[1], G_Fout.file)
        R.fwrite_arr("f", G.LinkResults, 0, 4, G_Fout.file)
      end
      ::continue11::
      j = j + 1
    end
  end
  k[1] = G.NumSubcatchVars
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = SUBCATCH_RAINFALL
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = SUBCATCH_SNOWDEPTH
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = SUBCATCH_EVAP
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = SUBCATCH_INFIL
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = SUBCATCH_RUNOFF
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = SUBCATCH_GW_FLOW
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = SUBCATCH_GW_ELEV
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = SUBCATCH_SOIL_MOIST
  R.fwrite1("i", 4, k[1], G_Fout.file)
  do
    j = 0
    while (j < G.NumPolluts) do
      do
        k[1] = (SUBCATCH_WASHOFF + j)
        R.fwrite1("i", 4, k[1], G_Fout.file)
      end
      j = j + 1
    end
  end
  k[1] = G.NumNodeVars
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = NODE_DEPTH
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = NODE_HEAD
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = NODE_VOLUME
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = NODE_LATFLOW
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = NODE_INFLOW
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = NODE_OVERFLOW
  R.fwrite1("i", 4, k[1], G_Fout.file)
  do
    j = 0
    while (j < G.NumPolluts) do
      do
        k[1] = (NODE_QUAL + j)
        R.fwrite1("i", 4, k[1], G_Fout.file)
      end
      j = j + 1
    end
  end
  k[1] = G.NumLinkVars
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = LINK_FLOW
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = LINK_DEPTH
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = LINK_VELOCITY
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = LINK_VOLUME
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = LINK_CAPACITY
  R.fwrite1("i", 4, k[1], G_Fout.file)
  do
    j = 0
    while (j < G.NumPolluts) do
      do
        k[1] = (LINK_QUAL + j)
        R.fwrite1("i", 4, k[1], G_Fout.file)
      end
      j = j + 1
    end
  end
  k[1] = 15
  R.fwrite1("i", 4, k[1], G_Fout.file)
  do
    k[1] = 0
    while (k[1] < 15) do
      do
        R.fwrite1("i", 4, k[1], G_Fout.file)
      end
      k[1] = k[1] + 1
    end
  end
  z[1] = ((G.ReportStep * 1.0) / 86400.0)
  if ((G.StartDateTime + z[1]) > G.ReportStart) then
    z[1] = G.StartDateTime
  else
    z[1] = (R.floor((((G.ReportStart - G.StartDateTime)) / z[1])) - 1.0)
    z[1] = (G.StartDateTime + ((z[1] * (G.ReportStep * 1.0)) / 86400.0))
  end
  R.fwrite1("d", 8, z[1], G_Fout.file)
  k[1] = G.ReportStep
  if (R.fwrite1("i", 4, k[1], G_Fout.file) < 1) then
    F.report_writeErrorMsg(ERR_OUT_WRITE, S[0])
    do return G.ErrorCode end
  end
  G.OutputStartPos = R.ftell(G_Fout.file)
  do return G.ErrorCode end
end

-- output.c:427
F.output_openOutFile = function()
  local G_Fout = G.Fout
  if (G_Fout.file ~= (nil)) then
    R.fclose(G_Fout.file)
  elseif (R.strlen(G_Fout.name) ~= 0) then
    G_Fout.mode = SAVE_FILE
  else
    G_Fout.mode = SCRATCH_FILE
    F.getTempFileName(G_Fout.name)
  end
  G_Fout.file = R.fopen(G_Fout.name, S[166])
  if ((G_Fout.file) == (nil)) then
    F.writecon(S[318])
    G.ErrorCode = ERR_OUT_FILE
  end
end

-- output.c:457
F.output_saveResults = function(reportTime)
  local G_SysResults, G_Fout, G_Nobjects, G_StepFlowTotals, G_Foutflows = G.SysResults, G.Fout, G.Nobjects, G.StepFlowTotals, G.Foutflows
  local i = 0
  local reportDate = F.getDateTime(reportTime)
  local date = {0.0}
  if (reportDate < G.ReportStart) then
    do return end
  end
  do
    i = 0
    while (i < 15) do
      do
        G_SysResults[i] = 0.0
      end
      i = i + 1
    end
  end
  date[1] = reportDate
  R.fwrite1("d", 8, date[1], G_Fout.file)
  if (G_Nobjects[SUBCATCH] > 0) then
    F.output_saveSubcatchResults(reportTime, G_Fout.file)
  end
  if (G.RptFlags.averages ~= 0) then
    F.output_saveAvgResults(G_Fout.file)
  else
    if (G_Nobjects[NODE] > 0) then
      F.output_saveNodeResults(reportTime, G_Fout.file)
    end
    if (G_Nobjects[LINK] > 0) then
      F.output_saveLinkResults(reportTime, G_Fout.file)
    end
  end
  G_SysResults[SYS_FLOODING] = R.f32(((G_StepFlowTotals.flooding * F.UCF(FLOW))))
  G_SysResults[SYS_OUTFLOW] = R.f32(((G_StepFlowTotals.outflow * F.UCF(FLOW))))
  G_SysResults[SYS_DWFLOW] = R.f32(((G_StepFlowTotals.dwInflow * F.UCF(FLOW))))
  G_SysResults[SYS_GWFLOW] = R.f32(((G_StepFlowTotals.gwInflow * F.UCF(FLOW))))
  G_SysResults[SYS_IIFLOW] = R.f32(((G_StepFlowTotals.iiInflow * F.UCF(FLOW))))
  G_SysResults[SYS_EXFLOW] = R.f32(((G_StepFlowTotals.exInflow * F.UCF(FLOW))))
  G_SysResults[SYS_INFLOW] = R.f32(R.f32(R.f32(R.f32(G_SysResults[SYS_RUNOFF] + G_SysResults[SYS_DWFLOW]) + G_SysResults[SYS_GWFLOW]) + G_SysResults[SYS_IIFLOW]) + G_SysResults[SYS_EXFLOW])
  R.fwrite_arr("f", G_SysResults, 0, 15, G_Fout.file)
  if ((G_Foutflows.mode == SAVE_FILE) and (not (G.IgnoreRouting ~= 0))) then
    F.iface_saveOutletResults(reportDate, G_Foutflows.file)
  end
  G.Nperiods = G.Nperiods + 1
end

-- output.c:515
F.output_end = function()
  local G_Fout = G.Fout
  local k = {0}
  R.fwrite1("l", 4, G.IDStartPos, G_Fout.file)
  R.fwrite1("l", 4, G.InputStartPos, G_Fout.file)
  R.fwrite1("l", 4, G.OutputStartPos, G_Fout.file)
  k[1] = R.i32(G.Nperiods)
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = G.ErrorCode
  R.fwrite1("i", 4, k[1], G_Fout.file)
  k[1] = 516114522
  if (R.fwrite1("i", 4, k[1], G_Fout.file) < 1) then
    F.report_writeErrorMsg(ERR_OUT_WRITE, S[0])
  end
end

-- output.c:539
F.output_close = function()
  do
    if (G.SubcatchResults ~= nil) then
      local _ = nil
      G.SubcatchResults = (nil)
    end
  end
  do
    if (G.NodeResults ~= nil) then
      local _ = nil
      G.NodeResults = (nil)
    end
  end
  do
    if (G.LinkResults ~= nil) then
      local _ = nil
      G.LinkResults = (nil)
    end
  end
  F.output_closeAvgResults()
end

-- output.c:554
F.output_saveID = function(id, file)
  local n = {R.i32(R.strlen(id))}
  R.fwrite1("i", 4, n[1], file)
  R.fwrite_arr("c", id, 0, n[1], file)
end

-- output.c:569
F.output_saveSubcatchResults = function(reportTime, file)
  local G_Nobjects, G_SubcatchResults, G_Subcatch, G_SysResults, G_Temp = G.Nobjects, G.SubcatchResults, G.Subcatch, G.SysResults, G.Temp
  local j = 0
  local f = 0.0
  local area = 0.0
  local totalArea = 0.0
  local reportDate = F.getDateTime(reportTime)
  do
    j = 0
    while (j < G_Nobjects[GAGE]) do
      do
        F.gage_setReportRainfall(j, reportDate)
      end
      j = j + 1
    end
  end
  f = (((reportTime - G.OldRunoffTime)) / ((G.NewRunoffTime - G.OldRunoffTime)))
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        F.subcatch_getResults(j, f, G_SubcatchResults)
        if (G_Subcatch[j].rptFlag ~= 0) then
          R.fwrite_arr("f", G_SubcatchResults, 0, G.NumSubcatchVars, file)
        end
        area = (G_Subcatch[j].area * F.UCF(LANDAREA))
        totalArea = R.f32(totalArea + (R.f32(area)))
        G_SysResults[SYS_RAINFALL] = R.f32(G_SysResults[SYS_RAINFALL] + (R.f32(((G_SubcatchResults[SUBCATCH_RAINFALL] * area)))))
        G_SysResults[SYS_SNOWDEPTH] = R.f32(G_SysResults[SYS_SNOWDEPTH] + (R.f32(((G_SubcatchResults[SUBCATCH_SNOWDEPTH] * area)))))
        G_SysResults[SYS_EVAP] = R.f32(G_SysResults[SYS_EVAP] + (R.f32(((G_SubcatchResults[SUBCATCH_EVAP] * area)))))
        if (G_Subcatch[j].groundwater ~= nil) then
          G_SysResults[SYS_EVAP] = R.f32(G_SysResults[SYS_EVAP] + (R.f32((((G_Subcatch[j].groundwater.evapLoss * F.UCF(EVAPRATE)) * area)))))
        end
        G_SysResults[SYS_INFIL] = R.f32(G_SysResults[SYS_INFIL] + (R.f32(((G_SubcatchResults[SUBCATCH_INFIL] * area)))))
        G_SysResults[SYS_RUNOFF] = R.f32(G_SysResults[SYS_RUNOFF] + G_SubcatchResults[SUBCATCH_RUNOFF])
      end
      j = j + 1
    end
  end
  if (totalArea > 0.0) then
    G_SysResults[SYS_EVAP] = R.f32(G_SysResults[SYS_EVAP] / totalArea)
    G_SysResults[SYS_RAINFALL] = R.f32(G_SysResults[SYS_RAINFALL] / totalArea)
    G_SysResults[SYS_SNOWDEPTH] = R.f32(G_SysResults[SYS_SNOWDEPTH] / totalArea)
    G_SysResults[SYS_INFIL] = R.f32(G_SysResults[SYS_INFIL] / totalArea)
  end
  if (G.UnitSystem == SI) then
    f = (((5.0 / 9.0)) * ((G_Temp.ta - 32.0)))
  else
    f = G_Temp.ta
  end
  G_SysResults[SYS_TEMPERATURE] = R.f32(f)
  f = (G.Evap.rate * F.UCF(EVAPRATE))
  G_SysResults[SYS_PET] = R.f32(f)
end

-- output.c:636
F.output_saveNodeResults = function(reportTime, file)
  local G_Nobjects, G_NodeResults, G_Node, G_SysResults = G.Nobjects, G.NodeResults, G.Node, G.SysResults
  local j = 0
  local f = (((reportTime - G.OldRoutingTime)) / ((G.NewRoutingTime - G.OldRoutingTime)))
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        F.node_getResults(j, f, G_NodeResults)
        if (G_Node[j].rptFlag ~= 0) then
          R.fwrite_arr("f", G_NodeResults, 0, G.NumNodeVars, file)
        end
        F.stats_updateMaxNodeDepth(j, G_NodeResults[NODE_DEPTH])
        G_SysResults[SYS_STORAGE] = R.f32(G_SysResults[SYS_STORAGE] + G_NodeResults[NODE_VOLUME])
      end
      j = j + 1
    end
  end
end

-- output.c:666
F.output_saveLinkResults = function(reportTime, file)
  local G_Nobjects, G_Link, G_LinkResults, G_SysResults = G.Nobjects, G.Link, G.LinkResults, G.SysResults
  local j = 0
  local f = 0.0
  local z = 0.0
  f = (((reportTime - G.OldRoutingTime)) / ((G.NewRoutingTime - G.OldRoutingTime)))
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        if (G_Link[j].rptFlag ~= 0) then
          F.link_getResults(j, f, G_LinkResults)
          R.fwrite_arr("f", G_LinkResults, 0, G.NumLinkVars, file)
        end
        z = ((((((1.0 - f)) * G_Link[j].oldVolume) + (f * G_Link[j].newVolume))) * F.UCF(VOLUME))
        G_SysResults[SYS_STORAGE] = R.f32(G_SysResults[SYS_STORAGE] + (R.f32(z)))
      end
      j = j + 1
    end
  end
end

-- output.c:699
F.output_readDateTime = function(period, days, days__k)
  local G_Fout = G.Fout
  local p = period
  local bytePos = (G.OutputStartPos + (((p - 1)) * G.BytesPerPeriod))
  R.fseek(G_Fout.file, bytePos, 0)
  days[days__k] = ((-693594) * 1.0)
  R.fread1("d", 8, days, days__k, G_Fout.file)
end

-- output.c:716
F.output_readSubcatchResults = function(period, index)
  local G_Fout = G.Fout
  local offset = (index * G.NumSubcatchVars)
  local p = period
  local bytePos = (((G.OutputStartPos + (((p - 1)) * G.BytesPerPeriod)) + 8) + (offset * 4))
  R.fseek(G_Fout.file, bytePos, 0)
  R.fread_arr("f", G.SubcatchResults, 0, G.NumSubcatchVars, G_Fout.file)
end

-- output.c:735
F.output_readNodeResults = function(period, index)
  local G_Fout = G.Fout
  local offset = ((G.NumSubcatch * G.NumSubcatchVars) + (index * G.NumNodeVars))
  local p = period
  local bytePos = (((G.OutputStartPos + (((p - 1)) * G.BytesPerPeriod)) + 8) + (offset * 4))
  R.fseek(G_Fout.file, bytePos, 0)
  R.fread_arr("f", G.NodeResults, 0, G.NumNodeVars, G_Fout.file)
end

-- output.c:753
F.output_readLinkResults = function(period, index)
  local G_Fout = G.Fout
  local offset = ((((G.NumSubcatch * G.NumSubcatchVars) + (G.NumNodes * G.NumNodeVars)) + (index * G.NumLinkVars)))
  local p = period
  local bytePos = (((G.OutputStartPos + (((p - 1)) * G.BytesPerPeriod)) + 8) + (offset * 4))
  R.fseek(G_Fout.file, bytePos, 0)
  R.fread_arr("f", G.LinkResults, 0, G.NumLinkVars, G_Fout.file)
  R.fread_arr("f", G.SysResults, 0, 15, G_Fout.file)
end

-- output.c:774
F.output_openAvgResults = function()
  local i = 0
  G.AvgNodeResults = R.recs(G.NumNodes, T.TAvgResults)
  if (G.AvgNodeResults == (nil)) then
    do return 0 end
  end
  do
    i = 0
    while (i < G.NumNodes) do
      do
        G.AvgNodeResults[i].xAvg = (nil)
      end
      i = i + 1
    end
  end
  G.AvgLinkResults = R.recs(G.NumLinks, T.TAvgResults)
  if (G.AvgLinkResults == (nil)) then
    F.output_closeAvgResults()
    do return 0 end
  end
  do
    i = 0
    while (i < G.NumLinks) do
      do
        G.AvgLinkResults[i].xAvg = (nil)
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G.NumNodes) do
      do
        G.AvgNodeResults[i].xAvg = R.fill(G.NumNodeVars, 0.0)
        if (G.AvgNodeResults[i].xAvg == (nil)) then
          F.output_closeAvgResults()
          do return 0 end
        end
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G.NumLinks) do
      do
        G.AvgLinkResults[i].xAvg = R.fill(G.NumLinkVars, 0.0)
        if (G.AvgLinkResults[i].xAvg == (nil)) then
          F.output_closeAvgResults()
          do return 0 end
        end
      end
      i = i + 1
    end
  end
  do return 1 end
end

-- output.c:820
F.output_closeAvgResults = function()
  local i = 0
  if (G.AvgNodeResults ~= nil) then
    do
      i = 0
      while (i < G.NumNodes) do
        do
          if (G.AvgNodeResults[i].xAvg ~= nil) then
            local _ = nil
            G.AvgNodeResults[i].xAvg = (nil)
          end
        end
        i = i + 1
      end
    end
    do
      if (G.AvgNodeResults ~= nil) then
        local _ = nil
        G.AvgNodeResults = (nil)
      end
    end
  end
  if (G.AvgLinkResults ~= nil) then
    do
      i = 0
      while (i < G.NumLinks) do
        do
          if (G.AvgLinkResults[i].xAvg ~= nil) then
            local _ = nil
            G.AvgLinkResults[i].xAvg = (nil)
          end
        end
        i = i + 1
      end
    end
    do
      if (G.AvgLinkResults ~= nil) then
        local _ = nil
        G.AvgLinkResults = (nil)
      end
    end
  end
end

-- output.c:839
F.output_initAvgResults = function()
  local G_AvgNodeResults, G_AvgLinkResults = G.AvgNodeResults, G.AvgLinkResults
  local i = 0
  local j = 0
  G.output_Nsteps = 0
  do
    i = 0
    while (i < G.NumNodes) do
      do
        do
          j = 0
          while (j < G.NumNodeVars) do
            do
              G_AvgNodeResults[i].xAvg[j] = R.f32(0.0)
            end
            j = j + 1
          end
        end
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G.NumLinks) do
      do
        do
          j = 0
          while (j < G.NumLinkVars) do
            do
              G_AvgLinkResults[i].xAvg[j] = R.f32(0.0)
            end
            j = j + 1
          end
        end
      end
      i = i + 1
    end
  end
end

-- output.c:857
F.output_updateAvgResults = function()
  local G_Nobjects, G_Node, G_NodeResults, G_AvgNodeResults, G_Link, G_LinkResults = G.Nobjects, G.Node, G.NodeResults, G.AvgNodeResults, G.Link, G.LinkResults
  local G_AvgLinkResults = G.AvgLinkResults
  local i = 0
  local j = 0
  local k = 0
  local sign = 0
  k = 0
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        if (not (G_Node[i].rptFlag ~= 0)) then
          goto continue1
        end
        F.node_getResults(i, 1.0, G_NodeResults)
        do
          j = 0
          while (j < G.NumNodeVars) do
            do
              G_AvgNodeResults[k].xAvg[j] = R.f32(G_AvgNodeResults[k].xAvg[j] + G_NodeResults[j])
            end
            j = j + 1
          end
        end
        k = k + 1
      end
      ::continue1::
      i = i + 1
    end
  end
  k = 0
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        if (not (G_Link[i].rptFlag ~= 0)) then
          goto continue3
        end
        F.link_getResults(i, 1.0, G_LinkResults)
        sign = (((((G_LinkResults[LINK_FLOW]) < R.f32(0.0))) and ((-1)) or (1)))
        do
          j = 0
          while (j < G.NumLinkVars) do
            do
              if (j == LINK_CAPACITY) then
                if (G_Link[i].type_ == CONDUIT) then
                  G_AvgLinkResults[k].xAvg[j] = R.f32(G_AvgLinkResults[k].xAvg[j] + G_LinkResults[j])
                else
                  G_AvgLinkResults[k].xAvg[j] = R.f32(G_LinkResults[j] * R.f32((((G.output_Nsteps + 1)) * 1.0)))
                end
              else
                G_AvgLinkResults[k].xAvg[j] = R.f32(G_AvgLinkResults[k].xAvg[j] + G_LinkResults[j])
              end
            end
            j = j + 1
          end
        end
        k = k + 1
      end
      ::continue3::
      i = i + 1
    end
  end
  G.output_Nsteps = G.output_Nsteps + 1
end

-- output.c:911
F.output_saveAvgResults = function(file)
  local G_AvgNodeResults, G_NodeResults, G_Nobjects, G_Node, G_SysResults, G_AvgLinkResults = G.AvgNodeResults, G.NodeResults, G.Nobjects, G.Node, G.SysResults, G.AvgLinkResults
  local G_LinkResults, G_Link = G.LinkResults, G.Link
  local i = 0
  local j = 0
  do
    i = 0
    while (i < G.NumNodes) do
      do
        do
          j = 0
          while (j < G.NumNodeVars) do
            do
              G_NodeResults[j] = R.f32(G_AvgNodeResults[i].xAvg[j] / R.f32((G.output_Nsteps * 1.0)))
            end
            j = j + 1
          end
        end
        R.fwrite_arr("f", G_NodeResults, 0, G.NumNodeVars, file)
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        F.stats_updateMaxNodeDepth(i, (G_Node[i].newDepth * F.UCF(LENGTH)))
        G_SysResults[SYS_STORAGE] = R.f32(G_SysResults[SYS_STORAGE] + (R.f32(((G_Node[i].newVolume * F.UCF(VOLUME))))))
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G.NumLinks) do
      do
        do
          j = 0
          while (j < G.NumLinkVars) do
            do
              G_LinkResults[j] = R.f32(G_AvgLinkResults[i].xAvg[j] / R.f32((G.output_Nsteps * 1.0)))
            end
            j = j + 1
          end
        end
        R.fwrite_arr("f", G_LinkResults, 0, G.NumLinkVars, file)
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        G_SysResults[SYS_STORAGE] = R.f32(G_SysResults[SYS_STORAGE] + (R.f32(((G_Link[i].newVolume * F.UCF(VOLUME))))))
      end
      i = i + 1
    end
  end
  F.output_initAvgResults()
end

