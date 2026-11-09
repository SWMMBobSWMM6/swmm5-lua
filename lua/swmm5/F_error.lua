-- Generated from EPA SWMM 5.2.4 (error.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local _ENV = R.strict

G.ErrString = R.buf(256)

-- error.c:30
F.error_getMsg = function(errCode, msg)
  do
    local __sw1 = errCode
    if __sw1 < 213 then
      if __sw1 < 145 then
        if __sw1 < 119 then
          if __sw1 < 110 then
            if __sw1 < 107 then
              if __sw1 == 101 then goto case2
              elseif __sw1 == 103 then goto case3
              elseif __sw1 == 105 then goto case4
              end
            else
              if __sw1 == 107 then goto case5
              elseif __sw1 == 108 then goto case6
              elseif __sw1 == 109 then goto case7
              end
            end
          else
            if __sw1 < 113 then
              if __sw1 == 110 then goto case8
              elseif __sw1 == 111 then goto case9
              elseif __sw1 == 112 then goto case10
              end
            else
              if __sw1 < 115 then
                if __sw1 == 113 then goto case11
                elseif __sw1 == 114 then goto case12
                end
              else
                if __sw1 == 115 then goto case13
                elseif __sw1 == 117 then goto case14
                end
              end
            end
          end
        else
          if __sw1 < 136 then
            if __sw1 < 131 then
              if __sw1 == 119 then goto case15
              elseif __sw1 == 121 then goto case16
              elseif __sw1 == 122 then goto case17
              end
            else
              if __sw1 < 134 then
                if __sw1 == 131 then goto case18
                elseif __sw1 == 133 then goto case19
                end
              else
                if __sw1 == 134 then goto case20
                elseif __sw1 == 135 then goto case21
                end
              end
            end
          else
            if __sw1 < 139 then
              if __sw1 == 136 then goto case22
              elseif __sw1 == 137 then goto case23
              elseif __sw1 == 138 then goto case24
              end
            else
              if __sw1 < 141 then
                if __sw1 == 139 then goto case25
                elseif __sw1 == 140 then goto case26
                end
              else
                if __sw1 == 141 then goto case27
                elseif __sw1 == 143 then goto case28
                end
              end
            end
          end
        end
      else
        if __sw1 < 184 then
          if __sw1 < 159 then
            if __sw1 < 155 then
              if __sw1 == 145 then goto case29
              elseif __sw1 == 151 then goto case30
              elseif __sw1 == 153 then goto case31
              end
            else
              if __sw1 < 157 then
                if __sw1 == 155 then goto case32
                elseif __sw1 == 156 then goto case33
                end
              else
                if __sw1 == 157 then goto case34
                elseif __sw1 == 158 then goto case35
                end
              end
            end
          else
            if __sw1 < 173 then
              if __sw1 == 159 then goto case36
              elseif __sw1 == 161 then goto case37
              elseif __sw1 == 171 then goto case38
              end
            else
              if __sw1 < 182 then
                if __sw1 == 173 then goto case39
                elseif __sw1 == 181 then goto case40
                end
              else
                if __sw1 == 182 then goto case41
                elseif __sw1 == 183 then goto case42
                end
              end
            end
          end
        else
          if __sw1 < 200 then
            if __sw1 < 188 then
              if __sw1 == 184 then goto case43
              elseif __sw1 == 185 then goto case44
              elseif __sw1 == 187 then goto case45
              end
            else
              if __sw1 < 193 then
                if __sw1 == 188 then goto case46
                elseif __sw1 == 191 then goto case47
                end
              else
                if __sw1 == 193 then goto case48
                elseif __sw1 == 195 then goto case49
                end
              end
            end
          else
            if __sw1 < 205 then
              if __sw1 == 200 then goto case50
              elseif __sw1 == 201 then goto case51
              elseif __sw1 == 203 then goto case52
              end
            else
              if __sw1 < 209 then
                if __sw1 == 205 then goto case53
                elseif __sw1 == 207 then goto case54
                end
              else
                if __sw1 == 209 then goto case55
                elseif __sw1 == 211 then goto case56
                end
              end
            end
          end
        end
      end
    else
      if __sw1 < 327 then
        if __sw1 < 305 then
          if __sw1 < 227 then
            if __sw1 < 221 then
              if __sw1 == 213 then goto case57
              elseif __sw1 == 217 then goto case58
              elseif __sw1 == 219 then goto case59
              end
            else
              if __sw1 == 221 then goto case60
              elseif __sw1 == 223 then goto case61
              elseif __sw1 == 225 then goto case62
              end
            end
          else
            if __sw1 < 233 then
              if __sw1 == 227 then goto case63
              elseif __sw1 == 229 then goto case64
              elseif __sw1 == 231 then goto case65
              end
            else
              if __sw1 < 301 then
                if __sw1 == 233 then goto case66
                elseif __sw1 == 235 then goto case67
                end
              else
                if __sw1 == 301 then goto case68
                elseif __sw1 == 303 then goto case69
                end
              end
            end
          end
        else
          if __sw1 < 317 then
            if __sw1 < 309 then
              if __sw1 == 305 then goto case70
              elseif __sw1 == 307 then goto case71
              elseif __sw1 == 308 then goto case72
              end
            else
              if __sw1 < 313 then
                if __sw1 == 309 then goto case73
                elseif __sw1 == 311 then goto case74
                end
              else
                if __sw1 == 313 then goto case75
                elseif __sw1 == 315 then goto case76
                end
              end
            end
          else
            if __sw1 < 320 then
              if __sw1 == 317 then goto case77
              elseif __sw1 == 318 then goto case78
              elseif __sw1 == 319 then goto case79
              end
            else
              if __sw1 < 323 then
                if __sw1 == 320 then goto case80
                elseif __sw1 == 321 then goto case81
                end
              else
                if __sw1 == 323 then goto case82
                elseif __sw1 == 325 then goto case83
                end
              end
            end
          end
        end
      else
        if __sw1 < 355 then
          if __sw1 < 338 then
            if __sw1 < 333 then
              if __sw1 == 327 then goto case84
              elseif __sw1 == 329 then goto case85
              elseif __sw1 == 331 then goto case86
              end
            else
              if __sw1 < 336 then
                if __sw1 == 333 then goto case87
                elseif __sw1 == 335 then goto case88
                end
              else
                if __sw1 == 336 then goto case89
                elseif __sw1 == 337 then goto case90
                end
              end
            end
          else
            if __sw1 < 343 then
              if __sw1 == 338 then goto case91
              elseif __sw1 == 339 then goto case92
              elseif __sw1 == 341 then goto case93
              end
            else
              if __sw1 < 351 then
                if __sw1 == 343 then goto case94
                elseif __sw1 == 345 then goto case95
                end
              else
                if __sw1 == 351 then goto case96
                elseif __sw1 == 353 then goto case97
                end
              end
            end
          end
        else
          if __sw1 < 503 then
            if __sw1 < 363 then
              if __sw1 == 355 then goto case98
              elseif __sw1 == 357 then goto case99
              elseif __sw1 == 361 then goto case100
              end
            else
              if __sw1 < 501 then
                if __sw1 == 363 then goto case101
                elseif __sw1 == 500 then goto case102
                end
              else
                if __sw1 == 501 then goto case103
                elseif __sw1 == 502 then goto case104
                end
              end
            end
          else
            if __sw1 < 506 then
              if __sw1 == 503 then goto case105
              elseif __sw1 == 504 then goto case106
              elseif __sw1 == 505 then goto case107
              end
            else
              if __sw1 < 508 then
                if __sw1 == 506 then goto case108
                elseif __sw1 == 507 then goto case109
                end
              else
                if __sw1 == 508 then goto case110
                elseif __sw1 == 509 then goto case111
                end
              end
            end
          end
        end
      end
    end
    goto case112
    ::case2::
    do
      R.strcpy(msg, S[46])
      goto swend1
    end
    ::case3::
    do
      R.strcpy(msg, S[47])
      goto swend1
    end
    ::case4::
    do
      R.strcpy(msg, S[48])
      goto swend1
    end
    ::case5::
    do
      R.strcpy(msg, S[49])
      goto swend1
    end
    ::case6::
    do
      R.strcpy(msg, S[50])
      goto swend1
    end
    ::case7::
    do
      R.strcpy(msg, S[51])
      goto swend1
    end
    ::case8::
    do
      R.strcpy(msg, S[52])
      goto swend1
    end
    ::case9::
    do
      R.strcpy(msg, S[53])
      goto swend1
    end
    ::case10::
    do
      R.strcpy(msg, S[54])
      goto swend1
    end
    ::case11::
    do
      R.strcpy(msg, S[55])
      goto swend1
    end
    ::case12::
    do
      R.strcpy(msg, S[56])
      goto swend1
    end
    ::case13::
    do
      R.strcpy(msg, S[57])
      goto swend1
    end
    ::case14::
    do
      R.strcpy(msg, S[58])
      goto swend1
    end
    ::case15::
    do
      R.strcpy(msg, S[59])
      goto swend1
    end
    ::case16::
    do
      R.strcpy(msg, S[60])
      goto swend1
    end
    ::case17::
    do
      R.strcpy(msg, S[61])
      goto swend1
    end
    ::case18::
    do
      R.strcpy(msg, S[62])
      goto swend1
    end
    ::case19::
    do
      R.strcpy(msg, S[63])
      goto swend1
    end
    ::case20::
    do
      R.strcpy(msg, S[64])
      goto swend1
    end
    ::case21::
    do
      R.strcpy(msg, S[65])
      goto swend1
    end
    ::case22::
    do
      R.strcpy(msg, S[66])
      goto swend1
    end
    ::case23::
    do
      R.strcpy(msg, S[67])
      goto swend1
    end
    ::case24::
    do
      R.strcpy(msg, S[68])
      goto swend1
    end
    ::case25::
    do
      R.strcpy(msg, S[69])
      goto swend1
    end
    ::case26::
    do
      R.strcpy(msg, S[70])
      goto swend1
    end
    ::case27::
    do
      R.strcpy(msg, S[71])
      goto swend1
    end
    ::case28::
    do
      R.strcpy(msg, S[72])
      goto swend1
    end
    ::case29::
    do
      R.strcpy(msg, S[73])
      goto swend1
    end
    ::case30::
    do
      R.strcpy(msg, S[74])
      goto swend1
    end
    ::case31::
    do
      R.strcpy(msg, S[75])
      goto swend1
    end
    ::case32::
    do
      R.strcpy(msg, S[76])
      goto swend1
    end
    ::case33::
    do
      R.strcpy(msg, S[77])
      goto swend1
    end
    ::case34::
    do
      R.strcpy(msg, S[78])
      goto swend1
    end
    ::case35::
    do
      R.strcpy(msg, S[79])
      goto swend1
    end
    ::case36::
    do
      R.strcpy(msg, S[80])
      goto swend1
    end
    ::case37::
    do
      R.strcpy(msg, S[81])
      goto swend1
    end
    ::case38::
    do
      R.strcpy(msg, S[82])
      goto swend1
    end
    ::case39::
    do
      R.strcpy(msg, S[83])
      goto swend1
    end
    ::case40::
    do
      R.strcpy(msg, S[84])
      goto swend1
    end
    ::case41::
    do
      R.strcpy(msg, S[85])
      goto swend1
    end
    ::case42::
    do
      R.strcpy(msg, S[86])
      goto swend1
    end
    ::case43::
    do
      R.strcpy(msg, S[87])
      goto swend1
    end
    ::case44::
    do
      R.strcpy(msg, S[88])
      goto swend1
    end
    ::case45::
    do
      R.strcpy(msg, S[89])
      goto swend1
    end
    ::case46::
    do
      R.strcpy(msg, S[90])
      goto swend1
    end
    ::case47::
    do
      R.strcpy(msg, S[91])
      goto swend1
    end
    ::case48::
    do
      R.strcpy(msg, S[92])
      goto swend1
    end
    ::case49::
    do
      R.strcpy(msg, S[93])
      goto swend1
    end
    ::case50::
    do
      R.strcpy(msg, S[94])
      goto swend1
    end
    ::case51::
    do
      R.strcpy(msg, S[95])
      goto swend1
    end
    ::case52::
    do
      R.strcpy(msg, S[96])
      goto swend1
    end
    ::case53::
    do
      R.strcpy(msg, S[97])
      goto swend1
    end
    ::case54::
    do
      R.strcpy(msg, S[98])
      goto swend1
    end
    ::case55::
    do
      R.strcpy(msg, S[99])
      goto swend1
    end
    ::case56::
    do
      R.strcpy(msg, S[100])
      goto swend1
    end
    ::case57::
    do
      R.strcpy(msg, S[101])
      goto swend1
    end
    ::case58::
    do
      R.strcpy(msg, S[102])
      goto swend1
    end
    ::case59::
    do
      R.strcpy(msg, S[103])
      goto swend1
    end
    ::case60::
    do
      R.strcpy(msg, S[104])
      goto swend1
    end
    ::case61::
    do
      R.strcpy(msg, S[105])
      goto swend1
    end
    ::case62::
    do
      R.strcpy(msg, S[106])
      goto swend1
    end
    ::case63::
    do
      R.strcpy(msg, S[107])
      goto swend1
    end
    ::case64::
    do
      R.strcpy(msg, S[108])
      goto swend1
    end
    ::case65::
    do
      R.strcpy(msg, S[109])
      goto swend1
    end
    ::case66::
    do
      R.strcpy(msg, S[110])
      goto swend1
    end
    ::case67::
    do
      R.strcpy(msg, S[111])
      goto swend1
    end
    ::case68::
    do
      R.strcpy(msg, S[112])
      goto swend1
    end
    ::case69::
    do
      R.strcpy(msg, S[113])
      goto swend1
    end
    ::case70::
    do
      R.strcpy(msg, S[114])
      goto swend1
    end
    ::case71::
    do
      R.strcpy(msg, S[115])
      goto swend1
    end
    ::case72::
    do
      R.strcpy(msg, S[116])
      goto swend1
    end
    ::case73::
    do
      R.strcpy(msg, S[117])
      goto swend1
    end
    ::case74::
    do
      R.strcpy(msg, S[118])
      goto swend1
    end
    ::case75::
    do
      R.strcpy(msg, S[119])
      goto swend1
    end
    ::case76::
    do
      R.strcpy(msg, S[120])
      goto swend1
    end
    ::case77::
    do
      R.strcpy(msg, S[121])
      goto swend1
    end
    ::case78::
    do
      R.strcpy(msg, S[122])
      goto swend1
    end
    ::case79::
    do
      R.strcpy(msg, S[123])
      goto swend1
    end
    ::case80::
    do
      R.strcpy(msg, S[124])
      goto swend1
    end
    ::case81::
    do
      R.strcpy(msg, S[125])
      goto swend1
    end
    ::case82::
    do
      R.strcpy(msg, S[126])
      goto swend1
    end
    ::case83::
    do
      R.strcpy(msg, S[127])
      goto swend1
    end
    ::case84::
    do
      R.strcpy(msg, S[128])
      goto swend1
    end
    ::case85::
    do
      R.strcpy(msg, S[129])
      goto swend1
    end
    ::case86::
    do
      R.strcpy(msg, S[130])
      goto swend1
    end
    ::case87::
    do
      R.strcpy(msg, S[131])
      goto swend1
    end
    ::case88::
    do
      R.strcpy(msg, S[132])
      goto swend1
    end
    ::case89::
    do
      R.strcpy(msg, S[133])
      goto swend1
    end
    ::case90::
    do
      R.strcpy(msg, S[134])
      goto swend1
    end
    ::case91::
    do
      R.strcpy(msg, S[135])
      goto swend1
    end
    ::case92::
    do
      R.strcpy(msg, S[136])
      goto swend1
    end
    ::case93::
    do
      R.strcpy(msg, S[137])
      goto swend1
    end
    ::case94::
    do
      R.strcpy(msg, S[138])
      goto swend1
    end
    ::case95::
    do
      R.strcpy(msg, S[139])
      goto swend1
    end
    ::case96::
    do
      R.strcpy(msg, S[140])
      goto swend1
    end
    ::case97::
    do
      R.strcpy(msg, S[141])
      goto swend1
    end
    ::case98::
    do
      R.strcpy(msg, S[142])
      goto swend1
    end
    ::case99::
    do
      R.strcpy(msg, S[143])
      goto swend1
    end
    ::case100::
    do
      R.strcpy(msg, S[144])
      goto swend1
    end
    ::case101::
    do
      R.strcpy(msg, S[145])
      goto swend1
    end
    ::case102::
    do
      R.strcpy(msg, S[146])
      goto swend1
    end
    ::case103::
    do
      R.strcpy(msg, S[147])
      goto swend1
    end
    ::case104::
    do
      R.strcpy(msg, S[148])
      goto swend1
    end
    ::case105::
    do
      R.strcpy(msg, S[149])
      goto swend1
    end
    ::case106::
    do
      R.strcpy(msg, S[150])
      goto swend1
    end
    ::case107::
    do
      R.strcpy(msg, S[151])
      goto swend1
    end
    ::case108::
    do
      R.strcpy(msg, S[152])
      goto swend1
    end
    ::case109::
    do
      R.strcpy(msg, S[153])
      goto swend1
    end
    ::case110::
    do
      R.strcpy(msg, S[154])
      goto swend1
    end
    ::case111::
    do
      R.strcpy(msg, S[155])
      goto swend1
    end
    ::case112::
    do
      R.strcpy(msg, S[0])
    end
    ::swend1::
  end
  do return (msg) end
end

-- error.c:45
F.error_setInpError = function(errcode, s)
  R.strcpy(G.ErrString, s)
  do return errcode end
end

