-- Generated from EPA SWMM 5.2.4 (lid.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local ERR_MEMORY <const> = 101
local POLLUT <const> = 4
local ERR_ITEMS <const> = 203
local LID <const> = 15
local ERR_NAME <const> = 209
local SURF <const> = 0
local SOIL <const> = 1
local STOR <const> = 2
local PAVE <const> = 3
local DRAINMAT <const> = 4
local REMOVALS <const> = 6
local ERR_KEYWORD <const> = 205
local SUBCATCH <const> = 1
local ERR_NUMBER <const> = 211
local NODE <const> = 2
local LENGTH <const> = 3
local ERR_RPT_FILE <const> = 305
local RAINDEPTH <const> = 1
local RAINFALL <const> = 0
local CURVE <const> = 7
local GREEN_ROOF <const> = 2
local ERR_LID_TYPE <const> = 183
local BIO_CELL <const> = 0
local RAIN_GARDEN <const> = 1
local POROUS_PAVEMENT <const> = 4
local INFIL_TRENCH <const> = 3
local ERR_LID_LAYER <const> = 184
local ERR_LID_PARAMS <const> = 185
local VEG_SWALE <const> = 6
local ROOF_DISCON <const> = 7
local RAIN_BARREL <const> = 5
local GREEN_AMPT <const> = 2
local MOD_GREEN_AMPT <const> = 3
local ERR_LID_AREAS <const> = 187
local ERR_LID_CAPTURE_AREA <const> = 188
local PREVIOUS <const> = 0
local BMP_REMOVAL_LOAD <const> = 3
local RUNOFF_LOAD <const> = 5
local WET_WEATHER_INFLOW <const> = 2
local IMPERV0 <const> = 0
local IMPERV1 <const> = 1
local TO_PERV <const> = 2
local PERV <const> = 2
local TO_IMPERV <const> = 1
local RUNOFF_DRAINS <const> = 4
local US <const> = 0
local _ENV = R.strict

G.LidLayerWords = {[0] = S[991], S[992], S[742], S[993], S[994], S[995], S[996], (nil)}
G.LidTypeWords = {[0] = S[997], S[998], S[953], S[999], S[1000], S[1001], S[1002], S[1003], (nil)}
G.LidProcs = nil
G.LidCount = 0
G.LidGroups = nil
G.GroupCount = 0
G.lid_EvapRate = 0.0
G.NativeInfil = 0.0
G.lid_MaxNativeInfil = 0.0
G.initLidRptFile_colCount = 14
G.initLidRptFile_head1 = {[0] = S[1022], S[1023], S[1024], S[1024], S[1025], S[1026], S[1027], S[1028], S[1025], S[1029], S[1025], S[1026], S[1027], S[1030], nil}
G.initLidRptFile_head2 = {[0] = S[1022], S[1031], S[1032], S[1033], S[1034], S[1035], S[1035], S[1036], S[1037], S[1038], S[1039], S[1039], S[1040], S[1041], nil}
G.initLidRptFile_units1 = {[0] = S[1042], S[1043], S[1044], S[1044], S[1044], S[1044], S[1044], S[1044], S[1044], S[1044], S[1045], S[1045], S[1046], S[1047], nil}
G.initLidRptFile_units2 = {[0] = S[1042], S[1043], S[1048], S[1048], S[1048], S[1048], S[1048], S[1048], S[1048], S[1048], S[1049], S[1049], S[1046], S[1050], nil}
G.initLidRptFile_line9 = R.bufFrom(S[1051], 11)

-- lid.c:237
F.lid_create = function(lidCount, subcatchCount)
  local G_Nobjects = G.Nobjects
  local j = 0
  G.LidProcs = (nil)
  G.LidGroups = (nil)
  G.LidCount = lidCount
  G.GroupCount = subcatchCount
  if (G.GroupCount > 0) then
    G.LidGroups = {}
    if (G.LidGroups == (nil)) then
      G.ErrorCode = ERR_MEMORY
      do return end
    end
  end
  do
    j = 0
    while (j < G.GroupCount) do
      do
        G.LidGroups[j] = (nil)
      end
      j = j + 1
    end
  end
  if (G.LidCount == 0) then
    do return end
  end
  G.LidProcs = R.recs(G.LidCount, T.TLidProc)
  if (G.LidProcs == (nil)) then
    G.ErrorCode = ERR_MEMORY
    do return end
  end
  do
    j = 0
    while (j < G.LidCount) do
      do
        G.LidProcs[j].lidType = (-1)
        G.LidProcs[j].surface.thickness = 0.0
        G.LidProcs[j].surface.voidFrac = 1.0
        G.LidProcs[j].surface.roughness = 0.0
        G.LidProcs[j].surface.surfSlope = 0.0
        G.LidProcs[j].pavement.thickness = 0.0
        G.LidProcs[j].soil.thickness = 0.0
        G.LidProcs[j].storage.thickness = 0.0
        G.LidProcs[j].storage.kSat = 0.0
        G.LidProcs[j].drain.coeff = 0.0
        G.LidProcs[j].drain.offset = 0.0
        G.LidProcs[j].drainMat.thickness = 0.0
        G.LidProcs[j].drainMat.roughness = 0.0
        G.LidProcs[j].drainRmvl = (nil)
        G.LidProcs[j].drainRmvl = R.fill(G_Nobjects[POLLUT], 0.0)
        if (G.LidProcs[j].drainRmvl == (nil)) then
          G.ErrorCode = ERR_MEMORY
          do return end
        end
      end
      j = j + 1
    end
  end
end

-- lid.c:304
F.lid_delete = function()
  local j = 0
  do
    j = 0
    while (j < G.GroupCount) do
      do
        F.freeLidGroup(j)
      end
      j = j + 1
    end
  end
  do
    if (G.LidGroups ~= nil) then
      local _ = nil
      G.LidGroups = (nil)
    end
  end
  do
    j = 0
    while (j < G.LidCount) do
      do
        if (G.LidProcs[j].drainRmvl ~= nil) then
          local _ = nil
          G.LidProcs[j].drainRmvl = (nil)
        end
      end
      j = j + 1
    end
  end
  do
    if (G.LidProcs ~= nil) then
      local _ = nil
      G.LidProcs = (nil)
    end
  end
  G.GroupCount = 0
  G.LidCount = 0
end

-- lid.c:322
F.freeLidGroup = function(j)
  local G_LidGroups = G.LidGroups
  local lidGroup = G_LidGroups[j]
  local lidList = nil
  local lidUnit = nil
  local nextLidUnit = nil
  if (lidGroup == (nil)) then
    do return end
  end
  lidList = lidGroup.lidList
  while (lidList ~= nil) do
    do
      lidUnit = lidList.lidUnit
      if (lidUnit.rptFile ~= nil) then
        if (lidUnit.rptFile.file ~= nil) then
          R.fclose(lidUnit.rptFile.file)
        end
        local _ = nil
      end
      nextLidUnit = lidList.nextLidUnit
      local _ = nil
      local _ = nil
      lidList = nextLidUnit
    end
  end
  local _ = nil
  G_LidGroups[j] = (nil)
end

-- lid.c:355
F.lid_readProcParams = function(toks, ntoks)
  local G_LidProcs = G.LidProcs
  local j = 0
  local m = 0
  if (ntoks < 2) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  j = F.project_findObject(LID, toks[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, toks[0]) end
  end
  if R.peq(G_LidProcs[j].ID, (nil)) then
    G_LidProcs[j].ID = F.project_findID(LID, toks[0])
  end
  m = F.findmatch(toks[1], G.LidTypeWords)
  if (m >= 0) then
    G_LidProcs[j].lidType = m
    do return 0 end
  else
    m = F.findmatch(toks[1], G.LidLayerWords)
  end
  do
    local __sw1 = m
    if __sw1 < PAVE then
      if __sw1 == SURF then goto case2
      elseif __sw1 == SOIL then goto case3
      elseif __sw1 == STOR then goto case4
      end
    else
      if __sw1 < 5 then
        if __sw1 == PAVE then goto case5
        elseif __sw1 == DRAINMAT then goto case7
        end
      else
        if __sw1 == 5 then goto case6
        elseif __sw1 == REMOVALS then goto case8
        end
      end
    end
    goto swend1
    ::case2::
    do
      do return F.readSurfaceData(j, toks, ntoks) end
    end
    ::case3::
    do
      do return F.readSoilData(j, toks, ntoks) end
    end
    ::case4::
    do
      do return F.readStorageData(j, toks, ntoks) end
    end
    ::case5::
    do
      do return F.readPavementData(j, toks, ntoks) end
    end
    ::case6::
    do
      do return F.readDrainData(j, toks, ntoks) end
    end
    ::case7::
    do
      do return F.readDrainMatData(j, toks, ntoks) end
    end
    ::case8::
    do
      do return F.readRemovalsData(j, toks, ntoks) end
    end
    ::swend1::
  end
  do return F.error_setInpError(ERR_KEYWORD, toks[1]) end
end

-- lid.c:415
F.lid_readGroupParams = function(toks, ntoks)
  local i = 0
  local j = 0
  local k = 0
  local n = 0
  local x = R.fill(6, 0.0)
  local fname = (nil)
  local drainSubcatch = (-1)
  local drainNode = (-1)
  if (ntoks < 8) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  j = F.project_findObject(SUBCATCH, toks[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, toks[0]) end
  end
  k = F.project_findObject(LID, toks[1])
  if (k < 0) then
    do return F.error_setInpError(ERR_NAME, toks[1]) end
  end
  n = R.atoi(toks[2])
  if (n < 0) then
    do return F.error_setInpError(ERR_NUMBER, toks[2]) end
  end
  if (n == 0) then
    do return 0 end
  end
  do
    i = 3
    while (i <= 7) do
      do
        if ((not (F.getDouble(toks[i], x, (i - 3)) ~= 0)) or (x[(i - 3)] < 0.0)) then
          do return F.error_setInpError(ERR_NUMBER, toks[i]) end
        end
      end
      i = i + 1
    end
  end
  do
    i = 2
    while (i <= 3) do
      do
        if (x[i] > 100.0) then
          do return F.error_setInpError(ERR_NUMBER, toks[(i + 3)]) end
        end
      end
      i = i + 1
    end
  end
  if ((ntoks >= 9) and (R.strcmp(toks[8], S[275]) ~= 0)) then
    fname = toks[8]
  end
  if ((ntoks >= 10) and (R.strcmp(toks[9], S[275]) ~= 0)) then
    drainSubcatch = F.project_findObject(SUBCATCH, toks[9])
    if (drainSubcatch < 0) then
      drainNode = F.project_findObject(NODE, toks[9])
      if (drainNode < 0) then
        do return F.error_setInpError(ERR_NAME, toks[9]) end
      end
    end
  end
  x[5] = 0.0
  if (ntoks >= 11) then
    if (((not (F.getDouble(toks[10], x, 5) ~= 0)) or (x[5] < 0.0)) or (x[5] > 100.0)) then
      do return F.error_setInpError(ERR_NUMBER, toks[10]) end
    end
  end
  do return F.addLidUnit(j, k, n, x, fname, drainSubcatch, drainNode) end
end

-- lid.c:499
F.addLidUnit = function(j, k, n, x, fname, drainSubcatch, drainNode)
  local G_LidGroups = G.LidGroups
  local lidUnit = nil
  local lidList = nil
  local lidGroup = nil
  lidGroup = G_LidGroups[j]
  if (not (lidGroup ~= nil)) then
    lidGroup = T.LidGroup()
    if (not (lidGroup ~= nil)) then
      do return F.error_setInpError(ERR_MEMORY, S[0]) end
    end
    lidGroup.lidList = (nil)
    G_LidGroups[j] = lidGroup
  end
  lidUnit = T.TLidUnit()
  if (not (lidUnit ~= nil)) then
    do return F.error_setInpError(ERR_MEMORY, S[0]) end
  end
  lidUnit.rptFile = (nil)
  lidList = T.TLidList()
  if (not (lidList ~= nil)) then
    local _ = nil
    do return F.error_setInpError(ERR_MEMORY, S[0]) end
  end
  lidList.lidUnit = lidUnit
  lidList.nextLidUnit = lidGroup.lidList
  lidGroup.lidList = lidList
  lidUnit.lidIndex = k
  lidUnit.number = n
  lidUnit.area = (x[0] / (((F.UCF(LENGTH)) * (F.UCF(LENGTH)))))
  lidUnit.fullWidth = (x[1] / F.UCF(LENGTH))
  lidUnit.initSat = (x[2] / 100.0)
  lidUnit.fromImperv = (x[3] / 100.0)
  lidUnit.toPerv = (((x[4] > 0.0)) and 1 or 0)
  lidUnit.fromPerv = (x[5] / 100.0)
  lidUnit.drainSubcatch = drainSubcatch
  lidUnit.drainNode = drainNode
  if not R.peq(fname, (nil)) then
    if (not (F.createLidRptFile(lidUnit, fname) ~= 0)) then
      do return F.error_setInpError(ERR_RPT_FILE, fname) end
    end
  end
  do return 0 end
end

-- lid.c:567
F.createLidRptFile = function(lidUnit, fname)
  local rptFile = nil
  rptFile = T.TLidRptFile()
  if (rptFile == (nil)) then
    do return 0 end
  end
  lidUnit.rptFile = rptFile
  rptFile.file = R.fopen(fname, S[171])
  if (rptFile.file == (nil)) then
    do return 0 end
  end
  do return 1 end
end

-- lid.c:581
F.readSurfaceData = function(j, toks, ntoks)
  local G_LidProcs = G.LidProcs
  local i = 0
  local x = R.fill(5, 0.0)
  if (ntoks < 7) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  do
    i = 2
    while (i < 7) do
      do
        if ((not (F.getDouble(toks[i], x, (i - 2)) ~= 0)) or (x[(i - 2)] < 0.0)) then
          do return F.error_setInpError(ERR_NUMBER, toks[i]) end
        end
      end
      i = i + 1
    end
  end
  if (x[1] >= 1.0) then
    do return F.error_setInpError(ERR_NUMBER, toks[3]) end
  end
  if (x[0] == 0.0) then
    x[1] = 0.0
  end
  G_LidProcs[j].surface.thickness = (x[0] / F.UCF(RAINDEPTH))
  G_LidProcs[j].surface.voidFrac = (1.0 - x[1])
  G_LidProcs[j].surface.roughness = x[2]
  G_LidProcs[j].surface.surfSlope = (x[3] / 100.0)
  G_LidProcs[j].surface.sideSlope = x[4]
  do return 0 end
end

-- lid.c:616
F.readPavementData = function(j, toks, ntoks)
  local G_LidProcs = G.LidProcs
  local i = 0
  local x = R.fill(7, 0.0)
  if (ntoks < 7) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  do
    i = 2
    while (i < 7) do
      do
        if ((not (F.getDouble(toks[i], x, (i - 2)) ~= 0)) or (x[(i - 2)] < 0.0)) then
          do return F.error_setInpError(ERR_NUMBER, toks[i]) end
        end
      end
      i = i + 1
    end
  end
  x[5] = 0.0
  if (ntoks > 7) then
    if ((not (F.getDouble(toks[7], x, 5) ~= 0)) or (x[5] < 0.0)) then
      do return F.error_setInpError(ERR_NUMBER, toks[7]) end
    end
  end
  x[6] = 0.0
  if (ntoks > 8) then
    if (((not (F.getDouble(toks[8], x, 6) ~= 0)) or (x[6] < 0.0)) or (x[6] > 1.0)) then
      do return F.error_setInpError(ERR_NUMBER, toks[8]) end
    end
  end
  x[1] = (x[1] / ((x[1] + 1.0)))
  G_LidProcs[j].pavement.thickness = (x[0] / F.UCF(RAINDEPTH))
  G_LidProcs[j].pavement.voidFrac = x[1]
  G_LidProcs[j].pavement.impervFrac = x[2]
  G_LidProcs[j].pavement.kSat = (x[3] / F.UCF(RAINFALL))
  G_LidProcs[j].pavement.clogFactor = x[4]
  G_LidProcs[j].pavement.regenDays = x[5]
  G_LidProcs[j].pavement.regenDegree = x[6]
  do return 0 end
end

-- lid.c:669
F.readSoilData = function(j, toks, ntoks)
  local G_LidProcs = G.LidProcs
  local i = 0
  local x = R.fill(7, 0.0)
  if (ntoks < 9) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  do
    i = 2
    while (i < 9) do
      do
        if ((not (F.getDouble(toks[i], x, (i - 2)) ~= 0)) or (x[(i - 2)] < 0.0)) then
          do return F.error_setInpError(ERR_NUMBER, toks[i]) end
        end
      end
      i = i + 1
    end
  end
  G_LidProcs[j].soil.thickness = (x[0] / F.UCF(RAINDEPTH))
  G_LidProcs[j].soil.porosity = x[1]
  G_LidProcs[j].soil.fieldCap = x[2]
  G_LidProcs[j].soil.wiltPoint = x[3]
  G_LidProcs[j].soil.kSat = (x[4] / F.UCF(RAINFALL))
  G_LidProcs[j].soil.kSlope = x[5]
  G_LidProcs[j].soil.suction = (x[6] / F.UCF(RAINDEPTH))
  do return 0 end
end

-- lid.c:703
F.readStorageData = function(j, toks, ntoks)
  local G_LidProcs = G.LidProcs
  local i = 0
  local covered = 0
  local x = R.fill(6, 0.0)
  if (ntoks < 6) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  do
    i = 2
    while (i < 6) do
      do
        if ((not (F.getDouble(toks[i], x, (i - 2)) ~= 0)) or (x[(i - 2)] < 0.0)) then
          do return F.error_setInpError(ERR_NUMBER, toks[i]) end
        end
      end
      i = i + 1
    end
  end
  if (ntoks > 6) then
    if (F.match(toks[6], S[5]) ~= 0) then
      covered = 1
    end
  end
  x[1] = (x[1] / ((x[1] + 1.0)))
  G_LidProcs[j].storage.thickness = (x[0] / F.UCF(RAINDEPTH))
  G_LidProcs[j].storage.voidFrac = x[1]
  G_LidProcs[j].storage.kSat = (x[2] / F.UCF(RAINFALL))
  G_LidProcs[j].storage.clogFactor = x[3]
  G_LidProcs[j].storage.covered = covered
  do return 0 end
end

-- lid.c:749
F.readDrainData = function(j, toks, ntoks)
  local G_LidProcs = G.LidProcs
  local i = 0
  local x = R.fill(6, 0.0)
  if (ntoks < 6) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  do
    i = 0
    while (i < 6) do
      do
        x[i] = 0.0
      end
      i = i + 1
    end
  end
  do
    i = 2
    while (i < 8) do
      do
        if (((ntoks > i)) and (((not (F.getDouble(toks[i], x, (i - 2)) ~= 0)) or (x[(i - 2)] < 0.0)))) then
          do return F.error_setInpError(ERR_NUMBER, toks[i]) end
        end
      end
      i = i + 1
    end
  end
  i = (-1)
  if (ntoks >= 9) then
    i = F.project_findObject(CURVE, toks[8])
    if (i < 0) then
      do return F.error_setInpError(ERR_NAME, toks[8]) end
    end
  end
  G_LidProcs[j].drain.coeff = x[0]
  G_LidProcs[j].drain.expon = x[1]
  G_LidProcs[j].drain.offset = (x[2] / F.UCF(RAINDEPTH))
  G_LidProcs[j].drain.delay = (x[3] * 3600.0)
  G_LidProcs[j].drain.hOpen = (x[4] / F.UCF(RAINDEPTH))
  G_LidProcs[j].drain.hClose = (x[5] / F.UCF(RAINDEPTH))
  G_LidProcs[j].drain.qCurve = i
  do return 0 end
end

-- lid.c:794
F.readDrainMatData = function(j, toks, ntoks)
  local G_LidProcs = G.LidProcs
  local i = 0
  local x = R.fill(3, 0.0)
  if (ntoks < 5) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  if (G_LidProcs[j].lidType ~= GREEN_ROOF) then
    do return 0 end
  end
  do
    i = 2
    while (i < 5) do
      do
        if ((not (F.getDouble(toks[i], x, (i - 2)) ~= 0)) or (x[(i - 2)] < 0.0)) then
          do return F.error_setInpError(ERR_NUMBER, toks[i]) end
        end
      end
      i = i + 1
    end
  end
  G_LidProcs[j].drainMat.thickness = (x[0] / F.UCF(RAINDEPTH))
  G_LidProcs[j].drainMat.voidFrac = x[1]
  G_LidProcs[j].drainMat.roughness = x[2]
  do return 0 end
end

-- lid.c:828
F.readRemovalsData = function(j, toks, ntoks)
  local G_LidProcs = G.LidProcs
  local i = 2
  local p = 0
  local rmvl = {0.0}
  if (ntoks < 4) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  while (ntoks > i) do
    do
      p = F.project_findObject(POLLUT, toks[i])
      if (p < 0) then
        do return F.error_setInpError(ERR_NAME, toks[i]) end
      end
      i = i + 1
      if (ntoks == i) then
        do return F.error_setInpError(ERR_ITEMS, S[0]) end
      end
      if (((not (F.getDouble(toks[i], rmvl, 1) ~= 0)) or (rmvl[1] < 0.0)) or (rmvl[1] > 100.0)) then
        do return F.error_setInpError(ERR_NUMBER, toks[i]) end
      end
      G_LidProcs[j].drainRmvl[p] = (rmvl[1] / 100.0)
      i = i + 1
    end
  end
  do return 0 end
end

-- lid.c:869
F.lid_writeSummary = function()
  local G_Frpt, G_LidGroups, G_Subcatch, G_LidProcs = G.Frpt, G.LidGroups, G.Subcatch, G.LidProcs
  local j = 0
  local k = 0
  local pctArea = 0.0
  local lidUnit = nil
  local lidList = nil
  local lidGroup = nil
  R.fprintf(G_Frpt.file, S[276])
  R.fprintf(G_Frpt.file, S[276])
  R.fprintf(G_Frpt.file, S[277])
  R.fprintf(G_Frpt.file, S[278])
  R.fprintf(G_Frpt.file, S[277])
  R.fprintf(G_Frpt.file, S[279])
  R.fprintf(G_Frpt.file, S[280])
  R.fprintf(G_Frpt.file, S[281])
  do
    j = 0
    while (j < G.GroupCount) do
      do
        lidGroup = G_LidGroups[j]
        if (lidGroup == (nil)) then
          goto continue1
        end
        lidList = lidGroup.lidList
        while (lidList ~= nil) do
          do
            lidUnit = lidList.lidUnit
            k = lidUnit.lidIndex
            pctArea = (((lidUnit.area * (lidUnit.number * 1.0)) / G_Subcatch[j].area) * 100.0)
            R.fprintf(G_Frpt.file, S[282], G_Subcatch[j].ID, G_LidProcs[k].ID)
            R.fprintf(G_Frpt.file, S[283], lidUnit.number, (lidUnit.area * (((F.UCF(LENGTH)) * (F.UCF(LENGTH))))), (lidUnit.fullWidth * F.UCF(LENGTH)), pctArea, (lidUnit.fromImperv * 100.0), (lidUnit.fromPerv * 100.0))
            lidList = lidList.nextLidUnit
          end
        end
      end
      ::continue1::
      j = j + 1
    end
  end
end

-- lid.c:918
F.lid_validate = function()
  local j = 0
  do
    j = 0
    while (j < G.LidCount) do
      do
        F.validateLidProc(j)
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G.GroupCount) do
      do
        F.validateLidGroup(j)
      end
      j = j + 1
    end
  end
end

-- lid.c:932
F.validateLidProc = function(j)
  local G_LidProcs, G_Msg = G.LidProcs, G.Msg
  local layerMissing = 0
  if (G_LidProcs[j].lidType < 0) then
    F.report_writeErrorMsg(ERR_LID_TYPE, G_LidProcs[j].ID)
    do return end
  end
  do
    local __sw1 = G_LidProcs[j].lidType
    if __sw1 == BIO_CELL or __sw1 == RAIN_GARDEN then goto case2
    elseif __sw1 == GREEN_ROOF then goto case3
    elseif __sw1 == POROUS_PAVEMENT then goto case4
    elseif __sw1 == INFIL_TRENCH then goto case5
    else goto swend1 end
    ::case2::
    do
      if (G_LidProcs[j].soil.thickness <= 0.0) then
        layerMissing = 1
      end
      goto swend1
    end
    ::case3::
    do
      if (G_LidProcs[j].soil.thickness <= 0.0) then
        layerMissing = 1
      end
      if (G_LidProcs[j].drainMat.thickness <= 0.0) then
        layerMissing = 1
      end
      goto swend1
    end
    ::case4::
    do
      if (G_LidProcs[j].pavement.thickness <= 0.0) then
        layerMissing = 1
      end
      goto swend1
    end
    ::case5::
    do
      if (G_LidProcs[j].storage.thickness <= 0.0) then
        layerMissing = 1
      end
      goto swend1
    end
    ::swend1::
  end
  if (layerMissing ~= 0) then
    F.report_writeErrorMsg(ERR_LID_LAYER, G_LidProcs[j].ID)
    do return end
  end
  if (G_LidProcs[j].lidType == POROUS_PAVEMENT) then
    if (((((G_LidProcs[j].pavement.thickness <= 0.0) or (G_LidProcs[j].pavement.kSat <= 0.0)) or (G_LidProcs[j].pavement.voidFrac <= 0.0)) or (G_LidProcs[j].pavement.voidFrac > 1.0)) or (G_LidProcs[j].pavement.impervFrac > 1.0)) then
      F.sstrncpy(G_Msg, G_LidProcs[j].ID, 1024)
      F.sstrcat(G_Msg, S[284], 1024)
      F.report_writeErrorMsg(ERR_LID_PARAMS, G_Msg)
    end
  end
  if (G_LidProcs[j].soil.thickness > 0.0) then
    if (((((G_LidProcs[j].soil.porosity <= 0.0) or (G_LidProcs[j].soil.fieldCap >= G_LidProcs[j].soil.porosity)) or (G_LidProcs[j].soil.wiltPoint >= G_LidProcs[j].soil.fieldCap)) or (G_LidProcs[j].soil.kSat <= 0.0)) or (G_LidProcs[j].soil.kSlope < 0.0)) then
      F.sstrncpy(G_Msg, G_LidProcs[j].ID, 1024)
      F.sstrcat(G_Msg, S[285], 1024)
      F.report_writeErrorMsg(ERR_LID_PARAMS, G_Msg)
    end
  end
  if (G_LidProcs[j].storage.thickness > 0.0) then
    if ((G_LidProcs[j].storage.voidFrac <= 0.0) or (G_LidProcs[j].storage.voidFrac > 1.0)) then
      F.sstrncpy(G_Msg, G_LidProcs[j].ID, 1024)
      F.sstrcat(G_Msg, S[286], 1024)
      F.report_writeErrorMsg(ERR_LID_PARAMS, G_Msg)
    end
  else
    G_LidProcs[j].storage.voidFrac = 1.0
    G_LidProcs[j].drain.offset = 0.0
  end
  if ((G_LidProcs[j].drain.hOpen > 0.0) and (G_LidProcs[j].drain.hOpen <= G_LidProcs[j].drain.hClose)) then
    F.sstrncpy(G_Msg, G_LidProcs[j].ID, 1024)
    F.sstrcat(G_Msg, S[287], 1024)
    F.report_writeErrorMsg(ERR_LID_PARAMS, G_Msg)
  end
  if (G_LidProcs[j].lidType == VEG_SWALE) then
    if (((G_LidProcs[j].surface.roughness * G_LidProcs[j].surface.surfSlope) <= 0.0) or (G_LidProcs[j].surface.thickness == 0.0)) then
      F.sstrncpy(G_Msg, G_LidProcs[j].ID, 1024)
      F.sstrcat(G_Msg, S[288], 1024)
      F.report_writeErrorMsg(ERR_LID_PARAMS, G_Msg)
    else
      G_LidProcs[j].surface.alpha = ((1.49 * m_sqrt(G_LidProcs[j].surface.surfSlope)) / G_LidProcs[j].surface.roughness)
    end
  else
    if (G_LidProcs[j].surface.roughness > 0.0) then
      G_LidProcs[j].surface.alpha = ((1.49 / G_LidProcs[j].surface.roughness) * m_sqrt(G_LidProcs[j].surface.surfSlope))
    else
      G_LidProcs[j].surface.alpha = 0.0
    end
  end
  if (G_LidProcs[j].drainMat.roughness > 0.0) then
    G_LidProcs[j].drainMat.alpha = ((1.49 / G_LidProcs[j].drainMat.roughness) * m_sqrt(G_LidProcs[j].surface.surfSlope))
  else
    G_LidProcs[j].drainMat.alpha = 0.0
  end
  if (G_LidProcs[j].pavement.thickness > 0.0) then
    G_LidProcs[j].pavement.clogFactor = (G_LidProcs[j].pavement.clogFactor * ((G_LidProcs[j].pavement.thickness * G_LidProcs[j].pavement.voidFrac) * ((1.0 - G_LidProcs[j].pavement.impervFrac))))
  end
  if (G_LidProcs[j].storage.thickness > 0.0) then
    G_LidProcs[j].storage.clogFactor = (G_LidProcs[j].storage.clogFactor * (G_LidProcs[j].storage.thickness * G_LidProcs[j].storage.voidFrac))
  else
    G_LidProcs[j].storage.clogFactor = 0.0
  end
  G_LidProcs[j].surface.canOverflow = 1
  do
    local __sw2 = G_LidProcs[j].lidType
    if __sw2 < INFIL_TRENCH then
      if __sw2 == BIO_CELL then goto case8
      elseif __sw2 == RAIN_GARDEN then goto case8
      elseif __sw2 == GREEN_ROOF then goto case8
      end
    else
      if __sw2 == INFIL_TRENCH then goto case8
      elseif __sw2 == POROUS_PAVEMENT then goto case8
      elseif __sw2 == ROOF_DISCON then goto case7
      end
    end
    goto swend6
    ::case7::
    do
      G_LidProcs[j].surface.canOverflow = 0
      goto swend6
    end
    ::case8::
    do
      if (G_LidProcs[j].surface.alpha > 0.0) then
        G_LidProcs[j].surface.canOverflow = 0
      end
    end
    ::swend6::
  end
  if (G_LidProcs[j].lidType == RAIN_BARREL) then
    G_LidProcs[j].storage.voidFrac = 1.0
    G_LidProcs[j].storage.kSat = 0.0
  end
  if (G_LidProcs[j].lidType == GREEN_ROOF) then
    G_LidProcs[j].storage.thickness = G_LidProcs[j].drainMat.thickness
    G_LidProcs[j].storage.voidFrac = G_LidProcs[j].drainMat.voidFrac
    G_LidProcs[j].storage.clogFactor = 0.0
    G_LidProcs[j].storage.kSat = 0.0
  end
end

-- lid.c:1113
F.validateLidGroup = function(j)
  local G_Subcatch, G_LidProcs, G_Msg = G.Subcatch, G.LidProcs, G.Msg
  local k = 0
  local p = R.fill(3, 0.0)
  local totalArea = G_Subcatch[j].area
  local totalLidArea = 0.0
  local fromImperv = 0.0
  local fromPerv = 0.0
  local lidUnit = nil
  local lidList = nil
  local lidGroup = nil
  lidGroup = G.LidGroups[j]
  if (lidGroup == (nil)) then
    do return end
  end
  lidList = lidGroup.lidList
  while (lidList ~= nil) do
    do
      lidUnit = lidList.lidUnit
      k = lidUnit.lidIndex
      totalLidArea = (totalLidArea + ((lidUnit.area * (lidUnit.number * 1.0))))
      fromImperv = (fromImperv + lidUnit.fromImperv)
      fromPerv = (fromPerv + lidUnit.fromPerv)
      lidUnit.soilInfil.Ks = 0.0
      if (G_LidProcs[k].soil.thickness > 0.0) then
        p[0] = (G_LidProcs[k].soil.suction * F.UCF(RAINDEPTH))
        p[1] = (G_LidProcs[k].soil.kSat * F.UCF(RAINFALL))
        p[2] = (((G_LidProcs[k].soil.porosity - G_LidProcs[k].soil.wiltPoint)) * ((1.0 - lidUnit.initSat)))
        if (F.grnampt_setParams(lidUnit.soilInfil, p) == 0) then
          F.sstrncpy(G_Msg, G_LidProcs[k].ID, 1024)
          F.sstrcat(G_Msg, S[285], 1024)
          F.report_writeErrorMsg(ERR_LID_PARAMS, G_Msg)
        end
      end
      if (G_LidProcs[k].lidType == VEG_SWALE) then
        if ((G_Subcatch[j].infilModel == GREEN_AMPT) or (G_Subcatch[j].infilModel == MOD_GREEN_AMPT)) then
          F.grnampt_getParams(j, p)
          if (F.grnampt_setParams(lidUnit.soilInfil, p) == 0) then
            F.sstrncpy(G_Msg, G_LidProcs[k].ID, 1024)
            F.sstrcat(G_Msg, S[289], 1024)
            F.report_writeErrorMsg(ERR_LID_PARAMS, G_Msg)
          end
        end
        if (lidUnit.fullWidth <= 0.0) then
          F.sstrncpy(G_Msg, G_LidProcs[k].ID, 1024)
          F.sstrcat(G_Msg, S[290], 1024)
          F.report_writeErrorMsg(ERR_LID_PARAMS, G_Msg)
        end
      end
      if (G_Subcatch[j].fracImperv >= 0.999) then
        lidUnit.toPerv = 0
      end
      if ((lidUnit.drainNode == (-1)) and (lidUnit.drainSubcatch == (-1))) then
        lidUnit.drainNode = G_Subcatch[j].outNode
        lidUnit.drainSubcatch = G_Subcatch[j].outSubcatch
      end
      lidList = lidList.nextLidUnit
    end
  end
  if (totalLidArea > (1.001 * totalArea)) then
    F.report_writeErrorMsg(ERR_LID_AREAS, G_Subcatch[j].ID)
  end
  if ((fromImperv > 1.001) or (fromPerv > 1.001)) then
    F.report_writeErrorMsg(ERR_LID_CAPTURE_AREA, G_Subcatch[j].ID)
  end
  if (totalLidArea > (0.999 * totalArea)) then
    totalLidArea = totalArea
  end
  G_Subcatch[j].lidArea = totalLidArea
end

-- lid.c:1211
F.lid_initState = function()
  local G_LidGroups, G_LidProcs, G_Title, G_Subcatch = G.LidGroups, G.LidProcs, G.Title, G.Subcatch
  local i = 0
  local j = 0
  local k = 0
  local lidUnit = nil
  local lidList = nil
  local lidGroup = nil
  local initVol = 0.0
  local initDryTime = (G.StartDryDays * 86400.0)
  G.HasWetLids = 0
  do
    j = 0
    while (j < G.GroupCount) do
      do
        lidGroup = G_LidGroups[j]
        if (lidGroup == (nil)) then
          goto continue1
        end
        lidGroup.pervArea = 0.0
        lidGroup.flowToPerv = 0.0
        lidGroup.oldDrainFlow = 0.0
        lidGroup.newDrainFlow = 0.0
        lidList = lidGroup.lidList
        while (lidList ~= nil) do
          do
            lidUnit = lidList.lidUnit
            k = lidUnit.lidIndex
            lidUnit.surfaceDepth = 0.0
            lidUnit.storageDepth = 0.0
            lidUnit.soilMoisture = 0.0
            lidUnit.paveDepth = 0.0
            lidUnit.dryTime = initDryTime
            lidUnit.volTreated = 0.0
            lidUnit.nextRegenDay = G_LidProcs[k].pavement.regenDays
            initVol = 0.0
            if (G_LidProcs[k].soil.thickness > 0.0) then
              lidUnit.soilMoisture = (G_LidProcs[k].soil.wiltPoint + (lidUnit.initSat * ((G_LidProcs[k].soil.porosity - G_LidProcs[k].soil.wiltPoint))))
              initVol = (initVol + (lidUnit.soilMoisture * G_LidProcs[k].soil.thickness))
            end
            if (G_LidProcs[k].storage.thickness > 0.0) then
              lidUnit.storageDepth = (lidUnit.initSat * G_LidProcs[k].storage.thickness)
              initVol = (initVol + (lidUnit.storageDepth * G_LidProcs[k].storage.voidFrac))
            end
            if (lidUnit.initSat > 0.0) then
              G.HasWetLids = 1
            end
            F.lidproc_initWaterBalance(lidUnit, initVol)
            lidUnit.volTreated = 0.0
            if (lidUnit.rptFile ~= nil) then
              F.initLidRptFile(G_Title[0], G_LidProcs[k].ID, G_Subcatch[j].ID, lidUnit)
            end
            lidUnit.oldDrainFlow = 0.0
            lidUnit.newDrainFlow = 0.0
            do
              i = 0
              while (i < 4) do
                do
                  lidUnit.oldFluxRates[i] = 0.0
                end
                i = i + 1
              end
            end
            if (lidUnit.soilInfil.Ks > 0.0) then
              F.grnampt_initState(lidUnit.soilInfil)
            end
            if (F.isLidPervious(lidUnit.lidIndex) ~= 0) then
              lidGroup.pervArea = (lidGroup.pervArea + ((lidUnit.area * (lidUnit.number * 1.0))))
            end
            lidList = lidList.nextLidUnit
          end
        end
      end
      ::continue1::
      j = j + 1
    end
  end
end

-- lid.c:1302
F.lid_setOldGroupState = function(j)
  local G_LidGroups = G.LidGroups
  local lidList = nil
  if (G_LidGroups[j] ~= (nil)) then
    G_LidGroups[j].oldDrainFlow = G_LidGroups[j].newDrainFlow
    G_LidGroups[j].newDrainFlow = 0.0
    lidList = G_LidGroups[j].lidList
    while (lidList ~= nil) do
      do
        lidList.lidUnit.oldDrainFlow = lidList.lidUnit.newDrainFlow
        lidList.lidUnit.newDrainFlow = 0.0
        lidList = lidList.nextLidUnit
      end
    end
  end
end

-- lid.c:1326
F.isLidPervious = function(k)
  local G_LidProcs = G.LidProcs
  do return ((((G_LidProcs[k].storage.thickness == 0.0) or (G_LidProcs[k].storage.kSat > 0.0))) and 1 or 0) end
end

-- lid.c:1339
F.getSurfaceDepth = function(j)
  local G_Subcatch, G_LidProcs = G.Subcatch, G.LidProcs
  local k = 0
  local depth = 0.0
  local lidUnit = nil
  local lidList = nil
  local lidGroup = nil
  lidGroup = G.LidGroups[j]
  if (lidGroup == (nil)) then
    do return 0.0 end
  end
  if (G_Subcatch[j].lidArea == 0.0) then
    do return 0.0 end
  end
  lidList = lidGroup.lidList
  while (lidList ~= nil) do
    do
      lidUnit = lidList.lidUnit
      k = lidUnit.lidIndex
      depth = (depth + (((lidUnit.surfaceDepth * G_LidProcs[k].surface.voidFrac) * lidUnit.area) * (lidUnit.number * 1.0)))
      lidList = lidList.nextLidUnit
    end
  end
  do return (depth / G_Subcatch[j].lidArea) end
end

-- lid.c:1370
F.lid_getPervArea = function(j)
  local G_LidGroups = G.LidGroups
  if (G_LidGroups[j] ~= nil) then
    do return G_LidGroups[j].pervArea end
  else
    do return 0.0 end
  end
end

-- lid.c:1383
F.lid_getFlowToPerv = function(j)
  local G_LidGroups = G.LidGroups
  if (G_LidGroups[j] ~= (nil)) then
    do return G_LidGroups[j].flowToPerv end
  end
  do return 0.0 end
end

-- lid.c:1397
F.lid_getStoredVolume = function(j)
  local total = 0.0
  local lidUnit = nil
  local lidList = nil
  local lidGroup = nil
  lidGroup = G.LidGroups[j]
  if ((lidGroup == (nil)) or (G.Subcatch[j].lidArea == 0.0)) then
    do return 0.0 end
  end
  lidList = lidGroup.lidList
  while (lidList ~= nil) do
    do
      lidUnit = lidList.lidUnit
      total = (total + ((lidUnit.waterBalance.finalVol * lidUnit.area) * (lidUnit.number * 1.0)))
      lidList = lidList.nextLidUnit
    end
  end
  do return total end
end

-- lid.c:1424
F.lid_getDrainFlow = function(j, timePeriod)
  local G_LidGroups = G.LidGroups
  if (G_LidGroups[j] ~= (nil)) then
    if (timePeriod == PREVIOUS) then
      do return G_LidGroups[j].oldDrainFlow end
    else
      do return G_LidGroups[j].newDrainFlow end
    end
  end
  do return 0.0 end
end

-- lid.c:1442
F.lid_addDrainLoads = function(j, c, tStep)
  local G_Nobjects, G_Pollut, G_LidProcs = G.Nobjects, G.Pollut, G.LidProcs
  local isRunoffLoad = 0
  local p = 0
  local r = 0.0
  local w = 0.0
  local lidUnit = nil
  local lidList = nil
  local lidGroup = nil
  lidGroup = G.LidGroups[j]
  if (lidGroup ~= (nil)) then
    lidList = lidGroup.lidList
    while (lidList ~= nil) do
      do
        lidUnit = lidList.lidUnit
        isRunoffLoad = ((((lidUnit.drainNode >= 0) or (lidUnit.drainSubcatch == j))) and 1 or 0)
        if (not (lidUnit.toPerv ~= 0)) then
          do
            p = 0
            while (p < G_Nobjects[POLLUT]) do
              do
                w = ((((lidUnit.newDrainFlow * c[p]) * tStep) * 28.317) * G_Pollut[p].mcf)
                r = G_LidProcs[lidUnit.lidIndex].drainRmvl[p]
                F.massbal_updateLoadingTotals(BMP_REMOVAL_LOAD, p, (r * w))
                if (isRunoffLoad ~= 0) then
                  F.massbal_updateLoadingTotals(RUNOFF_LOAD, p, (w * ((1.0 - r))))
                end
              end
              p = p + 1
            end
          end
        end
        lidList = lidList.nextLidUnit
      end
    end
  end
end

-- lid.c:1497
F.lid_addDrainRunon = function(j)
  local G_Nobjects, G_Subcatch, G_LidProcs = G.Nobjects, G.Subcatch, G.LidProcs
  local i = 0
  local k = 0
  local p = 0
  local q = 0.0
  local w = 0.0
  local lidUnit = nil
  local lidList = nil
  local lidGroup = nil
  lidGroup = G.LidGroups[j]
  if (lidGroup ~= (nil)) then
    lidList = lidGroup.lidList
    while (lidList ~= nil) do
      do
        lidUnit = lidList.lidUnit
        i = lidUnit.lidIndex
        k = lidUnit.drainSubcatch
        if ((k >= 0) and (k ~= j)) then
          q = lidUnit.oldDrainFlow
          F.subcatch_addRunonFlow(k, q)
          do
            p = 0
            while (p < G_Nobjects[POLLUT]) do
              do
                w = ((q * G_Subcatch[j].oldQual[p]) * 28.317)
                w = (w * ((1.0 - G_LidProcs[i].drainRmvl[p])))
                G_Subcatch[k].newQual[p] = (G_Subcatch[k].newQual[p] + w)
              end
              p = p + 1
            end
          end
        end
        lidList = lidList.nextLidUnit
      end
    end
  end
end

-- lid.c:1549
F.lid_addDrainInflow = function(j, f)
  local G_Node, G_Nobjects, G_Subcatch, G_LidProcs = G.Node, G.Nobjects, G.Subcatch, G.LidProcs
  local i = 0
  local k = 0
  local p = 0
  local q = 0.0
  local w = 0.0
  local w1 = 0.0
  local w2 = 0.0
  local lidUnit = nil
  local lidList = nil
  local lidGroup = nil
  lidGroup = G.LidGroups[j]
  if (lidGroup ~= (nil)) then
    lidList = lidGroup.lidList
    while (lidList ~= nil) do
      do
        lidUnit = lidList.lidUnit
        i = lidUnit.lidIndex
        k = lidUnit.drainNode
        if (k >= 0) then
          q = ((((1.0 - f)) * lidUnit.oldDrainFlow) + (f * lidUnit.newDrainFlow))
          G_Node[k].newLatFlow = (G_Node[k].newLatFlow + q)
          F.massbal_addInflowFlow(WET_WEATHER_INFLOW, q)
          do
            p = 0
            while (p < G_Nobjects[POLLUT]) do
              do
                w1 = (lidUnit.oldDrainFlow * G_Subcatch[j].oldQual[p])
                w2 = (lidUnit.newDrainFlow * G_Subcatch[j].newQual[p])
                w = ((((1.0 - f)) * w1) + (f * w2))
                w = (w * ((1.0 - G_LidProcs[i].drainRmvl[p])))
                G_Node[k].newQual[p] = (G_Node[k].newQual[p] + w)
                F.massbal_addInflowQual(WET_WEATHER_INFLOW, p, w)
              end
              p = p + 1
            end
          end
        end
        lidList = lidList.nextLidUnit
      end
    end
  end
end

-- lid.c:1609
F.lid_getRunoff = function(j, tStep)
  local G_Evap, G_Subcatch = G.Evap, G.Subcatch
  local theLidGroup = nil
  local lidList = nil
  local lidUnit = nil
  local lidArea = 0.0
  local qImperv = 0.0
  local qPerv = 0.0
  local lidInflow = 0.0
  local qRunoff = {0.0}
  local qDrain = {0.0}
  local qReturn = {0.0}
  theLidGroup = G.LidGroups[j]
  if (not (theLidGroup ~= nil)) then
    do return end
  end
  lidList = theLidGroup.lidList
  if (not (lidList ~= nil)) then
    do return end
  end
  G.lid_EvapRate = G_Evap.rate
  if ((G_Evap.dryOnly ~= 0) and (G_Subcatch[j].rainfall > 0.0)) then
    G.lid_EvapRate = 0.0
  end
  F.findNativeInfil(j, tStep)
  if (G_Subcatch[j].area > G_Subcatch[j].lidArea) then
    qImperv = F.getImpervAreaRunoff(j)
    qPerv = F.getPervAreaRunoff(j)
  end
  while (lidList ~= nil) do
    do
      lidUnit = lidList.lidUnit
      lidArea = (lidUnit.area * (lidUnit.number * 1.0))
      if (lidArea > 0.0) then
        lidInflow = ((((qImperv * lidUnit.fromImperv) + (qPerv * lidUnit.fromPerv))) / lidArea)
        G.VlidIn = (G.VlidIn + ((lidInflow * lidArea) * tStep))
        lidInflow = (lidInflow + F.getRainInflow(j, lidUnit))
        if (G_Subcatch[j].area == G_Subcatch[j].lidArea) then
          lidInflow = (lidInflow + G_Subcatch[j].runon)
        end
        F.evalLidUnit(j, lidUnit, lidArea, lidInflow, tStep, qRunoff, 1, qDrain, 1, qReturn, 1)
      end
      lidList = lidList.nextLidUnit
    end
  end
  theLidGroup.newDrainFlow = qDrain[1]
  theLidGroup.flowToPerv = qReturn[1]
  G.VlidOut = (qRunoff[1] * tStep)
  G.VlidDrain = (qDrain[1] * tStep)
  G.VlidReturn = (qReturn[1] * tStep)
end

-- lid.c:1697
F.findNativeInfil = function(j, tStep)
  local G_Subcatch = G.Subcatch
  local nonLidArea = 0.0
  nonLidArea = (G_Subcatch[j].area - G_Subcatch[j].lidArea)
  if ((nonLidArea > 0.0) and (G_Subcatch[j].fracImperv < 1.0)) then
    G.NativeInfil = ((G.Vinfil / nonLidArea) / tStep)
  else
    G.NativeInfil = F.infil_getInfil(j, tStep, G_Subcatch[j].rainfall, G_Subcatch[j].runon, F.getSurfaceDepth(j))
  end
  if ((not (G.IgnoreGwater ~= 0)) and (G_Subcatch[j].groundwater ~= nil)) then
    G.lid_MaxNativeInfil = (G_Subcatch[j].groundwater.maxInfilVol / tStep)
  else
    G.lid_MaxNativeInfil = 10000000000.0
  end
end

-- lid.c:1734
F.getRainInflow = function(j, lidUnit)
  local lidProc = G.LidProcs[lidUnit.lidIndex]
  if ((lidProc.lidType == RAIN_BARREL) and (lidProc.storage.covered == 1)) then
    do return 0.0 end
  end
  do return G.Subcatch[j].rainfall end
end

-- lid.c:1751
F.getImpervAreaRunoff = function(j)
  local G_Subcatch = G.Subcatch
  local i = 0
  local q = 0.0
  local nonLidArea = 0.0
  do
    i = IMPERV0
    while (i <= IMPERV1) do
      do
        q = (q + (G_Subcatch[j].subArea[i].runoff * G_Subcatch[j].subArea[i].fArea))
      end
      i = i + 1
    end
  end
  if ((G_Subcatch[j].subArea[IMPERV0].routeTo == TO_PERV) and (G_Subcatch[j].fracImperv < 1.0)) then
    q = (q * G_Subcatch[j].subArea[IMPERV0].fOutlet)
  end
  nonLidArea = (G_Subcatch[j].area - G_Subcatch[j].lidArea)
  do return (q * nonLidArea) end
end

-- lid.c:1781
F.getPervAreaRunoff = function(j)
  local G_Subcatch = G.Subcatch
  local q = 0.0
  local nonLidArea = 0.0
  q = (G_Subcatch[j].subArea[PERV].runoff * G_Subcatch[j].subArea[PERV].fArea)
  if ((G_Subcatch[j].subArea[PERV].routeTo == TO_IMPERV) and (G_Subcatch[j].fracImperv > 0.0)) then
    q = (q * G_Subcatch[j].subArea[PERV].fOutlet)
  end
  nonLidArea = (G_Subcatch[j].area - G_Subcatch[j].lidArea)
  do return (q * nonLidArea) end
end

-- lid.c:1807
F.evalLidUnit = function(j, lidUnit, lidArea, lidInflow, tStep, qRunoff, qRunoff__k, qDrain, qDrain__k, qReturn, qReturn__k)
  local G_Subcatch = G.Subcatch
  local lidProc = nil
  local lidRunoff = 0.0
  local lidEvap = {0.0}
  local lidInfil = {0.0}
  local lidDrain = {0.0}
  lidProc = G.LidProcs[lidUnit.lidIndex]
  lidEvap[1] = 0.0
  lidInfil[1] = 0.0
  lidRunoff = (F.lidproc_getOutflow(lidUnit, lidProc, lidInflow, G.lid_EvapRate, G.NativeInfil, G.lid_MaxNativeInfil, tStep, lidEvap, 1, lidInfil, 1, lidDrain, 1) * lidArea)
  lidDrain[1] = (lidDrain[1] * lidArea)
  if ((lidUnit.toPerv ~= 0) and (G_Subcatch[j].area > G_Subcatch[j].lidArea)) then
    qReturn[qReturn__k] = (qReturn[qReturn__k] + lidRunoff)
    lidRunoff = 0.0
    if ((lidUnit.drainNode == G_Subcatch[j].outNode) and (lidUnit.drainSubcatch == G_Subcatch[j].outSubcatch)) then
      qReturn[qReturn__k] = (qReturn[qReturn__k] + lidDrain[1])
      lidDrain[1] = 0.0
    end
  end
  if (lidUnit.drainNode >= 0) then
    F.massbal_updateRunoffTotals(RUNOFF_DRAINS, (lidDrain[1] * tStep))
  end
  lidUnit.newDrainFlow = lidDrain[1]
  G.Vevap = (G.Vevap + ((lidEvap[1] * tStep) * lidArea))
  G.VlidInfil = (G.VlidInfil + ((lidInfil[1] * tStep) * lidArea))
  if (F.isLidPervious(lidUnit.lidIndex) ~= 0) then
    G.Vpevap = (G.Vpevap + ((lidEvap[1] * tStep) * lidArea))
  end
  if (G_Subcatch[j].rainfall > 2.31481e-08) then
    lidUnit.dryTime = 0.0
  else
    lidUnit.dryTime = (lidUnit.dryTime + tStep)
  end
  F.lidproc_saveResults(lidUnit, F.UCF(RAINFALL), F.UCF(RAINDEPTH))
  qRunoff[qRunoff__k] = (qRunoff[qRunoff__k] + lidRunoff)
  qDrain[qDrain__k] = (qDrain[qDrain__k] + lidDrain[1])
end

-- lid.c:1890
F.lid_writeWaterBalance = function()
  local G_LidGroups, G_Frpt, G_Subcatch, G_LidProcs = G.LidGroups, G.Frpt, G.Subcatch, G.LidProcs
  local j = 0
  local k = 0
  local ucf = F.UCF(RAINDEPTH)
  local inflow = 0.0
  local outflow = 0.0
  local err = 0.0
  local lidUnit = nil
  local lidList = nil
  local lidGroup = nil
  do
    j = 0
    while (j < G.GroupCount) do
      do
        if (G_LidGroups[j] ~= nil) then
          k = k + 1
        end
      end
      j = j + 1
    end
  end
  if (k == 0) then
    do return end
  end
  R.fprintf(G_Frpt.file, S[291])
  R.fprintf(G_Frpt.file, S[292])
  if (G.UnitSystem == US) then
    R.fprintf(G_Frpt.file, S[293])
  else
    R.fprintf(G_Frpt.file, S[294])
  end
  R.fprintf(G_Frpt.file, S[295])
  do
    j = 0
    while (j < G.GroupCount) do
      do
        lidGroup = G_LidGroups[j]
        if ((not (lidGroup ~= nil)) or (G_Subcatch[j].lidArea == 0.0)) then
          goto continue2
        end
        lidList = lidGroup.lidList
        while (lidList ~= nil) do
          do
            lidUnit = lidList.lidUnit
            k = lidUnit.lidIndex
            R.fprintf(G_Frpt.file, S[296], G_Subcatch[j].ID, G_LidProcs[k].ID)
            R.fprintf(G_Frpt.file, S[297], (lidUnit.waterBalance.inflow * ucf), (lidUnit.waterBalance.evap * ucf), (lidUnit.waterBalance.infil * ucf), (lidUnit.waterBalance.surfFlow * ucf), (lidUnit.waterBalance.drainFlow * ucf), (lidUnit.waterBalance.initVol * ucf), (lidUnit.waterBalance.finalVol * ucf))
            inflow = (lidUnit.waterBalance.initVol + lidUnit.waterBalance.inflow)
            outflow = ((((lidUnit.waterBalance.finalVol + lidUnit.waterBalance.evap) + lidUnit.waterBalance.infil) + lidUnit.waterBalance.surfFlow) + lidUnit.waterBalance.drainFlow)
            if (inflow > 0.0) then
              err = (((inflow - outflow)) / inflow)
            else
              err = 1.0
            end
            R.fprintf(G_Frpt.file, S[298], (err * 100.0))
            lidList = lidList.nextLidUnit
          end
        end
      end
      ::continue2::
      j = j + 1
    end
  end
end

-- lid.c:1972
F.initLidRptFile = function(title, lidID, subcatchID, lidUnit)
  local i = 0
  local f = lidUnit.rptFile.file
  if (f == (nil)) then
    do return end
  end
  R.fprintf(f, S[299])
  R.fprintf(f, S[300], title)
  R.fprintf(f, S[301], lidID, subcatchID)
  do
    i = 0
    while (i < G.initLidRptFile_colCount) do
      do
        R.fprintf(f, S[169], G.initLidRptFile_head1[i])
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G.initLidRptFile_colCount) do
      do
        R.fprintf(f, S[169], G.initLidRptFile_head2[i])
      end
      i = i + 1
    end
  end
  if (G.UnitSystem == US) then
    do
      i = 0
      while (i < G.initLidRptFile_colCount) do
        do
          R.fprintf(f, S[169], G.initLidRptFile_units1[i])
        end
        i = i + 1
      end
    end
  else
    do
      i = 0
      while (i < G.initLidRptFile_colCount) do
        do
          R.fprintf(f, S[169], G.initLidRptFile_units2[i])
        end
        i = i + 1
      end
    end
  end
  R.fprintf(f, S[302])
  do
    i = 1
    while (i < G.initLidRptFile_colCount) do
      do
        R.fprintf(f, S[303], G.initLidRptFile_line9)
      end
      i = i + 1
    end
  end
  lidUnit.rptFile.wasDry = 1
  F.sstrncpy(lidUnit.rptFile.results, S[0], 0)
end

