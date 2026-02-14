/datum/species/shapeshifter/holosphere/proc/try_transform(var/mob/living/carbon/human/H, force = FALSE)
	if(!force && H.incapacitated(INCAPACITATION_ALL))
		to_chat(H, span_warning("You can't do that right now!"))
		return
	if(force || !IS_DEAD(holosphere_shell))
		holosphere_shell.name = H.name
		try_exit_recharge_station()
		if(transform_component.try_transform())
			H.drop_held_items()
			holosphere_shell.regenerate_icons()

/datum/species/shapeshifter/holosphere/proc/try_untransform(var/mob/living/carbon/human/H, force = FALSE)
	if(force || !IS_DEAD(holosphere_shell) && !H.is_in_critical())
		try_exit_recharge_station()
		transform_component.try_untransform()

/datum/species/shapeshifter/holosphere/proc/get_current_transform_state()
	return transform_component.get_current_transform_state()

/datum/species/shapeshifter/holosphere/proc/get_expected_transform_state(var/mob/living/carbon/human/H, var/current_transform_state)
	// if hologram is in critical, you should be in your shell
	if(holosphere_shell.hologram.is_in_critical())
		return STATE_TRANSFORMED
	// if hologram or shell is dead, you should be in your shell
	if(IS_DEAD(holosphere_shell) || IS_DEAD(H))
		return STATE_TRANSFORMED
	// otherwise we can be our current state
	return current_transform_state

// compares current and expected state
// transforms/untransforms to move to the expected state
/datum/species/shapeshifter/holosphere/proc/handle_transform_state(var/mob/living/carbon/human/H)
	var/current_transform_state = get_current_transform_state()
	var/expected_transform_state = get_expected_transform_state(H, current_transform_state)
	if(current_transform_state == expected_transform_state)
		return

	if(expected_transform_state == STATE_TRANSFORMED)
		try_transform(H, force = TRUE) // transform even if dead
	else if(expected_transform_state == STATE_NOT_TRANSFORMED)
		try_untransform(H, force = TRUE) // untransform even if dead
