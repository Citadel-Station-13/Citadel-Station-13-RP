//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// todo: support for innate controlled actions? for stuff like mind-linked vehicles and whatnot instead of piloted..
/datum/action/vehicle
	check_mobility_flags = MOBILITY_CAN_USE
	button_icon = 'icons/screen/actions/vehicles.dmi'
	button_icon_state = "vehicle_eject"

	/// required control flags
	var/required_control_flags = NONE

/datum/action/vehicle/sealed
	target_type = /obj/vehicle/sealed

/datum/action/vehicle/sealed/climb_out
	name = "Climb Out"
	desc = "Climb out of your vehicle!"
	button_icon_state = "car_eject"

	required_control_flags = VEHICLE_CONTROL_EXIT

/datum/action/vehicle/sealed/climb_out/invoke_target(obj/vehicle/sealed/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.mob_try_exit(actor.performer, actor)

/datum/action/vehicle/sealed/remove_key
	name = "Remove key"
	desc = "Take your key out of the vehicle's ignition"
	button_icon_state = "car_removekey"

/datum/action/vehicle/sealed/remove_key/invoke_target(obj/vehicle/sealed/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.remove_key(actor.performer)
