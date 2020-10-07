HAC.Func = {}

--Gatehook
function HAC.Func.GateHook(self, Args1, args)
	--Gone
	if Args1:Check("FuncThis_GONE") then return INIT_BAN end
	--Check args
	local k, Res, c, Call = args[2], args[3], args[4], args[5]

	if not (ValidString(k) and ValidString(Res) and ValidString(c) and ValidString(Call)) then
		self:FailInit(Format("FuncThis=BadArgs [" .. Args1 .. "] k(%s), Res(%s), c(%s), Call(%s)", tostring(k), tostring(Res), tostring(c), tostring(Call)), HAC.Msg.FC_BadFuncs)

		return INIT_DO_NOTHING
	end

	--Save
	self:Write("functhis", Format('\n{"%s",\t%s%s,\t%s},', k, (k:Check("Not") and "_H." or "_E."), k, Res))
	--Log
	self:LogOnly(Format("FuncThis=%s (%s != %s) [%s]", k, Res, c, Call))

	return INIT_DO_NOTHING
end

HAC.Init.GateHook("FuncThis=", HAC.Func.GateHook)
