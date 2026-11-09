-- Generated from EPA SWMM 5.2.4 (street.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local STREET <const> = 16
local ERR_MEMORY <const> = 101
local ERR_ITEMS <const> = 203
local ERR_NAME <const> = 209
local ERR_NUMBER <const> = 211
local LENGTH <const> = 3
local DW <const> = 4
local _ENV = R.strict


-- street.c:29
F.street_create = function(nStreets)
  local G_Nobjects = G.Nobjects
  G.Street = (nil)
  G_Nobjects[STREET] = 0
  G.Street = R.recs(nStreets, T.TStreet)
  if (G.Street == (nil)) then
    do return ERR_MEMORY end
  end
  G_Nobjects[STREET] = nStreets
  do return 0 end
end

-- street.c:46
F.street_delete = function()
  do
    if (G.Street ~= nil) then
      local _ = nil
      G.Street = (nil)
    end
  end
end

-- street.c:58
F.street_readParams = function(tok, ntoks)
  local G_Street = G.Street
  local i = 0
  local k = 0
  local sides = {0}
  local x = R.fill(11, 0.0)
  local street = nil
  if (ntoks < 5) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  i = F.project_findObject(STREET, tok[0])
  if (i < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  G_Street[i].ID = F.project_findID(STREET, tok[0])
  do
    k = 0
    while (k <= 9) do
      do
        x[k] = 0.0
      end
      k = k + 1
    end
  end
  do
    k = 1
    while (k <= 4) do
      do
        if ((not (F.getDouble(tok[k], x, k) ~= 0)) or (x[k] <= 0.0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[k]) end
        end
      end
      k = k + 1
    end
  end
  if (ntoks > 5) then
    if ((not (F.getDouble(tok[5], x, 5) ~= 0)) or (x[5] < 0.0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[5]) end
    end
  end
  if (ntoks > 6) then
    if ((not (F.getDouble(tok[6], x, 6) ~= 0)) or (x[6] < 0.0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[6]) end
    end
  end
  sides[1] = 2
  if (ntoks > 7) then
    if (((not (F.getInt(tok[7], sides, 1) ~= 0)) or (sides[1] < 1)) or (sides[1] > 2)) then
      do return F.error_setInpError(ERR_NUMBER, tok[7]) end
    end
  end
  if (ntoks > 8) then
    if ((not (F.getDouble(tok[8], x, 8) ~= 0)) or (x[8] < 0.0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[8]) end
    end
    if (x[8] > 0.0) then
      if (ntoks < 11) then
        do return F.error_setInpError(ERR_ITEMS, S[0]) end
      end
      do
        k = 9
        while (k <= 10) do
          do
            if ((not (F.getDouble(tok[k], x, k) ~= 0)) or (x[k] <= 0.0)) then
              do return F.error_setInpError(ERR_NUMBER, tok[k]) end
            end
          end
          k = k + 1
        end
      end
    end
  end
  street = G_Street[i]
  street.width = (x[1] / F.UCF(LENGTH))
  street.curbHeight = (x[2] / F.UCF(LENGTH))
  street.slope = (x[3] / 100.0)
  street.roughness = x[4]
  street.gutterDepression = (x[5] / F.UCF(LENGTH))
  street.gutterWidth = (x[6] / F.UCF(LENGTH))
  street.sides = sides[1]
  street.backWidth = (x[8] / F.UCF(LENGTH))
  street.backSlope = (x[9] / 100.0)
  street.backRoughness = x[10]
  F.transect_createStreetTransect(street)
  do return 0 end
end

-- street.c:141
F.street_getExtentFilled = function(link)
  local G_Link, G_Node, G_Conduit = G.Link, G.Node, G.Conduit
  local k = 0
  local t = 0
  local filled = 0.0
  t = G_Link[link].xsect.transect
  if (t < 0) then
    do return 0.0 end
  end
  if (G.RouteModel == DW) then
    filled = (((((G_Node[G_Link[link].node1].newDepth) >= (G_Node[G_Link[link].node2].newDepth))) and (G_Node[G_Link[link].node1].newDepth) or (G_Node[G_Link[link].node2].newDepth)))
  else
    k = G_Link[link].subIndex
    filled = (((((G_Conduit[k].a1) >= (G_Conduit[k].a2))) and (G_Conduit[k].a1) or (G_Conduit[k].a2)))
  end
  do return filled end
end

