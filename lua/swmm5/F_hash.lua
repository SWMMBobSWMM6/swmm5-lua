-- Generated from EPA SWMM 5.2.4 (hash.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local _ENV = R.strict


-- hash.c:24
F.samestr = function(s1, s2)
  local i = 0
  do
    i = 0
    while (((((((s1.b[s1.o + i]) >= 97) and ((s1.b[s1.o + i]) <= 122))) and (((s1.b[s1.o + i]) & (~32))) or (s1.b[s1.o + i]))) == ((((((s2.b[s2.o + i]) >= 97) and ((s2.b[s2.o + i]) <= 122))) and (((s2.b[s2.o + i]) & (~32))) or (s2.b[s2.o + i])))) do
      do
        if ((not (s1.b[s1.o + (i + 1)] ~= 0)) and (not (s2.b[s2.o + (i + 1)] ~= 0))) then
          do return (1) end
        end
      end
      i = i + 1
    end
  end
  do return (0) end
end

-- hash.c:33
F.hash = function(str)
  local sum1 = 0
  local check1 = 0
  local sum2 = 0
  while (0 ~= str.b[str.o]) do
    do
      sum1 = ((sum1 + (((((((str.b[str.o]) >= 97) and ((str.b[str.o]) <= 122))) and (((str.b[str.o]) & (~32))) or (str.b[str.o]))) & 0xFFFFFFFF)) & 0xFFFFFFFF)
      str = R.padd(str, 1)
      if (255 <= sum1) then
        sum1 = ((sum1 - 255) & 0xFFFFFFFF)
      end
      sum2 = (sum2 + sum1)
    end
  end
  check1 = (sum2 & 0xFFFFFFFF)
  check1 = m_fmod(check1, 255)
  check1 = ((255 - m_fmod((((sum1 + check1) & 0xFFFFFFFF)), 255)) & 0xFFFFFFFF)
  sum1 = ((255 - m_fmod((((sum1 + check1) & 0xFFFFFFFF)), 255)) & 0xFFFFFFFF)
  do return (m_fmod((((((check1 << 8) & 0xFFFFFFFF)) | sum1)), 1999)) end
end

-- hash.c:51
F.HTcreate = function()
  local i = 0
  local ht = {}
  if (ht ~= (nil)) then
    do
      i = 0
      while (i < 1999) do
        do
          ht[i] = (nil)
        end
        i = i + 1
      end
    end
  end
  do return (ht) end
end

-- hash.c:59
F.HTinsert = function(ht, key, data)
  local i = F.hash(key)
  local entry = nil
  if (i >= 1999) then
    do return (0) end
  end
  entry = T.HTentry()
  if (entry == (nil)) then
    do return (0) end
  end
  entry.key = key
  entry.data = data
  entry.next_ = ht[i]
  ht[i] = entry
  do return (1) end
end

-- hash.c:73
F.HTfind = function(ht, key)
  local i = F.hash(key)
  local entry = nil
  if (i >= 1999) then
    do return ((-1)) end
  end
  entry = ht[i]
  while (entry ~= (nil)) do
    do
      if (F.samestr(entry.key, key) ~= 0) then
        do return (entry.data) end
      end
      entry = entry.next_
    end
  end
  do return ((-1)) end
end

-- hash.c:87
F.HTfindKey = function(ht, key)
  local i = F.hash(key)
  local entry = nil
  if (i >= 1999) then
    do return ((nil)) end
  end
  entry = ht[i]
  while (entry ~= (nil)) do
    do
      if (F.samestr(entry.key, key) ~= 0) then
        do return (entry.key) end
      end
      entry = entry.next_
    end
  end
  do return ((nil)) end
end

-- hash.c:101
F.HTfree = function(ht)
  local entry = nil
  local nextentry = nil
  local i = 0
  do
    i = 0
    while (i < 1999) do
      do
        entry = ht[i]
        while (entry ~= (nil)) do
          do
            nextentry = entry.next_
            local _ = nil
            entry = nextentry
          end
        end
      end
      i = i + 1
    end
  end
  local _ = nil
end

