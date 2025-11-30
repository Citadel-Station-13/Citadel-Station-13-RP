//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/sealed/mecha/user_vehicle_turn(direction)
	// -- LEGACY BULLSHIT
	if(zoom)
		if(!(world.time % 1 SECONDS))
			occupant_send_default_chat("You cannot turn while zoom-mode is turned on.")
		return FALSE
	// -- END

	if(!draw_sourced_power_oneoff("actuators", "actuators", turn_cost_base))
		return FALSE

	return vehicle_turn(direction)

/obj/vehicle/sealed/mecha/user_vehicle_move(direction, face_direction)
	// -- LEGACY BULLSHIT
	if(zoom)
		if(!(world.time % 1 SECONDS))
			occupant_send_default_chat("You cannot move while zoom-mode is turned on.")
		return
	// -- END

	if(!draw_sourced_power_oneoff("actuators", "actuators", move_cost_base))
		return FALSE

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
	. = ..()
	if(!.)
		return
	if(turn_sound)
		playsound(src, turn_sound, 40, TRUE)

/obj/vehicle/sealed/mecha/vehicle_move(direction)
	. = ..()
	if(!.)
		return
	if(move_sound)
		playsound(src, move_sound, 40, TRUE)

#warn strafing should do more delay
