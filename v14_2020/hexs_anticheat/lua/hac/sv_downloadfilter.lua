HAC.DLF = {}

function HAC.DLF.Finish(str, len, sID, idx, Total, self)
	--String
	if not ValidString(str) then
		self:FailInit("CC_NO_RX", HAC.Msg.DL_NoRX)

		return
	end

	--dec
	local dec = util.JSONToTable(str)

	if not istable(dec) then
		self:FailInit("CC_NO_DEC", HAC.Msg.DL_NoDec)

		return
	end

	--dec count
	if #dec ~= #HAC.SERVER.HaveToExist then
		self:FailInit("CC_DEC_NOT_TOT (" .. table.Count(dec) .. ")", HAC.Msg.DL_Count)

		return
	end

	--Check
	for k, v in pairs(dec) do
		local File = HAC.SERVER.HaveToExist[k]

		--Error
		if not File then
			self:FailInit("MissingFile_E=" .. File, HAC.Msg.DL_NotFile)
			continue
		end

		--Missing
		if v ~= 1 then
			self:FailInit("MissingFile=" .. File, HAC.Msg.DL_NoFiles)
		end
	end
end

net.Hook("DLF", HAC.DLF.Finish)
