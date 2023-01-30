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

/mob/proc/Stun(amount)
	if(status_flags & CANSTUN)
		facing_dir = null
		stunned = max(max(stunned,amount),0) //can't go below 0, getting a low amount of stun doesn't lower your current stun
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/SetStunned(amount) //if you REALLY need to set stun to a set amount without the whole "can't go below current stunned"
	if(status_flags & CANSTUN)
		stunned = max(amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/AdjustStunned(amount)
	if(status_flags & CANSTUN)
		stunned = max(stunned + amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/Weaken(amount)
	if(status_flags & CANWEAKEN)
		facing_dir = null
		weakened = max(max(weakened,amount),0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/SetWeakened(amount)
	if(status_flags & CANWEAKEN)
		weakened = max(amount,0)
		update_canmove()	//can you guess what this does yet?
	return

/mob/proc/AdjustWeakened(amount)
	if(status_flags & CANWEAKEN)
		weakened = max(weakened + amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/Unconscious(amount)
	if(status_flags & CANPARALYSE)
		facing_dir = null
		paralysis = max(max(paralysis,amount),0)
	return

/mob/proc/SetUnconscious(amount)
	if(status_flags & CANPARALYSE)
		paralysis = max(amount,0)
	return

/mob/proc/AdjustUnconscious(amount)
	if(status_flags & CANPARALYSE)
		paralysis = max(paralysis + amount,0)
	return

/mob/proc/Sleeping(amount)
	facing_dir = null
	sleeping = max(max(sleeping,amount),0)
	return

/mob/proc/SetSleeping(amount)
	sleeping = max(amount,0)
	return

/mob/proc/AdjustSleeping(amount)
	sleeping = max(sleeping + amount,0)
	return

/mob/proc/Confuse(amount)
	confused = max(max(confused,amount),0)
	return

/mob/proc/SetConfused(amount)
	confused = max(amount,0)
	return

/mob/proc/AdjustConfused(amount)
	confused = max(confused + amount,0)
	return

/mob/proc/Blind(amount)
	eye_blind = max(max(eye_blind,amount),0)
	return

/mob/proc/SetBlinded(amount)
	eye_blind = max(amount,0)
	return

/mob/proc/AdjustBlinded(amount)
	eye_blind = max(eye_blind + amount,0)
	return
