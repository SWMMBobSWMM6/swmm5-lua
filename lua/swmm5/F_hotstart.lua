-- Generated from EPA SWMM 5.2.4 (hotstart.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local USE_FILE <const> = 2
local ERR_HOTSTART_FILE_OPEN <const> = 331
local ERR_HOTSTART_FILE_FORMAT <const> = 333
local SUBCATCH <const> = 1
local LANDUSE <const> = 5
local NODE <const> = 2
local LINK <const> = 3
local POLLUT <const> = 4
local SAVE_FILE <const> = 3
local STORAGE <const> = 2
local ERR_HOTSTART_FILE_READ <const> = 335
local _ENV = R.strict

G.fileVersion = 0

-- hotstart.c:72
F.hotstart_open = function()
  if (not (F.openHotstartFile1() ~= 0)) then
    do return 0 end
  end
  if (not (F.openHotstartFile2() ~= 0)) then
    do return 0 end
  end
  do return 1 end
end

-- hotstart.c:82
F.hotstart_close = function()
  local G_Fhotstart2 = G.Fhotstart2
  if (G_Fhotstart2.file ~= nil) then
    F.saveRunoff()
    F.saveRouting()
    R.fclose(G_Fhotstart2.file)
  end
end

-- hotstart.c:94
F.openHotstartFile1 = function()
  local G_Fhotstart1, G_Nobjects = G.Fhotstart1, G.Nobjects
  local nSubcatch = {0}
  local nNodes = {0}
  local nLinks = {0}
  local nPollut = {0}
  local nLandUses = {0}
  local flowUnits = {0}
  local fStamp = R.bufFrom(S[160], 15)
  local fileStamp = R.bufFrom(S[160], 15)
  local fStampx = R.bufFrom(S[161], 16)
  local fileStamp2 = R.bufFrom(S[162], 16)
  local fileStamp3 = R.bufFrom(S[163], 16)
  local fileStamp4 = R.bufFrom(S[164], 16)
  if (G_Fhotstart1.mode ~= USE_FILE) then
    do return 1 end
  end
  G_Fhotstart1.file = R.fopen(G_Fhotstart1.name, S[165])
  if ((G_Fhotstart1.file) == (nil)) then
    F.report_writeErrorMsg(ERR_HOTSTART_FILE_OPEN, G_Fhotstart1.name)
    do return 0 end
  end
  R.fread_arr("c", fStampx, 0, R.strlen(fileStamp2), G_Fhotstart1.file)
  if (R.strcmp(fStampx, fileStamp4) == 0) then
    G.fileVersion = 4
  elseif (R.strcmp(fStampx, fileStamp3) == 0) then
    G.fileVersion = 3
  elseif (R.strcmp(fStampx, fileStamp2) == 0) then
    G.fileVersion = 2
  else
    R.rewind(G_Fhotstart1.file)
    R.fread_arr("c", fStamp, 0, R.strlen(fileStamp), G_Fhotstart1.file)
    if (R.strcmp(fStamp, fileStamp) ~= 0) then
      F.report_writeErrorMsg(ERR_HOTSTART_FILE_FORMAT, S[0])
      do return 0 end
    end
    G.fileVersion = 1
  end
  nSubcatch[1] = (-1)
  nNodes[1] = (-1)
  nLinks[1] = (-1)
  nPollut[1] = (-1)
  nLandUses[1] = (-1)
  flowUnits[1] = (-1)
  if (G.fileVersion >= 2) then
    R.fread1("i", 4, nSubcatch, 1, G_Fhotstart1.file)
  else
    nSubcatch[1] = G_Nobjects[SUBCATCH]
  end
  if (G.fileVersion >= 3) then
    R.fread1("i", 4, nLandUses, 1, G_Fhotstart1.file)
  else
    nLandUses[1] = G_Nobjects[LANDUSE]
  end
  R.fread1("i", 4, nNodes, 1, G_Fhotstart1.file)
  R.fread1("i", 4, nLinks, 1, G_Fhotstart1.file)
  R.fread1("i", 4, nPollut, 1, G_Fhotstart1.file)
  R.fread1("i", 4, flowUnits, 1, G_Fhotstart1.file)
  if ((((((nSubcatch[1] ~= G_Nobjects[SUBCATCH]) or (nLandUses[1] ~= G_Nobjects[LANDUSE])) or (nNodes[1] ~= G_Nobjects[NODE])) or (nLinks[1] ~= G_Nobjects[LINK])) or (nPollut[1] ~= G_Nobjects[POLLUT])) or (flowUnits[1] ~= G.FlowUnits)) then
    F.report_writeErrorMsg(ERR_HOTSTART_FILE_FORMAT, S[0])
    do return 0 end
  end
  if (G.fileVersion >= 3) then
    F.readRunoff()
  end
  F.readRouting()
  R.fclose(G_Fhotstart1.file)
  if (G.ErrorCode ~= 0) then
    do return 0 end
  else
    do return 1 end
  end
end

-- hotstart.c:180
F.openHotstartFile2 = function()
  local G_Fhotstart2, G_Nobjects = G.Fhotstart2, G.Nobjects
  local nSubcatch = {0}
  local nLandUses = {0}
  local nNodes = {0}
  local nLinks = {0}
  local nPollut = {0}
  local flowUnits = {0}
  local fileStamp = R.bufFrom(S[164], 16)
  if (G_Fhotstart2.mode ~= SAVE_FILE) then
    do return 1 end
  end
  G_Fhotstart2.file = R.fopen(G_Fhotstart2.name, S[166])
  if ((G_Fhotstart2.file) == (nil)) then
    F.report_writeErrorMsg(ERR_HOTSTART_FILE_OPEN, G_Fhotstart2.name)
    do return 0 end
  end
  nSubcatch[1] = G_Nobjects[SUBCATCH]
  nLandUses[1] = G_Nobjects[LANDUSE]
  nNodes[1] = G_Nobjects[NODE]
  nLinks[1] = G_Nobjects[LINK]
  nPollut[1] = G_Nobjects[POLLUT]
  flowUnits[1] = G.FlowUnits
  R.fwrite_arr("c", fileStamp, 0, R.strlen(fileStamp), G_Fhotstart2.file)
  R.fwrite1("i", 4, nSubcatch[1], G_Fhotstart2.file)
  R.fwrite1("i", 4, nLandUses[1], G_Fhotstart2.file)
  R.fwrite1("i", 4, nNodes[1], G_Fhotstart2.file)
  R.fwrite1("i", 4, nLinks[1], G_Fhotstart2.file)
  R.fwrite1("i", 4, nPollut[1], G_Fhotstart2.file)
  R.fwrite1("i", 4, flowUnits[1], G_Fhotstart2.file)
  do return 1 end
end

-- hotstart.c:222
F.saveRouting = function()
  local G_Nobjects, G_Node, G_Fhotstart2, G_Storage, G_Link = G.Nobjects, G.Node, G.Fhotstart2, G.Storage, G.Link
  local i = 0
  local j = 0
  local x = R.fill(3, 0.0)
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        x[0] = R.f32(G_Node[i].newDepth)
        x[1] = R.f32(G_Node[i].newLatFlow)
        R.fwrite_arr("f", x, 0, 2, G_Fhotstart2.file)
        if (G_Node[i].type_ == STORAGE) then
          j = G_Node[i].subIndex
          x[0] = R.f32(G_Storage[j].hrt)
          R.fwrite_arr("f", x, 0, 1, G_Fhotstart2.file)
        end
        do
          j = 0
          while (j < G_Nobjects[POLLUT]) do
            do
              x[0] = R.f32(G_Node[i].newQual[j])
              R.fwrite_arr("f", x, 0, 1, G_Fhotstart2.file)
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
    while (i < G_Nobjects[LINK]) do
      do
        x[0] = R.f32(G_Link[i].newFlow)
        x[1] = R.f32(G_Link[i].newDepth)
        x[2] = R.f32(G_Link[i].setting)
        R.fwrite_arr("f", x, 0, 3, G_Fhotstart2.file)
        do
          j = 0
          while (j < G_Nobjects[POLLUT]) do
            do
              x[0] = R.f32(G_Link[i].newQual[j])
              R.fwrite_arr("f", x, 0, 1, G_Fhotstart2.file)
            end
            j = j + 1
          end
        end
      end
      i = i + 1
    end
  end
end

-- hotstart.c:267
F.readRouting = function()
  local G_Nobjects, G_Subcatch, G_Node, G_Storage, G_Link = G.Nobjects, G.Subcatch, G.Node, G.Storage, G.Link
  local i = 0
  local j = 0
  local x = {0.0}
  local xgw = R.fill(4, 0.0)
  local f = G.Fhotstart1.file
  if (G.fileVersion == 2) then
    xgw[2] = 0.0
    xgw[3] = (-10000000000.0)
    do
      i = 0
      while (i < G_Nobjects[SUBCATCH]) do
        do
          if (not (F.readFloat(x, 1, f) ~= 0)) then
            do return end
          end
          xgw[0] = x[1]
          if (not (F.readFloat(x, 1, f) ~= 0)) then
            do return end
          end
          xgw[1] = x[1]
          if (G_Subcatch[i].groundwater ~= (nil)) then
            F.gwater_setState(i, xgw)
          end
        end
        i = i + 1
      end
    end
  end
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        if (not (F.readFloat(x, 1, f) ~= 0)) then
          do return end
        end
        G_Node[i].newDepth = x[1]
        if (not (F.readFloat(x, 1, f) ~= 0)) then
          do return end
        end
        G_Node[i].newLatFlow = x[1]
        if ((G.fileVersion >= 4) and (G_Node[i].type_ == STORAGE)) then
          if (not (F.readFloat(x, 1, f) ~= 0)) then
            do return end
          end
          j = G_Node[i].subIndex
          G_Storage[j].hrt = x[1]
        end
        do
          j = 0
          while (j < G_Nobjects[POLLUT]) do
            do
              if (not (F.readFloat(x, 1, f) ~= 0)) then
                do return end
              end
              G_Node[i].newQual[j] = x[1]
            end
            j = j + 1
          end
        end
        if (G.fileVersion <= 2) then
          do
            j = 0
            while (j < G_Nobjects[POLLUT]) do
              do
                if (not (F.readFloat(x, 1, f) ~= 0)) then
                  do return end
                end
              end
              j = j + 1
            end
          end
        end
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        if (not (F.readFloat(x, 1, f) ~= 0)) then
          do return end
        end
        G_Link[i].newFlow = x[1]
        if (not (F.readFloat(x, 1, f) ~= 0)) then
          do return end
        end
        G_Link[i].newDepth = x[1]
        if (not (F.readFloat(x, 1, f) ~= 0)) then
          do return end
        end
        G_Link[i].setting = x[1]
        G_Link[i].targetSetting = x[1]
        F.link_setTargetSetting(i)
        F.link_setSetting(i, 0.0)
        do
          j = 0
          while (j < G_Nobjects[POLLUT]) do
            do
              if (not (F.readFloat(x, 1, f) ~= 0)) then
                do return end
              end
              G_Link[i].newQual[j] = x[1]
            end
            j = j + 1
          end
        end
      end
      i = i + 1
    end
  end
end

-- hotstart.c:356
F.saveRunoff = function()
  local G_Nobjects, G_Subcatch = G.Nobjects, G.Subcatch
  local i = 0
  local j = 0
  local k = 0
  local x = R.fill(6, 0.0)
  local f = G.Fhotstart2.file
  do
    i = 0
    while (i < G_Nobjects[SUBCATCH]) do
      do
        do
          j = 0
          while (j < 3) do
            do
              x[j] = G_Subcatch[i].subArea[j].depth
            end
            j = j + 1
          end
        end
        x[3] = G_Subcatch[i].newRunoff
        R.fwrite_arr("d", x, 0, 4, f)
        do
          j = 0
          while (j < 6) do
            do
              x[j] = 0.0
            end
            j = j + 1
          end
        end
        F.infil_getState(i, x)
        R.fwrite_arr("d", x, 0, 6, f)
        if (G_Subcatch[i].groundwater ~= (nil)) then
          F.gwater_getState(i, x)
          R.fwrite_arr("d", x, 0, 4, f)
        end
        if (G_Subcatch[i].snowpack ~= (nil)) then
          do
            j = 0
            while (j < 3) do
              do
                F.snow_getState(i, j, x)
                R.fwrite_arr("d", x, 0, 5, f)
              end
              j = j + 1
            end
          end
        end
        if (G_Nobjects[POLLUT] > 0) then
          do
            j = 0
            while (j < G_Nobjects[POLLUT]) do
              do
                x[0] = G_Subcatch[i].newQual[j]
                R.fwrite_arr("d", x, 0, 1, f)
              end
              j = j + 1
            end
          end
          do
            j = 0
            while (j < G_Nobjects[POLLUT]) do
              do
                x[0] = G_Subcatch[i].pondedQual[j]
                R.fwrite_arr("d", x, 0, 1, f)
              end
              j = j + 1
            end
          end
          do
            k = 0
            while (k < G_Nobjects[LANDUSE]) do
              do
                do
                  j = 0
                  while (j < G_Nobjects[POLLUT]) do
                    do
                      x[0] = G_Subcatch[i].landFactor[k].buildup[j]
                      R.fwrite_arr("d", x, 0, G_Nobjects[POLLUT], f)
                    end
                    j = j + 1
                  end
                end
                x[0] = G_Subcatch[i].landFactor[k].lastSwept
                R.fwrite_arr("d", x, 0, 1, f)
              end
              k = k + 1
            end
          end
        end
      end
      i = i + 1
    end
  end
end

-- hotstart.c:430
F.readRunoff = function()
  local G_Nobjects, G_Subcatch = G.Nobjects, G.Subcatch
  local i = 0
  local j = 0
  local k = 0
  local x = R.fill(6, 0.0)
  local f = G.Fhotstart1.file
  do
    i = 0
    while (i < G_Nobjects[SUBCATCH]) do
      do
        do
          j = 0
          while (j < 3) do
            do
              if (not (F.readDouble(G_Subcatch[i].subArea[j], "depth", f) ~= 0)) then
                do return end
              end
            end
            j = j + 1
          end
        end
        if (not (F.readDouble(G_Subcatch[i], "newRunoff", f) ~= 0)) then
          do return end
        end
        do
          j = 0
          while (j < 6) do
            do
              if (not (F.readDouble(x, j, f) ~= 0)) then
                do return end
              end
            end
            j = j + 1
          end
        end
        F.infil_setState(i, x)
        if (G_Subcatch[i].groundwater ~= (nil)) then
          do
            j = 0
            while (j < 4) do
              do
                if (not (F.readDouble(x, j, f) ~= 0)) then
                  do return end
                end
              end
              j = j + 1
            end
          end
          F.gwater_setState(i, x)
        end
        if (G_Subcatch[i].snowpack ~= (nil)) then
          do
            j = 0
            while (j < 3) do
              do
                do
                  k = 0
                  while (k < 5) do
                    do
                      if (not (F.readDouble(x, k, f) ~= 0)) then
                        do return end
                      end
                    end
                    k = k + 1
                  end
                end
                F.snow_setState(i, j, x)
              end
              j = j + 1
            end
          end
        end
        if (G_Nobjects[POLLUT] > 0) then
          do
            j = 0
            while (j < G_Nobjects[POLLUT]) do
              do
                if (not (F.readDouble(G_Subcatch[i].newQual, j, f) ~= 0)) then
                  do return end
                end
              end
              j = j + 1
            end
          end
          do
            j = 0
            while (j < G_Nobjects[POLLUT]) do
              do
                if (not (F.readDouble(G_Subcatch[i].pondedQual, j, f) ~= 0)) then
                  do return end
                end
              end
              j = j + 1
            end
          end
          do
            k = 0
            while (k < G_Nobjects[LANDUSE]) do
              do
                do
                  j = 0
                  while (j < G_Nobjects[POLLUT]) do
                    do
                      if (not (F.readDouble(G_Subcatch[i].landFactor[k].buildup, j, f) ~= 0)) then
                        do return end
                      end
                    end
                    j = j + 1
                  end
                end
                if (not (F.readDouble(G_Subcatch[i].landFactor[k], "lastSwept", f) ~= 0)) then
                  do return end
                end
              end
              k = k + 1
            end
          end
        end
      end
      i = i + 1
    end
  end
end

-- hotstart.c:499
F.readFloat = function(x, x__k, f)
  R.fread1("f", 4, x, x__k, f)
  if (x[x__k] ~= x[x__k]) then
    F.report_writeErrorMsg(ERR_HOTSTART_FILE_READ, S[0])
    x[x__k] = R.f32(0.0)
    do return 0 end
  end
  do return 1 end
end

-- hotstart.c:521
F.readDouble = function(x, x__k, f)
  if (R.feof(f) ~= 0) then
    x[x__k] = 0.0
    F.report_writeErrorMsg(ERR_HOTSTART_FILE_READ, S[0])
    do return 0 end
  end
  R.fread1("d", 8, x, x__k, f)
  if (x[x__k] ~= x[x__k]) then
    x[x__k] = 0.0
    do return 0 end
  end
  do return 1 end
end

