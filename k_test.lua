--- @type Mq
local mq = require('mq')

--- @type ImGui
require('ImGui')

local is_open = true
local is_drawn = true
local window_title = 'Kuhle ImGui Application'
local application_name = 'ImGui App'

-- Some local vars for the gui
local levels_selected = false
local levels = { 1, 85 }
local spell_locations = {
   {
      name = 'Plane of Knowledge',
      min_level = 1,
      max_level = 90,
      selected = true
    }, {
      name = 'Argath',
      min_level = 91,
      max_level = 95,
      selected = true
    }, {
      name = 'Shards Landing',
      min_level = 96,
      max_level = 100,
      selected = true
    }, {
      name = 'Ethernere',
      min_level = 96,
      max_level = 100,
      selected = true
    }, {
      name = 'Katta Deluge',
      min_level = 101,
      max_level = 105,
      selected = true
    }, {
      name = 'Plane of Tranquility',
      min_level = 101,
      max_level = 105,
      selected = true
    }, {
      name = 'Lceanium',
      min_level = 101,
      max_level = 105,
      selected = true
    }, {
      name = 'Overthere',
      min_level = 106,
      max_level = 110,
      selected = true
    }, {
      name = 'Stratos',
      min_level = 106,
      max_level = 110,
      selected = true
    }, {
      name = 'Eastern Wastes',
      min_level = 111,
      max_level = 115,
      selected = true
    }, {
      name = 'Great Divide',
      min_level = 111,
      max_level = 115,
      selected = true
    }, {
      name = 'Cobalt Scar',
      min_level = 111,
      max_level = 115,
      selected = true
    }, {
      name = 'Western Wastes',
      min_level = 111,
      max_level = 115,
      selected = true
    }, {
      name = 'Madiens Eye',
      min_level = 111,
      max_level = 115,
      selected = true
    }}

-- Lets us pass in arguments to the script
local args = { ... }
if args[1] and args[2] then
   levels[1] = tonumber(args[1])
   levels[2] = tonumber(args[2])
end

-- Function to check spell levels desired against spell zone valueParts
local function set_location_options(locations, range)
   for _, value in ipairs(locations) do
      if range[2] < value.min_level then
         value.selected = false
      else
         value.selected = true
      end
   end
end

-- As the name implies, this is the main function that draws our window
local function draw_main_window()
   if is_open then
      is_open, is_drawn = ImGui.Begin(window_title, is_open)
      ImGui.SetWindowSize(500, 500, ImGuiCond.Once)
      if is_drawn then

         levels, levels_selected = ImGui.SliderInt2('Levels of Scribing', levels, 1, 120)
         if levels_selected then set_location_options(spell_locations, levels) end

         ImGui.Separator()
         if levels[1] > levels[2] or levels[2] < levels[1] then levels[1] = levels[2] end

         ImGui.BeginTable('Zone Selections', 2)
         for _, value in ipairs(spell_locations) do
            ImGui.TableNextColumn()
            value.selected = ImGui.Checkbox(value.name, value.selected)
            ImGui.SameLine()
            ImGui.TextDisabled(string.format('(%d-%d)', value.min_level, value.max_level))
         end
         ImGui.EndTable()

      end
   end
   ImGui.End()
end

-- Inialize our application
set_location_options(spell_locations, levels)
mq.imgui.init(application_name, draw_main_window)

-- Continue to check for the state of the application
while is_open do mq.delay(1000) end