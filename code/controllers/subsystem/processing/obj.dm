/**
 * General object processing subsystem. Fires once per 2 seconds.
 */
PROCESSING_SUBSYSTEM_DEF(obj)
	name = "Objects"
	priority = FIRE_PRIORITY_OBJ
	subsystem_flags = SS_NO_INIT
	wait = 2 SECONDS
	stat_tag = "P_OBJ"
