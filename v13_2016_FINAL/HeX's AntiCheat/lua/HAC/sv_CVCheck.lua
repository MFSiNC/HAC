
HAC.CVC = {}


local function Fuckup(self,err)
	debug.ErrorNoHalt(err)
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
		local function OnFinished(Res, name,value)
			if not IsValid(self) then return end
			
			local ret,err = pcall(function()
				if HAC.Conf.Debug then print("CVC: ", cvar,Res,name,value,self) end
				
				//Valid, ban if no exist
				local BadRes = HAC.CVC.BadRes[ Res ]
				if BadRes then
					self:DoBan("CVCheck_Err: "..cvar.." == "..BadRes, HAC.Msg.CV_BadRes)
					return
				end
				
				
				//Name
				if name != cvar then
					self:DoBan("CVCheck_Name: "..name.." != "..cvar)
				end
				
				//Value
				local Str = v.Str
				if value != Str then
					self:DoBan("CVCheck: "..cvar.." ("..name..") [["..value.."]] != "..Str)
				end
			end)
			
			if err then
				Fuckup(self, "CheckCVars("..self:HAC_Info()..", "..cvar..") error ("..tostring(err)..")!")
			end
		end
		
		//Check
		if not self:StartQueryCvarValue(cvar, OnFinished) then
			Fuckup(self, "CheckCVars("..self:HAC_Info()..", "..cvar..") failed!")
		end
	end
	
	
	//Check common cvars, if exist, BAN
	if self.HAC_CVC_Selector then
		self.HAC_CVC_Selector:Remove()
	end
	local function Bulk_OnSelect(Selector, k,v)
		
		local function Bulk_OnFinish(Res, name,value)
			if not IsValid(self) then Selector:Remove() return end
			
			local res,err = pcall(function()
				//FOUND, ban!
				local BadRes = HAC.CVC.BadRes[ Res ] or Res
				if Res != CVAR_NOT_FOUND then
					self:DoBan("CVCheck_Bulk: "..v.." ("..tostring(name)..") [["..tostring(value).."]] Res("..BadRes..")")
				end
				
				//Select next
				Selector:Select(0.18)
			end)
			if err then
				Fuckup(self, "CheckCVars_Gen("..self:HAC_Info()..", "..v..") error ("..tostring(err)..")!")
			end
		end
		self:StartQueryCvarValue(v, Bulk_OnFinish)
		
	end
	self.HAC_CVC_Selector = selector.Init(HAC.SERVER.CVC_Blacklist, Bulk_OnSelect, true) --Start now
end


//Spawn
function HAC.CVC.Spawn(self)
	HAC.CVC.Timer()
	if self:IsBot() then return end
	
	//Every
	self:TimerCreate("HAC.CVC.Every", 25, 0, function()
		self:CheckCVars()
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
		debug.ErrorNoHalt("\nsv_CVar.lua: pl_cvquery.dll missing!\n")
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
	Block 					= true
	_R.Player.CheckCVars 	= Useless
end
hook.Add("ShutDown", "HAC.CVC.Kill", HAC.CVC.Kill)













