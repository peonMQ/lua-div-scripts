local mq = require('mq')
require('ImGui')
local redis = require('redis')
local client = redis.connect('127.0.0.1', 6379)

local client_set_key = string.format('%s:%s', mq.TLO.EverQuest.Server(), mq.TLO.Me.Name())

local publish_members = {
   'X',
   'Y',
   'AAPointsAssigned',
   'AAPointsSpent',
   'AAPointsTotal',
   'AAVitality',
   'AAVitalityCap',
   'AccuracyBonus',
   'ActiveDisc',
   'Aego',
   'AGI',
   'Aura',
   'AutoFire',
   'AvoidanceBonus',
   'BaseAGI',
   'BaseCHA',
   'BaseDEX',
   'BaseINT',
   'BaseSTA',
   'BaseSTR',
   'BaseWIS'
}

-- GUI Control variables
local openGUI = true
local shouldDrawGUI = true
local terminate = false

-- GUI State variables
local user = {}

local function display_values(t, member_state)
   for _, value in ipairs(t) do
      ImGui.Text(value)
      ImGui.NextColumn()
      ImGui.Text(tostring(user[value]))
      ImGui.NextColumn()
   end
end

-- ImGui main function for rendering the UI window
local redis_gv = function()
    openGUI, shouldDrawGUI = ImGui.Begin('Redis Group Viewer', openGUI)
    if shouldDrawGUI then
      ImGui.Columns(2)
      display_values(publish_members, user)
    end
    ImGui.End()
    if not openGUI then
        terminate = true
    end
end

mq.imgui.init('redisgv', redis_gv)

while not terminate do
   user = client:hgetall(client_set_key)
   mq.delay(250)
end