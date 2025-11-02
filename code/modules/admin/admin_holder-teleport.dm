//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/admins/proc/teleport_as_ghost_to_loc(turf/where, log_reason)
	// this is a helper that should only be called by code!
	if(IsAdminAdvancedProcCall())
		return
	if(!istype(where))
		CRASH("invalid input turf; input must be a turf")
	var/turf/prior = get_turf(owner.mob)
	if(!istype(owner.mob, /mob/observer/dead))
		admin_ghost()
	if(!istype(owner.mob, /mob/observer/dead))
		stack_trace("failed to ghostize an admin while they were jumping.")
		to_chat(owner, SPAN_BOLDANNOUNCE("ADMIN: Failed to ghostize while jumping as ghost as non-ghost. Please report this to coders."))
		return FALSE
	var/mob/observer/dead/ghost = owner.mob
	log_admin("[key_name(owner)] jumped from [COORD(prior)] to [COORD(where)]")
	ghost.forceMove(where)
	return TRUE
