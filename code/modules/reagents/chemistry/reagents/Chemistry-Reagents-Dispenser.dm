/datum/reagent/sugar
	name = "Sugar"
	id = "sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	taste_description = "sugar"
	taste_mult = 1.8
	reagent_state = REAGENT_SOLID
	color = "#FFFFFF"

	glass_name = "sugar"
	glass_desc = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	glass_icon = DRINK_ICON_NOISY

/datum/reagent/sugar/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.nutrition += removed * 3

	var/effective_dose = metabolism.total_processed_dose
	if(issmall(M))
		effective_dose *= 2

	if(alien == IS_UNATHI)
		if(effective_dose < 2)
			if(effective_dose == metabolism_rate * 2 || prob(5))
				M.emote("yawn")
		else if(effective_dose < 5)
			M.eye_blurry = max(M.eye_blurry, 10)
		else if(effective_dose < 20)
			if(prob(50))
				M.afflict_paralyze(20 * 2)
			M.drowsyness = max(M.drowsyness, 20)
		else
			M.afflict_sleeping(20 * 20)
			M.drowsyness = max(M.drowsyness, 60)

	if(alien == IS_ALRAUNE) //cit change - too much sugar isn't good for plants
		if(effective_dose < 2)
			if(prob(5))
				to_chat(M, "<span class='danger'>You feel an imbalance of energy.</span>")
			M.make_jittery(4)

/datum/reagent/sulfur
	name = "Sulfur"
	id = "sulfur"
	description = "A chemical element with a pungent smell."
	taste_description = "old eggs"
	reagent_state = REAGENT_SOLID
	color = "#BF8C00"

