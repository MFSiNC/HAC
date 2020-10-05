


local Dir = "buff"
local Done = "hac_buff.txt"


local Binds = {
	[["PGDN"]],
	[["PGUP"]],
	[["NUMLOCK"]],
	[["CAPSLOCK"]],
	[["BACKSPACE"]],
	[["/"]],
	[["0"]],
	[["1"]],
	[["2"]],
	[["3"]],
	[["4"]],
	[["5"]],
	[["6"]],
	[["7"]],
	[["8"]],
	[["9"]],
	[["a"]],
	[["b"]],
	[["c"]],
	[["d"]],
	[["e"]],
	[["f"]],
	[["g"]],
	[["h"]],
	[["i"]],
	[["j"]],
	[["k"]],
	[["l"]],
	[["m"]],
	[["n"]],
	[["o"]],
	[["p"]],
	[["q"]],
	[["r"]],
	[["s"]],
	[["t"]],
	[["u"]],
	[["v"]],
	[["w"]],
	[["x"]],
	[["y"]],
	[["z"]],
	[["KP_INS"]],
	[["KP_END"]],
	[["KP_DOWNARROW"]],
	[["KP_PGDN"]],
	[["KP_LEFTARROW"]],
	[["KP_5"]],
	[["KP_RIGHTARROW"]],
	[["KP_HOME"]],
	[["KP_UPARROW"]],
	[["KP_PGUP"]],
	[["KP_SLASH"]],
	[["KP_MULTIPLY"]],
	[["KP_MINUS"]],
	[["KP_PLUS"]],
	[["KP_ENTER"]],
	[["KP_DEL"]],
	[["["]],
	[["]"]],
	[["SEMICOLON"]],
	[["'"]],
	[["`"]],
	[[","]],
	[["."]],
	[["\"]],
	[["-"]],
	[["="]],
	[["SPACE"]],
	[["TAB"]],
	[["ESCAPE"]],
	[["HOME"]],
	[["END"]],
	[["PAUSE"]],
	[["SHIFT"]],
	[["ALT"]],
	[["CTRL"]],
	[["UPARROW"]],
	[["LEFTARROW"]],
	[["DOWNARROW"]],
	[["RIGHTARROW"]],
	[["F1"]],
	[["F2"]],
	[["F3"]],
	[["F4"]],
	[["F5"]],
	[["F6"]],
	[["F7"]],
	[["F8"]],
	[["F9"]],
	[["F10"]],
	[["F11"]],
	[["F12"]],
	[["MOUSE1"]],
	[["MOUSE2"]],
	[["MOUSE3"]],
	[["MOUSE4"]],
	[["MOUSE5"]],
	[["MOUSE6"]],
	[["MWHEELUP"]],
	[["MWHEELDOWN"]],
	[["INS"]],
	[["DEL"]],
}
local function RDBind(str)
	for k,v in pairs(Binds) do
		if HAC.StringCheck(str, v) then
			return string.Replace(str, v, ''):Trim()
		end
	end
	return "NOBIND "..str
end


local function BuildBuff(ply,cmd,args)
	if not ply:IsSuperAdmin() then return end
	if not file.Exists(Dir) then
		print("[HAC] buff folder gone!")
		return
	end
	
	local Temp = {}
	
	for k,v in pairs( file.Find(Dir.."/*.txt" ) ) do
		local Kfile = file.Read(Dir.."/"..v)
		local KTab = string.Explode("\n", Kfile)
		
		for x,y in pairs(KTab) do
			if ValidString(y) and (x >= 8) then --Ignore first few lines
				y = y:gsub("\t", ""):Trim()
				
				y = RDBind(y) --Remove the bind
				
				if not table.HasValue(Temp, y) then
					table.insert(Temp, y)
				end
			end
		end
	end
	
	
	if not file.Exists(Done) then
		file.Write(Done, "\n\n\n")
	end
	
	for k,v in ipairs(Temp) do
		file.Append(Done, Format('\t%s,\n', v) )
	end
	
	print("[HAC] Saved: ["..#Temp.."] entries!")
end
concommand.Add("hac_buildbuff", BuildBuff)














