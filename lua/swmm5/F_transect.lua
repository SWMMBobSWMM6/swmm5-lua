-- Generated from EPA SWMM 5.2.4 (transect.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local ERR_MEMORY <const> = 101
local ERR_KEYWORD <const> = 205
local ERR_ITEMS <const> = 203
local ERR_NUMBER <const> = 211
local TRANSECT <const> = 10
local ERR_NAME <const> = 209
local ERR_TRANSECT_TOO_FEW <const> = 223
local ERR_TRANSECT_TOO_MANY <const> = 225
local ERR_TRANSECT_MANNING <const> = 227
local ERR_TRANSECT_OVERBANK <const> = 229
local ERR_TRANSECT_NO_DEPTH <const> = 231
local LENGTH <const> = 3
local ERR_TRANSECT_UNKNOWN <const> = 219
local ERR_TRANSECT_SEQUENCE <const> = 221
local _ENV = R.strict

G.Ntransects = 0
G.Nstations = 0
G.Station = R.fill(1501, 0.0)
G.Elev = R.fill(1501, 0.0)
G.Nleft = 0.0
G.Nright = 0.0
G.Nchannel = 0.0
G.Xleftbank = 0.0
G.Xrightbank = 0.0
G.Xfactor = 0.0
G.Yfactor = 0.0
G.Lfactor = 0.0

-- transect.c:70
F.transect_create = function(n)
  G.Ntransects = n
  if (n == 0) then
    do return 0 end
  end
  G.Transect = R.recs(G.Ntransects, T.TTransect)
  if (G.Transect == (nil)) then
    do return ERR_MEMORY end
  end
  G.Nchannel = 0.0
  G.Nleft = 0.0
  G.Nright = 0.0
  G.Nstations = 0
  do return 0 end
end

-- transect.c:90
F.transect_delete = function()
  if (G.Ntransects == 0) then
    do return end
  end
  do
    if (G.Transect ~= nil) then
      local _ = nil
      G.Transect = (nil)
    end
  end
  G.Ntransects = 0
end

-- transect.c:104
F.transect_readParams = function(count, count__k, tok, ntoks)
  local i = 0
  local k = 0
  local index = count[count__k]
  local errcode = 0
  local x = R.fill(10, 0.0)
  local id = nil
  k = F.findmatch(tok[0], G.TransectKeyWords)
  if (k < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[0]) end
  end
  do
    local __sw1 = k
    if __sw1 == 0 then goto case2
    elseif __sw1 == 1 then goto case3
    elseif __sw1 == 2 then goto case4
    else goto swend1 end
    ::case2::
    do
      F.transect_validate((index - 1))
      if (ntoks < 4) then
        do return F.error_setInpError(ERR_ITEMS, S[0]) end
      end
      do
        i = 1
        while (i <= 3) do
          do
            if (not (F.getDouble(tok[i], x, i) ~= 0)) then
              do return F.error_setInpError(ERR_NUMBER, tok[i]) end
            end
          end
          i = i + 1
        end
      end
      do return F.setManning(x) end
    end
    ::case3::
    do
      if (ntoks < 10) then
        do return F.error_setInpError(ERR_ITEMS, S[0]) end
      end
      id = F.project_findID(TRANSECT, tok[1])
      if R.peq(id, (nil)) then
        do return F.error_setInpError(ERR_NAME, tok[1]) end
      end
      do
        i = 2
        while (i < 10) do
          do
            if (not (F.getDouble(tok[i], x, i) ~= 0)) then
              do return F.error_setInpError(ERR_NUMBER, tok[i]) end
            end
          end
          i = i + 1
        end
      end
      count[count__k] = (index + 1)
      do return F.setParams(index, id, x) end
    end
    ::case4::
    do
      if (m_fmod(((ntoks - 1)), 2) > 0) then
        do return F.error_setInpError(ERR_ITEMS, S[0]) end
      end
      i = 1
      while (i < ntoks) do
        do
          if (not (F.getDouble(tok[i], x, 1) ~= 0)) then
            do return F.error_setInpError(ERR_NUMBER, tok[i]) end
          end
          if (not (F.getDouble(tok[(i + 1)], x, 2) ~= 0)) then
            do return F.error_setInpError(ERR_NUMBER, tok[(i + 1)]) end
          end
          errcode = F.addStation(x[1], x[2])
          if (errcode ~= 0) then
            do return errcode end
          end
          i = (i + 2)
        end
      end
      do return 0 end
    end
    ::swend1::
  end
  do return 0 end
end

-- transect.c:194
F.transect_validate = function(j)
  local G_Transect, G_Elev, G_Station = G.Transect, G.Elev, G.Station
  local i = 0
  local ymin = 0.0
  local ymax = 0.0
  local oldNchannel = G.Nchannel
  if ((j < 0) or (j >= G.Ntransects)) then
    do return end
  end
  if (G.Nstations < 2) then
    F.report_writeErrorMsg(ERR_TRANSECT_TOO_FEW, G_Transect[j].ID)
    do return end
  end
  if (G.Nstations >= 1500) then
    F.report_writeErrorMsg(ERR_TRANSECT_TOO_MANY, G_Transect[j].ID)
    do return end
  end
  if (G.Nchannel <= 0.0) then
    F.report_writeErrorMsg(ERR_TRANSECT_MANNING, G_Transect[j].ID)
    do return end
  end
  if (G.Xleftbank > G.Xrightbank) then
    F.report_writeErrorMsg(ERR_TRANSECT_OVERBANK, G_Transect[j].ID)
    do return end
  end
  G.Nchannel = (G.Nchannel * m_sqrt(G.Lfactor))
  G_Transect[j].lengthFactor = G.Lfactor
  ymax = G_Elev[1]
  ymin = G_Elev[1]
  do
    i = 2
    while (i <= G.Nstations) do
      do
        ymax = (((((G_Elev[i]) >= (ymax))) and (G_Elev[i]) or (ymax)))
        ymin = (((((G_Elev[i]) <= (ymin))) and (G_Elev[i]) or (ymin)))
      end
      i = i + 1
    end
  end
  if (ymin >= ymax) then
    F.report_writeErrorMsg(ERR_TRANSECT_NO_DEPTH, G_Transect[j].ID)
    do return end
  end
  G_Station[0] = G_Station[1]
  G_Elev[0] = ymax
  G.Nstations = G.Nstations + 1
  G_Station[G.Nstations] = G_Station[(G.Nstations - 1)]
  G_Elev[G.Nstations] = G_Elev[0]
  G_Transect[j].nTbl = 51
  F.createTables(G_Transect[j], ymin, ymax)
  G_Transect[j].roughness = oldNchannel
end

-- transect.c:264
F.createTables = function(transect, ymin, ymax)
  local i = 0
  local nLast = 0
  local dy = 0.0
  local y = 0.0
  transect.yFull = (ymax - ymin)
  transect.wMax = 0.0
  transect.areaTbl[0] = 0.0
  transect.hradTbl[0] = 0.0
  transect.widthTbl[0] = 0.0
  dy = (((ymax - ymin)) / ((((transect.nTbl) * 1.0) - 1.0)))
  y = ymin
  do
    i = 1
    while (i < transect.nTbl) do
      do
        y = (y + dy)
        transect.areaTbl[i] = 0.0
        transect.hradTbl[i] = 0.0
        transect.widthTbl[i] = 0.0
        F.getGeometry(transect, i, y)
      end
      i = i + 1
    end
  end
  F.setMaxSectionFactor(transect)
  nLast = (transect.nTbl - 1)
  transect.aFull = transect.areaTbl[nLast]
  transect.rFull = transect.hradTbl[nLast]
  transect.wMax = transect.widthTbl[nLast]
  do
    i = 1
    while (i <= nLast) do
      do
        transect.areaTbl[i] = (transect.areaTbl[i] / transect.aFull)
        transect.hradTbl[i] = (transect.hradTbl[i] / transect.rFull)
        transect.widthTbl[i] = (transect.widthTbl[i] / transect.wMax)
      end
      i = i + 1
    end
  end
  transect.widthTbl[0] = transect.widthTbl[1]
end

-- transect.c:312
F.setManning = function(n)
  local i = 0
  do
    i = 1
    while (i <= 3) do
      do
        if (n[i] < 0.0) then
          do return ERR_NUMBER end
        end
      end
      i = i + 1
    end
  end
  if (n[1] > 0.0) then
    G.Nleft = n[1]
  end
  if (n[2] > 0.0) then
    G.Nright = n[2]
  end
  if (n[3] > 0.0) then
    G.Nchannel = n[3]
  end
  if (G.Nleft == 0.0) then
    G.Nleft = G.Nchannel
  end
  if (G.Nright == 0.0) then
    G.Nright = G.Nchannel
  end
  do return 0 end
end

-- transect.c:334
F.setParams = function(j, id, x)
  if ((j < 0) or (j >= G.Ntransects)) then
    do return ERR_NUMBER end
  end
  G.Transect[j].ID = id
  G.Xleftbank = (x[3] / F.UCF(LENGTH))
  G.Xrightbank = (x[4] / F.UCF(LENGTH))
  G.Lfactor = x[7]
  if (G.Lfactor == 0.0) then
    G.Lfactor = 1.0
  end
  G.Xfactor = x[8]
  if (G.Xfactor == 0.0) then
    G.Xfactor = 1.0
  end
  G.Xleftbank = (G.Xleftbank * G.Xfactor)
  G.Xrightbank = (G.Xrightbank * G.Xfactor)
  G.Yfactor = (x[9] / F.UCF(LENGTH))
  G.Nstations = 0
  do return 0 end
end

-- transect.c:360
F.addStation = function(y, x)
  local G_Station = G.Station
  if (G.Nstations < 0) then
    do return ERR_TRANSECT_UNKNOWN end
  end
  G.Nstations = G.Nstations + 1
  if (G.Nstations >= 1500) then
    do return 0 end
  end
  G_Station[G.Nstations] = ((x * G.Xfactor) / F.UCF(LENGTH))
  G.Elev[G.Nstations] = (((y + G.Yfactor)) / F.UCF(LENGTH))
  if ((G.Nstations > 1) and (G_Station[G.Nstations] < G_Station[(G.Nstations - 1)])) then
    do return ERR_TRANSECT_SEQUENCE end
  end
  do return 0 end
end

-- transect.c:388
F.getGeometry = function(transect, i, y)
  local G_Elev = G.Elev
  local k = 0
  local ylo = 0.0
  local yhi = 0.0
  local w = {0.0}
  local wp = {0.0}
  local wpSum = 0.0
  local a = {0.0}
  local aSum = 0.0
  local q = 0.0
  local qSum = 0.0
  local findFlow = 0
  wpSum = 0.0
  aSum = 0.0
  qSum = 0.0
  do
    k = 1
    while (k <= G.Nstations) do
      do
        if (G_Elev[(k - 1)] >= G_Elev[k]) then
          yhi = G_Elev[(k - 1)]
          ylo = G_Elev[k]
        else
          yhi = G_Elev[k]
          ylo = G_Elev[(k - 1)]
        end
        if (ylo >= y) then
          goto continue1
        end
        F.getSliceGeom(k, y, ylo, yhi, w, 1, a, 1, wp, 1)
        wpSum = (wpSum + wp[1])
        aSum = (aSum + a[1])
        transect.areaTbl[i] = (transect.areaTbl[i] + a[1])
        transect.widthTbl[i] = (transect.widthTbl[i] + w[1])
        if (G_Elev[k] >= y) then
          findFlow = 1
        else
          findFlow = 0
        end
        q = F.getFlow(k, aSum, wpSum, findFlow)
        if (q > 0.0) then
          qSum = (qSum + q)
          aSum = 0.0
          wpSum = 0.0
        end
      end
      ::continue1::
      k = k + 1
    end
  end
  aSum = transect.areaTbl[i]
  if (aSum == 0.0) then
    transect.hradTbl[i] = transect.hradTbl[(i - 1)]
  else
    transect.hradTbl[i] = ((((qSum * G.Nchannel) / 1.49) / aSum) ^ 1.5)
  end
end

-- transect.c:468
F.getSliceGeom = function(k, y, ylo, yhi, w, w__k, a, a__k, wp, wp__k)
  local G_Station = G.Station
  local width = 0.0
  local ratio = 0.0
  width = m_abs((G_Station[k] - G_Station[(k - 1)]))
  w[w__k] = width
  wp[wp__k] = m_sqrt(((width * width) + (((yhi - ylo)) * ((yhi - ylo)))))
  a[a__k] = 0.0
  if (y > yhi) then
    a[a__k] = ((width * ((((y - yhi)) + ((y - ylo))))) / 2.0)
  elseif (yhi > ylo) then
    ratio = (((y - ylo)) / ((yhi - ylo)))
    a[a__k] = ((((width * ((yhi - ylo))) / 2.0) * ratio) * ratio)
    w[w__k] = (w[w__k] * ratio)
    wp[wp__k] = (wp[wp__k] * ratio)
  end
end

-- transect.c:519
F.getFlow = function(k, a, wp, findFlow)
  local G_Station = G.Station
  local n = 0.0
  if (findFlow == 0) then
    if (k == (G.Nstations - 1)) then
      findFlow = 1
    elseif (G_Station[k] == G.Xleftbank) then
      if ((G.Nleft ~= G.Nchannel) and (G_Station[k] ~= G_Station[(k - 1)])) then
        findFlow = 1
      end
    elseif (G_Station[k] == G.Xrightbank) then
      if ((G.Nright ~= G.Nchannel) and (G_Station[k] ~= G_Station[(k + 1)])) then
        findFlow = 1
      end
    end
  end
  if (findFlow ~= 0) then
    n = G.Nchannel
    if (G_Station[(k - 1)] < G.Xleftbank) then
      n = G.Nleft
    end
    if (G_Station[k] > G.Xrightbank) then
      n = G.Nright
    end
    do return (((1.486 / n) * a) * ((a / wp) ^ (2.0 / 3.0))) end
  end
  do return 0.0 end
end

-- transect.c:570
F.setMaxSectionFactor = function(transect)
  local i = 0
  local sf = 0.0
  transect.aMax = 0.0
  transect.sMax = 0.0
  do
    i = 1
    while (i < transect.nTbl) do
      do
        sf = (transect.areaTbl[i] * (transect.hradTbl[i] ^ (2.0 / 3.0)))
        if (sf > transect.sMax) then
          transect.sMax = sf
          transect.aMax = transect.areaTbl[i]
        end
      end
      i = i + 1
    end
  end
end

-- transect.c:596
F.transect_createStreetTransect = function(street)
  local G_Station, G_Elev = G.Station, G.Elev
  local ymin = 0.0
  local ymax = 0.0
  local y1 = 0.0
  local y3 = 0.0
  local y4 = 0.0
  local w1 = 0.0
  local w2 = 0.0
  local w3 = 0.0
  local w4 = 0.0
  ymin = 0.0
  w1 = street.backWidth
  w2 = street.gutterWidth
  w3 = street.width
  w4 = (w3 - w2)
  y3 = (street.gutterDepression + (street.slope * w2))
  y1 = (street.curbHeight + street.gutterDepression)
  ymax = ((street.backSlope * street.backWidth) + y1)
  y4 = (y3 + (street.slope * w4))
  ymax = (((((ymax) >= (y4))) and (ymax) or (y4)))
  G_Station[0] = 0.0
  G_Elev[0] = ymax
  G_Station[1] = w1
  G_Elev[1] = y1
  G_Station[2] = w1
  G_Elev[2] = 0.0
  G_Station[3] = (w1 + w2)
  G_Elev[3] = y3
  G_Station[4] = (w1 + w3)
  G_Elev[4] = y4
  if (street.sides == 1) then
    G_Station[5] = G_Station[4]
    G_Elev[5] = ymax
    G.Nstations = 5
    street.transect.nTbl = 51
  else
    G_Station[5] = (G_Station[4] + w4)
    G_Elev[5] = y3
    G_Station[6] = (G_Station[5] + w2)
    G_Elev[6] = 0.0
    G_Station[7] = G_Station[6]
    G_Elev[7] = y1
    G_Station[8] = (G_Station[7] + w1)
    G_Elev[8] = ymax
    G.Nstations = 8
    street.transect.nTbl = 51
  end
  G.Nchannel = street.roughness
  if (street.backWidth == 0.0) then
    G.Nleft = G.Nchannel
    G.Nright = G.Nchannel
    G.Xleftbank = G_Station[0]
    G.Xrightbank = G_Station[G.Nstations]
  else
    G.Nleft = street.backRoughness
    G.Nright = G.Nleft
    G.Xleftbank = G_Station[1]
    if (street.sides == 2) then
      G.Xrightbank = G_Station[(G.Nstations - 1)]
    else
      G.Xrightbank = G_Station[G.Nstations]
    end
  end
  F.createTables(street.transect, ymin, ymax)
  street.transect.roughness = street.roughness
end

