//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/action/vehicle/mecha
	target_type = /obj/vehicle/sealed/mecha
	background_icon_state = "mecha"
	button_icon = 'icons/screen/actions/mecha.dmi'

	required_control_flags = NONE

/datum/action/vehicle/mecha/eject
	name = "Eject"
	desc = "Eject from your mecha."
	button_icon_state = "eject"

	required_control_flags = VEHICLE_CONTROL_EXIT

/datum/action/vehicle/mecha/eject/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.mob_try_exit(actor.performer, actor)
