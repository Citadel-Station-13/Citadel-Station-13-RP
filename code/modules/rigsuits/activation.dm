//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/rig/proc/set_activation_state(new_state)
	activation_state = new_state
	if(activation_state & (RIG_ACTIVATION_ACTIVATING | RIG_ACTIVATION_OFFLINE))
		set_weight(offline_weight)
		set_encumbrance(offline_encumbrance)
	else
		set_weight(online_weight)
		set_encumbrance(online_encumbrance)

/obj/item/rig/proc/fully_activated()
	return activation_state == RIG_ACTIVATION_ONLINE

/obj/item/rig/proc/partially_activated()
	return activation_state & RIG_ACTIVATION_IS_CYCLING

/obj/item/rig/proc/startup(datum/event_args/actor/actor, instant, deploy, instant_seal)
	#warn impl


/obj/item/rig/proc/shutdown(datum/event_args/actor/actor, instant)
	for(var/datum/component/rig_piece/piece as anything in piece_components)
		if(!piece.is_deployed())
			continue


	#warn impl


