-- Generated from EPA SWMM 5.2.4 (report.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local ERR_ITEMS <const> = 203
local ERR_KEYWORD <const> = 205
local NO <const> = 0
local YES <const> = 1
local SUBCATCH <const> = 1
local NODE <const> = 2
local LINK <const> = 3
local NONE <const> = 0
local ALL <const> = 1
local SOME <const> = 2
local ERR_NAME <const> = 209
local GAGE <const> = 0
local UNITHYD <const> = 12
local SNOWMELT <const> = 13
local AQUIFER <const> = 11
local POLLUT <const> = 4
local DW <const> = 4
local LENGTH <const> = 3
local US <const> = 0
local LANDAREA <const> = 4
local USE_FILE <const> = 2
local RAINDEPTH <const> = 1
local COUNT <const> = 2
local SUBCATCH_RAINFALL <const> = 0
local SUBCATCH_EVAP <const> = 2
local SUBCATCH_INFIL <const> = 3
local SUBCATCH_RUNOFF <const> = 4
local SUBCATCH_SNOWDEPTH <const> = 1
local SUBCATCH_GW_ELEV <const> = 6
local SUBCATCH_GW_FLOW <const> = 5
local SUBCATCH_WASHOFF <const> = 8
local NODE_INFLOW <const> = 4
local NODE_OVERFLOW <const> = 5
local NODE_DEPTH <const> = 0
local NODE_HEAD <const> = 1
local NODE_QUAL <const> = 6
local LINK_FLOW <const> = 0
local LINK_VELOCITY <const> = 2
local LINK_DEPTH <const> = 1
local LINK_CAPACITY <const> = 4
local LINK_QUAL <const> = 5
local ERR_INPUT <const> = 200
local ERR_FILE_NAME <const> = 301
local ERR_MEMORY <const> = 101
local ERR_TIMESTEP <const> = 107
local ERR_OUT_FILE <const> = 307
local ERR_SYSTEM <const> = 500
local ERR_CURVE_SEQUENCE <const> = 171
local ERR_TIMESERIES_SEQUENCE <const> = 173
local _ENV = R.strict

G.SysTime = 0

-- report.c:93
F.report_readOptions = function(tok, ntoks)
  local G_RptFlags, G_Subcatch, G_Node, G_Link = G.RptFlags, G.Subcatch, G.Node, G.Link
  local k = 0
  local j = 0
  local m = 0
  local t = 0
  if (ntoks < 2) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  k = R.i8(F.findmatch(tok[0], G.ReportWords))
  if (k < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[0]) end
  end
  if ((k < 2) or (k > 4)) then
    m = F.findmatch(tok[1], G.NoYesWords)
    if ((m < NO) or (m > YES)) then
      do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
    end
    do
      local __sw1 = k
      if __sw1 < 6 then
        if __sw1 == 0 then goto case2
        elseif __sw1 == 1 then goto case3
        elseif __sw1 == 5 then goto case4
        end
      else
        if __sw1 < 8 then
          if __sw1 == 6 then goto case5
          elseif __sw1 == 7 then goto case6
          end
        else
          if __sw1 == 8 then goto case7
          elseif __sw1 == 9 then goto case8
          end
        end
      end
      goto case9
      ::case2::
      do
        G_RptFlags.disabled = m
        do return 0 end
      end
      ::case3::
      do
        G_RptFlags.input = m
        do return 0 end
      end
      ::case4::
      do
        G_RptFlags.continuity = m
        do return 0 end
      end
      ::case5::
      do
        G_RptFlags.flowStats = m
        do return 0 end
      end
      ::case6::
      do
        G_RptFlags.controls = m
        do return 0 end
      end
      ::case7::
      do
        G_RptFlags.averages = m
        do return 0 end
      end
      ::case8::
      do
        do return 0 end
      end
      ::case9::
      do
        do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
      end
      ::swend1::
    end
  else
    do
      local __sw2 = k
      if __sw2 == 2 then goto case11
      elseif __sw2 == 3 then goto case12
      elseif __sw2 == 4 then goto case13
      else goto swend10 end
      ::case11::
      do
        m = SUBCATCH
        goto swend10
      end
      ::case12::
      do
        m = NODE
        goto swend10
      end
      ::case13::
      do
        m = LINK
        goto swend10
      end
      ::swend10::
    end
  end
  if (F.strcomp(tok[1], S[355]) ~= 0) then
    k = NONE
  elseif (F.strcomp(tok[1], S[351]) ~= 0) then
    k = ALL
  else
    k = SOME
    do
      t = 1
      while (t < ntoks) do
        do
          j = F.project_findObject(m, tok[t])
          if (j < 0) then
            do return F.error_setInpError(ERR_NAME, tok[t]) end
          end
          do
            local __sw3 = m
            if __sw3 == SUBCATCH then goto case16
            elseif __sw3 == NODE then goto case17
            elseif __sw3 == LINK then goto case18
            else goto swend15 end
            ::case16::
            do
              G_Subcatch[j].rptFlag = 1
              goto swend15
            end
            ::case17::
            do
              G_Node[j].rptFlag = 1
              goto swend15
            end
            ::case18::
            do
              G_Link[j].rptFlag = 1
              goto swend15
            end
            ::swend15::
          end
        end
        t = t + 1
      end
    end
  end
  do
    local __sw4 = m
    if __sw4 == SUBCATCH then goto case20
    elseif __sw4 == NODE then goto case21
    elseif __sw4 == LINK then goto case22
    else goto swend19 end
    ::case20::
    do
      G_RptFlags.subcatchments = k
      goto swend19
    end
    ::case21::
    do
      G_RptFlags.nodes = k
      goto swend19
    end
    ::case22::
    do
      G_RptFlags.links = k
      goto swend19
    end
    ::swend19::
  end
  do return 0 end
end

-- report.c:171
F.report_writeLine = function(line)
  local G_Frpt = G.Frpt
  if (G_Frpt.file ~= nil) then
    R.fprintf(G_Frpt.file, S[356], line)
  end
end

-- report.c:183
F.report_writeSysTime = function()
  local G_Frpt = G.Frpt
  local theTime = R.buf(9)
  local elapsedTime = 0.0
  local endTime = {0}
  if (G_Frpt.file ~= nil) then
    R.fprintf(G_Frpt.file, S[357], R.ctime(G.SysTime))
    endTime[1] = R.time()
    local _ = endTime[1]
    R.fprintf(G_Frpt.file, S[358], R.ctime(endTime[1]))
    elapsedTime = ((endTime[1] - G.SysTime) * 1.0)
    R.fprintf(G_Frpt.file, S[359])
    if (elapsedTime < 1.0) then
      R.fprintf(G_Frpt.file, S[360])
    else
      elapsedTime = (elapsedTime / 86400.0)
      if (elapsedTime >= 1.0) then
        R.fprintf(G_Frpt.file, S[361], R.D2I(R.floor(elapsedTime)))
        elapsedTime = (elapsedTime - (R.floor(elapsedTime)))
      end
      F.datetime_timeToStr(elapsedTime, theTime)
      R.fprintf(G_Frpt.file, S[169], theTime)
    end
  end
end

-- report.c:220
F.report_writeLogo = function()
  local G_Frpt = G.Frpt
  R.fprintf(G_Frpt.file, S[362])
  R.fprintf(G_Frpt.file, S[363])
  R.fprintf(G_Frpt.file, S[276])
  G.SysTime = R.time()
  local _ = G.SysTime
end

-- report.c:235
F.report_writeTitle = function()
  local G_Title = G.Title
  local i = 0
  local lineCount = 0
  if (G.ErrorCode ~= 0) then
    do return end
  end
  do
    i = 0
    while (i < 3) do
      do
        if (R.strlen(G_Title[i]) > 0) then
          F.report_writeLine((G_Title[i]))
          lineCount = lineCount + 1
        end
      end
      i = i + 1
    end
  end
end

-- report.c:254
F.report_writeOptions = function()
  local G_Frpt, G_Nobjects = G.Frpt, G.Nobjects
  local str = R.buf(80)
  F.report_writeLine((S[0]))
  F.report_writeLine((S[227]))
  F.report_writeLine((S[364]))
  F.report_writeLine((S[227]))
  R.fprintf(G_Frpt.file, S[365], G.FlowUnitWords[G.FlowUnits])
  R.fprintf(G_Frpt.file, S[366])
  R.fprintf(G_Frpt.file, S[367])
  if ((G.IgnoreRainfall ~= 0) or (G_Nobjects[GAGE] == 0)) then
    R.fprintf(G_Frpt.file, S[4])
  else
    R.fprintf(G_Frpt.file, S[5])
  end
  R.fprintf(G_Frpt.file, S[368])
  if ((G.IgnoreRDII ~= 0) or (G_Nobjects[UNITHYD] == 0)) then
    R.fprintf(G_Frpt.file, S[4])
  else
    R.fprintf(G_Frpt.file, S[5])
  end
  R.fprintf(G_Frpt.file, S[369])
  if ((G.IgnoreSnowmelt ~= 0) or (G_Nobjects[SNOWMELT] == 0)) then
    R.fprintf(G_Frpt.file, S[4])
  else
    R.fprintf(G_Frpt.file, S[5])
  end
  R.fprintf(G_Frpt.file, S[370])
  if ((G.IgnoreGwater ~= 0) or (G_Nobjects[AQUIFER] == 0)) then
    R.fprintf(G_Frpt.file, S[4])
  else
    R.fprintf(G_Frpt.file, S[5])
  end
  R.fprintf(G_Frpt.file, S[371])
  if ((G.IgnoreRouting ~= 0) or (G_Nobjects[LINK] == 0)) then
    R.fprintf(G_Frpt.file, S[4])
  else
    R.fprintf(G_Frpt.file, S[5])
    R.fprintf(G_Frpt.file, S[372])
    if (G.AllowPonding ~= 0) then
      R.fprintf(G_Frpt.file, S[5])
    else
      R.fprintf(G_Frpt.file, S[4])
    end
  end
  R.fprintf(G_Frpt.file, S[373])
  if ((G.IgnoreQuality ~= 0) or (G_Nobjects[POLLUT] == 0)) then
    R.fprintf(G_Frpt.file, S[4])
  else
    R.fprintf(G_Frpt.file, S[5])
  end
  if (G_Nobjects[SUBCATCH] > 0) then
    R.fprintf(G_Frpt.file, S[374], G.InfilModelWords[G.InfilModel])
  end
  if (G_Nobjects[LINK] > 0) then
    R.fprintf(G_Frpt.file, S[375], G.RouteModelWords[G.RouteModel])
  end
  if (G.RouteModel == DW) then
    R.fprintf(G_Frpt.file, S[376], G.SurchargeWords[G.SurchargeMethod])
  end
  F.datetime_dateToStr(G.StartDate, str)
  R.fprintf(G_Frpt.file, S[377], str)
  F.datetime_timeToStr(G.StartTime, str)
  R.fprintf(G_Frpt.file, S[378], str)
  F.datetime_dateToStr(G.EndDate, str)
  R.fprintf(G_Frpt.file, S[379], str)
  F.datetime_timeToStr(G.EndTime, str)
  R.fprintf(G_Frpt.file, S[378], str)
  R.fprintf(G_Frpt.file, S[380], G.StartDryDays)
  F.datetime_timeToStr(F.datetime_encodeTime(0, 0, G.ReportStep), str)
  R.fprintf(G_Frpt.file, S[381], str)
  if (G_Nobjects[SUBCATCH] > 0) then
    F.datetime_timeToStr(F.datetime_encodeTime(0, 0, G.WetStep), str)
    R.fprintf(G_Frpt.file, S[382], str)
    F.datetime_timeToStr(F.datetime_encodeTime(0, 0, G.DryStep), str)
    R.fprintf(G_Frpt.file, S[383], str)
  end
  if (G_Nobjects[LINK] > 0) then
    R.fprintf(G_Frpt.file, S[384], G.RouteStep)
    if (G.RouteModel == DW) then
      R.fprintf(G_Frpt.file, S[385])
      if (G.CourantFactor > 0.0) then
        R.fprintf(G_Frpt.file, S[5])
      else
        R.fprintf(G_Frpt.file, S[4])
      end
      R.fprintf(G_Frpt.file, S[386], G.MaxTrials)
      R.fprintf(G_Frpt.file, S[387], G.NumThreads)
      R.fprintf(G_Frpt.file, S[388], (G.HeadTol * F.UCF(LENGTH)))
      if (G.UnitSystem == US) then
        R.fprintf(G_Frpt.file, S[389])
      else
        R.fprintf(G_Frpt.file, S[390])
      end
    end
  end
  F.report_writeLine((S[0]))
end

-- report.c:355
F.report_writeRainStats = function(i, r)
  local G_Frpt, G_Gage = G.Frpt, G.Gage
  local date1 = R.bufFrom(S[391], 12)
  local date2 = R.bufFrom(S[391], 12)
  if (G.RptFlags.disabled ~= 0) then
    do return end
  end
  if (i < 0) then
    F.report_writeLine((S[0]))
    F.report_writeLine((S[255]))
    F.report_writeLine((S[392]))
    F.report_writeLine((S[255]))
    R.fprintf(G_Frpt.file, S[393])
    R.fprintf(G_Frpt.file, S[394])
    R.fprintf(G_Frpt.file, S[245])
  else
    if (r.startDate ~= ((-693594) * 1.0)) then
      F.datetime_dateToStr(r.startDate, date1)
    end
    if (r.endDate ~= ((-693594) * 1.0)) then
      F.datetime_dateToStr(r.endDate, date2)
    end
    R.fprintf(G_Frpt.file, S[395], G_Gage[i].staID, date1, date2, R.idiv(G_Gage[i].rainInterval, 60), r.periodsRain, r.periodsMissing, r.periodsMalfunc)
  end
  F.report_writeLine((S[0]))
end

-- report.c:396
F.report_writeRdiiStats = function(rainVol, rdiiVol)
  local G_Frpt = G.Frpt
  local ratio = 0.0
  local ucf1 = 0.0
  local ucf2 = 0.0
  if (G.RptFlags.disabled ~= 0) then
    do return end
  end
  ucf1 = (F.UCF(LENGTH) * F.UCF(LANDAREA))
  if (G.UnitSystem == US) then
    ucf2 = (0.64632 / 86400.0)
  else
    ucf2 = (2.4466 / 86400.0)
  end
  F.report_writeLine((S[0]))
  R.fprintf(G_Frpt.file, S[396])
  if (G.UnitSystem == US) then
    R.fprintf(G_Frpt.file, S[397])
  else
    R.fprintf(G_Frpt.file, S[398])
  end
  R.fprintf(G_Frpt.file, S[399])
  R.fprintf(G_Frpt.file, S[400], (rainVol * ucf1), (rainVol * ucf2))
  R.fprintf(G_Frpt.file, S[401], (rdiiVol * ucf1), (rdiiVol * ucf2))
  if (rainVol == 0.0) then
    ratio = 0.0
  else
    ratio = (rdiiVol / rainVol)
  end
  R.fprintf(G_Frpt.file, S[402], ratio)
  F.report_writeLine((S[0]))
end

-- report.c:441
F.report_writeControlActionsHeading = function()
  F.report_writeLine((S[0]))
  F.report_writeLine((S[255]))
  F.report_writeLine((S[403]))
  F.report_writeLine((S[255]))
  R.fprintf(G.Frpt.file, S[276])
end

-- report.c:452
F.report_writeControlAction = function(aDate, linkID, value, ruleID)
  local theDate = R.buf(12)
  local theTime = R.buf(9)
  if (G.RptFlags.disabled ~= 0) then
    do return end
  end
  F.datetime_dateToStr(aDate, theDate)
  F.datetime_timeToStr(aDate, theTime)
  R.fprintf(G.Frpt.file, S[404], theDate, theTime, linkID, value, ruleID)
end

-- report.c:480
F.report_writeRunoffError = function(totals, totalArea)
  local G_Frunoff, G_Frpt, G_Nobjects = G.Frunoff, G.Frpt, G.Nobjects
  if (G_Frunoff.mode == USE_FILE) then
    F.report_writeLine((S[0]))
    R.fprintf(G_Frpt.file, S[405], G_Frunoff.name)
    F.report_writeLine((S[0]))
    do return end
  end
  if (totalArea == 0.0) then
    do return end
  end
  F.report_writeLine((S[0]))
  R.fprintf(G_Frpt.file, S[406])
  if (G.UnitSystem == US) then
    R.fprintf(G_Frpt.file, S[407])
  else
    R.fprintf(G_Frpt.file, S[408])
  end
  R.fprintf(G_Frpt.file, S[409])
  if (totals.initStorage > 0.0) then
    R.fprintf(G_Frpt.file, S[410], ((totals.initStorage * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.initStorage / totalArea) * F.UCF(RAINDEPTH)))
  end
  if (G_Nobjects[SNOWMELT] > 0) then
    R.fprintf(G_Frpt.file, S[411], ((totals.initSnowCover * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.initSnowCover / totalArea) * F.UCF(RAINDEPTH)))
  end
  R.fprintf(G_Frpt.file, S[412], ((totals.rainfall * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.rainfall / totalArea) * F.UCF(RAINDEPTH)))
  if (totals.runon > 0.0) then
    R.fprintf(G_Frpt.file, S[413], ((totals.runon * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.runon / totalArea) * F.UCF(RAINDEPTH)))
  end
  R.fprintf(G_Frpt.file, S[414], ((totals.evap * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.evap / totalArea) * F.UCF(RAINDEPTH)))
  R.fprintf(G_Frpt.file, S[415], ((totals.infil * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.infil / totalArea) * F.UCF(RAINDEPTH)))
  R.fprintf(G_Frpt.file, S[416], ((totals.runoff * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.runoff / totalArea) * F.UCF(RAINDEPTH)))
  if (totals.drains > 0.0) then
    R.fprintf(G_Frpt.file, S[417], ((totals.drains * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.drains / totalArea) * F.UCF(RAINDEPTH)))
  end
  if (G_Nobjects[SNOWMELT] > 0) then
    R.fprintf(G_Frpt.file, S[418], ((totals.snowRemoved * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.snowRemoved / totalArea) * F.UCF(RAINDEPTH)))
    R.fprintf(G_Frpt.file, S[419], ((totals.finalSnowCover * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.finalSnowCover / totalArea) * F.UCF(RAINDEPTH)))
  end
  R.fprintf(G_Frpt.file, S[420], ((totals.finalStorage * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.finalStorage / totalArea) * F.UCF(RAINDEPTH)))
  R.fprintf(G_Frpt.file, S[421], totals.pctError)
  F.report_writeLine((S[0]))
end

-- report.c:577
F.report_writeLoadingError = function(totals)
  local G_Nobjects = G.Nobjects
  local p1 = 0
  local p2 = 0
  p1 = 1
  p2 = (((((5) <= (G_Nobjects[POLLUT]))) and (5) or (G_Nobjects[POLLUT])))
  while (p1 <= G_Nobjects[POLLUT]) do
    do
      F.report_LoadingErrors((p1 - 1), (p2 - 1), totals)
      p1 = (p2 + 1)
      p2 = (p1 + 4)
      p2 = (((((p2) <= (G_Nobjects[POLLUT]))) and (p2) or (G_Nobjects[POLLUT])))
    end
  end
end

-- report.c:599
F.report_LoadingErrors = function(p1, p2, totals)
  local G_Frpt, G_Pollut, G_LoadUnitsWords = G.Frpt, G.Pollut, G.LoadUnitsWords
  local i = 0
  local p = 0
  local cf = 1.0
  local units = R.buf(15)
  F.report_writeLine((S[0]))
  R.fprintf(G_Frpt.file, S[422])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[423], G_Pollut[p].ID)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[424])
  do
    p = p1
    while (p <= p2) do
      do
        i = G.UnitSystem
        if (G_Pollut[p].units == COUNT) then
          i = 2
        end
        F.sstrncpy(units, G_LoadUnitsWords[i], 14)
        R.fprintf(G_Frpt.file, S[423], units)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[422])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[425])
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[426])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], (totals[p].initLoad * cf))
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[428])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], (totals[p].buildup * cf))
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[429])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], (totals[p].deposition * cf))
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[430])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], (totals[p].sweeping * cf))
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[431])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], (totals[p].infil * cf))
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[432])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], (totals[p].bmpRemoval * cf))
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[433])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], (totals[p].runoff * cf))
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[434])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], (totals[p].finalLoad * cf))
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[435])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], totals[p].pctError)
      end
      p = p + 1
    end
  end
  F.report_writeLine((S[0]))
