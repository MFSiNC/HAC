


--local Out = file.Open("lua/bin/gmsv_hsp_win32.dll", "rb", "GAME")
local Out = file.Open("poo.dll", "rb", "DATA")
	local Size 	= Out:Size()
	local Raw	= Out:Read(Size)
Out:Close()

print("orig: ", Size)



local NewDLL = Format("%q", Raw):lower()


print("! NewDLL: ", #NewDLL)
file.Write("NewDLL.txt", NewDLL)


for k,v in pairs(HAC.SERVER.DLCBlacklist) do
	if NewDLL:find(v, nil,true) then
		IsBad = "BAD"
		local What = Format("DLCW=%s (%s)", UID, v)
		
		print(What)
	end
end



print("\n", #NewDLL == Size)





--[[
local ThisDLL = ""
for i=0,#Raw do
	local char = Raw:sub(i,i)
	
	if char and char != "\0" then
		ThisDLL = ThisDLL..char
	end
end
ThisDLL = ThisDLL:lower()

print("! ThisDLL: ", #ThisDLL)
file.Write("ThisDLL.txt", ThisDLL)

]]









