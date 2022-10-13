SCRIPTLeader = ""

-- -----------------------------------------------------------------
-- -----------------------------------------------------------------
-- mcmerc macro LUA Great Divide Restless Assault mission automation
-- -----------------------------------------------------------------
-- -----------------------------------------------------------------
mq = require('mq')

-- general GUI variables ~=
-- ----------------------------------
local GUI_script = true
local GUI_script_shouldDraw = true
local GUI_script_base_btn_height = 22
local GUI_mcmerc_textcolor = {
  w = { r = 1, g = 1, b = 1 },
  y = { r = 1, g = 1, b = 0 },
  g = { r = 0, g = 1, b = 0 },
  p = { r = 1, g = 0, b = 1 },
  t = { r = 0.5, g = 0.8, b = 0.9 },
  o = { r = 1, g = 0.6, b = 0.1 },
  r = { r = 1,  g = 0, b = 0 }
}
local GUI_mcmerc_textalpha =  0.75
local GUI_mcmerc_base_btn_height = 22

-- script general variables
-- ----------------------------------
local SCRIPTPaused = false
local SCRIPTCurrentState = 0
local SCRIPTState = { [0] = 'Stopped', [1] = 'Running', [2] = 'Paused', [3] = 'Finished' }
local SCRIPTCurrentStep = 0
local SCRIPTStep = {}
local SCRIPTWaitTimer = os.time()
local SCRIPTLastZoned = mq.TLO.Me.LastZoned.Raw()
local SCRIPTMoveCalledID = 0
local SCRIPTAssistCalledID = 0
local SCRIPTMainTank = mq.TLO.Me.Name()

-- script specific variables
-- ----------------------------------
local TrashAdd1 = 0
local TrashAdd2 = 0
local TrashAdd3 = 0
local StepNamed = 0
local StepAdd = 0
local StepNearest = 0
local StepRhinoAdd = 0
local StepRhinoLastEmote = 0
local StepRhinoNextRelocation
local StepGrondoBurn = true
local StepGrondoBurnCalled
local StepNarandiSplits = {}
local StepNarandiSplitsN
local StepNarandiCurrentCopy
local StepNarandiLowestGap
local StepNarandiCopyLocked
local StepNarandiManual = false
local StepNarandiManualCopy = 1

-- ----------------------------------
-- draws script main tab
-- ----------------------------------
local SCRIPTDrawMainTab = function()

  if ImGui.BeginTabItem('Main') then

    ImGui.Columns(2)
    ImGui.Text('Leading: ')
    ImGui.SameLine()
    ImGui.TextColored(GUI_mcmerc_textcolor['t'].r, GUI_mcmerc_textcolor['t'].g, GUI_mcmerc_textcolor['t'].b, GUI_mcmerc_textalpha, SCRIPTLeader)	
    ImGui.Text('Status: ')
    ImGui.SameLine()
    ImGui.TextColored(GUI_mcmerc_textcolor['y'].r, GUI_mcmerc_textcolor['y'].g, GUI_mcmerc_textcolor['y'].b, GUI_mcmerc_textalpha, SCRIPTState[SCRIPTCurrentState])	
    ImGui.NextColumn()
    if ImGui.Button('PAUSE', 70, GUI_script_base_btn_height) then
      if SCRIPTCurrentState == 1 then
       SCRIPTCurrentState = 2
	  else
        if SCRIPTCurrentState == 2 then
          SCRIPTCurrentState = 1
		end
	  end
	end
    ImGui.SameLine()
    if ImGui.Button('END', 50, GUI_script_base_btn_height) then
      SCRIPTCurrentState = 0
	end
    ImGui.Columns()
    ImGui.Separator()
  
    ImGui.Text('Step:')
    ImGui.SameLine()
    ImGui.TextColored(GUI_mcmerc_textcolor['y'].r, GUI_mcmerc_textcolor['y'].g, GUI_mcmerc_textcolor['y'].b, GUI_mcmerc_textalpha, tostring(SCRIPTCurrentStep)..','..tostring(SCRIPTStep[SCRIPTCurrentStep].section)..','..tostring(SCRIPTStep[SCRIPTCurrentStep].iteration)..' -')	
    ImGui.SameLine()
    if SCRIPTCurrentStep then
      ImGui.TextColored(GUI_mcmerc_textcolor['y'].r, GUI_mcmerc_textcolor['y'].g, GUI_mcmerc_textcolor['y'].b, GUI_mcmerc_textalpha, SCRIPTStep[SCRIPTCurrentStep].desc)	
	else
      ImGui.TextColored(GUI_mcmerc_textcolor['y'].r, GUI_mcmerc_textcolor['y'].g, GUI_mcmerc_textcolor['y'].b, GUI_mcmerc_textalpha, ' Not started')	
	end

    ImGui.EndTabItem()
  end

end

