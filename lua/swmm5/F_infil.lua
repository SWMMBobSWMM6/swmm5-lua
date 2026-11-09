-- Generated from EPA SWMM 5.2.4 (infil.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local ERR_MEMORY <const> = 101
local SUBCATCH <const> = 1
local ERR_NAME <const> = 209
local HORTON <const> = 0
local MOD_HORTON <const> = 1
local GREEN_AMPT <const> = 2
local MOD_GREEN_AMPT <const> = 3
local CURVE_NUMBER <const> = 4
local ERR_ITEMS <const> = 203
local ERR_NUMBER <const> = 211
local ERR_INFIL_PARAMS <const> = 235
local MONTHLY_PATTERN <const> = 0
local RAINFALL <const> = 0
local RAINDEPTH <const> = 1
local _ENV = R.strict

G.Infil = nil
G.Fumax = 0.0
G.InfilFactor = 0.0

-- infil.c:101
F.infil_create = function(n)
  G.Infil = R.recs(n, T.TInfil)
  if (G.Infil == (nil)) then
    G.ErrorCode = ERR_MEMORY
  end
  G.InfilFactor = 1.0
  do return end
end

-- infil.c:116
F.infil_delete = function()
  do
    if (G.Infil ~= nil) then
      local _ = nil
      G.Infil = (nil)
    end
  end
end

-- infil.c:128
F.infil_readParams = function(m, tok, ntoks)
  local G_Subcatch, G_Infil = G.Subcatch, G.Infil
  local i = 0
  local j = 0
  local n = 0
  local status = 0
  local x = R.fill(5, 0.0)
  j = F.project_findObject(SUBCATCH, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  i = F.findmatch(tok[(ntoks - 1)], G.InfilModelWords)
  if (i >= 0) then
    m = i
    ntoks = ntoks - 1
  end
  if (m == HORTON) then
    n = 5
  elseif (m == MOD_HORTON) then
    n = 5
  elseif (m == GREEN_AMPT) then
    n = 4
  elseif (m == MOD_GREEN_AMPT) then
    n = 4
  elseif (m == CURVE_NUMBER) then
    n = 4
  else
    do return 0 end
  end
  if (ntoks < n) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  do
    i = 0
    while (i < 5) do
      do
        x[i] = 0.0
      end
      i = i + 1
    end
  end
  do
    i = 1
    while (i < n) do
      do
        if (not (F.getDouble(tok[i], x, (i - 1)) ~= 0)) then
          do return F.error_setInpError(ERR_NUMBER, tok[i]) end
        end
      end
      i = i + 1
    end
  end
  if ((((m == HORTON) or (m == MOD_HORTON))) and (ntoks > n)) then
    if (not (F.getDouble(tok[n], x, (n - 1)) ~= 0)) then
      do return F.error_setInpError(ERR_NUMBER, tok[n]) end
    end
  end
  G_Subcatch[j].infil = j
  G_Subcatch[j].infilModel = m
  do
    local __sw1 = m
    if __sw1 == HORTON or __sw1 == MOD_HORTON then goto case4
    elseif __sw1 == GREEN_AMPT or __sw1 == MOD_GREEN_AMPT then goto case5
    elseif __sw1 == CURVE_NUMBER then goto case6
    else goto case7 end
    ::case4::
    do
      status = F.horton_setParams(G_Infil[j].horton, x)
      goto swend3
    end
    ::case5::
    do
      status = F.grnampt_setParams(G_Infil[j].grnAmpt, x)
      goto swend3
    end
    ::case6::
    do
      status = F.curvenum_setParams(G_Infil[j].curveNum, x)
      goto swend3
    end
    ::case7::
    do
      status = 1
    end
    ::swend3::
  end
  if (not (status ~= 0)) then
    do return F.error_setInpError(ERR_INFIL_PARAMS, S[0]) end
  end
  do return 0 end
end

-- infil.c:201
F.infil_initState = function(j)
  local G_Infil = G.Infil
  do
    local __sw1 = G.Subcatch[j].infilModel
    if __sw1 == HORTON or __sw1 == MOD_HORTON then goto case2
    elseif __sw1 == GREEN_AMPT or __sw1 == MOD_GREEN_AMPT then goto case3
    elseif __sw1 == CURVE_NUMBER then goto case4
    else goto swend1 end
    ::case2::
    do
      F.horton_initState(G_Infil[j].horton)
      goto swend1
    end
    ::case3::
    do
      F.grnampt_initState(G_Infil[j].grnAmpt)
      goto swend1
    end
    ::case4::
    do
      F.curvenum_initState(G_Infil[j].curveNum)
      goto swend1
    end
    ::swend1::
  end
end

-- infil.c:221
F.infil_getState = function(j, x)
  local G_Infil = G.Infil
  do
    local __sw1 = G.Subcatch[j].infilModel
    if __sw1 == HORTON or __sw1 == MOD_HORTON then goto case2
    elseif __sw1 == GREEN_AMPT or __sw1 == MOD_GREEN_AMPT then goto case3
    elseif __sw1 == CURVE_NUMBER then goto case4
    else goto swend1 end
    ::case2::
    do
      F.horton_getState(G_Infil[j].horton, x)
      goto swend1
    end
    ::case3::
    do
      F.grnampt_getState(G_Infil[j].grnAmpt, x)
      goto swend1
    end
    ::case4::
    do
      F.curvenum_getState(G_Infil[j].curveNum, x)
      goto swend1
    end
    ::swend1::
  end
end

-- infil.c:241
F.infil_setState = function(j, x)
  local G_Infil = G.Infil
  do
    local __sw1 = G.Subcatch[j].infilModel
    if __sw1 == HORTON or __sw1 == MOD_HORTON then goto case2
    elseif __sw1 == GREEN_AMPT or __sw1 == MOD_GREEN_AMPT then goto case3
    elseif __sw1 == CURVE_NUMBER then goto case4
    else goto swend1 end
    ::case2::
    do
      F.horton_setState(G_Infil[j].horton, x)
      goto swend1
    end
    ::case3::
    do
      F.grnampt_setState(G_Infil[j].grnAmpt, x)
      goto swend1
    end
    ::case4::
    do
      F.curvenum_setState(G_Infil[j].curveNum, x)
      goto swend1
    end
    ::swend1::
  end
end

-- infil.c:262
F.infil_setInfilFactor = function(j)
  local G_Pattern = G.Pattern
  local m = 0
  local p = 0
  G.InfilFactor = G.Adjust.hydconFactor
  if (j >= 0) then
    p = G.Subcatch[j].infilPattern
    if ((p >= 0) and (G_Pattern[p].type_ == MONTHLY_PATTERN)) then
      m = (F.datetime_monthOfYear(F.getDateTime(G.OldRunoffTime)) - 1)
      G.InfilFactor = G_Pattern[p].factor[m]
    end
  end
end

-- infil.c:288
F.infil_getInfil = function(j, tstep, rainfall, runon, depth)
  local G_Subcatch, G_Infil = G.Subcatch, G.Infil
  do
    local __sw1 = G_Subcatch[j].infilModel
    if __sw1 == HORTON then goto case2
    elseif __sw1 == MOD_HORTON then goto case3
    elseif __sw1 == GREEN_AMPT or __sw1 == MOD_GREEN_AMPT then goto case4
    elseif __sw1 == CURVE_NUMBER then goto case5
    else goto case6 end
    ::case2::
    do
      do return F.horton_getInfil(G_Infil[j].horton, tstep, (rainfall + runon), depth) end
    end
    ::case3::
    do
      do return F.modHorton_getInfil(G_Infil[j].horton, tstep, (rainfall + runon), depth) end
    end
    ::case4::
    do
      do return F.grnampt_getInfil(G_Infil[j].grnAmpt, tstep, (rainfall + runon), depth, G_Subcatch[j].infilModel) end
    end
    ::case5::
    do
      depth = (depth + (runon * tstep))
      do return F.curvenum_getInfil(G_Infil[j].curveNum, tstep, rainfall, depth) end
    end
    ::case6::
    do
      do return 0.0 end
    end
    ::swend1::
  end
end

-- infil.c:325
F.horton_setParams = function(infil, p)
  local k = 0
  do
    k = 0
    while (k < 5) do
      do
        if (p[k] < 0.0) then
          do return 0 end
        end
      end
      k = k + 1
    end
  end
  infil.f0 = (p[0] / F.UCF(RAINFALL))
  infil.fmin = (p[1] / F.UCF(RAINFALL))
  infil.decay = (p[2] / 3600.0)
  if (p[3] == 0.0) then
    p[3] = 1e-06
  end
  infil.regen = (((-(R.log((1.0 - 0.98)))) / p[3]) / 86400.0)
  infil.Fmax = (p[4] / F.UCF(RAINDEPTH))
  if (infil.f0 < infil.fmin) then
    do return 0 end
  end
  do return 1 end
end

-- infil.c:357
F.horton_initState = function(infil)
  infil.tp = 0.0
  infil.Fe = 0.0
end

-- infil.c:370
F.horton_getState = function(infil, x)
  x[0] = infil.tp
  x[1] = infil.Fe
end

-- infil.c:376
F.horton_setState = function(infil, x)
  infil.tp = x[0]
  infil.Fe = x[1]
end

-- infil.c:384
F.horton_getInfil = function(infil, tstep, irate, depth)
  local iter = 0
  local fa = 0.0
  local fp = 0.0
  local Fp = 0.0
  local F1 = 0.0
  local t1 = 0.0
  local tlim = 0.0
  local ex = 0.0
  local kt = 0.0
  local FF = 0.0
  local FF1 = 0.0
  local r = 0.0
  local f0 = (infil.f0 * G.InfilFactor)
  local fmin = (infil.fmin * G.InfilFactor)
  local Fmax = infil.Fmax
  local tp = infil.tp
  local df = (f0 - fmin)
  local kd = infil.decay
  local kr = (infil.regen * G.Evap.recoveryFactor)
  if (((df < 0.0) or (kd < 0.0)) or (kr < 0.0)) then
    do return 0.0 end
  end
  if ((df == 0.0) or (kd == 0.0)) then
    fp = f0
    fa = (irate + (depth / tstep))
    if (fp > fa) then
      fp = fa
    end
    do return (((((0.0) >= (fp))) and (0.0) or (fp))) end
  end
  fa = (irate + (depth / tstep))
  if (fa > 1e-10) then
    t1 = (tp + tstep)
    tlim = (16.0 / kd)
    if (tp >= tlim) then
      Fp = ((fmin * tp) + (df / kd))
      F1 = (Fp + (fmin * tstep))
    else
      Fp = ((fmin * tp) + ((df / kd) * ((1.0 - m_exp(((-kd) * tp))))))
      F1 = ((fmin * t1) + ((df / kd) * ((1.0 - m_exp(((-kd) * t1))))))
    end
    fp = (((F1 - Fp)) / tstep)
    fp = (((((fp) >= (fmin))) and (fp) or (fmin)))
    if (fp > fa) then
      fp = fa
    end
    if (t1 > tlim) then
      tp = t1
    elseif (fp < fa) then
      tp = t1
    else
      F1 = (Fp + (fp * tstep))
      tp = (tp + (tstep / 2.0))
      do
        iter = 1
        while (iter <= 20) do
          do
            kt = (((((60.0) <= ((kd * tp)))) and (60.0) or ((kd * tp))))
            ex = m_exp((-kt))
            FF = (((fmin * tp) + ((df / kd) * ((1.0 - ex)))) - F1)
            FF1 = (fmin + (df * ex))
            r = (FF / FF1)
            tp = (tp - r)
            if (m_abs(r) <= (0.001 * tstep)) then
              break
            end
          end
          iter = iter + 1
        end
      end
    end
    if (Fmax > 0.0) then
      if ((infil.Fe + (fp * tstep)) > Fmax) then
        fp = (((Fmax - infil.Fe)) / tstep)
      end
      fp = (((((fp) >= (0.0))) and (fp) or (0.0)))
      infil.Fe = (infil.Fe + (fp * tstep))
    end
  elseif (kr > 0.0) then
    r = m_exp(((-kr) * tstep))
    tp = (1.0 - m_exp(((-kd) * tp)))
    tp = ((-(R.log((1.0 - (r * tp))))) / kd)
    if (Fmax > 0.0) then
      infil.Fe = ((fmin * tp) + (((df / kd)) * ((1.0 - m_exp(((-kd) * tp))))))
    end
  end
  infil.tp = tp
  do return fp end
end

-- infil.c:496
F.modHorton_getInfil = function(infil, tstep, irate, depth)
  local f = 0.0
  local fp = 0.0
  local fa = 0.0
  local f0 = (infil.f0 * G.InfilFactor)
  local fmin = (infil.fmin * G.InfilFactor)
  local df = (f0 - fmin)
  local kd = infil.decay
  local kr = (infil.regen * G.Evap.recoveryFactor)
  if (((df < 0.0) or (kd < 0.0)) or (kr < 0.0)) then
    do return 0.0 end
  end
  if ((df == 0.0) or (kd == 0.0)) then
    fp = f0
    fa = (irate + (depth / tstep))
    if (fp > fa) then
      fp = fa
    end
    do return (((((0.0) >= (fp))) and (0.0) or (fp))) end
  end
  fa = (irate + (depth / tstep))
  if (fa > 1e-10) then
    if ((infil.Fmax > 0.0) and (infil.Fe >= infil.Fmax)) then
      do return 0.0 end
    end
    fp = (f0 - (kd * infil.Fe))
    fp = (((((fp) >= (fmin))) and (fp) or (fmin)))
    f = (((((fa) <= (fp))) and (fa) or (fp)))
    infil.Fe = (infil.Fe + ((((((((f - fmin))) >= (0.0))) and (((f - fmin))) or (0.0))) * tstep))
    if (infil.Fmax > 0.0) then
      infil.Fe = (((((infil.Fe) >= (infil.Fmax))) and (infil.Fe) or (infil.Fmax)))
    end
  elseif (kr > 0.0) then
    infil.Fe = (infil.Fe * (m_exp(((-kr) * tstep))))
    infil.Fe = (((((infil.Fe) >= (0.0))) and (infil.Fe) or (0.0)))
  end
  do return f end
end

-- infil.c:559
F.grnampt_getParams = function(j, p)
  local G_Infil = G.Infil
  p[0] = (G_Infil[j].grnAmpt.S_ * F.UCF(RAINDEPTH))
  p[1] = (G_Infil[j].grnAmpt.Ks * F.UCF(RAINFALL))
  p[2] = G_Infil[j].grnAmpt.IMDmax
end

-- infil.c:574
F.grnampt_setParams = function(infil, p)
  local ksat = 0.0
  if ((((p[0] < 0.0) or (p[1] <= 0.0)) or (p[2] < 0.0)) or (p[2] > 1.0)) then
    do return 0 end
  end
  infil.S_ = (p[0] / F.UCF(RAINDEPTH))
  infil.Ks = (p[1] / F.UCF(RAINFALL))
  infil.IMDmax = p[2]
  ksat = ((infil.Ks * 12.0) * 3600.0)
  infil.Lu = ((4.0 * m_sqrt(ksat)) / 12.0)
  do return 1 end
end

-- infil.c:597
F.grnampt_initState = function(infil)
  if (infil == (nil)) then
    do return end
  end
  infil.IMD = infil.IMDmax
  infil.Fu = 0.0
  infil.F_ = 0.0
  infil.Sat = 0
  infil.T_ = 0.0
end

-- infil.c:612
F.grnampt_getState = function(infil, x)
  x[0] = infil.IMD
  x[1] = infil.F_
  x[2] = infil.Fu
  x[3] = (infil.Sat * 1.0)
  x[4] = infil.T_
end

-- infil.c:621
F.grnampt_setState = function(infil, x)
  infil.IMD = x[0]
  infil.F_ = x[1]
  infil.Fu = x[2]
  infil.Sat = R.i8(R.D2I(x[3]))
  infil.T_ = x[4]
end

-- infil.c:632
F.grnampt_getInfil = function(infil, tstep, irate, depth, modelType)
  G.Fumax = ((infil.IMDmax * infil.Lu) * m_sqrt(G.InfilFactor))
  infil.T_ = (infil.T_ - tstep)
  if (infil.Sat ~= 0) then
    do return F.grnampt_getSatInfil(infil, tstep, irate, depth) end
  else
    do return F.grnampt_getUnsatInfil(infil, tstep, irate, depth, modelType) end
  end
end

-- infil.c:660
F.grnampt_getUnsatInfil = function(infil, tstep, irate, depth, modelType)
  local G_Evap = G.Evap
  local ia = 0.0
  local c1 = 0.0
  local F2 = 0.0
  local dF = 0.0
  local Fs = 0.0
  local kr = 0.0
  local ts = 0.0
  local ks = (infil.Ks * G.InfilFactor)
  local lu = (infil.Lu * m_sqrt(G.InfilFactor))
  ia = (irate + (depth / tstep))
  if (ia < 1e-10) then
    ia = 0.0
  end
  if (ia == 0.0) then
    if (infil.Fu <= 0.0) then
      do return 0.0 end
    end
    kr = ((lu / 90000.0) * G_Evap.recoveryFactor)
    dF = ((kr * G.Fumax) * tstep)
    infil.F_ = (infil.F_ - dF)
    infil.Fu = (infil.Fu - dF)
    if (infil.Fu <= 0.0) then
      infil.Fu = 0.0
      infil.F_ = 0.0
      infil.IMD = infil.IMDmax
      do return 0.0 end
    end
    if (infil.T_ <= 0.0) then
      infil.IMD = (((G.Fumax - infil.Fu)) / lu)
      infil.F_ = 0.0
    end
    do return 0.0 end
  end
  if (ia <= ks) then
    dF = (ia * tstep)
    infil.F_ = (infil.F_ + dF)
    infil.Fu = (infil.Fu + dF)
    infil.Fu = (((((infil.Fu) <= (G.Fumax))) and (infil.Fu) or (G.Fumax)))
    if ((modelType == GREEN_AMPT) and (infil.T_ <= 0.0)) then
      infil.IMD = (((G.Fumax - infil.Fu)) / lu)
      infil.F_ = 0.0
    end
    do return ia end
  end
  infil.T_ = ((5400.0 / lu) / G_Evap.recoveryFactor)
  Fs = (((ks * ((infil.S_ + depth))) * infil.IMD) / ((ia - ks)))
  if (infil.F_ > Fs) then
    infil.Sat = 1
    do return F.grnampt_getSatInfil(infil, tstep, irate, depth) end
  end
  if ((infil.F_ + (ia * tstep)) < Fs) then
    dF = (ia * tstep)
    infil.F_ = (infil.F_ + dF)
    infil.Fu = (infil.Fu + dF)
    infil.Fu = (((((infil.Fu) <= (G.Fumax))) and (infil.Fu) or (G.Fumax)))
    do return ia end
  end
  ts = (tstep - (((Fs - infil.F_)) / ia))
  if (ts <= 0.0) then
    ts = 0.0
  end
  c1 = (((infil.S_ + depth)) * infil.IMD)
  F2 = F.grnampt_getF2(Fs, c1, ks, ts)
  if (F2 > (Fs + (ia * ts))) then
    F2 = (Fs + (ia * ts))
  end
  dF = (F2 - infil.F_)
  infil.F_ = F2
  infil.Fu = (infil.Fu + dF)
  infil.Fu = (((((infil.Fu) <= (G.Fumax))) and (infil.Fu) or (G.Fumax)))
  infil.Sat = 1
  do return (dF / tstep) end
end

-- infil.c:767
F.grnampt_getSatInfil = function(infil, tstep, irate, depth)
  local ia = 0.0
  local c1 = 0.0
  local dF = 0.0
  local F2 = 0.0
  local ks = (infil.Ks * G.InfilFactor)
  local lu = (infil.Lu * m_sqrt(G.InfilFactor))
  ia = (irate + (depth / tstep))
  if (ia < 1e-10) then
    do return 0.0 end
  end
  infil.T_ = ((5400.0 / lu) / G.Evap.recoveryFactor)
  c1 = (((infil.S_ + depth)) * infil.IMD)
  F2 = F.grnampt_getF2(infil.F_, c1, ks, tstep)
  dF = (F2 - infil.F_)
  if (dF > (ia * tstep)) then
    dF = (ia * tstep)
    infil.Sat = 0
  end
  infil.F_ = (infil.F_ + dF)
  infil.Fu = (infil.Fu + dF)
  infil.Fu = (((((infil.Fu) <= (G.Fumax))) and (infil.Fu) or (G.Fumax)))
  do return (dF / tstep) end
end

-- infil.c:813
F.grnampt_getF2 = function(f1, c1, ks, ts)
  local i = 0
  local f2 = f1
  local f2min = 0.0
  local df2 = 0.0
  local c2 = 0.0
  f2min = (f1 + (ks * ts))
  if (c1 == 0.0) then
    do return f2min end
  end
  if ((ts < 10.0) and (f1 > (0.01 * c1))) then
    f2 = (f1 + ((ks * ((1.0 + (c1 / f1)))) * ts))
    do return (((((f2) >= (f2min))) and (f2) or (f2min))) end
  end
  c2 = ((c1 * R.log((f1 + c1))) - (ks * ts))
  do
    i = 1
    while (i <= 20) do
      do
        df2 = (((((f2 - f1) - (c1 * R.log((f2 + c1)))) + c2)) / ((1.0 - (c1 / ((f2 + c1))))))
        if (m_abs(df2) < 1e-05) then
          do return (((((f2) >= (f2min))) and (f2) or (f2min))) end
        end
        f2 = (f2 - df2)
      end
      i = i + 1
    end
  end
  do return f2min end
end

-- infil.c:861
F.curvenum_setParams = function(infil, p)
  if (p[0] < 10.0) then
    p[0] = 10.0
  end
  if (p[0] > 99.0) then
    p[0] = 99.0
  end
  infil.Smax = ((((1000.0 / p[0]) - 10.0)) / 12.0)
  if (infil.Smax < 0.0) then
    do return 0 end
  end
  if (p[2] > 0.0) then
    infil.regen = (1.0 / ((p[2] * 86400.0)))
  else
    do return 0 end
  end
  infil.Tmax = (0.06 / infil.regen)
  do return 1 end
end

-- infil.c:888
F.curvenum_initState = function(infil)
  infil.S_ = infil.Smax
  infil.P = 0.0
  infil.F_ = 0.0
  infil.T_ = 0.0
  infil.Se = infil.Smax
  infil.f = 0.0
end

-- infil.c:903
F.curvenum_getState = function(infil, x)
  x[0] = infil.S_
  x[1] = infil.P
  x[2] = infil.F_
  x[3] = infil.T_
  x[4] = infil.Se
  x[5] = infil.f
end

-- infil.c:913
F.curvenum_setState = function(infil, x)
  infil.S_ = x[0]
  infil.P = x[1]
  infil.F_ = x[2]
  infil.T_ = x[3]
  infil.Se = x[4]
  infil.f = x[5]
end

-- infil.c:925
F.curvenum_getInfil = function(infil, tstep, irate, depth)
  local F1 = 0.0
  local f1 = 0.0
  local fa = (irate + (depth / tstep))
  if (irate > 1e-10) then
    if (infil.T_ >= infil.Tmax) then
      infil.P = 0.0
      infil.F_ = 0.0
      infil.f = 0.0
      infil.Se = infil.S_
    end
    infil.T_ = 0.0
    infil.P = (infil.P + (irate * tstep))
    F1 = (infil.P * ((1.0 - (infil.P / ((infil.P + infil.Se))))))
    f1 = (((F1 - infil.F_)) / tstep)
    if ((f1 < 0.0) or (infil.S_ <= 0.0)) then
      f1 = 0.0
    end
  else
    if ((depth > 0.004167) and (infil.S_ > 0.0)) then
      f1 = infil.f
      if ((f1 * tstep) > infil.S_) then
        f1 = (infil.S_ / tstep)
      end
    else
      infil.T_ = (infil.T_ + tstep)
    end
  end
  if (f1 > 0.0) then
    f1 = (((((f1) <= (fa))) and (f1) or (fa)))
    f1 = (((((f1) >= (0.0))) and (f1) or (0.0)))
    infil.F_ = (infil.F_ + (f1 * tstep))
    if (infil.regen > 0.0) then
      infil.S_ = (infil.S_ - (f1 * tstep))
      if (infil.S_ < 0.0) then
        infil.S_ = 0.0
      end
    end
  else
    infil.S_ = (infil.S_ + (((infil.regen * infil.Smax) * tstep) * G.Evap.recoveryFactor))
    if (infil.S_ > infil.Smax) then
      infil.S_ = infil.Smax
    end
  end
  infil.f = f1
  do return f1 end
end

