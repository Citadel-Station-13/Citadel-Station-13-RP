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

/**
 * updates mobility flags
 *
 * @params
 * * blocked - what to deny
 * * forced - what to always allow. overrides blocked.
 *
 * @return new mobility flags
 */
/mob/proc/update_mobility(blocked, forced)
	if(transforming)
		. = mobility_flags = NONE
		SEND_SIGNAL(src, COMSIG_MOB_ON_UPDATE_MOBILITY, .)
		return
	. = MOBILITY_FLAGS_DEFAULT
	if(!IS_CONSCIOUS(src))
		. &= ~MOBILITY_IS_CONSCIOUS
	if(is_paralyzed())
		. &= ~(MOBILITY_CAN_MOVE | MOBILITY_CAN_USE | MOBILITY_CAN_PICKUP | MOBILITY_CAN_STORAGE | MOBILITY_CAN_UI | MOBILITY_CAN_PULL | MOBILITY_CAN_RESIST | MOBILITY_CAN_STAND | MOBILITY_CAN_HOLD)
	else
		if(is_stunned())
			. &= ~(MOBILITY_CAN_USE | MOBILITY_CAN_MOVE | MOBILITY_CAN_PICKUP | MOBILITY_CAN_STORAGE | MOBILITY_CAN_UI | MOBILITY_CAN_PULL | MOBILITY_CAN_RESIST)
		else if(is_rooted())
			. &= ~(MOBILITY_CAN_MOVE)
		if(is_knockdown())
			. &= ~MOBILITY_CAN_STAND

	if(HAS_TRAIT(src, TRAIT_MOBILITY_HOLD_BLOCKED))
		. &= ~MOBILITY_CAN_HOLD
	if(HAS_TRAIT(src, TRAIT_MOBILITY_MOVE_BLOCKED))
		. &= ~MOBILITY_CAN_MOVE
	if(HAS_TRAIT(src, TRAIT_MOBILITY_PICKUP_BLOCKED))
		. &= ~MOBILITY_CAN_PICKUP
	if(HAS_TRAIT(src, TRAIT_MOBILITY_PULL_BLOCKED))
		. &= ~MOBILITY_CAN_PULL
	if(HAS_TRAIT(src, TRAIT_MOBILITY_RESIST_BLOCKED))
		. &= ~MOBILITY_CAN_RESIST
	if(HAS_TRAIT(src, TRAIT_MOBILITY_STAND_BLOCKED))
		. &= ~MOBILITY_CAN_STAND
	if(HAS_TRAIT(src, TRAIT_MOBILITY_UI_BLOCKED))
		. &= ~MOBILITY_CAN_UI
	if(HAS_TRAIT(src, TRAIT_MOBILITY_STORAGE_BLOCKED))
		. &= ~MOBILITY_CAN_STORAGE

	mobility_flags = .

	#warn resting?

	SEND_SIGNAL(src, COMSIG_MOB_ON_UPDATE_MOBILITY, .)
