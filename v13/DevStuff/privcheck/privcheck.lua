
--[[
76561198054974642 --vac, public
76561198096733493 --vac, private

76561197995883976 --no vac, public
76561197999006300 --no vac, private


http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=Gone&steamids=76561197995883976

http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=Gone&format=json&steamids=
]]



//Private profile
if body.communityvisibilitystate and body.communityvisibilitystate != PROF_PUBLIC and not body.timecreated then
	--kick for private profile
end








