-- Generated from EPA SWMM 5.2.4 (forcmain.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local H_W <const> = 0
local D_W <const> = 1
local _ENV = R.strict

G.VISCOS = 1.1e-05

-- forcmain.c:37
F.forcemain_getEquivN = function(j, k)
  local G_Conduit = G.Conduit
  local xsect = T.copy_TXsect(G.Link[j].xsect)
  local f = 0.0
  local d = xsect.yFull
  do
    local __sw1 = G.ForceMainEqn
    if __sw1 == H_W then goto case2
    elseif __sw1 == D_W then goto case3
    else goto swend1 end
    ::case2::
    do
      do return ((1.067 / xsect.rBot) * ((d / G_Conduit[k].slope) ^ 0.04)) end
    end
    ::case3::
    do
      f = F.forcemain_getFricFactor(xsect.rBot, (d / 4.0), 1000000000000.0)
      do return (m_sqrt((f / 185.0)) * (d ^ ((1.0 / 6.0)))) end
    end
    ::swend1::
  end
  do return G_Conduit[k].roughness end
end

-- forcmain.c:64
F.forcemain_getRoughFactor = function(j, lengthFactor)
  local xsect = T.copy_TXsect(G.Link[j].xsect)
  local r = 0.0
  do
    local __sw1 = G.ForceMainEqn
    if __sw1 == H_W then goto case2
    elseif __sw1 == D_W then goto case3
    else goto swend1 end
    ::case2::
    do
      r = ((1.318 * xsect.rBot) * (lengthFactor ^ 0.54))
      do return (32.2 / (r ^ 1.852)) end
    end
    ::case3::
    do
      do return ((1.0 / 8.0) / lengthFactor) end
    end
    ::swend1::
  end
  do return 0.0 end
end

-- forcmain.c:88
F.forcemain_getFricSlope = function(j, v, hrad)
  local re = 0.0
  local f = 0.0
  local xsect = T.copy_TXsect(G.Link[j].xsect)
  do
    local __sw1 = G.ForceMainEqn
    if __sw1 == H_W then goto case2
    elseif __sw1 == D_W then goto case3
    else goto swend1 end
    ::case2::
    do
      do return ((xsect.sBot * (v ^ 0.852)) / (hrad ^ 1.1667)) end
    end
    ::case3::
    do
      re = F.forcemain_getReynolds(v, hrad)
      f = F.forcemain_getFricFactor(xsect.rBot, hrad, re)
      do return (((f * xsect.sBot) * v) / hrad) end
    end
    ::swend1::
  end
  do return 0.0 end
end

-- forcmain.c:117
F.forcemain_getReynolds = function(v, hrad)
  do return (((4.0 * hrad) * v) / G.VISCOS) end
end

-- forcmain.c:130
F.forcemain_getFricFactor = function(e, hrad, re)
  local f = 0.0
  if (re < 10.0) then
    re = 10.0
  end
  if (re <= 2000.0) then
    f = (64.0 / re)
  elseif (re < 4000.0) then
    f = F.forcemain_getFricFactor(e, hrad, 4000.0)
    f = (0.032 + ((((f - 0.032)) * ((re - 2000.0))) / 2000.0))
  else
    f = ((e / 3.7) / ((4.0 * hrad)))
    if (re < 10000000000.0) then
      f = (f + (5.74 / (re ^ 0.9)))
    end
    f = R.log10(f)
    f = ((0.25 / f) / f)
  end
  do return f end
end