-- ----------------------------------
-- draws script options tab
-- ----------------------------------
local SCRIPTDrawOptionsTab = function()

  if ImGui.BeginTabItem('Options') then
    StepGrondoBurn = ImGui.Checkbox('Burn Grondo first', StepGrondoBurn)
    ImGui.Separator()
	
	ImGui.Text('Narandi manual copy target override')
    StepNarandiManual = ImGui.Checkbox('Manual pick', StepNarandiManual)
    StepNarandiManualCopy = ImGui.RadioButton('1##Narandi', StepNarandiManualCopy, 1)
    ImGui.SameLine()
    StepNarandiManualCopy = ImGui.RadioButton('2##Narandi', StepNarandiManualCopy, 2)
    ImGui.SameLine()
    StepNarandiManualCopy = ImGui.RadioButton('3##Narandi', StepNarandiManualCopy, 3)
    ImGui.SameLine()
    StepNarandiManualCopy = ImGui.RadioButton('4##Narandi', StepNarandiManualCopy, 4)
	
    if ImGui.Button('DPS NOW', 85, GUI_mcmerc_base_btn_height) then
      mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI DPS ON')
      mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI DPS NOW')
	end
    ImGui.SameLine()
    if ImGui.Button('RESTLESS HERO ASSIST', 145, GUI_mcmerc_base_btn_height) then
      mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI ASSIST MANUAL a_restless_hero')
	end
	
    ImGui.EndTabItem()
  end
  
end

-- ----------------------------------
-- draws mission console
-- ----------------------------------
local SCRIPTDrawConsole = function()

  GUI_script, GUI_script_shouldDraw = ImGui.Begin('Restless Assault mission script console', GUI_script)

  ImGui.SetWindowFontScale(0.8)

  if GUI_script_shouldDraw and mq.TLO.Macro.CurLine() then

    if ImGui.BeginTabBar('SCRIPT_tabbar') then
      SCRIPTDrawMainTab()
      SCRIPTDrawOptionsTab()
	  ImGui.EndTabBar()
	end
	
  end
 
 ImGui.End()

end

-- ----------------------------------
-- script auxiliary functions
-- ----------------------------------

-- Navigates to a mob until distance < assist distance keeping the group in range and calls assist when close enough
-- Increases step section counter when mob despawns or is dead
-- ----------------------------------
local DisposeMob = function(mobID)

  if not mq.TLO.Spawn(mobID)() or mq.TLO.Spawn(mobID).Dead() then
    SCRIPTMoveCalledID = 0
    SCRIPTAssistCalledID = 0
    SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
  else 
    if SCRIPTAssistCalledID ~= mobID then
      if mq.TLO.Spawn(mobID).Distance()<=mq.TLO.Macro.Variable('AttackOnMinDistance')() then
        mq.cmd.cecho('\awConsole:\ay +SILENT MOVE OFF')
        SCRIPTMoveCalledID = 0
        mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI ASSIST MANUAL '..mobID)
        SCRIPTAssistCalledID = mobID
      else
	    if SCRIPTMoveCalledID == 0 then
          if mq.TLO.SpawnCount('PC radius 100')() + mq.TLO.SpawnCount('MERCENARY radius 155')() == mq.TLO.Group.GroupSize() and not mq.TLO.Me.Casting.ID() then
            mq.cmd.cecho('\awConsole:\ay +SILENT MOVE ID '..tostring(mobID))
            SCRIPTMoveCalledID = mobID
	      end
	    else
          if mq.TLO.SpawnCount('PC radius 250')() + mq.TLO.SpawnCount('MERCENARY radius 350')() ~= mq.TLO.Group.GroupSize() then
            mq.cmd.cecho('\awConsole:\ay +SILENT MOVE OFF')
            SCRIPTMoveCalledID = 0
		  else
            if not mq.TLO.Macro.Variable('MoveActive')() then
              if mq.TLO.SpawnCount('PC radius 100')() + mq.TLO.SpawnCount('MERCENARY radius 155')() == mq.TLO.Group.GroupSize() and os.time() > SCRIPTWaitTimer then
                SCRIPTMoveCalledID = 0
				SCRIPTWaitTimer = os.time() + 2
			  end
		    end
		  end
		end
	  end
	end
  end

end

-- Retrieves from the event data list the last time an event trigger pattern has been activated
-- ----------------------------------
local MonitorEvent = function(event)

  local n = 1
  local acttime = nil
  
  while n <= mq.TLO.Macro.Variable('EVENTEventDataListN')() do
    if mq.TLO.Macro.Variable('EVENTEventDataList['..tostring(n)..',1]')() == event and mq.TLO.Macro.Variable('EVENTEventDataList['..tostring(n)..',2]')() == 'PTT' then
	  acttime = mq.TLO.Macro.Variable('EVENTEventDataList['..tostring(n)..',4]')()
      n = mq.TLO.Macro.Variable('EVENTEventDataListN')()
	end
	n = n + 1
  end
  return acttime
  
end

