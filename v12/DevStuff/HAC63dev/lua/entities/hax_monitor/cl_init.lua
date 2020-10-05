include("shared.lua")

language.Add( "hax_monitor", "HAAAX!" )
killicon.AddFont("hax_monitor", "HL2MPTypeDeath", "9", Color( 255, 80, 0, 255 ))


function ENT:Draw()
	self.Entity:DrawModel()
end