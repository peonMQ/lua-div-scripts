local mq = require 'mq'
local imgui = require 'ImGui'

local DANNET = require 'lib.vs.DANNET'
if DANNET.checkVersion(1,1) == false then mq.exit() end

local TABLE = require 'lib.vs.TABLE'
if TABLE.checkVersion(1,0) == false then mq.exit() end

local OpenUI,ShowUI = true,true
local SwitcherName = 'Switcher'
local SwitcherVersion = '0.3'

local command_line_args = {...}
local first_imgui_frame = true
local peer_list_refreshed = false
local peer_list_last_refreshed = 0
local peer_list = {}
local peer_list_ui = {}
local peer_name_cache = {}
local observer_list = DANNET.newObserverList()

local NAME_QUERY    = 'Me.CleanName'
local LEADER_QUERY  = 'Group.Leader.CleanName'

local function showToolTip(tooltip)
  if tooltip ~= nil and ImGui.IsItemHovered() then
    ImGui.BeginTooltip()
    ImGui.TextUnformatted(tooltip)
    ImGui.EndTooltip()
  end
end

local function getNameIndex(list,name)
  for i,peer in ipairs(list) do
    if peer.name == name then return i end
  end
end

local function getLeaderIndex(list,leader)
  for i,peer in ipairs(list) do
    if peer.leader == leader then return i end
  end
end

function dummyPeerList()
  local index = 1
  local list = {}
  toon = { name='toon'..tostring(index), leader='toon'..tostring(index) }   table.insert(list,toon)  index=index+1
  toon = { name='toon'..tostring(index), leader='toon'..tostring(1) }       table.insert(list,toon)  index=index+1
  toon = { name='toon'..tostring(index), leader='toon'..tostring(1) }       table.insert(list,toon)  index=index+1
  toon = { name='toon'..tostring(index), leader='toon'..tostring(1) }       table.insert(list,toon)  index=index+1
  toon = { name='toon'..tostring(index), leader='toon'..tostring(1) }       table.insert(list,toon)  index=index+1
  toon = { name='toon'..tostring(index), leader='toon'..tostring(1) }       table.insert(list,toon)  index=index+1
  toon = { name='toon'..tostring(index), leader='toon'..tostring(index) }   table.insert(list,toon)  index=index+1
  toon = { name='toon'..tostring(index), leader='toon'..tostring(7) }       table.insert(list,toon)  index=index+1
  toon = { name='toon'..tostring(index), leader='toon'..tostring(7) }       table.insert(list,toon)  index=index+1
  toon = { name='toon'..tostring(index), leader='toon'..tostring(7) }       table.insert(list,toon)  index=index+1
  toon = { name='toon'..tostring(index), leader='toon'..tostring(7) }       table.insert(list,toon)  index=index+1
  toon = { name='toon'..tostring(index), leader='toon'..tostring(7) }       table.insert(list,toon)  index=index+1
  toon = { name='toon'..tostring(index), leader=nil }                       table.insert(list,toon)  index=index+1
  return list
end

local function refreshPeerList()

  if os.difftime( os.time(), peer_list_last_refreshed ) == 0 then
    return
  end
  
  peer_list_last_refreshed = os.time()

  local peer_names = DANNET.getPeers()
  table.sort(peer_names, function(a,b) return a > b end)
  
  for i,peer in ipairs(peer_names) do
    if peer_name_cache[peer] == nil then
      peer_name_cache[peer] = DANNET.query(peer,NAME_QUERY)
    end
  end

  for i,peer in ipairs(peer_names) do
    DANNET.addPeer(observer_list,peer)
  end

  peer_list = {}

  for i,peer in ipairs(peer_names) do
    local name = peer_name_cache[peer]
    if name ~= nil then
      local leader = DANNET.observe(peer,LEADER_QUERY)
      local leader_index = getNameIndex(peer_list,leader)
      if leader_index then
        table.insert( peer_list, leader_index + 1, { name=name, leader=leader } )
      else
        local group_index = getLeaderIndex(peer_list,leader)
        if group_index then
          table.insert( peer_list, group_index, { name=name, leader=leader } )
        else
          table.insert( peer_list, { name=name, leader=leader } )
        end
      end
    end
  end

  peer_list_refreshed = true
  
end

local function updatePeerListUI()

  if peer_list_refreshed == true then
    peer_list_ui = TABLE.copy(peer_list)
    peer_list_refreshed = false
  end
  
end

