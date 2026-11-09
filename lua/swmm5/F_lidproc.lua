-- Generated from EPA SWMM 5.2.4 (lidproc.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local SURF <const> = 0
local SOIL <const> = 1
local STOR <const> = 2
local PAVE <const> = 3
local POROUS_PAVEMENT <const> = 4
local MOD_GREEN_AMPT <const> = 3
local GREEN_ROOF <const> = 2
local BIO_CELL <const> = 0
local RAIN_GARDEN <const> = 1
local INFIL_TRENCH <const> = 3
local RAIN_BARREL <const> = 5
local ROOF_DISCON <const> = 7
local VEG_SWALE <const> = 6
local SURF_INFLOW <const> = 0
local TOTAL_EVAP <const> = 1
local SURF_INFIL <const> = 2
local PAVE_PERC <const> = 3
local SOIL_PERC <const> = 4
local STOR_EXFIL <const> = 5
local SURF_OUTFLOW <const> = 6
local STOR_DRAIN <const> = 7
local SURF_DEPTH <const> = 8
local PAVE_DEPTH <const> = 9
local SOIL_MOIST <const> = 10
local STOR_DEPTH <const> = 11
local RAINFALL <const> = 0
local RAINDEPTH <const> = 1
local _ENV = R.strict

G.theLidUnit = nil
G.theLidProc = nil
G.lidproc_Tstep = 0.0
G.lidproc_EvapRate = 0.0
G.lidproc_MaxNativeInfil = 0.0
G.SurfaceInflow = 0.0
G.SurfaceInfil = 0.0
G.SurfaceEvap = 0.0
G.SurfaceOutflow = 0.0
G.SurfaceVolume = 0.0
G.PaveEvap = 0.0
G.PavePerc = 0.0
G.PaveVolume = 0.0
G.SoilEvap = 0.0
G.SoilPerc = 0.0
G.SoilVolume = 0.0
G.StorageInflow = 0.0
G.StorageExfil = 0.0
G.StorageEvap = 0.0
G.StorageDrain = 0.0
G.StorageVolume = 0.0
G.Xold = R.fill(4, 0.0)

-- lidproc.c:178
F.lidproc_initWaterBalance = function(lidUnit, initVol)
  lidUnit.waterBalance.inflow = 0.0
  lidUnit.waterBalance.evap = 0.0
  lidUnit.waterBalance.infil = 0.0
  lidUnit.waterBalance.surfFlow = 0.0
  lidUnit.waterBalance.drainFlow = 0.0
  lidUnit.waterBalance.initVol = initVol
  lidUnit.waterBalance.finalVol = initVol
end

-- lidproc.c:197
F.lidproc_getOutflow = function(lidUnit, lidProc, inflow, evap, infil, maxInfil, tStep, lidEvap, lidEvap__k, lidInfil, lidInfil__k, lidDrain, lidDrain__k)
  local G_Xold = G.Xold
  local i = 0
  local x = R.fill(4, 0.0)
  local xOld = R.fill(4, 0.0)
  local xPrev = R.fill(4, 0.0)
  local xMin = R.fill(4, 0.0)
  local xMax = R.fill(4, 0.0)
  local fOld = R.fill(4, 0.0)
  local f = R.fill(4, 0.0)
  local xTol = {[0] = 0.00328, 0.00328, 0.00328, 0.00328}
  local omega = 0.0
  local fluxRates = (nil)
  G.theLidProc = lidProc
  G.theLidUnit = lidUnit
  G.lidproc_EvapRate = evap
  G.lidproc_MaxNativeInfil = maxInfil
  G.lidproc_Tstep = tStep
  x[SURF] = G.theLidUnit.surfaceDepth
  x[SOIL] = G.theLidUnit.soilMoisture
  x[STOR] = G.theLidUnit.storageDepth
  x[PAVE] = G.theLidUnit.paveDepth
  G.SurfaceVolume = 0.0
  G.PaveVolume = 0.0
  G.SoilVolume = 0.0
  G.StorageVolume = 0.0
  G.SurfaceInflow = inflow
  G.SurfaceInfil = 0.0
  G.SurfaceEvap = 0.0
  G.SurfaceOutflow = 0.0
  G.PaveEvap = 0.0
  G.PavePerc = 0.0
  G.SoilEvap = 0.0
  G.SoilPerc = 0.0
  G.StorageInflow = 0.0
  G.StorageExfil = 0.0
  G.StorageEvap = 0.0
  G.StorageDrain = 0.0
  do
    i = 0
    while (i < 4) do
      do
        f[i] = 0.0
        fOld[i] = G.theLidUnit.oldFluxRates[i]
        xMin[i] = 0.0
        xMax[i] = 10000000000.0
        G_Xold[i] = x[i]
      end
      i = i + 1
    end
  end
  if (G.theLidProc.lidType == POROUS_PAVEMENT) then
    G.SurfaceInfil = 0.0
  elseif (G.theLidUnit.soilInfil.Ks > 0.0) then
    G.SurfaceInfil = F.grnampt_getInfil(G.theLidUnit.soilInfil, G.lidproc_Tstep, G.SurfaceInflow, G.theLidUnit.surfaceDepth, MOD_GREEN_AMPT)
  else
    G.SurfaceInfil = infil
  end
  if (G.theLidProc.soil.thickness > 0.0) then
    xMin[SOIL] = G.theLidProc.soil.wiltPoint
    xMax[SOIL] = G.theLidProc.soil.porosity
  end
  if (G.theLidProc.pavement.thickness > 0.0) then
    xMax[PAVE] = G.theLidProc.pavement.thickness
  end
  if (G.theLidProc.storage.thickness > 0.0) then
    xMax[STOR] = G.theLidProc.storage.thickness
  end
  if (G.theLidProc.lidType == GREEN_ROOF) then
    xMax[STOR] = G.theLidProc.drainMat.thickness
  end
  do
    local __sw1 = G.theLidProc.lidType
    if __sw1 < POROUS_PAVEMENT then
      if __sw1 < GREEN_ROOF then
        if __sw1 == BIO_CELL then goto case3
        elseif __sw1 == RAIN_GARDEN then goto case3
        end
      else
        if __sw1 == GREEN_ROOF then goto case4
        elseif __sw1 == INFIL_TRENCH then goto case5
        end
      end
    else
      if __sw1 < VEG_SWALE then
        if __sw1 == POROUS_PAVEMENT then goto case6
        elseif __sw1 == RAIN_BARREL then goto case7
        end
      else
        if __sw1 == VEG_SWALE then goto case9
        elseif __sw1 == ROOF_DISCON then goto case8
        end
      end
    end
    goto case10
    ::case3::
    do
      fluxRates = F.biocellFluxRates
      goto swend2
    end
    ::case4::
    do
      fluxRates = F.greenRoofFluxRates
      goto swend2
    end
    ::case5::
    do
      fluxRates = F.trenchFluxRates
      goto swend2
    end
    ::case6::
    do
      fluxRates = F.pavementFluxRates
      goto swend2
    end
    ::case7::
    do
      fluxRates = F.barrelFluxRates
      goto swend2
    end
    ::case8::
    do
      fluxRates = F.roofFluxRates
      goto swend2
    end
    ::case9::
    do
      fluxRates = F.swaleFluxRates
      omega = 0.5
      goto swend2
    end
    ::case10::
    do
      do return 0.0 end
    end
    ::swend2::
  end
  i = F.modpuls_solve(4, x, xOld, xPrev, xMin, xMax, xTol, fOld, f, tStep, omega, fluxRates)
  if ((G.theLidProc.surface.canOverflow ~= 0) or (G.theLidUnit.fullWidth == 0.0)) then
    G.SurfaceOutflow = (G.SurfaceOutflow + (F.getSurfaceOverflowRate(x, SURF)))
  end
  G.theLidUnit.surfaceDepth = x[SURF]
  G.theLidUnit.paveDepth = x[PAVE]
  G.theLidUnit.soilMoisture = x[SOIL]
  G.theLidUnit.storageDepth = x[STOR]
  do
    i = 0
    while (i < 4) do
      do
        G.theLidUnit.oldFluxRates[i] = f[i]
      end
      i = i + 1
    end
  end
  lidEvap[lidEvap__k] = (((G.SurfaceEvap + G.PaveEvap) + G.SoilEvap) + G.StorageEvap)
  lidInfil[lidInfil__k] = G.StorageExfil
  lidDrain[lidDrain__k] = G.StorageDrain
  do return G.SurfaceOutflow end
end

-- lidproc.c:360
F.lidproc_saveResults = function(lidUnit, ucfRainfall, ucfRainDepth)
  local G_theLidUnit = G.theLidUnit
  local ucf = 0.0
  local totalEvap = 0.0
  local totalVolume = 0.0
  local rptVars = R.fill(12, 0.0)
  local isDry = 0
  local timeStamp = R.buf(22)
  local elapsedHrs = 0.0
  totalEvap = (((G.SurfaceEvap + G.PaveEvap) + G.SoilEvap) + G.StorageEvap)
  totalVolume = (((G.SurfaceVolume + G.PaveVolume) + G.SoilVolume) + G.StorageVolume)
  F.updateWaterBalance(G_theLidUnit, G.SurfaceInflow, totalEvap, G.StorageExfil, G.SurfaceOutflow, G.StorageDrain, totalVolume)
  if (((((G.SurfaceInflow < 2.3e-08) and (G.SurfaceOutflow < 2.3e-08)) and (G.StorageDrain < 2.3e-08)) and (G.StorageExfil < 2.3e-08)) and (totalEvap < 2.3e-08)) then
    isDry = 1
  end
  if (not (isDry ~= 0)) then
    G.HasWetLids = 1
  end
  if (lidUnit.rptFile ~= nil) then
    ucf = ucfRainfall
    rptVars[SURF_INFLOW] = (G.SurfaceInflow * ucf)
    rptVars[TOTAL_EVAP] = (totalEvap * ucf)
    rptVars[SURF_INFIL] = (G.SurfaceInfil * ucf)
    rptVars[PAVE_PERC] = (G.PavePerc * ucf)
    rptVars[SOIL_PERC] = (G.SoilPerc * ucf)
    rptVars[STOR_EXFIL] = (G.StorageExfil * ucf)
    rptVars[SURF_OUTFLOW] = (G.SurfaceOutflow * ucf)
    rptVars[STOR_DRAIN] = (G.StorageDrain * ucf)
    ucf = ucfRainDepth
    rptVars[SURF_DEPTH] = (G_theLidUnit.surfaceDepth * ucf)
    rptVars[PAVE_DEPTH] = (G_theLidUnit.paveDepth * ucf)
    rptVars[SOIL_MOIST] = G_theLidUnit.soilMoisture
    rptVars[STOR_DEPTH] = (G_theLidUnit.storageDepth * ucf)
    if ((not (isDry ~= 0)) and (G_theLidUnit.rptFile.wasDry > 1)) then
      R.fprintf(G_theLidUnit.rptFile.file, S[169], G_theLidUnit.rptFile.results)
    end
    elapsedHrs = ((G.NewRunoffTime / 1000.0) / 3600.0)
    F.datetime_getTimeStamp(1, F.getDateTime(G.NewRunoffTime), 21, timeStamp)
    R.snprintf(G_theLidUnit.rptFile.results, 256, S[304], timeStamp, elapsedHrs, rptVars[0], rptVars[1], rptVars[2], rptVars[3], rptVars[4], rptVars[5], rptVars[6], rptVars[7], rptVars[8], rptVars[9], rptVars[10], rptVars[11])
    if (isDry ~= 0) then
      if (G_theLidUnit.rptFile.wasDry == 0) then
        R.fprintf(G_theLidUnit.rptFile.file, S[169], G_theLidUnit.rptFile.results)
      end
      G_theLidUnit.rptFile.wasDry = G_theLidUnit.rptFile.wasDry + 1
    else
      R.fprintf(G_theLidUnit.rptFile.file, S[169], G_theLidUnit.rptFile.results)
      G_theLidUnit.rptFile.wasDry = 0
    end
  end
end

-- lidproc.c:469
F.roofFluxRates = function(x, f)
  local G_theLidProc = G.theLidProc
  local surfaceDepth = {x[SURF]}
  F.lidproc_getEvapRates(surfaceDepth[1], 0.0, 0.0, 0.0, 1.0)
  G.SurfaceVolume = surfaceDepth[1]
  G.SurfaceInfil = 0.0
  if (G_theLidProc.surface.alpha > 0.0) then
    G.SurfaceOutflow = F.getSurfaceOutflowRate(surfaceDepth[1])
  else
    F.getSurfaceOverflowRate(surfaceDepth, 1)
  end
  G.StorageDrain = ((((((G_theLidProc.drain.coeff / F.UCF(RAINFALL))) <= (G.SurfaceOutflow))) and ((G_theLidProc.drain.coeff / F.UCF(RAINFALL))) or (G.SurfaceOutflow)))
  G.SurfaceOutflow = (G.SurfaceOutflow - G.StorageDrain)
  f[SURF] = ((((G.SurfaceInflow - G.SurfaceEvap) - G.StorageDrain) - G.SurfaceOutflow))
end

-- lidproc.c:491
F.greenRoofFluxRates = function(x, f)
  local G_theLidProc = G.theLidProc
  local surfaceDepth = 0.0
  local soilTheta = 0.0
  local storageDepth = 0.0
  local availVolume = 0.0
  local maxRate = 0.0
  local soilThickness = G_theLidProc.soil.thickness
  local storageThickness = G_theLidProc.storage.thickness
  local soilPorosity = G_theLidProc.soil.porosity
  local storageVoidFrac = G_theLidProc.storage.voidFrac
  local soilFieldCap = G_theLidProc.soil.fieldCap
  local soilWiltPoint = G_theLidProc.soil.wiltPoint
  surfaceDepth = x[SURF]
  soilTheta = x[SOIL]
  storageDepth = x[STOR]
  G.SurfaceVolume = (surfaceDepth * G_theLidProc.surface.voidFrac)
  G.SoilVolume = (soilTheta * soilThickness)
  G.StorageVolume = (storageDepth * storageVoidFrac)
  availVolume = (G.SoilVolume - (soilWiltPoint * soilThickness))
  F.lidproc_getEvapRates(G.SurfaceVolume, 0.0, availVolume, G.StorageVolume, 1.0)
  if (soilTheta >= soilPorosity) then
    G.StorageEvap = 0.0
  end
  G.SoilPerc = F.getSoilPercRate(soilTheta)
  availVolume = (((soilTheta - soilFieldCap)) * soilThickness)
  maxRate = (((((((availVolume) >= (0.0))) and (availVolume) or (0.0))) / G.lidproc_Tstep) - G.SoilEvap)
  G.SoilPerc = (((((G.SoilPerc) <= (maxRate))) and (G.SoilPerc) or (maxRate)))
  G.SoilPerc = (((((G.SoilPerc) >= (0.0))) and (G.SoilPerc) or (0.0)))
  G.StorageExfil = 0.0
  G.StorageDrain = F.getDrainMatOutflow(storageDepth)
  if ((soilTheta >= soilPorosity) and (storageDepth >= storageThickness)) then
    maxRate = (((((G.SoilPerc) <= (G.StorageDrain))) and (G.SoilPerc) or (G.StorageDrain)))
    G.SoilPerc = maxRate
    G.StorageDrain = maxRate
    G.SurfaceInfil = (((((G.SurfaceInfil) <= (maxRate))) and (G.SurfaceInfil) or (maxRate)))
  else
    maxRate = (((storageDepth * storageVoidFrac) / G.lidproc_Tstep) - G.StorageEvap)
    if (storageDepth >= storageThickness) then
      maxRate = (maxRate + G.SoilPerc)
    end
    maxRate = (((((maxRate) >= (0.0))) and (maxRate) or (0.0)))
    G.StorageDrain = (((((G.StorageDrain) <= (maxRate))) and (G.StorageDrain) or (maxRate)))
    maxRate = ((((((storageThickness - storageDepth)) * storageVoidFrac) / G.lidproc_Tstep) + G.StorageDrain) + G.StorageEvap)
    G.SoilPerc = (((((G.SoilPerc) <= (maxRate))) and (G.SoilPerc) or (maxRate)))
    maxRate = ((((((soilPorosity - soilTheta)) * soilThickness) / G.lidproc_Tstep) + G.SoilPerc) + G.SoilEvap)
    G.SurfaceInfil = (((((G.SurfaceInfil) <= (maxRate))) and (G.SurfaceInfil) or (maxRate)))
  end
  G.SurfaceOutflow = F.getSurfaceOutflowRate(surfaceDepth)
  f[SURF] = (((((G.SurfaceInflow - G.SurfaceEvap) - G.SurfaceInfil) - G.SurfaceOutflow)) / G_theLidProc.surface.voidFrac)
  f[SOIL] = ((((G.SurfaceInfil - G.SoilEvap) - G.SoilPerc)) / G_theLidProc.soil.thickness)
  f[STOR] = ((((G.SoilPerc - G.StorageEvap) - G.StorageDrain)) / G_theLidProc.storage.voidFrac)
end

-- lidproc.c:589
F.biocellFluxRates = function(x, f)
  local G_theLidProc = G.theLidProc
  local surfaceDepth = 0.0
  local soilTheta = 0.0
  local storageDepth = 0.0
  local availVolume = 0.0
  local maxRate = 0.0
  local soilThickness = G_theLidProc.soil.thickness
  local soilPorosity = G_theLidProc.soil.porosity
  local soilFieldCap = G_theLidProc.soil.fieldCap
  local soilWiltPoint = G_theLidProc.soil.wiltPoint
  local storageThickness = G_theLidProc.storage.thickness
  local storageVoidFrac = G_theLidProc.storage.voidFrac
  surfaceDepth = x[SURF]
  soilTheta = x[SOIL]
  storageDepth = x[STOR]
  G.SurfaceVolume = (surfaceDepth * G_theLidProc.surface.voidFrac)
  G.SoilVolume = (soilTheta * soilThickness)
  G.StorageVolume = (storageDepth * storageVoidFrac)
  availVolume = (G.SoilVolume - (soilWiltPoint * soilThickness))
  F.lidproc_getEvapRates(G.SurfaceVolume, 0.0, availVolume, G.StorageVolume, 1.0)
  if (soilTheta >= soilPorosity) then
    G.StorageEvap = 0.0
  end
  G.SoilPerc = F.getSoilPercRate(soilTheta)
  availVolume = (((soilTheta - soilFieldCap)) * soilThickness)
  maxRate = (((((((availVolume) >= (0.0))) and (availVolume) or (0.0))) / G.lidproc_Tstep) - G.SoilEvap)
  G.SoilPerc = (((((G.SoilPerc) <= (maxRate))) and (G.SoilPerc) or (maxRate)))
  G.SoilPerc = (((((G.SoilPerc) >= (0.0))) and (G.SoilPerc) or (0.0)))
  G.StorageExfil = F.getStorageExfilRate()
  G.StorageDrain = 0.0
  if (G_theLidProc.drain.coeff > 0.0) then
    G.StorageDrain = F.getStorageDrainRate(storageDepth, soilTheta, 0.0, surfaceDepth)
  end
  if (storageThickness == 0.0) then
    G.StorageEvap = 0.0
    maxRate = (((((G.SoilPerc) <= (G.StorageExfil))) and (G.SoilPerc) or (G.StorageExfil)))
    G.SoilPerc = maxRate
    G.StorageExfil = maxRate
    maxRate = ((((((soilPorosity - soilTheta)) * soilThickness) / G.lidproc_Tstep) + G.SoilPerc) + G.SoilEvap)
    G.SurfaceInfil = (((((G.SurfaceInfil) <= (maxRate))) and (G.SurfaceInfil) or (maxRate)))
  else
    if ((soilTheta >= soilPorosity) and (storageDepth >= storageThickness)) then
      maxRate = (G.StorageExfil + G.StorageDrain)
      if (G.SoilPerc < maxRate) then
        maxRate = G.SoilPerc
        if (maxRate > G.StorageExfil) then
          G.StorageDrain = (maxRate - G.StorageExfil)
        else
          G.StorageExfil = maxRate
          G.StorageDrain = 0.0
        end
      else
        G.SoilPerc = maxRate
      end
      G.SurfaceInfil = (((((G.SurfaceInfil) <= (maxRate))) and (G.SurfaceInfil) or (maxRate)))
    else
      maxRate = ((G.SoilPerc - G.StorageEvap) + ((storageDepth * storageVoidFrac) / G.lidproc_Tstep))
      G.StorageExfil = (((((G.StorageExfil) <= (maxRate))) and (G.StorageExfil) or (maxRate)))
      G.StorageExfil = (((((G.StorageExfil) >= (0.0))) and (G.StorageExfil) or (0.0)))
      if (G.StorageDrain > 0.0) then
        maxRate = ((-G.StorageExfil) - G.StorageEvap)
        if (storageDepth >= storageThickness) then
          maxRate = (maxRate + G.SoilPerc)
        end
        if (G_theLidProc.drain.offset <= storageDepth) then
          maxRate = (maxRate + ((((storageDepth - G_theLidProc.drain.offset)) * storageVoidFrac) / G.lidproc_Tstep))
        end
        maxRate = (((((maxRate) >= (0.0))) and (maxRate) or (0.0)))
        G.StorageDrain = (((((G.StorageDrain) <= (maxRate))) and (G.StorageDrain) or (maxRate)))
      end
      maxRate = (((G.StorageExfil + G.StorageDrain) + G.StorageEvap) + ((((storageThickness - storageDepth)) * storageVoidFrac) / G.lidproc_Tstep))
      G.SoilPerc = (((((G.SoilPerc) <= (maxRate))) and (G.SoilPerc) or (maxRate)))
      maxRate = ((((((soilPorosity - soilTheta)) * soilThickness) / G.lidproc_Tstep) + G.SoilPerc) + G.SoilEvap)
      G.SurfaceInfil = (((((G.SurfaceInfil) <= (maxRate))) and (G.SurfaceInfil) or (maxRate)))
    end
  end
  G.SurfaceOutflow = F.getSurfaceOutflowRate(surfaceDepth)
  f[SURF] = (((((G.SurfaceInflow - G.SurfaceEvap) - G.SurfaceInfil) - G.SurfaceOutflow)) / G_theLidProc.surface.voidFrac)
  f[SOIL] = ((((G.SurfaceInfil - G.SoilEvap) - G.SoilPerc)) / G_theLidProc.soil.thickness)
  if (storageThickness == 0.0) then
    f[STOR] = 0.0
  else
    f[STOR] = (((((G.SoilPerc - G.StorageEvap) - G.StorageExfil) - G.StorageDrain)) / G_theLidProc.storage.voidFrac)
  end
end

-- lidproc.c:735
F.trenchFluxRates = function(x, f)
  local G_theLidProc = G.theLidProc
  local surfaceDepth = 0.0
  local storageDepth = 0.0
  local availVolume = 0.0
  local maxRate = 0.0
  local storageThickness = G_theLidProc.storage.thickness
  local storageVoidFrac = G_theLidProc.storage.voidFrac
  surfaceDepth = x[SURF]
  storageDepth = x[STOR]
  G.SurfaceVolume = (surfaceDepth * G_theLidProc.surface.voidFrac)
  G.SoilVolume = 0.0
  G.StorageVolume = (storageDepth * storageVoidFrac)
  availVolume = (((storageThickness - storageDepth)) * storageVoidFrac)
  F.lidproc_getEvapRates(G.SurfaceVolume, 0.0, 0.0, G.StorageVolume, 1.0)
  if (surfaceDepth > 0.0) then
    G.StorageEvap = 0.0
  end
  G.StorageInflow = (G.SurfaceInflow + (G.SurfaceVolume / G.lidproc_Tstep))
  G.StorageExfil = F.getStorageExfilRate()
  G.StorageDrain = 0.0
  if (G_theLidProc.drain.coeff > 0.0) then
    G.StorageDrain = F.getStorageDrainRate(storageDepth, 0.0, 0.0, surfaceDepth)
  end
  maxRate = ((G.StorageInflow - G.StorageEvap) + ((storageDepth * storageVoidFrac) / G.lidproc_Tstep))
  G.StorageExfil = (((((G.StorageExfil) <= (maxRate))) and (G.StorageExfil) or (maxRate)))
  G.StorageExfil = (((((G.StorageExfil) >= (0.0))) and (G.StorageExfil) or (0.0)))
  if (G.StorageDrain > 0.0) then
    maxRate = ((-G.StorageExfil) - G.StorageEvap)
    if (storageDepth >= storageThickness) then
      maxRate = (maxRate + G.StorageInflow)
    end
    if (G_theLidProc.drain.offset <= storageDepth) then
      maxRate = (maxRate + ((((storageDepth - G_theLidProc.drain.offset)) * storageVoidFrac) / G.lidproc_Tstep))
    end
    maxRate = (((((maxRate) >= (0.0))) and (maxRate) or (0.0)))
    G.StorageDrain = (((((G.StorageDrain) <= (maxRate))) and (G.StorageDrain) or (maxRate)))
  end
  maxRate = (((((((storageThickness - storageDepth)) * storageVoidFrac) / G.lidproc_Tstep) + G.StorageExfil) + G.StorageEvap) + G.StorageDrain)
  G.StorageInflow = (((((G.StorageInflow) <= (maxRate))) and (G.StorageInflow) or (maxRate)))
  G.SurfaceInfil = G.StorageInflow
  G.SurfaceOutflow = F.getSurfaceOutflowRate(surfaceDepth)
  f[SURF] = (((((G.SurfaceInflow - G.SurfaceEvap) - G.StorageInflow) - G.SurfaceOutflow)) / G_theLidProc.surface.voidFrac)
  f[STOR] = (((((G.StorageInflow - G.StorageEvap) - G.StorageExfil) - G.StorageDrain)) / G_theLidProc.storage.voidFrac)
  f[SOIL] = 0.0
end

-- lidproc.c:823
F.pavementFluxRates = function(x, f)
  local G_theLidProc = G.theLidProc
  local surfaceDepth = 0.0
  local paveDepth = 0.0
  local soilTheta = 0.0
  local storageDepth = 0.0
  local pervFrac = ((1.0 - G_theLidProc.pavement.impervFrac))
  local storageInflow = 0.0
  local availVolume = 0.0
  local maxRate = 0.0
  local paveVoidFrac = (G_theLidProc.pavement.voidFrac * pervFrac)
  local paveThickness = G_theLidProc.pavement.thickness
  local soilThickness = G_theLidProc.soil.thickness
  local soilPorosity = G_theLidProc.soil.porosity
  local soilFieldCap = G_theLidProc.soil.fieldCap
  local soilWiltPoint = G_theLidProc.soil.wiltPoint
  local storageThickness = G_theLidProc.storage.thickness
  local storageVoidFrac = G_theLidProc.storage.voidFrac
  surfaceDepth = x[SURF]
  paveDepth = x[PAVE]
  soilTheta = x[SOIL]
  storageDepth = x[STOR]
  G.SurfaceVolume = (surfaceDepth * G_theLidProc.surface.voidFrac)
  G.PaveVolume = (paveDepth * paveVoidFrac)
  G.SoilVolume = (soilTheta * soilThickness)
  G.StorageVolume = (storageDepth * storageVoidFrac)
  availVolume = (G.SoilVolume - (soilWiltPoint * soilThickness))
  F.lidproc_getEvapRates(G.SurfaceVolume, G.PaveVolume, availVolume, G.StorageVolume, pervFrac)
  if ((paveDepth >= paveThickness) or (((soilThickness > 0.0) and (soilTheta >= soilPorosity)))) then
    G.StorageEvap = 0.0
  end
  G.SurfaceInfil = (G.SurfaceInflow + ((G.SurfaceVolume / G.lidproc_Tstep)))
  G.PavePerc = (F.getPavementPermRate() * pervFrac)
  G.SurfaceInfil = (((((G.SurfaceInfil) <= (G.PavePerc))) and (G.SurfaceInfil) or (G.PavePerc)))
  maxRate = (((G.PaveVolume / G.lidproc_Tstep) + G.SurfaceInfil) - G.PaveEvap)
  maxRate = (((((maxRate) >= (0.0))) and (maxRate) or (0.0)))
  G.PavePerc = (((((G.PavePerc) <= (maxRate))) and (G.PavePerc) or (maxRate)))
  if (soilThickness > 0.0) then
    G.SoilPerc = F.getSoilPercRate(soilTheta)
    availVolume = (((soilTheta - soilFieldCap)) * soilThickness)
    maxRate = (((((((availVolume) >= (0.0))) and (availVolume) or (0.0))) / G.lidproc_Tstep) - G.SoilEvap)
    G.SoilPerc = (((((G.SoilPerc) <= (maxRate))) and (G.SoilPerc) or (maxRate)))
    G.SoilPerc = (((((G.SoilPerc) >= (0.0))) and (G.SoilPerc) or (0.0)))
  else
    G.SoilPerc = G.PavePerc
  end
  G.StorageExfil = F.getStorageExfilRate()
  G.StorageDrain = 0.0
  if (G_theLidProc.drain.coeff > 0.0) then
    G.StorageDrain = F.getStorageDrainRate(storageDepth, soilTheta, paveDepth, surfaceDepth)
  end
  if (((soilThickness == 0.0) and (storageDepth >= storageThickness)) and (paveDepth >= paveThickness)) then
    maxRate = ((G.StorageEvap + G.StorageDrain) + G.StorageExfil)
    if (G.PavePerc > maxRate) then
      G.PavePerc = maxRate
    else
      G.StorageExfil = (((((G.StorageExfil) <= (G.PavePerc))) and (G.StorageExfil) or (G.PavePerc)))
      G.StorageDrain = (G.PavePerc - G.StorageExfil)
    end
    G.SoilPerc = G.PavePerc
    G.SurfaceInfil = (((((G.SurfaceInfil) <= (G.PavePerc))) and (G.SurfaceInfil) or (G.PavePerc)))
  elseif ((((soilThickness > 0.0) and (storageDepth >= storageThickness)) and (soilTheta >= soilPorosity)) and (paveDepth >= paveThickness)) then
    maxRate = (G.StorageExfil + G.StorageDrain)
    if (G.SoilPerc < maxRate) then
      maxRate = G.SoilPerc
    else
      maxRate = (((((maxRate) <= (G.PavePerc))) and (maxRate) or (G.PavePerc)))
    end
    if (maxRate > G.StorageExfil) then
      G.StorageDrain = (maxRate - G.StorageExfil)
    else
      G.StorageExfil = maxRate
      G.StorageDrain = 0.0
    end
    G.SoilPerc = maxRate
    G.PavePerc = maxRate
    G.SurfaceInfil = (((((G.SurfaceInfil) <= (G.PavePerc))) and (G.SurfaceInfil) or (G.PavePerc)))
  elseif (((soilThickness > 0.0) and (storageDepth >= storageThickness)) and (soilTheta >= soilPorosity)) then
    maxRate = (G.StorageDrain + G.StorageExfil)
    if (G.SoilPerc > maxRate) then
      G.SoilPerc = maxRate
    else
      G.StorageExfil = (((((G.StorageExfil) <= (G.SoilPerc))) and (G.StorageExfil) or (G.SoilPerc)))
      G.StorageDrain = (G.SoilPerc - G.StorageExfil)
    end
    G.PavePerc = (((((G.PavePerc) <= (G.SoilPerc))) and (G.PavePerc) or (G.SoilPerc)))
    availVolume = (((paveThickness - paveDepth)) * paveVoidFrac)
    maxRate = (((availVolume / G.lidproc_Tstep) + G.PavePerc) + G.PaveEvap)
    G.SurfaceInfil = (((((G.SurfaceInfil) <= (maxRate))) and (G.SurfaceInfil) or (maxRate)))
  elseif (((soilThickness > 0.0) and (paveDepth >= paveThickness)) and (soilTheta >= soilPorosity)) then
    G.PavePerc = (((((G.PavePerc) <= (G.SoilPerc))) and (G.PavePerc) or (G.SoilPerc)))
    G.SoilPerc = G.PavePerc
    G.SurfaceInfil = (((((G.SurfaceInfil) <= (G.PavePerc))) and (G.SurfaceInfil) or (G.PavePerc)))
    maxRate = ((((((((G.StorageVolume / G.lidproc_Tstep) + G.SoilPerc) - G.StorageEvap)) >= (0.0))) and ((((G.StorageVolume / G.lidproc_Tstep) + G.SoilPerc) - G.StorageEvap)) or (0.0)))
    G.StorageExfil = (((((G.StorageExfil) <= (maxRate))) and (G.StorageExfil) or (maxRate)))
  else
    maxRate = ((G.SoilPerc - G.StorageEvap) + (G.StorageVolume / G.lidproc_Tstep))
    maxRate = (((((0.0) >= (maxRate))) and (0.0) or (maxRate)))
    G.StorageExfil = (((((G.StorageExfil) <= (maxRate))) and (G.StorageExfil) or (maxRate)))
    if (G.StorageDrain > 0.0) then
      maxRate = ((-G.StorageExfil) - G.StorageEvap)
      if (storageDepth >= storageThickness) then
        maxRate = (maxRate + G.SoilPerc)
      end
      if (G_theLidProc.drain.offset <= storageDepth) then
        maxRate = (maxRate + ((((storageDepth - G_theLidProc.drain.offset)) * storageVoidFrac) / G.lidproc_Tstep))
      end
      maxRate = (((((maxRate) >= (0.0))) and (maxRate) or (0.0)))
      G.StorageDrain = (((((G.StorageDrain) <= (maxRate))) and (G.StorageDrain) or (maxRate)))
    end
    availVolume = (((storageThickness - storageDepth)) * storageVoidFrac)
    maxRate = ((((availVolume / G.lidproc_Tstep) + G.StorageEvap) + G.StorageDrain) + G.StorageExfil)
    maxRate = (((((maxRate) >= (0.0))) and (maxRate) or (0.0)))
    if (soilThickness > 0.0) then
      G.SoilPerc = (((((G.SoilPerc) <= (maxRate))) and (G.SoilPerc) or (maxRate)))
      maxRate = (((((soilPorosity - soilTheta)) * soilThickness) / G.lidproc_Tstep) + G.SoilPerc)
    end
    G.PavePerc = (((((G.PavePerc) <= (maxRate))) and (G.PavePerc) or (maxRate)))
    availVolume = (((paveThickness - paveDepth)) * paveVoidFrac)
    maxRate = (((availVolume / G.lidproc_Tstep) + G.PavePerc) + G.PaveEvap)
    G.SurfaceInfil = (((((G.SurfaceInfil) <= (maxRate))) and (G.SurfaceInfil) or (maxRate)))
  end
  G.SurfaceOutflow = F.getSurfaceOutflowRate(surfaceDepth)
  f[SURF] = (((G.SurfaceInflow - G.SurfaceEvap) - G.SurfaceInfil) - G.SurfaceOutflow)
  f[PAVE] = ((((G.SurfaceInfil - G.PaveEvap) - G.PavePerc)) / paveVoidFrac)
  if (G_theLidProc.soil.thickness > 0.0) then
    f[SOIL] = ((((G.PavePerc - G.SoilEvap) - G.SoilPerc)) / soilThickness)
    storageInflow = G.SoilPerc
  else
    f[SOIL] = 0.0
    storageInflow = G.PavePerc
    G.SoilPerc = 0.0
  end
  f[STOR] = (((((storageInflow - G.StorageEvap) - G.StorageExfil) - G.StorageDrain)) / storageVoidFrac)
end

-- lidproc.c:1061
F.swaleFluxRates = function(x, f)
  local G_theLidProc, G_theLidUnit = G.theLidProc, G.theLidUnit
  local depth = 0.0
  local topWidth = 0.0
  local botWidth = 0.0
  local length = 0.0
  local surfInflow = 0.0
  local surfWidth = 0.0
  local surfArea = 0.0
  local flowArea = 0.0
  local lidArea = 0.0
  local hydRadius = 0.0
  local slope = 0.0
  local volume = 0.0
  local dVdT = 0.0
  local dStore = 0.0
  local xDepth = 0.0
  depth = x[SURF]
  depth = (((((depth) <= (G_theLidProc.surface.thickness))) and (depth) or (G_theLidProc.surface.thickness)))
  dStore = 0.0
  slope = G_theLidProc.surface.sideSlope
  topWidth = G_theLidUnit.fullWidth
  topWidth = (((((topWidth) >= (0.5))) and (topWidth) or (0.5)))
  botWidth = (topWidth - ((2.0 * slope) * G_theLidProc.surface.thickness))
  if (botWidth < 0.5) then
    botWidth = 0.5
    slope = ((0.5 * ((topWidth - 0.5))) / G_theLidProc.surface.thickness)
  end
  lidArea = G_theLidUnit.area
  length = (lidArea / topWidth)
  surfWidth = (botWidth + ((2.0 * slope) * depth))
  surfArea = (length * surfWidth)
  flowArea = (((depth * ((botWidth + (slope * depth))))) * G_theLidProc.surface.voidFrac)
  volume = (length * flowArea)
  surfInflow = (G.SurfaceInflow * lidArea)
  G.SurfaceEvap = (G.lidproc_EvapRate * surfArea)
  G.SurfaceEvap = (((((G.SurfaceEvap) <= ((volume / G.lidproc_Tstep)))) and (G.SurfaceEvap) or ((volume / G.lidproc_Tstep))))
  G.StorageExfil = (G.SurfaceInfil * surfArea)
  xDepth = (depth - dStore)
  if (xDepth <= 1e-10) then
    G.SurfaceOutflow = 0.0
  else
    flowArea = (flowArea - (((dStore * ((botWidth + (slope * dStore))))) * G_theLidProc.surface.voidFrac))
    if (flowArea < 1e-10) then
      G.SurfaceOutflow = 0.0
    else
      botWidth = (botWidth + ((2.0 * dStore) * slope))
      hydRadius = (botWidth + ((2.0 * xDepth) * m_sqrt((1.0 + (slope * slope)))))
      hydRadius = (flowArea / hydRadius)
      G.SurfaceOutflow = ((G_theLidProc.surface.alpha * flowArea) * (hydRadius ^ (2.0 / 3.0)))
    end
  end
  dVdT = (((surfInflow - G.SurfaceEvap) - G.StorageExfil) - G.SurfaceOutflow)
  if ((depth == G_theLidProc.surface.thickness) and (dVdT > 0.0)) then
    G.SurfaceOutflow = (G.SurfaceOutflow + dVdT)
    dVdT = 0.0
  end
  G.SurfaceEvap = (G.SurfaceEvap / lidArea)
  G.StorageExfil = (G.StorageExfil / lidArea)
  G.SurfaceOutflow = (G.SurfaceOutflow / lidArea)
  f[SURF] = (dVdT / surfArea)
  f[SOIL] = 0.0
  f[STOR] = 0.0
  G.SurfaceVolume = (volume / lidArea)
  G.SoilVolume = 0.0
  G.StorageVolume = 0.0
end

-- lidproc.c:1176
F.barrelFluxRates = function(x, f)
  local G_theLidProc = G.theLidProc
  local storageDepth = x[STOR]
  local head = 0.0
  local maxValue = 0.0
  G.SurfaceVolume = 0.0
  G.SoilVolume = 0.0
  G.StorageVolume = storageDepth
  G.SurfaceInfil = 0.0
  G.SurfaceOutflow = 0.0
  G.StorageDrain = 0.0
  if ((G_theLidProc.drain.delay == 0.0) or (G.theLidUnit.dryTime >= G_theLidProc.drain.delay)) then
    head = (storageDepth - G_theLidProc.drain.offset)
    if (head > 0.0) then
      G.StorageDrain = F.getStorageDrainRate(storageDepth, 0.0, 0.0, 0.0)
      maxValue = ((head / G.lidproc_Tstep))
      G.StorageDrain = (((((G.StorageDrain) <= (maxValue))) and (G.StorageDrain) or (maxValue)))
    end
  end
  G.StorageInflow = G.SurfaceInflow
  maxValue = ((((G_theLidProc.storage.thickness - storageDepth)) / G.lidproc_Tstep) + G.StorageDrain)
  G.StorageInflow = (((((G.StorageInflow) <= (maxValue))) and (G.StorageInflow) or (maxValue)))
  G.SurfaceInfil = G.StorageInflow
  f[SURF] = (G.SurfaceInflow - G.StorageInflow)
  f[STOR] = (G.StorageInflow - G.StorageDrain)
  f[SOIL] = 0.0
end

-- lidproc.c:1226
F.getSurfaceOutflowRate = function(depth)
  local G_theLidProc, G_theLidUnit = G.theLidProc, G.theLidUnit
  local delta = 0.0
  local outflow = 0.0
  delta = (depth - G_theLidProc.surface.thickness)
  if (delta < 0.0) then
    do return 0.0 end
  end
  outflow = (((G_theLidProc.surface.alpha * (delta ^ (5.0 / 3.0))) * G_theLidUnit.fullWidth) / G_theLidUnit.area)
  outflow = (((((outflow) <= ((delta / G.lidproc_Tstep)))) and (outflow) or ((delta / G.lidproc_Tstep))))
  do return outflow end
end

-- lidproc.c:1251
F.getPavementPermRate = function()
  local G_theLidProc, G_theLidUnit = G.theLidProc, G.theLidUnit
  local permReduction = 0.0
  local clogFactor = G_theLidProc.pavement.clogFactor
  local regenDays = G_theLidProc.pavement.regenDays
  if (clogFactor > 0.0) then
    if (regenDays > 0.0) then
      if (((G.OldRunoffTime / 1000.0) / 86400.0) >= G_theLidUnit.nextRegenDay) then
        G_theLidUnit.volTreated = (G_theLidUnit.volTreated * ((1.0 - G_theLidProc.pavement.regenDegree)))
        G_theLidUnit.nextRegenDay = (G_theLidUnit.nextRegenDay + regenDays)
      end
    end
    permReduction = (G_theLidUnit.volTreated / clogFactor)
    permReduction = (((((permReduction) <= (1.0))) and (permReduction) or (1.0)))
  end
  do return (G_theLidProc.pavement.kSat * ((1.0 - permReduction))) end
end

-- lidproc.c:1293
F.getSoilPercRate = function(theta)
  local G_theLidProc = G.theLidProc
  local delta = 0.0
  if (theta <= G_theLidProc.soil.fieldCap) then
    do return 0.0 end
  end
  delta = (G_theLidProc.soil.porosity - theta)
  do return (G_theLidProc.soil.kSat * m_exp(((-delta) * G_theLidProc.soil.kSlope))) end
end

-- lidproc.c:1313
F.getStorageExfilRate = function()
  local G_theLidProc = G.theLidProc
  local infil = 0.0
  local clogFactor = 0.0
  if (G_theLidProc.storage.kSat == 0.0) then
    do return 0.0 end
  end
  if (G.lidproc_MaxNativeInfil == 0.0) then
    do return 0.0 end
  end
  clogFactor = G_theLidProc.storage.clogFactor
  if (clogFactor > 0.0) then
    clogFactor = (G.theLidUnit.waterBalance.inflow / clogFactor)
    clogFactor = (((((clogFactor) <= (1.0))) and (clogFactor) or (1.0)))
  end
  infil = (G_theLidProc.storage.kSat * ((1.0 - clogFactor)))
  do return (((((infil) <= (G.lidproc_MaxNativeInfil))) and (infil) or (G.lidproc_MaxNativeInfil))) end
end

-- lidproc.c:1344
F.getStorageDrainRate = function(storageDepth, soilTheta, paveDepth, surfaceDepth)
  local G_theLidProc, G_theLidUnit = G.theLidProc, G.theLidUnit
  local curve = G_theLidProc.drain.qCurve
  local head = storageDepth
  local outflow = 0.0
  local paveThickness = G_theLidProc.pavement.thickness
  local soilThickness = G_theLidProc.soil.thickness
  local soilPorosity = G_theLidProc.soil.porosity
  local soilFieldCap = G_theLidProc.soil.fieldCap
  local storageThickness = G_theLidProc.storage.thickness
  if (storageDepth >= storageThickness) then
    if (soilThickness > 0.0) then
      if (soilTheta > soilFieldCap) then
        head = (head + ((((soilTheta - soilFieldCap)) / ((soilPorosity - soilFieldCap))) * soilThickness))
        if (soilTheta >= soilPorosity) then
          if (paveThickness > 0.0) then
            head = (head + paveDepth)
            if (paveDepth >= paveThickness) then
              head = (head + surfaceDepth)
            end
          else
            head = (head + surfaceDepth)
          end
        end
      end
    elseif (paveThickness > 0.0) then
      head = (head + paveDepth)
      if (paveDepth >= paveThickness) then
        head = (head + surfaceDepth)
      end
    end
  end
  if ((G_theLidUnit.oldDrainFlow == 0.0) and (head <= G_theLidProc.drain.hOpen)) then
    do return 0.0 end
  end
  if ((G_theLidUnit.oldDrainFlow > 0.0) and (head <= G_theLidProc.drain.hClose)) then
    do return 0.0 end
  end
  head = (head - G_theLidProc.drain.offset)
  if (head > 1e-10) then
    head = (head * (F.UCF(RAINDEPTH)))
    outflow = (G_theLidProc.drain.coeff * R.pow(head, G_theLidProc.drain.expon))
    if (curve >= 0) then
      outflow = (outflow * (F.table_lookup(G.Curve[curve], head)))
    end
    outflow = (outflow / (F.UCF(RAINFALL)))
  end
  do return outflow end
end

-- lidproc.c:1436
F.getDrainMatOutflow = function(depth)
  local G_theLidProc, G_theLidUnit = G.theLidProc, G.theLidUnit
  local result = G.SoilPerc
  if (G_theLidProc.drainMat.alpha > 0.0) then
    result = ((((G_theLidProc.drainMat.alpha * (depth ^ (5.0 / 3.0))) * G_theLidUnit.fullWidth) / G_theLidUnit.area) * G_theLidProc.drainMat.voidFrac)
  end
  do return result end
end

-- lidproc.c:1458
F.lidproc_getEvapRates = function(surfaceVol, paveVol, soilVol, storageVol, pervFrac)
  local availEvap = 0.0
  availEvap = G.lidproc_EvapRate
  G.SurfaceEvap = (((((availEvap) <= ((surfaceVol / G.lidproc_Tstep)))) and (availEvap) or ((surfaceVol / G.lidproc_Tstep))))
  G.SurfaceEvap = (((((0.0) >= (G.SurfaceEvap))) and (0.0) or (G.SurfaceEvap)))
  availEvap = (((((0.0) >= (((availEvap - G.SurfaceEvap))))) and (0.0) or (((availEvap - G.SurfaceEvap)))))
  availEvap = (availEvap * pervFrac)
  if (G.SurfaceInfil > 0.0) then
    G.PaveEvap = 0.0
    G.SoilEvap = 0.0
    G.StorageEvap = 0.0
  else
    G.PaveEvap = (((((availEvap) <= ((paveVol / G.lidproc_Tstep)))) and (availEvap) or ((paveVol / G.lidproc_Tstep))))
    availEvap = (((((0.0) >= (((availEvap - G.PaveEvap))))) and (0.0) or (((availEvap - G.PaveEvap)))))
    G.SoilEvap = (((((availEvap) <= ((soilVol / G.lidproc_Tstep)))) and (availEvap) or ((soilVol / G.lidproc_Tstep))))
    availEvap = (((((0.0) >= (((availEvap - G.SoilEvap))))) and (0.0) or (((availEvap - G.SoilEvap)))))
    G.StorageEvap = (((((availEvap) <= ((storageVol / G.lidproc_Tstep)))) and (availEvap) or ((storageVol / G.lidproc_Tstep))))
  end
end

-- lidproc.c:1503
F.getSurfaceOverflowRate = function(surfaceDepth, surfaceDepth__k)
  local G_theLidProc = G.theLidProc
  local delta = (surfaceDepth[surfaceDepth__k] - G_theLidProc.surface.thickness)
  if (delta <= 0.0) then
    do return 0.0 end
  end
  surfaceDepth[surfaceDepth__k] = G_theLidProc.surface.thickness
  do return ((delta * G_theLidProc.surface.voidFrac) / G.lidproc_Tstep) end
end

-- lidproc.c:1518
F.updateWaterBalance = function(lidUnit, inflow, evap, infil, surfFlow, drainFlow, storage)
  lidUnit.volTreated = (lidUnit.volTreated + (inflow * G.lidproc_Tstep))
  lidUnit.waterBalance.inflow = (lidUnit.waterBalance.inflow + (inflow * G.lidproc_Tstep))
  lidUnit.waterBalance.evap = (lidUnit.waterBalance.evap + (evap * G.lidproc_Tstep))
  lidUnit.waterBalance.infil = (lidUnit.waterBalance.infil + (infil * G.lidproc_Tstep))
  lidUnit.waterBalance.surfFlow = (lidUnit.waterBalance.surfFlow + (surfFlow * G.lidproc_Tstep))
  lidUnit.waterBalance.drainFlow = (lidUnit.waterBalance.drainFlow + (drainFlow * G.lidproc_Tstep))
  lidUnit.waterBalance.finalVol = storage
end

-- lidproc.c:1544
F.modpuls_solve = function(n, x, xOld, xPrev, xMin, xMax, xTol, qOld, q, dt, omega, derivs)
  local i = 0
  local canStop = 0
  local steps = 1
  local maxSteps = 20
  do
    i = 0
    while (i < n) do
      do
        xOld[i] = x[i]
        xPrev[i] = x[i]
      end
      i = i + 1
    end
  end
  while (steps < maxSteps) do
    do
      canStop = 1
      derivs(x, q)
      do
        i = 0
        while (i < n) do
          do
            x[i] = (xOld[i] + ((((omega * qOld[i]) + (((1.0 - omega)) * q[i]))) * dt))
            x[i] = (((((x[i]) <= (xMax[i]))) and (x[i]) or (xMax[i])))
            x[i] = (((((x[i]) >= (xMin[i]))) and (x[i]) or (xMin[i])))
            if ((omega > 0.0) and (m_abs((x[i] - xPrev[i])) > xTol[i])) then
              canStop = 0
            end
            xPrev[i] = x[i]
          end
          i = i + 1
        end
      end
      if (canStop ~= 0) then
        do return steps end
      end
      steps = steps + 1
    end
  end
  do return 0 end
end

