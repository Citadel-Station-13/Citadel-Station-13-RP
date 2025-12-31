//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// todo: support for innate controlled actions? for stuff like mind-linked vehicles and whatnot instead of piloted..
/datum/action/vehicle
	target_type = /obj/vehicle
	check_mobility_flags = MOBILITY_CAN_USE
	button_icon = 'icons/screen/actions/vehicles.dmi'
	button_icon_state = "eject"
	#warn iconstate; render the vehicle please

	/// required control flags
	var/required_control_flags = NONE

/datum/action/vehicle/invoke_target(obj/vehicle/target, datum/event_args/actor/actor)
	return ..()

/datum/action/vehicle/control_panel
	name = "Open Control Panel"
	desc = "Open the vehicle's control panel."
	button_icon_state = "panel"
	#warn iconstate

/datum/action/vehicle/control_panel/invoke_target(obj/vehicle/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.get_ui_controller()?.ui_interact(actor.performer)

/datum/action/vehicle/cycle_active_module
	name = "Cycle Active Module"
	desc = "Cycle which module receives mouse clicks."

/datum/action/vehicle/cycle_active_module/invoke_target(obj/vehicle/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	#warn impl

//* Sealed *//

/datum/action/vehicle/sealed
	target_type = /obj/vehicle/sealed

/datum/action/vehicle/sealed/climb_out
	name = "Climb Out"
	desc = "Climb out of your vehicle!"
	button_icon_state = "eject"

	required_control_flags = VEHICLE_CONTROL_EXIT

/datum/action/vehicle/sealed/climb_out/invoke_target(obj/vehicle/sealed/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.mob_try_exit(actor.performer, actor)

/datum/action/vehicle/sealed/remove_key
	name = "Remove key"
	desc = "Take your key out of the vehicle's ignition"
	button_icon_state = "remove_key"

/datum/action/vehicle/sealed/remove_key/invoke_target(obj/vehicle/sealed/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.remove_key(actor.performer)
