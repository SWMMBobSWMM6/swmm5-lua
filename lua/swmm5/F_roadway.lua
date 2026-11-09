-- Generated from EPA SWMM 5.2.4 (roadway.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local WEIR <const> = 3
local SI <const> = 1
local SUBCRITICAL <const> = 3
local DN_CRITICAL <const> = 6
local UP_CRITICAL <const> = 5
local PAVED <const> = 1
local _ENV = R.strict

G.N_Cr_Low_Paved = 4
G.Cr_Low_Paved = {[0] = {[0] = 0.0, 2.85}, {[0] = 0.2, 2.95}, {[0] = 0.7, 3.03}, {[0] = 4.0, 3.05}}
G.N_Cr_Low_Gravel = 8
G.Cr_Low_Gravel = {[0] = {[0] = 0.0, 2.5}, {[0] = 0.5, 2.7}, {[0] = 1.0, 2.8}, {[0] = 1.5, 2.9}, {[0] = 2.0, 2.98}, {[0] = 2.5, 3.02}, {[0] = 3.0, 3.03}, {[0] = 4.0, 3.05}}
G.N_Cr_High_Paved = 2
G.Cr_High_Paved = {[0] = {[0] = 0.15, 3.05}, {[0] = 0.25, 3.1}}
G.N_Cr_High_Gravel = 2
G.Cr_High_Gravel = {[0] = {[0] = 0.15, 2.95}, {[0] = 0.3, 3.1}}
G.N_Kt_Paved = 9
G.Kt_Paved = {[0] = {[0] = 0.8, 1.0}, {[0] = 0.85, 0.98}, {[0] = 0.9, 0.92}, {[0] = 0.93, 0.85}, {[0] = 0.95, 0.8}, {[0] = 0.97, 0.7}, {[0] = 0.98, 0.6}, {[0] = 0.99, 0.5}, {[0] = 1.0, 0.4}}
G.N_Kt_Gravel = 12
G.Kt_Gravel = {[0] = {[0] = 0.75, 1.0}, {[0] = 0.8, 0.985}, {[0] = 0.83, 0.97}, {[0] = 0.86, 0.93}, {[0] = 0.89, 0.9}, {[0] = 0.9, 0.87}, {[0] = 0.92, 0.8}, {[0] = 0.94, 0.7}, {[0] = 0.96, 0.6}, {[0] = 0.98, 0.5}, {[0] = 0.99, 0.4}, {[0] = 1.0, 0.24}}

-- roadway.c:85
F.roadway_getInflow = function(j, dir, hRoad, h1, h2)
  local G_Link, G_Weir = G.Link, G.Weir
  local k = 0
  local roadSurf = 0
  local useVariableCd = 0
  local length = 0.0
  local roadWidth = 0.0
  local hWr = 0.0
  local ht = 0.0
  local cD = 0.0
  local q = 0.0
  local dqdh = 0.0
  if (G_Link[j].type_ ~= WEIR) then
    do return 0.0 end
  end
  k = G_Link[j].subIndex
  roadWidth = G_Weir[k].roadWidth
  roadSurf = G_Weir[k].roadSurface
  cD = G_Weir[k].cDisch1
  if (G.UnitSystem == SI) then
    cD = (cD / 0.552)
  end
  useVariableCd = 0
  if ((roadWidth > 0.0) and (roadSurf >= 1)) then
    useVariableCd = 1
  end
  hWr = (h1 - hRoad)
  ht = (h2 - hRoad)
  if (hWr > 0.0001) then
    if (useVariableCd ~= 0) then
      cD = F.getCd(hWr, ht, roadWidth, roadSurf)
    end
    length = G_Link[j].xsect.wMax
    q = ((cD * length) * (hWr ^ 1.5))
    dqdh = ((1.5 * q) / hWr)
  end
  G_Link[j].dqdh = dqdh
  G_Link[j].newDepth = ((((((h1 - hRoad)) >= (0.0))) and ((h1 - hRoad)) or (0.0)))
  G_Link[j].flowClass = SUBCRITICAL
  if (hRoad > h2) then
    if (dir == 1.0) then
      G_Link[j].flowClass = DN_CRITICAL
    else
      G_Link[j].flowClass = UP_CRITICAL
    end
  end
  do return (dir * q) end
end

-- roadway.c:146
F.getCd = function(hWr, ht, roadWidth, roadSurf)
  local kT = 1.0
  local hL = 0.0
  local htH = 0.0
  local cR = 0.0
  if (hWr <= 0.0) then
    do return 0.0 end
  end
  hL = (hWr / roadWidth)
  if (hL <= 0.15) then
    if (roadSurf == PAVED) then
      cR = F.getY(hWr, G.Cr_Low_Paved, G.N_Cr_Low_Paved)
    else
      cR = F.getY(hWr, G.Cr_Low_Gravel, G.N_Cr_Low_Gravel)
    end
  else
    if (roadSurf == PAVED) then
      cR = F.getY(hL, G.Cr_High_Paved, G.N_Cr_High_Paved)
    else
      cR = F.getY(hL, G.Cr_High_Gravel, G.N_Cr_High_Gravel)
    end
  end
  if (ht > 0.0) then
    htH = (ht / hWr)
    if (roadSurf == PAVED) then
      kT = F.getY(htH, G.Kt_Paved, G.N_Kt_Paved)
    else
      kT = F.getY(htH, G.Kt_Gravel, G.N_Kt_Gravel)
    end
  end
  do return (cR * kT) end
end

-- roadway.c:176
F.getY = function(x, table_, n)
  local i = 0
  local x1 = 0.0
  local y1 = 0.0
  local dx = 0.0
  local dy = 0.0
  if (x <= table_[0][0]) then
    do return table_[0][1] end
  end
  if (x >= (table_[(n - 1)])[0]) then
    do return (table_[(n - 1)])[1] end
  end
  do
    i = 1
    while (i < n) do
      do
        if (x <= table_[i][0]) then
          x1 = (table_[(i - 1)])[0]
          dx = (table_[i][0] - x1)
          y1 = (table_[(i - 1)])[1]
          dy = (table_[i][1] - y1)
          do return (y1 + ((((x - x1)) * dy) / dx)) end
        end
      end
      i = i + 1
    end
  end
  do return (table_[(n - 1)])[1] end
end

