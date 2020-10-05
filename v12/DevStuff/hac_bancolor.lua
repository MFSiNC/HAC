

HAC = HAC or {}


HAC.GREEN	= Color( 66, 255, 96 )		--HSP green
HAC.WHITE	= Color( 255, 255, 255 )	--white
HAC.RED		= Color( 255, 0, 11 )		--red
HAC.BLUE	= Color(51, 153, 255, 255)	--HeX Blue
HAC.YELLOW	= Color( 255, 200, 0 )		--yellow
HAC.SGREEN	= Color( 180, 250, 160 )	--source green


concommand.Add("lol1", function()

chat.AddText( HAC.GREEN,"[", HAC.RED,"HAC", HAC.GREEN,"] ", HAC.RED, "Autobanned: ", HAC.BLUE, "-=[UH]=- HeX", HAC.WHITE, " 15 minute ban. Attempted Hack/Blocked command. If this ban is in error, tell HeX (/id/MFSiNC)" )

end)

concommand.Add("lol2", function()


chat.AddText( HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ", "Autobanned: ", HAC.BLUE, "-=[UH]=- HeX", HAC.WHITE, " 15 minute ban. Attempted Hack/Blocked command. If this ban is in error, tell HeX (/id/MFSiNC)" )

end)



