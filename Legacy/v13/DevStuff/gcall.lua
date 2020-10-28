

local rawset = rawset
local rawget = rawget
local print = print

local Ran1 = false
local Ran2 = false
--[[
local Tab = {}

setmetatable(Tab,
	{
		__newindex = function(t,k,v)
			Ran1 = true
			rawset(t,k,v)
		end,
		
		__call = function(t,k)
			Ran2 = true
			return rawget(t,k)
		end
	}
)

Tab.hook = "lol"

local Ran3 = Tab("hook")

print("! Ran: ", Ran1, Ran2)

]]

_G.lol = nil

setmetatable(_G,
	{
		__newindex = function(t,k,v)
			Ran1 = true
			rawset(t,k,v)
		end,
		
		__call = function(t,k)
			Ran2 = true
			return rawget(t,k)
		end
	}
)



_G.lol = "lol"

local Ret3 = _G("lol")

print("! Ran: ", Ran1, Ran2, Ret3)


setmetatable(_G, nil)

