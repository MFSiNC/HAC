



for k, v in pairs( file.FindInLua( "../data/advanced_duplicator/*.txt" ) ) do
	file.Delete( "../data/advanced_duplicator/" .. v .. ".txt" )
end
	

	
	