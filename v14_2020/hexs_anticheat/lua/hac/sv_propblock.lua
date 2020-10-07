HAC.Prop = {
	BadPaths = {"../", "..\\",},
}

function HAC.Prop.PlayerSpawnObject(ply, Args1, Args2)
	if not IsValid(ply) or not Args1 then return false end
	Args2 = Args2 or ""
	if tostring(Args2) == "0.00" and tostring(Args1):Check("models\\props/") then return end
	local Found, IDX, det = Args1:InTable(HAC.Prop.BadPaths)

	if Found then
		ply:LogOnly(Format("PlayerSpawnObject[[%s]],[[%s]] (%s)", Args1, Args2, det))
		--Fruit & Sound
		ply:Fruit()
		ply:Holdup()

		return false
	end
end

hook.Add("PlayerSpawnObject", "HAC.Prop.PlayerSpawnObject", HAC.Prop.PlayerSpawnObject)
