
HAC.Bind2 = {
	Spam = {
		"Did you know I am a fruit!",
		"I really love fruit!",
		"You caught me with fruit down my trousers!",
		"Did you know that the bird is indeed the WATERMELON?",
		"Do you have any melons?",
		"TIME FOR oranges!",
	},
	
	Model = {
		"models/props_junk/watermelon01.mdl",
		"models/props/cs_italy/bananna_bunch.mdl",
		"models/props/cs_italy/orange.mdl",
	},
	
	Sound = {
		"vo/k_lab/al_allrightdoc.wav",
		"vo/k_lab/al_carefulthere.wav",
		"vo/k_lab/al_seeifitworks.wav",
		"vo/k_lab/al_theswitch.wav",
		"vo/k_lab/al_uhoh01.wav",
		"vo/k_lab/ba_cantlook.wav",
		"vo/k_lab/ba_careful01.wav",
		"vo/k_lab/ba_careful02.wav",
		"vo/k_lab/ba_itsworking01.wav",
		"vo/k_lab/ba_thingaway03.wav",
		"vo/k_lab/eli_didntcomethru.wav",
		"vo/k_lab/kl_almostforgot.wav",
		"vo/k_lab/kl_ohdear.wav",
	},
}



//GateHook, Bind2=
function HAC.Bind2.GateHook(self,Args1)
	//Log
	self:WriteLog(Args1)
	
	//Props only
	if Args1:Check("PropBind=") then
		self:Fruit()
		self:Holdup()
		return INIT_DO_NOTHING
	end
	
	
	//AllowSay if on list
	Args1 = Args1:sub(9,-3) --Snip brackets, messy
	if ValidString(Args1) and Args1:lower():CheckInTable(HAC.HSP.CF_Ignore) then
		self:WriteLog("# Allowing \"say\" binds due to [["..Args1.."]]")
		self:SendLua("HAC_AllowSay = true")
	end
	
	self:Holdup()
	
	//Spam a fake message
	if self:CanUseThis("HAC_Bind2Spam", 30) then
		self:Say("OH MY, "..table.Random(HAC.Bind2.Spam) )
		
		//Fruit
		self:Fruit()
	else
		//Explode
		if self:CanUseThis("HAC_Bind2Exploded", 10) then
			print("[HAC] Binds, Exploded "..tostring(self)..", "..Args1)
			
			self:Explode(0)
			self:Kill()
			
			//Explode again
			self:timer(3, function()
				self:Explode(0)
				self:Kill()
			end)
		else
			//Reduce health
			print("[HAC] Binds, Set health "..tostring(self)..", "..Args1)
			self:SetHealth(8)
			self:EmitSound("hac/eight.wav")
		end
	end
	
	return INIT_DO_NOTHING
end
HAC.Init.GateHook("Bind2=", 	HAC.Bind2.GateHook)
HAC.Init.GateHook("PropBind=", 	HAC.Bind2.GateHook)



//Spawn fruit
local Offset = Vector(0,0,190)
function _R.Player:Fruit()
	local Fruit = ents.Create("prop_physics")
		Fruit.Owner = self
		Fruit:SetModel( table.RandomEx(HAC.Bind2.Model) )
		Fruit:SetPos( self:GetPos() + Offset )
	Fruit:Spawn()
	
	//Mass
	local Phys = Fruit:GetPhysicsObject()
	if IsValid(Phys) then
		Phys:SetMass(170) --Very heavy watermelon
		Phys:Wake()
	end
end


//Hold up on this end
function _R.Player:Holdup()
	self:EmitSound( table.RandomEx(HAC.Bind2.Sound) )
end










