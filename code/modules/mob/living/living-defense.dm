//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

//* Misc Effects *//

/**
 * Processes a slip.
 *
 * * hard / soft strength are not necessarily directly mapped to stuns
 * * hard / soft strength can do a lot more than stun so don't go overboard
 *
 * @params
 * * slip_class - SLIP_CLASS_* flags of what the slip is
 * * source - a text string, or an atom, of what the source is
 * * hard_strength - nominally the amount of time it'll hardstun someone for; this should be very, very low
 * * soft_strength - nominally how strong the slip should be in terms of stun power. this is, optimally, 0 to 100, with the assumption most people go down at 100
 * * suppressed - suppress outgoing sound and text.
 *
 * @return 0 to 1 for effectiveness, with 0 being 'entirely resisted' and 1 being 'entirely hit'
 */
/mob/living/proc/slip_act(slip_class, source, hard_strength, soft_strength, suppressed)
	return 1
