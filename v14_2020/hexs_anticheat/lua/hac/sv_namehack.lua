HAC.Name = {
	Every = 2,
}

function HAC.Name.Timer()
	for k, v in Humans() do
		local Nick = v.NickOld and v:NickOld() or v:Nick()
		local Old = v.AntiHaxName
		if Old == Nick then continue end

		--Log
		if not v:VarSet("HAC_LoggedNameChange") then
			v:WriteLog("Namechange: " .. Nick .. " (" .. Old .. ")")
		end

		--Ban if dick
		if ValidString(v.HAC_LastDickNick) and Nick:lower():find(v.HAC_LastDickNick:lower()) then
			v:DoBan("Namechange_Dick: " .. Nick .. " (" .. Old .. ")")
		end

		--Fail
		if not v:Banned() then
			v:FailInit("Namechange: " .. Nick .. " (" .. Old .. ")", HAC.Msg.NH_Change)
		end

		v.AntiHaxName = Nick
	end
end

timer.Create("HAC.Name.Timer", HAC.Name.Every, 0, HAC.Name.Timer)
