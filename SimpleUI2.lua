-- --[[ Simple MQ Lua UI 




-- ]]

-- local mq = require 'mq'
-- require 'ImGui'

-- -- GUI control variables
-- local openGUI = true
-- local shouldDrawGUI = true
-- local terminate = false
-- -- Fade windows like EQ 
-- local isWindowHovered = false
-- local StartAlphaTimer = os.clock()
-- local AlphaTimerSeconds = 3
-- -- Setup ImGui Flag
-- local SetWindowFlags = ImGuiWindowFlags.None

-- -- Window Transparency increases if mouse is not over it after AlphaTimerSeconds
-- function AlphaIfMouseOverWindow()
--     -- This detects mouse over ImGui window with or without button pressed 
--     if ImGui.IsWindowHovered(ImGuiFocusedFlags.RootAndChildWindows) or
--             ImGui.IsAnyItemHovered() and ImGui.IsMouseDown(0) or
--                 ImGui.IsAnyItemHovered() and ImGui.IsMouseReleased(0)
--     then
--         -- Turn transparency off 
--         isWindowHovered = true
--         StartAlphaTimer = os.clock()
--         SetWindowFlags = bit32.bor(ImGuiWindowFlags.NoFocusOnAppearing, ImGuiWindowFlags.NoBringToFrontOnFocus)
        
--     else
--         -- Turn transparency on 
--         if os.clock() - StartAlphaTimer > AlphaTimerSeconds then
--             isWindowHovered = false
--             SetWindowFlags = bit32.bor(ImGuiWindowFlags.NoTitleBar, ImGuiWindowFlags.NoFocusOnAppearing, ImGuiWindowFlags.NoBringToFrontOnFocus)
--         end
--     end
-- end

-- -- Setup buttons in a row setcursor to x, y and offset between buttons
-- function DrawButtonRow(x, y, buttonLength, buttonWidth, offset)
--     ImGui.SetCursorPos(x, y)
--     if ImGui.Button("Stay", buttonLength, buttonWidth) then mq.cmd('/g Stay') end
--     ImGui.SameLine()
--     ImGui.SetCursorPosX(ImGui.GetCursorPosX() + offset)
--     if ImGui.Button("OTM", buttonLength, buttonWidth) then mq.cmd('/g Follow') end
--     ImGui.SameLine()
--     ImGui.SetCursorPosX(ImGui.GetCursorPosX() + offset)
--     if ImGui.Button("Buff", buttonLength, buttonWidth) then mq.cmd("/g Lets Buff") end
-- end

-- -- Setup buttons in a column setcursor to x, y and offset between buttons
-- function DrawButtonColumn(x, y, buttonLength, buttonWidth, offset)
--     ImGui.SetCursorPos(x, y)
--     if ImGui.Button("Button4", buttonLength, buttonWidth) then mq.cmd("/g Button 4") end
--     ImGui.SetCursorPos(x, ImGui.GetCursorPosY() + offset)
--     if ImGui.Button("Button5", buttonLength, buttonWidth) then mq.cmd("/g Button 5") end
--     ImGui.SetCursorPos(x, ImGui.GetCursorPosY() + offset)
--     if ImGui.Button("Button6", buttonLength, buttonWidth) then print("Button 6") end
--     ImGui.SetCursorPos(x, ImGui.GetCursorPosY() + offset)
--     if ImGui.Button("Button7", buttonLength, buttonWidth) then print("Button 7") end
-- end

-- -- Draw progress bar 
-- function DrawProgressBar(x, y, barLength, barWidth, displayName, displayPctHPs)
--     local unitInterval = displayPctHPs/100
--     ImGui.SetCursorPos(x, y)
--     ImGui.ProgressBar(unitInterval, barLength, barWidth, displayName..': '..displayPctHPs..'%')
--     ImGui.PopStyleColor(2)
-- end

-- -- Print target information to screen 
-- function DisplayTargetTextInfo(x, y, fontScale)
--     ImGui.SetCursorPos(x, y)
--     ImGui.SetWindowFontScale(fontScale)
--     ImGui.Text("LVL: "..TargetLevel.." Class: "..TargetShortNameClass.." Dist: "..TargetDistance)
--     ImGui.SetWindowFontScale(1)
-- end

-- -- Get target information 
-- function GetTargetInformation()
--     TargetPctHPs = mq.TLO.Target.PctHPs() or 0
--     TargetDisplayName = mq.TLO.Target.DisplayName() or 'No Target'
--     TargetLevel = mq.TLO.Target.Level() or '00'
--     TargetDistance = mq.TLO.Target.Distance3D.Int() or '00'
--     TargetShortNameClass = mq.TLO.Target.Class.ShortName() or '     '
--     if TargetShortNameClass == "UNKNOWN CLASS" then TargetShortNameClass = "UNK" end
-- end

-- -- Get group members current condition
-- function GetGroupInformation(member)
--     GroupPctHPs = mq.TLO.Group.Member(member).PctHPs() or 0
--     GroupPctMana = mq.TLO.Group.Member(member).PctMana()  or 0
--     GroupMemberName = mq.TLO.Group.Member(member).Name() or 'No Target'
-- end

-- -- Get your current condition 
-- function GetMeInformation()
--     MePctHPs = mq.TLO.Me.PctHPs() or 0
--     MePctMana = mq.TLO.Me.PctMana()  or 0
--     MeName = mq.TLO.Me.Name() or 'NULL'
-- end

