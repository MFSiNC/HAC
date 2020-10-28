
HAC.Group = {}


//Log all his groups for later checking
function _R.Player:DumpGroups()
	self.HAC_IsDumpingGroups = true
end

function HAC.Group.DumpCheck()
	for k,v in pairs( player.GetHumans() ) do
		if not (v.HAC_NotBadGroups and v.HAC_IsDumpingGroups) then continue end
		
		//Once only!
		if v.HAC_IsDumpingGroups_DONE then continue end
		v.HAC_IsDumpingGroups_DONE = true
		
		
		//Log
		local Log 	= "\nDumpGroups for: "..v:HAC_Info(nil,1).."\n\n"
		local HTML	= "<title>"..Log.."</title><br>"..Log
		for k,GID32 in pairs(v.HAC_NotBadGroups) do
			Log 	= Log..Format("\nhttp://steamcommunity.com/gid/[g:1:%s]\n", GID32)
			HTML = HTML..Format('\n\t<br><a href="http://steamcommunity.com/gid/[g:1:%s]">http://steamcommunity.com/gid/[g:1:%s]</a><br>\n', GID32, GID32)
		end
		Log  = Log.."\nEnd DumpGroups.\n\n"
		HTML = HTML.."\nEnd DumpGroups.\n\n"
		
		
		//Write
		HAC.file.Append(v.HAC_Dir.."/sapi_unk_groups.txt", Log)
		//Global log
		--HAC.file.Append("api_unk_groups.txt", Log)
		
		//HTML version (for clicking)
		local Path = v.HAC_Dir.."/api_unk_groups_html.txt"
		HAC.file.Append(Path, HTML)
		HAC.file.Rename(Path, ".html")
	end
end
hook.Add("Think", "HAC.Group.DumpCheck", HAC.Group.DumpCheck)




//Generate new table from list of profile URLs
local AllProf = {}

local function DoProf(URL, k,Total)
	local Prof = URL:gsub("http://steamcommunity.com/groups/", "")
	URL = URL.."/memberslistxml/?xml=1"
	print("! DoProf: ", Prof, k,Total)
	
	http.Fetch(
		URL,
		
		function(body)
			//Body
			if not ValidString(body) then
				//No body
				ErrorNoHalt("ProfileLookup: no body: "..Prof.."\n")
				return
			end
			
			local idx,GID64 = body:match("<groupID64%s*(.-)>(.-)</groupID64>")
			if not ValidString(GID64) then
				ErrorNoHalt("ProfileLookup: no GID64: "..Prof..", "..URL.."\n"..body:Left(256).."\n")
				return
			end
			
			AllProf[ GID64 ] = Prof
			
			print("! Add prof: ", Prof, GID64)
		end,
		
		//No connection
		function(code)
			ErrorNoHalt("ProfileLookup: Failed HTTP for "..Prof.." (Error: "..code..")\n")
		end
	)
	
	//Done
	timer.Simple(3, function()
		if k == Total then
			if table.Count(AllProf) == Total then
				print("\n! Got all "..Total.." profiles!\n")
			else
				print("\n! ERROR GETTING SOME PROFILES, only "..table.Count(AllProf).." of "..Total.." profiles!\n")
			end
			
			local Log = ""
			local Got = 0
			local New = 0
			for GID64,Prof in pairs(AllProf) do
				if HAC.Group.BadGroups[ GID64 ] then
					Got = Got + 1
					continue
				end
				New = New + 1
				
				Log = Log..Format('\n\t["%s"] = "%s",', GID64, Prof)
			end
			
			print("! Written: "..New.." new, already got: "..Got.." profiles")
			
			if ValidString(Log) then
				HAC.file.Write("hac_process_prof.txt", Log)
			end
		end
	end)
end



function HAC.Group.Command(ply,cmd,args,str)
	AllProf = {}
	
	local fName = args[1]
	if not ValidString(fName) then
		ply:print("! no fName!")
		return
	end
	fName = fName..".txt"
	
	local Cont = file.Read(fName, "DATA")
	if not ValidString(Cont) then
		ply:print("! no Cont!")
		return
	end
	
	local Good = {}
	for k,Line in pairs( Cont:Split("\r\n") ) do
		if not ValidString(Line) or not Line:find("steamcommunity") then continue end
		if not table.HasValue(Good,Line) then table.insert(Good, Line) end
	end
	
	local Total = #Good
	local Timer = 0
	for k,Line in pairs(Good) do
		timer.Simple(Timer, function()
			DoProf(Line, k,Total)
		end)
		Timer = Timer + 1.5
	end
