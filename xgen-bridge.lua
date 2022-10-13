-- XGen Bridge
-- Written by Aipoc76 for Red Guides.
-- To be used with XGen Macro collection.
--===================================================================================================================================================================================

-- Ide like to thank the following!
-- Brainiac (im sure i annoyed him more than he cared for!), knightly, aquietone, exspes007, kane01, and a slew of others for all your assistance while i fumbled around with lua.
-- I could not have done it with out my testers. Crusteye, Shinz, XXyyz, they were just as instrumental and AWESOME!!
-- Your all's assistance is greatly appreaciated!

---@diagnostic disable: cast-local-type, undefined-field, undefined-global

local mq = require('mq')
-- @type ImGui
require 'ImGui'
-- local dn = require('lib.dannetbinds')

local MQVAR = mq.TLO.Macro.Variable

local ICON = require('lib.icons')
local openGUI = true
local openGUI2 = true
local openGUI3 = true
local openGUI4 = true
local openGUI5 = true
local textToDraw = ''


local TEXT_BASE_WIDTH, _ = ImGui.CalcTextSize("A")
local TEXT_BASE_HEIGHT = ImGui.GetTextLineHeightWithSpacing()


-- DATA WE DONT WANT REDRAWN
-- DATA WE DONT WANT REDRAWN
-- DATA WE DONT WANT REDRAWN
-- DATA WE DONT WANT REDRAWN


local i = 1


local nametabpopcheckec
local variablestabpopcheckec
local raidpopcheckec

local data = ''
local data2 = ''
local melodydata = MQVAR('xgv_MelodyString')()
local ByosNewSpell = 'Variable "NewSpellName"'


-- SLIDER INITs
local mwhud = MQVAR('xgv_ToggleManaWatchHud')()
if mwhud == 0 then mq.cmd('/varset xgv_ToggleManaWatchHud OFF') end
if mwhud == 1 then mq.cmd('/varset xgv_ToggleManaWatchHud Healers') end
if mwhud == 2 then mq.cmd('/varset xgv_ToggleManaWatchHud Group') end
if mwhud == 3 then mq.cmd('/varset xgv_ToggleManaWatchHud Self') end

local function HelpMarker(desc)
    ImGui.TextDisabled('(?)')
    if ImGui.IsItemHovered() then
        ImGui.BeginTooltip()
        ImGui.PushTextWrapPos(ImGui.GetFontSize() * 35.0)
        ImGui.Text(desc)
        ImGui.PopTextWrapPos()
        ImGui.EndTooltip()
    end
end

-- FUNCTION WINDOW SIZE RESET
function Windowsizereset()
    if ImGui.Button('WindowSize') then ImGui.SetWindowSize(430, 277, ImGuiCond.Always) end
end

-- FUNCTION ZONE TABLES
-- Begening of Zone Build
local ZoneSearch = ""
Myzonetable = {}
for i = 1, 849 do
    local zone = mq.TLO.Zone(i)
    if zone() ~= nil then
        Myzonetable[zone.Name()] = zone.ShortName()
    end
end

-- FUNCTION SPLIT
---@diagnostic disable-next-line: lowercase-global
function mysplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

-- FUNCTION CHECKBOX
function Checkbox(_checkbox, _var, _command, _stuff)
    local chkbxname = _checkbox -- NAME OF CHECK BOX
    local state = mq.TLO.Macro.Variable(_var)() == 1 -- EDIT NAME IN ''
    local cmdname = _command -- /cc name you type to do command
    local mode = ImGui.Checkbox(chkbxname, state) -- NEVER EDIT
    if mode ~= state then -- NEVER EDIT
        if mode then mq.cmd("/cc", cmdname, "on") else mq.cmd("/cc", cmdname, "off") end -- NEVER EDIT
    end
    if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
        if ImGui.IsItemHovered() then ImGui.SetTooltip(_stuff) end
    end
end

-- FUNCTION ADMIN CHECKBOX
function AdminCheckbox(_checkbox, _var, _command, _stuff)
    local chkbxname = _checkbox -- NAME OF CHECK BOX
    local state = mq.TLO.Macro.Variable(_var)() == 1 -- EDIT NAME IN ''
    local cmdname = _command -- /cc name you type to do command
    local mode = ImGui.Checkbox(chkbxname, state) -- NEVER EDIT
    if mode ~= state then -- NEVER EDIT
        if mode then mq.cmd("/admin", cmdname, "on") else mq.cmd("/admin", cmdname, "off") end -- NEVER EDIT
    end
    if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
        if ImGui.IsItemHovered() then ImGui.SetTooltip(_stuff) end
    end
end

-- FUNCTION BUTTON BIG
-- to use type: Button('MyBigButton'. 'autosit', xgv_AutoSit1, 0.2, .6, 0.0, 1)Button, 0.2, .6, 0.0, 1)
function MyBigButton(_buttonname, _command, _var, _stuff)
    local SitLabel = _buttonname
    if MQVAR(_var)() == 1 then
        ImGui.PushStyleColor(ImGuiCol.Button, 0.2, .6, 0.0, 1)
    end
    if MQVAR(_var)() == 1 then SitLabel = SitLabel end
    if ImGui.Button(SitLabel) then mq.cmd('/cc ', _command) end
    if MQVAR(_var)() == 1 then ImGui.PopStyleColor() end
    if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
        if ImGui.IsItemHovered() then ImGui.SetTooltip(_stuff) end
    end

end

-- FUNCTION BUTTON small
function MySmallButton(_buttonname, _command, _var, _stuff)
    local SitLabel = _buttonname
    if MQVAR(_var)() == 1 then
        ImGui.PushStyleColor(ImGuiCol.Button, 0.2, .6, 0.0, 1)
    end
    if MQVAR(_var)() == 1 then SitLabel = SitLabel end
    if ImGui.SmallButton(SitLabel) then mq.cmd('/cc ', _command) end
    if MQVAR(_var)() == 1 then ImGui.PopStyleColor() end
    if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
        if ImGui.IsItemHovered() then ImGui.SetTooltip(_stuff) end
    end

end

-- FUNCTION BARD
function Clickedsavemelody()
    if ImGui.Button("Save") then
        mq.cmdf('/cc storevar xgv_MelodyString "%s"', melodydata)
    end
end

function Clickedstartmelody()
    if ImGui.Button("Start") then
        mq.cmd('/newmelody', melodydata)
    end
end

-- FUNCTION GROUP MEMBER FUNCTION
function Groupmember(_gid)
    local cwidth = ImGui.GetColumnWidth()
    GPMember = mq.TLO.Group.Member(_gid)
    if GPMember() then
        if ImGui.Button(GPMember(), cwidth, 0) then
            mq.cmdf('/target id %d', GPMember.ID())
        end
    end
    ImGui.TableNextColumn()

    ImGui.PushStyleVar(ImGuiStyleVar.ItemSpacing, 2.0, 0.0)
    local hcwidth = math.floor(cwidth * 0.7)

    if GPMember() then
        if mq.TLO.Group.MainTank() == GPMember() then ImGui.PushStyleColor(ImGuiCol.Button, 0.2, 0.5, 0.1, 1) end
        if ImGui.Button('GMT##' .. _gid, 33, 0) then
            mq.cmdf('/grouproles set %s %d', GPMember(), 1)
        end
        if mq.TLO.Group.MainTank() == GPMember() then ImGui.PopStyleColor() end
    end

    ImGui.SameLine()
    if GPMember() then
        if mq.TLO.Group.MainAssist() == GPMember() then ImGui.PushStyleColor(ImGuiCol.Button, 0.2, 0.5, 0.1, 1) end
        if ImGui.Button('GMA##' .. _gid, 33, 0) then
            mq.cmdf('/grouproles set %s %d', GPMember(), 2)
        end
        if mq.TLO.Group.MainAssist() == GPMember() then ImGui.PopStyleColor() end
    end
    ImGui.PopStyleVar()

end

function GroupmemberExp(_gidx)

    local GmemName = mq.TLO.Group.Member(_gidx).Name
    if GmemName() and mq.TLO.Defined('DN_' .. GmemName() .. '_Exp') then
        ImGui.Text(mq.TLO.Macro.Variable('DN_' .. GmemName() .. '_Exp')())
        ImGui.TableNextColumn()
        ImGui.Text(mq.TLO.Macro.Variable('DN_' .. GmemName() .. '_AAunused')())
    else
        ImGui.Text('-')
        ImGui.TableNextColumn()
        ImGui.Text('-')
    end

end

-- END DATA WE DONT WANT REDRAWN END
-- END DATA WE DONT WANT REDRAWN END
-- END DATA WE DONT WANT REDRAWN END
-- END DATA WE DONT WANT REDRAWN END