end

-- report.c:685
F.report_writeGwaterError = function(totals, gwArea)
  local G_Frpt = G.Frpt
  F.report_writeLine((S[0]))
  R.fprintf(G_Frpt.file, S[406])
  if (G.UnitSystem == US) then
    R.fprintf(G_Frpt.file, S[436])
  else
    R.fprintf(G_Frpt.file, S[437])
  end
  R.fprintf(G_Frpt.file, S[409])
  R.fprintf(G_Frpt.file, S[438], ((totals.initStorage * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.initStorage / gwArea) * F.UCF(RAINDEPTH)))
  R.fprintf(G_Frpt.file, S[439], ((totals.infil * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.infil / gwArea) * F.UCF(RAINDEPTH)))
  R.fprintf(G_Frpt.file, S[440], ((totals.upperEvap * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.upperEvap / gwArea) * F.UCF(RAINDEPTH)))
  R.fprintf(G_Frpt.file, S[441], ((totals.lowerEvap * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.lowerEvap / gwArea) * F.UCF(RAINDEPTH)))
  R.fprintf(G_Frpt.file, S[442], ((totals.lowerPerc * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.lowerPerc / gwArea) * F.UCF(RAINDEPTH)))
  R.fprintf(G_Frpt.file, S[443], ((totals.gwater * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.gwater / gwArea) * F.UCF(RAINDEPTH)))
  R.fprintf(G_Frpt.file, S[420], ((totals.finalStorage * F.UCF(LENGTH)) * F.UCF(LANDAREA)), ((totals.finalStorage / gwArea) * F.UCF(RAINDEPTH)))
  R.fprintf(G_Frpt.file, S[421], totals.pctError)
  F.report_writeLine((S[0]))
