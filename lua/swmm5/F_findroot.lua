-- Generated from EPA SWMM 5.2.4 (findroot.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local _ENV = R.strict


-- findroot.c:20
F.findroot_Newton = function(x1, x2, rts, rts__k, xacc, func, p)
  local j = 0
  local n = 0
  local df = {0.0}
  local dx = 0.0
  local dxold = 0.0
  local f = {0.0}
  local x = 0.0
  local temp = 0.0
  local xhi = 0.0
  local xlo = 0.0
  x = rts[rts__k]
  xlo = x1
  xhi = x2
  dxold = m_abs((x2 - x1))
  dx = dxold
  func(x, f, 1, df, 1, p)
  n = n + 1
  do
    j = 1
    while (j <= 60) do
      do
        if (((((((((x - xhi)) * df[1]) - f[1])) * (((((x - xlo)) * df[1]) - f[1]))) >= 0.0) or ((m_abs((2.0 * f[1])) > m_abs((dxold * df[1])))))) then
          dxold = dx
          dx = (0.5 * ((xhi - xlo)))
          x = (xlo + dx)
          if (xlo == x) then
            break
          end
        else
          dxold = dx
          dx = (f[1] / df[1])
          temp = x
          x = (x - dx)
          if (temp == x) then
            break
          end
        end
        if (m_abs(dx) < xacc) then
          break
        end
        func(x, f, 1, df, 1, p)
        n = n + 1
        if (f[1] < 0.0) then
          xlo = x
        else
          xhi = x
        end
      end
      j = j + 1
    end
  end
  rts[rts__k] = x
  if (n <= 60) then
    do return n end
  else
    do return 0 end
  end
end

-- findroot.c:91
F.findroot_Ridder = function(x1, x2, xacc, func, p)
  local j = 0
  local ans = 0.0
  local fhi = 0.0
  local flo = 0.0
  local fm = 0.0
  local fnew = 0.0
  local s = 0.0
  local xhi = 0.0
  local xlo = 0.0
  local xm = 0.0
  local xnew = 0.0
  flo = func(x1, p)
  fhi = func(x2, p)
  if (flo == 0.0) then
    do return x1 end
  end
  if (fhi == 0.0) then
    do return x2 end
  end
  ans = (0.5 * ((x1 + x2)))
  if ((((flo > 0.0) and (fhi < 0.0))) or (((flo < 0.0) and (fhi > 0.0)))) then
    xlo = x1
    xhi = x2
    do
      j = 1
      while (j <= 60) do
        do
          xm = (0.5 * ((xlo + xhi)))
          fm = func(xm, p)
          s = m_sqrt(((fm * fm) - (flo * fhi)))
          if (s == 0.0) then
            do return ans end
          end
          xnew = (xm + (((xm - xlo)) * ((((((flo >= fhi) and 1.0 or (-1.0))) * fm) / s))))
          if (m_abs((xnew - ans)) <= xacc) then
            break
          end
          ans = xnew
          fnew = func(ans, p)
          if (((((fnew) >= 0.0) and m_abs(fm) or (-(m_abs(fm))))) ~= fm) then
            xlo = xm
            flo = fm
            xhi = ans
            fhi = fnew
          elseif (((((fnew) >= 0.0) and m_abs(flo) or (-(m_abs(flo))))) ~= flo) then
            xhi = ans
            fhi = fnew
          elseif (((((fnew) >= 0.0) and m_abs(fhi) or (-(m_abs(fhi))))) ~= fhi) then
            xlo = ans
            flo = fnew
          else
            do return ans end
          end
          if (m_abs((xhi - xlo)) <= xacc) then
            do return ans end
          end
        end
        j = j + 1
      end
    end
    do return ans end
  end
  do return (-(1e+20)) end
end