local function imguicallback()
    if openGUI then
        ImGui.PushStyleColor(ImGuiCol.TabActive, .2, .2, .2, 1)
        ImGui.PushStyleColor(ImGuiCol.TabHovered, .5, .2, 1, 1)

        -- start of window draw above..
        ---@diagnostic disable-next-line: unused-local, cast-local-type
        local is_drawn = true
        openGUI, is_drawn = ImGui.Begin('XGen Bridge', openGUI)
        -- Windowsizereset()
        local id = 'id ' .. mq.TLO.Target.ID()
        local exists = mq.TLO.Navigation.PathExists(id)()

        ImGui.BeginTabBar('XGEN', ImGuiTabBarFlags.Reorderable)
        ImGui.PushStyleVar(ImGuiStyleVar.ScrollbarSize, 15)
        ImGui.PushStyleVar(ImGuiStyleVar.ItemSpacing, 4.0, 4.0)


        local xgen_running = string.find(mq.TLO.Macro.Name() or '', 'xgen.mac')

        WindowW = ImGui.GetWindowSize()
        WindowH = ImGui.GetWindowHeight()
        --print(WindowW ..'X ', WindowH)

        function Topbar()
            ImGui.BeginGroup()
            ImGui.PushStyleColor(ImGuiCol.Button, 0, 1, 0, .3)
            local people = string.format("%s %s", mq.TLO.SpawnCount("PC")(), ICON.FA_CHILD)
            if ImGui.SmallButton(people) then mq.cmd('/keypress m') end
            if ImGui.IsItemHovered() then ImGui.SetTooltip('Click to open map.') end

            ImGui.PopStyleColor()
            ImGui.EndGroup()
            ImGui.SameLine()

            ImGui.TextColored(0.39, 0.58, 0.92, 1, 'Trgt:')
            ImGui.SameLine()
            ImGui.TextColored(1, 1, 0.1, 1, mq.TLO.Target.CleanName())
            ImGui.SameLine()
            ImGui.TextColored(1, 1, 1, 1, 'LOS:')
            ImGui.SameLine()
            local checked = (mq.TLO.Target.LineOfSight())
            if checked then ImGui.TextColored(0, 1, 0, 1, 'T') else ImGui.TextColored(1, 0, 0, 1, 'F') end
            ImGui.SameLine()
            ImGui.TextColored(1, 1, 1, 1, 'X-Status:')
            ImGui.SameLine()

            local StartXGen = 'OFF'
            local colorStyleCount = 0


            if xgen_running then
                if MQVAR('XgenStarted')() == 1 then
                    ImGui.PushStyleColor(ImGuiCol.Button, 0.5, .5, 0.0, 1)
                    StartXGen = 'Starting'
                    colorStyleCount = colorStyleCount + 1
                elseif MQVAR('XgenStarted')() == 2 then
                    ImGui.PushStyleColor(ImGuiCol.Button, 0.2, .6, 0.0, 1)
                    StartXGen = 'UP'
                    colorStyleCount = colorStyleCount + 1
                end

            end

            if ImGui.SmallButton(StartXGen) then mq.cmdf('/macro xgen\\xgen') end
            if ImGui.IsItemHovered() then ImGui.SetTooltip('Click to Start/Restart XGen.') end

            ImGui.PopStyleColor(colorStyleCount)
            ImGui.SameLine()
            local EndMac = 'END##startbarend1'
            if ImGui.SmallButton(EndMac) then mq.cmdf('/end') end
            if ImGui.IsItemHovered() then ImGui.SetTooltip('Ends Running Macros.') end
            ImGui.SameLine()
            local MQPause = 'MQP##startbarmqp1'
            if mq.TLO.Macro.Paused() then MQPause = 'Paused##startbarpaused1' end
            if ImGui.SmallButton(MQPause) then mq.cmdf('/mqp') end
            if ImGui.IsItemHovered() then ImGui.SetTooltip('Pauses Macro.') end
            ImGui.SameLine()
            HelpMarker('Right click over most items for more information.')


        end

        if ImGui.BeginTabItem('Overview') then

            Topbar()

            ImGui.Separator()
            ImGui.Separator()

            -- Start of XGEN Tabs and buttons.
            if xgen_running and MQVAR('XgenStarted')() == 2 then
                ImGui.PushStyleVar(ImGuiStyleVar.ItemSpacing, 1.0, 4.0)

                -- New Row ================================================
                -- AUTO SIT CHECKBOX
                MyBigButton('AutoSit', 'autosit', 'xgv_Sit1', 'Enables/Disables Auto Sit.')
                -- RETURN TO CAMP CHECKBOX
                ImGui.SameLine()
                MyBigButton('Camp', 'camp', 'xgv_ToggleCamp1', 'Enables/Disables if you return to camp when OOC.')
                -- MOVE TO MOB CHECKBOX
                ImGui.SameLine()
                MyBigButton('Move', 'move', 'xgv_ToggleMove1', 'Enables/Disables if you Move to Mobs when fighting.')
                -- BUTTON GETBEHIND
                ImGui.SameLine()
                MyBigButton('Behind', 'behind', 'xgv_ToggleGetBehind',
                    'Enables/Disables if you fight at the back of the mob.')
                -- BUTTON MELEE
                ImGui.SameLine()
                local MeleeToggleButton = 'ENC, WIZ, MAG, DRU, NEC'
                if string.find(MeleeToggleButton, mq.TLO.Me.Class.ShortName()) then
                    MyBigButton('Melee', 'melee', 'xgv_ToggleMeleeMode',
                        'Enables/Disables melee mode for ENC, WIZ, MAG, DRU, NEC.')
                end
                -- BUTTON MAKECAMP
                ImGui.SameLine()
                local MakeCamp = 'MakeCamp'
                if ImGui.Button(MakeCamp) then mq.cmdf('/cc makecamp') end
                if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                    if ImGui.IsItemHovered() then ImGui.SetTooltip('Creates a New Camp at current Location.') end
                end


                ImGui.SameLine()
                ImGui.PushStyleColor(ImGuiCol.Button, 1, 0.3, 0, 1)
                MyBigButton('Follow', 'follow', 'xgv_Follow1')
                if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                    if ImGui.IsItemHovered() then ImGui.SetTooltip('Toggles Autofollow of Main Tank.') end
                end

                ImGui.PopStyleColor()

                ImGui.SameLine()
                local MakeCamp = 'Home'
                if ImGui.Button(MakeCamp) then mq.cmdf('/nav waypoint autocamp') end
                if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                    if ImGui.IsItemHovered() then ImGui.SetTooltip('Sends you back to your camp location.') end
                end
                ImGui.PopStyleVar()

                -- CHECKBOX PULLER
                ImGui.Separator()
                Checkbox('Puller', 'Pulling1', 'pullmode', 'Check to Enable Pulling')
                -- CHECKBOX HUNTER
                ImGui.SameLine()
                Checkbox('Hunter', 'xgv_ToggleHunter1', 'hunter', 'Check to Enable Hunter Mode')
                -- CHECKBOX PULL MOVE
                ImGui.SameLine()
                Checkbox('Pull Move', 'xgv_TogglePullMove', 'pmove',
                    'Check to Enable moving to target. or Just stand there and use spell to pull')
                -- CHECKBOX PULL NUKE
                ImGui.SameLine()
                Checkbox('Pull Nuke', 'xgv_TogglePullNukes', 'pnuke', 'Check to Using Pulling Spell / Ability')
                -- CHECKBOX BREAK INVIS
                ImGui.SameLine()
                Checkbox('BreakInv', 'xgv_ToggleAutoInvisOff', 'breakinvis',
                    'Enables/Disables Breaking Invis when GMT Gets in a fight.')



                ImGui.BeginTable('SpellsAndVars', 2,
                    bit32.bor(ImGuiTableFlags.Resizable, ImGuiTableFlags.Borders))
                ImGui.TableSetupColumn('Manawatch')
                ImGui.TableSetupColumn('Assist %', ImGuiTableColumnFlags.NoHeaderWidth)
                ImGui.TableHeadersRow()
                ImGui.TableNextRow()
                ImGui.TableNextColumn()
                -- New Row ================================================

                -- manawatch SLIDER
                local mwhud = MQVAR('xgv_ToggleManaWatchHud')()
                local m1 = MQVAR('xgv_ToggleManaWatch')()
                ImGui.PushItemWidth(140)
                local mwslider = ImGui.SliderInt(mwhud, m1, 0, 3)
                ImGui.PopItemWidth()
                local storvar = mwslider
                local hudset = MQVAR('xgv_ToggleManaWatchHud')()

                if mwslider ~= m1 then
                    mq.cmd('/varset xgv_ToggleManaWatch', mwslider)
                    if mwslider == 0 then mq.cmd('/varset xgv_ToggleManaWatchHud OFF') end
                    if mwslider == 1 then mq.cmd('/varset xgv_ToggleManaWatchHud Healers') end
                    if mwslider == 2 then mq.cmd('/varset xgv_ToggleManaWatchHud Group') end
                    if mwslider == 3 then mq.cmd('/varset xgv_ToggleManaWatchHud Self') end
                    mq.cmd("/cc storevar xgv_ToggleManaWatch", storvar)
                end

                if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                    if ImGui.IsItemHovered() then ImGui.SetTooltip("Slide to select a new Mana Watch Mode") end
                end

                ImGui.TableNextColumn()
                -- SLIDER ASSIST %
                local asstatvar = MQVAR('xgv_iAssistHealthPct')()
                ImGui.PushItemWidth(190)
                local assistatslider = ImGui.SliderInt('##Assist', asstatvar, 49, 100)
                ImGui.PopItemWidth()
                local storvar = assistatslider
                if assistatslider ~= asstatvar then
                    mq.cmd('/varset xgv_iAssistHealthPct', assistatslider)
                    mq.cmd("/cc storevar xgv_iAssistHealthPct", storvar)
                end
                -- END ===== ManaSaver Slider
                ImGui.EndTable()

                -- New Row ================================================
                -- RADIUS / ZRADIUS SLIDER
                local z1 = MQVAR('Radius')
                local z2 = MQVAR('ZRadius')
                local rads = { z1(), z2() }
                local radiuschange = ImGui.SliderInt2("Radius   X-Y   |   Z", rads, 1, 1000)

                for i, k, v in ipairs(radiuschange) do
                    if i == 1 then
                        mq.cmd('/varset Radius', k)
                        mq.cmd('/squelch /mapfilter SpellRadius', k)
                    end
                    if i == 2 then mq.cmd('/varset ZRadius', k) end
                    if i == 1 and k ~= MQVAR('Radius')() then print('Updating Pull Radius') end
                    if i == 1 and k ~= MQVAR('Radius')() then mq.cmd('/sqlite query ${xgv_XGenDB} pullingdata INSERT OR REPLACE INTO PullRads (ZoneName,Radius,ZRadius) VALUES (trim("${Zone.Name}"), "${Radius}", "${ZRadius}")') end
                    if i == 2 and k ~= MQVAR('ZRadius')() then mq.cmd('/sqlite query ${xgv_XGenDB} pullingdata INSERT OR REPLACE INTO PullRads (ZoneName,Radius,ZRadius) VALUES (trim("${Zone.Name}"), "${Radius}", "${ZRadius}")') end
                    if i == 2 and k ~= MQVAR('ZRadius')() then print('Updating Pull ZRadius') end
                end

                if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                    if ImGui.IsItemHovered() then ImGui.SetTooltip("Left Slider = X/Y Radius, Right Slider is Z Radius.") end
                end
                -- New Row ================================================
                ImGui.Separator()

                ImGui.PushStyleVar(ImGuiStyleVar.ItemSpacing, 6.0, 4.0)
                -- CHECKBOX Tankmode
                Checkbox('Tank', 'xgv_ToggleTankMode1', 'tankmode', 'Enable/Disable Tanking Abilities and Aggro.')
                -- CHECKBOX RaidTank
                ImGui.SameLine()
                Checkbox('RaidTank', 'xgv_RaidTankMode', 'raidtank',
                    'No Movement, Continuous Aggro, Defensive abilities, No target swap.')
                -- CHECKBOX AEAggro
                ImGui.SameLine()
                Checkbox('AE Aggro', 'xgv_ToggleAEAggro1', 'aeaggro', 'Enables/Disables AE Aggro Skills.')
                -- CHECKBOX DPSmode
                ImGui.SameLine()
                Checkbox('DPSMode', 'xgv_ToggleDPSMode', 'dpsmode', 'Enables/Disables DPS Abilities and Discs.')
                -- CHECKBOX DICHO
                ImGui.SameLine()
                Checkbox('Dicho', 'xgv_dicho', 'dicho', 'Enables or Disables Dicho Line.')

                -- New Row ================================================
                -- CHECKBOX AssistMode
                Checkbox('AssistMode', 'xgv_Asst1', 'assist', 'Enables/Disables Auto Assisting.')
                -- CHECKBOX ForceBurn
                ImGui.SameLine()
                Checkbox('ForceBurn', 'xgv_ForceBurn', 'forceburn', 'Enables/Disables Continuous Burn Skills.')
                -- BUTTON BurnOnce
                ImGui.SameLine()
                local BurnOnce = 'Burn Once'
                if ImGui.SmallButton(BurnOnce) then mq.cmdf('/cc burnonce') end
                if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                    if ImGui.IsItemHovered() then ImGui.SetTooltip("1 time use of Burn Skills on Current NPC.") end
                end
                -- CHECKBOX Nukes
                ImGui.SameLine()
                Checkbox('Nukes', 'xgv_ToggleDPSNukes', 'nukes', 'Enables/Disables Nukes.')
                -- CHECKBOX DOT's
                ImGui.SameLine()
                Checkbox("Dot's", "xgv_ToggleDots", "dots", "Enables/Disables Dot's")
                ImGui.PopStyleVar()

            end --Tab MAIN
            ImGui.EndTabItem()
        end


        -- #############################################################################################
        -- #############################################################################################
        -- #############################################################################################
        -- #############################################################################################


        if xgen_running and MQVAR('XgenStarted')() == 2 then -- checking for running mac-- this is set in if's on purpose. ImGui crahes if the macro is stopped while lua running.
            -- ============== Nukes / Dots ManaSaver TAB =================
            local NukeClasses = 'ENC, WIZ, MAG, DRU, NEC, SHD, SHM, RNG, PAL'
            if string.find(NukeClasses, mq.TLO.Me.Class.ShortName()) and
                ImGui.BeginTabItem('Caster DPS') then

                Topbar()

                ImGui.Separator()
                ImGui.Separator()

                -- CHECKBOX Nukes
                Checkbox('Nukes', 'xgv_ToggleDPSNukes', 'nukes', 'Enables/Disables Nukes.')

                -- CHECKBOX DOT's
                ImGui.SameLine()
                Checkbox("Dot's", "xgv_ToggleDots", "dots", "Enables/Disables Dot's")

                -- CHECKBOX BUFFS
                ImGui.SameLine()
                Checkbox('Buffs', 'xgv_bufz', 'buffs', 'Enables/Disables Buffs.')


                -- CHECKBOX Damage Shields
                ImGui.SameLine()
                Checkbox('DS', 'xgv_DamShld', 'ds', 'Enables/Disables Damage Shield.')


                -- CHECKBOX SUMMON PET
                ImGui.SameLine()
                Checkbox("Pet", "xgv_SummPet", "sumpet", "Enables/Disables Pet Summoning")



                ImGui.PushItemWidth(-170)
                ImGui.TextColored(1, 1, 1, 1, 'Set to minimum % mana for nuking. Reserves mana for other stuff.')
                -- minimum mana SLIDER

                -- Start ===== ManaSaver Slider
                local minmana = MQVAR('xgv_ManaSaver')()
                local minmanaslider = ImGui.SliderInt('% MinimumMana for Nukes', minmana, 1, 99)
                local storvar = minmanaslider
                if minmanaslider ~= minmana then
                    mq.cmd('/varset xgv_ManaSaver', minmanaslider)
                    mq.cmd("/cc storevar xgv_ManaSaver", storvar)
                end
                -- END ===== ManaSaver Slider

                -- Start ===== DotManaSaver Slider
                local dotminmana = MQVAR('xgv_DotManaSaver')()
                local dotminmanaslider = ImGui.SliderInt('% MinimumMana for DoTs', dotminmana, 1, 99)
                local storvar = dotminmanaslider
                if dotminmanaslider ~= dotminmana then
                    mq.cmd('/varset xgv_DotManaSaver', dotminmanaslider)
                    mq.cmd("/cc storevar xgv_DotManaSaver", storvar)
                end




                if mq.TLO.Me.Class.ShortName() == 'DRU' then
                    ImGui.SameLine()
                    Checkbox("Snare", "xgv_snare1", "snare", "Enables/Disables Ensnare AA")
                end

                -- battle Shamman
                if mq.TLO.Me.Class.ShortName() == 'SHM' then
                    ImGui.Separator()

                    local chkbxname = "X-DoT Mode" -- NAME OF CHECK BOX
                    local state = MQVAR('xgv_ToggleDotMode')() == 1 -- EDIT NAME IN ''
                    local cmdname = 'moredots' -- /cc name you type to do command
                    local mode = ImGui.Checkbox(chkbxname, state) -- NEVER EDIT
                    if mode ~= state then -- NEVER EDIT
                        if mode then
                            mq.cmd('/cc', cmdname, 'on')
                            mq.cmd('/cc buffs off')
                        else
                            mq.cmd('/cc', cmdname, 'off')
                        end
                    end
                end

                if mq.TLO.Me.Class.ShortName() == 'PAL' then
                    ImGui.Separator()

                    -- CHECKBOX Crush
                    Checkbox('Crush', 'xgv_CrushOrStun', 'crush', 'Enables/Disables Crush.')
                    -- CHECKBOX Stun
                    ImGui.SameLine()
                    Checkbox('Stuns', 'xgv_ToggleStuns', 'stuns', 'Enables/Disables Stuns.')
                    -- CHECKBOX Divine Stun
                    ImGui.SameLine()
                    Checkbox('Divine Stuns', 'xgv_ToggleStuns2', 'dstuns', 'Enables/Disables Divine Stun.')
                end

                if mq.TLO.Me.Class.ShortName() == 'ENC' then
                    -- CHECKBOX Dizy Line Stuns
                    Checkbox('Dizy Stuns', 'xgv_ToggleStuns', 'stuns', 'Enables/Disables Dizy Line Stuns.')
                    -- CHECKBOX Color Line Stuns
                    ImGui.SameLine()
                    Checkbox('Color Stuns', 'xgv_ToggleStuns2', 'stuns2', 'Enables/Disables Color Line Stuns.')
                end


                if mq.TLO.Me.Class.ShortName() == 'RNG' then

                    ImGui.Separator()


                    -- New Row ================================================


                    MyBigButton('Ranged Mode', 'ranged', 'xgv_ModeRanged')
                    ImGui.SameLine()
                    MyBigButton('Move', 'move', 'xgv_ToggleMove1')
                    -- BUTTON GETBEHIND
                    ImGui.SameLine()
                    MyBigButton('Behind', 'behind', 'xgv_ToggleGetBehind')

                    -- CHECKBOX AE's
                    Checkbox("AE's", 'xgv_ToggleAE', 'useae', 'Enables/Disables AE Abilities .')
                    ImGui.SameLine()
                    -- CHECKBOX Spirit of Eagle AA
                    Checkbox('SoE Toggle', 'xgv_SupaSpeed', 'soe', 'Enables/Disables Spirit of Eagles AA.')

                    local snuke = MQVAR('xgv_NukCnt')()
                    local sn1 = MQVAR('xgv_NukCnt')()
                    local snslider = ImGui.SliderInt('Summers Nuke Cast#', sn1, 1, 50)
                    local storvar = snslider
                    local hudset = MQVAR('xgv_NukCnt')()
                    if snslider ~= sn1 then
                        mq.cmd('/varset xgv_NukCnt', snslider)
                        mq.cmd("/cc storevar xgv_NukCnt", storvar)
                    end

                end
                ImGui.PopItemWidth()
                ImGui.EndTabItem()
            end


            -- #############################################################################################
            -- #############################################################################################
            -- #############################################################################################


            -- ==============  MISC TAB =================
            if ImGui.BeginTabItem('Misc') then

                Topbar()


                -- Character customisation Collapsable Header.
                if ImGui.CollapsingHeader('Macro Customisations', ImGuiTreeNodeFlags.Framed) then

                    -- CHECKBOX CLICKIES
                    ImGui.Separator()
                    Checkbox("Clickies", "xgv_ToggleuseClickies", "useclickies",
                        "Enables/Disables Auto use of clickie items in DB")
                    -- CHECKBOX End on Death
                    ImGui.SameLine()
                    Checkbox("End on Death", "xgv_EndOnDeath", "endondeath", "Enables/Disables Ending of Mac on Death")
                    -- CHECKBOX Tell Beeps
                    ImGui.SameLine()
                    Checkbox("Tell Beeps", "xgv_TellBeep", "tellbeep", "Enables/Disables Tell Beeps")
                    -- BUTTON MISSDING SPELLS
                    ImGui.SameLine()
                    MyBigButton('Missing Spells', 'missingspells')

                    -- CHECKBOX facefast
                    Checkbox("Face Fast", "xgv_ToggleFaceFast", "facefast", "Enables/Disables Fast Facing")
                    ImGui.SameLine()
                    -- CHECKBOX HIDEC CORPSE
                    Checkbox("Hide Corpse", "xgv_HidCor", "midecor", "Enables/Disables Hiding Corpses after kill")
                    -- CHECKBOX Time Stamps
                    ImGui.SameLine()
                    Checkbox("Timestamp", "StamP", "stamp", "Enables/Disables Time Stamps in Console.")
                    -- CHECKBOX Time Stamps

                    ImGui.SameLine()
                    AdminCheckbox("Admin Tab", "AdminModeOn", "admingui",
                        "Only use if you know what all this does please.")
                    -- BUTTON ITEM CLICKY
                    NameTabPopout = ImGui.Checkbox("Named List Popout", nametabpopcheckec)
                    nametabpopcheckec = NameTabPopout
                    ImGui.SameLine()
                    VariablesTabPopout = ImGui.Checkbox("Variables Popout", variablestabpopcheckec)
                    variablestabpopcheckec = VariablesTabPopout
                    ImGui.SameLine()
                    RaidPopout = ImGui.Checkbox("Raid Popout", raidpopcheckec)
                    raidpopcheckec = RaidPopout


                    ImGui.Separator()
                    MyBigButton('Add Clicky', 'additem', 'xgv_DummyVar',
                        'Put item on curser then click button for out of combat clickie use.')
                    -- BUTTON ITEM CLICKY
                    ImGui.SameLine()
                    MyBigButton('Add CombatClicky', 'additemcombat', 'xgv_DummyVar',
                        'Put item on curser then click button for combat clickie use.')
                    -- BUTTON ITEM CLICKY
                    ImGui.SameLine()
                    MyBigButton('Remove Clicky', 'deleteitem', 'xgv_DummyVar',
                        'Put item on curser then click button to REMOVE clickie use.')
                    ImGui.SameLine()
                    Windowsizereset()

                end


                --  I really dislike this entire block of code (Variables).  However due to the way the spells and variables are brough
                --  in to the lua, there is no elegant way that I know of on how to do what this does.  It has been
                --  RedNeck Engineered by Aipoc76 "Redneck Coder"
                if ImGui.CollapsingHeader("Variables", ImGuiTreeNodeFlags.Framed) then
                    ImGui.TextColored(1, 0, 0, 1, 'BYOS:')
                    ImGui.SameLine()
                    ImGui.TextColored(1, 1, 1, 1, 'Type the')
                    ImGui.SameLine()
                    ImGui.TextColored(1, 1, 0, 1, ' Variable ')
                    ImGui.SameLine()
                    ImGui.TextColored(1, 1, 1, 1, '&')
                    ImGui.SameLine()
                    ImGui.TextColored(1, 0, 0, 1, '"')
                    ImGui.SameLine()
                    ImGui.TextColored(1, 1, 0, 1, 'Spell Name')
                    ImGui.SameLine()
                    ImGui.TextColored(1, 0, 0, 1, '"')
                    ImGui.SameLine()
                    ImGui.TextColored(1, 1, 1, 1, ' save & restart')
                    ImGui.PushItemWidth(-120)

                    ---@diagnostic disable-next-line: cast-local-type
                    ByosNewSpell = ImGui.InputText('##ByosNewSpell', ByosNewSpell)
                    ImGui.PopItemWidth()
                    ImGui.SameLine()
                    if ImGui.SmallButton('Save') then
                        mq.cmd('/cc byos', ByosNewSpell)
                        mq.cmd('/varset ', ByosNewSpell)
                        ByosNewSpell = 'Variable "NewSpellName"'
                    end

                    if ImGui.BeginTable('SpellsAndVars', 4,
                        bit32.bor(ImGuiTableFlags.ScrollX, ImGuiTableFlags.Resizable, ImGuiTableFlags.Borders,
                            ImGuiTableFlags.SizingStretchProp, ImGuiTableFlags.NoPadOuterX, TEXT_BASE_HEIGHT * 15, 0.0)) then
                        ImGui.TableSetupColumn('Variable', bit32.bor(ImGuiTableColumnFlags.WidthStretch), -1.0, 1)
                        ImGui.TableSetupColumn('Spell Name', bit32.bor(ImGuiTableColumnFlags.WidthStretch), -1.0, 2)
                        ImGui.TableSetupColumn('Variable', bit32.bor(ImGuiTableColumnFlags.WidthStretch), -1.0, 3)
                        ImGui.TableSetupColumn('Spell Name', bit32.bor(ImGuiTableColumnFlags.WidthStretch), -1.0, 4)
                        -- ImGui.TableSetupScrollFreeze(0, 1)
                        ImGui.TableHeadersRow()

                        local spellvar = MQVAR('luavars')()
                        local spells = MQVAR('luavars')()
                        local spellvarstable = mysplit(spellvar, "|")
                        local spellstable = mysplit(spells, "|")
                        ImGui.TableNextRow()
                        ImGui.TableSetColumnIndex(0)

                        for i = 1, math.min(#spellvarstable, #spellstable) do

                            if mq.TLO.Me.AltAbilityReady(spellvarstable[i])() and
                                mq.TLO.Me.AltAbility(spellvarstable[i])()
                                or
                                mq.TLO.Me.CombatAbilityReady(spellvarstable[i])() and
                                mq.TLO.Me.CombatAbility(spellvarstable[i])() or
                                mq.TLO.Me.SpellReady(spellvarstable[i])() and mq.TLO.Me.Spell(spellvarstable[i])() then
                                ImGui.TextColored(0, 1, 0, 1, spellvarstable[i])
                            elseif mq.TLO.Macro.Variable(spellvarstable[i])() then
                                ImGui.TextColored(1, 1, 1, 1, spellvarstable[i])
                            else
                                ImGui.TextColored(1, 0, 0, 1, spellvarstable[i])
                            end
                            ImGui.TableNextColumn()
                            i = i + 1

                        end

                        ImGui.EndTable()
                    end
                end

                -- Travel Agency Collapsable Header.
                local tablename = 'Travel Agency'
                if ImGui.CollapsingHeader(tablename, ImGuiTreeNodeFlags.Framed) then
                    -- ImGui.TableSetupScrollFreeze(0, 1)
                    if ImGui.BeginTable(tablename, 2,
                        bit32.bor(ImGuiTableFlags.ScrollX, ImGuiTableFlags.Resizable, ImGuiTableFlags.Borders,
                            ImGuiTableFlags.SizingStretchProp, TEXT_BASE_HEIGHT * 15, 0.0)) then

                        ImGui.TableSetupColumn('Name - Case sensitive!', bit32.bor(ImGuiTableColumnFlags.WidthStretch),
                            -1.0
                            , 0)
                        ImGui.TableSetupColumn('Short', bit32.bor(ImGuiTableColumnFlags.WidthStretch), -1.0, 1)


                        ImGui.TableHeadersRow()
                        ImGui.TableNextRow()
                        ImGui.TableSetColumnIndex(0)
                        ImGui.Text('Search')
                        ---@diagnostic disable-next-line: cast-local-type
                        ZoneSearch = ImGui.InputText("##zonename", ZoneSearch)

                        ImGui.TableSetColumnIndex(1)
                        ImGui.Text('Click to Run')
                        ImGui.TableNextRow()
                        table.sort(Myzonetable)

                        for key, value in pairs(Myzonetable) do

                            ---@diagnostic disable-next-line: param-type-mismatch
                            if string.len(ZoneSearch) <= 0 or string.find(key, ZoneSearch) then
                                ImGui.TableNextRow()
                                ImGui.TableSetColumnIndex(0)
                                if ImGui.Selectable(key) then
                                    ImGui.SmallButton(key)
                                    mq.cmd('/travelto ', value)
                                end

                                ImGui.TableSetColumnIndex(1)
                                if ImGui.Selectable(value) then
                                    ImGui.SmallButton(value)
                                    mq.cmd('/travelto ', value)
                                end
                            end

                        end
                        ImGui.EndTable()
                    end
                end


                local tablename = 'Named List'
                if ImGui.CollapsingHeader(tablename, bit32.bor(ImGuiTreeNodeFlags.Framed)) then
                    if ImGui.BeginTable(tablename, 4,
                        bit32.bor(ImGuiTableFlags.Resizable, ImGuiTableFlags.Borders, ImGuiTableFlags.SizingStretchProp,
                            ImGuiTableFlags.RowBg)) then

                        ImGui.TableSetupColumn('Named -- Click to Run To')
                        ImGui.TableSetupColumn('Health')
                        ImGui.TableSetupColumn('Direction')
                        ImGui.TableSetupColumn('Distance')
                        ImGui.TableHeadersRow()
                        ImGui.TableNextRow()
                        ImGui.TableSetColumnIndex(0)

                        -- ImGui.Separator()

                        local namelist = MQVAR('xgv_namelist')()
                        local nametable = mysplit(namelist, "|")
                        for i = 1, math.min(#nametable) do
                            local mqsntablei = mq.TLO.Spawn(nametable[i])

                            if nametable[i] ~= 'abcd' then

                                if mqsntablei() then
                                    ImGui.TableSetColumnIndex(0)
                                    if ImGui.Selectable(nametable[i]) then
                                        mq.cmd('/nav id', mqsntablei())
                                    end
                                else
                                    ImGui.TableSetColumnIndex(0)
                                    ImGui.TextColored(1, 0, 0, 1, nametable[i])
                                end

                                ImGui.TableSetColumnIndex(1)
                                if mqsntablei() then
                                    ImGui.Text(mq.TLO.Spawn(nametable[i]).PctHPs() .. ' %')
                                else
                                    ImGui.Text('N/A')
                                end

                                ImGui.TableSetColumnIndex(2)
                                if mqsntablei() then
                                    ImGui.Text(mq.TLO.Spawn(nametable[i]).Heading())
                                else
                                    ImGui.Text('N/A')
                                end

                                ImGui.TableSetColumnIndex(3)
                                if mqsntablei() then
                                    local dist = mq.TLO.Spawn(nametable[i]).Distance()
                                    ImGui.Text(string.format("%.2f", dist))
                                else
                                    ImGui.Text('N/A')
                                end

                            end
                            ImGui.TableNextRow()
                            i = i + 1
                        end
                        ImGui.EndTable()
                    end
                end
                ImGui.EndTabItem()
            end

            -- #############################################################################################
            -- #############################################################################################
            -- #############################################################################################

            -- TANK Tab
            local TankClasses = 'SHD, PAL, WAR'
            if xgen_running and

                string.find(TankClasses, mq.TLO.Me.Class.ShortName()) and
                ImGui.BeginTabItem('Tanks') then


                Topbar()

                ImGui.Separator()
                ImGui.Separator()

                ImGui.PushStyleVar(ImGuiStyleVar.ItemSpacing, 3.0, 4.0)
                ImGui.TextColored(1, 0, 0, 1, 'This is for Setting Up Tanks.   Bandolier buttons SAVE sets.')
                ImGui.TextColored(0.39, 0.58, 0.92, 1, "Bandolier's")
                ImGui.SameLine()

                local TankingBando = 'Tanking'
                if ImGui.Button(TankingBando) then mq.cmd('/bandolier Add Tanking') end

                ImGui.SameLine()
                local twohdbando = '2hander'
                if ImGui.Button(twohdbando) then mq.cmd('/bandolier Add 2hander') end

                -- local twoonehanders = '1hs'
                ImGui.SameLine()
                local twoonehanders = '1hs'
                if (mq.TLO.Me.Class.ShortName() == 'WAR') then
                    if ImGui.Button(twoonehanders) then mq.cmd('/bandolier Add 1hs') end
                end

                -- BANDOLIER STUFF
                ImGui.SameLine()
                local chkbxname = "Bando" -- NAME OF CHECK BOX
                local state = MQVAR('xgv_ToggleBando1')() == 1 -- EDIT NAME IN ''
                local cmdname = 'bando' -- /cc name you type to do command

                local mode = ImGui.Checkbox(chkbxname, state) -- NEVER EDIT
                if mode ~= state then
                    if mode then mq.cmd('/cc', cmdname, 'on') else mq.cmd('/cc', cmdname, 'off') end
                end

                ImGui.SameLine()
                ImGui.PushItemWidth(-20)
                local bcount = MQVAR('xgv_bcount')()
                local storvar = ImGui.InputInt("##nonamebox", bcount)
                if bcount ~= storvar then
                    mq.cmd('/varset xgv_bcount', storvar)
                    mq.cmd("/cc storevar xgv_bcount", storvar)

                end
                ImGui.PopItemWidth()

                ImGui.Separator()
                ImGui.PopStyleVar()
                ImGui.PushItemWidth(-120) --- PUSH -120
                ImGui.PushStyleVar(ImGuiStyleVar.ItemSpacing, 4.0, 3.5)
                -- BUTTON AUTO SIT
                MySmallButton('AutoSit', 'autosit', 'xgv_Sit1')

                -- BUTTON RETURN TO CAMP
                ImGui.SameLine()
                MySmallButton('Camp', 'camp', 'xgv_ToggleCamp1')

                -- BUTTON MOVE TO MOB
                ImGui.SameLine()
                MySmallButton('Move', 'move', 'xgv_ToggleMove1')

                -- BUTTON GETBEHIND
                ImGui.SameLine()
                MySmallButton('Behind', 'behind', 'xgv_ToggleGetBehind')
                ImGui.PopStyleVar()
                ImGui.PushStyleVar(ImGuiStyleVar.ItemSpacing, 40.0, 3.0)

                ImGui.SameLine()
                MySmallButton('Follow', 'follow', 'xgv_Follow1')



                -- BUTTON MAKECAMP
                ImGui.SameLine()
                local MakeCamp = 'MakeCamp'
                if ImGui.SmallButton(MakeCamp) then mq.cmdf('/cc makecamp') end
                ImGui.PopStyleVar()
                ImGui.PushStyleVar(ImGuiStyleVar.ItemSpacing, 8.0, 3.0)
                ImGui.Separator()

                -- ###############  SETS THE HEIGHTH OF ALL THE SLIDERS ##########

                ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, 0, 2)

                -- ###############  SETS THE HEIGHTH OF ALL THE SLIDERS ##########

                -- Start ===== Defcon Slider
                local defconvar = MQVAR('xgv_DefCon')()
                local defconslider = ImGui.SliderInt("Sets DefCon %", defconvar, 1, 99)
                local storvart = defconslider
                if defconslider ~= defconvar then
                    mq.cmd('/varset xgv_DefCon', defconslider)
                    mq.cmd("/cc storevar xgv_DefCon", storvart)
                end
                -- END ===== Defcon Slider

                -- Start ===== Defcon2 Slider
                local defcon2var = MQVAR('xgv_DefCon2')()
                local defcon2slider = ImGui.SliderInt("Sets DefCon2 #", defcon2var, 1, 30)
                local storvard = defcon2slider
                if defcon2slider ~= defcon2var then
                    mq.cmd('/varset xgv_DefCon2', defcon2slider)
                    mq.cmd("/cc storevar xgv_DefCon2", storvard)
                end
                -- END ===== Defcon2 Slider

                -- Start ===== CampRad Slider
                local campradvar = MQVAR('xgv_GrpCmp')()
                local campradslider3 = ImGui.SliderInt("Sets CampRad #", campradvar, 1, 250)
                local storvarc = campradslider3
                if campradslider3 ~= campradvar then
                    mq.cmd('/varset xgv_GrpCmp', campradslider3)
                    mq.cmd("/cc storevar xgv_GrpCmp", storvarc)
                end
                -- END ===== CampRad Slider

                -- Start ===== 2aggro slider
                local secondagro = MQVAR('xgv_2PctAggro')()
                local secondagroslider = ImGui.SliderInt("Secondary Aggro %", secondagro, 30, 100)
                local storvar2a = secondagroslider
                if secondagroslider ~= secondagro then
                    mq.cmd('/varset xgv_2PctAggro', secondagroslider)
                    mq.cmd("/cc storevar xgv_2PctAggro", storvar2a)
                end
                -- END ===== 2aggro sliderr
                ImGui.PopStyleVar(2)
                ImGui.PopItemWidth() --- POP -120

                if mq.TLO.Me.Class.ShortName() == 'SHD' then
                    ImGui.TextColored(1, 1, 0, 1, 'SK')
                    ImGui.SameLine()
                    local chkbxname = 'Unity A' -- NAME OF CHECK BOX
                    local state = mq.TLO.Macro.Variable('Unity')() == mq.TLO.Macro.Variable('UnityA')() -- EDIT NAME IN ''UnityA
                    local cmdname = _command -- /cc name you type to do command

                    local mode = ImGui.Checkbox(chkbxname, state) -- NEVER EDIT
                    if mode ~= state then -- NEVER EDIT
                        if mode then mq.cmd("/cc setunity a") else mq.cmd("/cc setunity b") end -- NEVER EDIT
                    end
                    if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                        if ImGui.IsItemHovered() then ImGui.SetTooltip('Sets Unity Line to A') end
                    end

                    ImGui.SameLine()
                    local chkbxname = 'Unity B' -- NAME OF CHECK BOX
                    local state = mq.TLO.Macro.Variable('Unity')() == mq.TLO.Macro.Variable('UnityB')() -- EDIT NAME IN ''UnityA
                    local cmdname = _command -- /cc name you type to do command
                    local mode = ImGui.Checkbox(chkbxname, state) -- NEVER EDIT
                    if mode ~= state then -- NEVER EDIT
                        if mode then mq.cmd("/cc setunity b") else mq.cmd("/cc setunity a") end -- NEVER EDIT
                    end
                    if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                        if ImGui.IsItemHovered() then ImGui.SetTooltip('Sets Unity Line to B') end
                    end

                end
                -- End of Tab ======
                ImGui.EndTabItem()
            end

            -- #############################################################################################
            -- #############################################################################################
            -- #############################################################################################

            -- ============== Heal TAB =================
            local HealClasses = 'CLR, DRU, SHM, RNG, PAL, BST'
            if xgen_running and
                string.find(HealClasses, mq.TLO.Me.Class.ShortName()) and
                ImGui.BeginTabItem('Heals') then
                Topbar()

                ImGui.Separator()
                ImGui.Separator()

                -- Start -- MT Heal SLIDER
                local mtheal = MQVAR('xgv_MTHe1')()
                local mthealslider = ImGui.SliderInt('% MT Heals Start', mtheal, 1, 100)
                local storvar = mthealslider
                if mthealslider ~= mtheal then
                    mq.cmd('/varset xgv_MTHe1', mthealslider)
                    mq.cmd("/cc storevar xgv_MTHe1", storvar)
                end
                -- END -- MT Heal SLIDER

                -- Start  -- Group Heal SLIDER
                local grpheal = MQVAR('xgv_Pct1')()
                local grphealslider = ImGui.SliderInt('% Grp Heals Start', grpheal, 1, 99)
                local storvar = grphealslider
                if grphealslider ~= grpheal then
                    mq.cmd('/varset xgv_Pct1', grphealslider)
                    mq.cmd("/cc storevar xgv_Pct1", storvar)
                end
                -- END -- Group Heal SLIDER

                -- Start  -- Zerker Heal SLIDER
                local zrkheal = MQVAR('xgv_BERHeal')()
                local zrkhealslider = ImGui.SliderInt('% Zerker Heals D(80)', zrkheal, 1, 99)
                local storvar = zrkhealslider
                if zrkhealslider ~= zrkheal then
                    mq.cmd('/varset xgv_BERHeal', zrkhealslider)
                    mq.cmd("/cc storevar xgv_BERHeal", storvar)
                end
                -- END -- Zerker Heal SLIDER

                -- start Heal Range SLIDER
                local hl1 = MQVAR('xgv_Rng')()
                local healhudslider = ImGui.SliderInt('HealRange ' .. hl1 .. ' Ft.', hl1, 50, 300)
                local storvar = healhudslider
                if healhudslider ~= hl1 then
                    mq.cmd('/varset xgv_Rng', healhudslider)
                    mq.cmd("/cc storevar xgv_Rng", storvar)
                end

                ImGui.BeginGroup()

                -- CHECKBOX CURES
                Checkbox('Cures', 'xgv_ToggleCurez', 'cure', 'Enables/Disables Cures.')

                -- CHECKBOX BUFFS
                ImGui.SameLine()
                Checkbox('Buffs', 'xgv_bufz', 'buffs', 'Enables/Disables Buffs.')

                -- CHECKBOX X-Target Heals
                ImGui.SameLine()
                Checkbox('XTaHeals', 'xgv_XtargetHeals', 'xtheals', 'Enables/Disables X-Target Healing.')

                -- CHECKBOX Pet Heals
                ImGui.SameLine()
                Checkbox('PetHeals', 'xgv_PetHeals1', 'petheals', 'Enables/Disables Pet Healing.')

                -- CHECKBOX Auto Res
                ImGui.SameLine()
                Checkbox('Auto Rez', 'xgv_AutoRez1', 'autores', 'Enables/Disables Auto Res.')

                ImGui.EndGroup()
                ImGui.Separator()
                ImGui.Separator()

                -- Splash
                if mq.TLO.Me.Class.ShortName() == 'PAL' then
                    ImGui.TextColored(1, 1, 0, 1, 'Pally')
                    ImGui.SameLine()
                    Checkbox('Splash', 'xgv_Splash1', 'splash', 'Enables/Disables Splash at feet.')
                    ImGui.SameLine()
                    Checkbox('Auras', 'xgv_ToggleAura', 'aura', 'Enables/Disables Aura.')
                    ImGui.SameLine()
                    Checkbox('Self Heal', 'xgv_ToggleHealsSelf', 'sheals', 'Enables/Disables Self Healing.')
                    ImGui.SameLine()
                    Checkbox('Self Group', 'xgv_ToggleHealsGrp', 'gheals', 'Enables/Disables Group Healing.')

                end

                if mq.TLO.Me.Class.ShortName() == 'BST' then
                    ImGui.TextColored(1, 1, 0, 1, 'Beast')
                    ImGui.SameLine()
                    Checkbox('Focus Line', 'xgv_Focus', 'focus', 'Enables/Disables Focus Line Buffs.')
                    ImGui.SameLine()
                    Checkbox('Shared Fero', 'xgv_Fero', 'fero', 'Enables/Disables Shared Ferocity.')
                end

                if mq.TLO.Me.Class.ShortName() == 'DRU' then
                    ImGui.TextColored(1, 1, 0, 1, 'Druid')
                    ImGui.SameLine()
                    Checkbox('DS', 'xgv_DamShld', 'ds', 'Enables/Disables Damage Shield.')
                    ImGui.SameLine()
                    Checkbox('Skin', 'xgv_ToggleSkin', 'skin', 'Enables/Disables Skin Buff.')
                    ImGui.SameLine()
                    Checkbox('Auras', 'xgv_ToggleAura', 'aura', 'Enables/Disables Aura.')
                    Checkbox('Heals Only', 'HealsOnly', 'healsonly', 'Enables/Disables Heals Only Mode.')
                    ImGui.SameLine()
                    Checkbox('ManaSaver', 'Manasave1', 'manasave', 'Enables/Disables Mana Saving Mode.')
                    ImGui.SameLine()
                    Checkbox('DPSMode', 'xgv_ToggleDPSMode', 'dpsmode', 'Enables/Disables DPS Mode.')
                end

                if mq.TLO.Me.Class.ShortName() == 'CLR' then
                    ImGui.TextColored(1, 1, 0, 1, 'Cleric')
                    ImGui.SameLine()
                    Checkbox('Aego', 'xgv_ToggleAego1', 'aego', 'Enables/Disables Aegoism Buffline.')
                    ImGui.SameLine()
                    Checkbox('Symb', 'xgv_ToggleSymbol', 'symbol', 'Enables/Disables Symbol Buffline.')
                    ImGui.SameLine()
                    Checkbox('Yaulp', 'xgv_ToggleYaulp', 'yaulp', 'Enables/Disables Auto Yaulp.')
                    ImGui.SameLine()
                    Checkbox('Retort', 'xgv_retortonoff', 'retort', 'Enables/Disables Tank Retort.')
                    Checkbox('Splash', 'xgv_SplashRaid1', 'splash', 'Enables/Disables Splash.')
                    ImGui.SameLine()
                    Checkbox('ForceSplash', 'xgv_ForceSplash', 'forcesplash', 'Enables/Disables Force Splash.')
                end

                if mq.TLO.Me.Class.ShortName() == 'SHM' then
                    ImGui.TextColored(1, 1, 0, 1, 'Shaman')
                    ImGui.SameLine()
                    Checkbox('Combat Nuker', 'xgv_ToggleCombatNuke1', 'combatnuke',
                        'Enables/Disables Frost Line Chan Cast with coordinated Squall.')
                    ImGui.SameLine()
                    Checkbox('TalaTak', 'xgv_PITABuff', 'lupine', 'Enables/Disables Lupine / TalaTak Buffing.')
                    ImGui.SameLine()
                    Checkbox('Battle Shammy', 'xgv_ToggleMeleeMode', 'X-Melee',
                        'Enables/Disables Battle Shaman (Melee, Heals, Dots).')
                    Checkbox('Toggle Auras', 'xgv_ToggleAura', 'aura', 'Enables/Disables Aura.')
                    ImGui.SameLine()
                    Checkbox('Regen', ' xgv_Regen', 'regen', 'Enables/Disables Regen ("Regen1 Variable") Buffing.')
                    ImGui.SameLine()
                    local CampLabel3 = 'AA Shrink'
                    if ImGui.Button(CampLabel3) then mq.cmd('/alt act 9503') end

                end


                ImGui.EndTabItem()
            end


            -- #############################################################################################
            -- #############################################################################################
            -- #############################################################################################



            -- ==============  GROUP TAB =================
            if ImGui.BeginTabItem('Group') then
                Topbar()
                -- ImGuiCol.ButtonHovered
                local colorStyleCount = 0
                --ImGuiTableFlags.Resizable,
                --, ImGuiTableColumnFlags.WidthStretch
                -- , ImGuiTableFlags.SizingStretchProp
                ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, 0, 2)
                ImGui.BeginTable('Group1', 6,
                    bit32.bor(ImGuiTableFlags.Resizable, ImGuiTableFlags.Borders,
                        ImGuiTableFlags.ContextMenuInBody, TEXT_BASE_HEIGHT * 15, 0.0))

                ImGui.TableSetupColumn('Merc',
                    bit32.bor(ImGuiTableColumnFlags.NoResize, ImGuiTableColumnFlags.WidthFixed),
                    58, 1)
                ImGui.TableSetupColumn('Group',
                    bit32.bor(ImGuiTableColumnFlags.SizingFixedFit), -1.0, 2)
                ImGui.TableSetupColumn('  MT / MA',
                    bit32.bor(ImGuiTableColumnFlags.NoResize, ImGuiTableColumnFlags.WidthFixed)
                    , 67, 3)
                ImGui.TableSetupColumn('Grp Cmds',
                    bit32.bor(ImGuiTableColumnFlags.NoResize, ImGuiTableColumnFlags.WidthFixed), 68, 4)
                ImGui.TableSetupColumn('Exp', bit32.bor(ImGuiTableColumnFlags.NoResize, ImGuiTableColumnFlags.WidthFixed)
                    ,
                    -
                    1, 5)
                ImGui.TableSetupColumn('AA', bit32.bor(ImGuiTableColumnFlags.NoResize, ImGuiTableColumnFlags.WidthFixed)
                    , -1
                    , 6)

                ImGui.TableHeadersRow()
                ImGui.TableNextRow()
                -- ImGui.SetColumnWidth(4, 76) -- causing crash
                ImGui.TableSetColumnIndex(0)

                ImGui.PushStyleVar(ImGuiStyleVar.ItemSpacing, 2.0, 4.0)
                Merc = 'Suspend'
                if mq.TLO.Mercenary.State() == ('SUSPENDED') then
                    Merc = 'UnSuspend '
                end

                local cwidth1 = ImGui.GetColumnWidth()

                if ImGui.Button(Merc, cwidth1, 0) then
                    mq.cmd('/notify MMGW_ManageWnd MMGW_SuspendButton leftmouseup')
                end

                ImGui.TableNextColumn() -- ROW 1
                Groupmember(0) -- Group Member 0

                ImGui.TableNextColumn()
                -- local index = ImGui.GetColumnIndex()
                -- ImGui.SetColumnWidth(index, 76) -- causing crash

                local _var = 'xgv_Follow1'
                local colorStyleCount = 0

                if MQVAR(_var)() == 1 then
                    local cwidth4 = ImGui.GetColumnWidth()
                    local ButtonLabel = 'Follow on'
                    ImGui.PushStyleColor(ImGuiCol.Button, 0.3, 1, 0.1, 0.5)
                    colorStyleCount = colorStyleCount + 1
                    if ImGui.Button(ButtonLabel, cwidth4, 0) then mq.cmd('/dga all /cc follow ${Me.Name}') end
                    if ImGui.IsItemHovered() then ImGui.SetTooltip('Click to STOP group Follow Me.') end

                elseif MQVAR(_var)() == 0 then
                    local cwidth4 = ImGui.GetColumnWidth()
                    local ButtonLabel = 'Follow off'
                    ImGui.PushStyleColor(ImGuiCol.Button, 1, .2, 0.1, 0.9)
                    colorStyleCount = colorStyleCount + 1
                    if ImGui.Button(ButtonLabel, cwidth4, 0) then mq.cmd('/dga all /cc follow ${Me.Name}') end
                    if ImGui.IsItemHovered() then
                        ImGui.PushStyleColor(ImGuiCol.Button, 1, .2, 0.1, 0.9)
                        ImGui.SetTooltip('Click to START group Follow Me.')
                        colorStyleCount = colorStyleCount + 1
                    end

                end
                ImGui.PopStyleColor(colorStyleCount)
                ImGui.PopStyleVar()

                ImGui.TableNextColumn()
                GroupmemberExp(0)

                ImGui.TableNextRow() -- ROW 2
                ImGui.TableSetColumnIndex(0)

                ImGui.Text('== PH ==')

                ImGui.TableNextColumn()
                Groupmember(1) -- Group Member 1

                ImGui.TableNextColumn()
                local cwidth4 = ImGui.GetColumnWidth()
                if ImGui.Button('TO ME', cwidth4, 0) then mq.cmdf('/dgzexecute /nav id %s', mq.TLO.Me.ID()) end
                if ImGui.IsItemHovered() then
                    if ImGui.IsItemHovered() then ImGui.SetTooltip('Have ALL Move to you.') end
                end
                ImGui.TableNextColumn()
                GroupmemberExp(1)

                ImGui.TableNextRow() -- ROW 3
                ImGui.TableSetColumnIndex(0)

                if mq.TLO.Mercenary.State() == 'ACTIVE' then
                    local MercType = mq.TLO.Mercenary.Class.ShortName()
                    local MercClass1 = 'WAR'
                    local MercClass2 = 'ROG, CLR, WIZ'
                    if string.find(MercClass2, MercType) then
                        local MercStanceLabel = 'Balanced'
                        if mq.TLO.Mercenary.Stance() == MercStanceLabel then ImGui.PushStyleColor(ImGuiCol.Button, 0.3,
                                0.7,
                                0.1, 0.5)
                        end
                        if ImGui.Button(MercStanceLabel, cwidth1, 0) then
                            mq.cmd('/stance ', MercStanceLabel)
                        end
                        if mq.TLO.Mercenary.Stance() == MercStanceLabel then ImGui.PopStyleColor() end
                    end

                    if string.find(MercClass1, MercType) then
                        local MercStanceLabel = 'Aggressive'
                        if mq.TLO.Mercenary.Stance() == MercStanceLabel then ImGui.PushStyleColor(ImGuiCol.Button, 0.3,
                                0.7,
                                0.1, 0.5)
                        end
                        if ImGui.Button(MercStanceLabel, cwidth1, 0) then
                            mq.cmd('/stance ', MercStanceLabel)
                        end
                        if mq.TLO.Mercenary.Stance() == MercStanceLabel then ImGui.PopStyleColor() end
                    end
                end

                ImGui.TableSetColumnIndex(0)
                ImGui.TableNextColumn()
                Groupmember(2) -- Group Member 2
                ImGui.TableNextColumn()
                local cwidth4 = ImGui.GetColumnWidth()
                local ButtonLabel = 'MimicMe'
                local _var = 'xgv_MimmicMe'
                if MQVAR(_var)() == 1 then ImGui.PushStyleColor(ImGuiCol.Button, 0.2, .6, 0.0, 1) end
                if ImGui.Button(ButtonLabel, cwidth4, 0) then
                    mq.cmd('/groupinfo mimicme on|off')
                    mq.cmd('/varset xgv_MimmicMe ${NormalizeToggleValue[${Command2}, ${xgv_MimmicMe}]}')
                end
                if MQVAR(_var)() == 1 then ImGui.PopStyleColor() end
                if ImGui.IsItemHovered() then
                    if ImGui.IsItemHovered() then ImGui.SetTooltip('Enables / Disables mimmic command.  Group will do what you do.') end
                end
                ImGui.TableNextColumn()
                GroupmemberExp(2)

                ImGui.TableNextRow() -- ROW 4
                ImGui.TableSetColumnIndex(0)

                if mq.TLO.Mercenary.State() == 'ACTIVE' then
                    local MercType = mq.TLO.Mercenary.Class.ShortName()
                    local MercClass1 = 'WAR'
                    local MercClass2 = 'CLR'
                    local MercClass3 = 'ROG, WIZ'
                    if string.find(MercClass1, MercType) then
                        local MercStanceLabel = 'Assist'
                        if mq.TLO.Mercenary.Stance() == MercStanceLabel then ImGui.PushStyleColor(ImGuiCol.Button, 0.3,
                                0.7,
                                0.1, 0.5)
                        end
                        if ImGui.Button(MercStanceLabel, cwidth1, 0) then mq.cmd('/stance ', MercStanceLabel) end
                        if mq.TLO.Mercenary.Stance() == MercStanceLabel then ImGui.PopStyleColor() end
                    end

                    if string.find(MercClass2, MercType) then
                        local MercStanceLabel = 'Efficient'
                        if mq.TLO.Mercenary.Stance() == MercStanceLabel then ImGui.PushStyleColor(ImGuiCol.Button, 0.3,
                                0.7,
                                0.1, 0.5)
                        end
                        if ImGui.Button(MercStanceLabel, cwidth1, 0) then mq.cmd('/stance ', MercStanceLabel) end
                        if mq.TLO.Mercenary.Stance() == MercStanceLabel then ImGui.PopStyleColor() end
                    end

                    if string.find(MercClass3, MercType) then
                        local MercStanceLabel = 'Burn'
                        if mq.TLO.Mercenary.Stance() == MercStanceLabel then ImGui.PushStyleColor(ImGuiCol.Button, 0.3,
                                0.7,
                                0.1, 0.5)
                        end
                        if ImGui.Button(MercStanceLabel, cwidth1, 0) then mq.cmd('/stance ', MercStanceLabel) end
                        if mq.TLO.Mercenary.Stance() == MercStanceLabel then ImGui.PopStyleColor() end
                    end
                end

                ImGui.TableNextColumn()
                Groupmember(3) -- Group Member 3
                ImGui.TableNextColumn()
                ImGui.Text('== PH ==')

                ImGui.TableNextColumn()
                GroupmemberExp(3)

                ImGui.TableNextRow() -- ROW 5
                ImGui.TableSetColumnIndex(0)

                if mq.TLO.Mercenary.State() == 'ACTIVE' then
                    local MercType = mq.TLO.Mercenary.Class.ShortName()
                    local MercClasses = 'WAR, ROG, CLR, WIZ'
                    if string.find(MercClasses, MercType) then
                        local MercStanceLabel = 'Passive'
                        if mq.TLO.Mercenary.Stance() == MercStanceLabel then ImGui.PushStyleColor(ImGuiCol.Button, 1, 0.7
                                ,
                                0.1, 0.5)
                        end
                        if ImGui.Button(MercStanceLabel, cwidth1, 0) then mq.cmd('/stance ', MercStanceLabel) end
                        if mq.TLO.Mercenary.Stance() == MercStanceLabel then ImGui.PopStyleColor() end
                    end
                end

                ImGui.TableNextColumn()
                Groupmember(4) -- Group Member 4
                ImGui.TableNextColumn()
                local cwidth4 = ImGui.GetColumnWidth()
                ImGui.PushStyleColor(ImGuiCol.Button, 0.2, .6, 0.0, 1)
                if ImGui.Button('XGen All', cwidth4, 0) then mq.cmdf('/dgzexecute /mac xgen/xgen') end
                ImGui.PopStyleColor()
                if ImGui.IsItemHovered() then
                    if ImGui.IsItemHovered() then ImGui.SetTooltip('Starts XGen on ALL (except this one)') end
                end

                ImGui.TableNextColumn()
                GroupmemberExp(4)

                ImGui.TableNextRow() -- ROW 6
                ImGui.TableSetColumnIndex(0)

                if mq.TLO.Mercenary.State() == 'ACTIVE' then
                    local MercType = mq.TLO.Mercenary.Class.ShortName()
                    local MercClass2 = 'CLR'
                    if string.find(MercClass2, MercType) then
                        local MercStanceLabel = 'Reactive'
                        if mq.TLO.Mercenary.Stance() == MercStanceLabel then ImGui.PushStyleColor(ImGuiCol.Button, 0.3,
                                0.7,
                                0.1, 0.5)
                        end
                        if ImGui.Button(MercStanceLabel, cwidth1, 0) then mq.cmd('/stance ', MercStanceLabel) end
                        if mq.TLO.Mercenary.Stance() == MercStanceLabel then ImGui.PopStyleColor() end
                    end
                end


                ImGui.TableNextColumn()
                Groupmember(5)
                ImGui.TableNextColumn()
                local cwidth4 = ImGui.GetColumnWidth()
                ImGui.PushStyleColor(ImGuiCol.Button, 1, .0, 0.0, 1)
                if ImGui.Button('END All', cwidth4, 0) then mq.cmdf('/dgzaexecute /end') end
                ImGui.PopStyleColor()
                if ImGui.IsItemHovered() then
                    if ImGui.IsItemHovered() then ImGui.SetTooltip('Ends ALL Macros!') end
                end

                ImGui.TableNextColumn()
                GroupmemberExp(5) -- Group Member 5

                ImGui.PopStyleVar()
                ImGui.EndTable()
                ImGui.EndTabItem()
            end



            -- #############################################################################################
            -- #############################################################################################
            -- #############################################################################################



            -- ==============  ADMIN TAB =================
            if MQVAR('AdminModeOn')() == 1 then
                if ImGui.BeginTabItem('AdminTab') then

                    Topbar()

                    ImGui.Separator()
                    ImGui.Separator()

                    if xgen_running then

                        -- CHECKBOX Toggle Debug
                        AdminCheckbox('Debug', 'DebugOn', 'debug', 'Enables/Disables Debug.')
                        ImGui.SameLine()
                        -- CHECKBOX Toggle Assist Debug
                        AdminCheckbox('Assist Debug', 'DebugAOn', 'assistdebug', 'Enables/Disables Assist Debug.')
                        ImGui.SameLine()
                        -- CHECKBOX Toggle SETT Debug
                        AdminCheckbox('SETT Debug', 'SetDebug', 'setdebug', 'Enables/Disables SETT Debug.')
                        ImGui.SameLine()
                        -- CHECKBOX Toggle Attack Debug
                        AdminCheckbox('Attack Debug', 'AttackDebug', 'attackdebug', 'Enables/Disables Attack Debug.')
                        ImGui.Separator()
                        -- CHECKBOX Toggle Spell Debugs
                        AdminCheckbox('Spell Debug', 'SDebug', 'sdebug', 'Enables/Disables Spell Debug.')
                        ImGui.SameLine()
                        -- CHECKBOX Toggle Pull Debug
                        AdminCheckbox('Pull Debug', 'PDebug', 'pdebug', 'Enables/Disables Pull Debug.')
                        ImGui.SameLine()
                        -- CHECKBOX Toggle Sit Debug
                        AdminCheckbox('Sit Debug', 'SitDebug', 'sitdebug', 'Enables/Disables Sit Debug.')
                        ImGui.SameLine()
                        -- CHECKBOX Toggle Target Debug
                        AdminCheckbox('Target Debug', 'TargetDebug', 'targetdebug', 'Enables/Disables Target Debug.')

                        ImGui.Separator()
                        -- CHECKBOX Toggle Test Mode -- Did not change this one due to its double command output
                        local chkbxname = 'Test Mode' -- NAME OF CHECK BOX
                        local state = MQVAR('TestMode')() == 1 -- EDIT NAME IN ''
                        local cmdname = 'testmode' -- /admin name you type to do command
                        local mode = ImGui.Checkbox(chkbxname, state) -- NEVER EDIT
                        if mode ~= state then
                            if mode then mq.cmd('/admin', cmdname, 'on') else mq.cmd('/admin', cmdname, 'off') end
                            if mode then mq.cmd('/varset xgv_iAssistHealthPct ${If[${TestMode},100,98]}') else
                                mq.cmd('/varset xgv_iAssistHealthPct ${If[${TestMode},100,98]}')
                            end
                        end

                        ImGui.SameLine()
                        -- CHECKBOX Toggle GMA
                        AdminCheckbox('Toggle GMA', 'EnableSetAssist', 'togglesetgma', 'Enables/Disables Toggle GMA.')
                        ImGui.SameLine()
                        -- CHECKBOX Toggle GMT
                        AdminCheckbox('Toggle GMT', 'EnableSetTank', 'togglesetgmt', 'Enables/Disables Toggle GMT.')
                        ImGui.SameLine()
                        -- CHECKBOX Toggle GMT
                        AdminCheckbox('NAV Debug', 'NavDebug', 'navdebug', 'Enables/Disables Nav Debug.')

                        ImGui.Separator()
                        local CampLabel1 = 'Load HUD'
                        if ImGui.Button(CampLabel1) then mq.cmd('/cc loadhud') end

                        ImGui.SameLine()
                        local CampLabel2 = 'Lua GUI'
                        if ImGui.Button(CampLabel2) then mq.cmd('/lua gui') end

                        ImGui.SameLine()
                        Windowsizereset()
                        ImGui.SameLine()
                        local CampLabel3 = 'Diag Hud'
                        if ImGui.Button(CampLabel3) then mq.cmd('/admin diaghud') end
                        ImGui.SameLine()
                        local CampLabel = 'ObserverList'
                        if ImGui.Button(CampLabel) then mq.cmd('/admin o-list') end
                        local testbutton = 'Test Button'
                        if ImGui.Button(testbutton) then print(ImGui.GetFontSize() * 8) end
                        if ImGui.Button('Button1') then dn_Peers() end

                    end

                    ImGui.EndTabItem()
                end
            end




            -- #############################################################################################
            -- #############################################################################################
            -- #############################################################################################

            -- BARD Tab
            if mq.TLO.Me.Class.ShortName() == 'BRD' then
                if ImGui.BeginTabItem('BRD') then

                    Topbar()

                    ImGui.Separator()


                    -- New Row ================================================
                    ImGui.Separator()

                    -- CHECKBOX Twist
                    Checkbox('Twist', 'xgv_Twst1', 'twist', 'Turns song twisting On/Off.')

                    ImGui.SameLine()
                    -- CHECKBOX MEZZ
                    Checkbox('Mezz', 'xgv_ToggleMez1', 'mezz', 'Enable/Disable Mezzing.')

                    -- CHECKBOX Bellow
                    ImGui.SameLine()
                    Checkbox('Bellow', 'xgv_ToggleBellowOn', 'bellow', 'Enable/Disable Bellow.')

                    -- Selos CHECKBOX
                    ImGui.SameLine()
                    -- CHECKBOX Pull Greys
                    Checkbox('Selos', 'xgv_SupaSpeed', 'selos', 'Enable/Disable Selos on Tank.')

                    -- Selos CHECKBOX
                    ImGui.SameLine()
                    -- CHECKBOX Pull Greys
                    Checkbox('Safe Melodys', 'MelodySets', 'melodysets', 'Disable DPS songs when not in combat.')

                    -- TEXT INPUT BOX FOR NewMelody
                    ImGui.TextColored(1, 0, 0, 1, "Set up your melody and save it. Ex: 2 3 4 5 3 4 2 7 5")
                    Clickedstartmelody()
                    if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                        if ImGui.IsItemHovered() then ImGui.SetTooltip("Save Melody and Start singing if Twist is turned on!") end
                    end

                    ImGui.SameLine()
                    Clickedsavemelody()

                    if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                        if ImGui.IsItemHovered() then ImGui.SetTooltip("Save Melody and Start singing if Twist is turned on!") end
                    end
                    ImGui.SameLine()
                    ImGui.PushItemWidth(-110)
                    melodydata, _ = ImGui.InputText("Melody Numbers", melodydata)
                    if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                        if ImGui.IsItemHovered() then ImGui.SetTooltip("Set Gem Number of song you want to sing in order here.") end
                    end

                    -- CHECKBOX Toggle Auras

                    ImGui.Separator()
                    ImGui.TextColored(1, 1, 1, 1, 'AE Mezz#')
                    ImGui.SameLine()

                    local aem1 = MQVAR('xgv_AeMezCount')()
                    local aemslider = ImGui.SliderInt('##mezslider', aem1, 2, 6)
                    local storvar = aemslider
                    if aemslider ~= aem1 then
                        mq.cmd('/varset xgv_AeMezCount', aemslider)
                        mq.cmd("/cc storevar xgv_AeMezCount", storvar)
                    end
                    ImGui.PopItemWidth()



                    Checkbox('Toggle Auras', 'xgv_ToggleAura', 'aura', 'Enables/Disables Aura.')

                    ImGui.SameLine()
                    Checkbox('Toggle Dirge', 'xgv_AutoDirge', 'autodirge',
                        'Enables/Disables Dirge when no other dirge is up.')

                    ImGui.SameLine()
                    Checkbox('Auto Rallying Call', 'xgv_Rallyvar', 'autorally',
                        'Enables/Disables Auto Cast Rally Call on low mana during Manawatch wait.')



                    ImGui.EndTabItem()
                end
            end



            -- ###############################################################################################
            -- ###############################################################################################
            -- ###############################################################################################
            -- ###############################################################################################


            if mq.TLO.Me.Class.ShortName() == 'ENC' then
                if ImGui.BeginTabItem('ENC') then

                    Topbar()

                    ImGui.Separator()

                    -- New Row ================================================
                    ImGui.Separator()

                    -- CHECKBOX Mezzing
                    Checkbox('Mezz', 'xgv_ToggleMez1', 'mezz', 'Enable/Disable Mezzing.')
                    ImGui.SameLine()
                    -- CHECKBOX Debuffs
                    Checkbox('Debuffs', 'xgv_debuffz', 'debuffs', 'Enable/Disable Debuffs.')
                    -- CHECKBOX Composite Reinforcement
                    ImGui.SameLine()
                    Checkbox('Comp Ref', 'xgv_ToggleCompRef', 'compref', 'Enables/Disables Composite Reinforcement.')
                    ImGui.SameLine()
                    -- CHECKBOX Buffs
                    Checkbox('Buffs', 'xgv_bufz', 'buffs', 'Enable/Disable Buffs.')
                    -- CHECKBOX Nukes
                    ImGui.SameLine()
                    Checkbox('Nukes', 'xgv_ToggleDPSNukes', 'nukes', 'Enables/Disables Nukes.')
                    -- CHECKBOX Self Rune
                    Checkbox('Self Runes', 'xgv_SRune', 'srune', 'Enable/DisableSelf Runes.')
                    ImGui.SameLine()
                    -- CHECKBOX Tank Rune 1
                    Checkbox('Tank Runes', 'xgv_RuneTank', 'trune',
                        "Enable/Disable " .. mq.TLO.Macro.Variable('TankBuff2')() .. " on Tank.")
                    ImGui.SameLine()
                    -- CHECKBOX Tank Rune 2
                    Checkbox('Tank Rune2', 'xgv_RuneTank2', 'trune2',
                        "Enable/Disable " .. mq.TLO.Macro.Variable('TRune')() .. " on Tank.")
                    ImGui.SameLine()
                    -- CHECKBOX Dots
                    Checkbox("Dot's", 'xgv_ToggleDots', 'dots', "Enable/Disable Dot's.")
                    -- CHECKBOX Dizy Line Stuns
                    Checkbox('Dizy Stuns', 'xgv_ToggleStuns', 'stuns', 'Enables/Disables Dizy Line Stuns.')
                    -- CHECKBOX Color Line Stuns
                    ImGui.SameLine()
                    Checkbox('Color Stuns', 'xgv_ToggleStuns2', 'stuns2', 'Enables/Disables Color Line Stuns.')

                    ImGui.Separator()
                    ImGui.TextColored(1, 1, 1, 1, 'AE Mezz#')
                    ImGui.SameLine()

                    local aem1 = MQVAR('xgv_AeMezCount')()
                    local aemslider = ImGui.SliderInt('##mezslider', aem1, 2, 6)
                    local storvar = aemslider
                    if aemslider ~= aem1 then
                        mq.cmd('/varset xgv_AeMezCount', aemslider)
                        mq.cmd("/cc storevar xgv_AeMezCount", storvar)
                    end


                    ImGui.Separator()

                    ImGui.Text('Select either Mindslash warp ect.. set or Poly set nuke lines.')

                    local MindLabel = 'MindSet OFF';
                    if mq.TLO.Macro.Variable('xgv_NukeSet')() == 1 then ImGui.PushStyleColor(ImGuiCol.Button, 0.2, .6
                            , 0.0, 1);
                    end
                    if mq.TLO.Macro.Variable('xgv_NukeSet')() == 1 then MindLabel = 'MindSet ON'; end
                    if ImGui.SmallButton(MindLabel) then mq.cmd('/cc nukeset'); end
                    if mq.TLO.Macro.Variable('xgv_NukeSet')() == 1 then ImGui.PopStyleColor(); end

                    ImGui.SameLine()
                    local PolyLabel = 'PolySet OFF';
                    if mq.TLO.Macro.Variable('xgv_NukeSet')() == 0 then ImGui.PushStyleColor(ImGuiCol.Button, 0.2, .6,
                            0.0, 1)
                    end
                    if mq.TLO.Macro.Variable('xgv_NukeSet')() == 0 then PolyLabel = 'MindSet ON'; end
                    if ImGui.SmallButton(PolyLabel) then mq.cmd('/cc nukeset'); end
                    if mq.TLO.Macro.Variable('xgv_NukeSet')() == 0 then ImGui.PopStyleColor(); end

                    ImGui.EndTabItem()
                end
            end


            -- #############################################################################################
            -- #############################################################################################
            -- #############################################################################################


            -- ==============  Pull TAB =================
            if ImGui.BeginTabItem('Pull/Move') then
                if ImGui.BeginTable('PullsTable', 2,
                    bit32.bor(ImGuiTableFlags.Borders, ImGuiTableFlags.SizingStretchProp,
                        ImGuiTableFlags.ContextMenuInBody, TEXT_BASE_HEIGHT * 15, 0.0)) then
                    ImGui.TableSetupColumn('Engage Options')
                    ImGui.TableSetupColumn('Pull Options')
                    ImGui.TableHeadersRow()


                    -- COLUMN 0 ROW 1
                    ImGui.TableNextRow()
                    ImGui.TableSetColumnIndex(0)

                    ImGui.PushItemWidth(-95)

                    local camprad = MQVAR('xgv_GrpCmp')()
                    local campradslider = ImGui.SliderFloat('CampRad ', camprad, 12, 200)
                    local storvar = campradslider
                    if campradslider ~= camprad then
                        mq.cmd('/varset xgv_GrpCmp', campradslider)
                        mq.cmd("/cc storevar xgv_GrpCmp", storvar)
                    end
                    if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                        if ImGui.IsItemHovered() then ImGui.SetTooltip("Sets your Camp Radius Recomend (dps < 80 | Main Tanks > 80).") end
                    end

                    ImGui.PopItemWidth()

                    local CampRadNumber = MQVAR('xgv_GrpCmp')()
                    ImGui.SameLine()
                    ImGui.TextColored(1, 0, 0, 1, CampRadNumber)

                    -- COLUMN 1 ROW 1
                    ImGui.TableSetColumnIndex(1)
                    Checkbox('Style', 'PullStyle', 'pullstyle', 'Sets Pull Style. 1.Everywhere, 2.Set Radius')

                    ImGui.SameLine()
                    local Radius = MQVAR('Radius')()
                    if MQVAR('PullStyle')() == 1 then
                        ImGui.TextColored(1, 1, 0.1, 1, 'Radius ' .. Radius)
                    else ImGui.TextColored(1, 1, 0.1, 1, 'All Over')
                    end
                    if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                        if ImGui.IsItemHovered() then ImGui.SetTooltip("Set Radius distance for pulling") end
                    end

                    ImGui.SameLine()
                    -- CHECKBOX Pull Greys
                    Checkbox('Pull Greys', 'PullGREY', 'pullgrey', 'Enables/Disables Pulling of Grey Cons..')

                    -- ROW 2
                    ImGui.TableNextRow()
                    --COLUMN 0 ROW 2
                    ImGui.TableSetColumnIndex(0)
                    ImGui.PushItemWidth(-95)
                    local maxd1 = MQVAR('maxdslider')()
                    local maxdslider = ImGui.SliderFloat('   MaxD ', maxd1, 0.1, 1.00)
                    local storvar = maxdslider
                    if maxdslider ~= maxd1 then
                        mq.cmd('/varset maxdslider', maxdslider)
                        mq.cmd("/cc storevar maxdslider", storvar)
                    end
                    if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                        if ImGui.IsItemHovered() then ImGui.SetTooltip("Sets your Fighting distance from NPC, Updates with Target.") end
                    end

                    local MaxDNumber = mq.TLO.Target.MaxRangeTo()
                        MQVAR('maxdslider')()
                    ImGui.SameLine()
                    -- ImGui.TextColored(1, 0, 0, 1, MaxDNumber)
                    ImGui.TextColored(1, 0, 0, 1, string.format("%.2f", MaxDNumber))
                    ImGui.PopItemWidth()


                    --COLUMN 1 ROW 2
                    ImGui.TableSetColumnIndex(1)
                    ImGui.PushItemWidth(-95)
                    local scatter = MQVAR('SNum')()
                    local scatterslider = ImGui.SliderFloat('Scatter ', scatter, 0.1, 11.0)
                    local storvar = scatterslider
                    if scatterslider ~= scatter then
                        mq.cmd('/varset SNum', scatterslider)
                        mq.cmd("/cc storevar SNum", storvar)
                    end
                    if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                        if ImGui.IsItemHovered() then ImGui.SetTooltip("Sets your Scatter range on return to camp.") end
                    end

                    local snum = MQVAR('SNum')()
                    ImGui.SameLine()
                    -- ImGui.TextColored(1, 0, 0, 1, MaxDNumber)
                    ImGui.TextColored(1, 0, 0, 1, string.format("%.2f", snum))
                    ImGui.PopItemWidth()


                    ImGui.EndTable() -- END OF TABLE IS HERE!!!!!!!!!!!!!!!!!!!!!
                end
                -- CHECKBOX PULLER
                ImGui.Separator()
                Checkbox('Puller', 'Pulling1', 'pullmode', 'Check to Enable Pulling')
                -- CHECKBOX HUNTER
                ImGui.SameLine()
                Checkbox('Hunter', 'xgv_ToggleHunter1', 'hunter', 'Check to Enable Hunter Mode')
                -- CHECKBOX PULL MOVE
                ImGui.SameLine()
                Checkbox('Pull Move', 'xgv_TogglePullMove', 'pmove',
                    'Check to Enable moving to target. or Just stand there and use spell to pull')
                -- CHECKBOX PULL NUKE
                ImGui.SameLine()
                Checkbox('Pull Nuke', 'xgv_TogglePullNukes', 'pnuke', 'Check to Using Pulling Spell / Ability')
                -- BUTTON MAKECAMP
                ImGui.SameLine()
                local MakeCamp = 'MakeCamp'
                if ImGui.SmallButton(MakeCamp) then mq.cmdf('/cc makecamp') end


                ImGui.PushStyleVar(ImGuiStyleVar.ItemSpacing, 3.0, 2.5)
                ImGui.PushItemWidth(-175)
                -- TEXT INPUT BOX FOR TEMP IGNORE!!!!!
                ImGui.TextColored(1, 0, 0, 1, 'Add names for Perminant ignore list.')
                data, _ = ImGui.InputText("##permtext", data)
                ImGui.SameLine()
                local clickedperm = ImGui.Button("Save##perm")
                if clickedperm then
                    -- print('output is ', data)
                    mq.cmd('/cc permignore add ', data)
                    data = ''
                end
                ImGui.SameLine()
                local clickedperm = ImGui.Button("Remove")

                if clickedperm then
                    -- print('output is ', data)
                    mq.cmd('/cc permignore remove ', data)
                    data = ''
                end
                if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                    if ImGui.IsItemHovered() then ImGui.SetTooltip('Removes name from Perm Ignore List') end
                end

                ImGui.SameLine()
                if ImGui.Button('AddTarget') then mq.cmdf('/cc permignore add', mq.TLO.Target()) end
                if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                    if ImGui.IsItemHovered() then ImGui.SetTooltip('Adds Current Target to Perm Ignore List') end
                end


                ImGui.TextColored(1, 0, 0, 1, 'Add names for Temporary ignore list.')
                data2, _ = ImGui.InputText("##temptext", data2)
                ImGui.SameLine()
                local clickedtemp = ImGui.Button("Save##temp")
                if clickedtemp then
                    print('output is ', data2)
                    mq.cmd('/cc ignore ', data2)
                    data2 = ''
                end
                ImGui.SameLine()
                local clickedcleartemp = ImGui.Button("Clear")

                if clickedcleartemp then
                    mq.cmd('/cc clear ignore')
                    data = ''
                end
                if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                    if ImGui.IsItemHovered() then ImGui.SetTooltip('Clears Temp Ignore List.') end
                end

                ImGui.PopItemWidth()

                local clickedTignorelist = ImGui.Button("List Temp")
                if clickedTignorelist then
                    mq.cmd('/cc list')
                end

                ImGui.SameLine()
                local clickedPignorelist = ImGui.Button("List Perm")
                if clickedPignorelist then
                    mq.cmd('/cc updateplist')
                end
                ImGui.PopStyleVar()
                ImGui.EndTabItem()

            end
        end
        ImGui.PopStyleVar(2)
        ImGui.EndTabBar()
        ImGui.PopStyleColor(2)
        -- END OF DRAW DO NOT EDIT BELOW
        ImGui.End()

        -- SECOND WINDOW POPOUT
        -- #############################################################################################
        -- #############################################################################################
        -- #############################################################################################



        if VariablesTabPopout and openGUI2 then
            local is_drawn = true
            openGUI2, is_drawn = ImGui.Begin('Variables', openGUI2)


            ImGui.TextColored(1, 0, 0, 1, 'BYOS:')
            ImGui.SameLine()
            ImGui.TextColored(1, 1, 1, 1, 'Type the')
            ImGui.SameLine()
            ImGui.TextColored(1, 1, 0, 1, ' Variable ')
            ImGui.SameLine()
            ImGui.TextColored(1, 1, 1, 1, '&')
            ImGui.SameLine()
            ImGui.TextColored(1, 0, 0, 1, '"')
            ImGui.SameLine()
            ImGui.TextColored(1, 1, 0, 1, 'Spell Name')
            ImGui.SameLine()
            ImGui.TextColored(1, 0, 0, 1, '"')
            ImGui.SameLine()
            ImGui.TextColored(1, 1, 1, 1, ' save & restart')

            ImGui.PushItemWidth(-60)

            ---@diagnostic disable-next-line: cast-local-type
            ByosNewSpell = ImGui.InputText('##ByosNewSpell', ByosNewSpell)
            ImGui.PopItemWidth()
            ImGui.SameLine()
            if ImGui.SmallButton('Save') then
                mq.cmd('/cc byos', ByosNewSpell)
                mq.cmd('/varset ', ByosNewSpell)
                ByosNewSpell = 'Variable "NewSpellName"'
            end


            if ImGui.BeginTable('SpellsAndVars', 6,
                bit32.bor(ImGuiTableFlags.ScrollX, ImGuiTableFlags.Resizable, ImGuiTableFlags.Borders,
                    ImGuiTableFlags.SizingStretchProp, ImGuiTableFlags.NoPadOuterX, TEXT_BASE_HEIGHT * 15, 0.0)) then
                ImGui.TableSetupColumn('Variable', bit32.bor(ImGuiTableColumnFlags.WidthStretch), -1.0, 1)
                ImGui.TableSetupColumn('Spell Name', bit32.bor(ImGuiTableColumnFlags.WidthStretch), -1.0, 2)
                ImGui.TableSetupColumn('Variable', bit32.bor(ImGuiTableColumnFlags.WidthStretch), -1.0, 3)
                ImGui.TableSetupColumn('Spell Name', bit32.bor(ImGuiTableColumnFlags.WidthStretch), -1.0, 4)
                ImGui.TableSetupColumn('Variable', bit32.bor(ImGuiTableColumnFlags.WidthStretch), -1.0, 5)
                ImGui.TableSetupColumn('Spell Name', bit32.bor(ImGuiTableColumnFlags.WidthStretch), -1.0, 6)

                -- ImGui.TableSetupScrollFreeze(0, 1)
                ImGui.TableHeadersRow()

                local spellvar = MQVAR('luavars')()
                local spells = MQVAR('luavars')()
                local spellvarstable = mysplit(spellvar, "|")
                local spellstable = mysplit(spells, "|")
                ImGui.TableNextRow()
                ImGui.TableSetColumnIndex(0)

                for i = 1, math.min(#spellvarstable, #spellstable) do

                    if mq.TLO.Me.AltAbilityReady(spellvarstable[i])() and
                        mq.TLO.Me.AltAbility(spellvarstable[i])()
                        or
                        mq.TLO.Me.CombatAbilityReady(spellvarstable[i])() and
                        mq.TLO.Me.CombatAbility(spellvarstable[i])() or
                        mq.TLO.Me.SpellReady(spellvarstable[i])() and mq.TLO.Me.Spell(spellvarstable[i])() then
                        ImGui.TextColored(0, 1, 0, 1, spellvarstable[i])
                    elseif mq.TLO.Macro.Variable(spellvarstable[i])() then
                        ImGui.TextColored(1, 1, 1, 1, spellvarstable[i])
                    else
                        ImGui.TextColored(1, 0, 0, 1, spellvarstable[i])
                    end
                    ImGui.TableNextColumn()
                    i = i + 1
                end
                ImGui.EndTable()
            end

            ImGui.End()
        end
    end


    if NameTabPopout and openGUI3 then
        local is_drawn = true
        openGUI3, is_drawn = ImGui.Begin('Named List', openGUI3)
        local tablename = 'Named List'


        if ImGui.BeginTable(tablename, 4,
            bit32.bor(ImGuiTableFlags.Resizable, ImGuiTableFlags.Borders, ImGuiTableFlags.SizingStretchProp,
                ImGuiTableFlags.RowBg)) then

            ImGui.TableSetupColumn('Named -- Click to Run To')
            ImGui.TableSetupColumn('Health')
            ImGui.TableSetupColumn('Direction')
            ImGui.TableSetupColumn('Distance')
            if ImGui.IsMouseDown(ImGuiMouseButton.Right) then
                if ImGui.IsItemHovered() then ImGui.SetTooltip('Failure: Row 1 does nto exist means your in a zone not in the Database, Its Normal!') end
            end

            ImGui.TableHeadersRow()
            ImGui.TableNextRow()
            ImGui.TableSetColumnIndex(0)

            -- ImGui.Separator()

            local namelist = MQVAR('xgv_namelist')()
            local nametable = mysplit(namelist, "|")
            for i = 1, math.min(#nametable) do
                local mqsntablei = mq.TLO.Spawn(nametable[i])

                if nametable[i] ~= 'abcd' then

                    if mqsntablei() then
                        ImGui.TableSetColumnIndex(0)
                        if ImGui.Selectable(nametable[i]) then
                            mq.cmd('/nav id', mqsntablei())
                        end
                    else
                        ImGui.TableSetColumnIndex(0)
                        ImGui.TextColored(1, 0, 0, 1, nametable[i])
                    end

                    ImGui.TableSetColumnIndex(1)
                    if mqsntablei() then
                        ImGui.Text(mq.TLO.Spawn(nametable[i]).PctHPs() .. ' %')
                    else
                        ImGui.Text('N/A')
                    end

                    ImGui.TableSetColumnIndex(2)
                    if mqsntablei() then
                        ImGui.Text(mq.TLO.Spawn(nametable[i]).Heading())
                    else
                        ImGui.Text('N/A')
                    end

                    ImGui.TableSetColumnIndex(3)
                    if mqsntablei() then
                        local dist = mq.TLO.Spawn(nametable[i]).Distance()
                        ImGui.Text(string.format("%.2f", dist))
                    else
                        ImGui.Text('N/A')
                    end

                end
                ImGui.TableNextRow()
                i = i + 1
            end
            ImGui.EndTable()
        end

        ImGui.End()
    end



    if RaidPopout and openGUI4 then
        local is_drawn = true
        openGUI4, is_drawn = ImGui.Begin('Raid Members', openGUI4)
        local tablename = 'RaidMembers'
        local state = mq.TLO.Raid.Members()
        if MQVAR('TestMode')() == 1 then
            local state = 54
        end
        if ImGui.BeginTable('Raid Members', 4,
            bit32.bor(ImGuiTableFlags.Resizable, ImGuiTableFlags.Borders,
                ImGuiTableFlags.SizingStretchProp, ImGuiTableFlags.RowBg)) then
            ImGui.TableSetupColumn('Row 1', ImGuiTableColumnFlags.None, -1.0, 1)
            ImGui.TableSetupColumn('Row 2', ImGuiTableColumnFlags.None, -1.0, 2)
            ImGui.TableSetupColumn('Row 3', ImGuiTableColumnFlags.None, -1.0, 3)
            ImGui.TableSetupColumn('Row 4', ImGuiTableColumnFlags.None, -1.0, 4)
            ImGui.PushStyleVar(ImGuiStyleVar.ItemSpacing, 1.0, 1.0)
            ImGui.TableHeadersRow()
            ImGui.TableNextRow()
            for x = 1, 12 do
                -- print(x)
                ImGui.SetWindowFontScale(.75)
                ImGui.TableNextColumn()
                for i = 1, 54 do
                    -- print(i)

                    if mq.TLO.Raid.Member(i).Group() == x and mq.TLO.Spawn(mq.TLO.Raid.Member(i)()).Type() == 'Corpse' then

                        if ImGui.IsMouseReleased(ImGuiMouseButton.Left) and ImGui.IsItemHovered() then
                            ImGui.TextColored(1, 0, 0, 1, mq.TLO.Spawn(mq.TLO.Raid.Member(i)()).Name())
                            mq.cmdf('/target id "%d"', mq.TLO.Spawn(mq.TLO.Raid.Member(i)()).ID())
                            mq.delay(300)
                            mq.cmdf('/alt activate ${Res}')
                            mq.delay(200)

                        end
                    end

                    if mq.TLO.Raid.Member(i).Group() == x and mq.TLO.Raid.Member(i).Targetable() ~= nil then
                        local pctHPs = mq.TLO.Raid.Member(i).PctHPs()
                        local ratioHPs = pctHPs / 100

                        ImGui.PushStyleColor(ImGuiCol.PlotHistogram, 1 - ratioHPs, ratioHPs, 0, 0.5)
                        ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
                        ImGui.ProgressBar(math.abs(mq.TLO.Raid.Member(i).PctHPs() * 0.01), -1, 14,
                            mq.TLO.Raid.Member(i)() .. pctHPs .. '%')

                        if ImGui.IsMouseReleased(ImGuiMouseButton.Left) and ImGui.IsItemHovered() and
                            mq.TLO.Raid.Member(i).Targetable() then

                            mq.cmdf('/target id "%d"', mq.TLO.Raid.Member(i).ID())
                        end
                        ImGui.PopStyleColor(2)
                    end

                    if mq.TLO.Raid.Member(i).Group() == x and mq.TLO.Raid.Member(i).Targetable() == nil then
                        ImGui.TextColored(1, 0, 0, 1, mq.TLO.Spawn(mq.TLO.Raid.Member(i)()).Name())
                        if ImGui.IsMouseReleased(ImGuiMouseButton.Left) and ImGui.IsItemHovered() then
                            mq.cmdf('/target "%s"', mq.TLO.Spawn(mq.TLO.Raid.Member(i)()).Name())
                        end
                        --elseif mq.TLO.Raid.Member(i).Group() == x and not and mq.TLO.Raid.Member(i).Targetable() then
                        --  ImGui.Text(mq.TLO.Raid.Member(i).Name())
                        --end
                    end

                    if MQVAR('TestMode')() == 1 and i <= 6 then
                        ImGui.Text('Test ' .. i)
                    end


                end

                ImGui.SetWindowFontScale(1)
            end
            ImGui.PopStyleVar()
            ImGui.EndTable()

            --ImGui.Button('Rez')
            --ImGui.SameLine()
            --ImGui.Button('Call')
            --ImGui.SameLine()
            --ImGui.Button('Heal1')
            --ImGui.SameLine()
            --ImGui.Button('Heal2')

        end
        ImGui.End()
    end
    mq.doevents()

    
    if true and openGUI5 then
        ImGui.SetWindowSize(430, 700, ImGuiCond.Always)
        local is_drawn = true
        openGUI5, is_drawn = ImGui.Begin('Chat window', openGUI5)
        if ImGui.BeginTable('Chat', 1,
            bit32.bor(ImGuiTableFlags.ScrollY, ImGuiTableFlags.ScrollX, ImGuiTableFlags.Resizable,
                ImGuiTableFlags.NoPadOuterX, TEXT_BASE_HEIGHT * 15, 0.0)) then

            ImGui.TableSetupColumn('Chat 1', ImGuiTableColumnFlags.None, -1, 1)
            ImGui.TableHeadersRow()
            ImGui.TableNextRow()
            ImGui.TableNextColumn()

            if is_drawn then
                ImGui.Text(textToDraw)
                ImGui.TableNextRow()
                i = i+1
            end

            ImGui.EndTable()
        end
        local function event_say(line, arg1, arg2)
            -- print(arg1 .. '' .. arg2)
            textToDraw= string.format('%s %s', arg1, arg2)
        end

        mq.event('mysay', '#1# says, #2#', event_say)

        mq.doevents()
        ImGui.End()

    end

end

-- ###############################################################################################
-- ###############################################################################################
-- ########.............########..####################..######........############################
-- ########..###################..#..#################..######..#####..###########################
-- ########..###################..###..###############..######..#######..#########################
-- ########..###################..#####..#############..######..#########..#######################
-- ########..###################..#######..###########..######..###########..#####################
-- ########...........##########..#########..#########..######..###########..#####################
-- ########..###################..###########..#######..######..##########..######################
-- ########..###################..#############..#####..######..##########..######################
-- ########..###################..###############..###..######..########..########################
-- ########..###################..#################..#..######..######..##########################
-- ########.............########..####################..######........############################
-- ###############################################################################################
-- ###############################################################################################

mq.imgui.init('window', imguicallback)


while openGUI or openGUI2 or openGUI3 or openGUI4 or openGUI5 do
    mq.delay(1000)
end
