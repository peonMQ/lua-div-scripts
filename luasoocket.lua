

local mq = require('mq')
local http = require("socket.http")
local ltn12 = require("ltn12")
local webhookUrl = "insert your webhook url here"

local function sendMessage(line)
   local body = string.format('{ \"content\" : \"%s\" }', line)
   http.request {
      url = webhookUrl,
      method = "POST",
      headers = {
         ["Content-Type"] = "application/json",
         ["Content-Length"] = #body
      },
      source = ltn12.source.string(body)
   }
end

mq.event('Everything', '#*#', sendMessage)

while true do
   mq.doevents()
   mq.delay(250)
end