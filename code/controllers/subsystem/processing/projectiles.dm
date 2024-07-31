PROCESSING_SUBSYSTEM_DEF(projectiles)
	name = "Projectiles"
	wait = 0.25 // scale up to 40 fps
	stat_tag = "PP"
	priority = FIRE_PRIORITY_PROJECTILES
	subsystem_flags = SS_NO_INIT

	/// global projectile speed multiplier
	var/global_projectile_speed_multiplier = 1
