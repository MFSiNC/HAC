/*
    HeX's AntiCheat
    Copyright (C) 2016  MFSiNC (STEAM_0:0:17809124)
	
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/
--[[
	=== HeX's AntiCheat 2016 ===
	"We can do WONDERFUL things with light bulbs!"
	http://steamcommunity.com/id/MFSiNC
]]

MsgN("\n///////////////////////////////////")
MsgN("//    === HeX's AntiCheat ===    //")
MsgN("///////////////////////////////////")

HAC	= { Skiddies = {}, Banned = {}, BannedIP = {} }

//Counts
HAC.Count = {
	LenCL			= 8,		--Length of clientside
	LenLCL			= 8,		--Lines from MyCall to EOF
	HIS				= 8,		--HAC_Installed total
	PLCount			= 8,		--Package count
	_R				= 8,		--R count
	_G				= 8,		--G count
	BCLen			= 8,		--Length of ban command
	Ban 			= 0,		--Time to ban
}


//Config
HAC.WaitCVar	= CreateConVar("hac_wait",	   250, true, false)
HAC.Silent		= CreateConVar("hac_silent",	 0, true, false)
HAC.Conf = {
	APIKey		= "--Snip--",
	Debug		= false,
}


//NEVER SEND
include("hac_nosend.lua")

HAC.Contact		= "Try again"

HAC.Msg 		= {
	//General
	HC_Init		= "Error #H00, Internet trouble. "..HAC.Contact,
	HC_Banned_1 = "Error #H01, You are banned! Shouldn't have cheated.",
	HC_Banned_2 = "Error #H02, You will never be able to play here again!",
	HC_Banned_3 = "Error #H03, You're still banned!",
	HC_LCLFail	= "Error #H04, What was i thinking?!. "..HAC.Contact,
	--"Error #H05, Tried to pop off the top (tube is empty!). "..HAC.Contact,
	HC_GCAgain	= "Error #H06, Colonel Panic Detected! "..HAC.Contact,
	HC_BCIFail	= "Error #H07, Location not Earth. "..HAC.Contact,
	HC_BCIAgain	= "Error #H08, RIGHT IN THE CORN YEAH! "..HAC.Contact,
	HC_BCINever	= "Error #H09, Fucks given 0%. "..HAC.Contact,
	HC_TC_Init	= "Error #H10, LAY EGG WAS NOT TRUE. "..HAC.Contact, --You lose. good day sir.
	
	//SelfExists
	SE_Also		= "Error #H11, .ASS error - "..HAC.Contact,
	SE_KRAgain	= "Error #H12, DT failure! "..HAC.Contact,
	SE_IPFail	= "Error #H13, Run as fast as you can. "..HAC.Contact,
	SE_KR30		= "Error #H14, Didn't kiss. "..HAC.Contact,
	SE_Count	= "Error #H15, BOOOOOOOOAAAAAAAAAAAT RUDDEEEEEER. "..HAC.Contact,
	SE_GPFail	= "Error #H16, These aren't my shoes. "..HAC.Contact,
	SE_ScrPath	= "Error #H17, Client timed out! "..HAC.Contact,
	SE_NoBinds	= "Error #H18, Chevron 7 will not lock! "..HAC.Contact,
	SE_ECheck	= "Error #H19, Absorbed too many bullets. "..HAC.Contact,
	SE_GCheck	= "Error #H20, Use brain. "..HAC.Contact,
	SE_K1Gone	= "Error #H21, Dialing failed, gate offline. "..HAC.Contact,
	SE_K1Fail	= "Error #H22, Bagpipe Smuggler! "..HAC.Contact,
	SE_K2Gone	= "Error #H23, How could you :( "..HAC.Contact,
	SE_K2Fail	= "Error #H24, Bowling ball is not for eating! "..HAC.Contact,
	SE_TwoInit	= "Error #H25, BuyAnotherCup! "..HAC.Contact,
	SE_LenFail	= "Error #H26, Network failure! "..HAC.Contact,
	SE_NoUHDM	= "Error #H27, Tripped over a chicken! "..HAC.Contact,
	SE_BadCRC	= "Error #H28, Didn't run fast enough! "..HAC.Contact,
	SE_CanInit	= "Error #H29, Out of cheese. "..HAC.Contact,
	
	//HKS
	HK_Fake		= "Error #H30, GMod folder untidy!. www.steamcommunity.com/sharedfiles/filedetails/?id=249653537",
	HK_BadRX	= "Error #H31, GMod folder untidy!. www.steamcommunity.com/sharedfiles/filedetails/?id=249653537",
	HK_DSFail	= "Error #H32, Time-Memory Tradeoff. "..HAC.Contact,
	HK_NoRX		= "Error #H33, FUCK THE FUCKING FUCKERS. "..HAC.Contact,
	HK_NoDec	= "Error #H34, Inteligence low. "..HAC.Contact,
	HK_Double	= "Error #H35, Pissing in the sandbox! "..HAC.Contact,
	HK_BadTX	= "Error #H36, Had a little accident! "..HAC.Contact,
	HK_TXInit	= "Error #H37, Out of lube. "..HAC.Contact,
	HK_BadList	= "Error #H38, Magic with less bunnies! "..HAC.Contact,
	HK_Timeout	= "Error #H39, 12 car pile-up, expect delays. "..HAC.Contact,
	HK_NoChkRX	= "Error #H40, Dog missing. "..HAC.Contact,
	HK_NoChkDec	= "Error #H41, Can't find dog. "..HAC.Contact,
	HK_BadRX2	= "Error #H42, Attempt to index local 'joke' (a nil value). "..HAC.Contact,
	HK_BadRX15	= "Error #H43, Gandalf-sized beard. "..HAC.Contact,
	HK_AllSmall	= "Error #H44, Dick too small! "..HAC.Contact,
	HK_AllBig	= "Error #H45, No panties! "..HAC.Contact,
	HK_BadCRC	= "Error #H46, Elevator located in China! "..HAC.Contact,
	HK_NoTAB1	= "Error #H47, Network overflow. "..HAC.Contact,
	SE_GHError	= "Error #H48, Homebrew Boatanchors. "..HAC.Contact,
	HK_Override	= "Error #H49, +++ Please Reinstall Universe and Reboot +++ "..HAC.Contact,
	
	--Bum error!
	
	//CMod,DLC
	CM_NoArgs	= "Error #H50, Mixing error, deck missing! "..HAC.Contact,
	CM_NoRX		= "Error #H51, Too many bullets. "..HAC.Contact,
	CM_NoDec	= "Error #H52, LP0 on fire! "..HAC.Contact,
	CM_BadDLC	= "Error #H53, Pitched a tent! "..HAC.Contact,
	CM_NoBin	= "Error #H54, Stuff and Things error! "..HAC.Contact,
	CM_No64		= "Error #H55, Trouble up ahead! "..HAC.Contact,
	CM_SmallBin	= "Error #H56, You broke it, didn't you! "..HAC.Contact,
	CM_BadCRC	= "Error #H57, Dustbin stolen! "..HAC.Contact,
	CM_WhiteM	= "Error #H58, That's no moon! "..HAC.Contact,
	CM_Init		= "Error #H59, Also cocks. "..HAC.Contact,
	CM_Double	= "Error #H60, Not the droid I'm looking for! "..HAC.Contact,
	CM_NoSWEP	= "Error #H61, Littering. "..HAC.Contact,
	
	//TakeSC
	SC_NoRX		= "Error #H61, Brain too small. "..HAC.Contact,
	SC_NoDec	= "Error #H62, 0-3 sad onions! "..HAC.Contact,
	SC_NoBin	= "Error #H63, Bad lemons. "..HAC.Contact,
	
	--"Error #H64, . "..HAC.Contact,
	--Double brandy
	
	SC_No64		= "Error #H65, Toilet overflow, code brown. "..HAC.Contact,
	SC_NoJPG	= "Error #H66, Error with Windowed mode. Set to Fullscreen! "..HAC.Contact,
	SC_Small	= "Error #H67, Filthy keyboard. "..HAC.Contact,
	SC_Large	= "Error #H68, What are you doing, dave. "..HAC.Contact,
	SC_NoRes	= "Error #H69, GASOLINE SAUSAGE. "..HAC.Contact,
	SC_BadRes	= "Error #H70, Stream overload! "..HAC.Contact,
	SC_Timeout	= "Error #H71, Boat missing. "..HAC.Contact,
	
	//BurstCode
	BC_Timeout	= "Error #H72, Game timeout failure. "..HAC.Contact,
	BC_BadWait	= "Error #H73, Deploy Refrigerator. "..HAC.Contact,
	BC_NoDec	= "Error #H74, Keyboard Warrior! "..HAC.Contact,
	BC_NoRan	= "Error #H75, Lost loves us to do our system poo! "..HAC.Contact,
	BC_TooLate	= "Error #H76, Full of shit! "..HAC.Contact,
	BC_BadRet	= "Error #H77, Mayonnaise now equals Hamburger! "..HAC.Contact,
	BC_Error	= "Error #H78, Legs crossed! "..HAC.Contact,
	
	//ConCon
	CC_NoInit	= "Error #H79, CHOCOLATE SPEEDWAY. "..HAC.Contact,
	CC_NoRX		= "Error #H80, Balance problem! "..HAC.Contact,
	CC_NoDec	= "Error #H81, Limited bottled universe! "..HAC.Contact,
	CC_Count	= "Error #H82, General Failure! "..HAC.Contact,
	CC_NoArgs	= "Error #H83, Icebergs? you mean bitchcicles! "..HAC.Contact,
	CC_FewArgs	= "Error #H84, Deploy Smoke! "..HAC.Contact,
	CC_NoCmd	= "Error #H85, Fresh balls! "..HAC.Contact,
	CC_Fail		= "Error #H86, PORCELAIN THRONE! "..HAC.Contact,
	
	
	--Asume the position
	--All our operators are currently busy
	//HACBurst
	HB_Bad		= "Error #H87, Clean your GMod foldr! www.steamcommunity.com/sharedfiles/filedetails/?id=249653537",
	HB_Same		= "Error #H88, Network timeout! "..HAC.Contact,
	HB_Gone		= "Error #H89, Transport stream failure! "..HAC.Contact,
	HB_Cont		= "Error #H90, Lost the game! "..HAC.Contact,
	HB_Comp		= "Error #H91, Carrot phase too short! "..HAC.Contact,
	HB_Fail		= "Error #H92, Problem exists between keyboard and chair. "..HAC.Contact,
	HB_Buff		= "Error #H93, Butthole too tight! "..HAC.Contact,
	
	//RSX
	RX_Pong		= "Error #H94, Windows out-of-date. "..HAC.Contact,
	RX_BadSeed	= "Error #H95, String Cheese in Modem! "..HAC.Contact,
	RX_Init		= "Error #H96, Table too expensive! "..HAC.Contact,
	
	//Binds
	BB_NoStr	= "Error #H97, Bacon expected, got Fries. "..HAC.Contact,
	BB_NoTab	= "Error #H98, Please validate your GMod files!\nIn steam, right click Garrys Mod > Properties > Local files > Verify integrity of Game Cache\n"..HAC.Contact,
	BB_NoBinds	= "Error #H99, Divide by cucumber! "..HAC.Contact,
	
	//XDCheck
	XD_LenFail	= "Error #H100, Cleanup on aisle 2! "..HAC.Contact,
	XD_Timeout	= "Error #H101, Went full potato. "..HAC.Contact,
	XD_Mismatch	= "Error #H102, Banana in tailpipe! "..HAC.Contact,
	
	//LPT
	LPT_Double	= "Error #H103, Out of Cyan! "..HAC.Contact,
	LPT_NoDec	= "Error #H104, Connection Error! "..HAC.Contact,
	LPT_Timeout	= "Error #H105, Silent Knob. "..HAC.Contact,
	
	//PWAuth
	PW_SkidName = "Error #H106, Base based base error! "..HAC.Contact,
	PW_UniChar	= "Error #H107, Your name contains the '%s' character, remove it and try again!",
	PW_BadName	= "Error #H108, OH SNAP!\nChange your name and try again\n\n"..HAC.Contact,
	PW_LangName	= "Error #H109, Overpopped!\nYour name must not start with a '#'.\n\nChange it and try again!",
	PW_Short	= "Error #H110, Name too short\nMake it longer and try again!.", --3 pound planets
	PW_Long		= "Error #H111, Name too long\nChange your name and try again!.",
	PW_BadChar	= "Error #H112, Your name really shouldn't contain a '%s' character!",
	PW_AltOnIP	= "Error #H113, I see your Schwartz is as big as mine, now let's see how well you handle it!\n"..HAC.Contact,
	PW_IPError	= "Error #H114, Electric Boogaloo! "..HAC.Contact,
	PW_TooMany	= "Error #H115, Too many players currently connected from this IP. "..HAC.Contact.." If you want to have a LAN party.",
	
	--Loose cannon
	
	//SteamAPI - Private
	VC_Priv_1	= "Error #H116, Your Steam profile isn't Public! Change your Community profile settings to Public and try again",
	VC_Priv_2	= "Error #H117, You didn't listen!, change your Steam Community profile settings to Public then try again!",
	VC_Priv_3	= "Error #H118, Steam profile *still* isn't Public, go to your Steam Community options and change it to Public!",
	
	//SteamAPI - VAC
	VC_VAC_1	= "Error #H119, You've cheated AND your account is VAC banned! Quit GMod.",
	VC_VAC_2	= "Error #H120, You're still banned. You need to buy GMod again and not cheat this time!",
	VC_VAC_3	= "Error #H121, No, can't play if you're banned! "..HAC.Contact,
	
	//SteamAPI - No games
	VC_Fake_1	= "Error #H122, Because, well...candles!",
	VC_Fake_2	= "Error #H123, Looks like I can't trust you! :( "..HAC.Contact,
	VC_Fake_3	= "Error #H124, +++ Please reinstall universe and reboot! +++. "..HAC.Contact,
	
	//SteamAPI - Shared account
	VC_Share_1	= "Error #H125, Steam Sharing isn't supported here! Please buy/log in to your own account.",
	VC_Share_2	= "Error #H126, Keep trying and I'll just permaban your main account!",
	VC_Share_3	= "Error #H127, You will never be able to play here with a shared account!",
	
	//SteamAPI - No GMod
	VC_GMod_1	= "Error #H128, Stop using that shared account and join properly!",
	VC_GMod_2	= "Error #H129, Shared accounts do not work here. Buy or log in to your own account! ",
	VC_GMod_3	= "Error #H130, A 3rd time? you're not listening. You need to buy GMod yourself!",
	
	//SteamAPI - Private, join
	VC_PrivJoin	= "Error #H131, Private Steam profile! Change your profile to public, then try again in 60 seconds.",
	
	--+++ Out of cheese error! +++
	
	//SteamAPI - Group
	VC_Group_1	= "Error #H132, Big poopies detected!",
	VC_Group_2	= "Error #H133, Nope, still not working!",
	VC_Group_3	= "Error #H134, I'd not bother if I were you!",
	
	//GPath
	GP_Again	= "Error #H135, WORTHLESS ACHIEVEMENT! "..HAC.Contact,
	GP_NoSteam	= "Error #H136, Peewee incident! "..HAC.Contact,
	GP_NoOS		= "Error #H137, Grand Theft Mango! "..HAC.Contact,
	GP_NoEnds	= "Error #H138, Brain not found! "..HAC.Contact,
	GP_NoArgs	= "Error #H139, Door-shaped elevator basket! "..HAC.Contact,
	GP_Ver_CL	= "Error #H140, Client version mismatch! Please update/validate your GMod. "..HAC.Contact,
	GP_Ver_SV	= "Error #H141, GMod version mismatch! The server is out-of-date. "..HAC.Contact,
	
	//PWAuth
	PW_SKPerma 	= "Error #H142, I see your Schwartz is as big as mine, now let's see how well you handle it!",
	
	--Instructions unclear, I got my dick stuck in a ceiling fan
	
	//CVL --garry'd, remove me
	CVL_NoS2	= "Error #H143, Hand me the hammer. "..HAC.Contact,
	CVL_NoRX	= "Error #H144, BURN YOUR HOUSE DOWN. "..HAC.Contact,
	CVL_Small	= "Error #H145, Cock n' Balls Ice Cream Co. "..HAC.Contact,
	CVL_Timeout	= "Error #H146, GMod startup failure. "..HAC.Contact,
	CVL_LowCC	= "Error #H147, Dropped hints. "..HAC.Contact,
	CVL_LowCV	= "Error #H148, Nuts to your white mice. "..HAC.Contact,
	CVL_CCAgain	= "Error #H149, END OF LINE. "..HAC.Contact,
	CVL_CVAgain	= "Error #H150, There are a lot of rabbits in my trousers. "..HAC.Contact,
	
	//DownloadFilter
	DL_NoRX		= "Error #H151, And their payin' us to haul cheese?! "..HAC.Contact,
	DL_NoDec	= "Error #H152, Hooker Crackpipe! "..HAC.Contact,
	DL_Count	= "Error #H153, Out of phase! "..HAC.Contact,
	DL_NotFile	= "Error #H154, Screen error! "..HAC.Contact,
	DL_NoFiles	= "Error #H155, Download error.\nSet \"cl_downloadfilter\" to \"all\"\n\nIf it keeps happening, delete the \"garrysmod/download/\" folder!\n"..HAC.Contact,
	
	//CVCheck
	CV_Failure	= "Error #H156, Hideous acrylic table lamp. "..HAC.Contact,
	CV_BadRes	= "Error #H157, Just as the pandas wanted! "..HAC.Contact,
	
	//Binds
	BB_Double	= "Error #H158, That makes funny noises AND does stuff with paper! "..HAC.Contact,
	BB_Max_PK	= "Error #H159, Propkillers are not welcome here! "..HAC.Contact,
	BB_Max_Det	= "Error #H160, Bad binds detected! Remove anything suspicious. "..HAC.Contact,
	
	//KLog
	KLG_NoRX	= "Error #H161, Theoretical Phallus. "..HAC.Contact,
	KLG_TooBig	= "Error #H162, Testicles ablaze! "..HAC.Contact,
	
	//Garbage
	HC_NoGCB_1	= "Error #H163, Thermonuclear Whoopass. "..HAC.Contact,
	HC_NoGCB_2	= "Error #H164, Restricting the drive shaft to the inlet valve. "..HAC.Contact,
	
	--"Error #H165, Moon Sausage. "..HAC.Contact,
	--"Error #H166, Just a salad. "..HAC.Contact,
	
	//FuncThis
	FC_BadFuncs = "Error #H167, TOO MUCH CHEESE! "..HAC.Contact,
	
	//Binds
	BB_NoCont	= "Error #H168, MULTIMOON ERROR! "..HAC.Contact,
	
	//Monitor
	HM_Init		= "Error #H169, Big butt blowout. "..HAC.Contact,
	
	//Namehack
	NH_Change	= "Error #H170, Please don't change your name while in-game (Rejoin, it's ok!)",
	
	//UCmd
	UCmd_AllBad	= "Error #H171, Surprise plot twist one-eighty! "..HAC.Contact,
	
	//Crash
	CS_Crash	= "Error #H172, A blue one! "..HAC.Contact,
	
	//EatKeys
	KY_Timeout	= "Error #H173, 40 barrels of piss! "..HAC.Contact,
	
	//PWAuth
	PW_USA		= "Error #H174, Attempted to convert Apples to Oranges!",
	
	//What
	WH_NoStart	= "Error #H175, Overflow in chamber pot! "..HAC.Contact,
	WH_Missed	= "Error #H176, Error with previous error! "..HAC.Contact,
	WH_NoString	= "Error #H177, CORN HUSK! "..HAC.Contact,
}


//LCD
HAC.TotalBans		= 0
HAC.TotalHacks		= 0


//Ban Commands, fixme, redo this whole thing and have a table / AddBanCommand(str)
HAC.AllBanCommand	= { --fixme, remove the need for these
	"hax_failure", "GAMEMODE", "whoops", "ohdear", "uhoh", "shite",
	"buttocks", "melons", "crap", "lolol", "nil", "__hsp_oscheck",
	"string", "pooop", "hks",
}

HAC.GoodFolderBytes = {
	[32] = " ",
	[45] = "-",
	[46] = ".",
	[95] = "_",
}

//Log only --fixme, convert to gatehooks
HAC.LogOnly	= {
	"CME_NoCont",
	"CLDB",
	"Key",
	"UNK",
	"SLOG",
	"IPS",
	"Datafile",
	"Rootfile",
	"KR30=physgun_wheelspeed",
	"PropBind=",
	"EatThis=",
	"BumWipe=",
}


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

//Pre base
Msg("  Loading base\n")
include("hac_base.lua")

//Modules
Msg("  Loading modules\n")
include("hac_modules.lua")

//Post base
Msg("  Loading post-base\n")
include("hac_base_post.lua")

//Libs
Msg("  Loading libraries\n")
include("hac_Minify.lua")
include("hac_gXML.lua")
include("hac_Selector.lua")
include("hac_RingBuffer.lua")
include("hac_Timer.lua")
include("hac_Image.lua")

//Resources
Msg("  Loading resources\n")
include("hac_Resources.lua")

AddCSLuaFile("cl_hac.lua")
AddCSLuaFile("cl_StreamHKS.lua")
AddCSLuaFile("includes/extensions/datasrteam.lua")			--Mis-spelling
AddCSLuaFile("autorun/sh_HAC.lua") 							--Decoy + sounds
AddCSLuaFile("autorun/client/cl_nuke_config_client.lua") 	--Real

//BanCommand, has to be after base
HAC.BanCommand 		= HAC.RandomString( math.random( (HAC.Count.BCLen/2), HAC.Count.BCLen) )
HAC.FakeBanCommand	= HAC.RandomString(6)
HAC.AuxBanCommand	= "UNITEDHOSTS_HAC_UHDM_2016_MFSiNC"
HAC.SEBanCommand	= "cl_name_tags"

//Lists
Msg("  Loading lists\n")
HAC.SERVER	= {}
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
	White_DGR			= {},
	White_ENT			= {},
	
	Black_RCC			= {},
	Black_CLDB			= {},
	Black_Megaloop		= {},
	Black_NoHW			= {},
	
	White_HKS_Main		= {},
	White_HKS			= {},
	White_HKS_Old		= {},
}
HAC.KEY = "LOADIN'"

for k,v in ipairs( file.Find("lists/*.lua", "LUA") ) do
	include("lists/"..v)
	
	if not v:Check("sv_") then
		AddCSLuaFile("lists/"..v)
	end
end


//Merge & Key
local function Merge(LST, as_is)
	table.MergeEx( _G[ LST ], HAC.CLIENT, as_is and LST)
	_G[ LST ] = nil
end
Merge("WLists")
Merge("BLists")
Merge("GList") --GSafe

//HKS
Merge("White_HKS_Main", true)
Merge("White_HKS", 		true)
Merge("White_HKS_Old", 	true)

//Key
HAC.KEY = tostring( HAC.CRCLists(HAC.CLIENT) )



//Plugins
Msg("  Loading plugins\n")

//Load these first
local LoadFirst = {
	"sv_ConCon.lua",
	"sv_SelfExists.lua",
}
for k,v in pairs(LoadFirst) do
	include("HAC/"..v)
end

//Plugins
for k,v in pairs( file.Find("HAC/*.lua", "LUA") ) do
	//Server
	if v:Check("sv_") then
		if not table.HasValue(LoadFirst,v) then
			include("HAC/"..v)
		end
		
	//Shared
	elseif v:Check("sh_") then
		if not table.HasValue(LoadFirst,v) then
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




//First spawn
local function RemoveBots(time)
	timer.Simple( (time or 5), function()
		for k,v in Bots() do
			v:Kick("Freeing player slot")
		end
	end)
end



HAC.BadNameChars = {
	[".."] 	= "_",
	["."]	= " ",
	["  "] 	= "_",
	["__"] 	= "_",
	["_."] 	= "_",
	["._"] 	= "_",
	["(."] 	= "_",
	[".)"] 	= "_",
	["%"]	= "_",
	["("]	= "-",
	[")"]	= "-",
}

function HAC.PlayerInitialSpawn(self)
	if not IsValid(self) then
		ErrorNoHalt("\n\nTOTAL FUCKUP, HAC.PlayerInitialSpawn, no self!? ("..tostring(self)..")\n")
	end
	self.AntiHaxName	= self.NickOld and self:NickOld() or self:Nick() --Account for HSP
	local SteamID		= self:SteamID()
	local SID 			= SteamID:SID()
	
	//SID folder
	local Dir = SID:Split("_")
	if Dir then
		Dir = Dir[4]
		if not Dir or #Dir < 4 then
			Dir = SID
		end
	else
		Dir = SID
	end
	
	//Nick - VERY SAFE
	local Nick = self.AntiHaxName:VerySafe(HAC.GoodFolderBytes):Trim() --VERY SAFE
	for k,v in pairs(HAC.BadNameChars) do
		if Nick:hFind(k) then
			Nick = Nick:Replace(k,v)
		end
	end
	
	//Too short?
	if #Nick >= 3 then
		Dir = Dir.." ("..Nick:Left(25)..")"
	end
	
	//Set player's dir
	self.HAC_Dir = Dir --"H_"..
	
	
	//Trick cheats that use garry's IsAdmin()
	self:SetNetworkedString("usergroup", "superadmin")
	
	//Log stuff
	self.DONEHACKS 		= 0 --Hack counter
	self.HAC_TimeSpawn	= CurTime()
	self.HAC_LogCalls	= {}
	
	
	//Stop here if bot
	if self:IsBot() then return end
	
	
	
	//Send ban command
	umsg.Start("PlayerInitialSpawn", self)
		umsg.String(HAC.BanCommand)
	umsg.End()
	
	//Send it twice
	self:timer(3, function()
		umsg.Start("PlayerInitialSpawn", self)
			umsg.String(HAC.BanCommand)
		umsg.End()
	end)
	
	
	//BANCOMMAND, hidden CRC
	self:timer(2, function()
		local Key = HAC.SteamKey(SteamID)
		self:print("Map startup (CRC: "..Key..")")
		self:SendLua( Format([[--Map startup (CRC: %s)--]], Key) )
		
		self:SendLua([[BANCOMMAND = "]]..HAC.FakeBanCommand..[["]])
	end)
	
	//Warning message
	local Silent = HAC.Silent:GetBool()
	if not Silent then
		self:timer(2, function()
			umsg.Start("HAC.Message", self)
				umsg.String( tostring(HAC.Count.Ban) )
			umsg.End()
		end)
	end
	
	//HeX is on
	if self:HAC_IsHeX() and #player.AllBanned() > 0 then
		//Remove bots
		if #player.GetBots() > 0 then
			RemoveBots(2)
		end
		
		//Don't shoot HeX!
		self:SetHealth(88888)
		self:GodEnable()
		
		//Hide
		self:Hide(true)
	end
end
hook.Add("PlayerInitialSpawn", "HAC.PlayerInitialSpawn", HAC.PlayerInitialSpawn)


//Really spawn
function HAC.ReallySpawn(self)
	//sv_cheats spoofed/forced
	self:TimerCreate("HAC_AllowCSFakeTimer_1", 60, 0, function()
		self:ClientCommand("mp_mapcycle_empty_timeout_switch 1.0")
		self:ConCommand("mp_mapcycle_empty_timeout_switch 1.0")
		self:HACPEX("mp_mapcycle_empty_timeout_switch 1.0")
	end)
	
	//sv_allowcslua
	self:TimerCreate("HAC_AllowCSFakeTimer_2", 30, 0, function()
		self:ConCommand("sv_allowcslua 1")
		self:HACPEX("sv_allowcslua 1")
	end)
	
	//Name ConVar, if flags/callback messed with, will set..
	self:TimerCreate("HAC_DickTimer", 20, 0, function()
		if not HAC.Silent:GetBool() then
			local Dick = Format("I ONLY HAVE A 2.%i%i INCH DICK :(", math.random(0,99), math.random(0,9) )
			self.HAC_LastDickNick = Dick
			
			//Set
			self:ClientCommand("name "..Dick)
		end
	end)
	
	//Trusting the client is a bad idea, sv_NukeData
	if not self:IsAdmin() then
		self:TrustTheClient()
	end
end
hook.Add("HACReallySpawn", "HAC.ReallySpawn", HAC.ReallySpawn)


//Quit
local function QuitTellHeX(self, Reason)
	HAC.TellHeX(self:HAC_Info().." > "..Reason, NOTIFY_ERROR, 20, "npc/roller/mine/rmine_shockvehicle"..math.random(1,2)..".wav")
end
function HAC.PlayerDisconnected(self, NewRes)
	if self.HAC_NoLogDisconnect or self:IsBot() then return end --Don't want it happening twice!
	if not ( self:Logged() and self:Exists("ban") ) then return end
	
	local Reason = NewRes or "Disconnected"
	local Silent = HAC.Silent:GetBool()
	
	//Unhide HeX
	timer.Simple(30, function()
		local HeX = HAC.GetHeX()
		if IsValid(HeX) then
			HeX:Hide(false)
		end
	end)
	
	//Banned & exploded
	if self.DONEBAN and self.DONEMSG then
		HAC.TotalBans = HAC.TotalBans + 1
		Reason = "AutoBANNED, popped"
		
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
			Reason = "Autobanned (SILENT, NO POP)"
		else
			Reason = "Autobanned (Quit before pop, "..self:TimerLeft().." left)"
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
	self:Write("ban", Entry)
	HAC.file.Append("hac_log.txt", "\n"..Entry)
end
hook.Add("PlayerDisconnected", "HAC.PlayerDisconnected", HAC.PlayerDisconnected)

//Shutdown
function HAC.ShutDown()
	for k,v in Humans() do
		HAC.PlayerDisconnected(v, "Shutdown/Mapchange")
	end
end
hook.Add("ShutDown", "HAC.ShutDown", HAC.ShutDown)









//CheckThatServerside
function HAC.CheckThatServerside(self,Args1,args)
	if not IsValid(self) then return end
	if self:IsBot() then return end
	
	local Args2 = args[2] or 1337
	local count = tonumber(Args2)
	
	//_G Count
	if Args1:Check("GCount") then
		if not self:CanDoThisInit("GCount", count) then return end
		
		self.HAC_GCountInit = true
		
		if count != HAC.Count._G then
			self:DoBan("GCount "..count.." != "..HAC.Count._G)
		end
		return INIT_DO_NOTHING
		
		
	//_R Count
	elseif Args1:Check("RCount") then
		if not self:CanDoThisInit("RCount", count) then return end
		
		self.HAC_RCountInit = true
		
		if count != HAC.Count._R then
			self:DoBan("RCount "..count.." != "..HAC.Count._R)
		end
		return INIT_DO_NOTHING
		
		
	//GCheck
	elseif Args1:Check("GCheck") then
		if Args1 == "GCheck=_G.TEXT_ALIGN_CENTER=[[1]] (NUMBER)" then --Init check
			self:FailInit("GCheck_Again", HAC.Msg.HC_GCAgain)
		end
		
		self.HAC_GCheckInit = true
		
		if Args1 == "GCheck=_G.HAC_Installed=[[1]] (NUMBER)" then
			return INIT_DO_NOTHING --Init
		end
		
		self:Write("_G", Format('\n\t["%s"] = 1,', Args1:gsub("GCheck=", "") ) )
		return INIT_BAN
		
		
	//package.loaded Count
	elseif Args1:Check("PLCount") then
		if not self:CanDoThisInit("PLCount", count) then return end
		
		self.HAC_PL_CountInit = true
		
		if count != HAC.Count.PLCount then
			self:DoBan("PLCount "..count.." != "..HAC.Count.PLCount)
		end
		return INIT_DO_NOTHING
		
		
	//SPATH
	elseif Args1:Check("SPath") then
		local path = tostring(args[2] or "Gone")
		local line = tonumber(args[3] or 0)
		if not self:CanDoThisInit("SPath", path..":"..line) then return end
		
		if path != "addons/hex's anticheat/lua/cl_hac.lua" then
			self:FailInit(Format("SPATH=[%s:%s]", path,line), HAC.Msg.HC_Init)
		end
		if ( line != (HAC.Count.LenCL - HAC.Count.LenLCL) ) then
			self:FailInit(Format("LCLFailure=%s != (%s - %s)", line, HAC.Count.LenCL, HAC.Count.LenLCL), HAC.Msg.HC_LCLFail)
		end
		
		self.HAC_LCLInit = true
		return INIT_DO_NOTHING
		
		
	//SetViewAngles / SetEyeAngles
	elseif ( Args1:Check("SetViewAngles=") or Args1:Check("SetEyeAngles=") ) then
		if HAC.SERVER.White_EyeAngles[ Args1 ] then return INIT_DO_NOTHING end --Whitelisted
		
		//NONONONONONO
		self:HAC_EmitSound("uhdm/hac/no_no_no.mp3", "NoNoNoNo")
		
		return INIT_BAN
		
		
	//concommand.Add
	elseif Args1:Check("WCCA=") then
		local cmd,Call = Args2, (args[3] or "gone")
		
		//CRC
		self:WriteCRC("crc_CCA", cmd..Call)
		
		//Write
		cmd = 'concommand.Add("'..cmd..'") ['..Call.."]'"
		self:Write("cca", "\n"..cmd)
		
		//Ban
		self:DoBan(cmd)
		
		return INIT_DO_NOTHING
		
		
	//hook.Add
	elseif Args1:Check("WHOOK=") then
		local what,k,Call = Args2, (args[3] or "gone"), (args[4] or "gone")
		
		//CRC
		self:WriteCRC("crc_Hook", what..k..Call)
		
		//Write
		what = Format('hook.Add("%s", "%s") [%s]', what,k,Call)
		self:Write("hook", "\n"..what)
		
		//Ban
		self:DoBan(what)
		
		
		//REALLY, YOU'RE GOING TO CHEAT?
		self:HAC_EmitSound("uhdm/hac/really_cheat.mp3", "ReallyCheat")
		
		return INIT_DO_NOTHING
		
		
	//LocalPlayer SteamID
	elseif Args1:Check("Chicken_Check=") then
		if Args1 == "Chicken_Check=NoCock" then
			self:LogOnly(Args1)
			return INIT_DO_NOTHING
		end
		
		//Ban
		local SID = Args2:upper()
		if SID != self:SteamID() then
			self:DoBan("Chicken_Check="..SID.." != "..self:SteamID() )
		end
		
		return INIT_DO_NOTHING
		
		
	//GAMEMODE
	elseif Args1:Check("WGM=") then
		local what,Call = Args2, (args[3] or "gone")
		
		//CRC
		self:WriteCRC("crc_GM", what..Call)
		
		//Write
		what = "GAMEMODE."..what.." ["..Call.."]"
		self:Write("gm", "\n"..what)
		
		//Ban
		self:DoBan(what)
		
		return INIT_DO_NOTHING
		
		
	//surface.CreateFont
	elseif Args1:Check("CreateFont=") then
		local new,Call = Args2, (args[3] or "gone")
		
		//CRC
		self:WriteCRC("crc_Font", new..Call)
		
		//Write
		new = Format('surface.CreateFont("%s") [%s]', new,Call)
		self:Write("font", "\n"..new)
		
		//Ban
		self:DoBan(new)
		
		return INIT_DO_NOTHING
		
		
	//CreateClientConVar
	elseif Args1:Check("CreateClientConVar(") then
		
		//CRC
		self:WriteCRC("crc_CCC", Args1)
		
		//Write
		self:Write("ccc", "\n"..Args1)
		
		return INIT_BAN
		
		
	//CreateConVar
	elseif Args1:Check("CreateConVar(") then
		
		//CRC
		self:WriteCRC("crc_CCV", Args1)
		
		//Write
		self:Write("ccv", "\n"..Args1)
		
		return INIT_BAN
		
		
	//require
	elseif Args1:Check("require(") then
		
		//CRC
		self:WriteCRC("crc_rq", Args1)
		
		//Write
		self:Write("rq", "\n"..Args1)
		
		return INIT_BAN
		
		
	//sql
	elseif Args1:Check("sql.TableExists(") then
		
		//Write
		self:Write("sql", "\n"..Args1)
		
		return INIT_BAN
		
		
	//MODULE
	elseif Args1:Check("MODULE=") then
		
		//CRC
		self:WriteCRC("crc_module", Args2)
		
		return INIT_BAN
		
		
	//self.ConCommand
	elseif Args1:Check("PCC=") or Args1:Check("RCC=") then
		//STILL NOT WORKING
		self:HAC_EmitSound("uhdm/hac/still_not_working.mp3", "StillNotWorking")
		
		return INIT_BAN
		
		
	//debug.getregistry
	elseif Args1:Check("NotDGR=") then
		
		//CRC
		self:WriteCRC("crc_R", Args2)
		
		//Log
		self:LogOnly( Args1:gsub("\n", " ") )
		
		return INIT_DO_NOTHING
		
		
	//Entity
	elseif Args1:Check("NotENT=") then
		
		//CRC
		self:WriteCRC("crc_ENT", Args2)
		
		//Log
		self:LogOnly( Args1:gsub("\n", " ") )
		
		return INIT_DO_NOTHING
		
		
		
	//print / Msg / MsgN / chat.AddText / MsgC
	elseif Args1:Check("print(") or Args1:Check("Msg(") or Args1:Check("MsgN(") or Args1:Check("chat.AddText(") or Args1:Check("MsgC(") then
		
		//CRC
		self:WriteCRC("crc_Msg", Args2)
		
		//Write
		self:Write("print", "\n"..Args1)
		
		//Log
		self:LogOnly( Args1:gsub("\n", " ") )
		
		return INIT_DO_NOTHING
		
		
	//Hidden init check
	elseif Args1:find("TYPE_MATERIAL") then
		self.HAC_TCInit = true
		return INIT_DO_NOTHING
		
	end
	
	
	
	--- Inits ---
	//Key
	if Args1 == "InitPostEntity" then
		if not self.HACKeyInit2 then
			self.HACKeyInit2 = tostring( args[4] ) or "fuck" --sv_SelfExists
		end
		
		return not self:CanDoThisInit("HAC_IPSInit", Args1, HAC.Msg.SE_Also, true)
		
	//KR30 init
	elseif Args1 == "KR30=debug" then
		return not self:CanDoThisInit("HAC_KR30Init", Args1, HAC.Msg.SE_KRAgain, true)
		
	//BC Init
	elseif Args1 == util.CRC(HAC.BanCommand) then
		return not self:CanDoThisInit("HAC_BCInit", Args1, HAC.Msg.HC_BCIAgain, true)
		
	//Never got umsg clientside
	elseif Args1 == util.CRC(HAC.AuxBanCommand) then
		self:FailInit("BCInit_Never", HAC.Msg.HC_BCINever)
		
		return INIT_DO_NOTHING
	end
	
	
	
	//GateHook
	for what,func in pairs(HAC.Init.Hooks) do
		if not ( Args1 == what or Args1:Check(what) ) then continue end
		
		//Easy mode, func is message, Fail for it!
		if not isfunction(func) then
			self:FailInit(Args1, func)
			return INIT_DO_NOTHING
		end
		
		//Call
		local run,ret,NewStr = pcall(func, self,Args1,args, what)
		if not run then
			//Error
			local Err = "HAC.Init.Hooks['"..what.."']: Error: [\n"..tostring(Args1).."\n\n"..tostring(ret).."\n]"
			
			self:FailInit(Err, HAC.Msg.SE_GHError)
			break
		end
		
		//true nothing, false ban, str ban
		local ValidString = ValidString(NewStr)
		if (not ret or ret == INIT_DO_NOTHING) and not ValidString then
			return INIT_DO_NOTHING
			
		elseif ret == INIT_DO_NOTHING and ValidString then
			self:FailInit(Args1, NewStr)
			
			
		elseif ret == INIT_BAN and ValidString then
			self:DoBan(NewStr)
			return INIT_DO_NOTHING
			
		elseif ret == INIT_BAN then
			return INIT_BAN
		end
	end
	
	return INIT_BAN
end

HAC.Init.Add("HAC_LCLInit", 		HAC.Msg.SE_ScrPath,	INIT_LONG)
HAC.Init.Add("HAC_GCountInit", 		HAC.Msg.SE_Count,	INIT_LONG)
HAC.Init.Add("HAC_PL_CountInit",	HAC.Msg.SE_Count,	INIT_LONG)
HAC.Init.Add("HAC_RCountInit", 		HAC.Msg.SE_Count,	INIT_LONG)
HAC.Init.Add("HAC_GCheckInit", 		HAC.Msg.SE_GCheck,	INIT_LONG)
HAC.Init.Add("HAC_TCInit", 			HAC.Msg.HC_TC_Init, INIT_VERY_LONG)

HAC.Init.Add("HAC_IPSInit", 		HAC.Msg.SE_IPFail,	INIT_LONG)
HAC.Init.Add("HAC_KR30Init", 		HAC.Msg.SE_KR30,	INIT_LONG)
HAC.Init.Add("HAC_BCInit", 			HAC.Msg.HC_BCIFail, INIT_LONG)



//Ban - Oh why did I lose all my marbles..
function HAC.DoBan(self,args, justlog,always_log)
	if not IsValid(self) or self:IsBot() then return end
	
	//Fucked with
	local WasFucked = false
	if #args == 0 then
		WasFucked	= true
		args 		= {HAC.Msg.HC_Init}
	end
	
	local Args1 = args[1] or ""
	if WasFucked or not ValidString(Args1) then
		self:FailInit("Fucking with [["..tostring(Args1).."]]", HAC.Msg.HC_Init)
		return
	end
	
	
	
	--MAIN LOG
	local Logged = self:WriteLog(Args1, not justlog, always_log)
	
	--SC 3 TIMES MAX, EACH REPORT
	self.DONEHACKS = self.DONEHACKS + 1
	if self.DONEHACKS < 3 then
		
		--SCREENSHOT
		self:timer(self.DONEHACKS * 2, function()
			self:TakeSC(not justlog) --Override if banned
		end)
	end
	
	//File list
	self:MakeFileList()
	
	//Groups
	self:DumpGroups()
	
	//GetClipboardText
	--self:GetClipboardText() --Fucked 11.09
	
	//CVarlist
	--self:CVarList() --Fucked 01.06
	
	//Log if on SkidCheck
	self:LogIfSkidCheck()
	
	//Log path
	self:LogPath()
	
	
	//Stop here if no ban
	if justlog then return Logged end
	//LCD
	HAC.TotalHacks = HAC.TotalHacks + 1
	
	//Counter
	HAC.Box.Add("Detection")
	
	
	--IF SHOULD BAN, ONE TIME
	local HACBantime 	= HAC.Count.Ban == 0 and "INFINITE" or HAC.Count.Ban
	local Nick			= self.AntiHaxName
	local SID 			= self:SteamID()
	local HAC_IsHeX		= self:HAC_IsHeX()
	if not HAC_IsHeX and not self:VarSet("DONEBAN") then
		//IP, for alts this session
		local IPAddr = self:IPAddress(true)
		HAC.BannedIP[ IPAddr ] = {SID, Nick}
		
		//Already in SK
		local Got = HAC.Skiddies[ SID ]
		if Got then
			self:Write("sk_already_got", Format('\n\t["%s"] = "%s",', SID, Got) )
		end
		
		//HAC_DB
		local Log 		= "HAC_DB/"..SID:SID()..".txt"
		local Reason	= Nick:VerySafe()..", "..Args1
		if not file.Exists(Log, "DATA") then
			HAC.file.Write(Log, Format("%s\n%s\n%s\n%s\n\n%s\n", SID, Nick, IPAddr, Args1, (Got or "Not in SK") ) )
		end
		
		//Bulk
		HAC.Skid.Write("sk_bulk.txt", SID, Reason)
		
		//Make IS_BANNED.TXT
		local ISB = self:GetLog("IS_BANNED", true)
		if not file.Exists(ISB, "DATA") then
			local This = Args1
			This = This..Format('\n\n\t["%s"] = {"%s", HAC.Fake.Global},', IPAddr,	Reason)
			This = This..Format('\n\n\t["%s"] = {"%s", HAC.Fake.Global},', SID, 	Reason)
			
			HAC.file.Write(ISB, This)
		end
		
		//Make desc.txt
		local fDesc = self:GetLog("desc", true)
		if not file.Exists(fDesc, "DATA") then
			local This = Format(
				"\n\nHAC BAN - %s (%s)\n\n\n\n\n%s (%s)\n\nThe server:\nunitedhosts.org:27015\n\n",
				Nick,SID,
				Nick,SID
			)
			HAC.file.Write(fDesc, This)
		end
		
		
		
		//Total
		HAC.AddOneBan()
		
		//Abort map change
		HAC.HSP.AbortMapChange()
		
		//Add one to counter
		HAC.Box.Add("Ban")
		
		//Ring phone and VFD
		self:WriteVFD(Args1)
		
		//Write LastBan to player folder
		self:WriteLastInFolder()
		
		//Write LastBan, but don't sync yet
		self:WriteLast()
		
		//Mark as banned clientside
		self:SendLua("EIGHT = 8")
		
		//SCREENSHOT EVERY
		self:timer(20, function()
			if self:Banned() then
				self:TakeSCEvery(30)
			end
		end)
		
		//STOP HERE IF SILENT
		if HAC.Silent:GetBool() then return Logged end
		
		
		
		//Hide UI
		self:HideGameUI()
		
		//Draw halo
		self:DrawHalo(true)
		
		//BAN
		if not HAC.Banned[ SID ] then
			HAC.Banned[ SID ] = 1
			
			--UNBAN
			if isnumber(HACBantime) then
				timer.Simple( (HACBantime * 60), function()
					HAC.Banned[ SID ] = nil
				end)
			end
		end
		
		//Add bots for aiming
		if #player.GetBots() < 2 and not player.IsHeXOn() then
			RunConsoleCommand("bot"); RunConsoleCommand("bot")
		end
		
		//HORRIBLE PERSON
		self:timer(20, function()
			self:HAC_EmitSound("uhdm/hac/you_are_a_horrible_person.mp3", "Horrible person")
		end)
		
		//If HeX is on
		local HeX = HAC.GetHeX()
		if IsValid(HeX) then
			HeX:Hide(true)
		end
	end
	//WAIT FOR MORE LOGS
	
	//BanHook, POST - extra punishments, sv_Detections
	if HAC.Det.BanHook(self,Args1) then return end
	
	
	
	
	//MAIN TIMER
	if self.HAC_Timer then return end
	
	//Tick - Called every 0.1s
	local function HAC_TIMER_TICK(Timer, UpTo, Rem, Tot)
		if not IsValid(self) then return TIMER_KILL end
		
		//Update TimeLeft display
		if UpTo > 2 then
			self:UpdateTimeLeft()
		end
	end
	
	//End - LOCKED ON
	local function HAC_TIMER_END(Timer, Total)
		if not IsValid(self) or HAC.Silent:GetBool() then return TIMER_KILL end
		//Wait for burst/HKS, HurryUp done there, SKIP IF HURRY NOW
		if ( self:HKS_InProgress() or self:Burst_InProgress() ) and not self.HAC_HurryRightNow then return TIMER_WAIT end
		
		//Just Before Ban
		self.HAC_JustBeforeBan = true
		
		//TimeLeft
		self:UpdateTimeLeft()
		
		//Override LastBan, sync to all!
		self:WriteLast(true)
		
		
		//LOCKED ON chat message
		MsgAll("\n[HAC] Locked on: "..Nick.." ("..SID..")\n")
		HAC.CAT(
			HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
			HAC.ORANGE, ">>> ",
			HAC.RED, "LOCKED ON",
			HAC.ORANGE, " <<<"
		)
		
		for k,v in NonBanned() do
			//Sound
			v:HAC_EmitSound("uhdm/hac/timer_end.mp3", "!# Timer end", true, function()
				//LOCKED ON
				v:HAC_SPS("vo/novaprospekt/al_readings02.wav")
			end)
			
			//If HeX
			if v:HAC_IsHeX() then
				//Hide UI
				v:Hide(true)
				
				//Respawn for the pic
				local Here = v.HAC_SpawnHere
				if Here then
					v:RespawnIfDead(Here.Pos)
					v:SetPos(Here.Pos)
					v:SetEyeAngles(Here.Ang)
				end
				v:SetHealth(88888)
				
				//Give camera
				v:Give("gmod_camera")
				v:SelectWeapon("gmod_camera")
			else
				//Strip weapons
				v:SetBugBait(60,
					"Camera selected for 60s, "..Nick.." made a terrible mistake!",
					"All guns are back"
				)
			end
		end
		
		
		//CLOSE BSOD
		self:CloseBluescreen()
		
		//Remove Balls of Steel
		self:RemoveBallsOfSteel(true)
		
		//Stop spinning
		self:StopSpin()
		
		//Remove bin
		self:RemoveBin(true)
		
		
		
		//Final tick
		local function HAC_FINAL_TICK(Timer, UpTo, Rem, Tot)
			if not IsValid(self) then return TIMER_KILL end
			
			//5 seconds to go, just after "Ok doc, we're locked on"
			if UpTo == 5 then
				if not self:VarSet("DONETIMER") then
					//ACHIEVEMENT -  Scanned Alone
					if SACH and SACH.ACH_ScannedAlone then
						SACH.ACH_ScannedAlone(self)
					end
					
					//No more chat spam
					self.HAC_IsMuted = true
					
					//Mock the cheater
					self:HAC_EmitSound("vo/citadel/br_mock01.wav", "6 SECONDS TO GO", true)
					
					//Lock halo OFF
					self:DrawHalo(false,true)
					
					//GetClipboardText - one last time
					--self:GetClipboardText() --Fucked 11.09
					
					//Tell everyone - Watch and learn!
					for k,v in NonBanned() do
						v:HACGAN(
							"Get your camera ready, "..Nick.." made a terrible mistake!",
							NOTIFY_CLEANUP,
							4,
							Sound("uhdm/hac/watch_and_learn.mp3")
						)
					end
				end
			end
			
			//KICK HIS ASS, wait 6s
			if UpTo == 11 then
				HACBantime = isnumber(HACBantime) and HACBantime.." min" or HACBantime
				
				--DO HAX
				if not self:VarSet("DONEMSG") then
					//RANK
					if self.GetLevel and self:GetLevel() != 7 and not HAC_IsHeX then
						self:SetLevel(7) --Cheater
					end
					
					
					//Message
					MsgN("\n[HAC] Autobanned: ", Nick," "..HACBantime.." ban. Hacks detected!\n")
					HAC.CAT(
						HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
						HAC.RED, "Autobanned ",
						self:TeamColor(), Nick,
						
						HAC.WHITE, " (",
						HAC.GREEN2, SID,
						HAC.WHITE, ") ",
						
						HAC.RED, HACBantime,
						HAC.WHITE, " ban. Hacks detected!"
					)
					
					//Sound
					for k,v in Everyone() do --NonBanned
						v:HAC_SPS("ambient/machines/thumper_startup1.wav")
					end
					
					//Remove hammers
					self:RemoveAllHammers()
					
					//HAAAAAAX!
					self:DoHax()
				end
			end
			
			//End, BAN
			if UpTo == Tot then
				if self:VarSet("DONEKICK") then return end
				
				if not HAC_IsHeX then
					//LCD
					if not self:IsBot() then
						HAC.TotalBans = HAC.TotalBans + 1
					end
					
					//Total bans
					local Bans = HAC.GetAllBans() + table.Count(HAC.Skiddies)
					Bans = HAC.NiceNum(Bans)..HAC.AddTH(Bans)
					
					//Message
					HAC.CAT(
						HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
						self:TeamColor(), Nick,
						
						HAC.WHITE, " (",
						HAC.GREEN2, SID,
						HAC.WHITE, ") ",
						
						HAC.WHITE, "just became the ",
						HAC.PURPLE, Bans,
						HAC.WHITE, " banned player!"
					)
					print("\n[HAC] ", Nick, " just became the "..Bans.." banned player!\n")
				end
				
				HAC.PlayerDisconnected(self)
				self.HAC_NoLogDisconnect = true
				
				self:HAC_Drop("\n[HAC] Autobanned :(\n\n"..HACBantime.." ban. Hacks detected!")
			end
		end
		
		//FINAL TIMER
		self.HAC_Timer_Final = timer.Add(
			"HAC_Timer_Final"..tostring(self),
			18.4,
			
			Useless,
			HAC_FINAL_TICK
		)
	end
	
	//Start the countdown, can be adjusted
	self.HAC_Timer = timer.Add(
		"HAC_Timer"..tostring(self),
		HAC.WaitCVar:GetInt(),
		
		HAC_TIMER_END,
		HAC_TIMER_TICK
	)
end

//DoBan
function _R.Player:DoBan(str)
	if isstring(str) and str:FalsePos() then return end
	return HAC.DoBan(self, (isstring(str) and {str} or str), false)
end
//LogOnly
function _R.Player:LogOnly(str, always_log)
	if isstring(str) and str:FalsePos() then return end
	return HAC.DoBan(self, (isstring(str) and {str} or str), true, always_log)
end




--- Command gate ---
function HAC.KickMe(self,cmd,args,str)
	//Fucked with
	if not IsValid(self) then
		if #args > 0 then
			for k,v in pairs(args) do
				debug.ErrorNoHalt("! HAC.KickMe error: "..tostring(cmd)..", "..tostring(v)..", "..tostring(str) )
			end
		end
		return
	end
	local Args1 = args[1]
	if not ValidString(Args1) then
		self:FailInit("Args1 invalid!", HAC.Msg.HC_Init)
		return
	end
	
	
	//Check serverside, false = nothing, true = BAN
	if not HAC.CheckThatServerside(self,Args1,args) then
		return
		
	//False pos
	elseif Args1:FalsePos() then
		return
		
	//Log only
	elseif Args1:CheckInTable(HAC.LogOnly) then
		self:LogOnly(args)
		return
		
	else
		//BANBANBAN
		self:DoBan(args)
	end
end
concommand.Add(HAC.BanCommand,		HAC.KickMe)
concommand.Add(HAC.FakeBanCommand,	HAC.KickMe)
concommand.Add(HAC.SEBanCommand,	HAC.KickMe)

concon.Add(HAC.AuxBanCommand,		HAC.KickMe)
concon.Add(HAC.BanCommand,			HAC.KickMe)
concon.Add(HAC.FakeBanCommand,		HAC.KickMe)
concon.Add(HAC.SEBanCommand,		HAC.KickMe)

for k,v in pairs(HAC.AllBanCommand) do
	concommand.Add(v, HAC.KickMe)
	concon.Add(v, HAC.KickMe)
end






//Command
function HAC.Command(self,cmd,args)
	if not self:HAC_IsHeX() then return end
	
	if #args < 1 then
		//Print everyone
		self:print("")
		for k,v in Humans() do
			local Res 	= v:Banned() and "BANNED" or v:HasFailedInit() and (v.HAC_AbortInitKick and "ABORT" or "Failed") or ""
			local Fail 	= v:HasFailedInit() 	and v.HAC_InitFirst.str or ""
			local Ban	= v.HAC_FirstDetection 	and v.HAC_FirstDetection or ""
			
			self:print(
				Format("%s\t%s\t%s <%s>\t%s%s", v:TimerLeft(), Res, v.AntiHaxName,v:UserID(), Ban,Fail)
			)
		end
		self:print("")
		
		return
	end
	
	//Manual ban
	local Him = tonumber( args[1] )
	if not Him or Him == 0 then
		self:print("[HAC] Invalid index")
	end
	
	Him = Player(Him)
	if not IsValid(Him) then
		self:print("[HAC] Invalid player")
		return
	end
	
	Him.DONEBAN = false
	Him:DoBan("ManualBan")
end
concommand.Add("hac", HAC.Command)



//Unban all
function HAC.UnbanAll(self,cmd,args)
	if not self:HAC_IsHeX() then return end
	
	local Tot = 0
	for k,v in pairs(HAC.Banned) do
		Tot = Tot + 1
		self:print("[OK] Unbanning "..k)
	end
	for k,v in pairs(HAC.BannedIP) do
		self:print("[OK] Unbanning IP "..k)
	end
	HAC.Banned	 = {}
	HAC.BannedIP = {}
	
	self:print("[OK] Unbanned "..Tot.."\n")
end
concommand.Add("unbanall", HAC.UnbanAll)


//Clear LCD
function HAC.Clear(self,cmd,args)
	if not self:HAC_IsHeX() then return end
	
	//BANBox
	HAC.Box.ResetAll(true)
	
	HAC.TotalBans	= 0
	HAC.TotalHacks	= 0
	HAC.StreamHKS	= 0 --LCD
	HAC.TotalFails	= 0
	
	self:print("[HAC] Clear all counters")
end
concommand.Add("hac_clear", HAC.Clear)


//Debug
function HAC.ToggleDebug(self,cmd,args)
	if not self:HAC_IsHeX() then return end
	
	if HAC.Conf.Debug then
		HAC.Conf.Debug 	= not HAC.Conf.Debug
		HAC.BCode.Debug = not HAC.BCode.Debug
		
		self:print("[HAC] ---DEBUG DISABLED---")
	else
		HAC.Conf.Debug 	= not HAC.Conf.Debug
		HAC.BCode.Debug = not HAC.BCode.Debug
		
		self:print("[HAC] +++DEBUG ENABLED+++")
	end
end
concommand.Add("hac_debug", HAC.ToggleDebug)


//Set spawn pos for pic!
function HAC.SetHere(self)
	if not (IsValid(self) and self:HAC_IsHeX()) then return end
	self:print("[HAC] Set Here")
	
	self.HAC_SpawnHere = {
		Pos	= self:GetPos(),
		Ang	= self:EyeAngles(),
	}
end
concommand.Add("here", HAC.SetHere)



HAC_Installed = (HAC_Installed or 1) + 1

MsgN("  Loaded all plugins & Lists!")
MsgN("///////////////////////////////////")
MsgN("//          [HAC] loaded         //")
MsgN("///////////////////////////////////\n")












