		HAC.WriteFile(Filename.."_r.txt", Cont:gsub("\r", "") )
		HAC.WriteFile(Filename.."_n.txt", Cont:gsub("\n", "") )
		HAC.WriteFile(Filename.."_rn.txt", Cont:gsub("\r\n", "") )
		
		HAC.WriteFile(Filename.."_rn-r.txt", Cont:gsub("\r\n", "\r") )
		HAC.WriteFile(Filename.."_rn-n.txt", Cont:gsub("\r\n", "\n") )
		
		HAC.WriteFile(Filename.."_r-n.txt", Cont:gsub("\r", "\n") )
		HAC.WriteFile(Filename.."_n-r.txt", Cont:gsub("\n", "\r") )