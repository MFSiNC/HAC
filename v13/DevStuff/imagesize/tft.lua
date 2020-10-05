


include("sv_ImageSize.lua")



local Out = file.Open("shit.jpg", "rb", "DATA")
	local Raw = Out:Read( Out:Size() )
Out:Close()


local x,y = imagesize.FromJPEG(Raw)

print("! x,y: ", x,y)