-- ----------------------------------
-- script steps
-- ----------------------------------
local SCRIPTStep_01 = function()

  if SCRIPTStep[SCRIPTCurrentStep].section == 1 then
    if mq.TLO.DynamicZone.LeaderFlagged() then
      mq.cmd.cecho('\awConsole: \ayThere is already an instance running ${DynamicZone.Name}, ending script')
      SCRIPTCurrentState = 3
    else
      mq.cmd.cecho('\awConsole:\ay +ECHO THIS \\awGDRA: Leading the script for the group mission Restless Assault')
      mq.cmd.cecho('\awConsole:\ay +ECHO THIS \\awGDRA: Getting mission')
      mq.cmd.cecho('\awConsole:\ay +MERC TAR #Zrelik_the_Brave00')
      SCRIPTMoveCalledID = 0
      SCRIPTAssistCalledID = 0
	  SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 2 then
    if mq.TLO.Target() == '#Zrelik_the_Brave00' then
	  SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 3 then
    mq.cmd.cecho('\awConsole:\ay +MERC SAY small')
	SCRIPTWaitTimer = os.time() + 60
	  SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 4 then
    if mq.TLO.DynamicZone.LeaderFlagged() or os.time() > SCRIPTWaitTimer then
	  SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
    end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 5 then
    if not mq.TLO.DynamicZone.LeaderFlagged() then
      mq.cmd.cecho('\awConsole: \ayFailed to request the mission (timed out 60 secs), ending script')
      SCRIPTCurrentState = 3
    else
      mq.cmd.cecho('\awConsole:\ay +ECHO THIS \\awGDRA: Dynamic zone loaded for '..mq.TLO.DynamicZone.Members()..' characters')
      mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI PASSIVE')
      mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI TANK DPS')
      mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI MERC TAR #Zrelik_the_Brave00')
      SCRIPTWaitTimer = os.time() + 10
	  SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 6 then
    if os.time() > SCRIPTWaitTimer then
      mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI MERC SAY ready')
      SCRIPTWaitTimer = os.time() + 120
	  SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 7 then
    if SCRIPTLastZoned == mq.TLO.Me.LastZoned.Raw() then
      if os.time() > SCRIPTWaitTimer then
        mq.cmd.cecho('\awConsole: \ayFailed to zone in myself (timed out 120 secs), ending script')
        SCRIPTCurrentState = 3
      end
	else
      if mq.TLO.Group.AnyoneMissing() then
        if os.time() > SCRIPTWaitTimer then
          mq.cmd.cecho('\awConsole: \ayFailed to zone in the full group (timed out 120 secs), ending script')
          SCRIPTCurrentState = 3
		end
	  else
        mq.cmd.cecho('\awConsole:\ay +ECHO THIS \\awGDRA: Everybody zoned in')
		SCRIPTLastZoned = mq.TLO.Me.LastZoned.Raw()
        SCRIPTWaitTimer = os.time() + 10
        SCRIPTCurrentStep = SCRIPTCurrentStep + 1
      end
    end
  end

end

local SCRIPTStep_02 = function()

  if SCRIPTStep[SCRIPTCurrentStep].section == 1 then
    if os.time() > SCRIPTWaitTimer then
-- TO-DO pick MT from GUI	
      mq.cmd.cecho('\awConsole:\ay +TANK OFFTANK')
      mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI BALANCED')
      mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI SPEED ON')
      mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI SNARE OFF')
      mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI DS OFF')

      mq.cmd.cecho('\awConsole:\ay +ECHO THIS \\awGDRA: Setting up a camp to pull potential adds')
      mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI PULL LOC 804 -609 32')
      mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI PULL ON')

      TrashAdd1 = mq.TLO.NearestSpawn('NPC loc 960 -681 44 radius 10').ID()
      TrashAdd2 = mq.TLO.NearestSpawn('NPC loc 970 -550 59 radius 10').ID()
      TrashAdd3 = mq.TLO.NearestSpawn('NPC loc 970 -515 59 radius 10').ID()
  
      SCRIPTMoveCalledID = 0
      SCRIPTAssistCalledID = 0
	  SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 2 then
    if mq.TLO.Math.Distance('-609,804,32')() < 15 and mq.TLO.SpawnCount('PC radius 25')() == (mq.TLO.Group.Members() - mq.TLO.Group.MercenaryCount() + 1) then
      mq.cmd.cecho('\awConsole:\ay +ECHO THIS \\awGDRA: Camp set, starting pulls')
	  SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 3 then
    if mq.TLO.Macro.Variable('CurrentTargetID')() == 0 then
      if mq.TLO.Spawn(TrashAdd1)() and not mq.TLO.Spawn(TrashAdd1).Dead() then
        if SCRIPTAssistCalledID ~= TrashAdd1 then
          mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI ASSIST MANUAL '..TrashAdd1)
		  SCRIPTAssistCalledID = TrashAdd1
		end
	  elseif mq.TLO.Spawn(TrashAdd2)() and not mq.TLO.Spawn(TrashAdd2).Dead() then
        if SCRIPTAssistCalledID ~= TrashAdd2 then
          mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI ASSIST MANUAL '..TrashAdd2)
		  SCRIPTAssistCalledID = TrashAdd2
		end
	  elseif mq.TLO.Spawn(TrashAdd3)() and not mq.TLO.Spawn(TrashAdd3).Dead() then
        if SCRIPTAssistCalledID ~= TrashAdd3 then
          mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI ASSIST MANUAL '..TrashAdd3)
		  SCRIPTAssistCalledID = TrashAdd3
		end
	  else
        mq.cmd.cecho('\awConsole:\ay +ECHO THIS \\awGDRA: Moving back to Zrelik to start the mission')
        mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI PULL RESET')
        mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI PULL OFF')
        mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI AUTOFOLLOW ON '..mq.TLO.Spawn('PC '..SCRIPTMainTank)())
        mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} '..mq.TLO.Spawn('PC '..SCRIPTMainTank)()..' CLI MOVE TGT Zrelik')
	    SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	  end
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 4 then
    if mq.TLO.Spawn('Zrelik').Distance() < 20 and mq.TLO.SpawnCount('PC radius '..tostring(mq.TLO.Macro.Variable('AutofollowMaxDistanceRanged')))() == (mq.TLO.Group.Members() - mq.TLO.Group.MercenaryCount() + 1) then
      mq.cmd.cecho('\awConsole:\ay +ECHO THIS \\awGDRA: Triggering the mission')
      mq.cmd.cecho('\awConsole:\ay +MERC TAR #Zrelik_the_Brave00')
	  SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 5 then
    if mq.TLO.Target() == '#Zrelik_the_Brave00' then
      mq.cmd.cecho('\awConsole:\ay +EVENT ON')
      mq.cmd.cecho('\awConsole:\ay +EVENT ADD RHINO PTT "A restless rhinoceros stomps its hoof and snorts."')
      mq.cmd.cecho('\awConsole:\ay +EVENT ADD MELT PTT "Narandi the Restless melts, a pool of water appearing at its feet."')
      mq.cmd.cecho('\awConsole:\ay +MERC SAY start')
      SCRIPTCurrentStep = SCRIPTCurrentStep + 1
	end
  end

