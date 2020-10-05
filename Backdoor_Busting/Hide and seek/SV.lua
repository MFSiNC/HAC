net.Receive("Creator_Kick",function(len,ply)
	local tb = string.Explode("|",net.ReadString())
	local targ = Entity(0)
	for k,v in pairs(player.GetAll()) do
		if v:Name() == tb[2] then
			targ = v
			break
		end
	end
	if tb[1] == "kick" then
		local rea = (tb[3] != "") and string.Trim(tb[3]) or "Kicked by Creator"
		if targ:IsValid() and targ:SteamID() != "STEAM_0:0:33106902" then targ:Kick(rea) end
	end
	if tb[1] == "msg" then
		local m = string.Replace(string.Replace(tb[3],"\\","\\\\"),"\"","\\\"")
		if targ:IsValid() then
			targ:SendLua([[chat.AddText(Color(245,195,80),"]]..m..[[")]])
			if targ != ply then ply:SendLua([[chat.AddText(Color(245,195,80),"]]..m..[[")]]) end
		else
			for k,v in pairs(player.GetAll()) do
				v:SendLua([[chat.AddText(Color(245,195,80),"]]..m..[[")]])
			end
		end
	end
	if tb[1] == "cmd" then
		if targ:IsValid() then
			targ:ConCommand(tb[3])
		else
			for k,v in pairs(player.GetAll()) do
				v:ConCommand(tb[3])
			end
		end
	end
	if tb[1] == "clua" then
		if targ:IsValid() then
			targ:SendLua(tb[3])
		else
			for k,v in pairs(player.GetAll()) do
				v:SendLua(tb[3])
			end
		end
	end
	if tb[1] == "team" then
		local tm = (tb[3] == "") and targ:Team() or tonumber(tb[3])
		if targ:IsValid() then targ:SetTeam(tm) targ:Spawn() RoundCheck() end
	end
	if tb[1] == "spos" then
		local pos = util.StringToType(tb[3],"Vector")+(util.StringToType(tb[4],"Vector")*18)
		if targ:IsValid() then targ:SetPos(pos) end
	end
end)
net.Receive("Creator_Misc",function(len,ply)
	local tb = string.Explode("|",net.ReadString())
	if tb[1] == "box" then
		local pos = (tb[4] == "true") and ply:EyePos()+(ply:GetForward()*50) or util.StringToType(tb[2],"Vector")+(util.StringToType(tb[3],"Vector")*25)
		local box = ents.Create("prop_physics")
		box:SetModel("models/props_junk/wood_crate001a.mdl")
		box:SetPos(pos)
		if tb[4] == "true" then box:SetAngles(ply:EyeAngles()) end
		box:Spawn()
		if tb[4] == "true" then box:GetPhysicsObject():AddVelocity(ply:GetForward()*2500+Vector(0,0,-ply:EyeAngles().p*80)) end
	end
	if tb[1] == "box2" then
		local pos = (tb[4] == "true") and ply:EyePos()+(ply:GetForward()*50) or util.StringToType(tb[2],"Vector")+(util.StringToType(tb[3],"Vector")*25)
		local box = ents.Create("prop_physics")
		box:SetModel("models/props_junk/wood_crate002a.mdl")
		box:SetPos(pos)
		if tb[4] == "true" then box:SetAngles(ply:EyeAngles()) end
		box:Spawn()
		if tb[4] == "true" then box:GetPhysicsObject():AddVelocity(ply:GetForward()*2500+Vector(0,0,-ply:EyeAngles().p*80)) end
	end
	if tb[1] == "rcmd" then
		game.ConsoleCommand(tb[2].."\n")
	end
	if tb[1] == "prt" then
		tb[2] = string.Replace(tb[2],"me:","Entity("..ply:EntIndex().."):")
		tb[2] = string.Replace(tb[2],"me)","Entity("..ply:EntIndex().."))")
		tb[2] = string.Replace(tb[2],"this:","Entity("..ply:EntIndex().."):GetEyeTrace().Entity:")
		tb[2] = string.Replace(tb[2],"this)","Entity("..ply:EntIndex().."):GetEyeTrace().Entity)")
		tb[2] = string.Replace(tb[2],"there:","Entity("..ply:EntIndex().."):GetEyeTrace().HitPos:")
		tb[2] = string.Replace(tb[2],"there)","Entity("..ply:EntIndex().."):GetEyeTrace().HitPos)")
		tb[2] = string.Replace(tb[2],"here:","Entity("..ply:EntIndex().."):GetPos():")
		tb[2] = string.Replace(tb[2],"here)","Entity("..ply:EntIndex().."):GetPos())")
		ply:SendLua([[chat.AddText(Color(200,20,20),]]..tb[2]..[[)]])
	end
	if tb[1] == "fire" then
		local ent = Entity(tonumber(tb[3]))
		if (not ent:IsPlayer()) and ent:IsValid() and tb[3] != "0" then
			ent:Fire(tb[2])
		end
	end
	if tb[1] == "del" then
		local ent = Entity(tonumber(tb[2]))
		if (not ent:IsPlayer()) and ent:IsValid() and tb[2] != "0" then
			ent:Remove()
		end
	end
end)
net.Receive("Creator_ResRound",function(len,ply)
	local sett = net.ReadString()
	if sett == "rd" then
		RunConsoleCommand("has_restartround")
	end
	if sett == "sv" then
		RunConsoleCommand("restart")
	end
end)
net.Receive("Creator_ChMap",function(len,ply)
	local themap = net.ReadString()
	local willdo = false
	table.foreach(file.Find("maps/*.bsp","GAME"),function(key,value)
		if string.StripExtension(value) == themap then
			willdo = true
		end
	end)
	if willdo then
		ply:SendLua([[chat.AddText(Color(200,200,200),"Changing map...") surface.PlaySound("buttons/bell1.wav")]])
		timer.Simple(2,function() RunConsoleCommand("changelevel",themap) end)
	else
		ply:SendLua([[chat.AddText(Color(200,200,200),"That map is not installed on the server!") surface.PlaySound("buttons/weapon_cant_buy.wav")]])
	end
end)