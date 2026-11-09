-- Generated from EPA SWMM 5.2.4 (culvert.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local CONDUIT <const> = 0
local C <const> = 3
local Y <const> = 4
local K_ <const> = 1
local M <const> = 2
local FORM <const> = 0
local _ENV = R.strict

G.MAX_CULVERT_CODE = 57
G.Params = {[0] = {[0] = 0.0, 0.0, 0.0, 0.0, 0.0}, {[0] = 1.0, 0.0098, 2.0, 0.0398, 0.67}, {[0] = 1.0, 0.0018, 2.0, 0.0292, 0.74}, {[0] = 1.0, 0.0045, 2.0, 0.0317, 0.69}, {[0] = 1.0, 0.0078, 2.0, 0.0379, 0.69}, {[0] = 1.0, 0.021, 1.33, 0.0463, 0.75}, {[0] = 1.0, 0.034, 1.5, 0.0553, 0.54}, {[0] = 1.0, 0.0018, 2.5, 0.03, 0.74}, {[0] = 1.0, 0.0018, 2.5, 0.0243, 0.83}, {[0] = 1.0, 0.026, 1.0, 0.0347, 0.81}, {[0] = 1.0, 0.061, 0.75, 0.04, 0.8}, {[0] = 1.0, 0.061, 0.75, 0.0423, 0.82}, {[0] = 2.0, 0.51, 0.667, 0.0309, 0.8}, {[0] = 2.0, 0.486, 0.667, 0.0249, 0.83}, {[0] = 2.0, 0.515, 0.667, 0.0375, 0.79}, {[0] = 2.0, 0.495, 0.667, 0.0314, 0.82}, {[0] = 2.0, 0.486, 0.667, 0.0252, 0.865}, {[0] = 2.0, 0.545, 0.667, 0.04505, 0.73}, {[0] = 2.0, 0.533, 0.667, 0.0425, 0.705}, {[0] = 2.0, 0.522, 0.667, 0.0402, 0.68}, {[0] = 2.0, 0.498, 0.667, 0.0327, 0.75}, {[0] = 2.0, 0.497, 0.667, 0.0339, 0.803}, {[0] = 2.0, 0.493, 0.667, 0.0361, 0.806}, {[0] = 2.0, 0.495, 0.667, 0.0386, 0.71}, {[0] = 2.0, 0.497, 0.667, 0.0302, 0.835}, {[0] = 2.0, 0.495, 0.667, 0.0252, 0.881}, {[0] = 2.0, 0.493, 0.667, 0.0227, 0.887}, {[0] = 1.0, 0.0083, 2.0, 0.0379, 0.69}, {[0] = 1.0, 0.0145, 1.75, 0.0419, 0.64}, {[0] = 1.0, 0.034, 1.5, 0.0496, 0.57}, {[0] = 1.0, 0.01, 2.0, 0.0398, 0.67}, {[0] = 1.0, 0.0018, 2.5, 0.0292, 0.74}, {[0] = 1.0, 0.0045, 2.0, 0.0317, 0.69}, {[0] = 1.0, 0.01, 2.0, 0.0398, 0.67}, {[0] = 1.0, 0.0018, 2.5, 0.0292, 0.74}, {[0] = 1.0, 0.0095, 2.0, 0.0317, 0.69}, {[0] = 1.0, 0.0083, 2.0, 0.0379, 0.69}, {[0] = 1.0, 0.03, 1.0, 0.0463, 0.75}, {[0] = 1.0, 0.034, 1.5, 0.0496, 0.57}, {[0] = 1.0, 0.03, 1.5, 0.0496, 0.57}, {[0] = 1.0, 0.0088, 2.0, 0.0368, 0.68}, {[0] = 1.0, 0.003, 2.0, 0.0269, 0.77}, {[0] = 1.0, 0.03, 1.5, 0.0496, 0.57}, {[0] = 1.0, 0.0088, 2.0, 0.0368, 0.68}, {[0] = 1.0, 0.003, 2.0, 0.0269, 0.77}, {[0] = 1.0, 0.0083, 2.0, 0.0379, 0.69}, {[0] = 1.0, 0.03, 1.0, 0.0473, 0.75}, {[0] = 1.0, 0.034, 1.5, 0.0496, 0.57}, {[0] = 2.0, 0.534, 0.555, 0.0196, 0.9}, {[0] = 2.0, 0.519, 0.64, 0.021, 0.9}, {[0] = 2.0, 0.536, 0.622, 0.0368, 0.83}, {[0] = 2.0, 0.5035, 0.719, 0.0478, 0.8}, {[0] = 2.0, 0.547, 0.8, 0.0598, 0.75}, {[0] = 2.0, 0.475, 0.667, 0.0179, 0.97}, {[0] = 2.0, 0.56, 0.667, 0.0446, 0.85}, {[0] = 2.0, 0.56, 0.667, 0.0378, 0.87}, {[0] = 2.0, 0.5, 0.667, 0.0446, 0.65}, {[0] = 2.0, 0.5, 0.667, 0.0378, 0.71}}

-- culvert.c:174
F.culvert_getInflow = function(j, q0, h)
  local G_Link, G_Conduit, G_Params = G.Link, G.Conduit, G.Params
  local code = 0
  local k = 0
  local condition = 0
  local y = 0.0
  local y1 = 0.0
  local y2 = 0.0
  local q = 0.0
  local culvert = T.TCulvert()
  if (G_Link[j].type_ ~= CONDUIT) then
    do return q0 end
  end
  culvert.xsect = G_Link[j].xsect
  code = culvert.xsect.culvertCode
  if ((code <= 0) or (code > G.MAX_CULVERT_CODE)) then
    do return q0 end
  end
  k = G_Link[j].subIndex
  culvert.yFull = culvert.xsect.yFull
  culvert.ad = (culvert.xsect.aFull * m_sqrt(culvert.yFull))
  do
    local __sw1 = code
    if __sw1 == 5 or __sw1 == 37 or __sw1 == 46 then goto case2
    else goto case3 end
    ::case2::
    do
      culvert.scf = ((-7.0) * G_Conduit[k].slope)
      goto swend1
    end
    ::case3::
    do
      culvert.scf = (0.5 * G_Conduit[k].slope)
    end
    ::swend1::
  end
  y = (h - ((G.Node[G_Link[j].node1].invertElev + G_Link[j].offset1)))
  y2 = (culvert.yFull * ((((16.0 * G_Params[code][C]) + G_Params[code][Y]) - culvert.scf)))
  if (y >= y2) then
    q = F.getSubmergedFlow(code, y, culvert)
    condition = 2
  else
    y1 = (0.95 * culvert.yFull)
    if (y <= y1) then
      q = F.getUnsubmergedFlow(code, y, culvert)
      condition = 1
    else
      q = F.getTransitionFlow(code, y, y1, y2, culvert)
      condition = 0
    end
  end
  if (q < q0) then
    G_Link[j].inletControl = 1
    G_Link[j].dqdh = culvert.dQdH
    do return q end
  else
    do return q0 end
  end
end

-- culvert.c:257
F.getUnsubmergedFlow = function(code, h, culvert)
  local G_Params = G.Params
  local arg = 0.0
  local q = 0.0
  culvert.kk = G_Params[code][K_]
  culvert.mm = G_Params[code][M]
  arg = ((h / culvert.yFull) / culvert.kk)
  if (G_Params[code][FORM] == 1.0) then
    q = F.getForm1Flow(h, culvert)
  else
    q = (culvert.ad * R.pow(arg, (1.0 / culvert.mm)))
  end
  culvert.dQdH = ((q / h) / culvert.mm)
  do return q end
end

-- culvert.c:288
F.getSubmergedFlow = function(code, h, culvert)
  local G_Params = G.Params
  local cc = G_Params[code][C]
  local yy = G_Params[code][Y]
  local arg = (((((h / culvert.yFull) - yy) + culvert.scf)) / cc)
  local q = 0.0
  if (arg <= 0.0) then
    culvert.dQdH = 0.0
    do return 10000000000.0 end
  end
  q = (m_sqrt(arg) * culvert.ad)
  culvert.dQdH = ((((0.5 * q) / arg) / culvert.yFull) / cc)
  do return q end
end

-- culvert.c:316
F.getTransitionFlow = function(code, h, h1, h2, culvert)
  local q1 = F.getUnsubmergedFlow(code, h1, culvert)
  local q2 = F.getSubmergedFlow(code, h2, culvert)
  local q = (q1 + ((((q2 - q1)) * ((h - h1))) / ((h2 - h1))))
  culvert.dQdH = (((q2 - q1)) / ((h2 - h1)))
  do return q end
end

-- culvert.c:339
F.getForm1Flow = function(h, culvert)
  culvert.hPlus = ((h / culvert.yFull) + culvert.scf)
  F.findroot_Ridder((0.01 * h), h, 0.001, F.form1Eqn, culvert)
  do return culvert.qc end
end

-- culvert.c:363
F.form1Eqn = function(yc, p)
  local ac = 0.0
  local wc = 0.0
  local yh = 0.0
  local culvert = p
  ac = F.xsect_getAofY(culvert.xsect, yc)
  wc = F.xsect_getWofY(culvert.xsect, yc)
  yh = (ac / wc)
  culvert.qc = (ac * m_sqrt((32.2 * yh)))
  do return (((culvert.hPlus - (yc / culvert.yFull)) - ((yh / 2.0) / culvert.yFull)) - (culvert.kk * R.pow((culvert.qc / culvert.ad), culvert.mm))) end
end

