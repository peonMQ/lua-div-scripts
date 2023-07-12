local mq = require('mq')
local debug = require 'inventory/utils/debug'

local function spread(array)
   local t = {}
   for index, value in ipairs(array) do
      if index > 1 then
         table.insert(t, value)
      end
   end

   return array[1], t
end

local function append(array, value)
   local t = {}
   for i, v in ipairs(array) do
      table.insert(t, v)
   end
   table.insert(t, value)

   return t
end


local function getUserDataObject(userdata, userdataPath)
   local head, rest = spread(userdataPath)
   if #rest > 0 then
      return getUserDataObject(userdata[head], rest)
   end

   return userdata[head]
end

local tlo = {}
local mqDataTypes = {}
--  ~= nil
local function addTloMember(tloMember, memberType)
   if tlo[tloMember] == nil then
      tlo[tloMember] = memberType
   end
end

local function addDataType(type, member, memberType)
   if mqDataTypes[type] == nil then
      mqDataTypes[type] = {}
   end

   if mqDataTypes[type][member] == nil then
      mqDataTypes[type][member] = memberType
      return true
   end

   return false
end

local function parseMembers(dataTypePath)
   local userdata = getUserDataObject(mq.TLO, dataTypePath)
   local type = mq.gettype(userdata)
   if #dataTypePath == 1 then
      addTloMember(dataTypePath[1], type)
   end

   for index = 0, 300 do
      local member = mq.TLO.Type(type).Member(index)()
      if member then
         local memberType = mq.gettype(userdata[member]) or 'function'
         if addDataType(type, member, memberType) and memberType ~= 'function' then
            local memberDataTypePath = append(dataTypePath, member)
            parseMembers(memberDataTypePath)
         end
      end
   end
 end

-- listMembers(nil, 'character')

parseMembers({'Me'})

local configDir = mq.configDir.."/"
mq.pickle(configDir.."tlo.lua", tlo)
mq.pickle(configDir.."mqdatatypes.lua", mqDataTypes)