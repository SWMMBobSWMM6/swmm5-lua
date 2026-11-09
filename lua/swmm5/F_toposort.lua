-- Generated from EPA SWMM 5.2.4 (toposort.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local LINK <const> = 3
local DW <const> = 4
local NODE <const> = 2
local OUTFALL <const> = 1
local ERR_MEMORY <const> = 101
local DIRECTED <const> = 1
local ERR_LOOP <const> = 131
local UNDIRECTED <const> = 0
local DIVIDER <const> = 3
local CONDUIT <const> = 0
local DUMMY <const> = 0
local PUMP <const> = 1
local IDEAL_PUMP <const> = 5
local ERR_DUMMY_LINK <const> = 134
local _ENV = R.strict

G.InDegree = nil
G.StartPos = nil
G.AdjList = nil
G.Stack = nil
G.First = 0
G.Last = 0
G.Examined = nil
G.InTree = nil
G.LoopLinks = nil
G.LoopLinksLast = 0

-- toposort.c:57
F.toposort_sortLinks = function(sortedLinks)
  local G_Nobjects, G_Node, G_Link = G.Nobjects, G.Node, G.Link
  local i = 0
  local n = 0
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        sortedLinks[i] = i
      end
      i = i + 1
    end
  end
  if (G.RouteModel == DW) then
    F.checkDummyLinks()
    if (G.ErrorCode ~= 0) then
      do return end
    end
    do
      i = 0
      while (i < G_Nobjects[NODE]) do
        do
          G_Node[i].degree = 0
        end
        i = i + 1
      end
    end
    do
      i = 0
      while (i < G_Nobjects[LINK]) do
        do
          n = G_Link[i].node1
          if (G_Link[i].direction < 0) then
            n = G_Link[i].node2
          end
          if (G_Node[n].type_ == OUTFALL) then
            if (G_Link[i].direction < 0) then
              n = G_Link[i].node1
            else
              n = G_Link[i].node2
            end
            G_Node[n].degree = G_Node[n].degree + 1
          else
            G_Node[n].degree = G_Node[n].degree + 1
          end
        end
        i = i + 1
      end
    end
    do return end
  end
  if (G.ErrorCode ~= 0) then
    do return end
  end
  G.InDegree = R.fill(G_Nobjects[NODE], 0)
  G.StartPos = R.fill(G_Nobjects[NODE], 0)
  G.AdjList = R.fill(G_Nobjects[LINK], 0)
  G.Stack = R.fill(G_Nobjects[NODE], 0)
  if ((((G.InDegree == (nil)) or (G.StartPos == (nil))) or (G.AdjList == (nil))) or (G.Stack == (nil))) then
    F.report_writeErrorMsg(ERR_MEMORY, S[0])
  else
    F.createAdjList(DIRECTED)
    F.adjustAdjList()
    do
      i = 0
      while (i < G_Nobjects[NODE]) do
        do
          G.InDegree[i] = 0
        end
        i = i + 1
      end
    end
    do
      i = 0
      while (i < G_Nobjects[LINK]) do
        do
          G.InDegree[G_Link[i].node2] = G.InDegree[G_Link[i].node2] + 1
        end
        i = i + 1
      end
    end
    n = F.topoSort(sortedLinks)
  end
  do
    if (G.InDegree ~= nil) then
      local _ = nil
      G.InDegree = (nil)
    end
  end
  do
    if (G.StartPos ~= nil) then
      local _ = nil
      G.StartPos = (nil)
    end
  end
  do
    if (G.AdjList ~= nil) then
      local _ = nil
      G.AdjList = (nil)
    end
  end
  do
    if (G.Stack ~= nil) then
      local _ = nil
      G.Stack = (nil)
    end
  end
  if ((not (G.ErrorCode ~= 0)) and (n ~= G_Nobjects[LINK])) then
    F.report_writeErrorMsg(ERR_LOOP, S[0])
    F.findCycles()
  end
end

-- toposort.c:142
F.createAdjList = function(listType)
  local G_Nobjects, G_Node, G_Link, G_StartPos, G_AdjList = G.Nobjects, G.Node, G.Link, G.StartPos, G.AdjList
  local i = 0
  local j = 0
  local k = 0
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        G_Node[i].degree = 0
      end
      i = i + 1
    end
  end
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        G_Node[G_Link[j].node1].degree = G_Node[G_Link[j].node1].degree + 1
        if (listType == UNDIRECTED) then
          G_Node[G_Link[j].node2].degree = G_Node[G_Link[j].node2].degree + 1
        end
      end
      j = j + 1
    end
  end
  G_StartPos[0] = 0
  do
    i = 0
    while (i < (G_Nobjects[NODE] - 1)) do
      do
        G_StartPos[(i + 1)] = (G_StartPos[i] + G_Node[i].degree)
        G_Node[i].degree = 0
      end
      i = i + 1
    end
  end
  ;(G_Node[(G_Nobjects[NODE] - 1)]).degree = 0
  do
    j = 0
    while (j < G_Nobjects[LINK]) do
      do
        i = G_Link[j].node1
        k = (G_StartPos[i] + G_Node[i].degree)
        G_AdjList[k] = j
        G_Node[i].degree = G_Node[i].degree + 1
        if (listType == UNDIRECTED) then
          i = G_Link[j].node2
          k = (G_StartPos[i] + G_Node[i].degree)
          G_AdjList[k] = j
          G_Node[i].degree = G_Node[i].degree + 1
        end
      end
      j = j + 1
    end
  end
end

-- toposort.c:193
F.adjustAdjList = function()
  local G_Nobjects, G_Node, G_StartPos, G_AdjList, G_Divider = G.Nobjects, G.Node, G.StartPos, G.AdjList, G.Divider
  local i = 0
  local j = 0
  local k = 0
  local m = 0
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        if (G_Node[i].type_ ~= DIVIDER) then
          goto continue1
        end
        if (G_Node[i].degree ~= 2) then
          goto continue1
        end
        k = G_Node[i].subIndex
        m = G_StartPos[i]
        j = G_AdjList[m]
        if (j == G_Divider[k].link) then
          G_AdjList[m] = G_AdjList[(m + 1)]
          G_AdjList[(m + 1)] = j
        end
      end
      ::continue1::
      i = i + 1
    end
  end
end

-- toposort.c:225
F.topoSort = function(sortedLinks)
  local G_Nobjects, G_InDegree, G_Stack, G_StartPos, G_Node, G_AdjList = G.Nobjects, G.InDegree, G.Stack, G.StartPos, G.Node, G.AdjList
  local G_Link = G.Link
  local i = 0
  local j = 0
  local k = 0
  local n = 0
  local i1 = 0
  local i2 = 0
  local k1 = 0
  local k2 = 0
  G.First = 0
  G.Last = (-1)
  do
    i = 0
    while (i < G_Nobjects[NODE]) do
      do
        if (G_InDegree[i] == 0) then
          G.Last = G.Last + 1
          G_Stack[G.Last] = i
        end
      end
      i = i + 1
    end
  end
  n = 0
  while (G.First <= G.Last) do
    do
      i1 = G_Stack[G.First]
      k1 = G_StartPos[i1]
      k2 = (k1 + G_Node[i1].degree)
      do
        k = k1
        while (k < k2) do
          do
            j = G_AdjList[k]
            sortedLinks[n] = j
            n = n + 1
            i2 = G_Link[j].node2
            G_InDegree[i2] = G_InDegree[i2] - 1
            if (G_InDegree[i2] == 0) then
              G.Last = G.Last + 1
              G_Stack[G.Last] = i2
            end
          end
          k = k + 1
        end
      end
      G.First = G.First + 1
    end
  end
  do return n end
end

-- toposort.c:284
F.findCycles = function()
  local G_Nobjects = G.Nobjects
  local i = 0
  G.AdjList = R.fill((2 * G_Nobjects[LINK]), 0)
  G.StartPos = R.fill(G_Nobjects[NODE], 0)
  G.Stack = R.fill(G_Nobjects[NODE], 0)
  G.Examined = R.buf(G_Nobjects[NODE])
  G.InTree = R.buf(G_Nobjects[LINK])
  G.LoopLinks = R.fill(G_Nobjects[LINK], 0)
  if ((((((G.StartPos ~= nil) and (G.AdjList ~= nil)) and (G.Stack ~= nil)) and (G.Examined ~= nil)) and (G.InTree ~= nil)) and (G.LoopLinks ~= nil)) then
    F.createAdjList(UNDIRECTED)
    do
      i = 0
      while (i < G_Nobjects[NODE]) do
        do
          R.cset(G.Examined, i, 0)
        end
        i = i + 1
      end
    end
    do
      i = 0
      while (i < G_Nobjects[LINK]) do
        do
          R.cset(G.InTree, i, 0)
        end
        i = i + 1
      end
    end
    do
      i = 0
      while (i < G_Nobjects[NODE]) do
        do
          if (G.Examined.b[G.Examined.o + i] ~= 0) then
            goto continue3
          end
          G.Last = (-1)
          F.findSpanningTree(i)
        end
        ::continue3::
        i = i + 1
      end
    end
  end
  do
    if (G.StartPos ~= nil) then
      local _ = nil
      G.StartPos = (nil)
    end
  end
  do
    if (G.AdjList ~= nil) then
      local _ = nil
      G.AdjList = (nil)
    end
  end
  do
    if (G.Stack ~= nil) then
      local _ = nil
      G.Stack = (nil)
    end
  end
  do
    if (G.Examined ~= nil) then
      local _ = nil
      G.Examined = (nil)
    end
  end
  do
    if (G.InTree ~= nil) then
      local _ = nil
      G.InTree = (nil)
    end
  end
  do
    if (G.LoopLinks ~= nil) then
      local _ = nil
      G.LoopLinks = (nil)
    end
  end
end

-- toposort.c:330
F.findSpanningTree = function(startNode)
  local G_StartPos, G_Node, G_AdjList, G_Link, G_InTree, G_Examined = G.StartPos, G.Node, G.AdjList, G.Link, G.InTree, G.Examined
  local G_Stack = G.Stack
  local nextNode = 0
  local j = 0
  local k = 0
  local m = 0
  do
    m = G_StartPos[startNode]
    while (m < (G_StartPos[startNode] + G_Node[startNode].degree)) do
      do
        k = G_AdjList[m]
        if (G_Link[k].node1 == startNode) then
          j = G_Link[k].node2
        else
          j = G_Link[k].node1
        end
        if (G_InTree.b[G_InTree.o + k] == 0) then
          if (G_Examined.b[G_Examined.o + j] ~= 0) then
            R.cset(G_InTree, k, 2)
            F.evalLoop(k)
          else
            R.cset(G_Examined, j, 1)
            G.Last = G.Last + 1
            G_Stack[G.Last] = j
            R.cset(G_InTree, k, 1)
          end
        end
      end
      m = m + 1
    end
  end
  if (G.Last >= 0) then
    nextNode = G_Stack[G.Last]
    G.Last = G.Last - 1
    F.findSpanningTree(nextNode)
  end
end

-- toposort.c:385
F.evalLoop = function(startLink)
  local G_LoopLinks, G_Link, G_Frpt = G.LoopLinks, G.Link, G.Frpt
  local i = 0
  local i1 = 0
  local i2 = 0
  local j = 0
  local kount = 0
  local isCycle = 0
  G.LoopLinksLast = 0
  G_LoopLinks[0] = startLink
  i1 = G_Link[startLink].node1
  i2 = G_Link[startLink].node2
  if (not (F.traceLoop(i1, i2, startLink) ~= 0)) then
    do return end
  end
  isCycle = 1
  j = G_LoopLinks[0]
  i2 = G_Link[j].node2
  do
    i = 1
    while (i <= G.LoopLinksLast) do
      do
        j = G_LoopLinks[i]
        i1 = G_Link[j].node1
        if (i1 == i2) then
          i2 = G_Link[j].node2
        else
          isCycle = 0
          break
        end
      end
      i = i + 1
    end
  end
  if (isCycle ~= 0) then
    kount = 0
    do
      i = 0
      while (i <= G.LoopLinksLast) do
        do
          if (m_fmod(kount, 5) == 0) then
            R.fprintf(G_Frpt.file, S[276])
          end
          kount = kount + 1
          R.fprintf(G_Frpt.file, S[651], G_Link[G_LoopLinks[i]].ID)
          if (i < G.LoopLinksLast) then
            R.fprintf(G_Frpt.file, S[652])
          end
        end
        i = i + 1
      end
    end
  end
end

-- toposort.c:440
F.traceLoop = function(i1, i2, k1)
  local G_StartPos, G_Node, G_AdjList, G_InTree, G_Link, G_LoopLinks = G.StartPos, G.Node, G.AdjList, G.InTree, G.Link, G.LoopLinks
  local j = 0
  local k = 0
  local m = 0
  if (i1 == i2) then
    do return 1 end
  end
  do
    m = G_StartPos[i1]
    while (m < (G_StartPos[i1] + G_Node[i1].degree)) do
      do
        k = G_AdjList[m]
        if ((k == k1) or (G_InTree.b[G_InTree.o + k] ~= 1)) then
          goto continue1
        end
        if (G_Link[k].node1 == i1) then
          j = G_Link[k].node2
        else
          j = G_Link[k].node1
        end
        if (F.traceLoop(j, i2, k) ~= 0) then
          G.LoopLinksLast = G.LoopLinksLast + 1
          G_LoopLinks[G.LoopLinksLast] = k
          do return 1 end
        end
      end
      ::continue1::
      m = m + 1
    end
  end
  do return 0 end
end

-- toposort.c:482
F.checkDummyLinks = function()
  local G_Nobjects, G_Link, G_Pump, G_Node = G.Nobjects, G.Link, G.Pump, G.Node
  local i = 0
  local j = 0
  local marked = nil
  marked = R.fill(G_Nobjects[NODE], 0)
  if (marked == (nil)) then
    F.report_writeErrorMsg(ERR_MEMORY, S[0])
    do return end
  end
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        j = G_Link[i].node2
        if (G_Link[i].direction < 0) then
          j = G_Link[i].node1
        end
        if ((((G_Link[i].type_ == CONDUIT) and (G_Link[i].xsect.type_ == DUMMY))) or (((G_Link[i].type_ == PUMP) and (G_Pump[G_Link[i].subIndex].type_ == IDEAL_PUMP)))) then
          if (marked[j] == 0) then
            marked[j] = 1
          end
        else
          marked[j] = (-1)
        end
      end
      i = i + 1
    end
  end
  do
    i = 0
    while (i < G_Nobjects[LINK]) do
      do
        if ((((G_Link[i].type_ == CONDUIT) and (G_Link[i].xsect.type_ == DUMMY))) or (((G_Link[i].type_ == PUMP) and (G_Pump[G_Link[i].subIndex].type_ == IDEAL_PUMP)))) then
          j = G_Link[i].node1
          if (marked[j] > 0) then
            F.report_writeErrorMsg(ERR_DUMMY_LINK, G_Node[j].ID)
          end
        end
      end
      i = i + 1
    end
  end
  do
    if (marked ~= nil) then
      local _ = nil
      marked = (nil)
    end
  end
end

