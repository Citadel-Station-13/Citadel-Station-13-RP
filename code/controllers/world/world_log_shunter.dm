GLOBAL_REAL(world_log_shunter, /datum/world_log_shunter)
GLOBAL_LREA_VAR(world_log_shunter_active) = FALSE

/datum/world_log_shunter/New()
	world.ensure_logging_active()
