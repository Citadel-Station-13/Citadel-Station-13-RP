//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/silicon/robot/silicon_control_interaction_allowed(atom/target, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	// sigh. rework bolts when?
	if(bolt && !bolt.malfunction)
		#warn feedback
		return FALSE
	return TRUE
