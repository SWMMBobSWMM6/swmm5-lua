-- Generated from EPA SWMM 5.2.4 (shape.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local _ENV = R.strict

G.Atotal = 0.0
G.Ptotal = 0.0

-- shape.c:42
F.shape_validate = function(shape, curve)
  if (not (F.computeShapeTables(shape, curve) ~= 0)) then
    do return 0 end
  end
  if (not (F.normalizeShapeTables(shape) ~= 0)) then
    do return 0 end
  end
  do return 1 end
end

-- shape.c:64
F.computeShapeTables = function(shape, curve)
  local i = 0
  local n = 0
  local dy = 0.0
  local y = 0.0
  local y1 = {0.0}
  local y2 = {0.0}
  local w = 0.0
  local w1 = {0.0}
  local w2 = {0.0}
  local yLast = 0.0
  local wLast = 0.0
  local wMax = {0.0}
  if (not (F.table_getFirstEntry(curve, y1, 1, w1, 1) ~= 0)) then
    do return 0 end
  end
  if (((y1[1] < 0.0) or (y1[1] >= 1.0)) or (w1[1] < 0.0)) then
    do return 0 end
  end
  wMax[1] = w1[1]
  if (y1[1] ~= 0.0) then
    y2[1] = y1[1]
    w2[1] = w1[1]
    y1[1] = 0.0
    w1[1] = 0.0
  else
    if (not (F.table_getNextEntry(curve, y2, 1, w2, 1) ~= 0)) then
      do return 0 end
    end
    if ((y2[1] < y1[1]) or (w2[1] < 0.0)) then
      do return 0 end
    end
    if (y2[1] > 1.0) then
      y2[1] = 1.0
    end
    if (w2[1] > wMax[1]) then
      wMax[1] = w2[1]
    end
  end
  shape.nTbl = 51
  n = (shape.nTbl - 1)
  dy = (1.0 / ((n) * 1.0))
  shape.areaTbl[0] = 0.0
  shape.hradTbl[0] = 0.0
  shape.widthTbl[0] = w1[1]
  G.Ptotal = w1[1]
  G.Atotal = 0.0
  y = 0.0
  w = w1[1]
  do
    i = 1
    while (i <= n) do
      do
        yLast = y
        wLast = w
        y = (y + dy)
        if (m_abs((y - 1.0)) < 1e-06) then
          y = 1.0
        end
        if (y > y2[1]) then
          if (not (F.getNextInterval(curve, y, yLast, wLast, y1, 1, y2, 1, w1, 1, w2, 1, wMax, 1) ~= 0)) then
            do return 0 end
          end
          yLast = y1[1]
          wLast = w1[1]
        end
        w = F.shape_getWidth(y, y1[1], y2[1], w1[1], w2[1])
        G.Atotal = (G.Atotal + (F.shape_getArea(y, w, yLast, wLast)))
        G.Ptotal = (G.Ptotal + (F.getPerim(y, w, yLast, wLast)))
        if (y == 1.0) then
          G.Ptotal = (G.Ptotal + w2[1])
        end
        shape.widthTbl[i] = w
        shape.areaTbl[i] = G.Atotal
        if (G.Ptotal > 0.0) then
          shape.hradTbl[i] = (G.Atotal / G.Ptotal)
        else
          shape.hradTbl[i] = 0.0
        end
      end
      i = i + 1
    end
  end
  shape.aFull = shape.areaTbl[n]
  shape.rFull = shape.hradTbl[n]
  shape.wMax = wMax[1]
  F.getSmax(shape)
  do return 1 end
end

-- shape.c:189
F.getSmax = function(shape)
  local i = 0
  local n = (shape.nTbl - 1)
  local sf = 0.0
  shape.sMax = 0.0
  shape.aMax = 0.0
  do
    i = 1
    while (i <= n) do
      do
        sf = (shape.areaTbl[i] * (shape.hradTbl[i] ^ (2.0 / 3.0)))
        if (sf > shape.sMax) then
          shape.sMax = sf
          shape.aMax = shape.areaTbl[i]
        end
      end
      i = i + 1
    end
  end
end

-- shape.c:216
F.normalizeShapeTables = function(shape)
  local i = 0
  local n = (shape.nTbl - 1)
  local aFull = shape.aFull
  local rFull = shape.rFull
  local wMax = shape.wMax
  if (((aFull == 0.0) or (rFull == 0.0)) or (wMax == 0.0)) then
    do return 0 end
  end
  do
    i = 0
    while (i <= n) do
      do
        shape.areaTbl[i] = (shape.areaTbl[i] / aFull)
        shape.hradTbl[i] = (shape.hradTbl[i] / rFull)
        shape.widthTbl[i] = (shape.widthTbl[i] / wMax)
      end
      i = i + 1
    end
  end
  do return 1 end
end

-- shape.c:246
F.getNextInterval = function(curve, y, yLast, wLast, y1, y1__k, y2, y2__k, w1, w1__k, w2, w2__k, wMax, wMax__k)
  while (y > y2[y2__k]) do
    do
      if (y2[y2__k] > yLast) then
        G.Atotal = (G.Atotal + (F.shape_getArea(y2[y2__k], w2[w2__k], yLast, wLast)))
        G.Ptotal = (G.Ptotal + (F.getPerim(y2[y2__k], w2[w2__k], yLast, wLast)))
        yLast = y2[y2__k]
        wLast = w2[w2__k]
      end
      y1[y1__k] = y2[y2__k]
      w1[w1__k] = w2[w2__k]
      if (not (F.table_getNextEntry(curve, y2, y2__k, w2, w2__k) ~= 0)) then
        y2[y2__k] = 1.0
        do return 1 end
      end
      if (w2[w2__k] > wMax[wMax__k]) then
        wMax[wMax__k] = w2[w2__k]
      end
      if ((y2[y2__k] < y1[y1__k]) or (w2[w2__k] < 0.0)) then
        do return 0 end
      end
      if (y2[y2__k] > 1.0) then
        y2[y2__k] = 1.0
      end
    end
  end
  do return 1 end
end

-- shape.c:307
F.shape_getWidth = function(y, y1, y2, w1, w2)
  if (y2 == y1) then
    do return w2 end
  end
  do return (w1 + ((((y - y1)) / ((y2 - y1))) * ((w2 - w1)))) end
end

-- shape.c:328
F.shape_getArea = function(y, w, y1, w1)
  local wMin = 0.0
  local wMax = 0.0
  if (w > w1) then
    wMin = w1
    wMax = w
  else
    wMin = w
    wMax = w1
  end
  do return (((wMin + (((wMax - wMin)) / 2.0))) * ((y - y1))) end
end

-- shape.c:353
F.getPerim = function(y, w, y1, w1)
  local dy = (y - y1)
  local dw = (m_abs((w - w1)) / 2.0)
  do return (2.0 * m_sqrt(((dy * dy) + (dw * dw)))) end
end

