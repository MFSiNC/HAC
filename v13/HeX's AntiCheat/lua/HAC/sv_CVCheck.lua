
HAC.CVC = {
	General = {
		--["mat_dxlevel"] = { {"80", "81", "90", "91", "92", "95"}, HAC.Msg.CV_DXLevel}, --	CV_DXLevel	= "Error #H159, Your DirectX level is too low, please set mat_dxlevel to \"95\". If that doesn't work, your graphics card is too old and you'll need a new one. "..HAC.Contact,
	},
}

resource.AddFile("sound/hac/serious_loud.mp3")
resource.AddFile("sound/hac/eight.wav")


local function Fuckup(self,err)
	ErrorNoHalt(err)
	self:FailInit(err, HAC.Msg.CV_Failure)
end

//Check
local Block = true
function _R.Player:CheckCVars()
	if Block then return end
	if not IsValid(self) or self:IsBot() then return end
	
	//All
	for cvar,v in pairs(HAC.CLIENT.White_CVTab) do
		//Callback
		local function OnFinished(enum,name,value)
			if not IsValid(self) then return end
			
			local ret,err = pcall(function()
				if HAC.Conf.Debug then print("CVC: ", cvar,enum,name,value,self) end
				
				//Valid
				local BadRes = HAC.CVC.BadRes[ enum ]
				if BadRes then
					self:FailInit("CVCheck_Err: "..cvar.." == "..BadRes, HAC.Msg.CV_BadRes)
					return
				end
				
				//Name
				if name != cvar then
					local Reason = "CVCheck_Name: "..name.." != "..cvar
					self:DoBan(Reason)
					
					//Serious
					self:DoSerious(Reason)
				end
				
				//Value
				local Str = v.Str
				if value != Str then
					local Reason = "CVCheck: "..cvar.." ("..name..") [["..value.."]] != "..Str
					self:DoBan(Reason)
					
					//Serious
					self:DoSerious(Reason)
				end
			end)
			
			if err then
				Fuckup(self, "CheckCVars("..self:HAC_Info()..", "..cvar..") error ("..tostring(err)..")!\n")
			end
		end
		
		//Check
		if not self:StartQueryCvarValue(cvar, OnFinished) then
			Fuckup(self, "CheckCVars("..self:HAC_Info()..", "..cvar..") failed!\n")
		end
	end
	
	
	
	//General
	for cvar,v in pairs(HAC.CVC.General) do
		//Callback
		local function OnFinished_Gen(enum,name,value)
			if not IsValid(self) then return end
			
			//Value
			local ret,err = pcall(function()
				local Exp = v[1]
				
				//Multiple values allowed
				if istable(Exp) then
					if not table.HasValue(Exp, value) then
						//Fail
						self:FailInit("CVCheck_Gen: "..cvar.." [["..value.."]] != "..table.ToString(Exp), v[2] )
					end
					
				//One value
				else
					if value != Exp then
						//Fail
						self:FailInit("CVCheck_Gen: "..cvar.." [["..value.."]] != "..Exp, v[2] )
					end
				end
			end)
			
			if err then
				Fuckup(self, "CheckCVars_Gen("..self:HAC_Info()..", "..cvar..") error ("..tostring(err)..")!\n")
			end
		end
		
		//Check
		if not self:StartQueryCvarValue(cvar, OnFinished_Gen) then
			Fuckup(self, "CheckCVars_Gen("..self:HAC_Info()..", "..cvar..") failed!\n")
		end
	end
end


//Spawn
function HAC.CVC.Spawn(self)
	HAC.CVC.Timer()
	if self:IsBot() then return end
	
	//Every
	local TID = "HAC.CVC.Every_"..tostring(self)
	timer.Create(TID, 20, 0, function()
		if IsValid(self) then
			self:CheckCVars()
		else
			timer.Destroy(TID)
		end
	end)
end
hook.Add("PlayerInitialSpawn", "HAC.CVC.Spawn", HAC.CVC.Spawn)

//ReallySpawn
function HAC.CVC.ReallySpawn(self)
	self:CheckCVars()
end
hook.Add("HACReallySpawn", "HAC.CVC.ReallySpawn", HAC.CVC.ReallySpawn)



//Timer
function HAC.CVC.Timer()
	if HAC.CVC.BadRes then return end
	if not CVAR_INTACT then
		ErrorNoHalt("\nsv_CVar.lua: pl_CVCheck.dll missing!\n\n")
		_R.Player.CheckCVars = Useless
		return
	end
	
	HAC.CVC.BadRes = {
		[CVAR_NOT_FOUND]	= "CVAR_NOT_FOUND",
		[CVAR_NOT_A_CVAR]	= "CVAR_NOT_A_CVAR",
		[CVAR_PROTECTED] 	= "CVAR_PROTECTED",
	}
	
	Block = false
end
timer.Simple(2, HAC.CVC.Timer)

//Shutdown
function HAC.CVC.Kill()
	Block = true
	_R.Player.CheckCVars = Useless
end
hook.Add("ShutDown", "HAC.CVC.Kill", HAC.CVC.Kill)













