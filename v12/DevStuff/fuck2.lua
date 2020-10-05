

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


function DoLibrary(str)
	if not _G[str] then return end
	
	local FuncTab = GetFunctions( _G[str] )
	
	if FuncTab then
		for k,v in pairs(FuncTab) do
			print("! DoLibrary: ", "_G."..str.."."..v)
		end
	end
end




local GStandard = {
	"_G",
	"_R",
	"_E",
}


for k,v in pairs(_G) do
	if ( type(v) == "table" and type(k) == "string" and not table.HasValue(GStandard, k) ) then
		DoLibrary( tostring(k) )
	end
end




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









