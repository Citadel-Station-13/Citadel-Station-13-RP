//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

// doMove hook to ensure proper functionality when inv procs aren't called
/obj/item/doMove(atom/destination)
	if(worn_slot && !worn_hook_suppressed)
		// inventory handling
		if(destination == worn_inside)
			return ..()
		var/mob/M = worn_mob()
		if(!ismob(M))
			worn_slot = null
			worn_hook_suppressed = FALSE
			stack_trace("item forcemove inv hook called without a mob as loc??")
		M.temporarily_remove_from_inventory(src, INV_OP_FORCE)
	return ..()

// todo: this is fucking awful
/obj/item/Move(atom/newloc, direct, glide_size_override)
	if(!worn_slot)
		return ..()
	var/mob/M = worn_mob()
	if(istype(M))
		M.temporarily_remove_from_inventory(src, INV_OP_FORCE)
	else
		stack_trace("item Move inv hook called without a mob as loc??")
		worn_slot = null
	. = ..()
	if(!. || (loc == M))
		// kick them out
		forceMove(M.drop_location())
