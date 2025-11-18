/**
 * Fires 20 times a second. Kind of on the nose, huh?
 */
PROCESSING_SUBSYSTEM_DEF(process_20fps)
	name = "Processing - 20 fps"
	wait = (1 / 20) SECONDS
	stat_tag = "P20"
