/**
 * checks if characteristics system is enabled
 */
/proc/characteristic_enabled()
	return CONFIG_GET(flag/characteristic_enabled)

/**
 * checks if characteristics system is active
 */
/proc/characteristic_active()
	return CONFIG_GET(flag/characteristic_active)
