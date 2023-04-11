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

/datum/status_effect/stacking/on_apply(stacks, ...)
	src.stacks = isnull(stacks)? 1 : stacks
	ASSERT(src.stacks > 0)
	return ..()

/datum/status_effect/stacking/decay()
	adjust_stacks(decay_amount, TRUE)
	if(!stacks)
		return ..()
	started = world.time
	rebuild_decay_timer()

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
 *
 * @return stacks modified
 */
/datum/status_effect/stacking/proc/adjust_stacks(stacks, decaying)
	var/old = src.stacks
	src.stacks = clamp(src.stacks + stacks, 0, max_stacks)
	on_stacks(old, src.stacks, decaying)
	if(!decaying)
		qdel(src)
	return src.stacks - old

//? Mob procs

/**
 * simple add or increment to stacks of a stacking effect
 *
 * maximum as well as the effect's maximum are both respected.
 *
 * @return stacks applied
 */
/mob/proc/apply_stacking_effect(datum/status_effect/stacking/path, stacks, maximum)
	if(!ispath(path, /datum/status_effect/stacking))
		CRASH("[path] is not a stacking effect.")
	stacks = min(stacks, maximum) // just in case
	ASSERT(stacks > 0)
	var/datum/status_effect/stacking/effect = has_status_effect(path)
	if(isnull(effect))
		. = effect.adjust_stacks(clamp(stacks, 0, maximum - effect.stacks), FALSE)
	else
		effect = apply_status_effect(path, additional = list(stacks))
		. = effect.stacks

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
	if(isnull(effect))
		effect.adjust_stacks(-stacks, FALSE)
		. = effect.stacks
	else
		return 0
