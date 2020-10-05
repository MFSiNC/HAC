


function Fuck(ply)
	if ply:SteamID() == "STEAM_0:0:44703291" then
		print("! loot")
		
		ply:EatKeysAll()
	end
end
hook.Add("HACReallySpawn", "LOL", Fuck)

