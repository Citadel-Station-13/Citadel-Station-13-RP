/**
 * Supertype of global singletons used to organize game systems.
 *
 * * Do not delete any global singletons in Destroy(); use Recover() to inherit them, and rebuild if necessary.
 * * Destroy() should only terminate state that should not be kept across a hard reload of a controller, such as current tick usage/queue priorities/whatnot.
 */
/datum/controller
	/// Stub for subsystem names.
	var/name

	/// The object used for the clickable stat() button.
	var/obj/effect/statclick/statclick

	/// debug/verbose logging?
	var/verbose_logging = FALSE


/datum/controller/proc/Initialize()
	return


/// Cleanup actions.
/datum/controller/proc/Shutdown()
	return


/**
 * called before we start loading a parsed map
 *
 * this can delay the loading process. this is **NOT** the denotation of starting a *semantic*
 * map loading process - loading a single planet can call this dozens of times, as each
 * submap is itself considered a mapload!
 */
/datum/controller/proc/StartLoadingMap()
	return

/**
 * called after we stop loading a parsed map
 *
 * this can delay the loading process. this is **NOT** the denotation of stopping a *semantic*
 * map loading process - loading a single planet can call this dozens of times, as each
 * submap is itself considered a mapload!
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