end
concommand.Add("hac_group_add", HAC.Group.Command)




HAC.Group.BadGroups = {











	["103582791435389037"] = "GoronCityBackFromTheGrave",
	["103582791435880488"] = "420KushLords",
	["103582791432669492"] = "Brony-Group",
	["103582791433899321"] = "BroniesofAwesome",
	["103582791433519867"] = "PBFL",
	["103582791433305065"] = "MLPISTHEMANLY",
	["103582791434432390"] = "CanterlotHigh",
	["103582791433575163"] = "LOLROFLMFAOGTFo",
	["103582791435058880"] = "hackerrrs",
	["103582791433204270"] = "dummYx0r",
	["103582791432288489"] = "TF2Xploits",
	["103582791435093000"] = "Nyaaaas-Fans",
	["103582791435663344"] = "noanimeshittersallowed",
	["103582791435479545"] = "VACLifetimeMembership",
	["103582791435539801"] = "flutterpie",
	["103582791435137849"] = "YoeyForever",
	["103582791434837284"] = "ALLHAILLENNY",
	["103582791432501334"] = "organnerteam",
	["103582791433377979"] = "odpalamyhaxy",
	["103582791432418389"] = "PRODVIGAIORGANNER",
	["103582791431942409"] = "ORGANNERlove",
	["103582791434633632"] = "witouthxjc",
	["103582791432882328"] = "cheatorganner",
	["103582791432355472"] = "_ORGANNER_",
	["103582791432554586"] = "organersub",
	["103582791434685091"] = "organner_css",
	["103582791432653233"] = "organneer",
	["103582791432210266"] = "blubbbbbii",
	["103582791433272283"] = "Organnerne",
	["103582791434744310"] = "dcfsdfdsafdhfdgfsd",
	["103582791432165307"] = "hl2organnerpl",
	["103582791433003582"] = "orgaaaaaannnnnnneeeeeer",
	["103582791431957615"] = "dwdawdawdwd",
	["103582791432864727"] = "ORGANNERNP",
	["103582791432653233"] = "organneer",
	["103582791433182902"] = "234234231",
	["103582791433016864"] = "organaaaz",
	["103582791433272283"] = "Organnerne",
	["103582791432882328"] = "cheatorganner",
	["103582791433223387"] = "organnerrrrr",
	["103582791433258835"] = "eratae",
	["103582791430856447"] = "jayisafag",
	["103582791432864727"] = "ORGANNERNP",
	["103582791433377979"] = "odpalamyhaxy",
	["103582791431299536"] = "organners",
	["103582791431707470"] = "organnerplx22x",
	["103582791430446833"] = "123123123123123123123",
	["103582791430565584"] = "103582791430565584",
	["103582791431421557"] = "organna",
	["103582791431220849"] = "ORGANNERHAXER",
	["103582791431294065"] = "weloveorganner",
	["103582791431386748"] = "TROOTOP",
	["103582791431744236"] = "ORGANNERy0",
	["103582791430266385"] = "ORGANNERdotpl",
	["103582791431346949"] = "ORGANNERPL",
	["103582791431565184"] = "orgamd",
	["103582791431342038"] = "594187919616",
	["103582791434604432"] = "youhavebeenvacced",
	["103582791433079037"] = "hackingfornoobs",
	["103582791433393491"] = "IMMUNITYCSS",
	["103582791429953717"] = "BOGUS",
	["103582791433532460"] = "49640148",
	["103582791432639124"] = "organnert",
	["103582791434503445"] = "Dah-organner",
	["103582791433762482"] = "OrgannerISgood",
	["103582791431876043"] = "OrgannerPolskiSupport",
	["103582791431260178"] = "organnerz",
	["103582791433596801"] = "ORGANNERFANS",
	["103582791431355601"] = "team-organner",
	["103582791429612003"] = "ORGANNER",
	["103582791434777008"] = "OrgannerESLPROOF",
	["103582791431260454"] = "aNNboi",
	["103582791433670357"] = "-UNDETECTED-",
	["103582791434168914"] = "LowwkY",
	["103582791434404878"] = "organnah",
	["103582791435592492"] = "OGnner",
	["103582791433636035"] = "fan4egrip",
	["103582791431779070"] = "germanygivesyoudick",
	["103582791433182781"] = "united1337",
	["103582791435620476"] = "INMEMORYOFALLAN",
	["103582791434405709"] = "ugsduisaxyaIU",
	["103582791433679341"] = "DISCOWERY",
	["103582791430843584"] = "choppaaaa",
	["103582791431537575"] = "FEEL1NG",
	["103582791431271818"] = "SERIOUSBUSINESS1",
	["103582791434460279"] = "XaviaXMyLove",
	["103582791431626167"] = "scruulsfanboys",
	["103582791431665122"] = "wkg",
	["103582791430845146"] = "KevinBond",
	["103582791431164158"] = "whiteknucklegaming",
	["103582791430457908"] = "KeyboardBenchers",
	["103582791433699688"] = "GETIN2K13FRIENDSSSSANDFANSSSSSSS",
	["103582791432180710"] = "we_killed_source",
	["103582791430928024"] = "isintense",
	["103582791430607863"] = "ANGERSVENT",
	["103582791432315556"] = "gcf-file",
	["103582791433026424"] = "ShittyAdminsBanMe",
	["103582791430620789"] = "evennandglockateer",
	["103582791432636116"] = "HACKbaellchen",
	["103582791432560351"] = "PrivatLeague",
	["103582791432554057"] = "gcf_hacks",
	["103582791434749395"] = "ergrg",
	["103582791434767124"] = "1337eUU",
	["103582791432606404"] = "hfr1337",
	["103582791433718789"] = "gonzobusted",
	["103582791432580550"] = "gcfinvite",
	["103582791431948105"] = "wwwX22com",
	["103582791434168407"] = "LegitModus",
	["103582791434673497"] = "OBEYUSGROUP",
	["103582791435062341"] = "CelestialCSGO",
	["103582791430669313"] = "CHEATS4FREE",
	["103582791435586816"] = "3d3lhur3n",
	["103582791435048689"] = "get1doogednerd",
	["103582791434611300"] = "aTTaXHooK",
	["103582791435448562"] = "TurtleEsport",
	["103582791433015320"] = "anticheatsteam",
	["103582791431735246"] = "ORGANNER4LIFE",
	["103582791430585483"] = "w7-Gaming",
	["103582791434399164"] = "cewkimix",
	["103582791432750534"] = "TEAMNEORGANNER",
	["103582791433182270"] = "1st_kings",
	["103582791430492932"] = "2legitimate",
	["103582791431860775"] = "legitpaar",
	["103582791433887950"] = "Organnerhax",
	["103582791433797578"] = "arschodermundaufkleines",
	["103582791432889663"] = "HackerHoldet123",
	["103582791433969723"] = "hl1framework",
	["103582791434013593"] = "WHFRMK",
	["103582791434217309"] = "essentrialz0r",
	["103582791434538123"] = "Arnavkatan",
	["103582791435635729"] = "Link-A",
	["103582791435109546"] = "crackedpawlak",
	["103582791434988339"] = "4MES",
	["103582791433050482"] = "hdgproplayers",
	["103582791434342417"] = "PLCorganner",
	["103582791434309255"] = "organner4pl",
	["103582791434104743"] = "ORGANNERPLAA",
	["103582791434497923"] = "organnerpl20beta",
	["103582791434422354"] = "orgaNnerka",
	["103582791434046069"] = "SPONSOREDbyORGANNER",
	["103582791434414125"] = "ORGANNERpI",
	["103582791434498805"] = "ORGANNERRRRRRRRRRRR",
	["103582791434527492"] = "1337organnerleet",
	["103582791433962369"] = "ORGANNERFGHJFG",
	["103582791433960105"] = "883288238324",
	["103582791435599393"] = "0rgannerpl",
	["103582791433545879"] = "ORGANNERsdwdqq",
	["103582791433856418"] = "1337CREW1337",
	["103582791435605460"] = "organnertlp",
	["103582791435126910"] = "organneris",
	["103582791435193288"] = "organnerpower",
	["103582791435185883"] = "orgfans",
	["103582791434790512"] = "Organnerorganner",
	["103582791434955778"] = "ripuliripuli",

	["103582791435208449"] = "Applenonymous",
	["103582791435431305"] = "TheExtremeBronies",
	["103582791433194586"] = "7R0llED",
	["103582791434217072"] = "coolestkidsontheblock",
	["103582791432206915"] = "PnC_Servers",
	["103582791431338446"] = "hobo-protection-squad",
	["103582791434644192"] = "madeumadlol",
	["103582791434565679"] = "peopleagainstmuslims",
	["103582791434407335"] = "scrubfreegamingbynerve",
	["103582791433648262"] = "NOXPRESIDENT2013",
	["103582791435494913"] = "mexhoes",
	["103582791434128934"] = "NoxTheMLGTheBest2013",
	["103582791432159116"] = "LOLYOUfanClub",
	["103582791433848128"] = "fuckshityoloswag",
	["103582791434421474"] = "Letsseeeee",
	["103582791434826287"] = "ReCoNL33T",
	["103582791432238907"] = "fatasshole",
	["103582791431933607"] = "datpaste",
	["103582791435023524"] = "kirbyinstedofadd",
	["103582791435015405"] = "DEMOLITIOND",
	["103582791434315337"] = "Gdiplaygame",
	["103582791434740610"] = "TROLLALALALALAL",
	["103582791435497188"] = "ocstresser",
	["103582791431256228"] = "OWNZONEOWNZONEOWNZO",
	["103582791432787450"] = "ScrubFreeGaming",
	["103582791433689772"] = "HackvsGP",
	["103582791431342003"] = "Tyr4N",
	["103582791434262190"] = "gphack",
	["103582791435027463"] = "Gangster_Paradise_",
	["103582791434913934"] = "ragedfuckers",
	["103582791435491623"] = "onlyperfecthekers",
	["103582791433035099"] = "DosGruppen",
	["103582791435027452"] = "Gangster_Paradise",
	["103582791435182883"] = "NigerianAgency",
	["103582791435169260"] = "AIMWARE",
	["103582791435159768"] = "LulzPirate",
	["103582791432849875"] = "ironponygaming",
	["103582791433369444"] = "weloveyoutwilight",
	["103582791433277869"] = "Mafiaponyville",
	["103582791434200635"] = "DahLegion",
	["103582791432853915"] = "ThePOF",
	["103582791433614151"] = "TheAwsomeBronys",
	["103582791433317676"] = "samuraiponies",
	["103582791434372907"] = "sexyponiesinsexysocks",
	["103582791434223140"] = "mlmfip",
	["103582791433369173"] = "retardsifound",
	["103582791433409012"] = "StraightBronies",
	["103582791433627909"] = "iblamedashieTM",
	["103582791434387364"] = "PonyvilleTX",
	["103582791434442435"] = "BIGGAYWEEDDADDIES",
	["103582791434435911"] = "543552435234545245",
	["103582791434387733"] = "sexydasha",
	["103582791434052965"] = "putanendtoracism",
	["103582791434451497"] = "CompTF2Pony",
	["103582791434268306"] = "BaconsBronyGroup",
	["103582791433139410"] = "zombiebronies",
	["103582791433534698"] = "dfgsgsdgfsdgsdfgsdfsdfsdfsdf",
	["103582791433003831"] = "friedfuckingchicken",
	["103582791433423473"] = "specialskirts",
	["103582791432466143"] = "weloveshasorange",
	["103582791435241438"] = "TheNeckbeardClub",
	["103582791429523376"] = "unitednegrofund",
	["103582791435112050"] = "poniesarebad",
	["103582791434489846"] = "autismawards",
	["103582791435439520"] = "XSMX_LS",
	["103582791435486432"] = "VaBaCo",
	["103582791434723366"] = "lololollolololoololollll",
	["103582791435493172"] = "420SwegYulo",
	["103582791435140894"] = "Thomasgillespiehasbignips",
	["103582791434769771"] = "Nicolas69Cage",
	["103582791434985708"] = "TrueAmericanHero",
	["103582791435360929"] = "pedo_philes",
	["103582791435107100"] = "imasturbate",
	["103582791434878362"] = "shounen-ai",
	["103582791435150305"] = "APFAFH",
	["103582791429526412"] = "toughguys",
	["103582791431260563"] = "giantfuckingcocks2",
	["103582791435120707"] = "wowmuchtroll",
	["103582791434552818"] = "shrekcultists",
	["103582791434709345"] = "surprisedthisisnttaken",
	["103582791434648107"] = "horsefawkerz",
	["103582791435306345"] = "acstangodown",
	["103582791435252594"] = "gccu",
	["103582791435093211"] = "girlsmademegay",
	["103582791433259701"] = "mylittleponygaming",
	["103582791432482494"] = "CloudsdaleAirForce",
	["103582791433149386"] = "doyouevenliftforthelord",
	["103582791432629395"] = "AWHEEELLNAW",
	["103582791432799415"] = "suttlessucks",
	["103582791432874108"] = "FAGGOT-LAND",
	["103582791431195160"] = "gayweedddads",
	["103582791432360695"] = "TruNiggas",
	["103582791431059175"] = "iloveeatingwithgabenewell",
	["103582791432784856"] = "gibhatstosam",
	["103582791432565240"] = "gabenewellsmagicallovetub",
	["103582791433487169"] = "BNBF",
	["103582791432717862"] = "secksualepredatorez",
	["103582791432297266"] = "pleasefaponmyface",
	["103582791433298997"] = "menwhoplaydicks",
	["103582791435477791"] = "loltismthesecond",
	["103582791433048707"] = "captainsnoop",
	["103582791434052965"] = "putanendtoracism",
	["103582791435424679"] = "myg0ku",
	["103582791433184213"] = "AB-O",
	["103582791433170393"] = "expose_yourself",
	["103582791433565221"] = "lifesizedponies",
	["103582791435264322"] = "aaaaaaaalien",
	["103582791433897658"] = "inbredpageantpirates",
	["103582791429523376"] = "unitednegrofund",
	["103582791429574385"] = "fatkids",
	["103582791431260563"] = "giantfuckingcocks2",
	["103582791431786684"] = "ponyville",
	["103582791430006435"] = "itsoktobegay",
	["103582791431195160"] = "gayweedddads",
	["103582791432212663"] = "ponyfortress2",
	["103582791432331403"] = "mlptf2mods",
	["103582791429620564"] = "letsgetlaid",
	["103582791435105256"] = "cuntflap",
	["103582791435493172"] = "420SwegYulo",
	["103582791435036861"] = "SodasArmy",
	["103582791435306345"] = "acstangodown",
	["103582791434236299"] = "Nlita1337",
	["103582791434682794"] = "TheLulzSecCP",
	["103582791431499474"] = "mlpfim", --Not cheaters, just idiots.
	["103582791434598874"] = "7-Sky, nanocat",
	["103582791435321764"] = "Aonix, nanocat/cheating",
	["103582791434959610"] = "rebulzzzz",
	["103582791435326424"] = "fukingniggers",
	["103582791434674128"] = "5W4GN3M1T3",
	["103582791434585870"] = "sniparsgroup",
	["103582791434518947"] = "Papa-Johns",
	["103582791435083237"] = "Fapplet",
	["103582791434349521"] = "ButtFats",
	["103582791434556392"] = "HAPANAL",
	["103582791434401668"] = "hillybilly",
	["103582791434842137"] = "Sketti4lyf",
	["103582791435033042"] = "2DESU4U",
	["103582791434076778"] = "WelikeMingebags",
	["103582791434711856"] = "twantieeephorth",
	["103582791434635183"] = "Icedpkclan",
	["103582791433746777"] = "GmodTrollz",
	["103582791434554356"] = "eupk",
	["103582791434925148"] = "bolivianindependence",
	["103582791434420798"] = "GarryJewman",
	["103582791433741197"] = "kanspirasy",
	["103582791434913299"] = "shitpropkillgroup",
	["103582791434422449"] = "ripblueman",
	["103582791430481400"] = "weH8S",
	["103582791435173240"] = "anti-cheatsquad",
	["103582791434476933"] = "Austisim",
	["103582791432037553"] = "pokitraining",
	["103582791434675531"] = "propkillersdaf",
	["103582791432064659"] = "x22LoversS2",
	["103582791433986865"] = "4534562",
	["103582791430966275"] = "x22-like",
	["103582791431806819"] = "UnKnoWnCheaTsH4x",
	["103582791430367008"] = "x22pcw",
	["103582791433679254"] = "Likex22Like",
	["103582791431412855"] = "X22USERZ",
	["103582791433951949"] = "x22crackeddd",
	["103582791434910786"] = "TF2Haxx0rCrew",
	["103582791431846244"] = "ILovex22",
	["103582791432843462"] = "cheats_sale",
	["103582791431663499"] = "Enhanced-Aim",
	["103582791434720246"] = "hackforthebest",
	["103582791429912945"] = "game-deception",
	["103582791431313165"] = "Likex22Group",
	["103582791431969234"] = "x22ii",
	["103582791433991539"] = "x22Publik",
	["103582791431839595"] = "x23_",
	["103582791432070283"] = "x22userandlover",
	["103582791431972638"] = "x22regelt",
	["103582791431132000"] = "kuNNNNx22",
	["103582791431541292"] = "x22hack",
	["103582791434040895"] = "x22freak",
	["103582791434829230"] = "xyo22",
	["103582791431500049"] = "Krayzergruop",
	["103582791430965258"] = "x22",
	["103582791433848220"] = "TEAMHVH",
	["103582791431744567"] = "x22likesickgamingskill",
	["103582791432411301"] = "x22_like_love",
	["103582791431935059"] = "-Pro-GamerZ-",
	["103582791432828900"] = "x22y0",
	["103582791432661573"] = "x22hacks",
	["103582791433913448"] = "x22Activedx22",
	["103582791432825054"] = "22cheatx",
	["103582791431436593"] = "fan-de-x22",
	["103582791434302382"] = "HivEpk",
	["103582791431399331"] = "odio_al_x22_y_sus_users",
	["103582791430821504"] = "x22users",
	["103582791431299386"] = "grupox22",
	["103582791433007411"] = "settingsnice",
	["103582791432845700"] = "xInstantHook",
	["103582791433223385"] = "x22usercheat",
	["103582791432639768"] = "xX22REGELT",
	["103582791433849485"] = "x22-Customer",
	["103582791430638093"] = "myrmidonguild",
	["103582791431737365"] = "sjbnchbhcibsdopvhdsovadngpo35635",
	["103582791432130494"] = "x222222222222222222222",
	["103582791431917711"] = "enhancedaim",
	["103582791432022567"] = "EnhancedAimCSS",
	["103582791434489541"] = "kinzisuserofx22",
	["103582791431587303"] = "LiKEx22y00",
	["103582791431799952"] = "x22--like--",
	["103582791433986840"] = "672388",
	["103582791434531386"] = "TeamFUAK",
	["103582791432371456"] = "lovex22",
	["103582791431698803"] = "x22Lovers",
	["103582791433950650"] = "x22CheatsUnOfficial",
	["103582791430927815"] = "miraye",
	["103582791434419294"] = "ACS",
	["103582791429813559"] = "r00t",
	["103582791430194125"] = "MPGH",
	["103582791430803964"] = "HackingClub",
	["103582791430087319"] = "My-g0t",
	["103582791433856460"] = "QuikHop",
	["103582791430472985"] = "myg0thaters",
	["103582791432555506"] = "HFGM",
	["103582791434969773"] = "RustHackForums",
	["103582791430682520"] = "HackingPros",
	["103582791430495525"] = "myg0t_international",
	["103582791429991598"] = "103582791429991598",
	["103582791431285194"] = "thearmyofmpgh",
	["103582791431806176"] = "HackforumsCrew",
	["103582791429805723"] = "103582791429805723",
	["103582791429761110"] = "103582791429761110",
	["103582791430375700"] = "Myg0tisbest",
	["103582791433594341"] = "Krolek",
	["103582791434476091"] = "HackForumsNet",
	["103582791431701934"] = "HvH-1337-hacking",
	["103582791434598241"] = "StoneyLegion",
	["103582791429682469"] = "the_h4xing_league",
	["103582791429812292"] = "myg0t",
	["103582791432144835"] = "Niggest",
	["103582791431338919"] = "resurrected-cheats",
	["103582791434086026"] = "r00dbois",
	["103582791434018213"] = "way2stronk4u",
	["103582791431245138"] = "Ihatestuff",
	["103582791433605374"] = "SkrillexEnthusiastFanclub",
	["103582791433618356"] = "tylershackschool",
	["103582791430472985"] = "myg0thaters",
	["103582791434670357"] = "TFWF",
	["103582791433941474"] = "0verd0necheats",
	["103582791433582095"] = "xX666DEATHMETAL666Xx",
	["103582791432568242"] = "45475768",
	["103582791433280498"] = "Stilltryingtounzipit",
	["103582791432016325"] = "selfcoded-cheats",
	["103582791434555194"] = "pkillunited",
	["103582791434055772"] = "forlinegrunts",
	["103582791430313504"] = "poki",
	["103582791434305087"] = "POREEESE",
	["103582791431959783"] = "TheForline",
	["103582791434168612"] = "DedicatedToSloths",
	["103582791434509300"] = "SECRETMARVELSUPERHEROS",
	["103582791430925056"] = "Madbro",
	["103582791433379136"] = "maddcuzbadd",
	["103582791434877546"] = "NoNAnonPub",
	["103582791434750705"] = "orderoftheprop",
	["103582791434025737"] = "pktournament",
	["103582791434200833"] = "rrekt",
	["103582791430224363"] = "jewsupreme",
	["103582791433146782"] = "RighteousHarmony",
	["103582791433775971"] = "KKKsupremeoverlords",
	["103582791434448844"] = "IHAVEABIGDENNY",
	["103582791433190313"] = "RMUM",
	["103582791434558007"] = "fssadqwxaz",
	["103582791432218971"] = "bruger-wh",
	["103582791432370938"] = "whysocereal",
	["103582791434411645"] = "4realsfanclub",
	["103582791433770128"] = "nmlpgaming",
	["103582791434929434"] = "propriders",
	["103582791430650999"] = "103582791430650999",
	["103582791433462001"] = "plbl4d2",
	["103582791434505073"] = "dimadonut",
	["103582791434294575"] = "swagginpotatoesyo",
	["103582791433842711"] = "PropKillingPropKillers",
	["103582791434098493"] = "TheTRollerPropKillers",
	["103582791431711097"] = "CowsPwn",
	["103582791434505280"] = "gay-bo",
	["103582791430822536"] = "steemedclams",
	["103582791432670026"] = "luastonedhvh",
	["103582791434712394"] = "firetrucksandswag",
	["103582791432668619"] = "rbminges",
	["103582791434074507"] = "PaKiPK",
	["103582791429630394"] = "911insidejob",
	["103582791434783472"] = "lebronquickscopes",
	["103582791434897070"] = "AndersBreivikAllStarTeam",
	["103582791431371079"] = "ninus",
	["103582791433625419"] = "tylerstrollinggrouptrololo",
	["103582791430810352"] = "gabesgotdank",
	["103582791433153149"] = "bobjimjoejackson",
	["103582791434229741"] = "AnonOficial",
}


STEAM_ID_BASE = "103582791429521408"

function GID_64To32(GID64)
	if not longmath then ErrorNoHalt("sv_Group, GID_64To32: No longmath!\n") return "1337" end
	return longmath.Minus(GID64, STEAM_ID_BASE)
end
function GID_32To64(GID32)
	if not longmath then ErrorNoHalt("sv_Group, GID_32To64: No longmath!\n") return "1338" end
	return longmath.Add(GID32, STEAM_ID_BASE)
end

for k,v in pairs( table.Copy(HAC.Group.BadGroups) ) do
	HAC.Group.BadGroups[ GID_64To32(k) ] = {v,k}
end





























