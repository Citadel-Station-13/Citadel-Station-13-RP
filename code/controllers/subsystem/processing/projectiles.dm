PROCESSING_SUBSYSTEM_DEF(projectiles)
	name = "Projectiles"
	wait = 0.5 // scale up to 20 fps, but not beyond. normal projectiles do not need that sort of resolution
	stat_tag = "PP"
	priority = FIRE_PRIORITY_PROJECTILES
	subsystem_flags = SS_NO_INIT

	/// global projectile speed multiplier
	var/global_speed_multiplier = 1