end

local SCRIPTStep_03 = function()

  if SCRIPTStep[SCRIPTCurrentStep].section == 1 then
    if mq.TLO.Spawn('#Koldan_Wallbreaker00').ID() ~= 0 and mq.TLO.Spawn('NPC a_restless_dire_wolf00').ID() ~= 0 then
      mq.cmd.cecho('\awConsole:\ay +ECHO THIS \\awGDRA: Koldan Wallbreaker and restless dire wolf x1 spawned')
      StepNamed = mq.TLO.Spawn('#Koldan_Wallbreaker00').ID()
      StepAdd = mq.TLO.Spawn('NPC a_restless_dire_wolf00').ID()
      SCRIPTMoveCalledID = 0
      SCRIPTAssistCalledID = 0
	  SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 2 then
    DisposeMob(StepAdd)
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 3 then
    DisposeMob(StepNamed)
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 4 then
    SCRIPTCurrentStep = SCRIPTCurrentStep + 1
  end

end

local SCRIPTStep_04 = function()

  if SCRIPTStep[SCRIPTCurrentStep].section == 1 then
    if mq.TLO.Spawn('#Darikan_the_Ancient00').ID() ~= 0 and mq.TLO.Spawn('NPC a_restless_dire_wolf00').ID() ~= 0 then
      mq.cmd.cecho('\awConsole:\ay +ECHO THIS \\awGDRA: Darikan the Ancient and restless dire wolf x1 spawned')
      StepNamed = mq.TLO.Spawn('#Darikan_the_Ancient00').ID()
      StepAdd = mq.TLO.Spawn('NPC a_restless_dire_wolf00').ID()
      SCRIPTMoveCalledID = 0
      SCRIPTAssistCalledID = 0
	  SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 2 then
    DisposeMob(StepAdd)
  end
  
  if SCRIPTStep[SCRIPTCurrentStep].section == 3 then
    StepAdd = 0
    SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 4 then
    if StepAdd == 0 and mq.TLO.SpawnCount('NPC a_restless_crystal')() > 0 then
      StepAdd = mq.TLO.Spawn('NPC a_restless_crystal').ID()
	end
    if StepAdd ~= 0 then 
      DisposeMob(StepAdd)
	else
      DisposeMob(StepNamed)
	end
    if (not mq.TLO.Spawn(StepAdd)() or mq.TLO.Spawn(StepAdd).Dead()) then
      StepAdd = 0
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 5 then
    if (not mq.TLO.Spawn(StepNamed)() or mq.TLO.Spawn(StepNamed).Dead()) and mq.TLO.SpawnCount('NPC a_restless_crystal')() == 0 then
      SCRIPTCurrentStep = SCRIPTCurrentStep + 1
	else
      SCRIPTStep[SCRIPTCurrentStep].iteration = SCRIPTStep[SCRIPTCurrentStep].iteration + 1
      SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section - 1
	end
  end

end

