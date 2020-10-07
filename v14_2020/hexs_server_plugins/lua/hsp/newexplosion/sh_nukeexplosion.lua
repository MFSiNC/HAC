
----------------------------------------
--         2014-07-12 20:32:48          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	sh_NukeExplosion, v1.0

	Nice particle boom for the nuke!

]]



game.AddParticles("particles/nuke.pcf")



local Particles = {

	"cloud_rings",

	

	"dustwave_tracer",

	

	"glow_blast_b",

	"glow_flare",

	"glow_flare_b",

	"glow_ground",

	"glow_main",

	"glow_main_b",

	

	"ripplewave",

	"ripplewave_b",

}

for k,v in pairs(Particles) do

	PrecacheParticleSystem(v)

end







if SERVER then

	resource.AddFile("particles/nuke.pcf")

	

	function HSP.Nuke_DoExplodeEffect(self)

		if self.DoExplodeEffect then return end

		self.DoExplodeEffect = true

		

		local Pos = self:LocalToWorld( self:OBBCenter() )

		

		for k,v in ipairs(Particles) do

			ParticleEffect(v, Pos, angle_zero, nil)

		end

	end

end







--[[

--error

"door_explosion_core",

"dustwave",

"smoke_cloud",

"glow_blast",

"dust_blast_dust",

"nuke",

"nuke_explosion",

"nuke_shockwave_b",

"nuke_shockwave_c",



--useless

"dust_blast",



--too high

"fireball",

"fireball_b",



--too big

"flame_column",

]]












