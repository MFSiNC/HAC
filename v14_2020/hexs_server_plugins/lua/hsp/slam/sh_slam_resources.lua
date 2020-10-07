
----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	sh_SLAM_Resources, v1.0

	Fix the SLAM sounds

]]





if SERVER then

	resource.AddFile("sound/weapons/tripwire/hook.wav")

	--resource.AddFile("sound/weapons/tripwire/mine_activate.wav")

end





sound.Add(

	{

		name 		= "Weapon_SLAM.SatchelThrow",

		channel 	= CHAN_VOICE,

		volume 		= 0.7,

		soundlevel 	= SNDLVL_75dB,

		sound 		= "weapons/slam/throw.wav",

	}

)



sound.Add(

	{

		name 		= "Weapon_SLAM.TripMineMode",

		channel 	= CHAN_VOICE,

		volume 		= 0.7,

		soundlevel 	= SNDLVL_75dB,

		sound 		= "weapons/slam/mine_mode.wav",

	}

)



sound.Add(

	{

		name 		= "Weapon_SLAM.SatchelDetonate",

		channel 	= CHAN_VOICE,

		volume 		= 0.7,

		soundlevel 	= SNDLVL_75dB,

		sound 		= "UI/buttonclick.wav",

	}

)



sound.Add(

	{

		name 		= "TripmineGrenade.Place",

		channel 	= CHAN_WEAPON,

		volume 		= 0.95,

		soundlevel 	= SNDLVL_70dB,

		sound 		= "weapons/tripwire/hook.wav",

	}

)



sound.Add(

	{

		name 		= "TripmineGrenade.Activate",

		channel 	= CHAN_WEAPON,

		volume 		= 0.95,

		soundlevel 	= SNDLVL_70dB,

		--sound 		= "weapons/tripwire/mine_activate.wav",

		sound		= "npc/roller/mine/combine_mine_deploy1.wav"

	}

)



































