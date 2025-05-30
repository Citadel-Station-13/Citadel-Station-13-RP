// todo: replace with reagent effects
/datum/reagent/toxin
	name = "toxin"
	id = "toxin"
	description = "A toxic chemical."
	taste_description = "bitterness"
	taste_mult = 1.2
	reagent_state = REAGENT_LIQUID
	color = "#CF3600"
	metabolism_rate = REM * 0.25 // 0.05 by default. Hopefully enough to get some help, or die horribly, whatever floats your boat
	filtered_organs = list(O_LIVER, O_KIDNEYS)
	var/strength = 4 // How much damage it deals per unit
	var/skin_danger = 0.2 // The multiplier for how effective the toxin is when making skin contact.

/datum/reagent/toxin/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(strength && alien != IS_DIONA)
		if(issmall(M)) removed *= 2 // Small bodymass, more effect from lower volume.
		if(alien == IS_SLIME)
			removed *= 0.25 // Results in half the standard tox as normal. Prometheans are 'Small' for flaps.
			if(metabolism.total_processed_dose >= 10)
				M.nutrition += strength * removed //Body has to deal with the massive influx of toxins, rather than try using them to repair.
			else
				M.heal_organ_damage((10/strength) * removed, (10/strength) * removed) //Doses of toxins below 10 units, and 10 strength, are capable of providing useful compounds for repair.
		M.adjustToxLoss(strength * removed)

/datum/reagent/toxin/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	legacy_affect_blood(M, alien, removed * 0.2, metabolism)
