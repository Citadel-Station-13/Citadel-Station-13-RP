/**
 * ## Stacking Status Effects
 *
 * able to track stacks.
 *
 * this and all subtypes have `stacks` as an argument on apply.
 */
/datum/status_effect/stacking
	abstract_type = /datum/status_effect/stacking

	/// decay amount - this can be negative.
	var/decay_amount = 1
	/// stacks
	var/stacks = 1
	/// max stacks
	var/max_stacks = INFINITY
	/// default behavior: do we refresh decay timer to maximum (duration) when stacks increase from external sources?
	var/stacking_resets_decay = TRUE

/datum/status_effect/stacking/decay()
	#warn impl

/**
 * called when stacks change
 * when we're being removed, new_stacks is 0.
 *
 * @params
 * * old_stacks - old stacks
 * * new_stacks - new stacks
 * * decayed - is this from decaying?
 */
/datum/status_effect/stacking/proc/on_stacks(old_stacks, new_stacks, decayed)
	return

/**
 * called to modify stacks.
 */
/datum/status_effect/stacking/proc/adjust_stacks(stacks, decaying)
	#warn impl

//? Mob procs

/**
 * simple add or increment to stacks of a stacking effect
 *
 * @return effect datum
 */
/mob/proc/apply_stacking_effect(datum/status_effect/stacking/path, stacks)
	if(!ispath(path, /datum/status_effect/stacking))
		CRASH("[path] is not a stacking effect.")
	ASSERT(stacks > 0)
	var/datum/status_effect/stacking/effect = has_status_effect(path)
	if(!effect)
		effect = apply_status_effect(path, additional = list(stacks))
	else
		effect.adjust_stacks(stacks, FALSE)
	return effect

/**
 * simple decrement to stacks of a stacking effect
 *
 * @return stacks left
 */
/mob/proc/remove_stacking_effect(datum/status_effect/stacking/path, stacks)
	if(!ispath(path, /datum/status_effect/stacking))
		CRASH("[path] is not a stacking effect.")
	ASSERT(stacks > 0)
	var/datum/status_effect/stacking/effect = has_status_effect(path)
	if(!effect)
		return 0
	else
		effect.adjust_stacks(-stacks, FALSE)
		. = effect.stacks