end

-- report.c:737
F.report_writeFlowError = function(totals)
  local G_Frpt = G.Frpt
  local ucf1 = 0.0
  local ucf2 = 0.0
  ucf1 = (F.UCF(LENGTH) * F.UCF(LANDAREA))
  if (G.UnitSystem == US) then
    ucf2 = (0.64632 / 86400.0)
  else
    ucf2 = (2.4466 / 86400.0)
  end
  F.report_writeLine((S[0]))
  R.fprintf(G_Frpt.file, S[444])
  if (G.UnitSystem == US) then
    R.fprintf(G_Frpt.file, S[445])
  else
    R.fprintf(G_Frpt.file, S[446])
  end
  R.fprintf(G_Frpt.file, S[447])
  R.fprintf(G_Frpt.file, S[448], (totals.dwInflow * ucf1), (totals.dwInflow * ucf2))
  R.fprintf(G_Frpt.file, S[449], (totals.wwInflow * ucf1), (totals.wwInflow * ucf2))
  R.fprintf(G_Frpt.file, S[450], (totals.gwInflow * ucf1), (totals.gwInflow * ucf2))
  R.fprintf(G_Frpt.file, S[451], (totals.iiInflow * ucf1), (totals.iiInflow * ucf2))
  R.fprintf(G_Frpt.file, S[452], (totals.exInflow * ucf1), (totals.exInflow * ucf2))
  R.fprintf(G_Frpt.file, S[453], (totals.outflow * ucf1), (totals.outflow * ucf2))
  R.fprintf(G_Frpt.file, S[454], (totals.flooding * ucf1), (totals.flooding * ucf2))
  R.fprintf(G_Frpt.file, S[414], (totals.evapLoss * ucf1), (totals.evapLoss * ucf2))
  R.fprintf(G_Frpt.file, S[455], (totals.seepLoss * ucf1), (totals.seepLoss * ucf2))
  R.fprintf(G_Frpt.file, S[456], (totals.initStorage * ucf1), (totals.initStorage * ucf2))
  R.fprintf(G_Frpt.file, S[457], (totals.finalStorage * ucf1), (totals.finalStorage * ucf2))
  R.fprintf(G_Frpt.file, S[421], totals.pctError)
  F.report_writeLine((S[0]))
