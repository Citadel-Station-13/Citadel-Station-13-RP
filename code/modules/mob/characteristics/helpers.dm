/**
 * checks if characteristics system is enabled
 */
/proc/characteristics_enabled()
	return CONFIG_GET(flag/characteristics_enabled)

/**
 * checks if characteristics system is active
 */
/proc/characteristics_active()
	return CONFIG_GET(flag/characteristics_active)
