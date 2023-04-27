//? Incapacitation

/**
 * default method of kicking a poor guy down to the ground
 *
 * @params
 * - amount - standard strength in deciseconds
 */
/mob/proc/default_combat_knockdown(amount)
	return afflict_knockdown(amount)

/mob/proc/is_stunned()
	RETURN_TYPE(/datum/status_effect)
	return has_status_effect(/datum/status_effect/incapacitation/stun)

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
		else if(amount > 0)
			afflict_stun(amount)
	return TRUE

/mob/proc/adjust_stunned(amount)
	if(!(status_flags & STATUS_CAN_STUN))
		return FALSE
	var/datum/status_effect/effect = is_stunned()
	if(effect)
		effect.adjust_duration(amount)
	else if(amount > 0)
		afflict_stun(amount)
	return TRUE

/mob/proc/is_knockdown()
	RETURN_TYPE(/datum/status_effect)
	return has_status_effect(/datum/status_effect/incapacitation/knockdown)

/mob/proc/afflict_knockdown(amount)
	if(!(status_flags & STATUS_CAN_KNOCKDOWN))
		return FALSE
	apply_status_effect(/datum/status_effect/incapacitation/knockdown, amount)
	return TRUE

/mob/proc/set_knockdown(amount)
	if(!(status_flags & STATUS_CAN_KNOCKDOWN))
		return FALSE
	if(amount == 0)
		remove_status_effect(/datum/status_effect/incapacitation/knockdown)
	else
		var/datum/status_effect/effect = is_knockdown()
		if(effect)
			effect.set_duration_from_now(amount)
		else if(amount > 0)
			afflict_knockdown(amount)
	return TRUE

/mob/proc/adjust_knockdown(amount)
	if(!(status_flags & STATUS_CAN_KNOCKDOWN))
		return FALSE
	var/datum/status_effect/effect = is_knockdown()
	if(effect)
		effect.adjust_duration(amount)
	else if(amount > 0)
		afflict_knockdown(amount)
	return TRUE

/mob/proc/is_paralyzed()
	RETURN_TYPE(/datum/status_effect)
	return has_status_effect(/datum/status_effect/incapacitation/paralyze)

/mob/proc/afflict_paralyze(amount)
	if(!(status_flags & STATUS_CAN_PARALYZE))
		return FALSE
	apply_status_effect(/datum/status_effect/incapacitation/paralyze, amount)
	return TRUE

/mob/proc/adjust_paralyzed(amount)
	if(!(status_flags & STATUS_CAN_PARALYZE))
		return FALSE
	var/datum/status_effect/effect = is_paralyzed()
	if(effect)
		effect.adjust_duration(amount)
	else if(amount > 0)
		afflict_paralyze(amount)
	return TRUE

/mob/proc/set_paralyzed(amount)
	if(!(status_flags & STATUS_CAN_PARALYZE))
		return FALSE
	if(amount == 0)
		remove_status_effect(/datum/status_effect/incapacitation/paralyze)
	else
		var/datum/status_effect/effect = is_paralyzed()
		if(effect)
			effect.set_duration_from_now(amount)
		else if(amount > 0)
			afflict_paralyze(amount)
	return TRUE

/mob/proc/is_rooted()
	RETURN_TYPE(/datum/status_effect)
	return has_status_effect(/datum/status_effect/incapacitation/root)

/mob/proc/afflict_root(amount)
	if(!(status_flags & STATUS_CAN_ROOT))
		return FALSE
	apply_status_effect(/datum/status_effect/incapacitation/root, amount)
	return TRUE

/mob/proc/adjust_rooted(amount)
	if(!(status_flags & STATUS_CAN_ROOT))
		return FALSE
	var/datum/status_effect/effect = is_rooted()
	if(effect)
		effect.adjust_duration(amount)
	else if(amount > 0)
		afflict_root(amount)
	return TRUE

/mob/proc/set_rooted(amount)
	if(!(status_flags & STATUS_CAN_ROOT))
		return FALSE
	if(amount == 0)
		remove_status_effect(/datum/status_effect/incapacitation/root)
	else
		var/datum/status_effect/effect = is_rooted()
		if(effect)
			effect.set_duration_from_now(amount)
		else if(amount > 0)
			afflict_root(amount)
	return TRUE

/mob/proc/afflict_stagger(stacks, maximum)
	apply_stacking_effect(/datum/status_effect/stacking/staggered, stacks, maximum)

/mob/proc/cure_stagger(stacks)
	remove_stacking_effect(/datum/status_effect/stacking/staggered, stacks)

/mob/proc/is_staggered()
	RETURN_TYPE(/datum/status_effect/stacking/staggered)
	return has_status_effect(/datum/status_effect/stacking/staggered)

/mob/proc/stacks_staggered()
	return is_staggered()?.stacks

/mob/proc/is_unconscious()
	RETURN_TYPE(/datum/status_effect)
	return has_status_effect(/datum/status_effect/incapacitation/unconscious)

/mob/proc/afflict_unconscious(amount)
	apply_status_effect(/datum/status_effect/incapacitation/unconscious, amount)
	return TRUE

/mob/proc/set_unconscious(amount)
	var/datum/status_effect/incapacitation/unconscious/effect = is_unconscious()
	if(isnull(effect))
		if(!amount)
			return
		apply_status_effect(/datum/status_effect/incapacitation/unconscious, amount)
	else
		effect.set_duration_from_now(amount)
	return TRUE

/mob/proc/adjust_unconscious(amount)
	var/datum/status_effect/incapacitation/unconscious/effect = is_unconscious()
	if(isnull(effect))
		if(amount < 0)
			return
		apply_status_effect(/datum/status_effect/incapacitation/unconscious, amount)
	else
		effect.adjust_duration(amount)
	return TRUE

/mob/proc/is_sleeping()
	RETURN_TYPE(/datum/status_effect)
	return has_status_effect(/datum/status_effect/incapacitation/sleeping)

/mob/proc/afflict_sleeping(amount)
	apply_status_effect(/datum/status_effect/incapacitation/sleeping, amount)
	return TRUE

/mob/proc/set_sleeping(amount)
	var/datum/status_effect/incapacitation/sleeping/effect = is_sleeping()
	if(isnull(effect))
		if(!amount)
			return
		apply_status_effect(/datum/status_effect/incapacitation/sleeping, amount)
	else
		effect.set_duration_from_now(amount)
	return TRUE

/mob/proc/adjust_sleeping(amount)
	var/datum/status_effect/incapacitation/sleeping/effect = is_sleeping()
	if(isnull(effect))
		if(amount < 0)
			return
		apply_status_effect(/datum/status_effect/incapacitation/sleeping, amount)
	else
		effect.adjust_duration(amount)
	return TRUE

//? legacy

/mob/proc/Confuse(amount)
	confused = max(confused, amount, 0)

/mob/proc/SetConfused(amount)
	confused = max(amount, 0)

/mob/proc/AdjustConfused(amount)
	confused = max(confused + amount, 0)

/mob/proc/Blind(amount)
	eye_blind = max(eye_blind, amount, 0)

/mob/proc/SetBlinded(amount)
	eye_blind = max(amount, 0)

/mob/proc/AdjustBlinded(amount)
	eye_blind = max(eye_blind + amount, 0)
