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