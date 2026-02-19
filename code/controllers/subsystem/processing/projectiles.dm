/**
 * A very fast-ticking subsystem that runs projectiles.
 */
PROCESSING_SUBSYSTEM_DEF(projectiles)
	name = "Projectiles"
	wait = (1 / 20) SECONDS
	stat_tag = "P_PROJ"
	priority = FIRE_PRIORITY_PROJECTILES
	subsystem_flags = SS_NO_INIT | SS_KEEP_TIMING

	/// global projectile speed multiplier
	var/global_projectile_speed_multiplier = 1