end

-- report.c:800
F.report_writeQualError = function(QualTotals)
  local G_Nobjects = G.Nobjects
  local p1 = 0
  local p2 = 0
  p1 = 1
  p2 = (((((5) <= (G_Nobjects[POLLUT]))) and (5) or (G_Nobjects[POLLUT])))
  while (p1 <= G_Nobjects[POLLUT]) do
    do
      F.report_QualErrors((p1 - 1), (p2 - 1), QualTotals)
      p1 = (p2 + 1)
      p2 = (p1 + 4)
      p2 = (((((p2) <= (G_Nobjects[POLLUT]))) and (p2) or (G_Nobjects[POLLUT])))
    end
  end
end

-- report.c:821
F.report_QualErrors = function(p1, p2, QualTotals)
  local G_Frpt, G_Pollut, G_LoadUnitsWords = G.Frpt, G.Pollut, G.LoadUnitsWords
  local i = 0
  local p = 0
  local units = R.buf(15)
  F.report_writeLine((S[0]))
  R.fprintf(G_Frpt.file, S[422])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[423], G_Pollut[p].ID)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[458])
  do
    p = p1
    while (p <= p2) do
      do
        i = G.UnitSystem
        if (G_Pollut[p].units == COUNT) then
          i = 2
        end
        F.sstrncpy(units, G_LoadUnitsWords[i], 14)
        R.fprintf(G_Frpt.file, S[423], units)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[422])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[425])
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[459])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], QualTotals[p].dwInflow)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[460])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], QualTotals[p].wwInflow)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[461])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], QualTotals[p].gwInflow)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[462])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], QualTotals[p].iiInflow)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[463])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], QualTotals[p].exInflow)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[464])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], QualTotals[p].outflow)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[465])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], QualTotals[p].flooding)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[466])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], QualTotals[p].seepLoss)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[467])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], QualTotals[p].reacted)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[468])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], QualTotals[p].initStorage)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[469])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], QualTotals[p].finalStorage)
      end
      p = p + 1
    end
  end
  R.fprintf(G_Frpt.file, S[435])
  do
    p = p1
    while (p <= p2) do
      do
        R.fprintf(G_Frpt.file, S[427], QualTotals[p].pctError)
      end
      p = p + 1
    end
  end
  F.report_writeLine((S[0]))
