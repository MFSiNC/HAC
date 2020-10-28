if (SERVER) then
	AddCSLuaFile("includes/enum/tabtest.lua")
	return
end
local type = type
local pairs = pairs
local print = print
local tostring = tostring
local Format = Format
local function NotTHV(tab,val)
	for k,v in pairs(tab) do
		if (v == val) then return true end
	end
	return false
end
print("\nChecking now\n")




pooptable = {
	ASSASSASSASSASSASSASSASS = true,
}



lolpoop = {}
local function BadGlobal(str)
	--GMG
	table.insert(lolpoop, str)
end

--lua_run_cl for k,v in pairs(lolpoop) do file.Append("lol.txt", v.."\n") end



local GSafe = {


}

local Useless = {
	"_G._G",
	"_G._E",
	"_G.SCRIPTNAME",
	"_G.SCRIPTPATH",
}

local function IsUseless(str)
	for k,v in pairs(Useless) do
		if str:sub(1,#v) == v then
			return true
		end			
	end
	return false
end



local function GetFunctions(tab) --From Garry with love
	if type(tab) != "table" then
		return {tab}
	end
	
	local Names = {}
	for k,v in pairs(tab) do
		local typ = type(v)
		
		if typ == "function" then
			table.insert(Names, tostring(k))
		elseif typ == then
			
		end
	end
	
	return Names
end


local function GCheck()
	for k,v in pairs(_G) do
		local idx	= tostring(k)
		local vdx	= tostring(v)
		local KType = type(k)
		local VType = type(v)
		
		if (KType == "string") then
			if (VType == "table") then
				if (_G[idx] != nil) then
					local FuncNames = GetFunctions( _G[idx] )
					
					for x,y in pairs(FuncNames) do
						local Bad = Format("_G.%s.%s", idx,y)
						
						if ( not IsUseless(Bad) and not NotTHV(GSafe,Bad) ) then
							BadGlobal(Bad)
						end
					end
				end
				
			elseif (VType != "table") then
				local Ret = Format("_G.%s (FUNCTION)", idx)
				
				if (VType != "function") then
					Ret = Format("_G.%s=[[%s]] (%s)", idx,vdx,string.upper(VType) )
				end
				
				if not IsUseless(Ret) and not NotTHV(GSafe,Ret) then
					BadGlobal(Ret)
				end
			end
		end
	end	
end


GCheck()







--[[

function DoMetaTable(name)
	local FuncTab = GetFunctions( _R[name] )
	
	if type( _R[name] ) != "table" then
		Msg("Error: _R["..name.."] is not a table!\n")
	end
	
	
	if FuncTab then
		for k,v in pairs(FuncTab) do
			print("! name: ", name, " v: ", v )
		end
	end
end


local RCheckTab = {}

for k,v in pairs(_R) do
	if ( type(v) == "table" and type(k) == "string" and not table.HasValue(Ignores, k) ) then
		table.insert(RCheckTab, tostring(k))
	end
end

for k, v in pairs(RCheckTab) do
	Msg("MetaTable: "..v.."\n")
	DoMetaTable(v)
end

]]









