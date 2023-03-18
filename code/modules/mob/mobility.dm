//! Mobility: The ability of mobs to perform actions.
//? We primarily use flags and a proc to differentiate this
//? However, the eventual transition to traits will be done at some point.
//? Thus, all mobility flags (at the least; more than 24 are technically possible with lists)
//? should have associated traits
//? For speed, however, mobility_flags will always be maintained and updated as needed,
//? as bitfield operations are far faster than lists.

/**
 * Notable exceptions to the mobility system includes:
 * - position (old: resting): often update as a result of mobility, and therefore is read only.
 * - lying: angular turn of a mob. read only for the same reasons.
 * - stat: This is part of the health system. NOT the mobility system. Health statuses like
 * 		being dead (duh) can impact mobility, not the other way around.
 */

// todo: mobility system

// for now, just dumb wrappers



/// Updates canmove, lying and icons. Could perhaps do with a rename but I can't think of anything to describe it.
/mob/proc/update_canmove()
	return canmove