end

-- report.c:923
F.report_writeMaxStats = function(maxMassBalErrs, maxCourantCrit, nMaxStats)
  local G_Frpt, G_Node, G_Link = G.Frpt, G.Node, G.Link
  local i = 0
  local j = 0
  local k = 0
  if ((G.RouteModel ~= DW) or (G.Nobjects[LINK] == 0)) then
    do return end
  end
  if (nMaxStats <= 0) then
    do return end
  end
  if (maxMassBalErrs[0].index >= 0) then
    F.report_writeLine((S[0]))
    F.report_writeLine((S[470]))
    F.report_writeLine((S[471]))
    F.report_writeLine((S[470]))
    do
      i = 0
      while (i < nMaxStats) do
        do
          j = maxMassBalErrs[i].index
          if (j < 0) then
            goto continue1
          end
          R.fprintf(G_Frpt.file, S[472], G_Node[j].ID, maxMassBalErrs[i].value)
        end
        ::continue1::
        i = i + 1
      end
    end
    F.report_writeLine((S[0]))
  end
  if (G.CourantFactor == 0.0) then
    do return end
  end
  F.report_writeLine((S[0]))
  F.report_writeLine((S[473]))
  F.report_writeLine((S[474]))
  F.report_writeLine((S[473]))
  k = 0
  do
    i = 0
    while (i < nMaxStats) do
      do
        j = maxCourantCrit[i].index
        if (j < 0) then
          goto continue2
        end
        k = k + 1
        if (maxCourantCrit[i].objType == NODE) then
          R.fprintf(G_Frpt.file, S[475], G_Node[j].ID)
        else
          R.fprintf(G_Frpt.file, S[476], G_Link[j].ID)
        end
        R.fprintf(G_Frpt.file, S[477], maxCourantCrit[i].value)
      end
      ::continue2::
      i = i + 1
    end
  end
  if (k == 0) then
    R.fprintf(G_Frpt.file, S[478])
  end
  F.report_writeLine((S[0]))
end

-- report.c:977
F.report_writeMaxFlowTurns = function(flowTurns, nMaxStats)
  local G_Frpt, G_Link = G.Frpt, G.Link
  local i = 0
  local j = 0
  if (G.Nobjects[LINK] == 0) then
    do return end
  end
  F.report_writeLine((S[0]))
  F.report_writeLine((S[479]))
  F.report_writeLine((S[480]))
  F.report_writeLine((S[479]))
  if ((nMaxStats <= 0) or (flowTurns[0].index <= 0)) then
    R.fprintf(G_Frpt.file, S[481])
  else
    do
      i = 0
      while (i < nMaxStats) do
        do
          j = flowTurns[i].index
          if (j < 0) then
            goto continue1
          end
          R.fprintf(G_Frpt.file, S[482], G_Link[j].ID, flowTurns[i].value)
        end
        ::continue1::
        i = i + 1
      end
    end
  end
  F.report_writeLine((S[0]))
end

-- report.c:1011
F.report_writeNonconvergedStats = function(maxNonconverged, nMaxStats)
  local G_Frpt, G_Node = G.Frpt, G.Node
  local i = 0
  local j = 0
  if ((G.Nobjects[NODE] == 0) or (G.RouteModel ~= DW)) then
    do return end
  end
  F.report_writeLine((S[0]))
  F.report_writeLine((S[483]))
  F.report_writeLine((S[484]))
  F.report_writeLine((S[483]))
  if (((nMaxStats <= 0) or (maxNonconverged[0].index <= 0)) or (maxNonconverged[0].value < 5e-05)) then
    R.fprintf(G_Frpt.file, S[485])
  else
    do
      i = 0
      while (i < nMaxStats) do
        do
          j = maxNonconverged[i].index
          if ((j < 0) or (maxNonconverged[i].value <= 0.0)) then
            goto continue1
          end
          R.fprintf(G_Frpt.file, S[472], G_Node[j].ID, (100.0 * maxNonconverged[i].value))
        end
        ::continue1::
        i = i + 1
      end
    end
  end
  F.report_writeLine((S[0]))
