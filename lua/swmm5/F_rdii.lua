-- Generated from EPA SWMM 5.2.4 (rdii.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local ERR_ITEMS <const> = 203
local NODE <const> = 2
local ERR_NAME <const> = 209
local UNITHYD <const> = 12
local ERR_NUMBER <const> = 211
local ERR_MEMORY <const> = 101
local LANDAREA <const> = 4
local GAGE <const> = 0
local ERR_KEYWORD <const> = 205
local USE_FILE <const> = 2
local NO_FILE <const> = 0
local SCRATCH_FILE <const> = 1
local ERR_RDII_FILE_SCRATCH <const> = 341
local ERR_RDII_FILE_OPEN <const> = 343
local BINARY <const> = 0
local TEXT <const> = 1
local ERR_RDII_FILE_FORMAT <const> = 345
local ERR_UNITHYD_TIMES <const> = 151
local ERR_UNITHYD_RATIOS <const> = 153
local ERR_RDII_AREA <const> = 155
local RAINDEPTH <const> = 1
local RAINFALL <const> = 0
local _ENV = R.strict

G.ZERO_RDII = 0.0001
G.FileStamp = R.bufFrom(S[352], 11)
G.UHGroup = nil
G.RdiiStep = 0
G.NumRdiiNodes = 0
G.RdiiNodeIndex = nil
G.RdiiNodeFlow = nil
G.RdiiFlowUnits = 0
G.RdiiStartDate = 0.0
G.RdiiEndDate = 0.0
G.TotalRainVol = 0.0
G.TotalRdiiVol = 0.0
G.RdiiFileType = 0

-- rdii.c:152
F.rdii_readRdiiInflow = function(tok, ntoks)
  local G_Node = G.Node
  local j = 0
  local k = 0
  local a = {0.0}
  local inflow = nil
  if (ntoks < 3) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  j = F.project_findObject(NODE, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  k = F.project_findObject(UNITHYD, tok[1])
  if (k < 0) then
    do return F.error_setInpError(ERR_NAME, tok[1]) end
  end
  if ((not (F.getDouble(tok[2], a, 1) ~= 0)) or (a[1] < 0.0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[2]) end
  end
  inflow = G_Node[j].rdiiInflow
  if (inflow == (nil)) then
    inflow = T.TRdiiInflow()
    if (not (inflow ~= nil)) then
      do return F.error_setInpError(ERR_MEMORY, S[0]) end
    end
  end
  inflow.unitHyd = k
  inflow.area = (a[1] / F.UCF(LANDAREA))
  G_Node[j].rdiiInflow = inflow
  do return 0 end
end

-- rdii.c:198
F.rdii_initUnitHyd = function(j)
  local G_UnitHyd = G.UnitHyd
  local i = 0
  local m = 0
  do
    m = 0
    while (m < 12) do
      do
        do
          i = 0
          while (i < 3) do
            do
              G_UnitHyd[j].iaMax[m][i] = 0.0
              G_UnitHyd[j].iaRecov[m][i] = 0.0
              G_UnitHyd[j].iaInit[m][i] = 0.0
              G_UnitHyd[j].r[m][i] = 0.0
              G_UnitHyd[j].tPeak[m][i] = 0
              G_UnitHyd[j].tBase[m][i] = 0
            end
            i = i + 1
          end
        end
      end
      m = m + 1
    end
  end
end

-- rdii.c:224
F.rdii_readUnitHydParams = function(tok, ntoks)
  local G_UnitHyd = G.UnitHyd
  local i = 0
  local j = 0
  local k = 0
  local m = 0
  local g = 0
  local x = R.fill(6, 0.0)
  j = F.project_findObject(UNITHYD, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  if R.peq(G_UnitHyd[j].ID, (nil)) then
    G_UnitHyd[j].ID = F.project_findID(UNITHYD, tok[0])
  end
  if (ntoks == 2) then
    g = F.project_findObject(GAGE, tok[1])
    if (g < 0) then
      do return F.error_setInpError(ERR_NAME, tok[1]) end
    end
    G_UnitHyd[j].rainGage = g
    G.Gage[g].isUsed = 1
    do return 0 end
  elseif (ntoks < 6) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  m = F.datetime_findMonth(tok[1])
  if (m == 0) then
    if (not (F.match(tok[1], S[351]) ~= 0)) then
      do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
    end
  end
  k = F.findmatch(tok[2], G.UHTypeWords)
  if (k < 0) then
    do return F.readOldUHFormat(j, m, tok, ntoks) end
  end
  do
    i = 0
    while (i < 3) do
      do
        if (not (F.getDouble(tok[(i + 3)], x, i) ~= 0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[(i + 3)]) end
        end
      end
      i = i + 1
    end
  end
  do
    i = 3
    while (i < 6) do
      do
        x[i] = 0.0
        if (ntoks > (i + 3)) then
          if (not (F.getDouble(tok[(i + 3)], x, i) ~= 0)) then
            do return F.error_setInpError(ERR_NUMBER, tok[(i + 2)]) end
          end
        end
      end
      i = i + 1
    end
  end
  F.setUnitHydParams(j, k, m, x)
  do return 0 end
end

-- rdii.c:293
F.readOldUHFormat = function(j, m, tok, ntoks)
  local i = 0
  local k = 0
  local p = R.fill(9, 0.0)
  local x = R.fill(6, 0.0)
  if (ntoks < 11) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  do
    i = 0
    while (i < 9) do
      do
        if (not (F.getDouble(tok[(i + 2)], p, i) ~= 0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[(i + 2)]) end
        end
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < 3) do
      do
        x[(i + 3)] = 0.0
        if (ntoks > (i + 11)) then
          if (not (F.getDouble(tok[(i + 11)], x, (i + 3)) ~= 0)) then
            do return F.error_setInpError(ERR_NUMBER, tok[(i + 11)]) end
          end
        end
      end
      i = i + 1
    end
  end
  do
    k = 0
    while (k < 3) do
      do
        do
          i = 0
          while (i < 3) do
            do
              x[i] = p[((3 * k) + i)]
              F.setUnitHydParams(j, k, m, x)
            end
            i = i + 1
          end
        end
      end
      k = k + 1
    end
  end
  do return 0 end
end

-- rdii.c:342
F.setUnitHydParams = function(j, i, m, x)
  local G_UnitHyd = G.UnitHyd
  local m1 = 0
  local m2 = 0
  local t = 0.0
  local k = 0.0
  local tBase = 0.0
  if (m == 0) then
    m1 = 0
    m2 = 11
  else
    m1 = (m - 1)
    m2 = m1
  end
  do
    m = m1
    while (m <= m2) do
      do
        G_UnitHyd[j].r[m][i] = x[0]
        t = x[1]
        k = x[2]
        tBase = (t * ((1.0 + k)))
        G_UnitHyd[j].tPeak[m][i] = R.D2L(((t * 3600.0)))
        G_UnitHyd[j].tBase[m][i] = R.D2L(((tBase * 3600.0)))
        G_UnitHyd[j].iaMax[m][i] = x[3]
        G_UnitHyd[j].iaRecov[m][i] = x[4]
        G_UnitHyd[j].iaInit[m][i] = x[5]
      end
      m = m + 1
    end
  end
end

-- rdii.c:389
F.rdii_deleteRdiiInflow = function(j)
  local G_Node = G.Node
  if (G_Node[j].rdiiInflow ~= nil) then
    local _ = nil
    G_Node[j].rdiiInflow = (nil)
  end
end

-- rdii.c:408
F.rdii_openRdii = function()
  local G_Frdii, G_FileStamp = G.Frdii, G.FileStamp
  local fStamp = R.bufFrom(S[352], 11)
  G.RdiiNodeIndex = (nil)
  G.RdiiNodeFlow = (nil)
  G.NumRdiiNodes = 0
  G.RdiiStartDate = ((-693594) * 1.0)
  if (G.IgnoreRDII ~= 0) then
    do return end
  end
  if (G_Frdii.mode ~= USE_FILE) then
    F.createRdiiFile()
  end
  if ((G_Frdii.mode == NO_FILE) or (G.ErrorCode ~= 0)) then
    do return end
  end
  G_Frdii.file = R.fopen(G_Frdii.name, S[353])
  if (G_Frdii.file == (nil)) then
    if (G_Frdii.mode == SCRATCH_FILE) then
      F.report_writeErrorMsg(ERR_RDII_FILE_SCRATCH, S[0])
    else
      F.report_writeErrorMsg(ERR_RDII_FILE_OPEN, G_Frdii.name)
    end
    do return end
  end
  R.fread_arr("c", fStamp, 0, R.strlen(G_FileStamp), G_Frdii.file)
  if (R.strcmp(fStamp, G_FileStamp) == 0) then
    G.RdiiFileType = BINARY
    G.ErrorCode = F.readRdiiFileHeader()
  else
    R.fclose(G_Frdii.file)
    G.RdiiFileType = TEXT
    F.openRdiiTextFile()
  end
  if (G.ErrorCode ~= 0) then
    F.report_writeErrorMsg(G.ErrorCode, G_Frdii.name)
  else
    F.readRdiiFlows()
  end
end

-- rdii.c:470
F.openRdiiTextFile = function()
  local G_Frdii = G.Frdii
  G_Frdii.file = R.fopen(G_Frdii.name, S[13])
  if (G_Frdii.file == (nil)) then
    if (G_Frdii.mode == SCRATCH_FILE) then
      F.report_writeErrorMsg(ERR_RDII_FILE_SCRATCH, S[0])
    else
      F.report_writeErrorMsg(ERR_RDII_FILE_OPEN, G_Frdii.name)
    end
    do return end
  end
  G.ErrorCode = F.readRdiiTextFileHeader()
  if (G.ErrorCode ~= 0) then
    F.report_writeErrorMsg(G.ErrorCode, G_Frdii.name)
  end
end

-- rdii.c:497
F.rdii_closeRdii = function()
  local G_Frdii = G.Frdii
  if (G_Frdii.file ~= nil) then
    R.fclose(G_Frdii.file)
  end
  if (G_Frdii.mode == SCRATCH_FILE) then
    R.remove(G_Frdii.name)
  end
  do
    if (G.RdiiNodeIndex ~= nil) then
      local _ = nil
      G.RdiiNodeIndex = (nil)
    end
  end
  do
    if (G.RdiiNodeFlow ~= nil) then
      local _ = nil
      G.RdiiNodeFlow = (nil)
    end
  end
end

-- rdii.c:512
F.rdii_getNumRdiiFlows = function(aDate)
  local G_Frdii = G.Frdii
  if (G.NumRdiiNodes == 0) then
    do return 0 end
  end
  if (not (G_Frdii.file ~= nil)) then
    do return 0 end
  end
  while (not (R.feof(G_Frdii.file) ~= 0)) do
    do
      if (G.RdiiStartDate == ((-693594) * 1.0)) then
        do return 0 end
      end
      if (aDate < G.RdiiStartDate) then
        do return 0 end
      end
      if (aDate < G.RdiiEndDate) then
        do return G.NumRdiiNodes end
      else
        F.readRdiiFlows()
      end
    end
  end
  do return 0 end
end

-- rdii.c:542
F.rdii_getRdiiFlow = function(i, j, j__k, q, q__k)
  if ((i >= 0) and (i < G.NumRdiiNodes)) then
    j[j__k] = G.RdiiNodeIndex[i]
    q[q__k] = G.RdiiNodeFlow[i]
  end
end

-- rdii.c:560
F.readRdiiFileHeader = function()
  local G_Frdii, G_Node = G.Frdii, G.Node
  local i = 0
  local j = 0
  R.fread1("i", 4, G, "RdiiStep", G_Frdii.file)
  if (G.RdiiStep <= 0) then
    do return ERR_RDII_FILE_FORMAT end
  end
  R.fread1("i", 4, G, "NumRdiiNodes", G_Frdii.file)
  if (G.NumRdiiNodes <= 0) then
    do return ERR_RDII_FILE_FORMAT end
  end
  G.RdiiNodeIndex = R.fill(G.NumRdiiNodes, 0)
  if (not (G.RdiiNodeIndex ~= nil)) then
    do return ERR_MEMORY end
  end
  G.RdiiNodeFlow = R.fill(G.NumRdiiNodes, 0.0)
  if (not (G.RdiiNodeFlow ~= nil)) then
    do return ERR_MEMORY end
  end
  if (R.feof(G_Frdii.file) ~= 0) then
    do return ERR_RDII_FILE_FORMAT end
  end
  R.fread_arr("i", G.RdiiNodeIndex, 0, G.NumRdiiNodes, G_Frdii.file)
  do
    i = 0
    while (i < G.NumRdiiNodes) do
      do
        j = G.RdiiNodeIndex[i]
        if (G_Node[j].rdiiInflow == (nil)) then
          do return ERR_RDII_FILE_FORMAT end
        end
      end
      i = i + 1
    end
  end
  if (R.feof(G_Frdii.file) ~= 0) then
    do return ERR_RDII_FILE_FORMAT end
  end
  do return 0 end
end

-- rdii.c:595
F.readRdiiTextFileHeader = function()
  local G_Frdii = G.Frdii
  local i = 0
  local j = 0
  local line = R.buf(1025)
  local s1 = R.bufFrom(S[0], 1025)
  local s2 = R.buf(1025)
  R.fgets(line, 1024, G_Frdii.file)
  if ((not (R.sscanf(line, S[169], s1) ~= 0)) or (R.strcmp(s1, S[181]) ~= 0)) then
    do return ERR_RDII_FILE_FORMAT end
  end
  R.fgets(line, 1024, G_Frdii.file)
  G.RdiiStep = 0
  R.fgets(line, 1024, G_Frdii.file)
  if ((not (R.sscanf(line, S[182], G, "RdiiStep") ~= 0)) or (G.RdiiStep <= 0)) then
    do return ERR_RDII_FILE_FORMAT end
  end
  R.fgets(line, 1024, G_Frdii.file)
  R.fgets(line, 1024, G_Frdii.file)
  if (R.sscanf(line, S[44], s1, s2) < 2) then
    do return ERR_RDII_FILE_FORMAT end
  end
  G.RdiiFlowUnits = F.findmatch(s2, G.FlowUnitWords)
  if (G.RdiiFlowUnits < 0) then
    do return ERR_RDII_FILE_FORMAT end
  end
  R.fgets(line, 1024, G_Frdii.file)
  if ((R.sscanf(line, S[182], G, "NumRdiiNodes") < 1) or (G.NumRdiiNodes <= 0)) then
    do return ERR_RDII_FILE_FORMAT end
  end
  G.RdiiNodeIndex = R.fill(G.NumRdiiNodes, 0)
  if (not (G.RdiiNodeIndex ~= nil)) then
    do return ERR_MEMORY end
  end
  G.RdiiNodeFlow = R.fill(G.NumRdiiNodes, 0.0)
  if (not (G.RdiiNodeFlow ~= nil)) then
    do return ERR_MEMORY end
  end
  do
    i = 0
    while (i < G.NumRdiiNodes) do
      do
        if (R.feof(G_Frdii.file) ~= 0) then
          do return ERR_RDII_FILE_FORMAT end
        end
        R.fgets(line, 1024, G_Frdii.file)
        if (not (R.sscanf(line, S[169], s1) ~= 0)) then
          do return ERR_RDII_FILE_FORMAT end
        end
        j = F.project_findObject(NODE, s1)
        if (j < 0) then
          do return ERR_RDII_FILE_FORMAT end
        end
        G.RdiiNodeIndex[i] = j
      end
      i = i + 1
    end
  end
  if (R.feof(G_Frdii.file) ~= 0) then
    do return ERR_RDII_FILE_FORMAT end
  end
  R.fgets(line, 1024, G_Frdii.file)
  do return 0 end
end

-- rdii.c:663
F.readRdiiFlows = function()
  local G_Frdii = G.Frdii
  if (G.RdiiFileType == TEXT) then
    F.readRdiiTextFlows()
  else
    G.RdiiStartDate = ((-693594) * 1.0)
    G.RdiiEndDate = ((-693594) * 1.0)
    if (R.feof(G_Frdii.file) ~= 0) then
      do return end
    end
    R.fread1("d", 8, G, "RdiiStartDate", G_Frdii.file)
    if (G.RdiiStartDate == ((-693594) * 1.0)) then
      do return end
    end
    if (R.fread_arr("f", G.RdiiNodeFlow, 0, G.NumRdiiNodes, G_Frdii.file) < G.NumRdiiNodes) then
      G.RdiiStartDate = ((-693594) * 1.0)
    else
      G.RdiiEndDate = F.datetime_addSeconds(G.RdiiStartDate, (G.RdiiStep * 1.0))
    end
  end
end

-- rdii.c:686
F.readRdiiTextFlows = function()
  local G_Frdii, G_Qcf, G_RdiiNodeFlow = G.Frdii, G.Qcf, G.RdiiNodeFlow
  local i = 0
  local n = 0
  local yr = {0}
  local mon = {0}
  local day = {0}
  local hr = {0}
  local min = {0}
  local sec = {0}
  local x = {0.0}
  local line = R.buf(1025)
  local s = R.buf(1025)
  G.RdiiStartDate = ((-693594) * 1.0)
  do
    i = 0
    while (i < G.NumRdiiNodes) do
      do
        if (R.feof(G_Frdii.file) ~= 0) then
          do return end
        end
        R.fgets(line, 1024, G_Frdii.file)
        n = R.sscanf(line, S[354], s, yr, 1, mon, 1, day, 1, hr, 1, min, 1, sec, 1, x, 1)
        if (n < 8) then
          do return end
        end
        G_RdiiNodeFlow[i] = R.f32(((x[1] / G_Qcf[G.RdiiFlowUnits])))
      end
      i = i + 1
    end
  end
  G.RdiiStartDate = (F.datetime_encodeDate(yr[1], mon[1], day[1]) + F.datetime_encodeTime(hr[1], min[1], sec[1]))
  G.RdiiEndDate = F.datetime_addSeconds(G.RdiiStartDate, (G.RdiiStep * 1.0))
end

-- rdii.c:720
F.createRdiiFile = function()
  local G_Frdii = G.Frdii
  local hasRdii = 0
  local elapsedTime = 0.0
  local duration = 0.0
  local currentDate = 0.0
  G.RdiiStep = G.WetStep
  G.NumRdiiNodes = F.getNumRdiiNodes()
  if (G.NumRdiiNodes == 0) then
    G_Frdii.mode = NO_FILE
    do return end
  elseif (G_Frdii.mode == NO_FILE) then
    G_Frdii.mode = SCRATCH_FILE
  end
  F.validateRdii()
  F.initGageData()
  if (G.ErrorCode ~= 0) then
    do return end
  end
  F.openRdiiProcessor()
  if (not (G.ErrorCode ~= 0)) then
    F.initUnitHydData()
    duration = (G.TotalDuration / 1000.0)
    elapsedTime = 0.0
    while ((elapsedTime <= duration) and (not (G.ErrorCode ~= 0))) do
      do
        currentDate = (G.StartDateTime + (elapsedTime / 86400.0))
        F.getRainfall(currentDate)
        F.getUnitHydRdii(currentDate)
        hasRdii = F.getNodeRdii()
        if (hasRdii ~= 0) then
          F.saveRdiiFlows(currentDate)
        end
        elapsedTime = (elapsedTime + (G.RdiiStep * 1.0))
      end
    end
  end
  F.closeRdiiProcessor()
end

-- rdii.c:793
F.getNumRdiiNodes = function()
  local G_Nobjects, G_Node = G.Nobjects, G.Node
  local j = 0
  local n = 0
  n = 0
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        if (G_Node[j].rdiiInflow ~= nil) then
          n = n + 1
        end
      end
      j = j + 1
    end
  end
  do return n end
end

-- rdii.c:813
F.validateRdii = function()
  local G_Nobjects, G_UnitHyd, G_Node = G.Nobjects, G.UnitHyd, G.Node
  local i = 0
  local j = 0
  local k = 0
  local m = 0
  local rsum = 0.0
  do
    j = 0
    while (j < G_Nobjects[UNITHYD]) do
      do
        do
          m = 0
          while (m < 12) do
            do
              rsum = 0.0
              do
                k = 0
                while (k < 3) do
                  do
                    if (G_UnitHyd[j].tBase[m][k] == 0) then
                      goto continue3
                    end
                    if ((G_UnitHyd[j].tPeak[m][k] * 1.0) < 0.0) then
                      F.report_writeErrorMsg(ERR_UNITHYD_TIMES, G_UnitHyd[j].ID)
                    end
                    if (G_UnitHyd[j].r[m][k] < 0.0) then
                      F.report_writeErrorMsg(ERR_UNITHYD_RATIOS, G_UnitHyd[j].ID)
                    else
                      rsum = (rsum + G_UnitHyd[j].r[m][k])
                    end
                  end
                  ::continue3::
                  k = k + 1
                end
              end
              if (rsum > 1.01) then
                F.report_writeErrorMsg(ERR_UNITHYD_RATIOS, G_UnitHyd[j].ID)
              end
            end
            m = m + 1
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
        if (G_Node[i].rdiiInflow ~= nil) then
          if (G_Node[i].rdiiInflow.area < 0.0) then
            F.report_writeErrorMsg(ERR_RDII_AREA, G_Node[i].ID)
          end
        end
      end
      i = i + 1
    end
  end
end

-- rdii.c:877
F.openRdiiProcessor = function()
  local G_Nobjects, G_Node = G.Nobjects, G.Node
  local j = 0
  local n = 0
  G.UHGroup = (nil)
  G.RdiiNodeIndex = (nil)
  G.RdiiNodeFlow = (nil)
  G.TotalRainVol = 0.0
  G.TotalRdiiVol = 0.0
  if (not (F.allocRdiiMemory() ~= 0)) then
    F.report_writeErrorMsg(ERR_MEMORY, S[0])
    do return end
  end
  if (not (F.openNewRdiiFile() ~= 0)) then
    F.report_writeErrorMsg(ERR_RDII_FILE_SCRATCH, S[0])
    do return end
  end
  n = 0
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        if ((G_Node[j].rdiiInflow ~= nil) and (G.RdiiNodeIndex ~= (nil))) then
          G.RdiiNodeIndex[n] = j
          n = n + 1
        end
      end
      j = j + 1
    end
  end
end

-- rdii.c:922
F.allocRdiiMemory = function()
  local G_Nobjects = G.Nobjects
  local i = 0
  local k = 0
  local n = 0
  G.UHGroup = R.recs(G_Nobjects[UNITHYD], T.TUHGroup)
  if (not (G.UHGroup ~= nil)) then
    do return 0 end
  end
  do
    i = 0
    while (i < G_Nobjects[UNITHYD]) do
      do
        G.UHGroup[i].rainInterval = F.getRainInterval(i)
        do
          k = 0
          while (k < 3) do
            do
              G.UHGroup[i].uh[k].pastRain = (nil)
              G.UHGroup[i].uh[k].pastMonth = (nil)
              G.UHGroup[i].uh[k].maxPeriods = F.getMaxPeriods(i, k)
              n = G.UHGroup[i].uh[k].maxPeriods
              if (n > 0) then
                G.UHGroup[i].uh[k].pastRain = R.fill(n, 0.0)
                if (not (G.UHGroup[i].uh[k].pastRain ~= nil)) then
                  do return 0 end
                end
                G.UHGroup[i].uh[k].pastMonth = R.buf(n)
                if (not (G.UHGroup[i].uh[k].pastMonth ~= nil)) then
                  do return 0 end
                end
              end
            end
            k = k + 1
          end
        end
      end
      i = i + 1
    end
  end
  G.RdiiNodeIndex = R.fill(G.NumRdiiNodes, 0)
  if (not (G.RdiiNodeIndex ~= nil)) then
    do return 0 end
  end
  G.RdiiNodeFlow = R.fill(G.NumRdiiNodes, 0.0)
  if (not (G.RdiiNodeFlow ~= nil)) then
    do return 0 end
  end
  do return 1 end
end

-- rdii.c:970
F.getRainInterval = function(i)
  local G_UnitHyd = G.UnitHyd
  local ri = 0
  local tLimb = 0
  local k = 0
  local m = 0
  ri = G.WetStep
  do
    m = 0
    while (m < 12) do
      do
        do
          k = 0
          while (k < 3) do
            do
              if (G_UnitHyd[i].tPeak[m][k] > 0) then
                tLimb = R.i32(G_UnitHyd[i].tPeak[m][k])
                ri = (((((ri) <= (tLimb))) and (ri) or (tLimb)))
                tLimb = R.i32((G_UnitHyd[i].tBase[m][k] - tLimb))
                if (tLimb > 0) then
                  ri = (((((ri) <= (tLimb))) and (ri) or (tLimb)))
                end
              end
            end
            k = k + 1
          end
        end
      end
      m = m + 1
    end
  end
  do return ri end
end

-- rdii.c:1005
F.getMaxPeriods = function(i, k)
  local G_UnitHyd = G.UnitHyd
  local m = 0
  local n = 0
  local nMax = 0
  local rainInterval = 0
  rainInterval = G.UHGroup[i].rainInterval
  nMax = 0
  do
    m = 0
    while (m < 12) do
      do
        n = R.i32(((R.idiv(G_UnitHyd[i].tBase[m][k], rainInterval)) + 1))
        nMax = (((((n) >= (nMax))) and (n) or (nMax)))
      end
      m = m + 1
    end
  end
  do return nMax end
end

-- rdii.c:1034
F.initGageData = function()
  local G_Nobjects, G_Gage, G_Tseries, G_UnitHyd = G.Nobjects, G.Gage, G.Tseries, G.UnitHyd
  local i = 0
  local g = 0
  do
    g = 0
    while (g < G_Nobjects[GAGE]) do
      do
        if (G_Gage[g].tSeries >= 0) then
          F.table_tseriesInit(G_Tseries[G_Gage[g].tSeries])
        end
        F.gage_initState(g)
      end
      g = g + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[UNITHYD]) do
      do
        g = G_UnitHyd[i].rainGage
        if (g >= 0) then
          if (G_Gage[g].coGage >= 0) then
            G_UnitHyd[i].rainGage = G_Gage[g].coGage
          end
        end
      end
      i = i + 1
    end
  end
end

-- rdii.c:1072
F.initUnitHydData = function()
  local G_Nobjects, G_UHGroup, G_UnitHyd, G_RdiiNodeIndex, G_Node = G.Nobjects, G.UHGroup, G.UnitHyd, G.RdiiNodeIndex, G.Node
  local i = 0
  local j = 0
  local k = 0
  local n = 0
  local month = 0
  month = (F.datetime_monthOfYear(G.StartDateTime) - 1)
  do
    i = 0
    while (i < G_Nobjects[UNITHYD]) do
      do
        do
          k = 0
          while (k < 3) do
            do
              G_UHGroup[i].uh[k].drySeconds = (((G_UHGroup[i].uh[k].maxPeriods * G_UHGroup[i].rainInterval)) + 1)
              G_UHGroup[i].uh[k].period = (G_UHGroup[i].uh[k].maxPeriods + 1)
              G_UHGroup[i].uh[k].hasPastRain = 0
              G_UHGroup[i].uh[k].iaUsed = G_UnitHyd[i].iaInit[month][k]
            end
            k = k + 1
          end
        end
        G_UHGroup[i].gageDate = G.StartDateTime
        G_UHGroup[i].area = 0.0
        G_UHGroup[i].rdii = 0.0
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[UNITHYD]) do
      do
        G_UHGroup[i].isUsed = 0
      end
      i = i + 1
    end
  end
  do
    n = 0
    while (n < G.NumRdiiNodes) do
      do
        j = G_RdiiNodeIndex[n]
        i = G_Node[j].rdiiInflow.unitHyd
        G_UHGroup[i].isUsed = 1
        G_UHGroup[i].lastDate = G.StartDateTime
        G_UHGroup[i].area = (G_UHGroup[i].area + G_Node[j].rdiiInflow.area)
      end
      n = n + 1
    end
  end
end

-- rdii.c:1128
F.openNewRdiiFile = function()
  local G_Frdii, G_FileStamp, G_Nobjects, G_Node = G.Frdii, G.FileStamp, G.Nobjects, G.Node
  local j = {0}
  if (G_Frdii.mode == SCRATCH_FILE) then
    F.getTempFileName(G_Frdii.name)
  end
  G_Frdii.file = R.fopen(G_Frdii.name, S[166])
  if (G_Frdii.file == (nil)) then
    do return 0 end
  end
  R.fwrite_arr("c", G_FileStamp, 0, R.strlen(G_FileStamp), G_Frdii.file)
  R.fwrite1("i", 4, G.RdiiStep, G_Frdii.file)
  R.fwrite1("i", 4, G.NumRdiiNodes, G_Frdii.file)
  do
    j[1] = 0
    while (j[1] < G_Nobjects[NODE]) do
      do
        if (G_Node[j[1]].rdiiInflow ~= nil) then
          R.fwrite1("i", 4, j[1], G_Frdii.file)
        end
      end
      j[1] = j[1] + 1
    end
  end
  do return 1 end
end

-- rdii.c:1163
F.getRainfall = function(currentDate)
  local G_Nobjects, G_Gage, G_UnitHyd, G_UHGroup, G_Adjust = G.Nobjects, G.Gage, G.UnitHyd, G.UHGroup, G.Adjust
  local j = 0
  local k = 0
  local g = 0
  local i = 0
  local month = 0
  local rainInterval = 0
  local rainDepth = 0.0
  local excessDepth = 0.0
  local gageDate = 0.0
  month = (F.datetime_monthOfYear(currentDate) - 1)
  do
    g = 0
    while (g < G_Nobjects[GAGE]) do
      do
        G_Gage[g].isCurrent = 0
      end
      g = g + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[UNITHYD]) do
      do
        g = G_UnitHyd[j].rainGage
        rainInterval = G_UHGroup[j].rainInterval
        while (G_UHGroup[j].gageDate < currentDate) do
          do
            gageDate = G_UHGroup[j].gageDate
            G_Adjust.rainFactor = G_Adjust.rain[(F.datetime_monthOfYear(gageDate) - 1)]
            if (not (G_Gage[g].isCurrent ~= 0)) then
              F.gage_setState(g, gageDate)
              G_Gage[g].isCurrent = 1
            end
            rainDepth = ((G_Gage[g].rainfall * (rainInterval * 1.0)) / 3600.0)
            G.TotalRainVol = (G.TotalRainVol + ((rainDepth / F.UCF(RAINDEPTH)) * G_UHGroup[j].area))
            do
              k = 0
              while (k < 3) do
                do
                  excessDepth = F.applyIA(j, k, gageDate, (rainInterval * 1.0), rainDepth)
                  F.updateDryPeriod(j, k, excessDepth, rainInterval)
                  i = G_UHGroup[j].uh[k].period
                  if (i >= G_UHGroup[j].uh[k].maxPeriods) then
                    i = 0
                  end
                  G_UHGroup[j].uh[k].pastRain[i] = excessDepth
                  R.cset(G_UHGroup[j].uh[k].pastMonth, i, R.i8(month))
                  G_UHGroup[j].uh[k].period = (i + 1)
                end
                k = k + 1
              end
            end
            G_UHGroup[j].gageDate = F.datetime_addSeconds(gageDate, (rainInterval * 1.0))
          end
        end
      end
      j = j + 1
    end
  end
end

-- rdii.c:1231
F.applyIA = function(j, k, aDate, dt, rainDepth)
  local G_UnitHyd, G_UHGroup = G.UnitHyd, G.UHGroup
  local m = 0
  local ia = 0.0
  local netRainDepth = 0.0
  m = (F.datetime_monthOfYear(aDate) - 1)
  ia = (G_UnitHyd[j].iaMax[m][k] - G_UHGroup[j].uh[k].iaUsed)
  ia = (((((ia) >= (0.0))) and (ia) or (0.0)))
  if (rainDepth > 0.0) then
    netRainDepth = (rainDepth - ia)
    netRainDepth = (((((netRainDepth) >= (0.0))) and (netRainDepth) or (0.0)))
    ia = (rainDepth - netRainDepth)
    G_UHGroup[j].uh[k].iaUsed = (G_UHGroup[j].uh[k].iaUsed + ia)
  else
    G_UHGroup[j].uh[k].iaUsed = (G_UHGroup[j].uh[k].iaUsed - ((dt / 86400.0) * G_UnitHyd[j].iaRecov[m][k]))
    G_UHGroup[j].uh[k].iaUsed = (((((G_UHGroup[j].uh[k].iaUsed) >= (0.0))) and (G_UHGroup[j].uh[k].iaUsed) or (0.0)))
    netRainDepth = 0.0
  end
  do return netRainDepth end
end

-- rdii.c:1276
F.updateDryPeriod = function(j, k, rainDepth, rainInterval)
  local G_UHGroup = G.UHGroup
  local i = 0
  if (rainDepth > 0.0) then
    if (G_UHGroup[j].uh[k].drySeconds >= (rainInterval * G_UHGroup[j].uh[k].maxPeriods)) then
      do
        i = 0
        while (i < G_UHGroup[j].uh[k].maxPeriods) do
          do
            G_UHGroup[j].uh[k].pastRain[i] = 0.0
          end
          i = i + 1
        end
      end
      G_UHGroup[j].uh[k].period = 0
    end
    G_UHGroup[j].uh[k].drySeconds = 0
    G_UHGroup[j].uh[k].hasPastRain = 1
  else
    G_UHGroup[j].uh[k].drySeconds = (G_UHGroup[j].uh[k].drySeconds + rainInterval)
    if (G_UHGroup[j].uh[k].drySeconds >= (rainInterval * G_UHGroup[j].uh[k].maxPeriods)) then
      G_UHGroup[j].uh[k].hasPastRain = 0
    else
      G_UHGroup[j].uh[k].hasPastRain = 1
    end
  end
end

-- rdii.c:1321
F.getUnitHydRdii = function(currentDate)
  local G_Nobjects, G_UHGroup = G.Nobjects, G.UHGroup
  local j = 0
  local k = 0
  local rainInterval = 0
  do
    j = 0
    while (j < G_Nobjects[UNITHYD]) do
      do
        if (not (G_UHGroup[j].isUsed ~= 0)) then
          goto continue1
        end
        if (currentDate < G_UHGroup[j].lastDate) then
          goto continue1
        end
        G_UHGroup[j].lastDate = G_UHGroup[j].gageDate
        rainInterval = G_UHGroup[j].rainInterval
        G_UHGroup[j].rdii = 0.0
        do
          k = 0
          while (k < 3) do
            do
              if (G_UHGroup[j].uh[k].hasPastRain ~= 0) then
                G_UHGroup[j].rdii = (G_UHGroup[j].rdii + (F.getUnitHydConvol(j, k, rainInterval)))
              end
            end
            k = k + 1
          end
        end
      end
      ::continue1::
      j = j + 1
    end
  end
end

-- rdii.c:1358
F.getUnitHydConvol = function(j, k, rainInterval)
  local G_UnitHyd = G.UnitHyd
  local i = 0
  local m = 0
  local p = 0
  local pMax = 0
  local t = 0.0
  local u = 0.0
  local v = 0.0
  local rdii = 0.0
  local uh = nil
  rdii = 0.0
  uh = G.UHGroup[j].uh[k]
  i = (uh.period - 1)
  if (i < 0) then
    i = (uh.maxPeriods - 1)
  end
  pMax = uh.maxPeriods
  p = 1
  while (p < pMax) do
    do
      v = uh.pastRain[i]
      m = uh.pastMonth.b[uh.pastMonth.o + i]
      if (v > 0.0) then
        t = (((((p) * 1.0) - 0.5)) * (rainInterval * 1.0))
        u = (F.getUnitHydOrd(j, m, k, t) * G_UnitHyd[j].r[m][k])
        rdii = (rdii + (u * v))
      end
      p = (p + 1)
      i = (i - 1)
      if (i < 0) then
        i = (uh.maxPeriods - 1)
      end
    end
  end
  do return rdii end
end

-- rdii.c:1411
F.getUnitHydOrd = function(h, m, k, t)
  local G_UnitHyd = G.UnitHyd
  local qPeak = 0.0
  local f = 0.0
  local t1 = 0.0
  local t2 = 0.0
  local tBase = 0.0
  tBase = (G_UnitHyd[h].tBase[m][k] * 1.0)
  if (t >= tBase) then
    do return 0.0 end
  end
  qPeak = ((2.0 / tBase) * 3600.0)
  t1 = (G_UnitHyd[h].tPeak[m][k] * 1.0)
  t2 = (tBase - t1)
  if (t <= t1) then
    f = (t / t1)
  else
    f = (1.0 - (((t - t1)) / t2))
  end
  do return ((((((f) >= (0.0))) and (f) or (0.0))) * qPeak) end
end

-- rdii.c:1446
F.getNodeRdii = function()
  local G_RdiiNodeIndex, G_Node, G_UHGroup, G_RdiiNodeFlow = G.RdiiNodeIndex, G.Node, G.UHGroup, G.RdiiNodeFlow
  local hasRdii = 0
  local i = 0
  local j = 0
  local n = 0
  local rdii = 0.0
  do
    n = 0
    while (n < G.NumRdiiNodes) do
      do
        j = G_RdiiNodeIndex[n]
        i = G_Node[j].rdiiInflow.unitHyd
        rdii = ((G_UHGroup[i].rdii * G_Node[j].rdiiInflow.area) / F.UCF(RAINFALL))
        if (rdii < G.ZERO_RDII) then
          rdii = 0.0
        else
          hasRdii = 1
        end
        G_RdiiNodeFlow[n] = R.f32(rdii)
        if (rdii > 0.0) then
          G.TotalRdiiVol = (G.TotalRdiiVol + (rdii * (G.RdiiStep * 1.0)))
        end
      end
      n = n + 1
    end
  end
  do return hasRdii end
end

-- rdii.c:1483
F.saveRdiiFlows = function(currentDate)
  currentDate = {currentDate}
  local G_Frdii = G.Frdii
  R.fwrite1("d", 8, currentDate[1], G_Frdii.file)
  R.fwrite_arr("f", G.RdiiNodeFlow, 0, G.NumRdiiNodes, G_Frdii.file)
end

-- rdii.c:1496
F.closeRdiiProcessor = function()
  local G_Frdii = G.Frdii
  if (not (G.ErrorCode ~= 0)) then
    F.report_writeRdiiStats(G.TotalRainVol, G.TotalRdiiVol)
  end
  F.freeRdiiMemory()
  if (G_Frdii.file ~= nil) then
    R.fclose(G_Frdii.file)
  end
end

-- rdii.c:1516
F.freeRdiiMemory = function()
  local G_Nobjects = G.Nobjects
  local i = 0
  local k = 0
  if (G.UHGroup ~= nil) then
    do
      i = 0
      while (i < G_Nobjects[UNITHYD]) do
        do
          do
            k = 0
            while (k < 3) do
              do
                do
                  if (G.UHGroup[i].uh[k].pastRain ~= nil) then
                    local _ = nil
                    G.UHGroup[i].uh[k].pastRain = (nil)
                  end
                end
                do
                  if (G.UHGroup[i].uh[k].pastMonth ~= nil) then
                    local _ = nil
                    G.UHGroup[i].uh[k].pastMonth = (nil)
                  end
                end
              end
              k = k + 1
            end
          end
        end
        i = i + 1
      end
    end
    do
      if (G.UHGroup ~= nil) then
        local _ = nil
        G.UHGroup = (nil)
      end
    end
  end
  do
    if (G.RdiiNodeIndex ~= nil) then
      local _ = nil
      G.RdiiNodeIndex = (nil)
    end
  end
  do
    if (G.RdiiNodeFlow ~= nil) then
      local _ = nil
      G.RdiiNodeFlow = (nil)
    end
  end
end

