-- Generated from EPA SWMM 5.2.4 (datetime.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local _ENV = R.strict

G.MonthTxt = {[0] = S[695], S[696], S[697], S[698], S[699], S[700], S[701], S[702], S[703], S[704], S[705], S[706], nil}
G.DaysPerMonth = {[0] = {[0] = 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}, {[0] = 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}}
G.DateDelta = 693594
G.SecsPerDay = 86400.0
G.DateFormat = 0

-- datetime.c:51
F.divMod = function(n, d, result, result__k, remainder, remainder__k)
  if (d == 0) then
    result[result__k] = 0
    remainder[remainder__k] = 0
  else
    result[result__k] = R.idiv(n, d)
    remainder[remainder__k] = (n - (d * (result[result__k])))
  end
end

-- datetime.c:74
F.isLeapYear = function(year)
  if (((m_fmod(year, 4) == 0)) and ((((m_fmod(year, 100) ~= 0)) or ((m_fmod(year, 400) == 0))))) then
    do return 1 end
  else
    do return 0 end
  end
end

-- datetime.c:89
F.datetime_findMonth = function(month)
  local G_MonthTxt = G.MonthTxt
  local i = 0
  do
    i = 0
    while (i < 12) do
      do
        if (((((((((month.b[month.o]) >= 97) and ((month.b[month.o]) <= 122))) and (((month.b[month.o]) & (~32))) or (month.b[month.o]))) == G_MonthTxt[i].b[G_MonthTxt[i].o]) and (((((((month.b[month.o + 1]) >= 97) and ((month.b[month.o + 1]) <= 122))) and (((month.b[month.o + 1]) & (~32))) or (month.b[month.o + 1]))) == G_MonthTxt[i].b[G_MonthTxt[i].o + 1])) and (((((((month.b[month.o + 2]) >= 97) and ((month.b[month.o + 2]) <= 122))) and (((month.b[month.o + 2]) & (~32))) or (month.b[month.o + 2]))) == G_MonthTxt[i].b[G_MonthTxt[i].o + 2])) then
          do return (i + 1) end
        end
      end
      i = i + 1
    end
  end
  do return 0 end
end

-- datetime.c:108
F.datetime_encodeDate = function(year, month, day)
  local G_DaysPerMonth = G.DaysPerMonth
  local i = 0
  local j = 0
  i = F.isLeapYear(year)
  if (((((((year >= 1)) and ((year <= 9999))) and ((month >= 1))) and ((month <= 12))) and ((day >= 1))) and ((day <= G_DaysPerMonth[i][(month - 1)]))) then
    do
      j = 0
      while (j < (month - 1)) do
        do
          day = (day + G_DaysPerMonth[i][j])
        end
        j = j + 1
      end
    end
    i = (year - 1)
    i = ((((((i * 365) + R.idiv(i, 4)) - R.idiv(i, 100)) + R.idiv(i, 400)) + day) - G.DateDelta)
    do return (i * 1.0) end
  else
    do return ((-G.DateDelta) * 1.0) end
  end
end

-- datetime.c:136
F.datetime_encodeTime = function(hour, minute, second)
  local s = 0
  if ((((hour >= 0)) and ((minute >= 0))) and ((second >= 0))) then
    s = ((((hour * 3600) + (minute * 60)) + second))
    do return ((s * 1.0) / G.SecsPerDay) end
  else
    do return 0.0 end
  end
end

-- datetime.c:158
F.datetime_decodeDate = function(date, year, year__k, month, month__k, day, day__k)
  local G_DaysPerMonth = G.DaysPerMonth
  local D1 = 0
  local D4 = 0
  local D100 = 0
  local D400 = 0
  local y = 0
  local m = 0
  local d = {0}
  local i = {0}
  local k = 0
  local t = 0
  D1 = 365
  D4 = ((D1 * 4) + 1)
  D100 = ((D4 * 25) - 1)
  D400 = ((D100 * 4) + 1)
  t = (R.D2I((R.floor(date))) + G.DateDelta)
  if (t <= 0) then
    year[year__k] = 0
    month[month__k] = 1
    day[day__k] = 1
  else
    t = t - 1
    y = 1
    while (t >= D400) do
      do
        t = (t - D400)
        y = (y + 400)
      end
    end
    F.divMod(t, D100, i, 1, d, 1)
    if (i[1] == 4) then
      i[1] = i[1] - 1
      d[1] = (d[1] + D100)
    end
    y = (y + (i[1] * 100))
    F.divMod(d[1], D4, i, 1, d, 1)
    y = (y + (i[1] * 4))
    F.divMod(d[1], D1, i, 1, d, 1)
    if (i[1] == 4) then
      i[1] = i[1] - 1
      d[1] = (d[1] + D1)
    end
    y = (y + i[1])
    k = F.isLeapYear(y)
    m = 1
    do
      while true do
        do
          i[1] = G_DaysPerMonth[k][(m - 1)]
          if (d[1] < i[1]) then
            break
          end
          d[1] = (d[1] - i[1])
          m = m + 1
        end
      end
    end
    year[year__k] = y
    month[month__k] = m
    day[day__k] = (d[1] + 1)
  end
end

-- datetime.c:224
F.datetime_decodeTime = function(time, h, h__k, m, m__k, s, s__k)
  local secs = 0
  local mins = {0}
  local fracDay = (((time - R.floor(time))) * G.SecsPerDay)
  secs = R.D2I((R.floor((fracDay + 0.5))))
  if (secs >= 86400) then
    secs = 86399
  end
  F.divMod(secs, 60, mins, 1, s, s__k)
  F.divMod(mins[1], 60, h, h__k, m, m__k)
  if (h[h__k] > 23) then
    h[h__k] = 0
  end
end

-- datetime.c:245
F.datetime_dateToStr = function(date, s)
  local G_MonthTxt = G.MonthTxt
  local y = {0}
  local m = {0}
  local d = {0}
  F.datetime_decodeDate(date, y, 1, m, 1, d, 1)
  do
    local __sw1 = G.DateFormat
    if __sw1 == 0 then goto case2
    elseif __sw1 == 1 then goto case3
    else goto case4 end
    ::case2::
    do
      R.snprintf(s, 12, S[36], y[1], G_MonthTxt[(m[1] - 1)], d[1])
      goto swend1
    end
    ::case3::
    do
      R.snprintf(s, 12, S[37], m[1], d[1], y[1])
      goto swend1
    end
    ::case4::
    do
      R.snprintf(s, 12, S[38], d[1], G_MonthTxt[(m[1] - 1)], y[1])
    end
    ::swend1::
  end
end

-- datetime.c:270
F.datetime_timeToStr = function(time, s)
  local hr = {0}
  local min = {0}
  local sec = {0}
  F.datetime_decodeTime(time, hr, 1, min, 1, sec, 1)
  R.snprintf(s, 9, S[39], hr[1], min[1], sec[1])
end

-- datetime.c:284
F.datetime_strToDate = function(s, d, d__k)
  local yr = {0}
  local mon = {0}
  local day = {0}
  local n = 0
  local month = R.buf(4)
  local sep1 = {0}
  local sep2 = {0}
  d[d__k] = ((-G.DateDelta) * 1.0)
  if ((R.strchr(s, 45) ~= nil) or (R.strchr(s, 47) ~= nil)) then
    do
      local __sw1 = G.DateFormat
      if __sw1 == 0 then goto case2
      elseif __sw1 == 2 then goto case3
      else goto case4 end
      ::case2::
      do
        n = R.sscanf(s, S[40], yr, 1, sep1, 1, mon, 1, sep2, 1, day, 1)
        if (n < 3) then
          mon[1] = 0
          n = R.sscanf(s, S[41], yr, 1, sep1, 1, month, sep2, 1, day, 1)
          if (n < 3) then
            do return 0 end
          end
        end
        goto swend1
      end
      ::case3::
      do
        n = R.sscanf(s, S[40], day, 1, sep1, 1, mon, 1, sep2, 1, yr, 1)
        if (n < 3) then
          mon[1] = 0
          n = R.sscanf(s, S[41], day, 1, sep1, 1, month, sep2, 1, yr, 1)
          if (n < 3) then
            do return 0 end
          end
        end
        goto swend1
      end
      ::case4::
      do
        n = R.sscanf(s, S[40], mon, 1, sep1, 1, day, 1, sep2, 1, yr, 1)
        if (n < 3) then
          mon[1] = 0
          n = R.sscanf(s, S[42], month, sep1, 1, day, 1, sep2, 1, yr, 1)
          if (n < 3) then
            do return 0 end
          end
        end
      end
      ::swend1::
    end
    if (mon[1] == 0) then
      mon[1] = F.datetime_findMonth(month)
    end
    d[d__k] = F.datetime_encodeDate(yr[1], mon[1], day[1])
  end
  if (d[d__k] == ((-G.DateDelta) * 1.0)) then
    do return 0 end
  else
    do return 1 end
  end
end

-- datetime.c:338
F.datetime_strToTime = function(s, t, t__k)
  local n = 0
  local hr = {0}
  local min = {0}
  local sec = {0}
  local endptr = {nil}
  t[t__k] = R.strtod(s, endptr, 1)
  if (endptr[1].b[endptr[1].o] == 0) then
    t[t__k] = (t[t__k] / 24.0)
    do return 1 end
  end
  t[t__k] = 0.0
  n = R.sscanf(s, S[43], hr, 1, min, 1, sec, 1)
  if (n == 0) then
    do return 0 end
  end
  t[t__k] = F.datetime_encodeTime(hr[1], min[1], sec[1])
  if ((((hr[1] >= 0)) and ((min[1] >= 0))) and ((sec[1] >= 0))) then
    do return 1 end
  else
    do return 0 end
  end
end

-- datetime.c:369
F.datetime_setDateFormat = function(fmt)
  if ((fmt >= 0) and (fmt <= 1)) then
    G.DateFormat = fmt
  end
end

-- datetime.c:381
F.datetime_addSeconds = function(date1, seconds)
  local d = R.floor(date1)
  local h = {0}
  local m = {0}
  local s = {0}
  F.datetime_decodeTime(date1, h, 1, m, 1, s, 1)
  do return (d + ((((((3600.0 * (h[1] * 1.0)) + (60.0 * (m[1] * 1.0))) + (s[1] * 1.0)) + seconds)) / G.SecsPerDay)) end
end

-- datetime.c:397
F.datetime_addDays = function(date1, date2)
  local d1 = R.floor(date1)
  local d2 = R.floor(date2)
  local h1 = {0}
  local m1 = {0}
  local s1 = {0}
  local h2 = {0}
  local m2 = {0}
  local s2 = {0}
  F.datetime_decodeTime(date1, h1, 1, m1, 1, s1, 1)
  F.datetime_decodeTime(date2, h2, 1, m2, 1, s2, 1)
  do return ((d1 + d2) + F.datetime_encodeTime((h1[1] + h2[1]), (m1[1] + m2[1]), (s1[1] + s2[1]))) end
end

-- datetime.c:416
F.datetime_timeDiff = function(date1, date2)
  local d1 = R.floor(date1)
  local d2 = R.floor(date2)
  local h = {0}
  local m = {0}
  local s = {0}
  local s1 = 0
  local s2 = 0
  local secs = 0
  F.datetime_decodeTime(date1, h, 1, m, 1, s, 1)
  s1 = (((3600 * h[1]) + (60 * m[1])) + s[1])
  F.datetime_decodeTime(date2, h, 1, m, 1, s, 1)
  s2 = (((3600 * h[1]) + (60 * m[1])) + s[1])
  secs = R.D2I((R.floor(((((d1 - d2)) * G.SecsPerDay) + 0.5))))
  secs = (secs + ((s1 - s2)))
  do return secs end
end

-- datetime.c:439
F.datetime_monthOfYear = function(date)
  local year = {0}
  local month = {0}
  local day = {0}
  F.datetime_decodeDate(date, year, 1, month, 1, day, 1)
  do return month[1] end
end

-- datetime.c:453
F.datetime_dayOfYear = function(date)
  local year = {0}
  local month = {0}
  local day = {0}
  local startOfYear = 0.0
  F.datetime_decodeDate(date, year, 1, month, 1, day, 1)
  startOfYear = F.datetime_encodeDate(year[1], 1, 1)
  do return (R.D2I((R.floor((date - startOfYear)))) + 1) end
end

-- datetime.c:469
F.datetime_dayOfWeek = function(date)
  local t = (R.D2I((R.floor(date))) + G.DateDelta)
  do return ((m_fmod(t, 7)) + 1) end
end

-- datetime.c:482
F.datetime_hourOfDay = function(date)
  local hour = {0}
  local min = {0}
  local sec = {0}
  F.datetime_decodeTime(date, hour, 1, min, 1, sec, 1)
  do return hour[1] end
end

-- datetime.c:496
F.datetime_daysPerMonth = function(year, month)
  if ((month < 1) or (month > 12)) then
    do return 0 end
  end
  do return (G.DaysPerMonth[F.isLeapYear(year)])[(month - 1)] end
end

-- datetime.c:510
F.datetime_getTimeStamp = function(fmt, aDate, stampSize, timeStamp)
  local dateStr = R.buf(12)
  local timeStr = R.buf(9)
  local oldDateFormat = G.DateFormat
  if (stampSize < 21) then
    do return end
  end
  F.datetime_setDateFormat(fmt)
  F.datetime_dateToStr(aDate, dateStr)
  G.DateFormat = oldDateFormat
  F.datetime_timeToStr(aDate, timeStr)
  R.snprintf(timeStamp, stampSize, S[44], dateStr, timeStr)
end

