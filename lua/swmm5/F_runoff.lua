-- Generated from EPA SWMM 5.2.4 (runoff.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local ERR_ODE_SOLVER <const> = 105
local POLLUT <const> = 4
local ERR_MEMORY <const> = 101
local USE_FILE <const> = 2
local SAVE_FILE <const> = 3
local ERR_RUNOFF_FILE_OPEN <const> = 323
local SUBCATCH <const> = 1
local GAGE <const> = 0
local ERR_TIMESTEP <const> = 107
local ERR_RUNOFF_FILE_FORMAT <const> = 325
local ERR_RUNOFF_FILE_END <const> = 327
local SUBCATCH_SNOWDEPTH <const> = 1
local RAINDEPTH <const> = 1
local SUBCATCH_EVAP <const> = 2
local RAINFALL <const> = 0
local SUBCATCH_INFIL <const> = 3
local SUBCATCH_RUNOFF <const> = 4
local FLOW <const> = 10
local SUBCATCH_GW_FLOW <const> = 5
local SUBCATCH_GW_ELEV <const> = 6
local LENGTH <const> = 3
local SUBCATCH_SOIL_MOIST <const> = 7
local SUBCATCH_WASHOFF <const> = 8
local ERR_RUNOFF_FILE_READ <const> = 329
local OUTFALL <const> = 1
local RUNOFF_RUNON <const> = 5
local DEPOSITION_LOAD <const> = 1
local _ENV = R.strict

G.IsRaining = 0
G.HasRunoff = 0
G.HasSnow = 0
G.runoff_Nsteps = 0
G.MaxSteps = 0
G.MaxStepsPos = 0
G.HasWetLids = 0
G.OutflowLoad = nil

-- runoff.c:82
F.runoff_open = function()
  local G_Nobjects, G_Frunoff = G.Nobjects, G.Frunoff
  G.IsRaining = 0
  G.HasRunoff = 0
  G.HasSnow = 0
  G.runoff_Nsteps = 0
  if (not (F.odesolve_open(4) ~= 0)) then
    F.report_writeErrorMsg(ERR_ODE_SOLVER, S[0])
  end
  G.OutflowLoad = (nil)
  if (G_Nobjects[POLLUT] > 0) then
    G.OutflowLoad = R.fill(G_Nobjects[POLLUT], 0.0)
    if (not (G.OutflowLoad ~= nil)) then
      F.report_writeErrorMsg(ERR_MEMORY, S[0])
    end
  end
  do
    local __sw1 = G_Frunoff.mode
    if __sw1 == USE_FILE then goto case2
    elseif __sw1 == SAVE_FILE then goto case3
    else goto swend1 end
    ::case2::
    do
      G_Frunoff.file = R.fopen(G_Frunoff.name, S[165])
      if ((G_Frunoff.file) == (nil)) then
        F.report_writeErrorMsg(ERR_RUNOFF_FILE_OPEN, G_Frunoff.name)
      else
        F.runoff_initFile()
      end
      goto swend1
    end
    ::case3::
    do
      G_Frunoff.file = R.fopen(G_Frunoff.name, S[166])
      if ((G_Frunoff.file) == (nil)) then
        F.report_writeErrorMsg(ERR_RUNOFF_FILE_OPEN, G_Frunoff.name)
      else
        F.runoff_initFile()
      end
      goto swend1
    end
    ::swend1::
  end
  do return G.ErrorCode end
end

-- runoff.c:124
F.runoff_close = function()
  local G_Frunoff, G_Fclimate = G.Frunoff, G.Fclimate
  F.odesolve_close()
  do
    if (G.OutflowLoad ~= nil) then
      local _ = nil
      G.OutflowLoad = (nil)
    end
  end
  if (G_Frunoff.file ~= nil) then
    if (G_Frunoff.mode == SAVE_FILE) then
      R.fseek(G_Frunoff.file, G.MaxStepsPos, 0)
      R.fwrite1("i", 4, G.runoff_Nsteps, G_Frunoff.file)
    end
    R.fclose(G_Frunoff.file)
  end
  if (G_Fclimate.file ~= nil) then
    R.fclose(G_Fclimate.file)
  end
end

-- runoff.c:155
F.runoff_execute = function()
  local G_Nobjects, G_Gage, G_Frunoff, G_Subcatch = G.Nobjects, G.Gage, G.Frunoff, G.Subcatch
  local j = 0
  local day = 0
  local runoffStep = 0.0
  local oldRunoffStep = 0.0
  local runoff = 0.0
  local currentDate = 0.0
  local canSweep = 0
  if (G.ErrorCode ~= 0) then
    do return end
  end
  oldRunoffStep = (((G.NewRunoffTime - G.OldRunoffTime)) / 1000.0)
  currentDate = F.getDateTime(G.NewRunoffTime)
  F.climate_setState(currentDate)
  if (G_Nobjects[SUBCATCH] == 0) then
    G.OldRunoffTime = G.NewRunoffTime
    G.NewRunoffTime = (G.NewRunoffTime + (((G.DryStep) * 1.0) * 1000.0))
    G.NewRunoffTime = (((((G.NewRunoffTime) <= (G.TotalDuration))) and (G.NewRunoffTime) or (G.TotalDuration)))
    do return end
  end
  G.IsRaining = 0
  do
    j = 0
    while (j < G_Nobjects[GAGE]) do
      do
        F.gage_setState(j, currentDate)
        if (G_Gage[j].rainfall > 0.0) then
          G.IsRaining = 1
        end
      end
      j = j + 1
    end
  end
  if (G_Frunoff.mode == USE_FILE) then
    F.runoff_readFromFile()
    do return end
  end
  day = F.datetime_dayOfYear(currentDate)
  canSweep = 0
  if (G.SweepStart <= G.SweepEnd) then
    if ((day >= G.SweepStart) and (day <= G.SweepEnd)) then
      canSweep = 1
    end
  elseif ((day <= G.SweepEnd) or (day >= G.SweepStart)) then
    canSweep = 1
  end
  runoffStep = F.runoff_getTimeStep(currentDate)
  if (runoffStep <= 0.0) then
    G.ErrorCode = ERR_TIMESTEP
    do return end
  end
  G.OldRunoffTime = G.NewRunoffTime
  G.NewRunoffTime = (G.NewRunoffTime + ((1000.0 * runoffStep)))
  if (G.NewRunoffTime > G.TotalDuration) then
    runoffStep = (((G.TotalDuration - G.OldRunoffTime)) / 1000.0)
    G.NewRunoffTime = G.TotalDuration
  end
  do
    j = 0
    while (j < G_Nobjects[GAGE]) do
      do
        F.gage_updatePastRain(j, R.D2I(runoffStep))
      end
      j = j + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        F.subcatch_setOldState(j)
      end
      j = j + 1
    end
  end
  if (oldRunoffStep > 0.0) then
    F.runoff_getOutfallRunon(oldRunoffStep)
  end
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        if (G_Subcatch[j].area == 0.0) then
          goto continue4
        end
        F.subcatch_getRunon(j)
        if (not (G.IgnoreSnowmelt ~= 0)) then
          F.snow_plowSnow(j, runoffStep)
        end
      end
      ::continue4::
      j = j + 1
    end
  end
  G.HasSnow = 0
  G.HasRunoff = 0
  G.HasWetLids = 0
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        if (G_Subcatch[j].area == 0.0) then
          goto continue5
        end
        runoff = F.subcatch_getRunoff(j, runoffStep)
        if (runoff > 0.0) then
          G.HasRunoff = 1
        end
        if (G_Subcatch[j].newSnowDepth > 0.0) then
          G.HasSnow = 1
        end
        if (G.IgnoreQuality ~= 0) then
          goto continue5
        end
        if (runoff < 2.31481e-08) then
          F.surfqual_getBuildup(j, runoffStep)
        end
        if ((canSweep ~= 0) and (G_Subcatch[j].rainfall <= 2.31481e-08)) then
          F.surfqual_sweepBuildup(j, currentDate)
        end
        F.surfqual_getWashoff(j, runoff, runoffStep)
      end
      ::continue5::
      j = j + 1
    end
  end
  F.stats_updateMaxRunoff()
  G.runoff_Nsteps = G.runoff_Nsteps + 1
  if (G_Frunoff.mode == SAVE_FILE) then
    F.runoff_saveToFile(R.f32(runoffStep))
  end
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        G_Subcatch[j].runon = 0.0
      end
      j = j + 1
    end
  end
end

-- runoff.c:299
F.runoff_getTimeStep = function(currentDate)
  local G_Nobjects = G.Nobjects
  local j = 0
  local timeStep = 0
  local maxStep = G.DryStep
  timeStep = F.datetime_timeDiff(F.climate_getNextEvapDate(), currentDate)
  if (((timeStep * 1.0) > 0.0) and (timeStep < maxStep)) then
    maxStep = timeStep
  end
  do
    j = 0
    while (j < G_Nobjects[GAGE]) do
      do
        timeStep = F.datetime_timeDiff(F.gage_getNextRainDate(j, currentDate), currentDate)
        if ((timeStep > 0) and (timeStep < maxStep)) then
          maxStep = timeStep
        end
      end
      j = j + 1
    end
  end
  if ((((G.IsRaining ~= 0) or (G.HasSnow ~= 0)) or (G.HasRunoff ~= 0)) or (G.HasWetLids ~= 0)) then
    timeStep = G.WetStep
  else
    timeStep = G.DryStep
  end
  if (timeStep > maxStep) then
    timeStep = maxStep
  end
  do return (timeStep * 1.0) end
end

-- runoff.c:335
F.runoff_initFile = function()
  local G_Frunoff, G_Nobjects = G.Frunoff, G.Nobjects
  local nSubcatch = {0}
  local nPollut = {0}
  local flowUnits = {0}
  local fileStamp = R.bufFrom(S[533], 13)
  local fStamp = R.bufFrom(S[533], 13)
  G.MaxSteps = 0
  if (G_Frunoff.mode == SAVE_FILE) then
    nSubcatch[1] = G_Nobjects[SUBCATCH]
    nPollut[1] = G_Nobjects[POLLUT]
    flowUnits[1] = G.FlowUnits
    R.fwrite_arr("c", fileStamp, 0, R.strlen(fileStamp), G_Frunoff.file)
    R.fwrite1("i", 4, nSubcatch[1], G_Frunoff.file)
    R.fwrite1("i", 4, nPollut[1], G_Frunoff.file)
    R.fwrite1("i", 4, flowUnits[1], G_Frunoff.file)
    G.MaxStepsPos = R.ftell(G_Frunoff.file)
    R.fwrite1("i", 4, G.MaxSteps, G_Frunoff.file)
  end
  if (G_Frunoff.mode == USE_FILE) then
    R.fread_arr("c", fStamp, 0, R.strlen(fileStamp), G_Frunoff.file)
    if (R.strcmp(fStamp, fileStamp) ~= 0) then
      F.report_writeErrorMsg(ERR_RUNOFF_FILE_FORMAT, S[0])
      do return end
    end
    nSubcatch[1] = (-1)
    nPollut[1] = (-1)
    flowUnits[1] = (-1)
    R.fread1("i", 4, nSubcatch, 1, G_Frunoff.file)
    R.fread1("i", 4, nPollut, 1, G_Frunoff.file)
    R.fread1("i", 4, flowUnits, 1, G_Frunoff.file)
    R.fread1("i", 4, G, "MaxSteps", G_Frunoff.file)
    if ((((nSubcatch[1] ~= G_Nobjects[SUBCATCH]) or (nPollut[1] ~= G_Nobjects[POLLUT])) or (flowUnits[1] ~= G.FlowUnits)) or (G.MaxSteps <= 0)) then
      F.report_writeErrorMsg(ERR_RUNOFF_FILE_FORMAT, S[0])
    end
  end
end

-- runoff.c:391
F.runoff_saveToFile = function(tStep)
  tStep = {tStep}
  local G_Nobjects, G_Frunoff, G_SubcatchResults = G.Nobjects, G.Frunoff, G.SubcatchResults
  local j = 0
  local n = ((9 + G_Nobjects[POLLUT]) - 1)
  R.fwrite1("f", 4, tStep[1], G_Frunoff.file)
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        F.subcatch_getResults(j, 1.0, G_SubcatchResults)
        R.fwrite_arr("f", G_SubcatchResults, 0, n, G_Frunoff.file)
      end
      j = j + 1
    end
  end
end

-- runoff.c:412
F.runoff_readFromFile = function()
  local G_Nobjects, G_Frunoff, G_SubcatchResults, G_Subcatch, G_Aquifer = G.Nobjects, G.Frunoff, G.SubcatchResults, G.Subcatch, G.Aquifer
  local i = 0
  local j = 0
  local nResults = 0
  local kount = 0
  local tStep = {0.0}
  local gw = nil
  if (G.runoff_Nsteps > G.MaxSteps) then
    F.report_writeErrorMsg(ERR_RUNOFF_FILE_END, S[0])
    do return end
  end
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        F.subcatch_setOldState(j)
      end
      j = j + 1
    end
  end
  kount = 0
  kount = (kount + (R.i32(R.fread1("f", 4, tStep, 1, G_Frunoff.file))))
  nResults = ((9 + G_Nobjects[POLLUT]) - 1)
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        kount = (kount + (R.i32(R.fread_arr("f", G_SubcatchResults, 0, nResults, G_Frunoff.file))))
        G_Subcatch[j].newSnowDepth = (G_SubcatchResults[SUBCATCH_SNOWDEPTH] / F.UCF(RAINDEPTH))
        G_Subcatch[j].evapLoss = (G_SubcatchResults[SUBCATCH_EVAP] / F.UCF(RAINFALL))
        G_Subcatch[j].infilLoss = (G_SubcatchResults[SUBCATCH_INFIL] / F.UCF(RAINFALL))
        G_Subcatch[j].newRunoff = (G_SubcatchResults[SUBCATCH_RUNOFF] / F.UCF(FLOW))
        gw = G_Subcatch[j].groundwater
        if (gw ~= nil) then
          gw.newFlow = (G_SubcatchResults[SUBCATCH_GW_FLOW] / F.UCF(FLOW))
          gw.lowerDepth = (G_Aquifer[gw.aquifer].bottomElev - ((G_SubcatchResults[SUBCATCH_GW_ELEV] / F.UCF(LENGTH))))
          gw.theta = G_SubcatchResults[SUBCATCH_SOIL_MOIST]
        end
        do
          i = 0
          while (i < G_Nobjects[POLLUT]) do
            do
              G_Subcatch[j].newQual[i] = G_SubcatchResults[(SUBCATCH_WASHOFF + i)]
            end
            i = i + 1
          end
        end
      end
      j = j + 1
    end
  end
  if (kount < (1 + (G_Nobjects[SUBCATCH] * nResults))) then
    F.report_writeErrorMsg(ERR_RUNOFF_FILE_READ, S[0])
    do return end
  end
  G.OldRunoffTime = G.NewRunoffTime
  G.NewRunoffTime = (G.OldRunoffTime + ((tStep[1]) * 1000.0))
  G.NewRunoffTime = (((((G.NewRunoffTime) <= (G.TotalDuration))) and (G.NewRunoffTime) or (G.TotalDuration)))
  G.runoff_Nsteps = G.runoff_Nsteps + 1
end

-- runoff.c:491
F.runoff_getOutfallRunon = function(tStep)
  local G_Nnodes, G_Outfall, G_Subcatch, G_Nobjects, G_Pollut = G.Nnodes, G.Outfall, G.Subcatch, G.Nobjects, G.Pollut
  local i = 0
  local k = 0
  local p = 0
  local w = 0.0
  do
    i = 0
    while (i < G_Nnodes[OUTFALL]) do
      do
        k = G_Outfall[i].routeTo
        if (k < 0) then
          goto continue1
        end
        if (G_Subcatch[k].area == 0.0) then
          goto continue1
        end
        F.subcatch_addRunonFlow(k, (G_Outfall[i].vRouted / tStep))
        F.massbal_updateRunoffTotals(RUNOFF_RUNON, G_Outfall[i].vRouted)
        G_Outfall[i].vRouted = 0.0
        do
          p = 0
          while (p < G_Nobjects[POLLUT]) do
            do
              w = (G_Outfall[i].wRouted[p] * 28.317)
              F.massbal_updateLoadingTotals(DEPOSITION_LOAD, p, (w * G_Pollut[p].mcf))
              G_Subcatch[k].newQual[p] = (G_Subcatch[k].newQual[p] + (w / tStep))
              G_Outfall[i].wRouted[p] = 0.0
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

