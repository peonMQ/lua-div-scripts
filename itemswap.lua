for bag=23,34 do
  local primary_size = mq.TLO.Me.Inventory('mainhand').Size()
  local bag_sizeCap = mq.TLO.Me.Inventory(bag).SizeCapacity()
  local bag_freeslot = mq.TLO.Me.Inventory(bag).FirstFreeSlot() 
  if primary_size <= bag_sizeCap and bag_freeslot ~= nil then
    print('Bag ' .. bag .. ' Has a slot free at : ' .. bag_freeslot)
  end
end