-- -- Layout Health and Mana Bars
-- function DrawHealthManaBars(x, y, barLength, barWidth, barIteration, name, pctHPs, pctMana)
--     local unitIntervalHP = pctHPs/100
--     local unitIntervalMana = pctMana/100
--     -- Setup health bars and %
--     ImGui.PushStyleColor(ImGuiCol.PlotHistogram, 1 - unitIntervalHP, unitIntervalHP-.4, .2, 1)
--     ImGui.PushStyleColor(ImGuiCol.Text, 0.8, 0.8, 0.8, 1)
--     DrawProgressBar(x, barIteration*30+y-barIteration*5, barLength, barWidth, name, pctHPs)
--     -- Target player if clicked on 
--     if ImGui.IsItemHovered() and ImGui.IsMouseReleased(0) then
--         mq.cmdf("/target id ${Spawn[=%s].ID}",name)
--     end
--     ImGui.SetWindowFontScale(.4)
--     -- Setup mana bars and %
--     ImGui.PushStyleColor(ImGuiCol.PlotHistogram, .2, .2, unitIntervalMana, 1)
--     ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
--     DrawProgressBar(x, barIteration*30+y+15-barIteration*5, barLength, barWidth*.33, " ", pctMana)
--     -- Target player if clicked on Health or Mana bar 
--     if ImGui.IsItemHovered() and ImGui.IsMouseReleased(0) then
--         mq.cmdf("/target id ${Spawn[=%s].ID}",name)
--     end
--     -- Set window font to 1 so that the next window is normal Text
--     ImGui.SetWindowFontScale(1)
-- end

-- -- Setup targeting information 
-- function LayoutTargetInfo(x, y)
--     GetTargetInformation()
--     -- Setup colors and style 
--     ImGui.PushStyleColor(ImGuiCol.PlotHistogram, 1 - TargetPctHPs/100, TargetPctHPs/100-.5, .5, 1)
--     ImGui.PushStyleColor(ImGuiCol.Text, 0, 0, 0, 1)
--     -- Draw Bar 
--     DrawProgressBar(x, y, 180, 20, TargetDisplayName, TargetPctHPs)
--     DisplayTargetTextInfo(5, 70, 1) 
-- end

-- -- Setup and draw group health bars
-- function LayoutHealthBars(x, y, barLength, barWidth)
--     local GroupNumber = mq.TLO.Group() or 0
--     if GroupNumber ~= 0 then
--         -- Loop to display all group members 
--         for i=0,GroupNumber do
--             GetGroupInformation(i)
--             DrawHealthManaBars(x, 100, barLength, barWidth, i, GroupMemberName, GroupPctHPs, GroupPctMana)
--         end
--         -- If no group display you 
--     else
--         GetMeInformation()
--         DrawHealthManaBars(x, 100, barLength, barWidth, 0, MeName, MePctHPs, MePctMana)
--     end
-- end

-- -- Set Icons and Connect to MQ
-- function LayoutRowIcons(x, y, offset)
--     ImGui.SetCursorPos(x, y)
--     if mq.TLO.Me.Combat() then ImGui.TextColored(1, 0, 0, 1,'\xee\x9f\xbd') else
--         ImGui.TextColored(0, 1, 1, 1,'\xee\x9f\xbd')
--     end
--     ImGui.SameLine()
--     ImGui.SetCursorPos(ImGui.GetCursorPosX() + offset, y)
--     if mq.TLO.Me.Moving() then ImGui.TextColored(1, 0, 0, 1,'\xee\x95\xa6') else
--         ImGui.TextColored(0, 1, 1, 1,'\xee\x95\xa6')
--     end
--     ImGui.SameLine()
--     ImGui.SetCursorPos(ImGui.GetCursorPosX() + offset, y)
--     if mq.TLO.Me.Casting() then ImGui.TextColored(1, 0, 0, 1,'\xef\x8b\x9c') else
--         ImGui.TextColored(0, 1, 1, 1,'\xef\x8b\x9c')
--     end    
--     ImGui.SameLine()
--     ImGui.SetCursorPos(ImGui.GetCursorPosX() + offset, y)
--     if mq.TLO.Me.Sitting() then ImGui.TextColored(1, 0, 0, 1,'\xef\x89\xa1') else
--         ImGui.TextColored(0, 1, 1, 1,'\xef\x89\xa1')
--     end
-- end

-- -- ImGui main function for rendering the UI window
-- local GroupWindowLayout = function()
--     if isWindowHovered then ImGui.SetNextWindowBgAlpha(1) else ImGui.SetNextWindowBgAlpha(.1) end
--     openGUI, shouldDrawGUI = ImGui.Begin('Group Window', openGUI, SetWindowFlags)
--     if shouldDrawGUI then
--         AlphaIfMouseOverWindow()
--         DrawButtonRow(5, 25, 40, 20, 6)
--         DrawButtonColumn(190, 25, 60, 20, 10)
--         LayoutTargetInfo(5, 50)
--         LayoutHealthBars(5, 100, 180, 15)
--         LayoutRowIcons(5, 250, 20)
--     end
--     ImGui.End()
--     if not openGUI then
--         terminate = true
--     end
-- end

-- mq.imgui.init('GroupWindowLayout', GroupWindowLayout)

-- while not terminate do
--     mq.delay(100)
-- end