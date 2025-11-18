/**
 * Fires 5 times a second. Kind of on the nose, huh?
 */
PROCESSING_SUBSYSTEM_DEF(process_5fps)
	name = "Processing - 5 FPS"
	wait = (1 / 5) SECONDS
	stat_tag = "P5"
