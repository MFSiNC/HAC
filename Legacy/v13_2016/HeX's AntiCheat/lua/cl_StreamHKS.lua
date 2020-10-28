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

local _G				= _G
local include			= _G.include
local tostring			= _G.tostring
local type				= _G.type
local pcall				= _G.pcall
local pairs				= _G.pairs
local ErrorNoHalt		= _G.ErrorNoHalt
local Format			= _G.string.format
local NotSM 			= _G.string.match
local NotSL				= _G.string.lower
local NotSF				= _G.string.find
local NotSS				= _G.string.sub
local NotFO				= _G.file.Open
local NotFID			= _G.file.IsDir
local NotFF				= _G.file.Find
local NotFD				= _G.file.Delete
local NotFT				= _G.file.Time
local NotTS				= _G.timer.Simple
local NotCRC			= _G.util.CRC
local NotTSS			= _G.table.sort
local NotTIS			= function(k,v) k[#k+1] = v end
local Tabify			= function(t) local N = {} for k,v in pairs(t) do N[v] = 1 end return N end
local Count				= function(t) local i = 0 for k,v in pairs(t) do i = i + 1 end return i end
local HookCall 			= _G.net.SendEx
local net_Hook			= _G.net.Hook
local NotJST			= _G.util.TableToJSON
local NotB64			= _G.util.Base64Encode
local DelayBAN			= _G.DelayBAN
local Lists				= _G.Lists2
local RunConsoleCommand	= _G.HAC_RCC or RunConsoleCommand
local White_DLC			= Lists.White_DLC
local Useless_Data 		= Lists.White_HKS_Main.Useless_Data
local Useless			= Lists.White_HKS_Main.Useless
local Useless_Addons	= Lists.White_HKS_Main.Useless_Addons
local Useless_Mod		= Lists.White_HKS_Main.Useless_Mod
local NoSend			= Tabify(Lists.White_HKS)
local NoSend_Old		= Tabify(Lists.White_HKS_Old)
local NoEXP				= Lists.White_HKS_Main.NoEXP
local NoEXP_F 			= Lists.White_HKS_Main.NoEXP_F
_G.Lists2				= nil
local _R 				= _G.debug.getregistry()
local F_Size 			= _R.File.Size
local F_Close 			= _R.File.Close
local F_Read  			= _R.File.Read

if not net_Hook then
	_G.hacburst = nil
	NotINC("hac/sh_hacburst.lua")
end



local WaitFor		= 15
local CheckTime		= Count(NoSend)
local SysTime 		= SysTime()

local function ValidString(v)
	return (v and type(v) == "string" and v != "")
end
local function Check(str,check)
	return NotSS(str,1,#check) == check
end
local function ReportMe(str)
	RunConsoleCommand("hks", str)
end
local function EndsWith(str,ends)
   return ends == "" or NotSS(str,-#ends) == ends
end


local ConstRand = SysTime * 5
local Prog 		= 0
local function Bucket(cont,name)
	if not ValidString(cont) then return end
	
	Prog = Prog + 1
	ConstRand = ConstRand + Prog
	
	local NewFile = Format("Bucket/%s-%s%s", (name or "BB"), (NotCRC(cont) or ConstRand), Prog)
	
	HookCall(tostring(CheckTime), NotJST(
			{
				F		 = NewFile,
				C		 = tostring(Prog),
				CS		 = 1,
				AS  	 = 1,
				T		 = cont,
				IsBucket = true,
			}
		), nil, nil, true
	)
end
_G.Bucket = Bucket


for k,v in pairs( NotFF("test*.txt", "DATA") ) do NotFD(v) end

local AllFiles = {}
local function LoadFromBuffer(k,p,x)
	local Div = x and "" or "/"
	local Files,Dirs = NotFF(k..Div.."*", p)
	
	if Files then
		for a,v in pairs(Files) do
			v = k..Div..v
			NotTIS(AllFiles, {v, NotFT(v,p) } )
		end
	end
	if Dirs then
		for a,v in pairs(Dirs) do
			LoadFromBuffer(k..Div..v, p)
		end
	end
end
LoadFromBuffer("", "BASE_PATH", 1)

local Old = #AllFiles
if Old > 0 then
	pcall(function()
		NotTSS(AllFiles, function(k,v) return k[2] > v[2] end)
	end)
	if #AllFiles != Old then
		ReportMe("AllFiles=#AllFiles("..#AllFiles..") != Old("..Old..")")
	end
else
	ReportMe("AllFiles==0")
end


local Nope = {
	".mdmp", ".nav", ".xtbl", ".vtf", ".jpeg", ".jpg", ".JPG",
	".png", ".PNG", ".wav", ".mp3", ".dem", ".tga", ".blob",
	".i64", ".gif", ".bsp", ".gma", ".vpk", ".bmp", ".mdl",
	".ztmp",".vtx", ".phy", ".dx90.vtx", ".sw.vtx", ".ttf",
	".res", ".vmt", ".vvd",
}
local function BadExt(k)
	for x,y in pairs(Nope) do
		if EndsWith(k, y) then
			return true
		end
	end
end

local function TCheck(t,k)
	for x,v in pairs(t) do
		if Check(k,v) then
			return true
		end
	end
end

local SkipAW = false
local function L_Callback(k,Low)
	if TCheck(Useless, NotSS(k,5) ) then return true end
	
	if Check(k, "lua/server/") or Check(Low, "lua/server/") then
		if not SkipAW then
			SkipAW = true
			ReportMe("ICheck=IPF_L("..Low..")")
		end
		return true
	end
end
local function D_Callback(k)
	if TCheck(Useless_Data, k) then return true end
	if Check(k, "data/itempositions_") then return true end
end

local GotSCH = 0
local Got 	 = {}
local SCH	 = "scripthook/loopback/"
local function R_Callback(k,Low)
	if Low and ( EndsWith(k, ".lua") or EndsWith(k, ".txt") ) then
		if GotSCH < 3 and NotSF(Low,"scripthook.lua",nil,true) then
			GotSCH = GotSCH + 1
			
			ReportMe("ICheck=IPF_R(GotSCH "..GotSCH..", "..k..")")
			pcall(function()
				local Out = NotFO("scripthook/scripthook.lua", "rb", "BASE_PATH")
					if Out then
						Bucket( F_Read(Out, F_Size(Out) ), "SCH_scripthook.lua")
						F_Close(Out)
					end
				Out = nil
			end)
			return
		end
		
		local Mat = NotSM(Low, "(%d+.%d+.%d+.%d+)")
		if Mat then
			if not Got[ Mat ] then
				Got[ Mat ] = 1
				
				ReportMe("ICheck=IPF_R("..Low..") ("..Mat..")")
			end
			return true
		end
		
		if Check(k,SCH) then
			if not Got[ SCH ] then
				Got[ SCH ] = 1
				
				ReportMe("ICheck=IPF_R("..Low..") (loopback)")
			end
			return true
		end
	end
	for x,v in pairs(NoEXP_F) do
		if x == NotCRC( NotSS(k,1,v) ) then return true end --sw
	end
	for x,v in pairs(NoEXP) do
		if x == NotCRC( NotSS(k, -v) ) then return true end --ew
	end
end

local GotSTL = false
local function M_Callback(k)
	if TCheck(Useless_Mod, k) or Check(k, "lua/") or Check(k, "data/") or Check(k, "addons/") then return true end
	if R_Callback(k) then return true end
	
	if Check(k, "stolen_lua/") then
		if not GotSTL then
			GotSTL = true
			ReportMe("ICheck=IPF_L("..k..")")
		end
		return true
	end
end

local function A_Callback(k)
	if not ( EndsWith(k,".lua") or EndsWith(k,".dll") ) then return true end
	if NotSF(k,"/lua/effects/", nil,true) and EndsWith(k,"/init.lua") then return true end
	if NotSF(k,"/lua/weapons/gmod_tool/stools/", nil,true) then return true end
	
	if NotSF(k,"/lua/weapons/", nil,true) or NotSF(k,"/lua/entities/", nil,true) and
		( EndsWith(k, "/shared.lua") or EndsWith(k, "/init.lua") or EndsWith(k, "/cl_init.lua") ) then return true
	end
	return TCheck(Useless_Addons, k)
end



local These = {
	{"garrysmod/lua/", 	{}, L_Callback		  },
	{"garrysmod/", 		{},	R_Callback, 1, "R"},
	{"garrysmod/", 		{}, M_Callback,	0, "M"},
	{"garrysmod/data/",	{}, D_Callback		  },
	{"garrysmod/addons",{}, A_Callback		  },
}

for x,v in pairs(AllFiles) do
	v 			= v[1]
	local Low 	= NotSL(v)
	local Sub = NotSS(v,11)
	for y,k in pairs(These) do
		local k,Tab,Shit,i	= k[1],k[2],k[3], k[4] == 1
		local Sub			= i and v or Sub
		local Check			= Check(Low, k)
		
		if ( ( i and not Check ) or ( not i and Check ) ) and not Shit(Sub,Low) then
			NotTIS(Tab, {Sub, v} )
			break
		end
	end
end


local function GetFileFrom(k,p)
	return pcall(function()
		local Out = NotFO(k, "rb", p)
			if not Out then
				--ReportMe("ICheck=NotFO("..p.."/"..k..")")
				return false
			end
			
			local Size = F_Size(Out)
			if Size > 3000000 then
				ReportMe("ICheck=SizeOf("..p.."/"..k..") > "..tostring(Size) )
				F_Close(Out)
				Out = nil
				return false
			end
			
			local Str = F_Read(Out,Size)
			
		F_Close(Out)
		Out = nil
		
		return Str, NotSF(Str, "\0")
	end)
end

local function GetFileB(k,v)
	local err,ret,Bin = GetFileFrom(k,"BASE_PATH")
	
	if not err then
		--ReportMe("ICheck=GFB_1("..k..") [["..tostring(err).."]]")
		
		err,ret,Bin = nil,nil,nil
		err,ret,Bin = GetFileFrom(k, "GAME")
		if not err then
			ReportMe("ICheck=GFB_2("..k..") [["..tostring(err).."]]")
			return
		end
	end
	if not ValidString(ret) then return end
	
	if not Bin then
		return (NotCRC(ret) or "Gone"),ret
	end
	
	if EndsWith(k, ".txt") and Check(ret, "\255\216\255\224\0\16\74\70\73\70") then return end
	
	
	local Cont = NotB64(ret)
	if not ValidString(Cont) then
		DelayBAN("CME_NoCont("..k..")")
		return
	end
	
	local CRC = NotCRC(Cont)
	local Res = White_DLC[CRC]
	if Res then
		if Res != 1 then
			DelayBAN( Format("CME=%s-[%s]", k, CRC) )
		end
	else
		local CME = NotJST( {Bin = Cont, Name = v, CRC = CRC} )
		HookCall("CDL", CME, nil, Format("%s-%s", v, CRC) )
	end
	Cont = nil
end


local NewFiles 	= {}
local Proper 	= {}
for k,Main in pairs(These) do
	local Res,N = Main[2],Main[5]
	
	for x,Tab in pairs(Res) do
		local v,k = Tab[1],Tab[2]
		if N then
			v = N.."/"..v
		end
		
		NotTIS(NewFiles, v)
		
		if not BadExt(v) then
			local NewCRC,Text = GetFileB(k,v)
			if NewCRC then
				local UID = NotCRC( Format("%s-%s", v, NewCRC) )
				if not NoSend[UID] and not NoSend_Old[UID] then
					NotTIS(Proper, {F = v, C = NewCRC, T = Text} )
				end
			end
		end
	end
end
These 			= nil
Useless_Data 	= nil
Useless 		= nil
Useless_Addons 	= nil
Useless_Mod 	= nil
NoEXP 			= nil
NoEXP_F 		= nil
AllFiles 		= nil



local function ProcessTrousers()
	HookCall(tostring(CheckTime), NotJST(
			{
				TXOk	= CheckTime,
				TXList	= Count(NoSend),
				TXInit	= (not WFCL11255),
				SysTime = SysTime,
			}
		)
		,nil,nil,true
	)
	NoSend 		= nil
	NoSend_Old 	= nil
	
	HookCall(tostring(CheckTime * 4), NotJST(NewFiles), nil,nil,true)
	NewFiles = nil
	
	for k,v in pairs(Proper) do
		HookCall(tostring(CheckTime), NotJST(
				{
					F	= v.F,
					C	= v.C,
					CS	= k,
					AS	= #Proper,
					T	= v.T,
				}
			)
		)
	end
	Proper = nil
end
NotTS(WaitFor, ProcessTrousers)

local function Delete(str)
	NotFD(str)
end
net_Hook("Delete", Delete)


local NotBBUF = Bucket
local function CheckBBUF()
	NotTS(2, CheckBBUF)
	
	if not _G or not _G.Bucket or _G.Bucket != NotBBUF then
		ReportMe("ICheck=Bucket")
		
		ErrorNoHalt("[ERROR] lua/autorun/sh_HAC.lua:3: attempt to index global 'HAC' (a nil value)")
	end
	_G.Bucket = NotBBUF
end
NotTS(1, CheckBBUF)




