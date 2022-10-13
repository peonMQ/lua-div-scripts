--[[    
    Simple UI Aug. 20, 2022
--]]

-- Required mq for lua 
local mq = require 'mq'

-- GUI variables
local openGUI = true
local shouldDrawGUI = true

-- MQ variables displayed in GUI
local character = {name = "nil", lvl = nil, class = nil, pctHPs = nil, pctMana = nil}
local target = {name = "nil", class = nil, pctHPs = nil, distance = nil}

local function UpdateDisplay()
    character.name = mq.TLO.Me.Name()
    character.lvl = mq.TLO.Me.Level()
    character.class = mq.TLO.Me.Class.ShortName()
    character.pctHPs = mq.TLO.Me.PctHPs()
    character.pctMana = mq.TLO.Me.PctMana()
    target.name = mq.TLO.Target.CleanName() or ''
    target.class = mq.TLO.Target.Class.ShortName() or ''
    target.pctHPs = mq.TLO.Target.PctHPs() or ''
    target.distance = mq.TLO.Target.Distance3D() or ''
    if target.distance ~= '' then 
    target.distance = math.floor(target.distance+.5)
    end
end

-- ImGui main function for drawing UI
local function DrawUI()
    -- Do not do calculations or get data in this function just draw data
    openGUI, shouldDrawGUI = ImGui.Begin('Simple UI', openGUI)
    if shouldDrawGUI then
        -- Character UI display
        ImGui.SetWindowFontScale(1.2)
        ImGui.TextColored(1, .2, .6, 1, character.name.." ")
        ImGui.SameLine()
        ImGui.Text(character.lvl)
        ImGui.SameLine()
        ImGui.Text(character.class)
        ImGui.SetWindowFontScale(1)
        ImGui.TextColored(1, .0, .0, 1, character.pctHPs.." ")
        ImGui.SameLine()
        ImGui.TextColored(0, .8, .2, 1, character.pctMana.." ")
        -- Target UI display 
        ImGui.SetWindowFontScale(1.5)
        ImGui.TextColored(1, .2, .6, 1, target.name.." ")
        ImGui.SameLine()
        ImGui.TextColored(1, .2, .6, 1, target.pctHPs.." ")
        ImGui.SetWindowFontScale(1.0)
        ImGui.TextColored(1, .2, .6, 1, target.class.." ")
        ImGui.SameLine()
        ImGui.TextColored(1, .2, .6, 1, target.distance.." ")
    end
    ImGui.End()
end

-- Actual draw call done 60 times a second
mq.imgui.init('DrawUI', DrawUI)

-- You are in this while loop while you trigger draw calls 
while openGUI do
    -- Call additional functions here and get data here
    UpdateDisplay()
    mq.delay(50)
end