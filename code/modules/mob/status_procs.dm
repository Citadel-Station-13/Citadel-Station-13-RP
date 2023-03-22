/**
 * default method of kicking a poor guy down to the ground
 *
 * @params
 * - amount - standard strength in deciseconds
 */
/mob/proc/default_combat_knockdown(amount)
	return

/mob/proc/is_stunned()
	RETURN_TYPE(/datum/status_effect)
	#warn impl

/mob/proc/afflict_stun(amount)
	if(!(status_flags & STATUS_CAN_STUN))
		return FALSE
	apply_status_effect(/datum/status_effect/incapacitation/stun, amount)
	return TRUE

/mob/proc/set_stunned(amount)
	if(!(status_flags & STATUS_CAN_STUN))
		return FALSE
	if(amount == 0)
		remove_status_effect(/datum/status_effect/incapacitation/stun)
	else
		var/datum/status_effect/effect = is_stunned()
		if(effect)
			effect.set_duration_from_now(amount)
	return TRUE

/mob/proc/adjust_stunned(amount)
	if(!(status_flags & STATUS_CAN_STUN))
		return FALSE
	if(amount == 0)
		remove_status_effect(/datum/status_effect/incapacitation/stun)
	else
		var/datum/status_effect/effect = is_stunned()
		if(effect)
			effect.adjust_duration(amount)
	return TRUE

/mob/proc/is_knockdown()
	RETURN_TYPE(/datum/status_effect)
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

/mob/proc/is_paralyzed()
	RETURN_TYPE(/datum/status_effect)
	#warn impl

/mob/proc/afflict_paralyze(amount)
	#warn impl

/mob/proc/adjust_paralyzed(amount)
	#warn impl

/mob/proc/set_paralyzed(amount)
	#warn impl

/mob/proc/is_rooted()
	RETURN_TYPE(/datum/status_effect)
	#warn impl

/mob/proc/afflict_root(amount)
	#warn impl

/mob/proc/adjust_rooted(amount)
	#warn impl

/mob/proc/set_rooted(amount)
	#warn impl

/mob/proc/is_dazed()
	RETURN_TYPE(/datum/status_effect)
	#warn impl

/mob/proc/afflict_daze(amount)
	#warn impl

/mob/proc/adjust_dazed(amount)
	#warn impl

/mob/proc/set_dazed(amount)
	#warn impl

/mob/proc/is_unconscious()
	RETURN_TYPE(/datum/status_effect)
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
	RETURN_TYPE(/datum/status_effect)
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
