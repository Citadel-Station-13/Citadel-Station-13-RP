//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/rig/proc/set_activation_state(new_state)

/obj/item/rig/proc/fully_activated()
	return activation_state == RIG_ACTIVATION_ONLINE

/obj/item/rig/proc/partially_activated()
	return activation_state & RIG_ACTIVATION_IS_CYCLING

/obj/item/rig/proc/startup(datum/event_args/actor/actor, instant, seal, instant_seal)

/obj/item/rig/proc/shutdown(datum/event_args/actor/actor, instant)

#warn impl
