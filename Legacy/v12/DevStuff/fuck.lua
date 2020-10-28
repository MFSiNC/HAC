local function NotTHV(tab,val)
	for k,v in pairs(tab) do
		if (v == val) then return true end
	end
	return false
end
local pairs = pairs
local print = print
local tostring = tostring





function GetFunctions(tab) --From Garry with love
	local funcs = {}
	
	if type(tab) == "string" then
		return {tab}
		
	elseif type(tab) != "table" then
		return false
		
	end
	
	for k,v in pairs(tab) do
		if type(v) == "function" then
			table.insert(funcs, tostring(k))
		end
	end
	
	return funcs
end

FUCKFUCKFUCKFUCKFUCKFUCK = true
pooptable = {
	ASSASSASSASSASSASSASSASS = true,
}


local GSafe = {
	"_G",
	"_R",
	"_E",
}


function DoLibrary(lib)
	for k,v in pairs(lib) do
		if ( type(v) == "table" and type(k) == "string" and not NotTHV(GSafe,k) ) then
			local str = tostring(k)
			
			if _G[str] then
				local FuncNames = GetFunctions( _G[str] )
				
				if FuncNames then
					for k,v in pairs(FuncNames) do
						print("! DoLibrary: ", "_G."..str.."."..v)
					end
				end
			end
		else
			local k,v = tostring(k), tostring(v)
			print("? GLOBAL: ", "_G."..k.."."..v)
		end
	end	
end


DoLibrary(_G)







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









