-- Generated from EPA SWMM 5.2.4 (iface.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local ERR_ITEMS <const> = 203
local ERR_KEYWORD <const> = 205
local RAINFALL_FILE <const> = 0
local RUNOFF_FILE <const> = 1
local HOTSTART_FILE <const> = 2
local RDII_FILE <const> = 3
local INFLOWS_FILE <const> = 4
local OUTFLOWS_FILE <const> = 5
local USE_FILE <const> = 2
local SAVE_FILE <const> = 3
local NO_FILE <const> = 0
local ERR_ROUTING_FILE_NAMES <const> = 357
local NODE <const> = 2
local FLOW <const> = 10
local POLLUT <const> = 4
local ERR_ROUTING_FILE_OPEN <const> = 351
local ERR_ROUTING_FILE_FORMAT <const> = 353
local ERR_MEMORY <const> = 101
local ERR_ROUTING_FILE_NOMATCH <const> = 355
local DW <const> = 4
local OUTFALL <const> = 1
local _ENV = R.strict

G.IfaceFlowUnits = 0
G.IfaceStep = 0
G.NumIfacePolluts = 0
G.IfacePolluts = nil
G.NumIfaceNodes = 0
G.IfaceNodes = nil
G.OldIfaceValues = nil
G.NewIfaceValues = nil
G.IfaceFrac = 0.0
G.OldIfaceDate = 0.0
G.NewIfaceDate = 0.0

-- iface.c:66
F.iface_readFileParams = function(tok, ntoks)
  local G_Frain, G_Frunoff, G_Fhotstart1, G_Fhotstart2, G_Frdii, G_Finflows = G.Frain, G.Frunoff, G.Fhotstart1, G.Fhotstart2, G.Frdii, G.Finflows
  local G_Foutflows = G.Foutflows
  local k = 0
  local j = 0
  local fname = R.buf(260)
  if (ntoks < 2) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  k = R.i8(F.findmatch(tok[0], G.FileModeWords))
  if (k < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[0]) end
  end
  j = F.findmatch(tok[1], G.FileTypeWords)
  if (j < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
  end
  if (ntoks < 3) then
    do return 0 end
  end
  F.sstrncpy(fname, tok[2], 259)
  do
    local __sw1 = j
    if __sw1 < RDII_FILE then
      if __sw1 == RAINFALL_FILE then goto case2
      elseif __sw1 == RUNOFF_FILE then goto case3
      elseif __sw1 == HOTSTART_FILE then goto case4
      end
    else
      if __sw1 == RDII_FILE then goto case5
      elseif __sw1 == INFLOWS_FILE then goto case6
      elseif __sw1 == OUTFLOWS_FILE then goto case7
      end
    end
    goto swend1
    ::case2::
    do
      G_Frain.mode = k
      F.sstrncpy(G_Frain.name, F.addAbsolutePath(fname), 259)
      goto swend1
    end
    ::case3::
    do
      G_Frunoff.mode = k
      F.sstrncpy(G_Frunoff.name, F.addAbsolutePath(fname), 259)
      goto swend1
    end
    ::case4::
    do
      if (k == USE_FILE) then
        G_Fhotstart1.mode = k
        F.sstrncpy(G_Fhotstart1.name, F.addAbsolutePath(fname), 259)
      elseif (k == SAVE_FILE) then
        G_Fhotstart2.mode = k
        F.sstrncpy(G_Fhotstart2.name, F.addAbsolutePath(fname), 259)
      end
      goto swend1
    end
    ::case5::
    do
      G_Frdii.mode = k
      F.sstrncpy(G_Frdii.name, fname, 259)
      goto swend1
    end
    ::case6::
    do
      if (k ~= USE_FILE) then
        do return F.error_setInpError(ERR_ITEMS, S[0]) end
      end
      G_Finflows.mode = k
      F.sstrncpy(G_Finflows.name, F.addAbsolutePath(fname), 259)
      goto swend1
    end
    ::case7::
    do
      if (k ~= SAVE_FILE) then
        do return F.error_setInpError(ERR_ITEMS, S[0]) end
      end
      G_Foutflows.mode = k
      F.sstrncpy(G_Foutflows.name, F.addAbsolutePath(fname), 259)
      goto swend1
    end
    ::swend1::
  end
  do return 0 end
end

-- iface.c:138
F.iface_openRoutingFiles = function()
  local G_Foutflows, G_Finflows = G.Foutflows, G.Finflows
  G.NumIfacePolluts = 0
  G.IfacePolluts = (nil)
  G.NumIfaceNodes = 0
  G.IfaceNodes = (nil)
  G.OldIfaceValues = (nil)
  G.NewIfaceValues = (nil)
  if ((G_Foutflows.mode ~= NO_FILE) and (G_Finflows.mode ~= NO_FILE)) then
    if (F.strcomp(G_Foutflows.name, G_Finflows.name) ~= 0) then
      F.report_writeErrorMsg(ERR_ROUTING_FILE_NAMES, S[0])
      do return end
    end
  end
  if (G_Foutflows.mode == SAVE_FILE) then
    F.openFileForOutput()
  end
  if (G_Finflows.mode == USE_FILE) then
    F.openFileForInput()
  end
end

-- iface.c:170
F.iface_closeRoutingFiles = function()
  local G_OldIfaceValues, G_NewIfaceValues, G_Finflows, G_Foutflows = G.OldIfaceValues, G.NewIfaceValues, G.Finflows, G.Foutflows
  do
    if (G.IfacePolluts ~= nil) then
      local _ = nil
      G.IfacePolluts = (nil)
    end
  end
  do
    if (G.IfaceNodes ~= nil) then
      local _ = nil
      G.IfaceNodes = (nil)
    end
  end
  if (G_OldIfaceValues ~= (nil)) then
    F.project_freeMatrix(G_OldIfaceValues)
  end
  if (G_NewIfaceValues ~= (nil)) then
    F.project_freeMatrix(G_NewIfaceValues)
  end
  if (G_Finflows.file ~= nil) then
    R.fclose(G_Finflows.file)
  end
  if (G_Foutflows.file ~= nil) then
    R.fclose(G_Foutflows.file)
  end
end

-- iface.c:187
F.iface_getNumIfaceNodes = function(currentDate)
  if (G.OldIfaceDate > currentDate) then
    do return 0 end
  end
  while ((G.NewIfaceDate < currentDate) and (G.NewIfaceDate ~= ((-693594) * 1.0))) do
    do
      F.setOldIfaceValues()
      F.readNewIfaceValues()
    end
  end
  if (G.NewIfaceDate == ((-693594) * 1.0)) then
    do return 0 end
  end
  G.IfaceFrac = (((currentDate - G.OldIfaceDate)) / ((G.NewIfaceDate - G.OldIfaceDate)))
  G.IfaceFrac = (((((0.0) >= (G.IfaceFrac))) and (0.0) or (G.IfaceFrac)))
  G.IfaceFrac = (((((G.IfaceFrac) <= (1.0))) and (G.IfaceFrac) or (1.0)))
  do return G.NumIfaceNodes end
end

-- iface.c:219
F.iface_getIfaceNode = function(index)
  if ((index >= 0) and (index < G.NumIfaceNodes)) then
    do return G.IfaceNodes[index] end
  else
    do return (-1) end
  end
end

-- iface.c:232
F.iface_getIfaceFlow = function(index)
  local q1 = 0.0
  local q2 = 0.0
  if ((index >= 0) and (index < G.NumIfaceNodes)) then
    q1 = G.OldIfaceValues[index][0]
    q2 = G.NewIfaceValues[index][0]
    do return ((((1.0 - G.IfaceFrac)) * q1) + (G.IfaceFrac * q2)) end
  else
    do return 0.0 end
  end
end

-- iface.c:253
F.iface_getIfaceQual = function(index, pollut)
  local j = 0
  local c1 = 0.0
  local c2 = 0.0
  if ((index >= 0) and (index < G.NumIfaceNodes)) then
    j = G.IfacePolluts[pollut]
    if (j < 0) then
      do return 0.0 end
    end
    c1 = G.OldIfaceValues[index][(j + 1)]
    c2 = G.NewIfaceValues[index][(j + 1)]
    do return ((((1.0 - G.IfaceFrac)) * c1) + (G.IfaceFrac * c2)) end
  else
    do return 0.0 end
  end
end

-- iface.c:281
F.iface_saveOutletResults = function(reportDate, file)
  local G_Nobjects, G_Node = G.Nobjects, G.Node
  local i = 0
  local p = 0
  local yr = {0}
  local mon = {0}
  local day = {0}
  local hr = {0}
  local min = {0}
  local sec = {0}
  local theDate = R.buf(26)
  F.datetime_decodeDate(reportDate, yr, 1, mon, 1, day, 1)
  F.datetime_decodeTime(reportDate, hr, 1, min, 1, sec, 1)
  R.snprintf(theDate, 26, S[167], yr[1], mon[1], day[1], hr[1], min[1], sec[1])
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        if (not (F.isOutletNode(i) ~= 0)) then
          goto continue1
        end
        R.fprintf(file, S[168], G_Node[i].ID)
        R.fprintf(file, S[169], theDate)
        R.fprintf(file, S[170], (G_Node[i].inflow * F.UCF(FLOW)))
        do
          p = 0
          while (p < G_Nobjects[POLLUT]) do
            do
              R.fprintf(file, S[170], G_Node[i].newQual[p])
            end
            p = p + 1
          end
        end
      end
      ::continue1::
      i = i + 1
    end
  end
end

-- iface.c:313
F.openFileForOutput = function()
  local G_Foutflows, G_Nobjects, G_Pollut, G_QualUnitsWords, G_Node = G.Foutflows, G.Nobjects, G.Pollut, G.QualUnitsWords, G.Node
  local i = 0
  local n = 0
  G_Foutflows.file = R.fopen(G_Foutflows.name, S[171])
  if (G_Foutflows.file == (nil)) then
    F.report_writeErrorMsg(ERR_ROUTING_FILE_OPEN, G_Foutflows.name)
    do return end
  end
  R.fprintf(G_Foutflows.file, S[172])
  R.fprintf(G_Foutflows.file, S[173], G.Title[0])
  R.fprintf(G_Foutflows.file, S[174], G.ReportStep)
  R.fprintf(G_Foutflows.file, S[175], (G_Nobjects[POLLUT] + 1))
  R.fprintf(G_Foutflows.file, S[176], G.FlowUnitWords[G.FlowUnits])
  do
    i = 0
    while (i < G_Nobjects[POLLUT]) do
      do
        R.fprintf(G_Foutflows.file, S[177], G_Pollut[i].ID, G_QualUnitsWords[G_Pollut[i].units])
      end
      i = i + 1
    end
  end
  n = 0
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        if (F.isOutletNode(i) ~= 0) then
          n = n + 1
        end
      end
      i = i + 1
    end
  end
  R.fprintf(G_Foutflows.file, S[178], n)
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        if (F.isOutletNode(i) ~= 0) then
          R.fprintf(G_Foutflows.file, S[173], G_Node[i].ID)
        end
      end
      i = i + 1
    end
  end
  R.fprintf(G_Foutflows.file, S[179])
  do
    i = 0
    while (i < G_Nobjects[POLLUT]) do
      do
        R.fprintf(G_Foutflows.file, S[180], G_Pollut[i].ID)
      end
      i = i + 1
    end
  end
  if (G.ReportStart == G.StartDateTime) then
    F.iface_saveOutletResults(G.ReportStart, G_Foutflows.file)
  end
end

-- iface.c:377
F.openFileForInput = function()
  local G_Finflows = G.Finflows
  local err = 0
  local line = R.buf(1025)
  local s = R.buf(1025)
  G_Finflows.file = R.fopen(G_Finflows.name, S[13])
  if (G_Finflows.file == (nil)) then
    F.report_writeErrorMsg(ERR_ROUTING_FILE_OPEN, G_Finflows.name)
    do return end
  end
  R.fgets(line, 1024, G_Finflows.file)
  if ((not (R.sscanf(line, S[169], s) ~= 0)) or (not (F.strcomp(s, S[181]) ~= 0))) then
    F.report_writeErrorMsg(ERR_ROUTING_FILE_FORMAT, G_Finflows.name)
    do return end
  end
  R.fgets(line, 1024, G_Finflows.file)
  G.IfaceStep = 0
  R.fgets(line, 1024, G_Finflows.file)
  if ((not (R.sscanf(line, S[182], G, "IfaceStep") ~= 0)) or (G.IfaceStep <= 0)) then
    F.report_writeErrorMsg(ERR_ROUTING_FILE_FORMAT, G_Finflows.name)
    do return end
  end
  err = F.getIfaceFilePolluts()
  if (err > 0) then
    F.report_writeErrorMsg(err, G_Finflows.name)
    do return end
  end
  err = F.getIfaceFileNodes()
  if (err > 0) then
    F.report_writeErrorMsg(err, G_Finflows.name)
    do return end
  end
  G.OldIfaceValues = F.project_createMatrix(G.NumIfaceNodes, (1 + G.NumIfacePolluts))
  G.NewIfaceValues = F.project_createMatrix(G.NumIfaceNodes, (1 + G.NumIfacePolluts))
  if ((G.OldIfaceValues == (nil)) or (G.NewIfaceValues == (nil))) then
    F.report_writeErrorMsg(ERR_MEMORY, S[0])
    do return end
  end
  F.readNewIfaceValues()
  G.OldIfaceDate = G.NewIfaceDate
end

-- iface.c:450
F.getIfaceFilePolluts = function()
  local G_Finflows, G_Nobjects, G_QualUnitsWords, G_Pollut = G.Finflows, G.Nobjects, G.QualUnitsWords, G.Pollut
  local i = 0
  local j = 0
  local line = R.buf(1025)
  local s1 = R.buf(1025)
  local s2 = R.buf(1025)
  R.fgets(line, 1024, G_Finflows.file)
  G.NumIfacePolluts = (-1)
  if (R.sscanf(line, S[182], G, "NumIfacePolluts") ~= 0) then
    G.NumIfacePolluts = G.NumIfacePolluts - 1
  end
  if (G.NumIfacePolluts < 0) then
    do return ERR_ROUTING_FILE_FORMAT end
  end
  R.fgets(line, 1024, G_Finflows.file)
  if (R.sscanf(line, S[44], s1, s2) < 2) then
    do return ERR_ROUTING_FILE_FORMAT end
  end
  if (not (F.strcomp(s1, S[183]) ~= 0)) then
    do return ERR_ROUTING_FILE_FORMAT end
  end
  G.IfaceFlowUnits = F.findmatch(s2, G.FlowUnitWords)
  if (G.IfaceFlowUnits < 0) then
    do return ERR_ROUTING_FILE_FORMAT end
  end
  if (G_Nobjects[POLLUT] > 0) then
    G.IfacePolluts = R.fill(G_Nobjects[POLLUT], 0)
    if (not (G.IfacePolluts ~= nil)) then
      do return ERR_MEMORY end
    end
    do
      i = 0
      while (i < G_Nobjects[POLLUT]) do
        do
          G.IfacePolluts[i] = (-1)
        end
        i = i + 1
      end
    end
  end
  if ((G.NumIfacePolluts > 0) and (G_Nobjects[POLLUT] > 0)) then
    do
      i = 0
      while (i < G.NumIfacePolluts) do
        do
          if (R.feof(G_Finflows.file) ~= 0) then
            do return ERR_ROUTING_FILE_FORMAT end
          end
          R.fgets(line, 1024, G_Finflows.file)
          if (R.sscanf(line, S[44], s1, s2) < 2) then
            do return ERR_ROUTING_FILE_FORMAT end
          end
          j = F.project_findObject(POLLUT, s1)
          if (j < 0) then
            goto continue2
          end
          if (not (F.strcomp(s2, G_QualUnitsWords[G_Pollut[j].units]) ~= 0)) then
            do return ERR_ROUTING_FILE_NOMATCH end
          end
          G.IfacePolluts[j] = i
        end
        ::continue2::
        i = i + 1
      end
    end
  end
  do return 0 end
end

-- iface.c:510
F.getIfaceFileNodes = function()
  local G_Finflows = G.Finflows
  local i = 0
  local line = R.buf(1025)
  local s = R.buf(1025)
  R.fgets(line, 1024, G_Finflows.file)
  if ((not (R.sscanf(line, S[182], G, "NumIfaceNodes") ~= 0)) or (G.NumIfaceNodes <= 0)) then
    do return ERR_ROUTING_FILE_FORMAT end
  end
  G.IfaceNodes = R.fill(G.NumIfaceNodes, 0)
  if (not (G.IfaceNodes ~= nil)) then
    do return ERR_MEMORY end
  end
  do
    i = 0
    while (i < G.NumIfaceNodes) do
      do
        if (R.feof(G_Finflows.file) ~= 0) then
          do return ERR_ROUTING_FILE_FORMAT end
        end
        G.IfaceNodes[i] = 0
        R.fgets(line, 1024, G_Finflows.file)
        if (not (R.sscanf(line, S[169], s) ~= 0)) then
          do return ERR_ROUTING_FILE_FORMAT end
        end
        G.IfaceNodes[i] = F.project_findObject(NODE, s)
      end
      i = i + 1
    end
  end
  if (R.feof(G_Finflows.file) ~= 0) then
    do return ERR_ROUTING_FILE_FORMAT end
  end
  R.fgets(line, 1024, G_Finflows.file)
  do return 0 end
end

-- iface.c:550
F.readNewIfaceValues = function()
  local G_Finflows, G_Qcf, G_NewIfaceValues = G.Finflows, G.Qcf, G.NewIfaceValues
  local i = 0
  local j = 0
  local s = nil
  local yr = 0
  local mon = 0
  local day = 0
  local hr = 0
  local min = 0
  local sec = 0
  local line = R.buf(1025)
  G.NewIfaceDate = ((-693594) * 1.0)
  do
    i = 0
    while (i < G.NumIfaceNodes) do
      do
        if (R.feof(G_Finflows.file) ~= 0) then
          do return end
        end
        R.fgets(line, 1024, G_Finflows.file)
        if R.peq(R.strtok(line, S[184]), (nil)) then
          do return end
        end
        s = R.strtok((nil), S[184])
        if R.peq(s, (nil)) then
          do return end
        end
        yr = R.atoi(s)
        s = R.strtok((nil), S[184])
        if R.peq(s, (nil)) then
          do return end
        end
        mon = R.atoi(s)
        s = R.strtok((nil), S[184])
        if R.peq(s, (nil)) then
          do return end
        end
        day = R.atoi(s)
        s = R.strtok((nil), S[184])
        if R.peq(s, (nil)) then
          do return end
        end
        hr = R.atoi(s)
        s = R.strtok((nil), S[184])
        if R.peq(s, (nil)) then
          do return end
        end
        min = R.atoi(s)
        s = R.strtok((nil), S[184])
        if R.peq(s, (nil)) then
          do return end
        end
        sec = R.atoi(s)
        s = R.strtok((nil), S[184])
        if R.peq(s, (nil)) then
          do return end
        end
        G_NewIfaceValues[i][0] = (R.atof(s) / G_Qcf[G.IfaceFlowUnits])
        do
          j = 1
          while (j <= G.NumIfacePolluts) do
            do
              s = R.strtok((nil), S[184])
              if R.peq(s, (nil)) then
                do return end
              end
              G_NewIfaceValues[i][j] = R.atof(s)
            end
            j = j + 1
          end
        end
      end
      i = i + 1
    end
  end
  G.NewIfaceDate = (F.datetime_encodeDate(yr, mon, day) + F.datetime_encodeTime(hr, min, sec))
end

-- iface.c:613
F.setOldIfaceValues = function()
  local G_NewIfaceValues, G_OldIfaceValues = G.NewIfaceValues, G.OldIfaceValues
  local i = 0
  local j = 0
  G.OldIfaceDate = G.NewIfaceDate
  do
    i = 0
    while (i < G.NumIfaceNodes) do
      do
        do
          j = 0
          while (j < (G.NumIfacePolluts + 1)) do
            do
              G_OldIfaceValues[i][j] = G_NewIfaceValues[i][j]
            end
            j = j + 1
          end
        end
      end
      i = i + 1
    end
  end
end

-- iface.c:633
F.isOutletNode = function(i)
  local G_Node = G.Node
  if (G.RouteModel == DW) then
    do return (((G_Node[i].type_ == OUTFALL)) and 1 or 0) end
  else
    do return (((G_Node[i].degree == 0)) and 1 or 0) end
  end
end

