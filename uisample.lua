local mq = require 'mq'
require 'ImGui'

-- GUI Control variables
local openGUI = true
local shouldDrawGUI = true
local terminate = false

-- ImGui main function for rendering the UI window
local uisample = function()
    openGUI, shouldDrawGUI = ImGui.Begin('Sample UI', openGUI)
    if shouldDrawGUI then
        ImGui.Text('blah')
    end
    ImGui.End()
    if not openGUI then
        terminate = true
    end
end

mq.imgui.init('uisample', uisample)

while not terminate do
    mq.delay(1000)
end

local __something__ = true
local timeCounter = os.time()
while __something__ do
    if (mq.TLO.Target.Distance() or 0) > mq.TLO.Target.MaxRangeTo() then
        -- Only print every 60 seconds
        if os.difftime(os.time(), timeCounter) > 60 then
            print(mq.TLO.Target.CleanName() .. '\ar is OOR')
            timeCounter = os.time()
        end
    else
        print(mq.TLO.Target.CleanName() .. '\ag is IR')
    end
    mq.delay(100)
end