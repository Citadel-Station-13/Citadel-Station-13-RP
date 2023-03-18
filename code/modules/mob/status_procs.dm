/**
 * default method of kicking a poor guy down to the ground
 *
 * @params
 * - amount - standard strength in deciseconds
 */
/mob/proc/default_combat_knockdown(amount)
	return

/mob/proc/is_stunned()
	#warn impl

/mob/proc/afflict_stun(amount)
	if(!(status_flags & STATUS_CAN_STUN))
		return FALSE
	#warn impl
	return TRUE

/mob/proc/set_stunned(20 * amount) //if you REALLY need to set stun to a set amount without the whole "can't go below current stunned"
	if(status_flags & STATUS_CAN_STUN)
		stunned = max(amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/adjust_stunned(amount)
	if(status_flags & STATUS_CAN_STUN)
		stunned = max(stunned + amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/is_knockdown()
	#warn impl

/mob/proc/afflict_knockdown(amount)
	if(status_flags & STATUS_CAN_WEAKEN)
		facing_dir = null
		weakened = max(max(weakened,amount),0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/set_knockdown(amount)
	if(!(status_flags & STATUS_CAN_WEAKEN))
		return FALSE
	#warn impl
	return TRUE

/mob/proc/adjust_knockdown(amount)
	if(status_flags & STATUS_CAN_WEAKEN)
		weakened = max(weakened + amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/is_unconscious()
	#warn impl

/mob/proc/afflict_unconscious(amount)
	if(status_flags & STATUS_CAN_PARALYZE)
		facing_dir = null
		paralysis = max(max(paralysis,amount),0)
	return

/mob/proc/set_unconscious(amount)
	if(status_flags & STATUS_CAN_PARALYZE)
		paralysis = max(amount,0)
	return

/mob/proc/adjust_unconscious(amount)
	if(status_flags & STATUS_CAN_PARALYZE)
		paralysis = max(paralysis + amount,0)
	return

/mob/proc/is_sleeping()
	#warn impl

/mob/proc/afflict_sleeping(amount)
	facing_dir = null
	sleeping = max(max(sleeping,amount),0)
	return

/mob/proc/set_sleeping(amount)
	sleeping = max(amount,0)
	return

/mob/proc/adjust_sleeping(amount)
	sleeping = max(sleeping + amount,0)
	return

//? legacy

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
