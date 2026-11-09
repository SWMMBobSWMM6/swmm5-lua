-- Generated from EPA SWMM 5.2.4 (kinwave.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local CONDUIT <const> = 0
local DUMMY <const> = 0
local KW <const> = 2
local ERR_KINWAVE <const> = 103
local _ENV = R.strict

G.WX = 0.6
G.WT = 0.6
G.EPSIL = 0.001
G.Beta1 = 0.0
G.C1 = 0.0
G.C2 = 0.0
G.Afull = 0.0
G.Qfull = 0.0
G.pXsect = nil

-- kinwave.c:57
F.kinwave_execute = function(j, qinflow, qinflow__k, qoutflow, qoutflow__k, tStep)
  local G_Link, G_Conduit = G.Link, G.Conduit
  local k = 0
  local result = 1
  local dxdt = 0.0
  local dq = 0.0
  local ain = 0.0
  local aout = {0.0}
  local qin = 0.0
  local qout = 0.0
  local a1 = 0.0
  local a2 = 0.0
  local q1 = 0.0
  local q2 = 0.0
  local q3 = 0.0
  qoutflow[qoutflow__k] = (qinflow[qinflow__k])
  if (G_Link[j].type_ ~= CONDUIT) then
    do return result end
  end
  if (G_Link[j].xsect.type_ == DUMMY) then
    do return result end
  end
  G.pXsect = G_Link[j].xsect
  G.Qfull = G_Link[j].qFull
  G.Afull = G_Link[j].xsect.aFull
  k = G_Link[j].subIndex
  G.Beta1 = (G_Conduit[k].beta / G.Qfull)
  q1 = (G_Conduit[k].q1 / G.Qfull)
  q2 = (G_Conduit[k].q2 / G.Qfull)
  qin = (((qinflow[qinflow__k]) / (G_Conduit[k].barrels * 1.0)) / G.Qfull)
  q3 = (F.link_getLossRate(j, KW, (qin * G.Qfull), tStep) / G.Qfull)
  a1 = (G_Conduit[k].a1 / G.Afull)
  a2 = (G_Conduit[k].a2 / G.Afull)
  if (qin >= 1.0) then
    ain = 1.0
  else
    ain = (F.xsect_getAofS(G.pXsect, (qin / G.Beta1)) / G.Afull)
  end
  if ((qin <= 1e-06) and (q2 <= 1e-06)) then
    qout = 0.0
    aout[1] = 0.0
  else
    dxdt = (((F.link_getLength(j) / tStep) * G.Afull) / G.Qfull)
    dq = (q2 - q1)
    G.C1 = ((dxdt * G.WT) / G.WX)
    G.C2 = (((1.0 - G.WT)) * ((ain - a1)))
    G.C2 = (G.C2 - (G.WT * a2))
    G.C2 = ((G.C2 * dxdt) / G.WX)
    G.C2 = ((G.C2 + ((((1.0 - G.WX)) / G.WX) * dq)) - qin)
    G.C2 = (G.C2 + (q3 / G.WX))
    aout[1] = a2
    result = F.solveContinuity(qin, ain, aout, 1)
    if (result == (-1)) then
      F.report_writeErrorMsg(ERR_KINWAVE, G_Link[j].ID)
      do return 1 end
    end
    if (result <= 0) then
      result = 1
    end
    qout = (G.Beta1 * F.xsect_getSofA(G.pXsect, (aout[1] * G.Afull)))
    if (qin > 1.0) then
      qin = 1.0
    end
  end
  G_Conduit[k].q1 = (qin * G.Qfull)
  G_Conduit[k].a1 = (ain * G.Afull)
  G_Conduit[k].q2 = (qout * G.Qfull)
  G_Conduit[k].a2 = (aout[1] * G.Afull)
  G_Conduit[k].fullState = F.link_getFullState(G_Conduit[k].a1, G_Conduit[k].a2, G.Afull)
  qinflow[qinflow__k] = (G_Conduit[k].q1 * (G_Conduit[k].barrels * 1.0))
  qoutflow[qoutflow__k] = (G_Conduit[k].q2 * (G_Conduit[k].barrels * 1.0))
  do return result end
end

-- kinwave.c:170
F.solveContinuity = function(qin, ain, aout, aout__k)
  local G_pXsect = G.pXsect
  local n = 0
  local aLo = 0.0
  local aHi = 0.0
  local aTmp = 0.0
  local fLo = 0.0
  local fHi = 0.0
  local tol = G.EPSIL
  aHi = 1.0
  fHi = ((1.0 + G.C1) + G.C2)
  aLo = (F.xsect_getAmax(G_pXsect) / G.Afull)
  if (aLo < aHi) then
    fLo = ((((G.Beta1 * G_pXsect.sMax)) + ((G.C1 * aLo))) + G.C2)
  else
    fLo = fHi
  end
  if ((fHi * fLo) > 0.0) then
    aHi = aLo
    fHi = fLo
    aLo = 0.0
    fLo = G.C2
  end
  if ((fHi * fLo) <= 0.0) then
    if ((aout[aout__k] < aLo) or (aout[aout__k] > aHi)) then
      aout[aout__k] = (0.5 * ((aLo + aHi)))
    end
    if (fLo > fHi) then
      aTmp = aLo
      aLo = aHi
      aHi = aTmp
    end
    n = F.findroot_Newton(aLo, aHi, aout, aout__k, tol, F.evalContinuity, (nil))
    if (n <= 0) then
      n = (-1)
    end
  elseif (fLo < 0.0) then
    if (qin > 1.0) then
      aout[aout__k] = ain
    else
      aout[aout__k] = 1.0
    end
    n = (-2)
  elseif (fLo > 0.0) then
    aout[aout__k] = 0.0
    n = (-3)
  else
    n = (-1)
  end
  do return n end
end

-- kinwave.c:261
F.evalContinuity = function(a, f, f__k, df, df__k, p)
  local G_pXsect = G.pXsect
  f[f__k] = ((((G.Beta1 * F.xsect_getSofA(G_pXsect, (a * G.Afull)))) + ((G.C1 * a))) + G.C2)
  df[df__k] = ((((G.Beta1 * G.Afull) * F.xsect_getdSdA(G_pXsect, (a * G.Afull)))) + G.C1)
end