end

-- report.c:1037
F.report_writeTimeStepStats = function(timeStepStats)
  local G_Frpt = G.Frpt
  local timeStepCount = (timeStepStats.timeStepCount * 1.0)
  local totalRoutingTime = 0.0
  local fSteadyState = 0.0
  if ((G.Nobjects[LINK] == 0) or ((timeStepStats.timeStepCount * 1.0) == 0.0)) then
    do return end
  end
  totalRoutingTime = (timeStepStats.steadyStateTime + timeStepStats.routingTime)
  if (totalRoutingTime > 0.0) then
    fSteadyState = ((100.0 * timeStepStats.steadyStateTime) / totalRoutingTime)
  end
  F.report_writeLine((S[0]))
  F.report_writeLine((S[470]))
  F.report_writeLine((S[486]))
  F.report_writeLine((S[470]))
  R.fprintf(G_Frpt.file, S[487], timeStepStats.minTimeStep)
  R.fprintf(G_Frpt.file, S[488], (timeStepStats.routingTime / timeStepCount))
  R.fprintf(G_Frpt.file, S[489], timeStepStats.maxTimeStep)
  R.fprintf(G_Frpt.file, S[490], (((((fSteadyState) <= (100.0))) and (fSteadyState) or (100.0))))
  R.fprintf(G_Frpt.file, S[491], (timeStepStats.trialsCount / timeStepCount))
  R.fprintf(G_Frpt.file, S[492], ((100.0 * (G.NonConvergeCount * 1.0)) / timeStepCount))
  if ((G.RouteModel == DW) and (G.CourantFactor > 0.0)) then
    F.report_RouteStepFreq(timeStepStats)
  end
  F.report_writeLine((S[0]))
end

-- report.c:1085
F.report_RouteStepFreq = function(timeStepStats)
  local G_Frpt = G.Frpt
  local totalSteps = 0.0
  local i = 0
  do
    i = 1
    while (i < 6) do
      do
        totalSteps = (totalSteps + (timeStepStats.timeStepCounts[i] * 1.0))
      end
      i = i + 1
    end
  end
  if (totalSteps == 0.0) then
    do return end
  end
  R.fprintf(G_Frpt.file, S[493])
  do
    i = 1
    while (i < 6) do
      do
        R.fprintf(G_Frpt.file, S[494], timeStepStats.timeStepIntervals[(i - 1)], timeStepStats.timeStepIntervals[i], ((100.0 * ((timeStepStats.timeStepCounts[i]) * 1.0)) / totalSteps))
      end
      i = i + 1
    end
  end
end

-- report.c:1113
F.report_writeReport = function()
  local G_RptFlags = G.RptFlags
  if (G.ErrorCode ~= 0) then
    do return end
  end
  if (G.Nperiods == 0) then
    do return end
  end
  if ((G_RptFlags.subcatchments ~= NONE) and ((((G.IgnoreRainfall == 0) or (G.IgnoreSnowmelt == 0)) or (G.IgnoreGwater == 0)))) then
    F.report_Subcatchments()
  end
  if ((G.IgnoreRouting == 1) and (G.IgnoreQuality == 1)) then
    do return end
  end
  if (G_RptFlags.nodes ~= NONE) then
    F.report_Nodes()
  end
  if (G_RptFlags.links ~= NONE) then
    F.report_Links()
  end
end

-- report.c:1135
F.report_Subcatchments = function()
  local G_Nobjects, G_Subcatch, G_Frpt, G_SubcatchResults = G.Nobjects, G.Subcatch, G.Frpt, G.SubcatchResults
  local j = 0
  local p = 0
  local k = 0
  local period = 0
  local days = {0.0}
  local theDate = R.buf(12)
  local theTime = R.buf(9)
  local hasSnowmelt = ((((G_Nobjects[SNOWMELT] > 0) and (not (G.IgnoreSnowmelt ~= 0)))) and 1 or 0)
  local hasGwater = ((((G_Nobjects[AQUIFER] > 0) and (not (G.IgnoreGwater ~= 0)))) and 1 or 0)
  local hasQuality = ((((G_Nobjects[POLLUT] > 0) and (not (G.IgnoreQuality ~= 0)))) and 1 or 0)
  if (G_Nobjects[SUBCATCH] == 0) then
    do return end
  end
  F.report_writeLine((S[0]))
  F.report_writeLine((S[479]))
  F.report_writeLine((S[495]))
  F.report_writeLine((S[479]))
  do
    j = 0
    while (j < G_Nobjects[SUBCATCH]) do
      do
        k = (G_Subcatch[j].rptFlag - 1)
        if (k >= 0) then
          F.report_SubcatchHeader(G_Subcatch[j].ID)
          do
            period = 1
            while (period <= G.Nperiods) do
              do
                F.output_readDateTime(period, days, 1)
                F.datetime_dateToStr(days[1], theDate)
                F.datetime_timeToStr(days[1], theTime)
                F.output_readSubcatchResults(period, k)
                R.fprintf(G_Frpt.file, S[496], theDate, theTime, G_SubcatchResults[SUBCATCH_RAINFALL], ((G_SubcatchResults[SUBCATCH_EVAP] / 24.0) + G_SubcatchResults[SUBCATCH_INFIL]), G_SubcatchResults[SUBCATCH_RUNOFF])
                if (hasSnowmelt ~= 0) then
                  R.fprintf(G_Frpt.file, S[497], G_SubcatchResults[SUBCATCH_SNOWDEPTH])
                end
                if (hasGwater ~= 0) then
                  R.fprintf(G_Frpt.file, S[498], G_SubcatchResults[SUBCATCH_GW_ELEV], G_SubcatchResults[SUBCATCH_GW_FLOW])
                end
                if (hasQuality ~= 0) then
                  do
                    p = 0
                    while (p < G_Nobjects[POLLUT]) do
                      do
                        R.fprintf(G_Frpt.file, S[499], G_SubcatchResults[(SUBCATCH_WASHOFF + p)])
                      end
                      p = p + 1
                    end
                  end
                end
              end
              period = period + 1
            end
          end
          F.report_writeLine((S[0]))
        end
      end
      j = j + 1
    end
  end
end

