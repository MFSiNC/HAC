
HAC.Last = {
	Filename 	= "hac_lastban.txt",
	AutoTime 	= 120,
}

util.AddNetworkString("HAC.TimeSync")


function HAC.Last.GetLast()
	local Cont = HAC.file.Read(HAC.Last.Filename)
	if not ValidString(Cont) or not Cont:find("STEAM") then return 0,"","" end
	
	local Tab = Cont:Split("\n")
	if #Tab < 3 then debug.ErrorNoHalt("HAC.Last.GetLast: No Tab from "..HAC.Last.Filename) return 0,"","" end
	
	//When,Nick,SID
	return tonumber( Tab[1] ), Tab[2], Tab[3]
end


//Sync to all
function HAC.Last.Sync(override)
	//Don't sync if cheater is currently on
	if #player.AllBanned() > 0 and not override then
		return
	end
	
	//Send
	net.Start("HAC.TimeSync")
		net.WriteInt( os.time(), 32)
		
		local When,Nick,SID = HAC.Last.GetLast()
		net.WriteInt(When, 32)
		net.WriteString(Nick)
		net.WriteString(SID)
	net.SendNonBanned()
end
timer.Create("HAC.Last.Auto", HAC.Last.AutoTime, 0, HAC.Last.Sync)


//Generate
function _R.Player:GenerateLastBan(override)
	if self.HAC_LastBan and not override then return self.HAC_LastBan end
	
	self.HAC_LastBan = Format("%s\n%s\n%s\n%s\n", os.time(), self:Nick():Safe():Left(28), self:SteamID(), HAC.Date() )
	return self.HAC_LastBan
end
//Write main & sync
function _R.Player:WriteLast(override)	
	//Write
	HAC.file.Write(HAC.Last.Filename, self:GenerateLastBan(override) )
	
	//Sync
	if override or not self:Banned() then
		HAC.Last.Sync(override)
	end
end
//Write
function _R.Player:WriteLastInFolder()
	if self:VarSet("HAC_HasWrittenLastBan") then return end
	
	self:Write("hac_lastban", self:GenerateLastBan(), true,true)
end



//Spawn
function HAC.Last.Spawn(self)
	if self:IsBot() then return end
	
	HAC.Last.Sync()
end
hook.Add("HACReallySpawn", "HAC.Last.Spawn", HAC.Last.Spawn)












