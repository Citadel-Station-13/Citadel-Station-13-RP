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

/datum/status_effect/stacking/decay()
	#warn impl

/**
 * called when stacks change
 * when we're being removed, new_stacksi s 0.
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

/datum/status_effect/stacking
	identifier = "stacking_base"
	duration = -1 //removed under specific conditions
	alert_type = null
	var/stacks = 0 //how many stacks are accumulated, also is # of stacks that target will have when first applied
	var/delay_before_decay //deciseconds until ticks start occuring, which removes stacks (first stack will be removed at this time plus tick_interval)
	tick_interval = 10 //deciseconds between decays once decay starts


/datum/status_effect/stacking/proc/add_stacks(stacks_added)
	if(stacks_added > 0 && !can_gain_stacks())
		return FALSE
	owner.cut_overlay(status_overlay)
	owner.underlays -= status_underlay
	stacks += stacks_added
	if(stacks > 0)
		if(stacks >= stack_threshold && !threshold_crossed) //threshold_crossed check prevents threshold effect from occuring if changing from above threshold to still above threshold
			threshold_crossed = TRUE
			on_threshold_cross()
			if(consumed_on_threshold)
				return
		else if(stacks < stack_threshold && threshold_crossed)
			threshold_crossed = FALSE //resets threshold effect if we fall below threshold so threshold effect can trigger again
			on_threshold_drop()
		if(stacks_added > 0)
			next_tick += delay_before_decay //refreshes time until decay
		stacks = min(stacks, max_stacks)
		status_overlay.icon_state = "[overlay_state][stacks]"
		status_underlay.icon_state = "[underlay_state][stacks]"
		owner.add_overlay(status_overlay)
		owner.underlays += status_underlay
	else
		fadeout_effect()
		qdel(src) //deletes status if stacks fall under one

/datum/status_effect/stacking/on_apply()
	if(!can_have_status())
		return FALSE
	status_overlay = mutable_appearance(overlay_file, "[overlay_state][stacks]")
	status_underlay = mutable_appearance(underlay_file, "[underlay_state][stacks]")
	var/icon/I = icon(owner.icon, owner.icon_state, owner.dir)
	var/icon_height = I.Height()
	status_overlay.pixel_x = -owner.pixel_x
	status_overlay.pixel_y = FLOOR(icon_height * 0.25, 1)
	status_overlay.transform = matrix() * (icon_height/world.icon_size) //scale the status's overlay size based on the target's icon size
	status_underlay.pixel_x = -owner.pixel_x
	status_underlay.transform = matrix() * (icon_height/world.icon_size) * 3
	status_underlay.alpha = 40
	owner.add_overlay(status_overlay)
	owner.underlays += status_underlay
	return ..()

/datum/status_effect/stacking/Destroy()
	if(owner)
		owner.cut_overlay(status_overlay)
		owner.underlays -= status_underlay
	QDEL_NULL(status_overlay)
	return ..()
