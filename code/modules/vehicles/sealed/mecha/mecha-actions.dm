//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/action/vehicle/mecha
	target_type = /obj/vehicle/sealed/mecha
	background_icon_state = "mecha"
	button_icon = 'icons/screen/actions/mecha.dmi'

/datum/action/vehicle/mecha/eject
	name = "Eject"
	desc = "Eject from your mecha."
	button_icon_state = "eject"

	required_control_flags = VEHICLE_CONTROL_EXIT
	ask_confirm = TRUE

/datum/action/vehicle/mecha/eject/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.mob_try_exit(actor.performer, actor)

/datum/action/vehicle/mecha/strafing
	name = "Toggle Strafing"
	desc = "Toggle strafing movement on/off."
	button_icon_state = "strafing"
	#warn iconstate

/datum/action/vehicle/mecha/strafing/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.user_set_strafing(actor, !target.strafing)

/datum/action/vehicle/mecha/floodlight
	name = "Toggle Floodlights"
	desc = "Toggle floodlights on/off."
	button_icon_state = "floodlights"
	#warn iconstate

/datum/action/vehicle/mecha/floodlight/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.user_set_floodlights(actor, !target.floodlight_active)

/datum/action/vehicle/mecha/toggle_internals
	name = "Toggle Internals"
	desc = "Toggle cabin air supply between environmental and our internal tank."
	button_icon_state = "internals"
	#warn iconstate

/datum/action/vehicle/mecha/toggle_internals/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

#warn impl

//* legacy crap *//

// these are less 'shouldn't be buttons' and more 'the design conflicts with my worldview of how the game should be',
// thus they get kicked into that

/datum/action/vehicle/mecha/legacy

/datum/action/vehicle/mecha/legacy/phasing
	name = "Toggle Phasing"
	desc = "Toggle phasing, if your mech supports it"
	button_icon_state = "phasing"
	#warn iconstate

/datum/action/vehicle/mecha/legacy/phasing/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

/datum/action/vehicle/mecha/legacy/zoom
	name = "Toggle Zoom"
	desc = "Toggle zoom mode, if your mech supports it"
	button_icon_state = "zoom"
	#warn iconstate

/datum/action/vehicle/mecha/legacy/zoom/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

#warn impl all

