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

/obj/item/rig_module/launcher/grenade/yeet_entity(atom/movable/entity, atom/target, datum/event_args/actor/clickchain/clickchain)
	. = ..()
	if(!.)
		return
	if(!istype(entity, /obj/item/grenade))
		return
	var/obj/item/grenade/yeeted_grenade = entity
	yeeted_grenade.activate_shot_from_generic(src, prime_time, clickchain)

/obj/item/rig_module/launcher/grenade/rig_data()
	. = ..()
	.["primeTime"] = prime_time
	.["primeTimeMin"] = prime_time_min
	.["primeTimeMax"] = prime_time_max

/obj/item/rig_module/launcher/grenade/rig_act(datum/event_args/actor/actor, control_flags, action, list/params)
	. = ..()

/obj/item/rig_module/launcher/grenade/container
	var/capacity = 7
	/// lazy list; set to typepath = amount to preload
	var/list/obj/item/grenade/contained

/obj/item/rig_module/launcher/grenade/container/rig_data()
	. = ..()
	.["capacity"] = capacity

	#warn contained
	.["contained"] = contained

/obj/item/rig_module/launcher/grenade/container/rig_act(datum/event_args/actor/actor, control_flags, action, list/params)
	. = ..()

/obj/item/rig_module/launcher/grenade/container/loaded

/obj/item/rig_module/launcher/grenade/container/loaded/smoke
	contained = list(
		/obj/item/grenade/simple/smoke = 7,
	)

/obj/item/rig_module/launcher/grenade/container/loaded/flashbang
	contained = list(
		/obj/item/grenade/simple/flashbang = 7,
	)

/obj/item/rig_module/launcher/grenade/container/loaded/emp
	contained = list(
		/obj/item/grenade/simple/emp = 7,
	)

/obj/item/rig_module/launcher/grenade/container/loaded/combat
	capacity = 9
	contained = list(
		/obj/item/grenade/simple/flashbang = 3,
		/obj/item/grenade/simple/smoke = 3,
		/obj/item/grenade/simple/emp = 3,
	)
