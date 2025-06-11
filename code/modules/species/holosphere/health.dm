/datum/species/holosphere/handle_death(var/mob/living/carbon/human/H, gibbed)
	if(gibbed)
		QDEL_NULL(holosphere_shell)
		return

	var/deathmsg = "<span class='userdanger'>Systems critically damaged. Emitters temporarily offline.</span>"
	to_chat(H, deathmsg)
	try_transform(force = TRUE)
	holosphere_shell.afflict_stun(hologram_death_duration)
	try_revive(H)

/// same way shapeshifter species heals but it does not work if you have no nutrition
/datum/species/holosphere/handle_environment_special(mob/living/carbon/human/H, datum/gas_mixture/environment, dt)
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
	..()

/datum/species/holosphere/proc/get_revive_cost()
	return total_health * heal_rate * heal_nutrition_multiplier

/datum/species/holosphere/proc/can_revive(mob/living/carbon/human/H)
	if(H.stat != DEAD)
		return FALSE
	if(reviving)
		return FALSE
	var/revive_cost = get_revive_cost()
	if(H.nutrition >= revive_cost)
		return TRUE
	return FALSE

/datum/species/holosphere/proc/try_revive(mob/living/carbon/human/H, silent_failure = FALSE)
	if(can_revive(H))
		spawn(hologram_death_duration)
			var/revive_cost = get_revive_cost()
			if(can_revive(H))
				reviving = TRUE

				// kick them out of a recharge station if they're in one
				var/obj/machinery/recharge_station/R = holosphere_shell.loc
				if(istype(R))
					R.go_out()

				H.nutrition -= revive_cost
				try_untransform(force = TRUE)
				H.revive(full_heal = TRUE)
				var/regenmsg = "<span class='userdanger'>Emitters have returned online. Systems functional.</span>"
				to_chat(H, regenmsg)
			else if(!silent_failure)
				var/failuremsg = "<span class='userdanger'>Emitters unable to turn online due to insufficient battery.</span>"
				to_chat(holosphere_shell, failuremsg)
			reviving = FALSE
