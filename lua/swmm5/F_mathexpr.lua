-- Generated from EPA SWMM 5.2.4 (mathexpr.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local _ENV = R.strict

G.Err = 0
G.Bc = 0
G.PrevLex = 0
G.CurLex = 0
G.Len = 0
G.Pos = 0
G.S_ = nil
G.Token = R.buf(255)
G.Ivar = 0
G.Fvalue = 0.0
G.MathFunc = {[0] = S[1004], S[1005], S[1006], S[1007], S[1008], S[1009], S[1010], S[1011], S[739], S[1012], S[1013], S[1014], S[1015], S[1016], S[1017], S[1018], S[1019], S[1020], S[1021], (nil)}
G.mathexpr_getVariableIndex = nil

-- mathexpr.c:109
F.sametext = function(s1, s2)
  local i = 0
  do
    i = 0
    while (R.toupper(s1.b[s1.o + i]) == R.toupper(s2.b[s2.o + i])) do
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

-- mathexpr.c:130
F.isDigit = function(c)
  if ((c >= 49) and (c <= 57)) then
    do return 1 end
  end
  if (c == 48) then
    do return 1 end
  end
  do return 0 end
end

-- mathexpr.c:139
F.isLetter = function(c)
  if ((c >= 97) and (c <= 122)) then
    do return 1 end
  end
  if ((c >= 65) and (c <= 90)) then
    do return 1 end
  end
  if (c == 95) then
    do return 1 end
  end
  do return 0 end
end

-- mathexpr.c:149
F.getToken = function()
  local G_Token, G_S_ = G.Token, G.S_
  local c = R.bufFrom(S[33], 2)
  R.cset(G_Token, 0, 0)
  while ((G.Pos <= G.Len) and (((F.isLetter(G_S_.b[G_S_.o + G.Pos]) ~= 0) or (F.isDigit(G_S_.b[G_S_.o + G.Pos]) ~= 0)))) do
    do
      R.cset(c, 0, G_S_.b[G_S_.o + G.Pos])
      R.strcat(G_Token, c)
      G.Pos = G.Pos + 1
    end
  end
  G.Pos = G.Pos - 1
end

-- mathexpr.c:165
F.getMathFunc = function()
  local G_MathFunc, G_Token = G.MathFunc, G.Token
  local i = 0
  while not R.peq(G_MathFunc[i], (nil)) do
    do
      if (F.sametext(G_MathFunc[i], G_Token) ~= 0) then
        do return (i + 10) end
      end
      i = i + 1
    end
  end
  do return (0) end
end

-- mathexpr.c:178
F.getVariable = function()
  local G_mathexpr_getVariableIndex = G.mathexpr_getVariableIndex
  if (not (G_mathexpr_getVariableIndex ~= nil)) then
    do return 0 end
  end
  G.Ivar = G_mathexpr_getVariableIndex(G.Token)
  if (G.Ivar >= 0) then
    do return 8 end
  end
  do return 0 end
end

-- mathexpr.c:188
F.getNumber = function()
  local G_S_ = G.S_
  local c = R.bufFrom(S[33], 2)
  local sNumber = R.buf(255)
  local errflag = 0
  local decimalCount = 0
  R.cset(sNumber, 0, 0)
  while ((G.Pos < G.Len) and (F.isDigit(G_S_.b[G_S_.o + G.Pos]) ~= 0)) do
    do
      R.cset(c, 0, G_S_.b[G_S_.o + G.Pos])
      R.strcat(sNumber, c)
      G.Pos = G.Pos + 1
    end
  end
  if (G.Pos < G.Len) then
    if (G_S_.b[G_S_.o + G.Pos] == 46) then
      decimalCount = decimalCount + 1
      if (decimalCount > 1) then
        G.Err = 1
      end
      R.strcat(sNumber, S[315])
      G.Pos = G.Pos + 1
      while ((G.Pos < G.Len) and (F.isDigit(G_S_.b[G_S_.o + G.Pos]) ~= 0)) do
        do
          R.cset(c, 0, G_S_.b[G_S_.o + G.Pos])
          R.strcat(sNumber, c)
          G.Pos = G.Pos + 1
        end
      end
    end
    if ((G.Pos < G.Len) and (((G_S_.b[G_S_.o + G.Pos] == 101) or (G_S_.b[G_S_.o + G.Pos] == 69)))) then
      R.strcat(sNumber, S[316])
      G.Pos = G.Pos + 1
      if (G.Pos >= G.Len) then
        errflag = 1
      else
        if ((G_S_.b[G_S_.o + G.Pos] == 45) or (G_S_.b[G_S_.o + G.Pos] == 43)) then
          R.cset(c, 0, G_S_.b[G_S_.o + G.Pos])
          R.strcat(sNumber, c)
          G.Pos = G.Pos + 1
        end
        if ((G.Pos >= G.Len) or (not (F.isDigit(G_S_.b[G_S_.o + G.Pos]) ~= 0))) then
          errflag = 1
        else
          while ((G.Pos < G.Len) and (F.isDigit(G_S_.b[G_S_.o + G.Pos]) ~= 0)) do
            do
              R.cset(c, 0, G_S_.b[G_S_.o + G.Pos])
              R.strcat(sNumber, c)
              G.Pos = G.Pos + 1
            end
          end
        end
      end
    end
  end
  G.Pos = G.Pos - 1
  if (errflag ~= 0) then
    do return 0.0 end
  else
    do return R.atof(sNumber) end
  end
end

-- mathexpr.c:252
F.getOperand = function()
  local G_S_ = G.S_
  local code = 0
  do
    local __sw1 = G_S_.b[G_S_.o + G.Pos]
    if __sw1 < 43 then
      if __sw1 == 40 then goto case2
      elseif __sw1 == 41 then goto case3
      elseif __sw1 == 42 then goto case6
      end
    else
      if __sw1 < 47 then
        if __sw1 == 43 then goto case4
        elseif __sw1 == 45 then goto case5
        end
      else
        if __sw1 == 47 then goto case7
        elseif __sw1 == 94 then goto case8
        end
      end
    end
    goto case9
    ::case2::
    do
      code = 1
      goto swend1
    end
    ::case3::
    do
      code = 2
      goto swend1
    end
    ::case4::
    do
      code = 3
      goto swend1
    end
    ::case5::
    do
      code = 4
      if (((G.Pos < (G.Len - 1)) and (F.isDigit(G_S_.b[G_S_.o + (G.Pos + 1)]) ~= 0)) and (((G.CurLex <= 6) or (G.CurLex == 31)))) then
        G.Pos = G.Pos + 1
        G.Fvalue = (-(F.getNumber()))
        code = 7
      end
      goto swend1
    end
    ::case6::
    do
      code = 5
      goto swend1
    end
    ::case7::
    do
      code = 6
      goto swend1
    end
    ::case8::
    do
      code = 31
      goto swend1
    end
    ::case9::
    do
      code = 0
    end
    ::swend1::
  end
  do return code end
end

-- mathexpr.c:280
F.getLex = function()
  local G_S_ = G.S_
  local n = 0
  while ((G.Pos < G.Len) and (G_S_.b[G_S_.o + G.Pos] == 32)) do
    do
      G.Pos = G.Pos + 1
    end
  end
  if (G.Pos >= G.Len) then
    do return 0 end
  end
  n = F.getOperand()
  if (n == 0) then
    if (F.isLetter(G_S_.b[G_S_.o + G.Pos]) ~= 0) then
      F.getToken()
      n = F.getMathFunc()
      if (n == 0) then
        n = F.getVariable()
      end
    elseif ((G_S_.b[G_S_.o + G.Pos] == 46) or (F.isDigit(G_S_.b[G_S_.o + G.Pos]) ~= 0)) then
      n = 7
      G.Fvalue = F.getNumber()
    end
  end
  G.Pos = G.Pos + 1
  G.PrevLex = G.CurLex
  G.CurLex = n
  do return n end
end

-- mathexpr.c:314
F.newNode = function()
  local node = nil
  node = T.ExprTree()
  if (not (node ~= nil)) then
    G.Err = 2
  else
    node.opcode = 0
    node.ivar = (-1)
    node.fvalue = 0.0
    node.left = (nil)
    node.right = (nil)
  end
  do return node end
end

-- mathexpr.c:332
F.getSingleOp = function(lex, lex__k)
  local opcode = 0
  local left = nil
  local node = nil
  if (lex[lex__k] == 1) then
    G.Bc = G.Bc + 1
    left = F.getTree()
  else
    if (((lex[lex__k] < 7) or (lex[lex__k] == 9)) or (lex[lex__k] > 30)) then
      G.Err = 1
      do return (nil) end
    end
    opcode = lex[lex__k]
    if ((lex[lex__k] == 7) or (lex[lex__k] == 8)) then
      left = F.newNode()
      left.opcode = opcode
      if (lex[lex__k] == 7) then
        left.fvalue = G.Fvalue
      end
      if (lex[lex__k] == 8) then
        left.ivar = G.Ivar
      end
    else
      lex[lex__k] = F.getLex()
      if (lex[lex__k] ~= 1) then
        G.Err = 1
        do return (nil) end
      end
      G.Bc = G.Bc + 1
      left = F.newNode()
      left.left = F.getTree()
      left.opcode = opcode
    end
  end
  lex[lex__k] = F.getLex()
  if (lex[lex__k] == 31) then
    node = F.newNode()
    node.left = left
    node.opcode = lex[lex__k]
    lex[lex__k] = F.getLex()
    node.right = F.getSingleOp(lex, lex__k)
    left = node
  end
  do return left end
end

-- mathexpr.c:397
F.getOp = function(lex, lex__k)
  local opcode = 0
  local left = nil
  local right = nil
  local node = nil
  local neg = 0
  lex[lex__k] = F.getLex()
  if ((G.PrevLex == 0) or (G.PrevLex == 1)) then
    if (lex[lex__k] == 4) then
      neg = 1
      lex[lex__k] = F.getLex()
    elseif (lex[lex__k] == 3) then
      lex[lex__k] = F.getLex()
    end
  end
  left = F.getSingleOp(lex, lex__k)
  while ((lex[lex__k] == 5) or (lex[lex__k] == 6)) do
    do
      opcode = lex[lex__k]
      lex[lex__k] = F.getLex()
      right = F.getSingleOp(lex, lex__k)
      node = F.newNode()
      if (G.Err ~= 0) then
        do return (nil) end
      end
      node.left = left
      node.right = right
      node.opcode = opcode
      left = node
    end
  end
  if (neg ~= 0) then
    node = F.newNode()
    if (G.Err ~= 0) then
      do return (nil) end
    end
    node.left = left
    node.right = (nil)
    node.opcode = 9
    left = node
  end
  do return left end
end

-- mathexpr.c:442
F.getTree = function()
  local lex = {0}
  local opcode = 0
  local left = nil
  local right = nil
  local node = nil
  left = F.getOp(lex, 1)
  do
    while true do
      do
        if ((lex[1] == 0) or (lex[1] == 2)) then
          if (lex[1] == 2) then
            G.Bc = G.Bc - 1
          end
          break
        end
        if ((lex[1] ~= 3) and (lex[1] ~= 4)) then
          G.Err = 1
          break
        end
        opcode = lex[1]
        right = F.getOp(lex, 1)
        node = F.newNode()
        if (G.Err ~= 0) then
          break
        end
        node.left = left
        node.right = right
        node.opcode = opcode
        left = node
      end
    end
  end
  do return left end
end

-- mathexpr.c:479
F.traverseTree = function(tree, expr, expr__k)
  local node = nil
  if (tree == (nil)) then
    do return end
  end
  F.traverseTree(tree.left, expr, expr__k)
  F.traverseTree(tree.right, expr, expr__k)
  node = T.MathExpr()
  if (node ~= nil) then
    node.fvalue = tree.fvalue
    node.opcode = tree.opcode
    node.ivar = tree.ivar
    node.next_ = (nil)
    node.prev = (expr[expr__k])
  end
  if (expr[expr__k] ~= nil) then
    ;(expr[expr__k]).next_ = node
  end
  expr[expr__k] = node
end

-- mathexpr.c:501
F.deleteTree = function(tree)
  if (tree ~= nil) then
    if (tree.left ~= nil) then
      F.deleteTree(tree.left)
    end
    if (tree.right ~= nil) then
      F.deleteTree(tree.right)
    end
    local _ = nil
  end
end

-- mathexpr.c:516
F.mathexpr_eval = function(expr, getVariableValue)
  local ExprStack = R.fill(1024, 0.0)
  local node = expr
  local r1 = 0.0
  local r2 = 0.0
  local stackindex = 0
  ExprStack[0] = 0.0
  while ((node ~= (nil)) and (stackindex >= 0)) do
    do
      do
        local __sw1 = node.opcode
        if __sw1 < 16 then
          if __sw1 < 9 then
            if __sw1 < 6 then
              if __sw1 == 3 then goto case3
              elseif __sw1 == 4 then goto case4
              elseif __sw1 == 5 then goto case5
              end
            else
              if __sw1 == 6 then goto case6
              elseif __sw1 == 7 then goto case7
              elseif __sw1 == 8 then goto case8
              end
            end
          else
            if __sw1 < 12 then
              if __sw1 == 9 then goto case9
              elseif __sw1 == 10 then goto case10
              elseif __sw1 == 11 then goto case11
              end
            else
              if __sw1 < 14 then
                if __sw1 == 12 then goto case12
                elseif __sw1 == 13 then goto case13
                end
              else
                if __sw1 == 14 then goto case14
                elseif __sw1 == 15 then goto case15
                end
              end
            end
          end
        else
          if __sw1 < 23 then
            if __sw1 < 19 then
              if __sw1 == 16 then goto case16
              elseif __sw1 == 17 then goto case17
              elseif __sw1 == 18 then goto case18
              end
            else
              if __sw1 < 21 then
                if __sw1 == 19 then goto case19
                elseif __sw1 == 20 then goto case20
                end
              else
                if __sw1 == 21 then goto case21
                elseif __sw1 == 22 then goto case22
                end
              end
            end
          else
            if __sw1 < 26 then
              if __sw1 == 23 then goto case23
              elseif __sw1 == 24 then goto case24
              elseif __sw1 == 25 then goto case25
              end
            else
              if __sw1 < 28 then
                if __sw1 == 26 then goto case26
                elseif __sw1 == 27 then goto case27
                end
              else
                if __sw1 == 28 then goto case28
                elseif __sw1 == 31 then goto case29
                end
              end
            end
          end
        end
        goto swend2
        ::case3::
        do
          r1 = ExprStack[stackindex]
          stackindex = stackindex - 1
          if (stackindex < 0) then
            goto swend2
          end
          r2 = ExprStack[stackindex]
          ExprStack[stackindex] = (r2 + r1)
          goto swend2
        end
        ::case4::
        do
          r1 = ExprStack[stackindex]
          stackindex = stackindex - 1
          if (stackindex < 0) then
            goto swend2
          end
          r2 = ExprStack[stackindex]
          ExprStack[stackindex] = (r2 - r1)
          goto swend2
        end
        ::case5::
        do
          r1 = ExprStack[stackindex]
          stackindex = stackindex - 1
          if (stackindex < 0) then
            goto swend2
          end
          r2 = ExprStack[stackindex]
          ExprStack[stackindex] = (r2 * r1)
          goto swend2
        end
        ::case6::
        do
          r1 = ExprStack[stackindex]
          stackindex = stackindex - 1
          if (stackindex < 0) then
            goto swend2
          end
          r2 = ExprStack[stackindex]
          ExprStack[stackindex] = (r2 / r1)
          goto swend2
        end
        ::case7::
        do
          stackindex = stackindex + 1
          if (stackindex >= 1024) then
            goto swend2
          end
          ExprStack[stackindex] = node.fvalue
          goto swend2
        end
        ::case8::
        do
          if (getVariableValue ~= (nil)) then
            r1 = getVariableValue(node.ivar)
          else
            r1 = 0.0
          end
          stackindex = stackindex + 1
          if (stackindex >= 1024) then
            goto swend2
          end
          ExprStack[stackindex] = r1
          goto swend2
        end
        ::case9::
        do
          ExprStack[stackindex] = (-ExprStack[stackindex])
          goto swend2
        end
        ::case10::
        do
          r1 = ExprStack[stackindex]
          r2 = m_cos(r1)
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case11::
        do
          r1 = ExprStack[stackindex]
          r2 = m_sin(r1)
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case12::
        do
          r1 = ExprStack[stackindex]
          r2 = m_tan(r1)
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case13::
        do
          r1 = ExprStack[stackindex]
          if (r1 == 0.0) then
            r2 = 0.0
          else
            r2 = (1.0 / m_tan(r1))
          end
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case14::
        do
          r1 = ExprStack[stackindex]
          r2 = m_abs(r1)
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case15::
        do
          r1 = ExprStack[stackindex]
          if (r1 < 0.0) then
            r2 = (-1.0)
          elseif (r1 > 0.0) then
            r2 = 1.0
          else
            r2 = 0.0
          end
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case16::
        do
          r1 = ExprStack[stackindex]
          if (r1 < 0.0) then
            r2 = 0.0
          else
            r2 = m_sqrt(r1)
          end
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case17::
        do
          r1 = ExprStack[stackindex]
          if (r1 <= 0.0) then
            r2 = 0.0
          else
            r2 = R.log(r1)
          end
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case18::
        do
          r1 = ExprStack[stackindex]
          r2 = m_exp(r1)
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case19::
        do
          r1 = ExprStack[stackindex]
          r2 = m_asin(r1)
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case20::
        do
          r1 = ExprStack[stackindex]
          r2 = m_acos(r1)
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case21::
        do
          r1 = ExprStack[stackindex]
          r2 = R.atan(r1)
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case22::
        do
          r1 = ExprStack[stackindex]
          r2 = (1.5707963267948966 - R.atan(r1))
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case23::
        do
          r1 = ExprStack[stackindex]
          r2 = (((m_exp(r1) - m_exp((-r1)))) / 2.0)
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case24::
        do
          r1 = ExprStack[stackindex]
          r2 = (((m_exp(r1) + m_exp((-r1)))) / 2.0)
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case25::
        do
          r1 = ExprStack[stackindex]
          r2 = (((m_exp(r1) - m_exp((-r1)))) / ((m_exp(r1) + m_exp((-r1)))))
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case26::
        do
          r1 = ExprStack[stackindex]
          r2 = (((m_exp(r1) + m_exp((-r1)))) / ((m_exp(r1) - m_exp((-r1)))))
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case27::
        do
          r1 = ExprStack[stackindex]
          if (r1 == 0.0) then
            r2 = 0.0
          else
            r2 = R.log10(r1)
          end
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case28::
        do
          r1 = ExprStack[stackindex]
          if (r1 <= 0.0) then
            r2 = 0.0
          else
            r2 = 1.0
          end
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::case29::
        do
          r1 = ExprStack[stackindex]
          stackindex = stackindex - 1
          if (stackindex < 0) then
            goto swend2
          end
          r2 = ExprStack[stackindex]
          if (r2 <= 0.0) then
            r2 = 0.0
          else
            r2 = R.pow(r2, r1)
          end
          ExprStack[stackindex] = r2
          goto swend2
        end
        ::swend2::
      end
      node = node.next_
    end
  end
  if (stackindex >= 0) then
    r1 = ExprStack[stackindex]
  else
    r1 = 0.0
  end
  if (r1 ~= r1) then
    r1 = 0.0
  end
  do return r1 end
end

-- mathexpr.c:735
F.mathexpr_delete = function(expr)
  if (expr ~= nil) then
    F.mathexpr_delete(expr.next_)
  end
  local _ = nil
end

-- mathexpr.c:743
F.mathexpr_create = function(formula, getVar)
  local tree = nil
  local expr = {(nil)}
  local result = (nil)
  G.mathexpr_getVariableIndex = getVar
  G.Err = 0
  G.PrevLex = 0
  G.CurLex = 0
  G.S_ = formula
  G.Len = R.i32(R.strlen(G.S_))
  G.Pos = 0
  G.Bc = 0
  tree = F.getTree()
  if ((G.Bc == 0) and (G.Err == 0)) then
    F.traverseTree(tree, expr, 1)
    while (expr[1] ~= nil) do
      do
        result = expr[1]
        expr[1] = expr[1].prev
      end
    end
  end
  F.deleteTree(tree)
  do return result end
end

