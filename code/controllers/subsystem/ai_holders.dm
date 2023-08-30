//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Handles ticking AI holders
 */
/datum/controller/subsystem/ai_holders
	name = "AI Holders"

	/// all ticking ai holders
	var/static/list/datum/ai_holder/active_holders
	/// rolling bucket list; these hold the head node of linked ai_holders.
	var/tmp/list/buckets

/datum/controller/subsystem/ai_holders/PreInit(recovering)
	. = ..()
	buckets = new /list(SLOWEST_AI_HOLDER_TICK * world.fps)

/datum/controller/subsystem/ai_holders/on_ticklag_changed(old_ticklag, new_ticklag)
	rebuild()

/datum/controller/subsystem/ai_holders/fire(resumed)
	. = ..()
	#warn impl

/datum/controller/subsystem/ai_holders/Recover()
	. = ..()
	rebuild()

/**
 * perform error checking
 * rebuild all buckets
 */
/datum/controller/subsystem/ai_holders/proc/rebuild()
	#warn impl


#warn impl all