local SCRIPTStep_05 = function()

  if SCRIPTStep[SCRIPTCurrentStep].section == 1 then
    if mq.TLO.Spawn('#Endaroky_Stormcaller00').ID() ~= 0 and mq.TLO.Spawn('NPC a_restless_dire_wolf00').ID() ~= 0 then
      mq.cmd.cecho('\awConsole:\ay +ECHO THIS \\awGDRA: Endaroky Stormcaller and restless dire wolf x4 spawned')
      StepNamed = mq.TLO.Spawn('#Endaroky_Stormcaller00').ID()
      StepAdd = 0
      StepNearest = 0
      SCRIPTMoveCalledID = 0
      SCRIPTAssistCalledID = 0
	  SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 2 then
    if StepNearest == 0 then
      if StepAdd == 0 and mq.TLO.SpawnCount('NPC a_restless_dire_wolf')() > 0 then
        StepAdd = mq.TLO.Spawn('NPC a_restless_dire_wolf').ID()
	  end
      if mq.TLO.Spawn(StepNamed)() and not mq.TLO.Spawn(StepNamed).Dead() then
	    if StepAdd == 0 then
          StepNearest = StepNamed
		else
          if mq.TLO.Spawn(StepNamed).Distance() < mq.TLO.Spawn(StepAdd).Distance() then
            StepNearest = StepNamed
		  else
            StepNearest = StepAdd
		  end
		end
      else
	    StepNearest = StepAdd
	  end
	end
    if StepNearest == 0 then
      SCRIPTCurrentStep = SCRIPTCurrentStep + 1
	else
      DisposeMob(StepNearest)
      if (not mq.TLO.Spawn(StepNearest)() or mq.TLO.Spawn(StepNearest).Dead()) then
        StepAdd = 0
        StepNearest = 0
	  end
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 3 then
    if (not mq.TLO.Spawn(StepNamed)() or mq.TLO.Spawn(StepNamed).Dead()) and mq.TLO.SpawnCount('NPC a_restless_dire_wolf')() == 0 then
      SCRIPTCurrentStep = SCRIPTCurrentStep + 1
	else
      SCRIPTStep[SCRIPTCurrentStep].iteration = SCRIPTStep[SCRIPTCurrentStep].iteration + 1
      SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section - 1
	end
  end

end

local SCRIPTStep_06 = function()

  local rhinomoving
  local locX,locY
  
  if SCRIPTStep[SCRIPTCurrentStep].section == 1 then
    if mq.TLO.Spawn('#Mandrikai00').ID() ~= 0 and mq.TLO.Spawn('NPC a_restless_dire_wolf00').ID() ~= 0 and mq.TLO.Spawn('NPC a_restless_rhinoceros00').ID() ~= 0 then
      mq.cmd.cecho('\awConsole:\ay +ECHO THIS \\awGDRA: Mandrikai and restless dire wolf x1 (avoiding restless rhinoceros aura)')
      StepNamed = mq.TLO.Spawn('#Mandrikai00').ID()
      StepAdd = mq.TLO.Spawn('NPC a_restless_dire_wolf00').ID()
      StepRhinoAdd = mq.TLO.Spawn('NPC a_restless_rhinoceros00').ID()
	  StepRhinoLastEmote = 0
	  StepRhinoNextRelocation = 0
      SCRIPTMoveCalledID = 0
      SCRIPTAssistCalledID = 0
	  SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section > 1 then
    rhinomoving = MonitorEvent('RHINO')
	if rhinomoving and rhinomoving ~= StepRhinoLastEmote then
	  print('Rhinooooooooooo (EMOTE) !!! *',rhinomoving,'* ',StepRhinoLastEmote)
	  if StepRhinoLastEmote == '0' then
        mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI PULL ON')
	  end
      locX = math.floor(mq.TLO.Spawn(SCRIPTMainTank..' PC').X() - 125)
      locY = math.floor(mq.TLO.Spawn(SCRIPTMainTank..' PC').Y())
      mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI PULL LOC '..locX..' '..locY)
	  StepRhinoLastEmote = rhinomoving
	  StepRhinoNextRelocation = os.time() + 5
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section > 1 then
    if StepRhinoNextRelocation < os.time() and mq.TLO.Spawn(StepRhinoAdd).ID() ~= 0 then
	  if mq.TLO.Spawn(StepRhinoAdd).Distance() < 50 then
        print('Rhinooooooooooo (TOO CLOSE) !!! ',StepRhinoNextRelocation,' ',os.time())
	    if mq.TLO.Macro.Variable('AssistMoveHold')() then
          mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI PULL ON')
	    end
        locX = math.floor(mq.TLO.Spawn(SCRIPTMainTank).X() - 125)
        locY = math.floor(mq.TLO.Spawn(SCRIPTMainTank).Y())
        mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI PULL LOC '..locX..' '..locY)
        StepRhinoNextRelocation = os.time() + 10
	  end
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 2 then
    DisposeMob(StepAdd)
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 3 then
    DisposeMob(StepNamed)
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 4 then
    mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI PULL OFF')
    mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI PULL RESET')
    SCRIPTCurrentStep = SCRIPTCurrentStep + 1
  end

end

