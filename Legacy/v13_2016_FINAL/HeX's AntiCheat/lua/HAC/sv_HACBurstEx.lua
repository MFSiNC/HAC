HAC.BCEx = {
	Timeout = 90,
	SC_KillAt = 150, --Bursts, stop SC if > this Rem

}

util.AddNetworkString("netburst") --Used in net.lua!

function _R.Player:BurstRem()
	return self.HAC_BurstRem or 0
end

--In progress
function _R.Player:Burst_InProgress()
	if self.HAC_DoneAllBursts then return false end
	self.HAC_BanOnEndBursts = true

	--Timeout
	self:TimerCreate("Burst_InProgress", HAC.BCEx.Timeout, 1, function()
		--Override
		if not self:VarSet("HAC_DoneAllBursts") then
			self:SetTimer(HAC.hac_wait:GetInt() / 3, "BurstTimeout")
			self:DoBan("! NetBurst timeout (" .. HAC.BCEx.Timeout .. "), banning!")
		end
	end)

	local Rem = self:BurstRem()
	self:WriteLog("# Burst_InProgress(" .. Rem .. ")")

	--No more screenshots if sending loads!
	if Rem > HAC.BCEx.SC_KillAt then
		if self:KillSC() then
			self:WriteLog("! KillSC, too many Rem (" .. Rem .. " > " .. HAC.BCEx.SC_KillAt .. ")")
		end
	end

	return Rem > 0
end

--End
function HAC.BCEx.BurstEnd(self)
	if not self.HAC_BanOnEndBursts then return end
	self.HAC_BanOnEndBursts = false
	self.HAC_DoneAllBursts = true

	if self:Banned() and not self:JustBeforeBan() then
		self:SetTimer(20, "BurstEnd")
		self:DoBan("# Burst complete, banning!")
	end
end

hook.Add("NetBurstEnd", "HAC.BCEx.BurstEnd", HAC.BCEx.BurstEnd)

--Toggle
function HAC.BCEx.ToggleHook()
	for k, v in Humans() do
		if v:BurstRem() > 0 then
			if not v.HAC_HBRem_One then
				v.HAC_HBRem_One = true
				v.HAC_HBRem_Two = false
				v.HAC_HBDidStart = true
				hook.Call("NetBurstStart", nil, v)
			end
		else
			if not v.HAC_HBRem_Two then
				v.HAC_HBRem_Two = true
				v.HAC_HBRem_One = false

				if v.HAC_HBDidStart then
					hook.Call("NetBurstEnd", nil, v)
				end
			end
		end
	end
end

hook.Add("Think", "HAC.BCEx.ToggleHook", HAC.BCEx.ToggleHook)

--Remaining
concommand.Add("rem", function(self)
	for k, v in Humans() do
		self:print(v:BurstRem() .. "\t" .. v:HAC_Info() .. "\t" .. v:TimerLeft())
	end
end)

function HAC.BCEx.Toggle(self, cmd, args)
	net.DEBUG = not net.DEBUG
	self:print("! Debug: " .. tostring(DEBUG))
end

concommand.Add("hb_debug", HAC.BCEx.Toggle)

--Error calls from NetBurst
HAC.BCEx.ErrorLookup = {
	[1] = {"CheckFakeStream fail", HAC.Msg.HB_Bad},
	[2] = {"Same IDX as a previous stream", HAC.Msg.HB_Same},
	[3] = {"IF NOT HANDLED", HAC.Msg.HB_Gone},
	[4] = {"B64 DECODE", HAC.Msg.HB_Cont},
	[5] = {"DECOMPRESS", HAC.Msg.HB_Comp},
	[6] = {"CALL FINISH", HAC.Msg.HB_Fail},
	[7] = {"Split > Buff[ idx ].Total", HAC.Msg.HB_Buff},
}

function HAC.BCEx.Error(self, err, index)
	if not IsValid(self) or index == 2 then return end --Skip "Same IDX as a previous stream"
	local Tab = HAC.BCEx.ErrorLookup[index]

	if not Tab then
		debug.ErrorNoHalt("HAC.BCEx.Error: No Tab for " .. index .. "," .. err)

		return
	end

	if not self:VarSet("HAC_DoneHBError_" .. (index .. ":" .. Tab[1])) then
		self:FailInit("NB error (SV): '" .. err .. "' IDX:" .. index .. " (" .. Tab[1] .. ")", Tab[2])
	end
end

hook.Add("netburst", "HAC.BCEx.Error", HAC.BCEx.Error)
