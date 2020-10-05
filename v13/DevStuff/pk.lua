



local cont = file.Read("pk1.txt")

--done
--local cont = file.Read("pk2.txt")


local tab = {}

for k,v in pairs( cont:Split(",") ) do
	v = v:Trim("{")
	v = v:Trim("}")
	
	local SID = v:Split('":"')[1]
	SID = SID:Trim('"')
	
	SID = SID:Split('"')[1]
	
	print(SID)
	HAC.Skid.Add("sk_temp.txt", SID, "Propkiller")
end









