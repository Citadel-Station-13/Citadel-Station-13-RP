//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Checks if an attacking atom is within the defensive arc of a defending atom.
 *
 * * This does not support pixel movement.
 * * A null source is always inside defensive arc.
 *
 * todo: verify behavior.
 *
 * Attacking entity can be:
 *
 * * /obj/projectile - treated as projectile
 * * /datum/thrownthing - treated as thrown
 * * anything else - treated as an /atom-ish source.
 *
 * @params
 * * defending - the defending atom
 * * attacking - the attacking entity
 * * arc - the arc to check
 * * round_up_arc - if the attacking atom is not a projectile or something with angle sim, should we round their defensive angle up or down?
 * * use_dir - use this dir, not the defending atom's dir
 *
 * @return TRUE if they're within arc, FALSE otherwise
 */
/proc/check_defensive_arc_tile(atom/defending, attacking, arc, round_up_arc, use_dir = defending.dir)
	// clockwise from north
	var/our_angle = dir2angle(use_dir)
	// clockwise from north
	var/their_angle
	if(istype(attacking, /obj/projectile))
		// projectile source
		var/obj/projectile/proj = attacking
		// projectile angle var is clockwise from north
		// turn it around to get the angle from our PoV
		their_angle = (proj.angle + 180) % 360
	else
		// atom-ish source
		var/atom/atom_source
		if(istype(attacking, /datum/thrownthing))
			var/datum/thrownthing/thrown = attacking
			atom_source = thrown.thrownthing
		else if(isatom(attacking))
			atom_source = attacking
		else
			return TRUE
		their_angle = dir2angle(get_dir(defending, atom_source))
		// if we're rounding up our arc, we boost our arc since it's an atom source to nearest 45
		if(round_up_arc)
			arc = CEILING(arc, 45)
	// normalize it to +- of our angle
	their_angle -= our_angle
	if(their_angle > 180)
		their_angle -= 360
	return abs(their_angle) <= arc

// todo: pixel movement variant for overmaps and others.
