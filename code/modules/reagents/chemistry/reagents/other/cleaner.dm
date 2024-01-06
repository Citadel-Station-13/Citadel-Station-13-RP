/datum/reagent/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	description = "A compound used to clean things. Now with 50% more sodium hypochlorite!"
	taste_description = "sourness"
	reagent_state = REAGENT_LIQUID
	color = "#A5F0EE"
	touch_met = 50

/datum/reagent/space_cleaner/contact_expose_object(obj/target, volume, list/data, vapor)
	. = ..()
	target.clean_blood()
	target.clean_radiation(RAD_CONTAMINATION_CLEANSE_POWER * (volume / 10), RAD_CONTAMINATION_CLEANSE_FACTOR ** (1 / (volume / 10)))

/datum/reagent/space_cleaner/contact_expose_turf(turf/target, volume, list/data, vapor)
	. = ..()
	if(volume >= 1)
		if(istype(target, /turf/simulated))
			var/turf/simulated/S = target
			S.dirt = 0
		target.clean_blood()

		for(var/mob/living/simple_mob/slime/M in target)
			M.adjustToxLoss(rand(5, 10))

/datum/reagent/space_cleaner/touch_expose_mob(mob/target, volume, list/data, organ_tag)
	. = ..()
	target.clean_radiation(RAD_CONTAMINATION_CLEANSE_POWER * (volume / 10), RAD_CONTAMINATION_CLEANSE_FACTOR ** (1 / (volume / 10)))
	
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		if(M.r_hand)
			M.r_hand.clean_blood()
		if(M.l_hand)
			M.l_hand.clean_blood()
		if(M.wear_mask)
			if(M.wear_mask.clean_blood())
				M.update_inv_wear_mask(0)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(alien == IS_SLIME)
				M.adjustToxLoss(rand(5, 10))
			if(H.head)
				if(H.head.clean_blood())
					H.update_inv_head(0)
			if(H.wear_suit)
				if(H.wear_suit.clean_blood())
					H.update_inv_wear_suit(0)
			else if(H.w_uniform)
				if(H.w_uniform.clean_blood())
					H.update_inv_w_uniform(0)
			if(H.shoes)
				if(H.shoes.clean_blood())
					H.update_inv_shoes(0)
			else
				H.clean_blood(1)
				return
		M.clean_blood()

/datum/reagent/space_cleaner/vapor_expose_mob(mob/target, volume, list/data, inhaled)
	. = ..()
	target.clean_radiation(RAD_CONTAMINATION_CLEANSE_POWER * (volume / 10), RAD_CONTAMINATION_CLEANSE_FACTOR ** (1 / (volume / 10)))

/datum/reagent/space_cleaner/on_metabolize_tick(mob/living/carbon/entity, application, datum/reagent_metabolism/metabolism, organ_tag, list/data, removed)
	. = ..()
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		entity.adjustToxLoss(6 * removed)
	else
		entity.adjustToxLoss(3 * removed)
		if(prob(5))
			entity.vomit()
