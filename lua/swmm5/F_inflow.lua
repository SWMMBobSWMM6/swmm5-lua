-- Generated from EPA SWMM 5.2.4 (inflow.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local CONCEN_INFLOW <const> = 6
local ERR_ITEMS <const> = 203
local NODE <const> = 2
local ERR_NAME <const> = 209
local POLLUT <const> = 4
local TSERIES <const> = 8
local EXTERNAL_INFLOW <const> = 0
local FLOW_INFLOW <const> = 5
local FLOW <const> = 10
local MASS_INFLOW <const> = 7
local ERR_KEYWORD <const> = 205
local ERR_NUMBER <const> = 211
local TIMEPATTERN <const> = 6
local ERR_MEMORY <const> = 101
local MONTHLY_PATTERN <const> = 0
local DAILY_PATTERN <const> = 1
local HOURLY_PATTERN <const> = 2
local WEEKEND_PATTERN <const> = 3
local _ENV = R.strict


-- inflow.c:41
F.inflow_readExtInflow = function(tok, ntoks)
  local j = 0
  local param = 0
  local type_ = CONCEN_INFLOW
  local tseries = (-1)
  local basePat = (-1)
  local cf = {1.0}
  local sf = {1.0}
  local baseline = {0.0}
  if (ntoks < 3) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  j = F.project_findObject(NODE, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  param = F.project_findObject(POLLUT, tok[1])
  if (param < 0) then
    if (F.match(tok[1], S[183]) ~= 0) then
      param = (-1)
    else
      do return F.error_setInpError(ERR_NAME, tok[1]) end
    end
  end
  if (R.strlen(tok[2]) > 0) then
    tseries = F.project_findObject(TSERIES, tok[2])
    if (tseries < 0) then
      do return F.error_setInpError(ERR_NAME, tok[2]) end
    end
    G.Tseries[tseries].refersTo = EXTERNAL_INFLOW
  end
  if (param == (-1)) then
    type_ = FLOW_INFLOW
    cf[1] = (1.0 / F.UCF(FLOW))
  end
  if ((ntoks >= 4) and (param > (-1))) then
    if (F.match(tok[3], S[185]) ~= 0) then
      type_ = CONCEN_INFLOW
    elseif (F.match(tok[3], S[186]) ~= 0) then
      type_ = MASS_INFLOW
    else
      do return F.error_setInpError(ERR_KEYWORD, tok[3]) end
    end
    if ((ntoks >= 5) and (type_ == MASS_INFLOW)) then
      if (not (F.getDouble(tok[4], cf, 1) ~= 0)) then
        do return F.error_setInpError(ERR_NUMBER, tok[4]) end
      end
      if (cf[1] <= 0.0) then
        do return F.error_setInpError(ERR_NUMBER, tok[4]) end
      end
    end
  end
  if (ntoks >= 6) then
    if (not (F.getDouble(tok[5], sf, 1) ~= 0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[5]) end
    end
  end
  if (ntoks >= 7) then
    if (not (F.getDouble(tok[6], baseline, 1) ~= 0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[6]) end
    end
  end
  if (ntoks >= 8) then
    basePat = F.project_findObject(TIMEPATTERN, tok[7])
    if (basePat < 0) then
      do return F.error_setInpError(ERR_NAME, tok[7]) end
    end
  end
  if (type_ == MASS_INFLOW) then
    cf[1] = (cf[1] / 28.317)
  end
  do return (F.inflow_setExtInflow(j, param, type_, tseries, basePat, cf[1], baseline[1], sf[1])) end
end

-- inflow.c:138
F.inflow_setExtInflow = function(j, param, type_, tseries, basePat, cf, baseline, sf)
  local G_Node = G.Node
  local inflow = nil
  inflow = G_Node[j].extInflow
  while (inflow ~= nil) do
    do
      if (inflow.param == param) then
        break
      end
      inflow = inflow.next_
    end
  end
  if (inflow == (nil)) then
    inflow = T.TExtInflow()
    if (inflow == (nil)) then
      do return F.error_setInpError(ERR_MEMORY, S[0]) end
    end
    inflow.next_ = G_Node[j].extInflow
    G_Node[j].extInflow = inflow
  end
  inflow.param = param
  inflow.type_ = type_
  inflow.tSeries = tseries
  inflow.cFactor = cf
  inflow.sFactor = sf
  inflow.baseline = baseline
  inflow.basePat = basePat
  do return 0 end
end

-- inflow.c:187
F.inflow_deleteExtInflows = function(j)
  local inflow1 = nil
  local inflow2 = nil
  inflow1 = G.Node[j].extInflow
  while (inflow1 ~= nil) do
    do
      inflow2 = inflow1.next_
      local _ = nil
      inflow1 = inflow2
    end
  end
end

-- inflow.c:207
F.inflow_getExtInflow = function(inflow, aDate)
  local month = 0
  local day = 0
  local hour = 0
  local p = inflow.basePat
  local k = inflow.tSeries
  local cf = inflow.cFactor
  local sf = inflow.sFactor
  local blv = inflow.baseline
  local tsv = 0.0
  if (p >= 0) then
    month = (F.datetime_monthOfYear(aDate) - 1)
    day = (F.datetime_dayOfWeek(aDate) - 1)
    hour = F.datetime_hourOfDay(aDate)
    blv = (blv * (F.getPatternFactor(p, month, day, hour)))
  end
  if (k >= 0) then
    tsv = (F.table_tseriesLookup(G.Tseries[k], aDate, 0) * sf)
  end
  do return (cf * ((tsv + blv))) end
end

-- inflow.c:237
F.inflow_readDwfInflow = function(tok, ntoks)
  local G_Node = G.Node
  local i = 0
  local j = 0
  local k = 0
  local m = 0
  local pats = R.fill(4, 0)
  local x = {0.0}
  local inflow = nil
  if (ntoks < 3) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  j = F.project_findObject(NODE, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  k = F.project_findObject(POLLUT, tok[1])
  if (k < 0) then
    if (F.match(tok[1], S[183]) ~= 0) then
      k = (-1)
    else
      do return F.error_setInpError(ERR_NAME, tok[1]) end
    end
  end
  if (not (F.getDouble(tok[2], x, 1) ~= 0)) then
    do return F.error_setInpError(ERR_NUMBER, tok[2]) end
  end
  if (k == (-1)) then
    x[1] = (x[1] / (F.UCF(FLOW)))
  end
  do
    i = 0
    while (i < 4) do
      do
        pats[i] = (-1)
      end
      i = i + 1
    end
  end
  do
    i = 3
    while (i < 7) do
      do
        if (i >= ntoks) then
          break
        end
        if (R.strlen(tok[i]) == 0) then
          goto continue2
        end
        m = F.project_findObject(TIMEPATTERN, tok[i])
        if (m < 0) then
          do return F.error_setInpError(ERR_NAME, tok[i]) end
        end
        pats[(i - 3)] = m
      end
      ::continue2::
      i = i + 1
    end
  end
  inflow = G_Node[j].dwfInflow
  while (inflow ~= nil) do
    do
      if (inflow.param == k) then
        break
      end
      inflow = inflow.next_
    end
  end
  if (inflow == (nil)) then
    inflow = T.TDwfInflow()
    if (inflow == (nil)) then
      do return F.error_setInpError(ERR_MEMORY, S[0]) end
    end
    inflow.next_ = G_Node[j].dwfInflow
    G_Node[j].dwfInflow = inflow
  end
  inflow.param = k
  inflow.avgValue = x[1]
  do
    i = 0
    while (i < 4) do
      do
        inflow.patterns[i] = pats[i]
      end
      i = i + 1
    end
  end
  do return 0 end
end

-- inflow.c:311
F.inflow_deleteDwfInflows = function(j)
  local inflow1 = nil
  local inflow2 = nil
  inflow1 = G.Node[j].dwfInflow
  while (inflow1 ~= nil) do
    do
      inflow2 = inflow1.next_
      local _ = nil
      inflow1 = inflow2
    end
  end
end

-- inflow.c:331
F.inflow_initDwfInflow = function(inflow)
  local G_Pattern = G.Pattern
  local i = 0
  local p = 0
  local tmpPattern = R.fill(4, 0)
  do
    i = 0
    while (i < 4) do
      do
        tmpPattern[i] = (-1)
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < 4) do
      do
        p = inflow.patterns[i]
        if (p >= 0) then
          tmpPattern[G_Pattern[p].type_] = p
        end
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < 4) do
      do
        inflow.patterns[i] = tmpPattern[i]
      end
      i = i + 1
    end
  end
end

-- inflow.c:361
F.inflow_getDwfInflow = function(inflow, month, day, hour)
  local p1 = 0
  local p2 = 0
  local f = 1.0
  p1 = inflow.patterns[MONTHLY_PATTERN]
  if (p1 >= 0) then
    f = (f * (F.getPatternFactor(p1, month, day, hour)))
  end
  p1 = inflow.patterns[DAILY_PATTERN]
  if (p1 >= 0) then
    f = (f * (F.getPatternFactor(p1, month, day, hour)))
  end
  p1 = inflow.patterns[HOURLY_PATTERN]
  p2 = inflow.patterns[WEEKEND_PATTERN]
  if (p2 >= 0) then
    if ((day == 0) or (day == 6)) then
      f = (f * (F.getPatternFactor(p2, month, day, hour)))
    elseif (p1 >= 0) then
      f = (f * (F.getPatternFactor(p1, month, day, hour)))
    end
  elseif (p1 >= 0) then
    f = (f * (F.getPatternFactor(p1, month, day, hour)))
  end
  do return (f * inflow.avgValue) end
end

-- inflow.c:394
F.inflow_initDwfPattern = function(j)
  local G_Pattern = G.Pattern
  local i = 0
  do
    i = 0
    while (i < 24) do
      do
        G_Pattern[j].factor[i] = 1.0
      end
      i = i + 1
    end
  end
  G_Pattern[j].count = 0
  G_Pattern[j].type_ = (-1)
  G_Pattern[j].ID = (nil)
end

-- inflow.c:410
F.inflow_readDwfPattern = function(tok, ntoks)
  local G_Pattern = G.Pattern
  local i = 0
  local j = 0
  local k = 0
  local n = 1
  if (ntoks < 2) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  j = F.project_findObject(TIMEPATTERN, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  if R.peq(G_Pattern[j].ID, (nil)) then
    G_Pattern[j].ID = F.project_findID(TIMEPATTERN, tok[0])
    k = F.findmatch(tok[1], G.PatternTypeWords)
    if (k < 0) then
      do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
    end
    G_Pattern[j].type_ = k
    n = 2
  end
  while ((ntoks > n) and (G_Pattern[j].count < 24)) do
    do
      i = G_Pattern[j].count
      if (not (F.getDouble(tok[n], G_Pattern[j].factor, i) ~= 0)) then
        do return F.error_setInpError(ERR_NUMBER, tok[n]) end
      end
      G_Pattern[j].count = G_Pattern[j].count + 1
      n = n + 1
    end
  end
  do return 0 end
end

-- inflow.c:456
F.getPatternFactor = function(p, month, day, hour)
  local G_Pattern = G.Pattern
  do
    local __sw1 = G_Pattern[p].type_
    if __sw1 == MONTHLY_PATTERN then goto case2
    elseif __sw1 == DAILY_PATTERN then goto case3
    elseif __sw1 == HOURLY_PATTERN then goto case4
    elseif __sw1 == WEEKEND_PATTERN then goto case5
    else goto swend1 end
    ::case2::
    do
      if ((month >= 0) and (month < 12)) then
        do return G_Pattern[p].factor[month] end
      end
      goto swend1
    end
    ::case3::
    do
      if ((day >= 0) and (day < 7)) then
        do return G_Pattern[p].factor[day] end
      end
      goto swend1
    end
    ::case4::
    do
      if ((hour >= 0) and (hour < 24)) then
        do return G_Pattern[p].factor[hour] end
      end
      goto swend1
    end
    ::case5::
    do
      if ((day == 0) or (day == 6)) then
        if ((hour >= 0) and (hour < 24)) then
          do return G_Pattern[p].factor[hour] end
        end
      end
      goto swend1
    end
    ::swend1::
  end
  do return 1.0 end
end

