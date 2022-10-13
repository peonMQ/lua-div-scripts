-- print('STICK MAC STARTED')


-- if mq.TLO.Target.ID() then
--     local MaxD = 'mq.TLO.Target.MaxRangeTo()'
-- end

-- if mq.TLO.Target.Distance() > 300 then
--     print('mq.TLO.Target.Name() IS OOR')
--     if mq.TLO.Me.Combat() then
--         mq.cmdf('/attack') -- off
--         mq.delay(1000, not mq.TLO.Me.Combat())
--     end

--     return MaxD
-- end

-- if mq.TLO.Target.ID() then
--     print('Attacking (mq.TLO.Target.Name() at MaxD() distance.')
-- end

-- while ( mq.TLO.Me.CombatState() == 'COMBAT' and mq.TLO.Target.ID() ) do

--     if ( mq.TLO.Target.ID() == mq.TLO.Me.ID() and mq.TLO.Me.Combat() ) then
--         mq.cmdf('/attack') --off
--         mq.delay(1000, not mq.TLO.Me.Combat())
--     end

--     mq.cmdf('/face fast nolook')

--     if mq.TLO.Target.Distance() > MaxD-5() then
--         mq.cmdf('/keypress forward hold')
--     end

--     if mq.TLO.Target.Distance() <= MaxD-6() then
--         mq.cmdf('/keypress forward')
--     end

--     if mq.TLO.Target.Distance() <= MaxD-3() then
--         mq.cmdf('/doability "Kick"')
--     end

-- end

-- if mq.TLO.Target.ID() then
--     MaxD()
-- end
-- mq.cmdf('/keypress back')

-- return MaxD

-- local function nav_target()
--   local moba = "a worrisome shade"
--   if(not mq.TLO.Nav.Active())
--   then
--       if(tostring(mq.TLO.NearestSpawn(moba)) ~= "NULL")
--       then
--           local distance = mq.TLO.NearestSpawn(moba).Distance()
--           if(distance > 15)
--           then
--               mq.cmd("/nav spawn ", moba)
--           end
--       end
--   end
-- end

-- -- If we "unlock" the window we want to be able to move it and resize it
-- -- If we "lock" the window, we don't want to be able to click it, resize it, move it, etc.
-- -- Do you have a flag?!
-- function getFlagForLockedState()
--     if locked then
--         return bit32.bor(ImGuiWindowFlags.NoTitleBar, ImGuiWindowFlags.NoBackground, ImGuiWindowFlags.NoResize, ImGuiWindowFlags.NoMove, ImGuiWindowFlags.NoInputs)
--     elseif not locked then
--         return bit32.bor(ImGuiWindowFlags.NoTitleBar)
--     end
-- end