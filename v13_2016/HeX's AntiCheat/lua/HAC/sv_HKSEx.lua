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


HAC.HKSEx = {}


//Check hks.txt file
function HAC.HKSEx.CheckList(ply,cmd,args)
	if not ply:HAC_IsHeX() then return end
	
	local Temp = {}
	for k,v in pairs(HAC.CLIENT.White_HKS) do
		if Temp[v] then
			print("! dupe at: ", k)
		end
		
		Temp[v] = true
	end
	
	if file.Exists("hks.txt", "DATA") then
		print("! Cleared old hks.txt!\n")
		file.Delete("hks.txt")
	end
	
	error("fixme, new list format needed here")
	HAC.file.Append("hks.txt", "\n\n\n_G.White_HKS = {\n\n\n\n\n")
		for k,v in pairs(Temp) do
			HAC.file.Append("hks.txt", Format('\t"%s",\n', k) )
		end
	HAC.file.Append("hks.txt", "}\n\n\n")
end
concommand.Add("hac_checkhks", HAC.HKSEx.CheckList)




//Check folder of .ff files
function HAC.HKSEx.CheckFF(ply,cmd,args)
	if not ply:HAC_IsHeX() then return end
	
	//Read all
	local Files,Folders = file.Find("ff/*.txt", "DATA")
	if #Files == 0 then
		ply:print("! CheckFF: No /ff folder!")
		return
	end
	
	local All = ""
	for k,v in pairs(Files) do
		local Cont = HAC.file.Read("ff/"..v, "DATA")
		if not ValidString(Cont) then continue end
		
		All = All.."\n"..Cont
	end
	if not ValidString(All) then
		ply:print("! CheckFF: No files read!")
		return
	end
	
	//Split into table
	local AllTab = {}
	for k,v in pairs( All:Split("\t") ) do
		if not ValidString(v) then continue end
		v = v:gsub("\r", "")
		v = v:gsub("\n", "")
		v = v:gsub("\t", "")
		v = v:gsub(",", "")
		v = v:gsub('"', "")
		
		if #v > 4 and not AllTab[v] then
			AllTab[v] = true
		end
	end
	
	//Make file
	if file.Exists("ff_hks.txt", "DATA") then
		print("! Cleared old ff_hks.txt!\n")
		file.Delete("ff_hks.txt")
	end
	
	//Get table of old ones
	local AllOld = {}
	for k,v in pairs(HAC.CLIENT.White_HKS) do
		if not AllOld[v] then
			AllOld[v] = true
		end
	end
	
	//Write new
	local New = 0
	for k,v in pairs(AllTab) do
		if not AllOld[k] then
			if not ValidString(k) then continue end
			
			New = New + 1
			HAC.file.Append("ff_hks.txt", Format('\n\t"%s",', k) )
		end
	end
	
	local All = table.Count(AllTab)
	print("! Written "..New.." new entries, skipped "..(New - All).." out of "..All.." total in /ff")
end
concommand.Add("ff", HAC.HKSEx.CheckFF)


















