local mq = require('mq')

local basicTypes = {'Character', 'Target', 'Spawn'}
local memberCount = 1

for _key, type in pairs(basicTypes) do
   local index = 0
   while mq.TLO.Type(type:lower()).Member(index)() do
      local memberName = mq.TLO.Type(type:lower()).Member(index)()
      local memberValue = tostring(mq.TLO.Me[memberName]())
      print(string.format('%d - %s (%s)', memberCount, memberName, memberValue))
      index = index + 1
      memberCount = memberCount + 1
   end
end

local function printMemberItem(index, member, memberType, memberValue)
  print(string.format('%d. %s (%s) [%s]', index, member, memberType, tostring(memberValue)))
end

local function listMembers(dataTypePath, datatype)
  local index = 0
  while mq.TLO.Type(datatype).Member(index)() do
     local member = mq.TLO.Type(datatype).Member(index)()
     local memberType = mq.gettype(mq.TLO.Me[member])
     local memberValue = nil
     if dataTypePath then
        memberValue = mq.TLO.Me[dataTypePath][member]()
     else
        memberValue = mq.TLO.Me[member]()
     end
     printMemberItem(index, member, memberType, memberValue)
     listMembers(member, memberType)
     index = index + 1
  end
end

listMembers(nil, 'character')