//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/shuttle_transit_blocker
	/**
	 * The hook blocking the transit, if any
	 */
	var/datum/shuttle_hook/hook
	/**
	 * The transit stage being stage
	 */
	var/datum/shuttle_transit_stage/stage

	/// May be forced
	var/forceable = FALSE
	/// Forcing this may be dangerous
	var/forcing_could_be_dangerous = FALSE

	var/desc = "Unknown Blocker"

/datum/shuttle_transit_blocker/New(datum/shuttle_hook/hook, datum/shuttle_transit_stage/stage, desc)
	. = ..()
	src.hook = hook
	src.stage = stage
	src.desc = desc
	LAZYADD(stage.blockers, src)
	LAZYADD(hook.blocking, src)

/datum/shuttle_transit_blocker/Destroy()
	hook = null
	stage = null
	LAZYREMOVE(stage.blockers, src)
	LAZYREMOVE(hook.blocking, src)
	return ..()

/**
 * @return string
 */
/datum/shuttle_transit_blocker/proc/ui_why()
	return desc

/datum/shuttle_transit_blocker/mandatory
	forceable = FALSE

/datum/shuttle_transit_blocker/advisory
	forceable = TRUE

/datum/shuttle_transit_blocker/safety
	forceable = TRUE
	forcing_could_be_dangerous = TRUE
