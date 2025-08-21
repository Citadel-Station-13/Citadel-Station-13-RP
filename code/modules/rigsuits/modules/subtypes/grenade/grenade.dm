//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * launches grenades. really, just a launcher that can prime things.
 * * also contains default bindings for refilling
 */
/obj/item/rig_module/launcher/grenade
	var/prime_time = 3 SECONDS
	var/prime_time_min = 3 SECONDS
	var/prime_time_max = 10 SECONDS

/obj/item/rig_module/launcher/grenade/rig_data()
	. = ..()
	.["primeTime"] = prime_time
	.["primeTimeMin"] = prime_time_min
	.["primeTimeMax"] = prime_time_max

/obj/item/rig_module/launcher/grenade/rig_act(datum/event_args/actor/actor, control_flags, action, list/params)
	. = ..()

/obj/item/rig_module/launcher/grenade/container
	var/capacity = 9
	/// lazy list
	var/list/obj/item/grenade/contained

/obj/item/rig_module/launcher/grenade/container/rig_data()
	. = ..()
	.["capacity"] = capacity

	#warn contained
	.["contained"] = contained

/obj/item/rig_module/launcher/grenade/contained/rig_act(datum/event_args/actor/actor, control_flags, action, list/params)
	. = ..()








