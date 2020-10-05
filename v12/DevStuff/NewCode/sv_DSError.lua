






function HAC.DataStreamError(ply,han,dsid,enc,dec)
	
	return false --Don't error
end
hook.Add("DataStreamError", "HAC.DataStreamError", HAC.DataStreamError)