local SCRIPTStep_07 = function()

  if SCRIPTStep[SCRIPTCurrentStep].section == 1 then
    if mq.TLO.Spawn('#Warlord_Feri00').ID() ~= 0 and mq.TLO.Spawn('NPC a_restless_dire_wolf00').ID() ~= 0 then
      mq.cmd.cecho('\awConsole:\ay +ECHO THIS \\awGDRA: Warlord Feri and restless dire wolf x1 spawned')
      StepNamed = mq.TLO.Spawn('#Warlord_Feri00').ID()
      StepAdd = mq.TLO.Spawn('NPC a_restless_dire_wolf00').ID()
      SCRIPTAssistCalledID = 0
	  SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 2 then
    DisposeMob(StepAdd)
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 3 then
    DisposeMob(StepNamed)
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 4 then
    SCRIPTCurrentStep = SCRIPTCurrentStep + 1
  end

end

local SCRIPTStep_08 = function()

  if SCRIPTStep[SCRIPTCurrentStep].section == 1 then
    if mq.TLO.Spawn('#Huntmaster_Grondo00').ID() ~= 0 and mq.TLO.Spawn('NPC a_shivering_dire_wolf').ID() ~= 0 then
      mq.cmd.cecho('\awConsole:\ay +ECHO THIS \\awGDRA: Huntmaster Grondo and shivering dire wolf x1 spawned')
      StepNamed = mq.TLO.Spawn('#Huntmaster_Grondo00').ID()
      StepAdd = mq.TLO.Spawn('NPC a_shivering_dire_wolf').ID()
      StepGrondoBurnCalled = (mq.TLO.Macro.Variable('PerformanceMode')() == mq.TLO.Macro.Variable('PerformanceModeBurn')())
      if not StepGrondoBurn and StepGrondoBurnCalled then
        mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI BALANCED')
		StepGrondoBurnCalled = false
	  end
      SCRIPTMoveCalledID = 0
      SCRIPTAssistCalledID = 0
	  SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 2 then
    DisposeMob(StepAdd)
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 3 then
    StepAdd = 0
    SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 4 then
    if StepGrondoBurn then
      if not StepGrondoBurnCalled then
        mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI BURN')
	    StepGrondoBurnCalled = true
	  end
      if (mq.TLO.Spawn(StepNamed)() and not mq.TLO.Spawn(StepNamed).Dead()) then
        DisposeMob(StepNamed)
	  else
        if StepAdd == 0 then
          if mq.TLO.SpawnCount('NPC a_shivering_dire_wolf')() > 0 then		
            StepAdd = mq.TLO.Spawn('NPC a_shivering_dire_wolf').ID()
		  else
            SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
		  end
		else
          DisposeMob(StepAdd)
		end
	  end
    else
	  if StepAdd == 0 then
	    if mq.TLO.SpawnCount('NPC a_shivering_dire_wolf')() > 0 then
          StepAdd = mq.TLO.Spawn('NPC a_shivering_dire_wolf').ID()
		else
		  if (mq.TLO.Spawn(StepNamed)() and not mq.TLO.Spawn(StepNamed).Dead()) then
            DisposeMob(StepNamed)
	      else
            SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
		  end
		end
	  else
        DisposeMob(StepAdd)
	  end
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 5 then
    if (not mq.TLO.Spawn(StepNamed)() or mq.TLO.Spawn(StepNamed).Dead()) and mq.TLO.SpawnCount('NPC a_shivering_dire_wolf')() == 0 then
	  SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	else
      StepAdd = 0
      SCRIPTStep[SCRIPTCurrentStep].iteration = SCRIPTStep[SCRIPTCurrentStep].iteration + 1
      SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section - 1
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 6 then
    if StepGrondoBurnCalled then
      mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI BALANCED')
	end
    SCRIPTCurrentStep = SCRIPTCurrentStep + 1
  end

end

