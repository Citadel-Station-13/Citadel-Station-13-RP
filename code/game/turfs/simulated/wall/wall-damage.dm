//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Integrity - Direct Manipulation *//

/turf/simulated/wall/damage_integrity(amount, gradual, do_not_break)
	. = ..()
	// todo: optimize
	update_appearance()

/turf/simulated/wall/heal_integrity(amount, gradual, do_not_fix)
	. = ..()
	// todo: optimize
	update_appearance()
