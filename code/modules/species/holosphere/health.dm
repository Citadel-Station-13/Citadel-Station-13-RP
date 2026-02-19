/datum/species/shapeshifter/holosphere/handle_environment_special(mob/living/carbon/human/H, datum/gas_mixture/environment, dt)
	// handle_crit does not transform the shell on crit, it does everything else (the message, stun, automatic attempt to revive)
	if(H.is_in_critical())
		handle_crit(H)

	// handles when you are forced to change state between transformed/untransformed (i.e. due to dying or being in crit)
	handle_transform_state(H)

	handle_regen(H)

/datum/species/shapeshifter/holosphere/handle_death(var/mob/living/carbon/human/H, gibbed)
	if(gibbed)
		QDEL_NULL(holosphere_shell)
		return

/datum/species/shapeshifter/holosphere/proc/handle_crit(mob/living/carbon/human/H)
	if(get_current_transform_state() == STATE_TRANSFORMED)
		return

	var/deathmsg = "<span class='userdanger'>Systems critically damaged. Emitters temporarily offline.</span>"
	to_chat(holosphere_shell, deathmsg)
	holosphere_shell.afflict_stun(hologram_death_duration)
	spawn(hologram_death_duration)
		try_revive(H)

/datum/species/shapeshifter/holosphere/proc/can_revive(mob/living/carbon/human/H, revive_cost)
	if(H.stat != DEAD && !H.is_in_critical())
		return FALSE
	if(holosphere_shell.stat == DEAD)
		return FALSE
	var/time_passed = world.time - last_death_time
	if(time_passed < hologram_death_duration)
		return FALSE
	if(H.nutrition < revive_cost)
		return FALSE
	return TRUE

/datum/species/shapeshifter/holosphere/proc/get_revive_cost()
	return max_nutrition / 4

/datum/species/shapeshifter/holosphere/proc/try_revive(mob/living/carbon/human/H, silent_failure = FALSE)
	var/revive_cost = get_revive_cost()
	if(can_revive(H, revive_cost))
		H.nutrition -= revive_cost
		try_untransform(force = TRUE)
		if(IS_DEAD(H))
			H.revive(full_heal = TRUE, restore_nutrition = FALSE)
		else
			H.rejuvenate(TRUE, restore_nutrition = FALSE)
		var/regenmsg = "<span class='userdanger'>Emitters have returned online. Systems functional.</span>"
		to_chat(H, regenmsg)
	else if(!silent_failure)
		var/failuremsg = "<span class='userdanger'>Emitters unable to turn online due to insufficient battery.</span>"
		to_chat(holosphere_shell, failuremsg)

/datum/species/shapeshifter/holosphere/proc/handle_regen(mob/living/carbon/human/H)
	var/nutrition_cost = heal_nutrition_multiplier * heal_rate
	if(H.getBruteLoss() && H.nutrition >= nutrition_cost)
		H.nutrition -= nutrition_cost
		H.adjustBruteLoss(-heal_rate, TRUE)
	if(H.getFireLoss() && H.nutrition >= nutrition_cost)
		H.nutrition -= nutrition_cost
		H.adjustFireLoss(-heal_rate, TRUE)
	if(H.getOxyLoss() && H.nutrition >= nutrition_cost)
		H.nutrition -= nutrition_cost
		H.adjustOxyLoss(-heal_rate)
	if(H.getToxLoss() && H.nutrition >= nutrition_cost)
		H.nutrition -= nutrition_cost
		H.adjustToxLoss(-heal_rate)
