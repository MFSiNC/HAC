local a = {"PlayerKilledSelf", "PlayerKilledByPlayer", "PlayerKilled", "PlayerKilledNPC", "NPCKilledNPC",}
for k,v in pairs(a) do
	util.AddNetworkString(v)
end
hook.Add("PlayerKilledSelf", "HSP", function(victim, inflictor, attacker)
	net.Start("PlayerKilledSelf")
	net.WriteEntity(victim)
	net.Broadcast()
end)

hook.Add("PlayerKilledByPlayer", "HSPPlayerKilledByPlayer", function(victim, inflictor, attacker)
	net.Start("PlayerKilledByPlayer")
	net.WriteEntity(victim)
	net.WriteString(tostring(inflictor))
	net.WriteString(tostring(attacker))
	net.Broadcast()
end)

hook.Add("PlayerKilled", "HSPPlayerKilled", function(victim, inflictor, attacker)
	net.Start("PlayerKilled")
	net.WriteEntity(victim)
	net.WriteString(tostring(inflictor))
	net.WriteEntity(attacker)
	net.Broadcast()
end)

hook.Add("PlayerKilledNPC", "HSPPlayerKilledNPC", function(victim, inflictor, attacker)
	net.Start("PlayerKilledNPC")
	net.WriteString(victim:GetClass())
	net.WriteString(tostring(inflictor))
	net.WriteEntity(attacker)
	net.Broadcast()
end)

hook.Add("NPCKilledNPC", "HSPNPCKilledNPC", function(victim, inflictor, attacker)
	net.Start("NPCKilledNPC")
	net.WriteString(tostring(victim))
	net.WriteString(tostring(inflictor))
	net.WriteString(tostring(attacker))
	net.Broadcast()
end)


hook.Add( "PlayerDeath", "HSPDeath", function( victim, inflictor, attacker )
    if ( victim == attacker ) then
        hook.Call("PlayerKilledSelf", victim)
    elseif victim:IsNPC() and attacker:IsNPC() then
    	hook.Run("NPCKilledNPC",victim,inflictor, attacker)
    elseif attacker:IsPlayer() and victim:IsNPC() then
    	hook.Run("PlayerKilledNPC",victim,inflicor, attacker)
    elseif victim:IsPlayer() and attacker:IsPlayer() then
    	hook.Run("PlayerKilledByPlayer",victim,inflictor,attacker)
    else
    	hook.Run("PlayerKilled", victim,inflictor, attacker)
    end
end )
