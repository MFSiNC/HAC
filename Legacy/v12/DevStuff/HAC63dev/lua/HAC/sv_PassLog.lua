--[[
	sv_PassLog, password logging, yay gatekeepr
]]
if not gatekeeper then return end

HAC.PasswordLogEnabled = CreateConVar("hac_log_pass", 1, true, false)
HAC.HeXNameLogEnabled = CreateConVar("hac_log_hex", 1, true, false)
HAC.ServerLocked = CreateConVar("hac_lock", "", false, false)


function HAC.LockServerCvarCheck(CVar, PreviousValue, NewValue)
	print(CVar.." changed from "..PreviousValue.." to "..NewValue.."!")
end
cvars.AddChangeCallback("hac_lock", HAC.LockServerCvarCheck)



function HAC.CheckPassword(user,pass,steam,ipaddr)
	HAC.SVPassword = GetConVarString("sv_password")
	HAC.LockReason = GetConVarString("hac_lock")
	
	
	if (HAC.LockReason and HAC.LockReason != "") then
		return {
			false,
			"Server locked: "..HAC.LockReason
		}
		
	elseif steam != "STEAM_0:0:17809124" and string.find(user, "HeX") then
		if HAC.HeXNameLogEnabled:GetBool() then
			--FIXME, add logging!
		end
		return {
			false,
			"Oh Snap!, you're not HeX, change your name and try again"
		}
		
	elseif (HAC.SVPassword and HAC.SVPassword != "" and pass != HAC.SVPassword) then
		if HAC.PasswordLogEnabled:GetBool() then
			HAC.LogFailedPassword(user,pass,steam,ipaddr)
		end
		return {
			false,
			"Damnit, that's not what I was looking for"
		}
	end
end
hook.Add("PlayerPasswordAuth", "HACCheckPassword", HAC.CheckPassword)


--[[
	The above line is equivalent to: return Format("'%s' is not the password I was looking for, %s", pass, user)
	Or, if you do not want to specify an error message and simply want clients kicked: return false
]]

function HAC.LogFailedPassword(user,pass,steam,ipaddr)
	local user = user or "user"
	local pass = pass or "pass"
	local steam = steam or "steam"
	local ipaddr = ipaddr or "ipaddr"
	
	local WriteLog1 = Format("[HAC%s] [%s] - FailedPassword: %s (%s) - %s\n", HAC.Version, os.date("%d-%m-%y %I:%M%p"), user, steam, pass)
	local ShortMSG = Format("%s -> PassLog: %s", user, pass)
	
	if not file.Exists("hac_pass_log.txt") then
		file.Write("hac_pass_log.txt", "[HAC"..HAC.Version.."] False Positive log created at ["..os.date("%d-%m-%y %I:%M%p").."]\n\n")
	end
	filex.Append("hac_pass_log.txt", WriteLog1)
	
	HAC.HACPrint2Admins(WriteLog1)
	--print( Format("[HAC] PassLog\nName: '%s'\n Pass: '%s'\n ID: '%s'\n", user, pass, steam) )
	for k,v in ipairs(player.GetAll()) do
		if v and v:IsValid() and v:IsAdmin() then
			HACGANPLY(v, ShortMSG, 1, 8, "npc/roller/mine/rmine_predetonate.wav")
		end
	end
end








