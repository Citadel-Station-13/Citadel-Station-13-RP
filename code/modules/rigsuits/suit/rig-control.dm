//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/rig/proc/effective_control_flags(mob/user)
	if(is_admin_interactive(user))
		return RIG_CONTROL_FLAGS_ALL
	// todo: rig control system
	return user == wearer? RIG_CONTROL_FLAGS_WEARER : NONE

/obj/item/rig/proc/check_control_flags(mob/user, control_flags)
	return (effective_control_flags(user) & control_flags) == control_flags

/**
 * todo: this is kinda terrible and just a lazy patch rn.
 */
/obj/item/rig/proc/check_control_flags_or_reject(mob/user, control_flags)
	. = check_control_flags(user, control_flags)
	if(!.)
		user.action_feedback(SPAN_WARNING("Insufficient access to perform command."), src)
