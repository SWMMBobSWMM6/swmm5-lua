-- Generated from EPA SWMM 5.2.4 (table.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local ERR_ITEMS <const> = 203
local CURVE <const> = 7
local ERR_NAME <const> = 209
local ERR_KEYWORD <const> = 205
local ERR_NUMBER <const> = 211
local TSERIES <const> = 8
local USE_FILE <const> = 2
local NO_FILE <const> = 0
local ERR_TABLE_FILE_OPEN <const> = 361
local ERR_TABLE_FILE_READ <const> = 363
local ERR_CURVE_SEQUENCE <const> = 171
local _ENV = R.strict


-- table.c:51
F.table_interpolate = function(x, x1, y1, x2, y2)
  local dx = (x2 - x1)
  if (m_abs(dx) < 1e-20) then
    do return (((y1 + y2)) / 2.0) end
  end
  do return (y1 + ((((x - x1)) * ((y2 - y1))) / dx)) end
end

-- table.c:67
F.table_readCurve = function(tok, ntoks)
  local G_Curve = G.Curve
  local j = 0
  local m = 0
  local k = 0
  local k1 = 1
  local x = {0.0}
  local y = {0.0}
  if (ntoks < 2) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  j = F.project_findObject(CURVE, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  if R.peq(G_Curve[j].ID, (nil)) then
    G_Curve[j].ID = F.project_findID(CURVE, tok[0])
    m = F.findmatch(tok[1], G.CurveTypeWords)
    if (m < 0) then
      do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
    end
    G_Curve[j].curveType = m
    if (ntoks == 2) then
      do return 0 end
    end
    k1 = 2
  end
  do
    k = k1
    while (k < ntoks) do
      do
        if ((k + 1) >= ntoks) then
          do return F.error_setInpError(ERR_ITEMS, S[0]) end
        end
        if (not (F.getDouble(tok[k], x, 1) ~= 0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[k]) end
        end
        if (not (F.getDouble(tok[(k + 1)], y, 1) ~= 0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[(k + 1)]) end
        end
        F.table_addEntry(G_Curve[j], x[1], y[1])
      end
      k = (k + 2)
    end
  end
  do return 0 end
end

-- table.c:113
F.table_readTimeseries = function(tok, ntoks)
  local G_Tseries = G.Tseries
  local j = 0
  local k = 0
  local state = 0
  local x = 0.0
  local y = {0.0}
  local d = {0.0}
  local t = {0.0}
  local fname = R.buf(260)
  if (ntoks < 3) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  j = F.project_findObject(TSERIES, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  if R.peq(G_Tseries[j].ID, (nil)) then
    G_Tseries[j].ID = F.project_findID(TSERIES, tok[0])
  end
  if (F.strcomp(tok[1], S[1]) ~= 0) then
    F.sstrncpy(fname, tok[2], 259)
    F.sstrncpy(G_Tseries[j].file.name, F.addAbsolutePath(fname), 259)
    G_Tseries[j].file.mode = USE_FILE
    do return 0 end
  end
  x = 0.0
  k = 1
  state = 1
  while (k < ntoks) do
    do
      do
        local __sw1 = state
        if __sw1 == 1 then goto case3
        elseif __sw1 == 2 then goto case4
        elseif __sw1 == 3 then goto case5
        else goto swend2 end
        ::case3::
        do
          if (F.datetime_strToDate(tok[k], d, 1) ~= 0) then
            G_Tseries[j].lastDate = d[1]
            k = k + 1
          end
          state = 2
          goto swend2
        end
        ::case4::
        do
          if (k >= ntoks) then
            do return F.error_setInpError(ERR_ITEMS, S[0]) end
          end
          if (F.getDouble(tok[k], t, 1) ~= 0) then
            t[1] = (t[1] / 24.0)
          elseif (not (F.datetime_strToTime(tok[k], t, 1) ~= 0)) then
            do return F.error_setInpError(ERR_NUMBER, tok[k]) end
          end
          x = (G_Tseries[j].lastDate + t[1])
          k = k + 1
          state = 3
          goto swend2
        end
        ::case5::
        do
          if (k >= ntoks) then
            do return F.error_setInpError(ERR_ITEMS, S[0]) end
          end
          if (not (F.getDouble(tok[k], y, 1) ~= 0)) then
            do return F.error_setInpError(ERR_NUMBER, tok[k]) end
          end
          F.table_addEntry(G_Tseries[j], x, y[1])
          k = k + 1
          state = 1
          goto swend2
        end
        ::swend2::
      end
    end
  end
  do return 0 end
end

-- table.c:208
F.table_addEntry = function(table_, x, y)
  local entry = nil
  entry = T.TTableEntry()
  if (not (entry ~= nil)) then
    do return 0 end
  end
  entry.x = x
  entry.y = y
  entry.next_ = (nil)
  if (table_.firstEntry == (nil)) then
    table_.firstEntry = entry
  else
    table_.lastEntry.next_ = entry
  end
  table_.lastEntry = entry
  do return 1 end
end

-- table.c:231
F.table_deleteEntries = function(table_)
  local entry = nil
  local nextEntry = nil
  entry = table_.firstEntry
  while (entry ~= nil) do
    do
      nextEntry = entry.next_
      local _ = nil
      entry = nextEntry
    end
  end
  table_.firstEntry = (nil)
  table_.lastEntry = (nil)
  table_.thisEntry = (nil)
  if (table_.file.file ~= nil) then
    R.fclose(table_.file.file)
    table_.file.file = (nil)
  end
end

-- table.c:260
F.table_init = function(table_)
  table_.ID = (nil)
  table_.refersTo = (-1)
  table_.firstEntry = (nil)
  table_.lastEntry = (nil)
  table_.thisEntry = table_.firstEntry
  table_.lastDate = 0.0
  table_.x1 = 0.0
  table_.x2 = 0.0
  table_.y1 = 0.0
  table_.y2 = 0.0
  table_.dxMin = 0.0
  table_.file.mode = NO_FILE
  table_.file.file = (nil)
  table_.curveType = (-1)
end

-- table.c:285
F.table_validate = function(table_)
  local result = 0
  local x1 = {0.0}
  local x2 = {0.0}
  local y1 = {0.0}
  local y2 = {0.0}
  local dx = 0.0
  local dxMin = 10000000000.0
  if (table_.file.mode == USE_FILE) then
    table_.file.file = R.fopen(table_.file.name, S[13])
    if (table_.file.file == (nil)) then
      do return ERR_TABLE_FILE_OPEN end
    end
  end
  result = F.table_getFirstEntry(table_, x1, 1, y1, 1)
  if ((not (result ~= 0)) and (table_.file.mode == USE_FILE)) then
    do return ERR_TABLE_FILE_READ end
  end
  while (F.table_getNextEntry(table_, x2, 1, y2, 1) ~= 0) do
    do
      dx = (x2[1] - x1[1])
      if (dx <= 0.0) then
        table_.x2 = x2[1]
        do return ERR_CURVE_SEQUENCE end
      end
      dxMin = (((((dxMin) <= (dx))) and (dxMin) or (dx)))
      x1[1] = x2[1]
    end
  end
  table_.dxMin = dxMin
  if ((table_.file.mode == USE_FILE) and (not (R.feof(table_.file.file) ~= 0))) then
    do return ERR_TABLE_FILE_READ end
  end
  do return 0 end
end

-- table.c:331
F.table_getFirstEntry = function(table_, x, x__k, y, y__k)
  local entry = nil
  x[x__k] = 0.0
  y[y__k] = 0.0
  if (table_.file.mode == USE_FILE) then
    if (table_.file.file == (nil)) then
      do return 0 end
    end
    R.rewind(table_.file.file)
    do return F.table_getNextFileEntry(table_, x, x__k, y, y__k) end
  end
  entry = table_.firstEntry
  if (entry ~= nil) then
    x[x__k] = entry.x
    y[y__k] = entry.y
    table_.thisEntry = entry
    do return 1 end
  else
    do return 0 end
  end
end

-- table.c:366
F.table_getNextEntry = function(table_, x, x__k, y, y__k)
  local entry = nil
  if (table_.file.mode == USE_FILE) then
    do return F.table_getNextFileEntry(table_, x, x__k, y, y__k) end
  end
  entry = table_.thisEntry.next_
  if (entry ~= nil) then
    x[x__k] = entry.x
    y[y__k] = entry.y
    table_.thisEntry = entry
    do return 1 end
  else
    do return 0 end
  end
end

-- table.c:395
F.table_lookup = function(table_, x)
  local x1 = 0.0
  local y1 = 0.0
  local x2 = 0.0
  local y2 = 0.0
  local entry = nil
  entry = table_.firstEntry
  if (entry == (nil)) then
    do return 0.0 end
  end
  x1 = entry.x
  y1 = entry.y
  if (x <= x1) then
    do return y1 end
  end
  while (entry.next_ ~= nil) do
    do
      entry = entry.next_
      x2 = entry.x
      y2 = entry.y
      if (x <= x2) then
        do return F.table_interpolate(x, x1, y1, x2, y2) end
      end
      x1 = x2
      y1 = y2
    end
  end
  do return y1 end
end

-- table.c:430
F.table_getSlope = function(table_, x)
  local x1 = 0.0
  local y1 = 0.0
  local x2 = 0.0
  local y2 = 0.0
  local dx = 0.0
  local entry = nil
  entry = table_.firstEntry
  if (entry == (nil)) then
    do return 0.0 end
  end
  x1 = entry.x
  y1 = entry.y
  x2 = x1
  y2 = y1
  while (entry.next_ ~= nil) do
    do
      entry = entry.next_
      x2 = entry.x
      y2 = entry.y
      if (x <= x2) then
        break
      end
      x1 = x2
      y1 = y2
    end
  end
  dx = (x2 - x1)
  if (dx == 0.0) then
    do return 0.0 end
  end
  do return (((y2 - y1)) / dx) end
end

-- table.c:464
F.table_lookupEx = function(table_, x)
  local x1 = 0.0
  local y1 = 0.0
  local x2 = 0.0
  local y2 = 0.0
  local s = 0.0
  local entry = nil
  entry = table_.firstEntry
  if (entry == (nil)) then
    do return 0.0 end
  end
  x1 = entry.x
  y1 = entry.y
  if (x <= x1) then
    if (x1 > 0.0) then
      do return ((x / x1) * y1) end
    else
      do return y1 end
    end
  end
  while (entry.next_ ~= nil) do
    do
      entry = entry.next_
      x2 = entry.x
      y2 = entry.y
      if (x2 ~= x1) then
        s = (((y2 - y1)) / ((x2 - x1)))
      end
      if (x <= x2) then
        do return F.table_interpolate(x, x1, y1, x2, y2) end
      end
      x1 = x2
      y1 = y2
    end
  end
  if (s < 0.0) then
    s = 0.0
  end
  do return (y1 + (s * ((x - x1)))) end
end

-- table.c:503
F.table_intervalLookup = function(table_, x)
  local entry = nil
  entry = table_.firstEntry
  if (entry == (nil)) then
    do return 0.0 end
  end
  if (x < entry.x) then
    do return entry.y end
  end
  while (entry.next_ ~= nil) do
    do
      entry = entry.next_
      if (x < entry.x) then
        do return entry.y end
      end
    end
  end
  do return entry.y end
end

-- table.c:527
F.table_inverseLookup = function(table_, y)
  local x1 = 0.0
  local y1 = 0.0
  local x2 = 0.0
  local y2 = 0.0
  local entry = nil
  entry = table_.firstEntry
  if (entry == (nil)) then
    do return 0.0 end
  end
  x1 = entry.x
  y1 = entry.y
  if (y <= y1) then
    do return x1 end
  end
  while (entry.next_ ~= nil) do
    do
      entry = entry.next_
      x2 = entry.x
      y2 = entry.y
      if (y <= y2) then
        do return F.table_interpolate(y, y1, x1, y2, x2) end
      end
      x1 = x2
      y1 = y2
    end
  end
  do return x1 end
end

-- table.c:562
F.table_getMaxY = function(table_, x)
  local ymax = 0.0
  local entry = nil
  entry = table_.firstEntry
  ymax = entry.y
  while ((x > entry.x) and (entry.next_ ~= nil)) do
    do
      entry = entry.next_
      if (entry.y < ymax) then
        do return ymax end
      end
      ymax = entry.y
    end
  end
  do return 0.0 end
end

-- table.c:587
F.table_getStorageVolume = function(table_, x)
  local a = 0.0
  local a1 = 0.0
  local x1 = 0.0
  local v = 0.0
  local dx = 0.0
  local dy = 0.0
  local s = 0.0
  local entry = nil
  v = 0.0
  entry = table_.firstEntry
  if (entry == (nil)) then
    do return 0.0 end
  end
  x1 = entry.x
  a1 = entry.y
  if (x <= x1) then
    if (x1 < 1e-06) then
      do return 0.0 end
    end
    do return (((((a1 / x1)) * x) * x) / 2.0) end
  end
  while (entry.next_ ~= nil) do
    do
      entry = entry.next_
      if (entry.x >= x) then
        a = F.table_interpolate(x, x1, a1, entry.x, entry.y)
        do return (v + ((((a1 + a)) / 2.0) * ((x - x1)))) end
      else
        dx = (entry.x - x1)
        dy = (entry.y - a1)
        v = (v + ((((a1 + entry.y)) / 2.0) * dx))
        x1 = entry.x
        a1 = entry.y
      end
    end
  end
  if (dx > 1e-06) then
    s = (dy / dx)
    a = (a1 + (s * ((x - x1))))
    if (a < 0.0) then
      v = (v - (((a1 * a1) / s) / 2.0))
    else
      v = (v + ((((a1 + a)) / 2.0) * ((x - x1))))
    end
  end
  do return v end
end

-- table.c:651
F.table_getStorageDepth = function(table_, v)
  local a1 = 0.0
  local a2 = 0.0
  local d1 = 0.0
  local d2 = 0.0
  local dd = 0.0
  local da = 0.0
  local v1 = 0.0
  local v2 = 0.0
  local s = 0.0
  local entry = nil
  if (v == 0.0) then
    do return 0.0 end
  end
  entry = table_.firstEntry
  if (entry == (nil)) then
    do return 0.0 end
  end
  d1 = entry.x
  a1 = entry.y
  v1 = ((a1 * d1) / 2.0)
  if (v <= v1) then
    if (a1 > 0.0) then
      do return m_sqrt((((2.0 * v) * d1) / a1)) end
    else
      do return 0.0 end
    end
  end
  while (entry.next_ ~= nil) do
    do
      entry = entry.next_
      d2 = entry.x
      a2 = entry.y
      dd = (d2 - d1)
      da = (a2 - a1)
      v2 = (v1 + ((((a1 + a2)) / 2.0) * dd))
      if (v <= v2) then
        if (dd <= 0.0) then
          do return d1 end
        end
        if (da == 0.0) then
          if (m_abs((v2 - v1)) < 1e-06) then
            do return d1 end
          else
            do return (d1 + ((dd * ((v - v1))) / ((v2 - v1)))) end
          end
        end
        if (da < 0.0) then
          d1 = d2
          a1 = a2
          v1 = v2
        end
        s = (da / dd)
        do return (d1 + (((m_sqrt(((a1 * a1) + ((2.0 * s) * ((v - v1))))) - a1)) / s)) end
      end
      d1 = d2
      a1 = a2
      v1 = v2
    end
  end
  if ((dd == 0.0) or (da == 0.0)) then
    if (a1 > 0.0) then
      dd = (((v - v1)) / a1)
    else
      dd = 0.0
    end
  else
    s = (da / dd)
    dd = (((m_sqrt(((a1 * a1) + ((2.0 * s) * ((v - v1))))) - a1)) / s)
    if (dd < 0.0) then
      dd = 0.0
    end
  end
  do return (d1 + dd) end
end

-- table.c:730
F.table_tseriesInit = function(table_)
  F.table_getFirstEntry(table_, table_, "x1", table_, "y1")
  table_.x2 = table_.x1
  table_.y2 = table_.y1
  F.table_getNextEntry(table_, table_, "x2", table_, "y2")
end

-- table.c:745
F.table_tseriesLookup = function(table_, x, extend)
  if (((table_.x1 <= x) and (table_.x2 >= x)) and (table_.x1 ~= table_.x2)) then
    do return F.table_interpolate(x, table_.x1, table_.y1, table_.x2, table_.y2) end
  end
  if ((table_.file.mode == USE_FILE) and (R.feof(table_.file.file) ~= 0)) then
    if (extend == 1) then
      do return table_.y1 end
    else
      do return 0.0 end
    end
  end
  if ((table_.x1 == table_.x2) or (x < table_.x1)) then
    F.table_getFirstEntry(table_, table_, "x1", table_, "y1")
    if (x < table_.x1) then
      if (extend == 1) then
        do return table_.y1 end
      else
        do return 0.0 end
      end
    end
  end
  table_.x1 = table_.x2
  table_.y1 = table_.y2
  while (F.table_getNextEntry(table_, table_, "x2", table_, "y2") ~= 0) do
    do
      if (x <= table_.x2) then
        do return F.table_interpolate(x, table_.x1, table_.y1, table_.x2, table_.y2) end
      end
      table_.x1 = table_.x2
      table_.y1 = table_.y2
    end
  end
  if (extend == 1) then
    do return table_.y1 end
  else
    do return 0.0 end
  end
end

-- table.c:808
F.table_getNextFileEntry = function(table_, x, x__k, y, y__k)
  local line = R.buf(1025)
  local code = 0
  if (table_.file.file == (nil)) then
    do return 0 end
  end
  while ((not (R.feof(table_.file.file) ~= 0)) and (not R.peq(R.fgets(line, 1024, table_.file.file), (nil)))) do
    do
      code = F.table_parseFileLine(line, table_, x, x__k, y, y__k)
      if (code < 0) then
        goto continue1
      end
      do return code end
    end
    ::continue1::
  end
  do return 0 end
end

-- table.c:833
F.table_parseFileLine = function(line, table_, x, x__k, y, y__k)
  local n = 0
  local s1 = R.buf(50)
  local s2 = R.buf(50)
  local s3 = R.buf(50)
  local tStr = nil
  local yStr = nil
  local yy = {0.0}
  local d = {0.0}
  local t = {0.0}
  n = R.sscanf(line, S[650], s1, s2, s3)
  tStr = R.strtok(line, S[184])
  if ((R.peq(tStr, (nil))) or (tStr.b[tStr.o] == 59)) then
    do return (-1) end
  end
  if (n == 2) then
    d[1] = table_.lastDate
    tStr = s1
    yStr = s2
  elseif (n == 3) then
    if (not (F.datetime_strToDate(s1, d, 1) ~= 0)) then
      do return 0 end
    end
    table_.lastDate = d[1]
    tStr = s2
    yStr = s3
  else
    do return 0 end
  end
  if (F.getDouble(tStr, t, 1) ~= 0) then
    t[1] = (t[1] / 24.0)
  elseif (not (F.datetime_strToTime(tStr, t, 1) ~= 0)) then
    do return 0 end
  end
  if (not (F.getDouble(yStr, yy, 1) ~= 0)) then
    do return 0 end
  end
  x[x__k] = (d[1] + t[1])
  y[y__k] = yy[1]
  do return 1 end
end

