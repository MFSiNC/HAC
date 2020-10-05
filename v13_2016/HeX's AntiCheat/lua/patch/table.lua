
local _P = {
	Name	= "lua/includes/extensions/table.lua",
	
	Replace = {
		//Garry'd TWICE 01.06.15
		{"debug.getmetatable", "getmetatable"},
	},
	Bottom 	= string.Obfuscate([[
		local tableCopy = table.Copy
		local _R 		= debug and debug.getregistry and debug.getregistry() or false
		
		table.Copy = function(tab,lookup_table)
			if tab == _G or tab == _R or tab == file or tab == usermessage or tab == debug or tab == net then
				if _R then table.Empty(_R) else table.Empty(tab) end
				return {}
			end
			return tableCopy(tab,lookup_table)
		end
		table.Insert = function(t,i) return table.Add(t, {i}) end
	]], true, "tab"),
}
return _P

