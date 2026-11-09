-- Generated from EPA SWMM 5.2.4 (treatmnt.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local POLLUT <const> = 4
local ERR_MEMORY <const> = 101
local ERR_ITEMS <const> = 203
local NODE <const> = 2
local ERR_NAME <const> = 209
local ERR_KEYWORD <const> = 205
local ERR_MATH_EXPR <const> = 233
local REMOVAL <const> = 0
local ERR_CYCLIC_TREATMENT <const> = 161
local pvHRT <const> = 0
local pvDT <const> = 1
local pvFLOW <const> = 2
local pvDEPTH <const> = 3
local pvAREA <const> = 4
local STORAGE <const> = 2
local FLOW <const> = 10
local LENGTH <const> = 3
local _ENV = R.strict

G.PVMAX = 5
G.ErrCode = 0
G.J = 0
G.Dt = 0.0
G.Q = 0.0
G.V = 0.0
G.R_ = nil
G.Cin = nil

-- treatmnt.c:66
F.treatmnt_open = function()
  local G_Nobjects = G.Nobjects
  G.R_ = (nil)
  G.Cin = (nil)
  if (G_Nobjects[POLLUT] > 0) then
    G.R_ = R.fill(G_Nobjects[POLLUT], 0.0)
    G.Cin = R.fill(G_Nobjects[POLLUT], 0.0)
    if ((G.R_ == (nil)) or (G.Cin == (nil))) then
      F.report_writeErrorMsg(ERR_MEMORY, S[0])
      do return 0 end
    end
  end
  do return 1 end
end

-- treatmnt.c:90
F.treatmnt_close = function()
  do
    if (G.R_ ~= nil) then
      local _ = nil
      G.R_ = (nil)
    end
  end
  do
    if (G.Cin ~= nil) then
      local _ = nil
      G.Cin = (nil)
    end
  end
end

-- treatmnt.c:103
F.treatmnt_readExpression = function(tok, ntoks)
  local G_Node = G.Node
  local s = R.buf(1025)
  local expr = nil
  local i = 0
  local j = 0
  local k = 0
  local p = 0
  local equation = nil
  if (ntoks < 3) then
    do return F.error_setInpError(ERR_ITEMS, S[0]) end
  end
  j = F.project_findObject(NODE, tok[0])
  if (j < 0) then
    do return F.error_setInpError(ERR_NAME, tok[0]) end
  end
  p = F.project_findObject(POLLUT, tok[1])
  if (p < 0) then
    do return F.error_setInpError(ERR_NAME, tok[1]) end
  end
  F.sstrncpy(s, tok[2], 1024)
  do
    i = 3
    while (i < ntoks) do
      do
        F.sstrcat(s, S[33], 1024)
        F.sstrcat(s, tok[i], 1024)
      end
      i = i + 1
    end
  end
  if (((((((s.b[s.o]) >= 97) and ((s.b[s.o]) <= 122))) and (((s.b[s.o]) & (~32))) or (s.b[s.o]))) == 82) then
    k = 0
  elseif (((((((s.b[s.o]) >= 97) and ((s.b[s.o]) <= 122))) and (((s.b[s.o]) & (~32))) or (s.b[s.o]))) == 67) then
    k = 1
  else
    do return F.error_setInpError(ERR_KEYWORD, tok[2]) end
  end
  expr = R.strchr(s, 61)
  if R.peq(expr, (nil)) then
    do return F.error_setInpError(ERR_KEYWORD, S[0]) end
  else
    expr = R.padd(expr, 1)
  end
  if (G_Node[j].treatment == (nil)) then
    if (not (F.createTreatment(j) ~= 0)) then
      do return F.error_setInpError(ERR_MEMORY, S[0]) end
    end
  end
  equation = F.mathexpr_create(expr, F.treatmnt_getVariableIndex)
  if (equation == (nil)) then
    do return F.error_setInpError(ERR_MATH_EXPR, S[0]) end
  end
  if (G_Node[j].treatment ~= (nil)) then
    G_Node[j].treatment[p].treatType = k
    G_Node[j].treatment[p].equation = equation
  end
  do return 0 end
end

-- treatmnt.c:165
F.treatmnt_delete = function(j)
  local G_Node, G_Nobjects = G.Node, G.Nobjects
  local p = 0
  if (G_Node[j].treatment ~= nil) then
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          F.mathexpr_delete(G_Node[j].treatment[p].equation)
        end
        p = p + 1
      end
    end
    local _ = nil
  end
  G_Node[j].treatment = (nil)
end

-- treatmnt.c:184
F.treatmnt_setInflow = function(qIn, wIn)
  local G_Nobjects, G_Cin = G.Nobjects, G.Cin
  local p = 0
  if (qIn > 0.0) then
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          G_Cin[p] = (wIn[p] / qIn)
        end
        p = p + 1
      end
    end
  else
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          G_Cin[p] = 0.0
        end
        p = p + 1
      end
    end
  end
end

-- treatmnt.c:202
F.treatmnt_treat = function(j, q, v, tStep)
  local G_Node, G_Nobjects, G_R_, G_Cin = G.Node, G.Nobjects, G.R_, G.Cin
  local p = 0
  local cOut = 0.0
  local massLost = 0.0
  local treatment = nil
  if (G_Node[j].treatment == (nil)) then
    do return end
  end
  G.ErrCode = 0
  G.J = j
  G.Dt = tStep
  G.Q = q
  G.V = v
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        G_R_[p] = (-1.0)
      end
      p = p + 1
    end
  end
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        treatment = G_Node[j].treatment[p]
        if (treatment.equation == (nil)) then
          G_R_[p] = 0.0
        elseif ((treatment.treatType == REMOVAL) and (q <= 1e-10)) then
          G_R_[p] = 0.0
        else
          F.getRemoval(p)
        end
      end
      p = p + 1
    end
  end
  if (G.ErrCode == ERR_CYCLIC_TREATMENT) then
    F.report_writeErrorMsg(ERR_CYCLIC_TREATMENT, G_Node[G.J].ID)
  else
    do
      p = 0
      while (p < G_Nobjects[POLLUT]) do
        do
          if (G_R_[p] == 0.0) then
            goto continue3
          end
          treatment = G_Node[j].treatment[p]
          if (treatment.treatType == REMOVAL) then
            if (G_Cin[p] == 0.0) then
              cOut = G_Node[j].newQual[p]
            else
              cOut = (((1.0 - G_R_[p])) * G_Cin[p])
            end
            cOut = (((((cOut) <= (G_Node[j].newQual[p]))) and (cOut) or (G_Node[j].newQual[p])))
          else
            cOut = (((1.0 - G_R_[p])) * G_Node[j].newQual[p])
          end
          massLost = ((((((G_Cin[p] * q) * tStep) + (G_Node[j].oldQual[p] * G_Node[j].oldVolume)) - (cOut * (((q * tStep) + G_Node[j].oldVolume))))) / tStep)
          massLost = (((((0.0) >= (massLost))) and (0.0) or (massLost)))
          F.massbal_addReactedMass(p, massLost)
          G_Node[j].newQual[p] = cOut
        end
        ::continue3::
        p = p + 1
      end
    end
  end
end

-- treatmnt.c:288
F.createTreatment = function(j)
  local G_Nobjects, G_Node = G.Nobjects, G.Node
  local p = 0
  G_Node[j].treatment = R.recs(G_Nobjects[POLLUT], T.TTreatment)
  if (G_Node[j].treatment == (nil)) then
    do return 0 end
  end
  do
    p = 0
    while (p < G_Nobjects[POLLUT]) do
      do
        G_Node[j].treatment[p].equation = (nil)
      end
      p = p + 1
    end
  end
  do return 1 end
end

-- treatmnt.c:311
F.treatmnt_getVariableIndex = function(s)
  local k = 0
  local m = G.PVMAX
  k = F.findmatch(s, G.ProcessVarWords)
  if (k >= 0) then
    do return k end
  end
  k = F.project_findObject(POLLUT, s)
  if (k >= 0) then
    do return ((k + m)) end
  end
  if ((((((((s.b[s.o]) >= 97) and ((s.b[s.o]) <= 122))) and (((s.b[s.o]) & (~32))) or (s.b[s.o]))) == 82) and (s.b[s.o + 1] == 95)) then
    k = F.project_findObject(POLLUT, R.padd(s, 2))
    if (k >= 0) then
      do return (((G.Nobjects[POLLUT] + k) + m)) end
    end
  end
  do return (-1) end
end

-- treatmnt.c:340
F.treatmnt_getVariableValue = function(varCode)
  local G_Node, G_Nobjects = G.Node, G.Nobjects
  local p = 0
  local a1 = 0.0
  local a2 = 0.0
  local y = 0.0
  local treatment = nil
  if (varCode < G.PVMAX) then
    do
      local __sw1 = varCode
      if __sw1 == pvHRT then goto case2
      elseif __sw1 == pvDT then goto case3
      elseif __sw1 == pvFLOW then goto case4
      elseif __sw1 == pvDEPTH then goto case5
      elseif __sw1 == pvAREA then goto case6
      else goto case7 end
      ::case2::
      do
        if (G_Node[G.J].type_ == STORAGE) then
          do return (G.Storage[G_Node[G.J].subIndex].hrt / 3600.0) end
        else
          do return 0.0 end
        end
      end
      ::case3::
      do
        do return G.Dt end
      end
      ::case4::
      do
        do return (G.Q * F.UCF(FLOW)) end
      end
      ::case5::
      do
        y = (((G_Node[G.J].oldDepth + G_Node[G.J].newDepth)) / 2.0)
        do return (y * F.UCF(LENGTH)) end
      end
      ::case6::
      do
        a1 = F.node_getSurfArea(G.J, G_Node[G.J].oldDepth)
        a2 = F.node_getSurfArea(G.J, G_Node[G.J].newDepth)
        do return (((((a1 + a2)) / 2.0) * F.UCF(LENGTH)) * F.UCF(LENGTH)) end
      end
      ::case7::
      do
        do return 0.0 end
      end
      ::swend1::
    end
  elseif (varCode < (G.PVMAX + G_Nobjects[POLLUT])) then
    p = (varCode - G.PVMAX)
    treatment = G_Node[G.J].treatment[p]
    if (treatment.treatType == REMOVAL) then
      do return G.Cin[p] end
    end
    do return G_Node[G.J].newQual[p] end
  else
    p = ((varCode - G.PVMAX) - G_Nobjects[POLLUT])
    if (p >= G_Nobjects[POLLUT]) then
      do return 0.0 end
    end
    do return F.getRemoval(p) end
  end
end

-- treatmnt.c:404
F.getRemoval = function(p)
  local G_Node, G_R_ = G.Node, G.R_
  local c0 = G_Node[G.J].newQual[p]
  local r = 0.0
  local treatment = nil
  if ((G_R_[p] > 1.0) or (G.ErrCode ~= 0)) then
    G.ErrCode = 1
    do return 0.0 end
  end
  if ((G_R_[p] >= 0.0) and (G_R_[p] <= 1.0)) then
    do return G_R_[p] end
  end
  G_R_[p] = 10.0
  if (c0 == 0.0) then
    G_R_[p] = 0.0
    do return 0.0 end
  end
  treatment = G_Node[G.J].treatment[p]
  r = F.mathexpr_eval(treatment.equation, F.treatmnt_getVariableValue)
  r = (((((0.0) >= (r))) and (0.0) or (r)))
  if (treatment.treatType == REMOVAL) then
    r = (((((1.0) <= (r))) and (1.0) or (r)))
    G_R_[p] = r
  else
    r = (((((c0) <= (r))) and (c0) or (r)))
    G_R_[p] = (1.0 - (r / c0))
  end
  do return G_R_[p] end
end

