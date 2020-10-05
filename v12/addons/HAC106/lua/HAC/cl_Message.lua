



local RED	= Color(255, 0, 11)		--Red
local GREEN	= Color(66, 255, 96)	--HSP Green
local WHITE	= Color(255, 255, 255)	--White


usermessage.Hook("HAC.Message", function(um)
	local BanTime = tostring( um:ReadShort() )
	
	if BanTime == "0" then
		BanTime = "Infinate"
	else
		BanTime = BanTime.." min"
	end
	
	chat.AddText(RED,"[", GREEN,"HAC", RED,"]", WHITE," This server uses", RED," HeX's Anticheat")
	chat.AddText(RED,"[", GREEN,"HAC", RED,"]", WHITE," Cheating = ", RED,BanTime, WHITE," ban")	
end)