local SCRIPTStep_09 = function()

  local narandimelting
  local i_split,n_cross,i_cross

  if SCRIPTStep[SCRIPTCurrentStep].section == 1 then
    if mq.TLO.Spawn('#Narandi_the_Restless00').ID() ~= 0 and mq.TLO.Spawn('NPC a_restless_dire_wolf00').ID() ~= 0 then
      mq.cmd.cecho('\awConsole:\ay +ECHO THIS \\awGDRA: Narandi the Restless and restless dire wolf x1 spawned')
      StepNamed = mq.TLO.Spawn('#Narandi_the_Restless00').ID()
      StepAdd = mq.TLO.Spawn('NPC a_restless_dire_wolf00').ID()
	  StepNarandiLastMelt = '0'
      StepNarandiSplitsN = 0
      SCRIPTAssistCalledID = 0
	  SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 2 then
    DisposeMob(StepAdd)
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 3 then
    mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI DPS OFF')
    mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI PULL ON')
    mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI PULL LOC -765 -845')
    SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
    DisposeMob(StepNamed)
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 4 then
    if StepNamed == 0 then
	  StepNamed = mq.TLO.Spawn('#Narandi_the_Restless00').ID()
	else
      DisposeMob(StepNamed)
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 5 then
print('step 5',StepNarandiSplitsN,' ',mq.TLO.Spawn('Narandi_the_Restless100')(),' gap ',StepNarandiLowestGap)
mq.delay(1000)

    if StepNarandiSplitsN == 3 then
      SCRIPTCurrentStep = SCRIPTCurrentStep + 1
	else
      if mq.TLO.Spawn('Narandi_the_Restless100')()	 then
        StepNarandiSplits[1] = {ID = mq.TLO.Spawn('Narandi_the_Restless100').ID(), xt = 6 , gap = 105, crossed = false, copy = false}
        StepNarandiSplits[2] = {ID = mq.TLO.Spawn('Narandi_the_Restless101').ID(), xt = 7 , gap = 105, crossed = false, copy = false}
        StepNarandiSplits[3] = {ID = mq.TLO.Spawn('Narandi_the_Restless102').ID(), xt = 8 , gap = 105, crossed = false, copy = false}
        StepNarandiSplits[4] = {ID = mq.TLO.Spawn('Narandi_the_Restless103').ID(), xt = 9 , gap = 105, crossed = false, copy = false}
        mq.cmd.xtarget('set 6 Narandi_the_Restless100')
        mq.cmd.xtarget('set 7 Narandi_the_Restless101')
        mq.cmd.xtarget('set 8 Narandi_the_Restless102')
        mq.cmd.xtarget('set 9 Narandi_the_Restless103')
		StepNarandiLowestGap = 105
        StepNarandiCurrentCopy = 1
		StepNarandiCopyLocked = false
        mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI DPS OFF')
        SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	  end
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 6 then
print('step 6',mq.TLO.Me.XTarget(StepNarandiSplits[StepNarandiCurrentCopy].xt).PctHPs(),' ',StepNarandiCopyLocked,' gap ',StepNarandiLowestGap)
mq.delay(1000)

    if StepNarandiManual then
	  if StepNarandiCurrentCopy ~= StepNarandiManualCopy then
	    StepNarandiCurrentCopy = StepNarandiManualCopy
	    print('Manual copy lock override on ',StepNarandiCurrentCopy)
	  end
      if not StepNarandiCopyLocked then
	    StepNarandiCopyLocked = true
	  end
	end
    if mq.TLO.Me.XTarget(StepNarandiSplits[StepNarandiCurrentCopy].xt).PctHPs() then
	  if not StepNarandiCopyLocked and mq.TLO.Me.XTarget(StepNarandiSplits[StepNarandiCurrentCopy].xt).PctHPs() <= StepNarandiLowestGap - 35 then
	    print('Current copy 35 under lowest gap without emote, marking it as real ',StepNarandiCurrentCopy,mq.TLO.Me.XTarget(StepNarandiSplits[StepNarandiCurrentCopy].xt).PctHPs(),' gap ',StepNarandiLowestGap)
	    StepNarandiCopyLocked = true
        mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI DPS ON')
	  end
	end
	if not StepNarandiCopyLocked then
	  narandimelting = MonitorEvent('MELT')
	  if narandimelting and narandimelting ~= StepNarandiLastMelt then
	    print('Narandi melting !!! *',narandimelting,'* ',StepNarandiLastMelt)
        i_split = 1
		n_cross = 0
		while i_split <= 4 do
		  if mq.TLO.Me.XTarget(StepNarandiSplits[i_split].xt).PctHPs() <= StepNarandiSplits[i_split].gap - 20 then
print('narandi ',i_split,' crossed gap ',StepNarandiSplits[i_split].gap,' with ',mq.TLO.Me.XTarget(StepNarandiSplits[i_split].xt).PctHPs())
		    StepNarandiSplits[i_split].crossed = true
			i_cross = i_split
			n_cross = n_cross + 1
			while mq.TLO.Me.XTarget(StepNarandiSplits[i_split].xt).PctHPs() <= StepNarandiSplits[i_split].gap - 20 do
              StepNarandiSplits[i_split].gap = StepNarandiSplits[i_split].gap - 20
			end
		  else
print('narandi ',i_split,' DID NOT cross gap ',StepNarandiSplits[i_split].gap,' with ',mq.TLO.Me.XTarget(StepNarandiSplits[i_split].xt).PctHPs())
			StepNarandiSplits[i_split].crossed = false
		  end
		  i_split = i_split + 1
        end		  
