

--[[
local function Check(SID, what)
	http.Fetch(
		"http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key="..HAC.APIKey.."&steamids="..SID,
		
		function(body, len, headers, code)
			HAC.file.Append(what..".txt", body)
		end,
		
		function(code)
			ErrorNoHalt("VACCheck: Failed HTTP for "..SID.." (Error: "..code..")\n")
		end
	)
end
]]

--[[
76561198054974642 --vac, public
76561198096733493 --vac, private

76561197995883976 --no vac, public
76561197999006300 --no vac, private
]]


--[[
HAC.CheckProf("76561198054974642", "vac_public")
HAC.CheckProf("76561198096733493", "vac_private")

HAC.CheckProf("76561197995883976", "no_vac_public")
HAC.CheckProf("76561197999006300", "no_vac_private")
]]
PrintTable(HAC.PrivateProf)




