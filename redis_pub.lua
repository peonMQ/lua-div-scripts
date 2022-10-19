local mq = require('mq')
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

local function client_hset(members)
   for _, val in ipairs(members) do
      if mq.TLO.Me[val]() then
         client:hset(client_set_key, val, mq.TLO.Me[val]())
      end
   end
end

local function publish()
   client_hset(publish_members)
end

while true do
   publish()
   mq.delay(250)
end