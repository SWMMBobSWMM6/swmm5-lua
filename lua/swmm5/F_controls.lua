-- Generated from EPA SWMM 5.2.4 (controls.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local r_PRIORITY <const> = 6
local ERR_MEMORY <const> = 101
local ERR_ITEMS <const> = 203
local ERR_KEYWORD <const> = 205
local ERR_MATH_EXPR <const> = 233
local r_RULE <const> = 0
local r_IF <const> = 1
local r_AND <const> = 2
local r_OR <const> = 3
local r_THEN <const> = 4
local r_ELSE <const> = 5
local CONTROL <const> = 9
local ERR_RULE <const> = 217
local ERR_NUMBER <const> = 211
local r_GAGE <const> = 0
local r_NODE <const> = 1
local r_LINK <const> = 2
local r_CONDUIT <const> = 3
local r_PUMP <const> = 4
local r_ORIFICE <const> = 5
local r_WEIR <const> = 6
local r_OUTLET <const> = 7
local GAGE <const> = 0
local ERR_NAME <const> = 209
local NODE <const> = 2
local LINK <const> = 3
local r_DEPTH <const> = 0
local r_MAXDEPTH <const> = 1
local r_HEAD <const> = 2
local r_VOLUME <const> = 3
local r_INFLOW <const> = 4
local r_TIMEOPEN <const> = 13
local r_TIMECLOSED <const> = 14
local r_STATUS <const> = 8
local r_FULLFLOW <const> = 6
local r_FULLDEPTH <const> = 7
local r_FLOW <const> = 5
local r_LENGTH <const> = 10
local r_SLOPE <const> = 11
local r_VELOCITY <const> = 12
local r_SETTING <const> = 9
local r_TIME <const> = 15
local r_DATE <const> = 16
local r_CLOCKTIME <const> = 17
local r_DAY <const> = 19
local r_MONTH <const> = 20
local r_DAYOFYEAR <const> = 18
local ERR_DATETIME <const> = 213
local CONDUIT <const> = 0
local PUMP <const> = 1
local ORIFICE <const> = 2
local WEIR <const> = 3
local OUTLET <const> = 4
local r_PID <const> = 2
local r_CURVE <const> = 0
local r_TIMESERIES <const> = 1
local CURVE <const> = 7
local TSERIES <const> = 8
local FLOW <const> = 10
local LENGTH <const> = 3
local VOLUME <const> = 5
local EQ <const> = 0
local NE <const> = 1
local LT <const> = 2
local LE <const> = 3
local GT <const> = 4
local GE <const> = 5
local _ENV = R.strict

G.ObjectWords = {[0] = S[656], S[657], S[658], S[659], S[660], S[661], S[662], S[663], S[32], (nil)}
G.AttribWords = {[0] = S[664], S[665], S[314], S[666], S[667], S[183], S[668], S[669], S[670], S[671], S[672], S[673], S[674], S[675], S[676], S[677], S[21], S[678], S[679], S[680], S[681], (nil)}
G.RelOpWords = {[0] = S[31], S[682], S[683], S[684], S[685], S[686], (nil)}
G.StatusWords = {[0] = S[687], S[688], (nil)}
G.ConduitWords = {[0] = S[689], S[690], (nil)}
G.SettingTypeWords = {[0] = S[691], S[692], S[693], (nil)}
G.IntensityWord = S[694]
G.Rules = nil
G.ActionList = nil
G.InputState = 0
G.RuleCount = 0
G.ControlValue = 0.0
G.SetPoint = 0.0
G.CurrentDate = 0.0
G.CurrentTime = 0.0
G.VariableCount = 0
G.ExpressionCount = 0
G.CurrentVariable = 0
G.CurrentExpression = 0
G.NamedVariable = nil
G.Expression = nil

-- controls.c:226
F.controls_init = function()
  G.Rules = (nil)
  G.NamedVariable = (nil)
  G.Expression = (nil)
  G.RuleCount = 0
  G.VariableCount = 0
  G.ExpressionCount = 0
end

-- controls.c:243
F.controls_addToCount = function(s)
  if (F.match(s, S[29]) ~= 0) then
    G.VariableCount = G.VariableCount + 1
  elseif (F.match(s, S[30]) ~= 0) then
    G.ExpressionCount = G.ExpressionCount + 1
  end
end

-- controls.c:257
F.controls_create = function(n)
  local r = 0
  G.ActionList = (nil)
  G.InputState = r_PRIORITY
  G.RuleCount = n
  if (G.RuleCount > 0) then
    G.Rules = R.recs(G.RuleCount, T.TRule)
    if (G.Rules == (nil)) then
      do return ERR_MEMORY end
    end
    do
      r = 0
      while (r < G.RuleCount) do
        do
          G.Rules[r].ID = (nil)
          G.Rules[r].firstPremise = (nil)
          G.Rules[r].lastPremise = (nil)
          G.Rules[r].thenActions = (nil)
          G.Rules[r].elseActions = (nil)
          G.Rules[r].priority = 0.0
        end
        r = r + 1
      end
    end
  end
  G.CurrentVariable = (-1)
  G.CurrentExpression = (-1)
  if (G.VariableCount > 0) then
    G.NamedVariable = R.recs(G.VariableCount, T.TNamedVariable)
    if (G.NamedVariable == (nil)) then
      do return ERR_MEMORY end
    end
  end
  if (G.ExpressionCount > 0) then
    G.Expression = R.recs(G.ExpressionCount, T.TExpression)
    if (G.Expression == (nil)) then
      do return ERR_MEMORY end
    end
  end
  do return 0 end
end

-- controls.c:302
F.controls_delete = function()
  local i = 0
  do
    i = 0
    while (i < G.ExpressionCount) do
      do
        F.mathexpr_delete(G.Expression[i].expression)
        G.Expression[i].expression = (nil)
      end
      i = i + 1
    end
  end
  do
    if (G.Expression ~= nil) then
      local _ = nil
      G.Expression = (nil)
    end
  end
  do
    if (G.NamedVariable ~= nil) then
      local _ = nil
      G.NamedVariable = (nil)
    end
  end
  if (G.RuleCount == 0) then
    do return end
  end
  F.deleteActionList()
  F.deleteRules()
end

-- controls.c:326
F.controls_addVariable = function(tok, nToks)
  local G_NamedVariable = G.NamedVariable
  local v1 = T.TVariable()
  local k = {0}
  local err = 0
  G.CurrentVariable = G.CurrentVariable + 1
  if (nToks < 5) then
    do return ERR_ITEMS end
  end
  if (F.findExactMatch(tok[1], G.AttribWords) >= 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
  end
  if (not (F.match(tok[2], S[31]) ~= 0)) then
    do return F.error_setInpError(ERR_KEYWORD, tok[2]) end
  end
  if ((not (F.match(tok[3], S[32]) ~= 0)) and (nToks < 6)) then
    do return ERR_ITEMS end
  end
  k[1] = 3
  err = F.getPremiseVariable(tok, nToks, k, 1, v1)
  if (err > 0) then
    do return err end
  end
  k[1] = G.CurrentVariable
  G_NamedVariable[k[1]].variable = T.copy_TVariable(v1)
  F.sstrncpy(G_NamedVariable[k[1]].name, tok[1], 32)
  do return 0 end
end

-- controls.c:357
F.controls_addExpression = function(tok, nToks)
  local G_Expression = G.Expression
  local i = 0
  local k = 0
  local s = R.buf(1025)
  local expr = nil
  G.CurrentExpression = G.CurrentExpression + 1
  if (nToks < 4) then
    do return ERR_ITEMS end
  end
  k = G.CurrentExpression
  G_Expression[k].expression = (nil)
  F.sstrncpy(G_Expression[k].name, tok[1], 32)
  F.sstrncpy(s, tok[3], 1024)
  do
    i = 4
    while (i < nToks) do
      do
        F.sstrcat(s, S[33], 1024)
        F.sstrcat(s, tok[i], 1024)
      end
      i = i + 1
    end
  end
  expr = F.mathexpr_create(s, F.getVariableIndex)
  if (expr == (nil)) then
    do return F.error_setInpError(ERR_MATH_EXPR, S[0]) end
  end
  G_Expression[k].expression = expr
  do return 0 end
end

-- controls.c:393
F.getVariableIndex = function(varName)
  local G_NamedVariable = G.NamedVariable
  local i = 0
  do
    i = 0
    while (i < G.VariableCount) do
      do
        if (F.match(varName, G_NamedVariable[i].name) ~= 0) then
          do return i end
        end
      end
      i = i + 1
    end
  end
  do return (-1) end
end

-- controls.c:410
F.getNamedVariableValue = function(varIndex)
  do return F.getVariableValue(G.NamedVariable[varIndex].variable) end
end

-- controls.c:422
F.getExpressionIndex = function(exprName)
  local G_Expression = G.Expression
  local i = 0
  do
    i = 0
    while (i < G.ExpressionCount) do
      do
        if (F.match(exprName, G_Expression[i].name) ~= 0) then
          do return i end
        end
      end
      i = i + 1
    end
  end
  do return (-1) end
end

-- controls.c:439
F.controls_addRuleClause = function(r, keyword, tok, nToks)
  local G_Rules = G.Rules
  do
    local __sw1 = keyword
    if __sw1 < r_OR then
      if __sw1 == r_RULE then goto case2
      elseif __sw1 == r_IF then goto case3
      elseif __sw1 == r_AND then goto case4
      end
    else
      if __sw1 < r_ELSE then
        if __sw1 == r_OR then goto case5
        elseif __sw1 == r_THEN then goto case6
        end
      else
        if __sw1 == r_ELSE then goto case7
        elseif __sw1 == r_PRIORITY then goto case8
        end
      end
    end
    goto swend1
    ::case2::
    do
      if R.peq(G_Rules[r].ID, (nil)) then
        G_Rules[r].ID = F.project_findID(CONTROL, tok[1])
      end
      G.InputState = r_RULE
      if (nToks > 2) then
        do return ERR_RULE end
      end
      do return 0 end
    end
    ::case3::
    do
      if (G.InputState ~= r_RULE) then
        do return ERR_RULE end
      end
      G.InputState = r_IF
      do return F.addPremise(r, r_AND, tok, nToks) end
    end
    ::case4::
    do
      if (G.InputState == r_IF) then
        do return F.addPremise(r, r_AND, tok, nToks) end
      elseif ((G.InputState == r_THEN) or (G.InputState == r_ELSE)) then
        do return F.addAction(r, tok, nToks) end
      else
        do return ERR_RULE end
      end
    end
    ::case5::
    do
      if (G.InputState ~= r_IF) then
        do return ERR_RULE end
      end
      do return F.addPremise(r, r_OR, tok, nToks) end
    end
    ::case6::
    do
      if (G.InputState ~= r_IF) then
        do return ERR_RULE end
      end
      G.InputState = r_THEN
      do return F.addAction(r, tok, nToks) end
    end
    ::case7::
    do
      if (G.InputState ~= r_THEN) then
        do return ERR_RULE end
      end
      G.InputState = r_ELSE
      do return F.addAction(r, tok, nToks) end
    end
    ::case8::
    do
      if ((G.InputState ~= r_THEN) and (G.InputState ~= r_ELSE)) then
        do return ERR_RULE end
      end
      G.InputState = r_PRIORITY
      if (not (F.getDouble(tok[1], G_Rules[r], "priority") ~= 0)) then
        do return ERR_NUMBER end
      end
      if (nToks > 2) then
        do return ERR_RULE end
      end
      do return 0 end
    end
    ::swend1::
  end
  do return 0 end
end

-- controls.c:495
F.controls_evaluate = function(currentTime, elapsedTime, tStep)
  local G_Rules = G.Rules
  local r = 0
  local result = 0
  local p = nil
  local a = nil
  G.CurrentDate = R.floor(currentTime)
  G.CurrentTime = (currentTime - R.floor(currentTime))
  G.ElapsedTime = elapsedTime
  if (G.RuleCount == 0) then
    do return 0 end
  end
  F.clearActionList()
  do
    r = 0
    while (r < G.RuleCount) do
      do
        result = 1
        p = G_Rules[r].firstPremise
        while (p ~= nil) do
          do
            if (p.type_ == r_OR) then
              if (result == 0) then
                result = F.evaluatePremise(p, tStep)
              end
            else
              if (result == 0) then
                break
              end
              result = F.evaluatePremise(p, tStep)
            end
            p = p.next_
          end
        end
        if (result == 1) then
          a = G_Rules[r].thenActions
        else
          a = G_Rules[r].elseActions
        end
        while (a ~= nil) do
          do
            F.updateActionValue(a, currentTime, tStep)
            F.updateActionList(a)
            a = a.next_
          end
        end
      end
      r = r + 1
    end
  end
  if (G.ActionList ~= nil) then
    do return F.executeActionList(currentTime) end
  else
    do return 0 end
  end
end

-- controls.c:556
F.addPremise = function(r, type_, tok, nToks)
  local G_NamedVariable, G_Rules = G.NamedVariable, G.Rules
  local relation = 0
  local n = {0}
  local err = 0
  local value = {(-10000000000.0)}
  local p = nil
  local v1 = T.TVariable()
  local v2 = T.TVariable()
  local obj = 0
  local exprIndex = 0
  local varIndex = (-1)
  if (nToks < 4) then
    do return ERR_ITEMS end
  end
  v1.attribute = (-1)
  v1.object = (-1)
  v1.index = (-1)
  n[1] = 1
  exprIndex = F.getExpressionIndex(tok[1])
  if (exprIndex < 0) then
    varIndex = F.getVariableIndex(tok[n[1]])
    if (varIndex >= 0) then
      v1 = T.copy_TVariable(G_NamedVariable[varIndex].variable)
    else
      err = F.getPremiseVariable(tok, nToks, n, 1, v1)
      if (err > 0) then
        do return err end
      end
    end
  end
  n[1] = n[1] + 1
  if (n[1] >= nToks) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  relation = F.findExactMatch(tok[n[1]], G.RelOpWords)
  if (relation < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[n[1]]) end
  end
  v2.attribute = (-1)
  v2.object = (-1)
  v2.index = (-1)
  n[1] = n[1] + 1
  if (n[1] >= nToks) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  varIndex = F.getVariableIndex(tok[n[1]])
  if (varIndex >= 0) then
    v2 = T.copy_TVariable(G_NamedVariable[varIndex].variable)
  else
    obj = F.findmatch(tok[n[1]], G.ObjectWords)
    if (obj >= 0) then
      err = F.getPremiseVariable(tok, nToks, n, 1, v2)
      if (err > 0) then
        do return ERR_RULE end
      end
      if ((exprIndex < 0) and (v1.attribute ~= v2.attribute)) then
        F.report_writeWarningMsg(S[34], G_Rules[r].ID)
      end
    else
      err = F.getPremiseValue(tok[n[1]], v1.attribute, value, 1)
      if (err > 0) then
        do return err end
      end
    end
  end
  n[1] = n[1] + 1
  if ((n[1] < nToks) and (F.findmatch(tok[n[1]], G.RuleKeyWords) >= 0)) then
    do return ERR_RULE end
  end
  p = T.TPremise()
  if (not (p ~= nil)) then
    do return ERR_MEMORY end
  end
  p.type_ = type_
  p.exprIndex = exprIndex
  p.lhsVar = T.copy_TVariable(v1)
  p.rhsVar = T.copy_TVariable(v2)
  p.relation = relation
  p.value = value[1]
  p.next_ = (nil)
  if (G_Rules[r].firstPremise == (nil)) then
    G_Rules[r].firstPremise = p
  else
    G_Rules[r].lastPremise.next_ = p
  end
  G_Rules[r].lastPremise = p
  do return 0 end
end

-- controls.c:668
F.getPremiseVariable = function(tok, nToks, k, k__k, v)
  local n = k[k__k]
  local object = (-1)
  local index = (-1)
  local obj = 0
  local attrib = 0
  obj = F.findmatch(tok[n], G.ObjectWords)
  if (obj < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[n]) end
  end
  n = n + 1
  if (n >= nToks) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  do
    local __sw1 = obj
    if __sw1 < r_PUMP then
      if __sw1 < r_LINK then
        if __sw1 == r_GAGE then goto case2
        elseif __sw1 == r_NODE then goto case3
        end
      else
        if __sw1 == r_LINK then goto case4
        elseif __sw1 == r_CONDUIT then goto case4
        end
      end
    else
      if __sw1 < r_WEIR then
        if __sw1 == r_PUMP then goto case4
        elseif __sw1 == r_ORIFICE then goto case4
        end
      else
        if __sw1 == r_WEIR then goto case4
        elseif __sw1 == r_OUTLET then goto case4
        end
      end
    end
    goto case5
    ::case2::
    do
      index = F.project_findObject(GAGE, tok[n])
      if (index < 0) then
        do return F.error_setInpError(ERR_NAME, tok[n]) end
      end
      object = r_GAGE
      goto swend1
    end
    ::case3::
    do
      index = F.project_findObject(NODE, tok[n])
      if (index < 0) then
        do return F.error_setInpError(ERR_NAME, tok[n]) end
      end
      object = r_NODE
      goto swend1
    end
    ::case4::
    do
      index = F.project_findObject(LINK, tok[n])
      if (index < 0) then
        do return F.error_setInpError(ERR_NAME, tok[n]) end
      end
      object = r_LINK
      goto swend1
    end
    ::case5::
    do
      n = n - 1
    end
    ::swend1::
  end
  n = n + 1
  if (n >= nToks) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  if (object == r_GAGE) then
    attrib = F.getGageAttrib(tok[n])
  else
    attrib = F.findmatch(tok[n], G.AttribWords)
  end
  if (attrib < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[n]) end
  end
  if (obj == r_GAGE) then
  elseif (obj == r_NODE) then
    do
      local __sw2 = attrib
      if __sw2 == r_DEPTH or __sw2 == r_MAXDEPTH or __sw2 == r_HEAD or __sw2 == r_VOLUME or __sw2 == r_INFLOW then goto case7
      else goto case8 end
      ::case7::
      do
        goto swend6
      end
      ::case8::
      do
        do return F.error_setInpError(ERR_KEYWORD, tok[n]) end
      end
      ::swend6::
    end
  elseif (((object == r_LINK) and (index >= 0)) and ((((attrib == r_TIMEOPEN) or (attrib == r_TIMECLOSED))))) then
  elseif ((obj == r_LINK) or (obj == r_CONDUIT)) then
    do
      local __sw3 = attrib
      if __sw3 < r_STATUS then
        if __sw3 < r_FULLFLOW then
          if __sw3 == r_DEPTH then goto case10
          elseif __sw3 == r_FLOW then goto case10
          end
        else
          if __sw3 == r_FULLFLOW then goto case10
          elseif __sw3 == r_FULLDEPTH then goto case10
          end
        end
      else
        if __sw3 < r_SLOPE then
          if __sw3 == r_STATUS then goto case10
          elseif __sw3 == r_LENGTH then goto case10
          end
        else
          if __sw3 == r_SLOPE then goto case10
          elseif __sw3 == r_VELOCITY then goto case10
          end
        end
      end
      goto case11
      ::case10::
      do
        goto swend9
      end
      ::case11::
      do
        do return F.error_setInpError(ERR_KEYWORD, tok[n]) end
      end
      ::swend9::
    end
  elseif (obj == r_PUMP) then
    do
      local __sw4 = attrib
      if __sw4 == r_FLOW or __sw4 == r_SETTING or __sw4 == r_STATUS then goto case13
      else goto case14 end
      ::case13::
      do
        goto swend12
      end
      ::case14::
      do
        do return F.error_setInpError(ERR_KEYWORD, tok[n]) end
      end
      ::swend12::
    end
  elseif (((obj == r_ORIFICE) or (obj == r_WEIR)) or (obj == r_OUTLET)) then
    do
      local __sw5 = attrib
      if __sw5 == r_FLOW or __sw5 == r_SETTING then goto case16
      else goto case17 end
      ::case16::
      do
        goto swend15
      end
      ::case17::
      do
        do return F.error_setInpError(ERR_KEYWORD, tok[n]) end
      end
      ::swend15::
    end
  else
    do
      local __sw6 = attrib
      if __sw6 < r_DAYOFYEAR then
        if __sw6 == r_TIME then goto case19
        elseif __sw6 == r_DATE then goto case19
        elseif __sw6 == r_CLOCKTIME then goto case19
        end
      else
        if __sw6 == r_DAYOFYEAR then goto case19
        elseif __sw6 == r_DAY then goto case19
        elseif __sw6 == r_MONTH then goto case19
        end
      end
      goto case20
      ::case19::
      do
        goto swend18
      end
      ::case20::
      do
        do return F.error_setInpError(ERR_KEYWORD, tok[n]) end
      end
      ::swend18::
    end
  end
  v.object = object
  v.index = index
  v.attribute = attrib
  k[k__k] = n
  do return 0 end
end

-- controls.c:797
F.getGageAttrib = function(token)
  local attrib = 0
  if (F.match(token, G.IntensityWord) ~= 0) then
    do return 0 end
  end
  attrib = R.atoi(token)
  if ((attrib < 1) or (attrib > 48)) then
    do return (-1) end
  end
  do return attrib end
end

-- controls.c:824
F.getPremiseValue = function(token, attrib, value, value__k)
  local strDate = R.buf(25)
  do
    local __sw1 = attrib
    if __sw1 < r_DATE then
      if __sw1 < r_TIMECLOSED then
        if __sw1 == r_STATUS then goto case2
        elseif __sw1 == r_TIMEOPEN then goto case3
        end
      else
        if __sw1 == r_TIMECLOSED then goto case3
        elseif __sw1 == r_TIME then goto case3
        end
      end
    else
      if __sw1 < r_DAYOFYEAR then
        if __sw1 == r_DATE then goto case4
        elseif __sw1 == r_CLOCKTIME then goto case3
        end
      else
        if __sw1 == r_DAYOFYEAR then goto case7
        elseif __sw1 == r_DAY then goto case5
        elseif __sw1 == r_MONTH then goto case6
        end
      end
    end
    goto case8
    ::case2::
    do
      value[value__k] = (F.findmatch(token, G.StatusWords) * 1.0)
      if (value[value__k] < 0.0) then
        value[value__k] = (F.findmatch(token, G.ConduitWords) * 1.0)
      end
      if (value[value__k] < 0.0) then
        do return F.error_setInpError(ERR_KEYWORD, token) end
      end
      goto swend1
    end
    ::case3::
    do
      if (not (F.datetime_strToTime(token, value, value__k) ~= 0)) then
        do return F.error_setInpError(ERR_DATETIME, token) end
      end
      goto swend1
    end
    ::case4::
    do
      if (not (F.datetime_strToDate(token, value, value__k) ~= 0)) then
        do return F.error_setInpError(ERR_DATETIME, token) end
      end
      goto swend1
    end
    ::case5::
    do
      if (not (F.getDouble(token, value, value__k) ~= 0)) then
        do return F.error_setInpError(ERR_NUMBER, token) end
      end
      if ((value[value__k] < 1.0) or (value[value__k] > 7.0)) then
        do return F.error_setInpError(ERR_DATETIME, token) end
      end
      goto swend1
    end
    ::case6::
    do
      if (not (F.getDouble(token, value, value__k) ~= 0)) then
        do return F.error_setInpError(ERR_NUMBER, token) end
      end
      if ((value[value__k] < 1.0) or (value[value__k] > 12.0)) then
        do return F.error_setInpError(ERR_DATETIME, token) end
      end
      goto swend1
    end
    ::case7::
    do
      F.sstrncpy(strDate, token, 6)
      F.sstrcat(strDate, S[35], 25)
      if (F.datetime_strToDate(strDate, value, value__k) ~= 0) then
        value[value__k] = (F.datetime_dayOfYear(value[value__k]) * 1.0)
      elseif (((not (F.getDouble(token, value, value__k) ~= 0)) or (value[value__k] < 1.0)) or (value[value__k] > 365.0)) then
        do return F.error_setInpError(ERR_DATETIME, token) end
      end
      goto swend1
    end
    ::case8::
    do
      if (not (F.getDouble(token, value, value__k) ~= 0)) then
        do return F.error_setInpError(ERR_NUMBER, token) end
      end
    end
    ::swend1::
  end
  do return 0 end
end

-- controls.c:889
F.addAction = function(r, tok, nToks)
  local G_Link, G_Rules = G.Link, G.Rules
  local obj = 0
  local link = 0
  local attrib = {0}
  local curve = {(-1)}
  local tseries = {(-1)}
  local n = 0
  local err = 0
  local values = {[0] = 1.0, 0.0, 0.0}
  local a = nil
  if (nToks < 6) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  obj = F.findmatch(tok[1], G.ObjectWords)
  if ((((((obj ~= r_LINK) and (obj ~= r_CONDUIT)) and (obj ~= r_PUMP)) and (obj ~= r_ORIFICE)) and (obj ~= r_WEIR)) and (obj ~= r_OUTLET)) then
    do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
  end
  link = F.project_findObject(LINK, tok[2])
  if (link < 0) then
    do return F.error_setInpError(ERR_NAME, tok[2]) end
  end
  do
    local __sw1 = obj
    if __sw1 == r_CONDUIT then goto case2
    elseif __sw1 == r_PUMP then goto case3
    elseif __sw1 == r_ORIFICE then goto case4
    elseif __sw1 == r_WEIR then goto case5
    elseif __sw1 == r_OUTLET then goto case6
    else goto swend1 end
    ::case2::
    do
      if (G_Link[link].type_ ~= CONDUIT) then
        do return F.error_setInpError(ERR_NAME, tok[2]) end
      end
      goto swend1
    end
    ::case3::
    do
      if (G_Link[link].type_ ~= PUMP) then
        do return F.error_setInpError(ERR_NAME, tok[2]) end
      end
      goto swend1
    end
    ::case4::
    do
      if (G_Link[link].type_ ~= ORIFICE) then
        do return F.error_setInpError(ERR_NAME, tok[2]) end
      end
      goto swend1
    end
    ::case5::
    do
      if (G_Link[link].type_ ~= WEIR) then
        do return F.error_setInpError(ERR_NAME, tok[2]) end
      end
      goto swend1
    end
    ::case6::
    do
      if (G_Link[link].type_ ~= OUTLET) then
        do return F.error_setInpError(ERR_NAME, tok[2]) end
      end
      goto swend1
    end
    ::swend1::
  end
  attrib[1] = F.findmatch(tok[3], G.AttribWords)
  if (attrib[1] < 0) then
    do return F.error_setInpError(ERR_KEYWORD, tok[3]) end
  end
  if (obj == r_CONDUIT) then
    if (attrib[1] == r_STATUS) then
      values[0] = (F.findmatch(tok[5], G.ConduitWords) * 1.0)
      if (values[0] < 0.0) then
        do return F.error_setInpError(ERR_KEYWORD, tok[5]) end
      end
    else
      do return F.error_setInpError(ERR_KEYWORD, tok[3]) end
    end
  elseif (obj == r_PUMP) then
    if (attrib[1] == r_STATUS) then
      values[0] = (F.findmatch(tok[5], G.StatusWords) * 1.0)
      if (values[0] < 0.0) then
        do return F.error_setInpError(ERR_KEYWORD, tok[5]) end
      end
    elseif (attrib[1] == r_SETTING) then
      err = F.setActionSetting(tok, nToks, curve, 1, tseries, 1, attrib, 1, values)
      if (err > 0) then
        do return err end
      end
    else
      do return F.error_setInpError(ERR_KEYWORD, tok[3]) end
    end
  elseif (((obj == r_ORIFICE) or (obj == r_WEIR)) or (obj == r_OUTLET)) then
    if (attrib[1] == r_SETTING) then
      err = F.setActionSetting(tok, nToks, curve, 1, tseries, 1, attrib, 1, values)
      if (err > 0) then
        do return err end
      end
      if ((attrib[1] == r_SETTING) and (((values[0] < 0.0) or (values[0] > 1.0)))) then
        do return F.error_setInpError(ERR_NUMBER, tok[5]) end
      end
    else
      do return F.error_setInpError(ERR_KEYWORD, tok[3]) end
    end
  else
    do return F.error_setInpError(ERR_KEYWORD, tok[1]) end
  end
  n = 6
  if ((curve[1] >= 0) or (tseries[1] >= 0)) then
    n = 7
  end
  if (attrib[1] == r_PID) then
    n = 9
  end
  if ((n < nToks) and (F.findmatch(tok[n], G.RuleKeyWords) >= 0)) then
    do return ERR_RULE end
  end
  a = T.TAction()
  if (not (a ~= nil)) then
    do return ERR_MEMORY end
  end
  a.rule = r
  a.link = link
  a.attribute = attrib[1]
  a.curve = curve[1]
  a.tseries = tseries[1]
  a.value = values[0]
  if (attrib[1] == r_PID) then
    a.kp = values[0]
    a.ki = values[1]
    a.kd = values[2]
    a.e1 = 0.0
    a.e2 = 0.0
  end
  if (G.InputState == r_THEN) then
    a.next_ = G_Rules[r].thenActions
    G_Rules[r].thenActions = a
  else
    a.next_ = G_Rules[r].elseActions
    G_Rules[r].elseActions = a
  end
  do return 0 end
end

-- controls.c:1028
F.setActionSetting = function(tok, nToks, curve, curve__k, tseries, tseries__k, attrib, attrib__k, values)
  local k = 0
  local m = 0
  if (nToks < 6) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  k = F.findmatch(tok[5], G.SettingTypeWords)
  if ((k >= 0) and (nToks < 7)) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  do
    local __sw1 = k
    if __sw1 == r_CURVE then goto case2
    elseif __sw1 == r_TIMESERIES then goto case3
    elseif __sw1 == r_PID then goto case4
    else goto case5 end
    ::case2::
    do
      m = F.project_findObject(CURVE, tok[6])
      if (m < 0) then
        do return F.error_setInpError(ERR_NAME, tok[6]) end
      end
      curve[curve__k] = m
      goto swend1
    end
    ::case3::
    do
      m = F.project_findObject(TSERIES, tok[6])
      if (m < 0) then
        do return F.error_setInpError(ERR_NAME, tok[6]) end
      end
      tseries[tseries__k] = m
      G.Tseries[m].refersTo = CONTROL
      goto swend1
    end
    ::case4::
    do
      if (nToks < 9) then
        do return F.error_setInpError(ERR_ITEMS, S[0]) end
      end
      do
        m = 6
        while (m <= 8) do
          do
            if (not (F.getDouble(tok[m], values, (m - 6)) ~= 0)) then
              do return F.error_setInpError(ERR_NUMBER, tok[m]) end
            end
          end
          m = m + 1
        end
      end
      attrib[attrib__k] = r_PID
      goto swend1
    end
    ::case5::
    do
      if (not (F.getDouble(tok[5], values, 0) ~= 0)) then
        do return F.error_setInpError(ERR_NUMBER, tok[5]) end
      end
    end
    ::swend1::
  end
  do return 0 end
end

-- controls.c:1086
F.updateActionValue = function(a, currentTime, dt)
  if (a.curve >= 0) then
    a.value = F.table_lookup(G.Curve[a.curve], G.ControlValue)
  elseif (a.tseries >= 0) then
    a.value = F.table_tseriesLookup(G.Tseries[a.tseries], currentTime, 1)
  elseif (a.attribute == r_PID) then
    a.value = F.getPIDSetting(a, dt)
  end
end

-- controls.c:1111
F.getPIDSetting = function(a, dt)
  local G_Link = G.Link
  local e0 = 0.0
  local setting = 0.0
  local p = 0.0
  local i = 0.0
  local d = 0.0
  local update = 0.0
  local tolerance = 0.0001
  dt = (dt * 1440.0)
  e0 = (G.SetPoint - G.ControlValue)
  if (m_abs(e0) > 1e-06) then
    if (G.SetPoint ~= 0.0) then
      e0 = (e0 / G.SetPoint)
    else
      e0 = (e0 / G.ControlValue)
    end
  end
  if (m_abs((e0 - a.e1)) < tolerance) then
    a.e2 = 0.0
    a.e1 = 0.0
  end
  p = ((e0 - a.e1))
  if (a.ki == 0.0) then
    i = 0.0
  else
    i = ((e0 * dt) / a.ki)
  end
  d = ((a.kd * (((e0 - (2.0 * a.e1)) + a.e2))) / dt)
  update = (a.kp * (((p + i) + d)))
  if (m_abs(update) < tolerance) then
    update = 0.0
  end
  setting = (G_Link[a.link].targetSetting + update)
  a.e2 = a.e1
  a.e1 = e0
  if (setting < 0.0) then
    setting = 0.0
  end
  if ((G_Link[a.link].type_ ~= PUMP) and (setting > 1.0)) then
    setting = 1.0
  end
  do return setting end
end

-- controls.c:1168
F.updateActionList = function(a)
  local G_Rules = G.Rules
  local listItem = nil
  local a1 = nil
  local priority = G_Rules[a.rule].priority
  listItem = G.ActionList
  while (listItem ~= nil) do
    do
      a1 = listItem.action
      if (not (a1 ~= nil)) then
        break
      end
      if (a1.link == a.link) then
        if (priority > G_Rules[a1.rule].priority) then
          listItem.action = a
        end
        do return end
      end
      listItem = listItem.next_
    end
  end
  if (not (listItem ~= nil)) then
    listItem = T.TActionList()
    listItem.next_ = G.ActionList
    G.ActionList = listItem
  end
  listItem.action = a
end

-- controls.c:1206
F.executeActionList = function(currentTime)
  local G_Link, G_RptFlags, G_Rules = G.Link, G.RptFlags, G.Rules
  local listItem = nil
  local nextItem = nil
  local a1 = nil
  local count = 0
  listItem = G.ActionList
  while (listItem ~= nil) do
    do
      a1 = listItem.action
      if (not (a1 ~= nil)) then
        break
      end
      if (a1.link >= 0) then
        if (G_Link[a1.link].targetSetting ~= a1.value) then
          G_Link[a1.link].targetSetting = a1.value
          if ((((G_RptFlags.controls ~= 0) and (a1.curve < 0)) and (a1.tseries < 0)) and (a1.attribute ~= r_PID)) then
            F.report_writeControlAction(currentTime, G_Link[a1.link].ID, a1.value, G_Rules[a1.rule].ID)
          end
          count = count + 1
        end
      end
      nextItem = listItem.next_
      listItem = nextItem
    end
  end
  do return count end
end

-- controls.c:1243
F.evaluatePremise = function(p, tStep)
  local lhsValue = 0.0
  local rhsValue = 0.0
  local result = 0
  if (p.exprIndex >= 0) then
    lhsValue = F.mathexpr_eval(G.Expression[p.exprIndex].expression, F.getNamedVariableValue)
  else
    lhsValue = F.getVariableValue(p.lhsVar)
  end
  if (p.value == (-10000000000.0)) then
    rhsValue = F.getVariableValue(p.rhsVar)
  else
    rhsValue = p.value
  end
  if ((lhsValue == (-10000000000.0)) or (rhsValue == (-10000000000.0))) then
    do return 0 end
  end
  do
    local __sw1 = p.lhsVar.attribute
    if __sw1 == r_TIME or __sw1 == r_CLOCKTIME then goto case2
    elseif __sw1 == r_TIMEOPEN or __sw1 == r_TIMECLOSED then goto case3
    else goto case4 end
    ::case2::
    do
      do return F.compareTimes(lhsValue, p.relation, rhsValue, (tStep / 2.0)) end
    end
    ::case3::
    do
      result = F.compareTimes(lhsValue, p.relation, rhsValue, (tStep / 2.0))
      G.ControlValue = (lhsValue * 24.0)
      do return result end
    end
    ::case4::
    do
      do return F.compareValues(lhsValue, p.relation, rhsValue) end
    end
    ::swend1::
  end
end

-- controls.c:1286
F.getVariableValue = function(v)
  local G_Link, G_Conduit, G_Node = G.Link, G.Conduit, G.Node
  local i = (-1)
  local j = (-1)
  if (v.object == r_GAGE) then
    do return F.getRainValue(v) end
  end
  if (v.object == r_NODE) then
    i = v.index
  end
  if (v.object == r_LINK) then
    j = v.index
  end
  do
    local __sw1 = v.attribute
    if __sw1 < r_LENGTH then
      if __sw1 < r_FLOW then
        if __sw1 < r_HEAD then
          if __sw1 == r_DEPTH then goto case12
          elseif __sw1 == r_MAXDEPTH then goto case13
          end
        else
          if __sw1 == r_HEAD then goto case14
          elseif __sw1 == r_VOLUME then goto case15
          elseif __sw1 == r_INFLOW then goto case16
          end
        end
      else
        if __sw1 < r_FULLDEPTH then
          if __sw1 == r_FLOW then goto case10
          elseif __sw1 == r_FULLFLOW then goto case11
          end
        else
          if __sw1 == r_FULLDEPTH then goto case11
          elseif __sw1 == r_STATUS then goto case8
          elseif __sw1 == r_SETTING then goto case9
          end
        end
      end
    else
      if __sw1 < r_TIME then
        if __sw1 < r_VELOCITY then
          if __sw1 == r_LENGTH then goto case11
          elseif __sw1 == r_SLOPE then goto case11
          end
        else
          if __sw1 == r_VELOCITY then goto case11
          elseif __sw1 == r_TIMEOPEN then goto case17
          elseif __sw1 == r_TIMECLOSED then goto case18
          end
        end
      else
        if __sw1 < r_DAYOFYEAR then
          if __sw1 == r_TIME then goto case2
          elseif __sw1 == r_DATE then goto case3
          elseif __sw1 == r_CLOCKTIME then goto case4
          end
        else
          if __sw1 == r_DAYOFYEAR then goto case7
          elseif __sw1 == r_DAY then goto case5
          elseif __sw1 == r_MONTH then goto case6
          end
        end
      end
    end
    goto case19
    ::case2::
    do
      do return G.ElapsedTime end
    end
    ::case3::
    do
      do return G.CurrentDate end
    end
    ::case4::
    do
      do return G.CurrentTime end
    end
    ::case5::
    do
      do return (F.datetime_dayOfWeek(G.CurrentDate) * 1.0) end
    end
    ::case6::
    do
      do return (F.datetime_monthOfYear(G.CurrentDate) * 1.0) end
    end
    ::case7::
    do
      do return (F.datetime_dayOfYear(G.CurrentDate) * 1.0) end
    end
    ::case8::
    do
      if ((j < 0) or (((G_Link[j].type_ ~= CONDUIT) and (G_Link[j].type_ ~= PUMP)))) then
        do return (-10000000000.0) end
      else
        do return G_Link[j].setting end
      end
    end
    ::case9::
    do
      if ((j < 0) or ((((G_Link[j].type_ ~= PUMP) and (G_Link[j].type_ ~= ORIFICE)) and (G_Link[j].type_ ~= WEIR)))) then
        do return (-10000000000.0) end
      else
        do return G_Link[j].setting end
      end
    end
    ::case10::
    do
      if (j < 0) then
        do return (-10000000000.0) end
      else
        do return (((G_Link[j].direction * 1.0) * G_Link[j].newFlow) * F.UCF(FLOW)) end
      end
    end
    ::case11::
    do
      if (j < 0) then
        do return (-10000000000.0) end
      elseif (G_Link[j].type_ ~= CONDUIT) then
        do return (-10000000000.0) end
      end
      do
        local __sw2 = v.attribute
        if __sw2 == r_FULLFLOW then goto case21
        elseif __sw2 == r_FULLDEPTH then goto case22
        elseif __sw2 == r_VELOCITY then goto case23
        elseif __sw2 == r_LENGTH then goto case24
        elseif __sw2 == r_SLOPE then goto case25
        else goto case26 end
        ::case21::
        do
          do return (G_Link[j].qFull * F.UCF(FLOW)) end
        end
        ::case22::
        do
          do return (G_Link[j].xsect.yFull * F.UCF(LENGTH)) end
        end
        ::case23::
        do
          do return (F.link_getVelocity(j, G_Link[j].newFlow, G_Link[j].newDepth) * F.UCF(LENGTH)) end
        end
        ::case24::
        do
          do return (G_Conduit[G_Link[j].subIndex].length * F.UCF(LENGTH)) end
        end
        ::case25::
        do
          do return G_Conduit[G_Link[j].subIndex].slope end
        end
        ::case26::
        do
          do return (-10000000000.0) end
        end
        ::swend20::
      end
    end
    ::case12::
    do
      if (j >= 0) then
        do return (G_Link[j].newDepth * F.UCF(LENGTH)) end
      elseif (i >= 0) then
        do return (G_Node[i].newDepth * F.UCF(LENGTH)) end
      else
        do return (-10000000000.0) end
      end
    end
    ::case13::
    do
      if (i >= 0) then
        do return (G_Node[i].fullDepth * F.UCF(LENGTH)) end
      else
        do return (-10000000000.0) end
      end
    end
    ::case14::
    do
      if (i < 0) then
        do return (-10000000000.0) end
      end
      do return (((G_Node[i].newDepth + G_Node[i].invertElev)) * F.UCF(LENGTH)) end
    end
    ::case15::
    do
      if (i < 0) then
        do return (-10000000000.0) end
      end
      do return ((G_Node[i].newVolume * F.UCF(VOLUME))) end
    end
    ::case16::
    do
      if (i < 0) then
        do return (-10000000000.0) end
      else
        do return (G_Node[i].newLatFlow * F.UCF(FLOW)) end
      end
    end
    ::case17::
    do
      if (j < 0) then
        do return (-10000000000.0) end
      end
      if (G_Link[j].setting <= 0.0) then
        do return (-10000000000.0) end
      end
      do return ((G.CurrentDate + G.CurrentTime) - G_Link[j].timeLastSet) end
    end
    ::case18::
    do
      if (j < 0) then
        do return (-10000000000.0) end
      end
      if (G_Link[j].setting > 0.0) then
        do return (-10000000000.0) end
      end
      do return ((G.CurrentDate + G.CurrentTime) - G_Link[j].timeLastSet) end
    end
    ::case19::
    do
      do return (-10000000000.0) end
    end
    ::swend1::
  end
end

-- controls.c:1388
F.getRainValue = function(v)
  local G_Gage = G.Gage
  if (v.index < 0) then
    do return (-10000000000.0) end
  elseif (G_Gage[v.index].isUsed == 0) then
    do return 0.0 end
  elseif (v.attribute == 0) then
    do return G_Gage[v.index].rainfall end
  else
    do return F.gage_getPastRain(v.index, v.attribute) end
  end
end

-- controls.c:1405
F.compareTimes = function(lhsValue, relation, rhsValue, halfStep)
  if (relation == EQ) then
    if ((lhsValue >= (rhsValue - halfStep)) and (lhsValue < (rhsValue + halfStep))) then
      do return 1 end
    end
    do return 0 end
  elseif (relation == NE) then
    if ((lhsValue < (rhsValue - halfStep)) or (lhsValue >= (rhsValue + halfStep))) then
      do return 1 end
    end
    do return 0 end
  else
    do return F.compareValues(lhsValue, relation, rhsValue) end
  end
end

-- controls.c:1432
F.compareValues = function(lhsValue, relation, rhsValue)
  G.SetPoint = rhsValue
  G.ControlValue = lhsValue
  do
    local __sw1 = relation
    if __sw1 < LE then
      if __sw1 == EQ then goto case2
      elseif __sw1 == NE then goto case3
      elseif __sw1 == LT then goto case4
      end
    else
      if __sw1 == LE then goto case5
      elseif __sw1 == GT then goto case6
      elseif __sw1 == GE then goto case7
      end
    end
    goto swend1
    ::case2::
    do
      if (lhsValue == rhsValue) then
        do return 1 end
      end
      goto swend1
    end
    ::case3::
    do
      if (lhsValue ~= rhsValue) then
        do return 1 end
      end
      goto swend1
    end
    ::case4::
    do
      if (lhsValue < rhsValue) then
        do return 1 end
      end
      goto swend1
    end
    ::case5::
    do
      if (lhsValue <= rhsValue) then
        do return 1 end
      end
      goto swend1
    end
    ::case6::
    do
      if (lhsValue > rhsValue) then
        do return 1 end
      end
      goto swend1
    end
    ::case7::
    do
      if (lhsValue >= rhsValue) then
        do return 1 end
      end
      goto swend1
    end
    ::swend1::
  end
  do return 0 end
end

-- controls.c:1455
F.clearActionList = function()
  local listItem = nil
  listItem = G.ActionList
  while (listItem ~= nil) do
    do
      listItem.action = (nil)
      listItem = listItem.next_
    end
  end
end

-- controls.c:1473
F.deleteActionList = function()
  local listItem = nil
  local nextItem = nil
  listItem = G.ActionList
  while (listItem ~= nil) do
    do
      nextItem = listItem.next_
      local _ = nil
      listItem = nextItem
    end
  end
  G.ActionList = (nil)
end

-- controls.c:1494
F.deleteRules = function()
  local p = nil
  local pnext = nil
  local a = nil
  local anext = nil
  local r = 0
  do
    r = 0
    while (r < G.RuleCount) do
      do
        p = G.Rules[r].firstPremise
        while (p ~= nil) do
          do
            pnext = p.next_
            local _ = nil
            p = pnext
          end
        end
        a = G.Rules[r].thenActions
        while (a ~= nil) do
          do
            anext = a.next_
            local _ = nil
            a = anext
          end
        end
        a = G.Rules[r].elseActions
        while (a ~= nil) do
          do
            anext = a.next_
            local _ = nil
            a = anext
          end
        end
      end
      r = r + 1
    end
  end
  do
    if (G.Rules ~= nil) then
      local _ = nil
      G.Rules = (nil)
    end
  end
  G.RuleCount = 0
end

-- controls.c:1536
F.findExactMatch = function(s, keyword)
  local i = 0
  while not R.peq(keyword[i], (nil)) do
    do
      if (F.strcomp(s, keyword[i]) ~= 0) then
        do return (i) end
      end
      i = i + 1
    end
  end
  do return ((-1)) end
end