-- report.c:1192
F.report_SubcatchHeader = function(id)
  local G_Nobjects, G_Frpt, G_Pollut, G_FlowUnitWords, G_QualUnitsWords = G.Nobjects, G.Frpt, G.Pollut, G.FlowUnitWords, G.QualUnitsWords
  local i = 0
  local hasSnowmelt = ((((G_Nobjects[SNOWMELT] > 0) and (not (G.IgnoreSnowmelt ~= 0)))) and 1 or 0)
  local hasGwater = ((((G_Nobjects[AQUIFER] > 0) and (not (G.IgnoreGwater ~= 0)))) and 1 or 0)
  local hasQuality = ((((G_Nobjects[POLLUT] > 0) and (not (G.IgnoreQuality ~= 0)))) and 1 or 0)
  F.report_writeLine((S[0]))
  R.fprintf(G_Frpt.file, S[500], id)
  F.report_writeLine((S[501]))
  if (hasSnowmelt > 0) then
    R.fprintf(G_Frpt.file, S[502])
  end
  if (hasGwater ~= 0) then
    R.fprintf(G_Frpt.file, S[503])
    R.fprintf(G_Frpt.file, S[503])
  end
  if (hasQuality ~= 0) then
    do
      i = 0
      while (i < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[503])
        end
        i = i + 1
      end
    end
  end
  R.fprintf(G_Frpt.file, S[504])
  if (hasSnowmelt ~= 0) then
    R.fprintf(G_Frpt.file, S[505])
  end
  if (hasGwater ~= 0) then
    R.fprintf(G_Frpt.file, S[506])
  end
  if (hasQuality ~= 0) then
    do
      i = 0
      while (i < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[507], G_Pollut[i].ID)
        end
        i = i + 1
      end
    end
  end
  if (G.UnitSystem == US) then
    R.fprintf(G_Frpt.file, S[508], G_FlowUnitWords[G.FlowUnits])
  else
    R.fprintf(G_Frpt.file, S[509], G_FlowUnitWords[G.FlowUnits])
  end
  if (hasSnowmelt ~= 0) then
    if (G.UnitSystem == US) then
      R.fprintf(G_Frpt.file, S[510])
    else
      R.fprintf(G_Frpt.file, S[511])
    end
  end
  if (hasGwater ~= 0) then
    if (G.UnitSystem == US) then
      R.fprintf(G_Frpt.file, S[512], G_FlowUnitWords[G.FlowUnits])
    else
      R.fprintf(G_Frpt.file, S[513], G_FlowUnitWords[G.FlowUnits])
    end
  end
  if (hasQuality ~= 0) then
    do
      i = 0
      while (i < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[507], G_QualUnitsWords[G_Pollut[i].units])
        end
        i = i + 1
      end
    end
  end
  F.report_writeLine((S[501]))
  if (hasSnowmelt ~= 0) then
    R.fprintf(G_Frpt.file, S[502])
  end
  if (hasGwater ~= 0) then
    R.fprintf(G_Frpt.file, S[503])
    R.fprintf(G_Frpt.file, S[503])
  end
  if (hasQuality ~= 0) then
    do
      i = 0
      while (i < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[503])
        end
        i = i + 1
      end
    end
  end
end

-- report.c:1261
F.report_Nodes = function()
  local G_Nobjects, G_Node, G_Frpt, G_NodeResults = G.Nobjects, G.Node, G.Frpt, G.NodeResults
  local j = 0
  local p = 0
  local k = 0
  local period = 0
  local days = {0.0}
  local theDate = R.buf(12)
  local theTime = R.buf(9)
  if (G_Nobjects[NODE] == 0) then
    do return end
  end
  F.report_writeLine((S[0]))
  F.report_writeLine((S[514]))
  F.report_writeLine((S[515]))
  F.report_writeLine((S[514]))
  do
    j = 0
    while (j < G_Nobjects[NODE]) do
      do
        k = (G_Node[j].rptFlag - 1)
        if (k >= 0) then
          F.report_NodeHeader(G_Node[j].ID)
          do
            period = 1
            while (period <= G.Nperiods) do
              do
                F.output_readDateTime(period, days, 1)
                F.datetime_dateToStr(days[1], theDate)
                F.datetime_timeToStr(days[1], theTime)
                F.output_readNodeResults(period, k)
                R.fprintf(G_Frpt.file, S[516], theDate, theTime, G_NodeResults[NODE_INFLOW], G_NodeResults[NODE_OVERFLOW], G_NodeResults[NODE_DEPTH], G_NodeResults[NODE_HEAD])
                if (not (G.IgnoreQuality ~= 0)) then
                  do
                    p = 0
                    while (p < G_Nobjects[POLLUT]) do
                      do
                        R.fprintf(G_Frpt.file, S[195], G_NodeResults[(NODE_QUAL + p)])
                      end
                      p = p + 1
                    end
                  end
                end
              end
              period = period + 1
            end
          end
          F.report_writeLine((S[0]))
        end
      end
      j = j + 1
    end
  end
end

-- report.c:1305
F.report_NodeHeader = function(id)
  local G_Frpt, G_Nobjects, G_Pollut, G_FlowUnitWords, G_QualUnitsWords = G.Frpt, G.Nobjects, G.Pollut, G.FlowUnitWords, G.QualUnitsWords
  local i = 0
  local lengthUnits = R.buf(9)
  F.report_writeLine((S[0]))
  R.fprintf(G_Frpt.file, S[517], id)
  F.report_writeLine((S[518]))
  do
    i = 0
    while (i < G_Nobjects[POLLUT]) do
      do
        R.fprintf(G_Frpt.file, S[503])
      end
      i = i + 1
    end
  end
  R.fprintf(G_Frpt.file, S[519])
  if (not (G.IgnoreQuality ~= 0)) then
    do
      i = 0
      while (i < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[507], G_Pollut[i].ID)
        end
        i = i + 1
      end
    end
  end
  if (G.UnitSystem == US) then
    F.sstrncpy(lengthUnits, S[520], 8)
  else
    F.sstrncpy(lengthUnits, S[521], 8)
  end
  R.fprintf(G_Frpt.file, S[522], G_FlowUnitWords[G.FlowUnits], G_FlowUnitWords[G.FlowUnits], lengthUnits, lengthUnits)
  if (not (G.IgnoreQuality ~= 0)) then
    do
      i = 0
      while (i < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[507], G_QualUnitsWords[G_Pollut[i].units])
        end
        i = i + 1
      end
    end
  end
  F.report_writeLine((S[518]))
  if (not (G.IgnoreQuality ~= 0)) then
    do
      i = 0
      while (i < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[503])
        end
        i = i + 1
      end
    end
  end
