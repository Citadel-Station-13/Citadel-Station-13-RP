//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/mortar_kit
	name = "mortar kit"
	desc = "A collapsed kit that can be used to deploy a stationary mortar."
	icon = 'icons/modules/sectors/air_support/mortar'
	icon_state = "mortar-jungle"
	base_icon_state = "mortar-jungle"

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
	if(!mortar)
		return FALSE
	if(!istype(location))
		return FALSE
	move_into_deployed(location)
	qdel(src)
	return TRUE

/obj/item/mortar_kit/update_icon()
	if(mortar)
		icon_state = mortar.icon_state
	return ..()

/obj/item/mortar_kit/proc/user_deploy(turf/location, datum/event_args/actor/actor, delay_mod = 1)
	if(!istype(location))
		return FALSE
	var/delay = mortar.deploy_time * delay_mod
	if(delay > 0)
		if(delay > 0.5 SECONDS)
			actor.visible_feedback(
				target = src,
				range = MESSAGE_RANGE_CONSTRUCTION,
				visible = SPAN_WARNING("[actor.performer] starts deploying [mortar]..."),
				audible = SPAN_WARNING("You hear heavy machinery being unpacked."),
				otherwise_self = SPAN_WARNING("You start deploying [mortar]!"),
			)
		if(!do_after(actor.performer, delay, src))
			return FALSE
	actor.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = SPAN_WARNING("[actor.performer] deploys [mortar]!"),
		audible = SPAN_WARNING("You hear heavy machinery being deployed."),
		otherwise_self = SPAN_WARNING("You deploy [mortar]!"),
	)
	deploy(location)
	return TRUE

/obj/item/mortar_kit/on_attack_self(datum/event_args/actor/actor)
	user_deploy(get_turf(src), actor)
	return TRUE

/obj/item/mortar_kit/context_menu_act(datum/event_args/actor/actor, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("deploy")
			user_deploy(actor)
			return TRUE

/obj/item/mortar_kit/context_menu_query(datum/event_args/actor/actor)
	. = ..()
	.["deploy"] = create_context_menu_tuple("Deploy", mortar || src, 1, MOBILITY_CAN_USE, FALSE)

/obj/item/mortar_kit/basic
	mortar_type = /obj/machinery/mortar/basic

/obj/item/mortar_kit/basic/standard
	mortar_type = /obj/machinery/mortar/basic/standard
