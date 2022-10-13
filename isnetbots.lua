
local mq = require('mq')

local function isnetbots(member, check)
  local retval = mq.TLO.NetBots(member)[check]()
  return retval ~= 'NULL' and retval
end 

local i = 0
local netbotname = mq.TLO.Raid.Member(i).Name()
local pctHPs = isnetbots(netbotname, 'PctHPs') or 0
local pctMana = isnetbots(netbotname, 'PctMana') or 0 

local function isnetbots(member, check, nilreturn)
    local retval = mq.TLO.NetBots(member)[check]()
    if retval == nil or retval == "NULL" then
        return nilreturn
    else
        return retval
    end
end

local raidname = mq.TLO.Raid.Member(i).Name()
local pctHPs = isnetbots(raidname, 'PctHPs', 0)
local pctMana = isnetbots(raidname, 'PctMana', 0)
local targetName = isnetbots(raidname, 'Name', 'No Target')
local Attacking = isnetbots(raidname, "Attacking", false)
local Casting = isnetbots(raidname, "Casting", false)