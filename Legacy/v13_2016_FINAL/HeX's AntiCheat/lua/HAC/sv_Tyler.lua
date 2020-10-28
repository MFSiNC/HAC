
HAC.Tyler = {
	Every	= 5, --Mins
	URL		= "http://snixzz.net/cheats/snixzz3/getonline.php",
	
	//Ignore, updated below
	Done	= {},
	
	Show	= false,
}


local function LogAndPrint(Log, is_error)
	HAC.file.Append("ty_results.txt", "\n["..HAC.Date().."] "..Log)
	if is_error then 		ErrorNoHalt(Log) return end
	if HAC.Tyler.Show then 	print(Log) 				end
end

function HAC.Tyler.Check(JSON)
	LogAndPrint("sv_Tyler: Got, checking..")
	
	//Decode
	local Tab = json.Decode(JSON)
	if not istable(Tab) or table.Count(Tab) == 0 then
		LogAndPrint("sv_Tyler: JSON level 2 failed, see ty_error_json2.txt", true)
		HAC.file.Append("ty_error_json2.txt", "\n\n["..HAC.Date().."]\n"..JSON)
		return
	end
	
	//Current
	local Online = table.Count(Tab)
	LogAndPrint("sv_Tyler: "..Online.." users online")
	
	//Total saved
	local Saved = 0
	local Old = file.Read("ty_all.txt", "DATA")
	if Old then
		Saved = Old:Count("\t[")
	end
	
	//Check
	local OnSK	= 0
	local New	= 0
	local Got	= 0
	for SID64,Nick in pairs(Tab) do
		//Nick
		local Safe = ValidString(Nick) and Nick:VerySafe()
		if not Safe or #Safe <= 2 then
			Nick = "Troll names"
		end
		Nick = Safe
		
		//Valid
		local SID = util.SteamIDFrom64(SID64)
		if not ValidString(SID) then
			LogAndPrint("sv_Tyler: No SID for '"..SID64.." ("..Nick..")'", true)
			continue
		end
		
		//Checked already
		if HAC.Tyler.Done[ SID ] then
			Got = Got + 1
			continue
		end
		HAC.Tyler.Done[ SID ] = true
		
		//Got
		local Old = file.Read("ty_all.txt", "DATA")
		if Old and Old:find(SID:sub(9),nil,true) then
			Got = Got + 1
			continue
		end
		
		//Save
		local Res = Nick..", snixzz cheat user"
		HAC.Skid.Write("ty_all.txt", SID, Res)
		
		
		//Check if already on SK
		local Reason = HAC.Skiddies[ SID ]
		if Reason then
			OnSK = OnSK + 1
			
			LogAndPrint("sv_Tyler, OnSK: "..SID.."\t"..Nick.."\t"..Reason)
			HAC.Skid.Write("ty_needs_update.txt", SID, Res..", "..Reason)
			continue
		end
		
		//Add
		New = New + 1
		HAC.Skid.Write("ty_new.txt", SID, Res)
	end
	
	LogAndPrint("sv_Tyler: New: "..New..", SK: "..OnSK..", Stored: "..Got..", Online: "..Online.."\t\tAll users: "..Saved.."\n")
	HAC.Tyler.Show = false
end


function HAC.Tyler.Fetch()
	HAC.Skid.Open()
	
	LogAndPrint("\nsv_Tyler: Getting..")
	
	http.Fetch(HAC.Tyler.URL, function(body)
		//Size
		if #body > 1097152 then
			LogAndPrint("sv_Tyler: ["..HAC.Date().."] Too big (fucked with?)! ("..math.Bytes(#body).."), TIMER HALTED!", true)
			HAC.file.Append("ty_error_toobig.txt", "\n\n["..HAC.Date().."]\n"..body)
			
			//Stop timer
			timer.Destroy("HAC.Tyler.Fetch")
			return
		end
		
		//Empty
		if body == "[]" or #body < 4 then
			LogAndPrint("sv_Tyler: No current users")
			return
		end
		
		//Tell
		LogAndPrint("sv_Tyler: [["..body.."]]")
		
		//Validate
		local Temp = util.JSONToTable(body)
		if not Temp or table.Count(Temp) < 1 then
			LogAndPrint("sv_Tyler: ["..HAC.Date().."] JSON decode error, see ty_error_json.txt!", true)
			HAC.file.Append("ty_error_json.txt", "\n\n["..HAC.Date().."]\n"..body)
			return
		end
		
		
		//Check
		HAC.Tyler.Check(body)
		
		//Error
	end, function(err)
		LogAndPrint("sv_Tyler: ["..HAC.Date().."] Fetch error for '"..HAC.Tyler.URL.."' : "..err, true)
	end)
end
timer.Create("HAC.Tyler.Fetch", (HAC.Tyler.Every * 60), 0, HAC.Tyler.Fetch)
timer.Simple(5, HAC.Tyler.Fetch)

//Command
function HAC.Tyler.Command(self)
	\n
	
	HAC.Tyler.Show = true
	
	HAC.Tyler.Fetch()
end
concommand.Add("ty", HAC.Tyler.Command)






