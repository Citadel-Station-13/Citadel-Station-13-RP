/datum/controller
	var/name
	// The object used for the clickable stat() button.
	var/obj/effect/statclick/statclick
	/// debug/verbose logging?
	var/verbose_logging = FALSE

/datum/controller/proc/Initialize()

//cleanup actions
/datum/controller/proc/Shutdown()

//when we enter dmm_suite.load_map
/datum/controller/proc/StartLoadingMap()

//when we exit dmm_suite.load_map
/datum/controller/proc/StopLoadingMap()

/datum/controller/proc/Recover()

/datum/controller/proc/stat_entry()
