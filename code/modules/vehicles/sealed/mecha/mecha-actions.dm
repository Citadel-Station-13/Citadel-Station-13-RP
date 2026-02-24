//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/action/vehicle/mecha
	target_type = /obj/vehicle/sealed/mecha
	background_icon_state = "tech_green"
	button_icon = 'icons/screen/actions/mecha.dmi'

/datum/action/vehicle/mecha/strafing
	name = "Toggle Strafing"
	desc = "Toggle strafing movement on/off."
	button_icon_state = "strafing"

/datum/action/vehicle/mecha/strafing/pre_render_hook()
	..()
	var/obj/vehicle/sealed/mecha/casted_target = target
	set_button_active(casted_target.strafing, TRUE)

/datum/action/vehicle/mecha/strafing/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.user_set_strafing(actor, !target.strafing)

/datum/action/vehicle/mecha/floodlight
	name = "Toggle Floodlights"
	desc = "Toggle floodlights on/off."
	button_icon_state = "floodlights"

/datum/action/vehicle/mecha/floodlight/pre_render_hook()
	..()
	var/obj/vehicle/sealed/mecha/casted_target = target
	set_button_active(casted_target.floodlight_active, TRUE)

/datum/action/vehicle/mecha/floodlight/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.user_set_floodlights(actor, !target.floodlight_active)

/datum/action/vehicle/mecha/toggle_internals
	name = "Toggle Internals"
	desc = "Toggle cabin air supply between environmental and our internal tank."
	button_icon_state = "internals"

/datum/action/vehicle/mecha/toggle_internals/pre_render_hook()
	..()
	var/obj/vehicle/sealed/mecha/casted_target = target
	set_button_active(casted_target.use_internal_tank, TRUE)

/datum/action/vehicle/mecha/toggle_internals/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.internal_tank()
	update_buttons()
	return TRUE

//* legacy crap *//

// these are less 'shouldn't be buttons' and more 'the design conflicts with my worldview of how the game should be',
// thus they get kicked into that

/datum/action/vehicle/mecha/legacy

/datum/action/vehicle/mecha/legacy/phasing
	name = "Toggle Phasing"
	desc = "Toggle phasing, if your mech supports it"
	button_icon_state = "phasing"
	button_active_background_overlay = "tech_green_on_blue"

/datum/action/vehicle/mecha/legacy/phasing/pre_render_hook()
	..()
	var/obj/vehicle/sealed/mecha/casted_target = target
	set_button_active(casted_target.phasing, TRUE)

/datum/action/vehicle/mecha/legacy/phasing/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.phasing()
	update_buttons()
	return TRUE

/datum/action/vehicle/mecha/legacy/zoom
	name = "Toggle Zoom"
	desc = "Toggle zoom mode, if your mech supports it"
	button_icon_state = "zoom"
	button_active_background_overlay = "tech_green_on_red"

/datum/action/vehicle/mecha/legacy/zoom/pre_render_hook()
	..()
	var/obj/vehicle/sealed/mecha/casted_target = target
	set_button_active(casted_target.zoom, TRUE)

/datum/action/vehicle/mecha/legacy/zoom/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.zoom()
	update_buttons()
	return TRUE
