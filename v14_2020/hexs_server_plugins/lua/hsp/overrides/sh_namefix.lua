
----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	sh_NameFix, v1.0

	Remove the^2se ^1stupid ^4fuck^8ing tag^3s, also bot names!

]]





local Prefix = "[BOT] "



local FunBotNames = {

	"AimBot",

	"BeepBoopBeep",

	"Cannon Fodder",

	"CreditToTeam",

	"C++",

	"Kill Me",

	"Mindless Electrons",

	"Target Practice",

	"Totally Not A Bot",

}







local function Nick(self)

	if not self.HSPStoredNick then

		local NWNick = self:GetNWString("HSPStoredNick", "")

		

		if not NWNick or (NWNick == "") then --Return old until it arrives

			return self:NickOld()

		end

		

		self.HSPStoredNick = NWNick --Save

	end

	

	return self.HSPStoredNick

end

HSP.Detour.Meta("Player", "Nick", 		Nick)

HSP.Detour.Meta("Player", "Name", 		Nick)

HSP.Detour.Meta("Player", "GetName", 	Nick)





local function __tostring(self)

	if not self.HSPStoredNick then --I hate copy-pasting this, but it has to be as efficient as possible, this is called a lot!

		local NWNick = self:GetNWString("HSPStoredNick", "")

		

		if not NWNick or (NWNick == "") then

			return self:__tostringOld()

		end

		

		self.HSPStoredNick = NWNick

	end

	

	return "["..self:EntIndex().."]"..self.HSPStoredNick

end

HSP.Detour.Meta("Player", "__tostring", __tostring)







if SERVER then

	function HSP.Name_Spawn(ply)

		if ply.HSP_HasNick then return end

		ply.HSP_HasNick = true

		

		if ply:IsBot() then

			ply.HSPStoredNick = Prefix..table.Random(FunBotNames)

		else

			ply.HSPStoredNick = ply:NickOld():StripTags()

			ply.HSPStoredNick = ply.HSPStoredNick:gsub(" ur", "cum")

			ply.HSPStoredNick = ply.HSPStoredNick:gsub(" ur ", "cum")

			ply.HSPStoredNick = ply.HSPStoredNick:gsub(" u ", " My balls ")

		end

		

		ply:SetNWString("HSPStoredNick", ply.HSPStoredNick)

	end

	hook.Add("PlayerInitialSpawn", "HSP.Name_Spawn", HSP.Name_Spawn)

end





if SERVER then

	local function TestNWString(ply,cmd,args,str)

		ply:print("\n")

		

		for k,v in pairs( player.GetAll() ) do

			if not v.NickOld then continue end

			

			local Nick 		= v:NickOld()

			local NWNick 	= v:GetNWString("HSPStoredNick", "")

			

			local str = Format("%s\t\t%s", Nick, NWNick)

			

			ply:print(str)

		end

	end

	concommand.Add("nicks", TestNWString)

end














