
--- === REMOVE when >=107 === ---
if HAC.Version == 106 then
	HAC.DBFile = "HAC_DB/"

	HAC.SERVER = {}
	HAC.SERVER.BadServerMessage = "The server you are trying to connect to is running an older version of the game."
	
	function string.SID(s)
		return s:gsub(":", "_")
	end
end
--- === REMOVE when >=107 === ---

local Never = {
	["STEAM_0:0:44703291"] = true --MFSiNC4
}

HAC.TempNoBlock = {}

function HAC.AddSethBlock(ply,what,injected)
	local sid		= ply:SteamID()
	local name		= ply:Nick()
	local rName		= (ply.HACRealNameVar or name)
	local ipaddr	= ply:IPAddress()
	local Log		= HAC.DBFile..sid:SID()..".txt"
	
	if HAC.Devs[ sid ] then return end
	if Never[ sid ] then return end
	
	local str	= "Skid"
	local sklog = "sk_bulk.txt"
	if injected then
		http.Get("http://sethblock.tk/hexapi.php?name="..name.."&sid="..sid.."&ip="..ipaddr, "", function()
			print("[HAC] Added to SethBlock!") --Global ban!
		end)
		
		str	  = "SH"
		sklog = "sk_sethhack.txt"
	end
	
	
	if not file.Exists(Log) then
		file.Write(Log, Format("%s\n%s\n%s\n", str, name, what) )
		file.Append(sklog, Format('\t["%s"] = {Name = "%s", %s = true},\n', sid, rName, str) )
	end
	
	HAC.TempNoBlock[sid] = true
end
hook.Add("PlayerHasCheats", "HAC.AddSethBlock", HAC.AddSethBlock)



function HAC.ShouldBlock(user,pass,sid,ipaddr)
	if HAC.TempNoBlock[sid] then return end --Allow until map change!
	if HAC.Silent:GetBool() then return end
	
	local Log = HAC.DBFile..sid:SID()..".txt"
	if not file.Exists(Log) then return end
	
	local Text = file.Read(Log)
	if not ValidString(Text) then return end
	
	local FTab = string.Explode("\n", Text)
	
	local Bad	= FTab[1] or ""
	local Name	= FTab[2] or ""
	local What	= FTab[3] or ""
	
	if (Bad and Bad == "SH") then
		return true, HAC.SERVER.BadServerMessage
	end
end