end

-- report.c:1339
F.report_Links = function()
  local G_Nobjects, G_Link, G_Frpt, G_LinkResults = G.Nobjects, G.Link, G.Frpt, G.LinkResults
  local j = 0
  local p = 0
  local k = 0
  local period = 0
  local days = {0.0}
  local theDate = R.buf(12)
  local theTime = R.buf(9)
  if (G_Nobjects[LINK] == 0) then
    do return end
  end
  F.report_writeLine((S[0]))
  F.report_writeLine((S[514]))
  F.report_writeLine((S[523]))
  F.report_writeLine((S[514]))
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        k = (G_Link[j].rptFlag - 1)
        if (k >= 0) then
          F.report_LinkHeader(G_Link[j].ID)
          do
            period = 1
            while (period <= G.Nperiods) do
              do
                F.output_readDateTime(period, days, 1)
                F.datetime_dateToStr(days[1], theDate)
                F.datetime_timeToStr(days[1], theTime)
                F.output_readLinkResults(period, k)
                R.fprintf(G_Frpt.file, S[516], theDate, theTime, G_LinkResults[LINK_FLOW], G_LinkResults[LINK_VELOCITY], G_LinkResults[LINK_DEPTH], G_LinkResults[LINK_CAPACITY])
                if (not (G.IgnoreQuality ~= 0)) then
                  do
                    p = 0
                    while (p < G_Nobjects[POLLUT]) do
                      do
                        R.fprintf(G_Frpt.file, S[195], G_LinkResults[(LINK_QUAL + p)])
                      end
                      p = p + 1
                    end
                  end
                end
              end
              period = period + 1
            end
          end
          F.report_writeLine((S[0]))
        end
      end
      j = j + 1
    end
  end
end

-- report.c:1383
F.report_LinkHeader = function(id)
  local G_Frpt, G_Nobjects, G_Pollut, G_FlowUnitWords, G_QualUnitsWords = G.Frpt, G.Nobjects, G.Pollut, G.FlowUnitWords, G.QualUnitsWords
  local i = 0
  F.report_writeLine((S[0]))
  R.fprintf(G_Frpt.file, S[524], id)
  F.report_writeLine((S[518]))
  do
    i = 0
    while (i < G_Nobjects[POLLUT]) do
      do
        R.fprintf(G_Frpt.file, S[503])
      end
      i = i + 1
    end
  end
  R.fprintf(G_Frpt.file, S[525])
  if (not (G.IgnoreQuality ~= 0)) then
    do
      i = 0
      while (i < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[507], G_Pollut[i].ID)
        end
        i = i + 1
      end
    end
  end
  if (G.UnitSystem == US) then
    R.fprintf(G_Frpt.file, S[526], G_FlowUnitWords[G.FlowUnits])
  else
    R.fprintf(G_Frpt.file, S[527], G_FlowUnitWords[G.FlowUnits])
  end
  if (not (G.IgnoreQuality ~= 0)) then
    do
      i = 0
      while (i < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[528], G_QualUnitsWords[G_Pollut[i].units])
        end
        i = i + 1
      end
    end
  end
  F.report_writeLine((S[518]))
  if (not (G.IgnoreQuality ~= 0)) then
    do
      i = 0
      while (i < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[503])
        end
        i = i + 1
      end
    end
  end
end

-- report.c:1422
F.report_writeErrorMsg = function(code, s)
  local G_Frpt, G_Msg = G.Frpt, G.Msg
  if (G_Frpt.file ~= nil) then
    F.report_writeLine((S[0]))
    R.fprintf(G_Frpt.file, F.error_getMsg(code, G_Msg), s)
  end
  G.ErrorCode = code
  if ((G.ErrorCode <= ERR_INPUT) or (G.ErrorCode >= ERR_FILE_NAME)) then
    R.snprintf(G.ErrorMsg, 1024, F.error_getMsg(G.ErrorCode, G_Msg), s)
  end
end

-- report.c:1446
F.report_writeErrorCode = function()
  local G_Frpt = G.Frpt
  if (G_Frpt.file ~= nil) then
    if (((((G.ErrorCode >= ERR_MEMORY) and (G.ErrorCode <= ERR_TIMESTEP))) or (((G.ErrorCode >= ERR_FILE_NAME) and (G.ErrorCode <= ERR_OUT_FILE)))) or ((G.ErrorCode == ERR_SYSTEM))) then
      R.fprintf(G_Frpt.file, S[169], F.error_getMsg(G.ErrorCode, G.Msg))
    end
  end
end

-- report.c:1464
F.report_writeInputErrorMsg = function(k, sect, line, lineCount)
  local G_Frpt = G.Frpt
  if (G_Frpt.file ~= nil) then
    F.report_writeErrorMsg(k, G.ErrString)
    if (sect < 0) then
      R.fprintf(G_Frpt.file, S[529], lineCount)
    else
      R.fprintf(G_Frpt.file, S[530], lineCount, G.SectWords[sect])
    end
    R.fprintf(G_Frpt.file, S[356], line)
  end
end

-- report.c:1485
F.report_writeWarningMsg = function(msg, id)
  R.fprintf(G.Frpt.file, S[531], msg, id)
  G.Warnings = G.Warnings + 1
end

-- report.c:1499
F.report_writeTseriesErrorMsg = function(code, tseries)
  local theDate = R.buf(20)
  local theTime = R.buf(20)
  local x = 0.0
  if (code == ERR_CURVE_SEQUENCE) then
    x = tseries.x2
    F.datetime_dateToStr(x, theDate)
    F.datetime_timeToStr(x, theTime)
    F.report_writeErrorMsg(ERR_TIMESERIES_SEQUENCE, tseries.ID)
    R.fprintf(G.Frpt.file, S[532], theDate, theTime)
  else
    F.report_writeErrorMsg(code, tseries.ID)
  end
end

