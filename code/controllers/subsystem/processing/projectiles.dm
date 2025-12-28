PROCESSING_SUBSYSTEM_DEF(projectiles)
	name = "Projectiles"
	wait = 0.5
	stat_tag = "PP"
	priority = FIRE_PRIORITY_PROJECTILES
	subsystem_flags = SS_NO_INIT | SS_KEEP_TIMING

	/// global projectile speed multiplier
	var/global_projectile_speed_multiplier = 1
