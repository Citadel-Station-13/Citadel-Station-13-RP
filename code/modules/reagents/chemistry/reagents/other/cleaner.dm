/datum/reagent/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	description = "A compound used to clean things. Now with 50% more sodium hypochlorite!"
	taste_description = "sourness"
	reagent_state = REAGENT_LIQUID
	color = "#A5F0EE"
	touch_met = 50

/datum/reagent/space_cleaner/on_touch_obj(obj/target, remaining, allocated, data)
	. = ..()

	var/obj/O = target
	O.clean_blood()
	O.clean_radiation(RAD_CONTAMINATION_CLEANSE_POWER * (allocated / 10), RAD_CONTAMINATION_CLEANSE_FACTOR ** (1 / (allocated / 10)))

/datum/reagent/space_cleaner/on_touch_mob(mob/target, remaining, allocated, data, zone)
	. = ..()

	var/mob/M = target
	M.clean_radiation(RAD_CONTAMINATION_CLEANSE_POWER * (allocated / 10), RAD_CONTAMINATION_CLEANSE_FACTOR ** (1 / (allocated / 10)))

/datum/reagent/space_cleaner/on_touch_turf(turf/target, remaining, allocated, data)
	. = ..()

	var/turf/T = target
	if(allocated >= 1)
		if(istype(T, /turf/simulated))
			var/turf/simulated/S = T
			S.dirt = 0
		T.clean_blood()

		for(var/mob/living/simple_mob/slime/M in T)
			M.adjustToxLoss(rand(5, 10))

/datum/reagent/space_cleaner/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	for(var/obj/item/held as anything in M.get_held_items())
		held.clean_blood()
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

/datum/reagent/space_cleaner/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_SLIME)
		M.adjustToxLoss(6 * removed)
	else
		M.adjustToxLoss(3 * removed)
		if(prob(5))
			M.vomit()
