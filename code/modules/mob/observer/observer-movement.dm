//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/observer/process_spacemove(drifting, movement_dir, just_checking)
	return TRUE

/mob/observer/canface()
	return TRUE

/mob/observer/can_overcome_gravity()
	return TRUE

/mob/observer/CanAllowThrough(atom/movable/mover, turf/target)
	return TRUE
