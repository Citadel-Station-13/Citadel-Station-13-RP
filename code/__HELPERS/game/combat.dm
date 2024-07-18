//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Checks if an attacking atom is within the defensive arc of a defending atom.
 *
 * This does not support pixel movement.
 *
 * @params
 * * defending - the defending atom
 * * attacking - the attacking atom
 * * arc - the arc to check
 * * round_up_arc - if the attacking atom is not a projectile or something with angle sim, should we round their defensive angle up or down?
 *
 * @return TRUE if they're within arc, FALSE otherwise
 */
/proc/check_defensive_arc_tile(atom/defending, atom/attacking, arc, round_up_arc)
#warn impl

// todo: pixel movement variant for overmaps and others.
