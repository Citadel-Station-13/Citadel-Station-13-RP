//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/sealed/mecha/user_vehicle_turn(direction)
	return vehicle_turn(direction)

/obj/vehicle/sealed/mecha/user_vehicle_move(direction, face_direction)
	if(strafing)
		face_direction = dir
	else
		// direction controller; we need to be in the dir we're moving if not strafing.
		if(!(dir & direction))
			#warn impl turn
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