print('Melting emote detected, current gap ',StepNarandiLowestGap)
        if n_cross == 0 then
		  print('Melting emote detected but no gap cross found, lowering it one step')
          StepNarandiLowestGap = StepNarandiLowestGap - 20
        else
		  if n_cross == 1 then
		    print('Melting emote detected and only ONE gap cross found, marking as copy',i_cross,' gap ',StepNarandiLowestGap)
            StepNarandiSplits[i_cross].copy = true
            StepNarandiLowestGap = StepNarandiSplits[i_cross].gap
      		print('New gap ',StepNarandiLowestGap)
		    if i_cross == StepNarandiCurrentCopy then
			  print('Melting emote detected in current copy ',i_cross)
			  while StepNarandiCurrentCopy < 4 and StepNarandiSplits[StepNarandiCurrentCopy].copy do
			    StepNarandiCurrentCopy = StepNarandiCurrentCopy + 1				  
			  end
			  print('New assist  ',StepNarandiCurrentCopy)
			  if StepNarandiCurrentCopy == 4 then
			    print('Reached last copy, marking it as real ',StepNarandiCurrentCopy)
				StepNarandiCopyLocked = true
                mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI DPS ON')
			  end
			end
		  else
		    i_split = 1
			while i_split <= 4 do
              if StepNarandiSplits[i_split].gap < StepNarandiLowestGap then
                StepNarandiLowestGap = StepNarandiSplits[i_split].gap
			  end
			  i_split = i_split + 1
			end
		    print('Melting emote detected but multiple gap cross found ',n_cross, ' new gap ',StepNarandiLowestGap)
		  end
		end
        StepNarandiLastMelt = narandimelting
	  end
	end
    DisposeMob(StepNarandiSplits[StepNarandiCurrentCopy].ID)
  end
  
  if SCRIPTStep[SCRIPTCurrentStep].section == 7 then
    print('Copy disposed ',StepNarandiCurrentCopy, ' ID ',StepNarandiSplits[StepNarandiCurrentCopy].ID)
    StepNarandiSplitsN = StepNarandiSplitsN + 1
	StepNamed = 0
    SCRIPTStep[SCRIPTCurrentStep].iteration = SCRIPTStep[SCRIPTCurrentStep].iteration + 1
    SCRIPTStep[SCRIPTCurrentStep].section = 4
  end

end

local SCRIPTStep_10 = function()

  if SCRIPTStep[SCRIPTCurrentStep].section == 1 then
    if mq.TLO.Spawn('a_frozen_chest').ID() ~= 0 and mq.TLO.SpawnCount('CORPSE radius 100')() == 0 then
      mq.cmd.cecho('\awConsole:\ay +ECHO THIS \\awGDRA: Ending mission')
      mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI PULL RESET')
      SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
	end
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 2 then
    mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} '..mq.TLO.Spawn('PC '..SCRIPTMainTank)()..' CLI MOVE TGT a_frozen_chest')
    SCRIPTStep[SCRIPTCurrentStep].section = SCRIPTStep[SCRIPTCurrentStep].section + 1
  end

  if SCRIPTStep[SCRIPTCurrentStep].section == 3 then
    if mq.TLO.Spawn('a_frozen_chest').Distance() < 20 then
      mq.cmd.cecho('\awConsole:\ay +ECHO THIS \\awGDRA: Grab the loot, mission completed.')
      SCRIPTCurrentState = 3
	end
  end

end

-- ----------------------------------
-- main loop
-- ----------------------------------


-- mission related variables declaration
-- ----------------------------------

SCRIPTMainTank = mq.TLO.Me.Name()

-- SCRIPT general variables initialization
-- ----------------------------------
SCRIPTCurrentState = 1
SCRIPTStep[1] = {fn = SCRIPTStep_01, desc = 'Start mission', section = 1, iteration = 1}
SCRIPTStep[2] = {fn = SCRIPTStep_02, desc = 'Moving near the tizmak cave to clear possible add aggro', section = 1, iteration = 1}
SCRIPTStep[3] = {fn = SCRIPTStep_03, desc = 'Koldan Wallbreaker and restless dire wolf x1', section = 1, iteration = 1}
SCRIPTStep[4] = {fn = SCRIPTStep_04, desc = 'Darikan the Ancient, restless dire wolf x1, and sets of restless crystals x3', section = 1, iteration = 1}
SCRIPTStep[5] = {fn = SCRIPTStep_05, desc = 'Endaroky Stormcaller and restless dire wolf x4', section = 1, iteration = 1}
SCRIPTStep[6] = {fn = SCRIPTStep_06, desc = 'Mandrikai and restless dire wolf x1', section = 1, iteration = 1}
SCRIPTStep[7] = {fn = SCRIPTStep_07, desc = 'Warlord Feri and restless dire wolf x1', section = 1, iteration = 1}
SCRIPTStep[8] = {fn = SCRIPTStep_08, desc = 'Huntmaster Grondo and shivering dire wolf (multiple HP based)', section = 1, iteration = 1}
SCRIPTStep[9] = {fn = SCRIPTStep_09, desc = 'Narandi the Restless (x3 splits) and restless dire wolf x1', section = 1, iteration = 1}
SCRIPTStep[10] = {fn = SCRIPTStep_10, desc = 'End mission', section = 1, iteration = 1}

SCRIPTCurrentStep = 1

mq.imgui.init('missionGDRA', SCRIPTDrawConsole)
ImGui.PushStyleColor(ImGuiCol.WindowBg, 0, 0, 0, 0.2)

while mq.TLO.Macro.Variable('GUIAvailable')() and SCRIPTCurrentState ~= 0 do
  if SCRIPTCurrentState == 1 then
    SCRIPTStep[SCRIPTCurrentStep].fn ()
  end
end

mq.cmd.cecho('\awConsole:\ay +EVENT OFF')
mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI PULL RESET')
mq.cmd.dgt('\awConsole:\ay +MSG ${Me.Name} GRP CLI AUTOFOLLOW OFF')

mq.imgui.destroy('SCRIPTDrawConsole')

