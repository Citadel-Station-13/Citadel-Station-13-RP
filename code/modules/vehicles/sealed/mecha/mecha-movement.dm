//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/sealed/mecha/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	..()
	if(connected_port && loc != connected_port.loc)
		disconnect()

/obj/vehicle/sealed/mecha/user_vehicle_turn(direction)
	if(world.time < turn_delay)
		return FALSE
	// -- LEGACY BULLSHIT
	if(zoom)
		if(!(world.time % 1 SECONDS))
			occupant_send_default_chat("You cannot turn while zoom-mode is turned on.")
		return FALSE
	// -- END
	return ..()

/obj/vehicle/sealed/mecha/user_vehicle_move(direction, face_direction)
	if(world.time < move_delay)
		return FALSE
	// -- LEGACY BULLSHIT
	if(zoom)
		if(!(world.time % 1 SECONDS))
			occupant_send_default_chat("You cannot move while zoom-mode is turned on.")
		return
	if(connected_port)
		if(!(world.time % 1 SECONDS))
			occupant_send_default_chat("You cannot move while connected to an air port.")
		return
	// -- END
	var/stacks_of_miscalibration = fault_check(/datum/mecha_fault/calibration_lost)
	if(stacks_of_miscalibration)
		if(stacks_of_miscalibration > 15)
			// you dun fucked up
			if(prob(20))
				direction = pick(GLOB.alldirs)
			else if(prob(40))
				direction = turn(direction, pick(90, -90))
			else
				direction = turn(direction, pick(45, -45))
		else if(stacks_of_miscalibration > 5)
			// 18% to 42%
			if(prob(stacks_of_miscalibration * 3))
				if(prob(40))
					direction = turn(direction, pick(90, -90))
				else
					direction = turn(direction, pick(45, -45))
		else
			// 5 to 20 linear
			if(prob(stacks_of_miscalibration * 5))
				direction = turn(direction, pick(45, -45))

	if(strafing)
		face_direction = dir
	else
		// direction controller; we need to be in the dir we're moving if not strafing.
		if(!(dir & direction))
			user_vehicle_turn(ISDIAGONALDIR(direction) ? EWCOMPONENT(direction) : direction)
			// if we're not turned somehow, abort
			if(!(dir & direction))
				return FALSE

	return vehicle_move(direction, face_direction)

/obj/vehicle/sealed/mecha/vehicle_turn(direction)
	if(dir == direction)
		return TRUE
	if(world.time < turn_delay)
		return FALSE
	if(!draw_sourced_power_oneoff("actuators", "actuators", turn_cost_base))
		return FALSE
	. = ..()
	if(!.)
		return
	turn_delay = world.time + turn_delay()
	if(turn_sound)
		playsound(src, turn_sound, 40, TRUE)

#warn strafing / not strafing should be handled in user, vehicle move should move without turning

/obj/vehicle/sealed/mecha/vehicle_move(direction)
	if(world.time < move_delay)
		return FALSE
	if(!draw_sourced_power_oneoff("actuators", "actuators", move_cost_base))
		return FALSE
	// Mechs have a special movement controller.
	if(strafing)
		// Strafing: Usually comes with a move delay but doesn't turn the mech.
		#warn handle strafing
	else if(!(direction & dir))
		// Normal: Turn the mech if we're not travelling vaguely in our dir.
		#warn handle turn
	. = ..()
	if(!.)
		return
	if(move_sound)
		playsound(src, move_sound, 40, TRUE)

#warn strafing should do more delay

/obj/vehicle/sealed/mecha/proc/turn_delay()
	return base_turn_speed

/obj/vehicle/sealed/mecha/movement_delay()
	. = ..()
	if(comp_actuator)
		. *= comp_actuator.base_speed_multiplier

// -- jetpacks need refactored but that's for rigsuit branch -- //

/obj/vehicle/sealed/mecha/process_spacemove(drifting, movement_dir, just_checking)
	. = ..()
	if(.)
		return
	for(var/obj/item/vehicle_module/toggled/lazy/jetpack/jetpack in modules)
		if(jetpack.handle_process_spacemove(drifting, movement_dir, just_checking))
			return TRUE
