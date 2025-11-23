/datum/species/shapeshifter/holosphere/proc/try_transform(force = FALSE)
	if(!force && holosphere_shell.hologram.incapacitated(INCAPACITATION_ALL))
		to_chat(holosphere_shell.hologram, SPAN_WARNING("You can't do that right now!"))
		return
	if(force || !IS_DEAD(holosphere_shell))
		holosphere_shell.name = holosphere_shell.hologram.name
		try_exit_recharge_station()
		if(transform_component.try_transform())
			holosphere_shell.hologram.drop_held_items()
			holosphere_shell.regenerate_icons()

/datum/species/shapeshifter/holosphere/proc/try_untransform(force = FALSE)
	if(force || (!IS_DEAD(holosphere_shell.hologram) && !holosphere_shell.hologram.is_in_critical()))
		try_exit_recharge_station()
		transform_component.try_untransform()

/datum/species/shapeshifter/holosphere/proc/get_current_transform_state()
	return transform_component.get_current_transform_state()

/datum/species/shapeshifter/holosphere/proc/get_expected_transform_state(var/current_transform_state)
	// if hologram is in critical, you should be in your shell
	if(holosphere_shell.hologram.is_in_critical())
		return STATE_TRANSFORMED
	// if hologram or shell is dead, you should be in your shell
	if(IS_DEAD(holosphere_shell) || IS_DEAD(holosphere_shell.hologram))
		return STATE_TRANSFORMED
	// otherwise we can be our current state
	return current_transform_state
