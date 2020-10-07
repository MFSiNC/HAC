
----------------------------------------
--         2014-07-12 20:32:47          --
------------------------------------------
--[[

	=== HSP plugin module ===

	sh_MissingVehicles, v1.1

	The vehicles garry didn't want you to have!

]]





if SERVER then

	HSP.AddTexture("materials/vgui/entities/outer_pod")

end





local function HandleRollercoasterAnimation(veh,ply)

	return ply:SelectWeightedSequence(ACT_GMOD_SIT_ROLLERCOASTER) 

end



list.Set("Vehicles", "seat_jalopy", { 	

	Name		= "Jalopy Seat", 

	Class		= "prop_vehicle_prisoner_pod",

	Category	= "Half-Life 2",

	Author		= "HeX",

	Information = "The seat garry didn't want you to have",

	Model		= "models/Nova/jalopy_seat.mdl",

	

	KeyValues = {

		vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",

		limitview		=	"0"

	},



	Members = {

		HandleAnimation = HandleRollercoasterAnimation,

	},

})



list.Set("Vehicles", "outer_pod", {

	Name		= "GMod 9 Pod", 

	Class		= "prop_vehicle_prisoner_pod",

	Category	= "Half-Life 2",

	Author		= "VALVe",

	Information	= "The GMod 9 pod.",

	Model		= "models/vehicles/prisoner_pod.mdl",

	

	KeyValues = {

		vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",

	},

})




