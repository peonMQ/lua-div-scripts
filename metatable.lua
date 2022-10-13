local mq = require('mq')
local Me = mq.TLO.Me

-- create a metatable with a custom field called shortClass because I'm lazy
local my_metatable = {}
my_metatable.__index = {
   ShortClass = function(self)
      return self.Class.ShortName()
   end
}

-- get a reference to the metatable for the userdata
local me_metatable = getmetatable(Me)

-- merge the two metatables
me_metatable.__index = setmetatable({}, my_metatable)

-- Print the shortName of the player using Me.ShortClass()
print(Me.ShortClass())

local mq = require('mq')
local Me = mq.TLO.Me

-- create a metatable with a custom field called shortClass because I'm lazy
local my_metatable = {}
my_metatable.__index = {
   ShortClass = function(self)
      print(type(self))
      print(mq.gettype(self))
      return self.Class.ShortName()
   end
}

-- get a reference to the metatable for the userdata
local me_metatable = getmetatable(Me)

-- merge the two metatables
me_metatable.__index = setmetatable({}, my_metatable)

-- Print the shortName of the player using Me.ShortClass()
print(Me:ShortClass())

local mq = require('mq')

-- Create a wrapper table
WrappedMe = {}

-- Hold the underlying userdata object reference
WrappedMe.usrdata = mq.TLO.Me

-- Create a meta table for WrappedMe to handle new vs old behavior
setmetatable(WrappedMe, {
   __index = function(table, key)
      if WrappedMe[key] then
         return WrappedMe[key]
      else if WrappedMe.usrdata[key] then
            return WrappedMe.usrdata[key]
         else
            return nil
         end
      end
   end
})

function WrappedMe:ShortClass()
   return self.usrdata.Class.ShortName()
end

-- Old behavior
assert(WrappedMe.usrdata.Class.ShortName(), 'BST')

-- New behavior
assert(WrappedMe:ShortClass(), 'BST')