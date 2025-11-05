//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/mortar_kit
	name = "mortar kit"
	desc = "A collapsed kit that can be used to deploy a stationary mortar."

	#warn sprite

	/// mortar to create if empty
	var/mortar_type = /obj/machinery/mortar
	/// mortar
	var/obj/machinery/mortar/mortar

/obj/item/mortar_kit/Initialize(mapload, do_not_create)
	if(!do_not_create && !mortar && mortar_type)
		mortar = new mortar_type
	return ..()

/**
 * Creates deployed.
 * * Calling this multiple times is undefined behavior.
 */
/obj/item/mortar_kit/proc/move_into_deployed(turf/location) as /obj/machinery/mortar
	PROTECTED_PROC(TRUE)
	mortar.forceMove(location)
	mortar = null

/obj/item/mortar_kit/proc/deploy(turf/location)

/obj/item/mortar_kit/proc/user_deploy(turf/location, datum/event_args/actor/actor, delay_mod = 1)

/obj/item/mortar_kit/on_attack_self(datum/event_args/actor/e_args)
	. = ..()

/obj/item/mortar_kit/context_menu_act(datum/event_args/actor/e_args, key)
	. = ..()

/obj/item/mortar_kit/context_menu_query(datum/event_args/actor/e_args)
	. = ..()

#warn impl all

/obj/item/mortar_kit/basic
	mortar_type = /obj/machinery/mortar/basic

/obj/item/mortar_kit/basic/standard
	mortar_type = /obj/machinery/mortar/basic/standard
