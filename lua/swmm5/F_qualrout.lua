-- Generated from EPA SWMM 5.2.4 (qualrout.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local NODE <const> = 2
local POLLUT <const> = 4
local LINK <const> = 3
local STORAGE <const> = 2
local DW <const> = 4
local CONDUIT <const> = 0
local DUMMY <const> = 0
local SF <const> = 1
local _ENV = R.strict

G.ZeroVolume = 0.0353147
G.ZeroDepth = 0.003281

-- qualrout.c:63
F.qualrout_init = function()
  local G_Nobjects, G_Node, G_Pollut, G_Link = G.Nobjects, G.Node, G.Pollut, G.Link
  local i = 0
  local p = 0
  local isWet = 0
  local c = 0.0
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        isWet = (((G_Node[i].newDepth > G.ZeroDepth)) and 1 or 0)
        do
          p = 0
          while (p < G_Nobjects[POLLUT]) do
            do
              c = 0.0
              if (isWet ~= 0) then
                c = G_Pollut[p].initConcen
              end
              G_Node[i].oldQual[p] = c
              G_Node[i].newQual[p] = c
            end
            p = p + 1
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
        isWet = (((G_Link[i].newDepth > G.ZeroDepth)) and 1 or 0)
        do
          p = 0
          while (p < G_Nobjects[POLLUT]) do
            do
              c = 0.0
              if (isWet ~= 0) then
                c = G_Pollut[p].initConcen
              end
              G_Link[i].oldQual[p] = c
              G_Link[i].newQual[p] = c
            end
            p = p + 1
          end
        end
      end
      i = i + 1
    end
  end
end

-- qualrout.c:100
F.qualrout_execute = function(tStep)
  local G_Nobjects, G_Node = G.Nobjects, G.Node
  local i = 0
  local j = 0
  local qIn = 0.0
  local vAvg = 0.0
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        F.findLinkMassFlow(i, tStep)
      end
      i = i + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        G_Node[j].qualInflow = G_Node[j].inflow
        qIn = G_Node[j].qualInflow
        vAvg = (((G_Node[j].oldVolume + G_Node[j].newVolume)) / 2.0)
        if (G_Node[j].treatment ~= nil) then
          if (qIn < 1e-10) then
            qIn = 0.0
          end
          F.treatmnt_setInflow(qIn, G_Node[j].newQual)
        end
        if ((G_Node[j].type_ == STORAGE) or (G_Node[j].oldVolume > G.ZeroVolume)) then
          F.findStorageQual(j, tStep)
        else
          F.findNodeQual(j)
        end
        if (G_Node[j].treatment ~= nil) then
          F.treatmnt_treat(j, qIn, vAvg, tStep)
        end
      end
      j = j + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        F.findLinkQual(i, tStep)
      end
      i = i + 1
    end
  end
end

-- qualrout.c:146
F.getMixedQual = function(c, v1, wIn, qIn, tStep)
  local vIn = 0.0
  local cIn = 0.0
  local cMax = 0.0
  if (qIn <= 1e-10) then
    do return c end
  end
  vIn = (qIn * tStep)
  cIn = ((wIn * tStep) / vIn)
  cMax = (((((c) >= (cIn))) and (c) or (cIn)))
  c = ((((c * v1) + (wIn * tStep))) / ((v1 + vIn)))
  c = (((((c) <= (cMax))) and (c) or (cMax)))
  c = (((((c) >= (0.0))) and (c) or (0.0)))
  do return c end
end

-- qualrout.c:179
F.findLinkMassFlow = function(i, tStep)
  local G_Link, G_Nobjects, G_Node = G.Link, G.Nobjects, G.Node
  local j = 0
  local p = 0
  local qLink = 0.0
  local w = 0.0
  qLink = G_Link[i].newFlow
  j = G_Link[i].node2
  if (qLink < 0.0) then
    j = G_Link[i].node1
  end
  qLink = m_abs(qLink)
  if (G.RouteModel ~= DW) then
    qLink = (qLink - (F.inlet_capturedFlow(i)))
  end
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        w = (qLink * G_Link[i].oldQual[p])
        G_Node[j].newQual[p] = (G_Node[j].newQual[p] + w)
        G_Link[i].totalLoad[p] = (G_Link[i].totalLoad[p] + (w * tStep))
      end
      p = p + 1
    end
  end
  G_Node[j].qualInflow = (G_Node[j].qualInflow + qLink)
end

-- qualrout.c:221
F.findNodeQual = function(j)
  local G_Node, G_Nobjects = G.Node, G.Nobjects
  local p = 0
  local qNode = 0.0
  qNode = G_Node[j].qualInflow
  if (qNode > 1e-10) then
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          G_Node[j].newQual[p] = (G_Node[j].newQual[p] / qNode)
        end
        p = p + 1
      end
    end
  else
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          if (G_Node[j].newDepth > G.ZeroDepth) then
            G_Node[j].newQual[p] = G_Node[j].oldQual[p]
          else
            G_Node[j].newQual[p] = 0.0
          end
        end
        p = p + 1
      end
    end
  end
end

-- qualrout.c:253
F.findLinkQual = function(i, tStep)
  local G_Link, G_Nobjects, G_Node, G_Conduit = G.Link, G.Nobjects, G.Node, G.Conduit
  local j = 0
  local k = 0
  local p = 0
  local wIn = 0.0
  local qIn = 0.0
  local qSeep = 0.0
  local v1 = 0.0
  local v2 = 0.0
  local c1 = 0.0
  local c2 = 0.0
  local vEvap = 0.0
  local vLosses = 0.0
  local fEvap = 0.0
  local barrels = 0.0
  j = G_Link[i].node1
  if (G_Link[i].newFlow < 0.0) then
    j = G_Link[i].node2
  end
  if ((G_Link[i].type_ ~= CONDUIT) or (G_Link[i].xsect.type_ == DUMMY)) then
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          G_Link[i].newQual[p] = G_Node[j].newQual[p]
        end
        p = p + 1
      end
    end
    do return end
  end
  k = G_Link[i].subIndex
  barrels = (G_Conduit[k].barrels * 1.0)
  qIn = (m_abs(G_Conduit[k].q1) * barrels)
  qSeep = (G_Conduit[k].seepLossRate * barrels)
  vEvap = ((G_Conduit[k].evapLossRate * barrels) * tStep)
  v1 = G_Link[i].oldVolume
  v2 = G_Link[i].newVolume
  vLosses = ((qSeep * tStep) + vEvap)
  fEvap = 1.0
  if ((vEvap > 0.0) and (v1 > G.ZeroVolume)) then
    fEvap = (fEvap + (vEvap / v1))
  end
  if (G.RouteModel == SF) then
    F.findSFLinkQual(i, qSeep, fEvap, tStep)
    do return end
  end
  if (G.RouteModel == DW) then
    qIn = (qIn + ((((v2 + vLosses) - v1)) / tStep))
    qIn = (((((qIn) >= (0.0))) and (qIn) or (0.0)))
  end
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        c1 = G_Link[i].oldQual[p]
        F.massbal_addSeepageLoss(p, (qSeep * c1))
        c1 = (c1 * fEvap)
        c2 = F.getReactedQual(p, c1, v1, tStep)
        wIn = (G_Node[j].newQual[p] * qIn)
        c2 = F.getMixedQual(c2, v1, wIn, qIn, tStep)
        if ((v2 < G.ZeroVolume) or (G_Link[i].newDepth <= G.ZeroDepth)) then
          F.massbal_addToFinalStorage(p, (c2 * v2))
          c2 = 0.0
        end
        G_Link[i].newQual[p] = c2
      end
      p = p + 1
    end
  end
end

-- qualrout.c:357
F.findSFLinkQual = function(i, qSeep, fEvap, tStep)
  local G_Link, G_Nobjects, G_Node, G_Pollut = G.Link, G.Nobjects, G.Node, G.Pollut
  local j = G_Link[i].node1
  local p = 0
  local c1 = 0.0
  local c2 = 0.0
  local lossRate = 0.0
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        c1 = G_Node[j].newQual[p]
        F.massbal_addSeepageLoss(p, (qSeep * c1))
        c1 = (c1 * fEvap)
        c2 = c1
        if (G_Pollut[p].kDecay > 0.0) then
          c2 = (c1 * m_exp(((-G_Pollut[p].kDecay) * tStep)))
          c2 = (((((0.0) >= (c2))) and (0.0) or (c2)))
          lossRate = (((c1 - c2)) * G_Link[i].newFlow)
          F.massbal_addReactedMass(p, lossRate)
        end
        G_Link[i].newQual[p] = c2
      end
      p = p + 1
    end
  end
end

-- qualrout.c:398
F.findStorageQual = function(j, tStep)
  local G_Node, G_Storage, G_Nobjects = G.Node, G.Storage, G.Nobjects
  local p = 0
  local k = 0
  local qIn = 0.0
  local wIn = 0.0
  local v1 = 0.0
  local c1 = 0.0
  local c2 = 0.0
  local qExfil = 0.0
  local vEvap = 0.0
  local fEvap = 1.0
  qIn = G_Node[j].qualInflow
  v1 = G_Node[j].oldVolume
  if (G_Node[j].type_ == STORAGE) then
    F.updateHRT(j, G_Node[j].oldVolume, qIn, tStep)
    k = G_Node[j].subIndex
    qExfil = (G_Storage[k].exfilLoss / tStep)
    vEvap = G_Storage[k].evapLoss
    if ((vEvap > 0.0) and (v1 > G.ZeroVolume)) then
      fEvap = (fEvap + (vEvap / v1))
    end
  end
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        c1 = G_Node[j].oldQual[p]
        F.massbal_addSeepageLoss(p, (qExfil * c1))
        c1 = (c1 * fEvap)
        if ((G_Node[j].treatment == (nil)) or (G_Node[j].treatment[p].equation == (nil))) then
          c1 = F.getReactedQual(p, c1, v1, tStep)
        end
        wIn = G_Node[j].newQual[p]
        c2 = F.getMixedQual(c1, v1, wIn, qIn, tStep)
        if ((((G_Node[j].newVolume <= G.ZeroVolume) or (G_Node[j].newDepth <= G.ZeroDepth))) and (qIn <= 1e-10)) then
          F.massbal_addToFinalStorage(p, (c2 * G_Node[j].newVolume))
          c2 = 0.0
        end
        G_Node[j].newQual[p] = c2
      end
      p = p + 1
    end
  end
end

-- qualrout.c:478
F.updateHRT = function(j, v, q, tStep)
  local G_Storage = G.Storage
  local k = G.Node[j].subIndex
  local hrt = G_Storage[k].hrt
  if (v < 1e-10) then
    hrt = 0.0
  else
    hrt = ((((hrt + tStep)) * v) / ((v + (q * tStep))))
  end
  G_Storage[k].hrt = (((((hrt) >= (0.0))) and (hrt) or (0.0)))
end

-- qualrout.c:498
F.getReactedQual = function(p, c, v1, tStep)
  local c2 = 0.0
  local lossRate = 0.0
  local kDecay = G.Pollut[p].kDecay
  if (kDecay == 0.0) then
    do return c end
  end
  c2 = (c * ((1.0 - (kDecay * tStep))))
  c2 = (((((0.0) >= (c2))) and (0.0) or (c2)))
  lossRate = ((((c - c2)) * v1) / tStep)
  F.massbal_addReactedMass(p, lossRate)
  do return c2 end
end

