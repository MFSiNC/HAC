
include("sk_dismay.lua")

local Cont = HAC.file.Read("sv_SkidList.lua")

local All = {}
local Line = 0
for k,v in pairs( Cont:Split("\n") ) do
	if not ValidString(v) then continue end
	Line = Line + 1
	
	local SID = v:upper():match('(STEAM_(%d+):(%d+):(%d+))')
	if not SID then continue end
	if v:find("Dismay (stealing files), ban me",nil,true) then continue end
	
	local Rest = v:Replace('["'..SID..'"] = "', "")
	Rest = Rest:Trim(","):Trim('"')
	
	table.insert(All, {SID = SID, Rest = Rest} )
	--print(SID, Rest)
	--break
	--HAC.file.Append("lol.txt", "\n"..SID.." - "..Rest)
end


for SID,v in pairs(Dismay) do
	table.insert(All, {SID = SID, Rest = "Dismay (stealing files)"} )
end

print("! index: ", #All, Line)



local Done = {}
local Dupe = {}
for k,v in pairs(All) do
	local SID = v.SID
	local Rest = v.Rest
	
	if Done[ SID ] then
		table.insert(Dupe, {SID = SID, Rest = Rest} )
		continue
	end
	Done[ SID ] = Rest
end

print("! dupe: ", #Dupe)


local Same = 0
for k,v in pairs(Dupe) do
	local SID = v.SID
	local Rest = v.Rest
	
	local This = Done[ SID ]
	
	if This:Trim():Trim():Trim(":"):Trim(",") == Rest:Trim():Trim():Trim(":"):Trim(",") then
		Same = Same + 1
		--print("! same: ", This, Rest)
		continue
	end
	
	This = Rest..(This:EndsWith(", ") and "" or ", ")..This
	Done[ SID ] = This
	
	--print(This)
end
print("! Same: ", Same)





for SID,Rest in pairs(Done) do
	local Low = Rest:lower()
	if Low:find("dismay") and not Low:find("ban me") then
		--print("! banme: ", Rest)
		Done[ SID ] = Rest..", ban me"
	end
end


local Names = {}
for k,v in pairs(HAC.Skiddies) do
	
	local Cont = HAC.file.Read("HAC_DB/"..k:SID()..".txt", "DATA")
	if not Cont then continue end
	
	local IDX,Name,Reason = unpack( Cont:Split("\n") )
	
	Name = Name:VerySafe()
	if not ValidString(Name) then
		--print("! no name for ", k, v)
		--HAC.file.Append("sk_name.txt", Format('\n\t["%s"] = "%s",', k, v) )
		Name = v
	end
	
	Names[ k ] = Name
end

local RepNames = 0
for SID,Rest in pairs(Done) do
	local Name = Names[ SID ]
	if not Name then continue end
	
	if Rest:lower():find( Name:lower() ) then continue end
	
	RepNames = RepNames + 1
	Done[ SID ] = Name..", "..Rest
end
print("! Names: ", RepNames)



print("! new tot: ", table.Count(Done) )

for SID,Rest in pairs(Done) do
	HAC.file.Append("sk_all.txt", Format('\n\t["%s"] = "%s",', SID, Rest) )
end














