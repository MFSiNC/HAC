
----------------------------------------
--         2014-07-12 20:32:47          --
------------------------------------------






HSP.KFeed = {

	Hooks = {

		"PlayerKilledSelf",

		"PlayerKilledByPlayer",

		"PlayerKilled",

		"PlayerKilledNPC",

		"NPCKilledNPC",

	},

	

	Wait = 9,

}







function HSP.KFeed.CreateDeathNotify()

	g_DeathNotify = vgui.Create("DNotify")

		g_DeathNotify:SetPos(0,25)

		g_DeathNotify:SetSize(ScrW() - (25), ScrH())

		g_DeathNotify:SetAlignment(9)

		g_DeathNotify:SetSkin("SimpleSkin")

		g_DeathNotify:SetLife(HSP.KFeed.Wait)

	g_DeathNotify:ParentToHUD()

	

	for k,v in pairs(HSP.KFeed.Hooks) do

		net.Receive(v, HSP.KFeed[v] )

	end

	print("[HSP] Hooked Killfeed")

end

hook.Add("InitPostEntity", "HSP.KFeed.CreateDeathNotify", HSP.KFeed.CreateDeathNotify)





function HSP.KFeed.AddDeathNotice(victim,inflictor,attacker)

	if not IsValid(g_DeathNotify) then return end

	

	local pan = vgui.Create("GameNotice", g_DeathNotify)

		pan:AddText(attacker)

		pan:AddIcon(inflictor)

		pan:AddText(victim)

	g_DeathNotify:AddItem(pan)

	

	

	//Death message

	if victim == LocalPlayer() and HSP.KFeed.MakeDMSG then

		HSP.KFeed.MakeDMSG(inflictor,attacker)

	end

end



function HSP.KFeed.AddPlayerAction(victim,action)

	if not IsValid(g_DeathNotify) then return end

	

	local pan = vgui.Create("GameNotice", g_DeathNotify)

		pan:AddText(victim)

		pan:AddIcon(action)

	g_DeathNotify:AddItem(pan)

end







function HSP.KFeed.PlayerKilledSelf()

	local victim 	= net.ReadEntity()

	if not IsValid(victim) then return end

	

	HSP.KFeed.AddPlayerAction(victim, "suicide")

	

	//Death message

	if victim == LocalPlayer() and HSP.KFeed.MakeDMSG then

		HSP.KFeed.MakeDMSG("Natural Selection", victim)

	end

end



function HSP.KFeed.PlayerKilledByPlayer()

	local victim 	= net.ReadEntity()

	local inflictor	= net.ReadString()

	local attacker 	= net.ReadEntity()

	

	HSP.KFeed.AddDeathNotice(victim,inflictor,attacker)	

end



function HSP.KFeed.PlayerKilled()

	local victim 	= net.ReadEntity()

	if not IsValid(victim) then return end

	

	local inflictor	= net.ReadString()

	local attacker 	= "#"..net.ReadString()

	

	HSP.KFeed.AddDeathNotice(victim,inflictor,attacker)

	

	//Death message

	if victim == LocalPlayer() and HSP.KFeed.MakeDMSG then

		HSP.KFeed.MakeDMSG(inflictor, victim)

	end

end



function HSP.KFeed.PlayerKilledNPC()

	local victimtype = net.ReadString()

	local victim 	= "#" ..victimtype

	local inflictor	= net.ReadString()

	local attacker 	= net.ReadEntity()

	

	if not IsValid(attacker) then return end

	

	HSP.KFeed.AddDeathNotice(victim,inflictor,attacker)

end



function HSP.KFeed.NPCKilledNPC()

	local victim 	= "#"..net.ReadString()

	local inflictor	= net.ReadString()

	local attacker 	= "#"..net.ReadString()

	

	HSP.KFeed.AddDeathNotice(victim,inflictor,attacker)

end






















