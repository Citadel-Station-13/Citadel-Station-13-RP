/datum/controller
	/**
	 * Stub for subsystem names.
	 */
	var/name

	/**
	 * The object used for the clickable stat() button.
	 */
	var/obj/effect/statclick/statclick

	/**
	 * debug/verbose logging?
	 */
	var/verbose_logging = FALSE


/datum/controller/proc/Initialize()
	return


/**
 * Cleanup actions.
 */
/datum/controller/proc/Shutdown()
	return


/**
 * When we enter dmm_suite.load_map
 */
/datum/controller/proc/StartLoadingMap()
	return


/**
 * When we exit dmm_suite.load_map
 */
/datum/controller/proc/StopLoadingMap()
	return


/datum/controller/proc/Recover()
	return


/datum/controller/proc/stat_key()
	return "[name]:"


/datum/controller/proc/stat_entry()
	return "\[DEBUG\]"


/datum/controller/statpanel_click(client/C, action)
	C.debug_variables(src)
	message_admins("Admin [key_name_admin(C)] is debugging the [name] controller.")
