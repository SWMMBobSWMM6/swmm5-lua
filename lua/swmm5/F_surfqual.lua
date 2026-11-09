-- Generated from EPA SWMM 5.2.4 (surfqual.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local POLLUT <const> = 4
local LANDUSE <const> = 5
local LANDAREA <const> = 4
local BUILDUP_LOAD <const> = 0
local IMPERV0 <const> = 0
local SWEEPING_LOAD <const> = 2
local BMP_REMOVAL_LOAD <const> = 3
local RUNOFF_LOAD <const> = 5
local DEPOSITION_LOAD <const> = 1
local FINAL_LOAD <const> = 6
local INFIL_LOAD <const> = 4
local _ENV = R.strict


-- surfqual.c:65
F.surfqual_initState = function(j)
  local G_Nobjects, G_Subcatch = G.Nobjects, G.Subcatch
  local p = 0
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        G_Subcatch[j].oldQual[p] = 0.0
        G_Subcatch[j].newQual[p] = 0.0
        G_Subcatch[j].pondedQual[p] = 0.0
      end
      p = p + 1
    end
  end
  F.landuse_getInitBuildup(G_Subcatch[j].landFactor, G_Subcatch[j].initBuildup, G_Subcatch[j].area, G_Subcatch[j].curbLength)
end

-- surfqual.c:89
F.surfqual_getBuildup = function(j, tStep)
  local G_Nobjects, G_Subcatch, G_Pollut = G.Nobjects, G.Subcatch, G.Pollut
  local i = 0
  local p = 0
  local f = 0.0
  local area = 0.0
  local curb = 0.0
  local oldBuildup = 0.0
  local newBuildup = 0.0
  do
    i = 0
    while (i < G_Nobjects[LANDUSE]) do
      do
        f = G_Subcatch[j].landFactor[i].fraction
        if (f == 0.0) then
          goto continue1
        end
        area = ((f * G_Subcatch[j].area) * F.UCF(LANDAREA))
        curb = (f * G_Subcatch[j].curbLength)
        do
          p = 0
          while (p < G_Nobjects[POLLUT]) do
            do
              if ((G_Pollut[p].snowOnly ~= 0) and (G_Subcatch[j].newSnowDepth < (0.001 / 12.0))) then
                goto continue2
              end
              oldBuildup = G_Subcatch[j].landFactor[i].buildup[p]
              newBuildup = F.landuse_getBuildup(i, p, area, curb, oldBuildup, tStep)
              newBuildup = (((((newBuildup) >= (oldBuildup))) and (newBuildup) or (oldBuildup)))
              G_Subcatch[j].landFactor[i].buildup[p] = newBuildup
              F.massbal_updateLoadingTotals(BUILDUP_LOAD, p, ((newBuildup - oldBuildup)))
            end
            ::continue2::
            p = p + 1
          end
        end
      end
      ::continue1::
      i = i + 1
    end
  end
end

-- surfqual.c:137
F.surfqual_sweepBuildup = function(j, aDate)
  local G_Subcatch, G_Nobjects, G_Landuse = G.Subcatch, G.Nobjects, G.Landuse
  local i = 0
  local p = 0
  local oldBuildup = 0.0
  local newBuildup = 0.0
  if ((G_Subcatch[j].snowpack ~= (nil)) and (G_Subcatch[j].snowpack.wsnow[IMPERV0] > 0.004167)) then
    do return end
  end
  do
    i = 0
    while (i < G_Nobjects[LANDUSE]) do
      do
        if (G_Subcatch[j].landFactor[i].fraction == 0.0) then
          goto continue1
        end
        if (G_Landuse[i].sweepInterval == 0.0) then
          goto continue1
        end
        if ((aDate - G_Subcatch[j].landFactor[i].lastSwept) >= G_Landuse[i].sweepInterval) then
          G_Subcatch[j].landFactor[i].lastSwept = aDate
          do
            p = 0
            while (p < G_Nobjects[POLLUT]) do
              do
                oldBuildup = G_Subcatch[j].landFactor[i].buildup[p]
                newBuildup = (oldBuildup * ((1.0 - (G_Landuse[i].sweepRemoval * G_Landuse[i].washoffFunc[p].sweepEffic))))
                newBuildup = (((((oldBuildup) <= (newBuildup))) and (oldBuildup) or (newBuildup)))
                newBuildup = (((((0.0) >= (newBuildup))) and (0.0) or (newBuildup)))
                G_Subcatch[j].landFactor[i].buildup[p] = newBuildup
                F.massbal_updateLoadingTotals(SWEEPING_LOAD, p, (oldBuildup - newBuildup))
              end
              p = p + 1
            end
          end
        end
      end
      ::continue1::
      i = i + 1
    end
  end
end

-- surfqual.c:192
F.surfqual_getWashoff = function(j, runoff, tStep)
  local G_Subcatch, G_Nobjects, G_OutflowLoad, G_Pollut = G.Subcatch, G.Nobjects, G.OutflowLoad, G.Pollut
  local p = 0
  local hasOutflow = 0
  local cOut = 0.0
  local massLoad = 0.0
  local vLidRain = 0.0
  local vLidRunon = 0.0
  local vSurfOut = 0.0
  local vOut1 = 0.0
  local vOut2 = 0.0
  local area = 0.0
  area = G_Subcatch[j].area
  if ((G_Nobjects[POLLUT] == 0) or (area == 0.0)) then
    do return end
  end
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        G_OutflowLoad[p] = 0.0
      end
      p = p + 1
    end
  end
  F.findWashoffLoads(j, runoff)
  F.findPondedLoads(j, tStep)
  F.findLidLoads(j, tStep)
  vLidRain = ((G_Subcatch[j].rainfall * G_Subcatch[j].lidArea) * tStep)
  vLidRunon = 0.0
  if (area == G_Subcatch[j].lidArea) then
    vLidRunon = ((G_Subcatch[j].runon * area) * tStep)
  end
  vOut1 = ((G.Voutflow + vLidRain) + vLidRunon)
  vSurfOut = (G_Subcatch[j].newRunoff * tStep)
  vOut2 = (vSurfOut + G.VlidDrain)
  hasOutflow = (((vOut2 > ((2.31481e-08 * area) * tStep))) and 1 or 0)
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        cOut = 0.0
        if ((vOut1 > 0.0) and (hasOutflow ~= 0)) then
          cOut = (G_OutflowLoad[p] / vOut1)
        end
        if (G_Subcatch[j].lidArea > 0.0) then
          massLoad = ((cOut * ((vOut1 - vOut2))) * G_Pollut[p].mcf)
          if (massLoad > 0.0) then
            F.massbal_updateLoadingTotals(BMP_REMOVAL_LOAD, p, massLoad)
          end
        end
        massLoad = ((cOut * vOut2) * G_Pollut[p].mcf)
        G_Subcatch[j].totalLoad[p] = (G_Subcatch[j].totalLoad[p] + massLoad)
        if (((G_Subcatch[j].outNode >= 0) or (G_Subcatch[j].outSubcatch == j))) then
          massLoad = ((cOut * vSurfOut) * G_Pollut[p].mcf)
          F.massbal_updateLoadingTotals(RUNOFF_LOAD, p, massLoad)
        end
        G_Subcatch[j].newQual[p] = (cOut / 28.317)
      end
      p = p + 1
    end
  end
  if (G_Subcatch[j].lidArea > 0.0) then
    F.lid_addDrainLoads(j, G_Subcatch[j].newQual, tStep)
  end
end

-- surfqual.c:298
F.surfqual_getWtdWashoff = function(j, p, f)
  local G_Subcatch = G.Subcatch
  do return (((((1.0 - f)) * G_Subcatch[j].oldRunoff) * G_Subcatch[j].oldQual[p]) + ((f * G_Subcatch[j].newRunoff) * G_Subcatch[j].newQual[p])) end
end

-- surfqual.c:313
F.findPondedLoads = function(j, tStep)
  local G_Subcatch, G_Nobjects, G_Pollut, G_OutflowLoad = G.Subcatch, G.Nobjects, G.Pollut, G.OutflowLoad
  local p = 0
  local cPonded = 0.0
  local wPonded = 0.0
  local bmpRemoval = 0.0
  local vRain = 0.0
  local wRain = 0.0
  local wRunon = 0.0
  local wInfil = 0.0
  local wOutflow = 0.0
  local fullArea = 0.0
  local nonLidArea = 0.0
  if (G_Subcatch[j].area == G_Subcatch[j].lidArea) then
    do return end
  end
  fullArea = G_Subcatch[j].area
  nonLidArea = (fullArea - G_Subcatch[j].lidArea)
  vRain = ((G_Subcatch[j].rainfall * nonLidArea) * tStep)
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        wRain = ((G_Pollut[p].pptConcen * 28.317) * vRain)
        F.massbal_updateLoadingTotals(DEPOSITION_LOAD, p, (wRain * G_Pollut[p].mcf))
        if (G.Vinflow == 0.0) then
          F.massbal_updateLoadingTotals(FINAL_LOAD, p, (G_Subcatch[j].pondedQual[p] * G_Pollut[p].mcf))
          G_Subcatch[j].pondedQual[p] = 0.0
        else
          wRunon = (G_Subcatch[j].newQual[p] * tStep)
          wPonded = ((G_Subcatch[j].pondedQual[p] + wRain) + wRunon)
          cPonded = (wPonded / G.Vinflow)
          wInfil = (cPonded * G.Vinfil)
          wInfil = (((((wInfil) <= (wPonded))) and (wInfil) or (wPonded)))
          F.massbal_updateLoadingTotals(INFIL_LOAD, p, (wInfil * G_Pollut[p].mcf))
          wPonded = (wPonded - wInfil)
          wOutflow = (cPonded * G.Voutflow)
          wOutflow = (((((wOutflow) <= (wPonded))) and (wOutflow) or (wPonded)))
          wPonded = (wPonded - wOutflow)
          bmpRemoval = (F.landuse_getAvgBmpEffic(j, p) * wOutflow)
          F.massbal_updateLoadingTotals(BMP_REMOVAL_LOAD, p, (bmpRemoval * G_Pollut[p].mcf))
          wOutflow = (wOutflow - bmpRemoval)
          G_Subcatch[j].pondedQual[p] = ((cPonded * F.subcatch_getDepth(j)) * nonLidArea)
          G_OutflowLoad[p] = (G_OutflowLoad[p] + wOutflow)
        end
      end
      p = p + 1
    end
  end
end

-- surfqual.c:390
F.findWashoffLoads = function(j, runoff)
  local G_Subcatch, G_Nobjects, G_OutflowLoad, G_Pollut = G.Subcatch, G.Nobjects, G.OutflowLoad, G.Pollut
  local i = 0
  local p = 0
  local k = 0
  local w = 0.0
  local area = G_Subcatch[j].area
  if (runoff < 2.31481e-08) then
    do return end
  end
  do
    i = 0
    while (i < G_Nobjects[LANDUSE]) do
      do
        if (G_Subcatch[j].landFactor[i].fraction > 0.0) then
          do
            p = 0
            while (p < G_Nobjects[POLLUT]) do
              do
                G_OutflowLoad[p] = (G_OutflowLoad[p] + (F.landuse_getWashoffLoad(i, p, area, G_Subcatch[j].landFactor, runoff, G.Voutflow)))
              end
              p = p + 1
            end
          end
        end
      end
      i = i + 1
    end
  end
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        k = G_Pollut[p].coPollut
        if (k >= 0) then
          w = (G_Pollut[p].coFraction * G_OutflowLoad[k])
          F.massbal_updateLoadingTotals(BUILDUP_LOAD, p, (w * G_Pollut[p].mcf))
          G_OutflowLoad[p] = (G_OutflowLoad[p] + w)
        end
      end
      p = p + 1
    end
  end
end

-- surfqual.c:443
F.findLidLoads = function(j, tStep)
  local G_Subcatch, G_Nobjects, G_Pollut, G_OutflowLoad = G.Subcatch, G.Nobjects, G.Pollut, G.OutflowLoad
  local p = 0
  local useRunon = 0
  local lidArea = 0.0
  local vLidRain = 0.0
  local wLidRain = 0.0
  local wLidRunon = 0.0
  lidArea = G_Subcatch[j].lidArea
  if (lidArea == 0.0) then
    do return end
  end
  vLidRain = ((G_Subcatch[j].rainfall * lidArea) * tStep)
  useRunon = (((lidArea == G_Subcatch[j].area)) and 1 or 0)
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        wLidRain = ((G_Pollut[p].pptConcen * vLidRain) * 28.317)
        F.massbal_updateLoadingTotals(DEPOSITION_LOAD, p, (wLidRain * G_Pollut[p].mcf))
        if (useRunon ~= 0) then
          wLidRunon = (G_Subcatch[j].newQual[p] * tStep)
        else
          wLidRunon = 0.0
        end
        G_OutflowLoad[p] = (G_OutflowLoad[p] + (wLidRain + wLidRunon))
      end
      p = p + 1
    end
  end
end

