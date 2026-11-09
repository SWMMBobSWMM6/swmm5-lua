-- Generated from EPA SWMM 5.2.4 (inputrpt.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local GAGE <const> = 0
local SUBCATCH <const> = 1
local NODE <const> = 2
local LINK <const> = 3
local POLLUT <const> = 4
local LANDUSE <const> = 5
local LANDAREA <const> = 4
local LENGTH <const> = 3
local JUNCTION <const> = 0
local PUMP <const> = 1
local CONDUIT <const> = 0
local CUSTOM <const> = 23
local IRREGULAR <const> = 22
local STREET_XSECT <const> = 25
local FLOW <const> = 10
local SHAPE <const> = 14
local TRANSECT <const> = 10
local STREET <const> = 16
local _ENV = R.strict


-- inputrpt.c:27
F.inputrpt_writeInput = function()
  local G_Frpt, G_Nobjects, G_Pollut, G_QualUnitsWords, G_Landuse, G_Gage = G.Frpt, G.Nobjects, G.Pollut, G.QualUnitsWords, G.Landuse, G.Gage
  local G_Tseries, G_RainTypeWords, G_Subcatch, G_Node, G_NodeTypeWords, G_Link = G.Tseries, G.RainTypeWords, G.Subcatch, G.Node, G.NodeTypeWords, G.Link
  local G_PumpTypeWords, G_Pump, G_LinkTypeWords, G_Conduit, G_Curve, G_Transect = G.PumpTypeWords, G.Pump, G.LinkTypeWords, G.Conduit, G.Curve, G.Transect
  local G_Street, G_XsectTypeWords, G_Shape = G.Street, G.XsectTypeWords, G.Shape
  local m = 0
  local i = 0
  local k = 0
  local lidCount = 0
  if (G.ErrorCode ~= 0) then
    do return end
  end
  F.report_writeLine((S[0]))
  F.report_writeLine((S[206]))
  F.report_writeLine((S[207]))
  F.report_writeLine((S[206]))
  R.fprintf(G_Frpt.file, S[208], G_Nobjects[GAGE])
  R.fprintf(G_Frpt.file, S[209], G_Nobjects[SUBCATCH])
  R.fprintf(G_Frpt.file, S[210], G_Nobjects[NODE])
  R.fprintf(G_Frpt.file, S[211], G_Nobjects[LINK])
  R.fprintf(G_Frpt.file, S[212], G_Nobjects[POLLUT])
  R.fprintf(G_Frpt.file, S[213], G_Nobjects[LANDUSE])
  if (G_Nobjects[POLLUT] > 0) then
    F.report_writeLine((S[0]))
    F.report_writeLine((S[0]))
    F.report_writeLine((S[214]))
    F.report_writeLine((S[215]))
    F.report_writeLine((S[214]))
    R.fprintf(G_Frpt.file, S[216])
    R.fprintf(G_Frpt.file, S[217])
    R.fprintf(G_Frpt.file, S[218])
    do
      i = 0
      while (i < G_Nobjects[POLLUT]) do
        do
          R.fprintf(G_Frpt.file, S[219], G_Pollut[i].ID, G_QualUnitsWords[G_Pollut[i].units], G_Pollut[i].pptConcen, G_Pollut[i].gwConcen, (G_Pollut[i].kDecay * 86400.0))
          if (G_Pollut[i].coPollut >= 0) then
            R.fprintf(G_Frpt.file, S[220], G_Pollut[G_Pollut[i].coPollut].ID, G_Pollut[i].coFraction)
          end
        end
        i = i + 1
      end
    end
  end
  if (G_Nobjects[LANDUSE] > 0) then
    F.report_writeLine((S[0]))
    F.report_writeLine((S[0]))
    F.report_writeLine((S[221]))
    F.report_writeLine((S[222]))
    F.report_writeLine((S[221]))
    R.fprintf(G_Frpt.file, S[223])
    R.fprintf(G_Frpt.file, S[224])
    R.fprintf(G_Frpt.file, S[225])
    do
      i = 0
      while (i < G_Nobjects[LANDUSE]) do
        do
          R.fprintf(G_Frpt.file, S[226], G_Landuse[i].ID, G_Landuse[i].sweepInterval, G_Landuse[i].sweepRemoval, G_Landuse[i].sweepDays0)
        end
        i = i + 1
      end
    end
  end
  if (G_Nobjects[GAGE] > 0) then
    F.report_writeLine((S[0]))
    F.report_writeLine((S[0]))
    F.report_writeLine((S[227]))
    F.report_writeLine((S[228]))
    F.report_writeLine((S[227]))
    R.fprintf(G_Frpt.file, S[229])
    R.fprintf(G_Frpt.file, S[230])
    R.fprintf(G_Frpt.file, S[231])
    do
      i = 0
      while (i < G_Nobjects[GAGE]) do
        do
          if (G_Gage[i].tSeries >= 0) then
            R.fprintf(G_Frpt.file, S[232], G_Gage[i].ID, G_Tseries[G_Gage[i].tSeries].ID)
            R.fprintf(G_Frpt.file, S[233], G_RainTypeWords[G_Gage[i].rainType], R.idiv((G_Gage[i].rainInterval), 60))
          else
            R.fprintf(G_Frpt.file, S[234], G_Gage[i].ID, G_Gage[i].fname)
          end
        end
        i = i + 1
      end
    end
  end
  if (G_Nobjects[SUBCATCH] > 0) then
    F.report_writeLine((S[0]))
    F.report_writeLine((S[0]))
    F.report_writeLine((S[235]))
    F.report_writeLine((S[236]))
    F.report_writeLine((S[235]))
    R.fprintf(G_Frpt.file, S[237])
    R.fprintf(G_Frpt.file, S[238])
    do
      i = 0
      while (i < G_Nobjects[SUBCATCH]) do
        do
          R.fprintf(G_Frpt.file, S[239], G_Subcatch[i].ID, (G_Subcatch[i].area * F.UCF(LANDAREA)), (G_Subcatch[i].width * F.UCF(LENGTH)), (G_Subcatch[i].fracImperv * 100.0), (G_Subcatch[i].slope * 100.0), G_Gage[G_Subcatch[i].gage].ID)
          if (G_Subcatch[i].outNode >= 0) then
            R.fprintf(G_Frpt.file, S[240], G_Node[G_Subcatch[i].outNode].ID)
          elseif (G_Subcatch[i].outSubcatch >= 0) then
            R.fprintf(G_Frpt.file, S[240], G_Subcatch[G_Subcatch[i].outSubcatch].ID)
          end
          if (G_Subcatch[i].lidArea ~= 0.0) then
            lidCount = lidCount + 1
          end
        end
        i = i + 1
      end
    end
  end
  if (lidCount > 0) then
    F.lid_writeSummary()
  end
  if (G_Nobjects[NODE] > 0) then
    F.report_writeLine((S[0]))
    F.report_writeLine((S[0]))
    F.report_writeLine((S[241]))
    F.report_writeLine((S[242]))
    F.report_writeLine((S[241]))
    R.fprintf(G_Frpt.file, S[243])
    R.fprintf(G_Frpt.file, S[244])
    R.fprintf(G_Frpt.file, S[245])
    do
      i = 0
      while (i < G_Nobjects[NODE]) do
        do
          R.fprintf(G_Frpt.file, S[246], G_Node[i].ID, G_NodeTypeWords[(G_Node[i].type_ - JUNCTION)], (G_Node[i].invertElev * F.UCF(LENGTH)), (G_Node[i].fullDepth * F.UCF(LENGTH)), ((G_Node[i].pondedArea * F.UCF(LENGTH)) * F.UCF(LENGTH)))
          if (((G_Node[i].extInflow ~= nil) or (G_Node[i].dwfInflow ~= nil)) or (G_Node[i].rdiiInflow ~= nil)) then
            R.fprintf(G_Frpt.file, S[247])
          end
        end
        i = i + 1
      end
    end
  end
  if (G_Nobjects[LINK] > 0) then
    F.report_writeLine((S[0]))
    F.report_writeLine((S[0]))
    F.report_writeLine((S[241]))
    F.report_writeLine((S[248]))
    F.report_writeLine((S[241]))
    R.fprintf(G_Frpt.file, S[249])
    R.fprintf(G_Frpt.file, S[250])
    do
      i = 0
      while (i < G_Nobjects[LINK]) do
        do
          if (G_Link[i].direction == 1) then
            R.fprintf(G_Frpt.file, S[251], G_Link[i].ID, G_Node[G_Link[i].node1].ID, G_Node[G_Link[i].node2].ID)
          else
            R.fprintf(G_Frpt.file, S[251], G_Link[i].ID, G_Node[G_Link[i].node2].ID, G_Node[G_Link[i].node1].ID)
          end
          if (G_Link[i].type_ == PUMP) then
            k = G_Link[i].subIndex
            R.fprintf(G_Frpt.file, S[252], G_PumpTypeWords[G_Pump[k].type_])
          else
            R.fprintf(G_Frpt.file, S[253], G_LinkTypeWords[(G_Link[i].type_ - CONDUIT)])
          end
          if (G_Link[i].type_ == CONDUIT) then
            k = G_Link[i].subIndex
            R.fprintf(G_Frpt.file, S[254], (G_Conduit[k].length * F.UCF(LENGTH)), ((G_Conduit[k].slope * 100.0) * (G_Link[i].direction * 1.0)), G_Conduit[k].roughness)
          end
        end
        i = i + 1
      end
    end
    F.report_writeLine((S[0]))
    F.report_writeLine((S[0]))
    F.report_writeLine((S[255]))
    F.report_writeLine((S[256]))
    F.report_writeLine((S[255]))
    R.fprintf(G_Frpt.file, S[257])
    R.fprintf(G_Frpt.file, S[258])
    R.fprintf(G_Frpt.file, S[259])
    do
      i = 0
      while (i < G_Nobjects[LINK]) do
        do
          if (G_Link[i].type_ == CONDUIT) then
            k = G_Link[i].subIndex
            R.fprintf(G_Frpt.file, S[260], G_Link[i].ID)
            if (G_Link[i].xsect.type_ == CUSTOM) then
              R.fprintf(G_Frpt.file, S[261], G_Curve[G_Link[i].xsect.transect].ID)
            elseif (G_Link[i].xsect.type_ == IRREGULAR) then
              R.fprintf(G_Frpt.file, S[261], G_Transect[G_Link[i].xsect.transect].ID)
            elseif (G_Link[i].xsect.type_ == STREET_XSECT) then
              R.fprintf(G_Frpt.file, S[261], G_Street[G_Link[i].xsect.transect].ID)
            else
              R.fprintf(G_Frpt.file, S[261], G_XsectTypeWords[G_Link[i].xsect.type_])
            end
            R.fprintf(G_Frpt.file, S[262], (G_Link[i].xsect.yFull * F.UCF(LENGTH)), ((G_Link[i].xsect.aFull * F.UCF(LENGTH)) * F.UCF(LENGTH)), (G_Link[i].xsect.rFull * F.UCF(LENGTH)), (G_Link[i].xsect.wMax * F.UCF(LENGTH)), G_Conduit[k].barrels, (G_Link[i].qFull * F.UCF(FLOW)))
          end
        end
        i = i + 1
      end
    end
  end
  if (G_Nobjects[SHAPE] > 0) then
    F.report_writeLine((S[0]))
    F.report_writeLine((S[0]))
    F.report_writeLine((S[206]))
    F.report_writeLine((S[263]))
    F.report_writeLine((S[206]))
    do
      i = 0
      while (i < G_Nobjects[SHAPE]) do
        do
          k = G_Shape[i].curve
          R.fprintf(G_Frpt.file, S[264], G_Curve[k].ID)
          R.fprintf(G_Frpt.file, S[265])
          do
            m = 1
            while (m < 51) do
              do
                if (m_fmod(m, 5) == 1) then
                  R.fprintf(G_Frpt.file, S[266])
                end
                R.fprintf(G_Frpt.file, S[267], G_Shape[i].areaTbl[m])
              end
              m = m + 1
            end
          end
          R.fprintf(G_Frpt.file, S[268])
          do
            m = 1
            while (m < 51) do
              do
                if (m_fmod(m, 5) == 1) then
                  R.fprintf(G_Frpt.file, S[266])
                end
                R.fprintf(G_Frpt.file, S[267], G_Shape[i].hradTbl[m])
              end
              m = m + 1
            end
          end
          R.fprintf(G_Frpt.file, S[269])
          do
            m = 1
            while (m < 51) do
              do
                if (m_fmod(m, 5) == 1) then
                  R.fprintf(G_Frpt.file, S[266])
                end
                R.fprintf(G_Frpt.file, S[267], G_Shape[i].widthTbl[m])
              end
              m = m + 1
            end
          end
        end
        i = i + 1
      end
    end
  end
  if (G_Nobjects[TRANSECT] > 0) then
    F.report_writeLine((S[0]))
    F.report_writeLine((S[0]))
    F.report_writeLine((S[227]))
    F.report_writeLine((S[270]))
    F.report_writeLine((S[227]))
    do
      i = 0
      while (i < G_Nobjects[TRANSECT]) do
        do
          R.fprintf(G_Frpt.file, S[271], G_Transect[i].ID)
          R.fprintf(G_Frpt.file, S[265])
          do
            m = 1
            while (m < 51) do
              do
                if (m_fmod(m, 5) == 1) then
                  R.fprintf(G_Frpt.file, S[266])
                end
                R.fprintf(G_Frpt.file, S[267], G_Transect[i].areaTbl[m])
              end
              m = m + 1
            end
          end
          R.fprintf(G_Frpt.file, S[268])
          do
            m = 1
            while (m < 51) do
              do
                if (m_fmod(m, 5) == 1) then
                  R.fprintf(G_Frpt.file, S[266])
                end
                R.fprintf(G_Frpt.file, S[267], G_Transect[i].hradTbl[m])
              end
              m = m + 1
            end
          end
          R.fprintf(G_Frpt.file, S[269])
          do
            m = 1
            while (m < 51) do
              do
                if (m_fmod(m, 5) == 1) then
                  R.fprintf(G_Frpt.file, S[266])
                end
                R.fprintf(G_Frpt.file, S[267], G_Transect[i].widthTbl[m])
              end
              m = m + 1
            end
          end
        end
        i = i + 1
      end
    end
  end
  if (G_Nobjects[STREET] > 0) then
    F.report_writeLine((S[0]))
    F.report_writeLine((S[0]))
    F.report_writeLine((S[272]))
    F.report_writeLine((S[273]))
    F.report_writeLine((S[272]))
    do
      i = 0
      while (i < G_Nobjects[STREET]) do
        do
          R.fprintf(G_Frpt.file, S[274], G_Street[i].ID)
          R.fprintf(G_Frpt.file, S[265])
          do
            m = 1
            while (m < G_Street[i].transect.nTbl) do
              do
                if (m_fmod(m, 5) == 1) then
                  R.fprintf(G_Frpt.file, S[266])
                end
                R.fprintf(G_Frpt.file, S[267], G_Street[i].transect.areaTbl[m])
              end
              m = m + 1
            end
          end
          R.fprintf(G_Frpt.file, S[268])
          do
            m = 1
            while (m < G_Street[i].transect.nTbl) do
              do
                if (m_fmod(m, 5) == 1) then
                  R.fprintf(G_Frpt.file, S[266])
                end
                R.fprintf(G_Frpt.file, S[267], G_Street[i].transect.hradTbl[m])
              end
              m = m + 1
            end
          end
          R.fprintf(G_Frpt.file, S[269])
          do
            m = 1
            while (m < G_Street[i].transect.nTbl) do
              do
                if (m_fmod(m, 5) == 1) then
                  R.fprintf(G_Frpt.file, S[266])
                end
                R.fprintf(G_Frpt.file, S[267], G_Street[i].transect.widthTbl[m])
              end
              m = m + 1
            end
          end
        end
        i = i + 1
      end
    end
  end
  F.report_writeLine((S[0]))
end

