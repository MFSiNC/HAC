

local NotRPF = util.RelativePathToFull
local NotTS	 = timer.Simple
local NotRCC = RunConsoleCommand

NotTS(0, function() NotRCC("_hac_gpath", NotRPF("gameinfo.txt"):lower() ) end)




