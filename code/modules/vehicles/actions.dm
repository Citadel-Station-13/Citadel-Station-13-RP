// todo: rework everything, new actions are multi-owner!

//VEHICLE DEFAULT HANDLING
/obj/vehicle/proc/generate_actions()
	return

/obj/vehicle/proc/generate_action_type(actiontype)
	var/datum/action/vehicle/A = new actiontype(src)
	if(!istype(A))
		return
	// A.vehicle_target = src
	// don't need the above; targets are set per type.
	return A

/obj/vehicle/proc/initialize_passenger_action_type(actiontype)
	autogrant_actions_passenger += actiontype
	for(var/i in occupants)
		grant_passenger_actions(i)	//refresh

/obj/vehicle/proc/initialize_controller_action_type(actiontype, control_flag)
	LAZYINITLIST(autogrant_actions_controller["[control_flag]"])
	autogrant_actions_controller["[control_flag]"] += actiontype
	for(var/i in occupants)
		grant_controller_actions(i)	//refresh

/obj/vehicle/proc/grant_action_type_to_mob(actiontype, mob/m)
	if(isnull(occupants[m]) || !actiontype)
		return FALSE
	LAZYINITLIST(occupant_actions_legacy[m])
	if(occupant_actions_legacy[m][actiontype])
		return TRUE
	var/datum/action/action = generate_action_type(actiontype)
	action.grant(m.actions_controlled)
	occupant_actions_legacy[m][action.type] = action
	return TRUE

/obj/vehicle/proc/remove_action_type_from_mob(actiontype, mob/m)
	if(isnull(occupants[m]) || !actiontype)
		return FALSE
	LAZYINITLIST(occupant_actions_legacy[m])
	if(occupant_actions_legacy[m][actiontype])
		var/datum/action/action = occupant_actions_legacy[m][actiontype]
		action.revoke(m.actions_controlled)
		occupant_actions_legacy[m] -= actiontype
	return TRUE

/obj/vehicle/proc/grant_passenger_actions(mob/M)
	for(var/v in autogrant_actions_passenger)
		grant_action_type_to_mob(v, M)

/obj/vehicle/proc/remove_passenger_actions(mob/M)
	for(var/v in autogrant_actions_passenger)
		remove_action_type_from_mob(v, M)

/obj/vehicle/proc/grant_controller_actions(mob/M)
	if(!istype(M) || isnull(occupants[M]))
		return FALSE
	for(var/i in GLOB.bitflags)
		if(occupants[M] & i)
			grant_controller_actions_by_flag(M, i)
	return TRUE

/obj/vehicle/proc/remove_controller_actions(mob/M)
	if(!istype(M) || isnull(occupants[M]))
		return FALSE
	for(var/i in GLOB.bitflags)
		remove_controller_actions_by_flag(M, i)
	return TRUE

/obj/vehicle/proc/grant_controller_actions_by_flag(mob/M, flag)
	if(!istype(M))
		return FALSE
	for(var/v in autogrant_actions_controller["[flag]"])
		grant_action_type_to_mob(v, M)
	return TRUE

/obj/vehicle/proc/remove_controller_actions_by_flag(mob/M, flag)
	if(!istype(M))
		return FALSE
	for(var/v in autogrant_actions_controller["[flag]"])
		remove_action_type_from_mob(v, M)
	return TRUE

/obj/vehicle/proc/cleanup_actions_for_mob(mob/M)
	if(!istype(M))
		return FALSE
	for(var/path in occupant_actions_legacy[M])
		stack_trace("Leftover action type [path] in vehicle type [type] for mob type [M.type] - THIS SHOULD NOT BE HAPPENING!")
		var/datum/action/action = occupant_actions_legacy[M][path]
		action.revoke(M.actions_controlled)
		occupant_actions_legacy[M] -= path
	occupant_actions_legacy -= M
	return TRUE

//ACTION DATUMS

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
