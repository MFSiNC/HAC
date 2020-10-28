
//GMID
HAC.BCode.Add("bc_GMID.lua", "32145132", {obf = 1, over = 1} )

--[[
	log all alts to HAC_ALT/SID.txt:
	steamid\n
	name\n
	
	"Updated Alt of" ply to SteamID, overwrite file and LOG TO HAC_ALTS.TXT
]]

--ID_NoRX
--ID_Double
--ID_Empty
--ID_Size
--ID_NoSteam
--ID_Skiddie
--ID_NoWrite



HAC.GMID = {}

//Finish
function HAC.GMID.Finish(GMID,len,sID,idx,Total,self)
	//String
	if not ValidString(GMID) then self:FailInit("ID_NO_RX", HAC.Msg.ID_NoRX) return end
	
	//Double
	if self.HAC_GMID then self:FailInit("ID_DOUBLE ("..GMID.." != "..self.HAC_GMID..")", HAC.Msg.ID_Double) return end
	self.HAC_GMID = GMID
	
	//Empty
	if GMID == "GE" then self:FailInit("ID_EMPTY", HAC.Msg.ID_Empty) return end
	
	//New, no GMID
	if GMID == "G" then
		self:MakeGMID(true)
		return
	end
	
	//Size
	if #GMID > 66 then self:FailInit("ID_SIZE_ERR ("..#GMID.." > 66)", HAC.Msg.ID_Size) return end
	
	//SteamID
	GMID = GMID:match("(STEAM_(%d+):(%d+):(%d+))")
	if not ValidString(GMID) then
		self:FailInit("ID_NO_STEAM", HAC.Msg.ID_NoSteam)
		self:MakeGMID()
		return
	end
	
	//Same player
	if GMID == self:SteamID() then return end
	
	
	//SkidCheck
	local gSID = GMID:SID()
	local Skid = HAC.Skiddies[ gSID ]
	if Skid then
		self:FailInit("GMID_ALT ("..GMID.."), Skid: "..Skid, HAC.Msg.ID_Skiddie)
	end
	
	//Database, banned before
	local InDB,Info = HAC.InDB(gSID)
	if InDB then
		self:DoBan("GMID_ALT ("..GMID.."), InDB: "..Info[3] )
		return
	end
	
	//Auth log
	if file.Exists("hac_auth_log.txt", "DATA") then
		local Cont = HAC.file.Read("hac_auth_log.txt", "DATA")
		if not ValidString(Cont) then ErrorNoHalt("[HAC] sv_GMID, can't read hac_auth_log.txt!\n") return end
		
		local Auth = Cont:Split("\r\n")
		if table.Count(Auth) == 0 then ErrorNoHalt("[HAC] sv_GMID, Auth == 0!\n") return end
		
		local Found,IDX,det = GMID:InTable(Auth)
		if Found then
			
		end
		
		--[[
		for line,str in pairs( Cont:Split("\r\n") ) do
			if str:find(GMID, nil,true) then
				--log
				--print("! got", GMID, str)
				break
			end
		end
		]]
	end
end
hacburst.Hook("GMID", HAC.GMID.Finish)


//Spawn
function HAC.GMID.Spawn(self)
	if self:IsBot() or self:HAC_IsHeX() then return end
	
	self:MakeGMID()
end
hook.Add("PlayerInitialSpawn", "HAC.GMID.Spawn". HAC.GMID.Spawn)


//Make GMID
function _R.Player:MakeGMID(is_new)
	if self.HAC_DoneGMID then
		//Trigger
		timer.Simple(10, function()
			if IsValid(self) then
				umsg.Start("GMID", self)
				umsg.End()
			end
		end)
		
		return
	end
	self.HAC_DoneGMID = true
	
	//New
	if is_new then
		--log to alts db, new
	end
	
	//Burst
	local function Edit(Cont)
		return Cont:Replace("__SID__", self:SteamID() )
	end
	self:BurstCode("bc_GMID.lua", nil, Edit)
	
	//Trigger, call self, will set off timer
	self:MakeGMID()
end


//GateHooks
HAC.Init.GateHook("GMID=NoWrite", HAC.Msg.ID_NoWrite)




/*
//Clear GMID, DO NOT USE
function _R.Player:ClearGMID()
	self:SendLua([[ file.Delete("Expression2/e2shared/slime_made_by_EFR_Skillet.txt") ]])
end

function HAC.GMID.ConCommand(ply,cmd,args)
	if not ply:IsSuperAdmin() then return end
	
	if #args == 0 then
		ply:print("[HAC] No args, give userid!")
		return
	end
	
	local Him = Player( tonumber( args[1] ) )
	if IsValid(Him) then
		Him:ClearGMID()
		
		ply:print("[HAC] ClearGMID "..tostring(Him) )
	else
		ply:print("[HAC] Invalid userid!")
	end
end
concommand.Add("gmid", HAC.GMID.ConCommand)
*/









