

-- /itemnotify in pack1-10 itemslot2+1 i think
-- and itemslot would be -22 to get the pack number
-- so i restack that by setting bagstart and bagend to between 1 and 10
-- so we first have to convert it to itemslot by adding 22 so the me.inventory can work with it, then when i itemnofity i substract 22 from the bag
local BagStart = 0
local BagEnd = 0
local function restack()
  print(string.format('\agRestacking bag %d to %d', BagStart, BagEnd))
  for bag = BagStart,BagEnd do
      bag = bag+22
      for slot = 1, mq.TLO.Me.Inventory(bag).Container() do
          if mq.TLO.Me.Inventory(bag).Item(slot)() then
              mq.cmdf('/nomodkey /shiftkey /itemnotify in pack%d %d leftmouseup', bag-22, slot)
              mq.delay(500,function() return mq.TLO.Cursor() ~= nil end)
              while mq.TLO.Cursor.ID() do
                  mq.cmd('/autoinventory')
                  mq.delay(100)
              end
          end
      end
  end
  print('\agRestacking done')
end