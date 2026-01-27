/datum/species/shapeshifter/holosphere/handle_death(var/mob/living/carbon/human/H, gibbed)
	last_death_time = world.time

	if(gibbed)
		QDEL_NULL(holosphere_shell)
		return

	var/deathmsg = "<span class='userdanger'>Systems critically damaged. Emitters temporarily offline.</span>"
	to_chat(H, deathmsg)
	try_transform(force = TRUE)
	holosphere_shell.afflict_stun(hologram_death_duration)
	spawn(hologram_death_duration)
		try_revive(H)

/// same way shapeshifter species heals but it does not work if you have no nutrition
/datum/species/shapeshifter/holosphere/handle_environment_special(mob/living/carbon/human/H, datum/gas_mixture/environment, dt)
	if(!actively_healing || H.nutrition <= 0)
		return
	if(H.fire_stacks >= 0 && heal_rate > 0)
		if(H.getBruteLoss() || H.getFireLoss() || H.getOxyLoss() || H.getToxLoss())
			var/nutrition_cost = 0
			var/nutrition_debt = H.getBruteLoss()
			var/starve_mod = 1
			if(H.nutrition <= 25)
				starve_mod = 0.75
			H.adjustBruteLoss(-heal_rate * starve_mod)
			nutrition_cost += nutrition_debt - H.getBruteLoss()

			nutrition_debt = H.getFireLoss()
			H.adjustFireLoss(-heal_rate * starve_mod)
			nutrition_cost += nutrition_debt - H.getFireLoss()

			nutrition_debt = H.getOxyLoss()
			H.adjustOxyLoss(-heal_rate * starve_mod)
			nutrition_cost += nutrition_debt - H.getOxyLoss()

			nutrition_debt = H.getToxLoss()
			H.adjustToxLoss(-heal_rate * starve_mod)
			nutrition_cost += nutrition_debt - H.getToxLoss()
			H.nutrition -= (heal_nutrition_multiplier * nutrition_cost) //Costs Nutrition when damage is being repaired, corresponding to the amount of damage being repaired.
			H.nutrition = max(0, H.nutrition) //Ensure it's not below 0.
	try_revive(H, TRUE)

/datum/species/shapeshifter/holosphere/proc/get_revive_cost()
	return max_nutrition / 4

/datum/species/shapeshifter/holosphere/proc/can_revive(mob/living/carbon/human/H, revive_cost)
	if(H.stat != DEAD)
		return FALSE
	var/time_passed = world.time - last_death_time
	if(time_passed < hologram_death_duration)
		return FALSE
	if(H.nutrition < revive_cost)
		return FALSE
	return TRUE

/datum/species/shapeshifter/holosphere/proc/try_revive(mob/living/carbon/human/H, silent_failure = FALSE)
	var/revive_cost = get_revive_cost()
	if(can_revive(H, revive_cost))
		H.nutrition -= revive_cost
		try_untransform(force = TRUE)
		H.revive(full_heal = TRUE, restore_nutrition = FALSE)
		var/regenmsg = "<span class='userdanger'>Emitters have returned online. Systems functional.</span>"
		to_chat(H, regenmsg)
	else if(!silent_failure)
		var/failuremsg = "<span class='userdanger'>Emitters unable to turn online due to insufficient battery.</span>"
		to_chat(holosphere_shell, failuremsg)