local function button_LoadAll()

  if ImGui.SmallButton('Load All') then
    local x,y = ImGui.GetWindowPos()
    if x < 0 then x = 0 end
    if y < 0 then y = 0 end
    mq.cmdf('/dge /lua run %s %s %s',SwitcherName,x,y)
  end
  
  showToolTip('Load on all other peers at current position. Will not reload peers if they are already running.')

end

local function button_UnloadAll()

  if ImGui.SmallButton('Unload All') then
    mq.cmdf('/dge /switcher unload')
  end

  showToolTip('Unload on all other peers. Use before "Load All" to reset positions.')

end

local function switchTo(name)
  if name ~= nil and type(name) == 'string' then mq.cmdf('/dex %s /foreground',name) end
end

local function turnTo(name)
  if name ~= nil and type(name) == 'string' then mq.cmdf('/multiline ; /tar PC %s; /face; /if (${Cursor.ID}) /click left target',name) end
end

local function show_Peers()

  updatePeerListUI()

  for i,peer in ipairs(peer_list_ui) do
  
    local pop_style  = 0
    local pop_indent = false
    
    if peer.name == mq.TLO.Me.CleanName() then
      if peer.leader == nil or peer.name == peer.leader then
        ImGui.Separator()
      else
        ImGui.Indent()
        pop_indent = true
      end
      ImGui.PushStyleColor(ImGuiCol.Text,1,1,0,1)
      pop_style = pop_style + 1
      
    elseif peer.leader == nil or peer.name == peer.leader then
      ImGui.Separator()
      if peer.leader == nil then
        ImGui.PushStyleColor(ImGuiCol.Text,0,1,1,1)
      else
        ImGui.PushStyleColor(ImGuiCol.Text,0,1,0,1)
      end
      pop_style = pop_style + 1
      
    else
      ImGui.Indent()
      pop_indent = true
    end

    if peer.name ~= nil and type(peer.name) == 'string' then
      if ImGui.Selectable(peer.name) then switchTo(peer.name) end
      if ImGui.IsItemClicked(ImGuiMouseButton.Right) then turnTo(peer.name) end
    end
    
    if pop_style > 0 then
      ImGui.PopStyleColor(pop_style)
    end
    
    if pop_indent then
      ImGui.Unindent()
    end

    showToolTip('Left-click to switch. Right-click to target.')
    
  end
  
end

local function firstFrameOnly()

  if first_imgui_frame then
  
    first_imgui_frame = false

    if command_line_args[1] ~= nil and command_line_args[2] ~= nil then
      x = tonumber(command_line_args[1])
      y = tonumber(command_line_args[2])
      if x >= 0 and y >= 0 then
        ImGui.SetNextWindowPos( x, y )
      end
    end

  end

end

function SwitcherUI()

  if OpenUI then

    firstFrameOnly()

    ImGui.SetNextWindowBgAlpha(0.8)
    local window_flags = bit32.bor( ImGuiWindowFlags.NoResize, ImGuiWindowFlags.AlwaysAutoResize )
    OpenUI, ShowUI = ImGui.Begin(SwitcherName, OpenUI, window_flags)

    if ShowUI then

      button_LoadAll()

      ImGui.SameLine()
      
      button_UnloadAll()
      
      show_Peers()
      
    end
    
    ImGui.End()
  end
end

local function bind_Switcher(...)
  local args = {...}
  for i, arg in ipairs(args) do
    arg = string.lower(arg)
    if arg == 'unload' then
      OpenUI = false
    end
    return
  end
  print(SwitcherName..', version '..SwitcherVersion)
  print('/switcher unload - unloads Switcher')
  print('/switchto name - switches to name')
  print('/to name - switches to name')
end

local function bind_Switchto(...)
  local args = {...}
  for i, arg in ipairs(args) do
    arg = string.lower(arg)
    for i,name in pairs(peer_name_cache) do
      if string.lower(name) == arg then
        switchTo(name)
        return
      end
    end
    for i,name in pairs(peer_name_cache) do
      if string.find(string.lower(name),arg) ~= nil then
        switchTo(name)
        return
      end
    end
  end
end

local function init()
  DANNET.addQuery(observer_list,LEADER_QUERY)
  mq.bind( '/switcher', bind_Switcher )
  mq.bind( '/switchto', bind_Switchto )
  mq.bind( '/to',       bind_Switchto )
  mq.imgui.init( SwitcherName, SwitcherUI )
end

local function loop()
  while OpenUI and mq.TLO.MacroQuest.GameState() == 'INGAME' do
    refreshPeerList()
    mq.delay( 100 )
  end
end

local function leave()
  DANNET.removeAll(observer_list)
end

init()
loop()
leave()
