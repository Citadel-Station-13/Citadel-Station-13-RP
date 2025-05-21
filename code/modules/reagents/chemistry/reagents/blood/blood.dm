// todo: stuff in this file might need to be moved somewhere else, this being in reagents/core is weird.

/**
 * Blood.
 *
 * I'm not sure what you expected this to say.
 *
 * * `data_initializer`: `/datum/blood_mixture` instance
 * * `data`: /datum/blood_mixture instance
 */
/datum/reagent/blood
	name = "Blood"
	id = "blood"
	taste_description = "iron"
	taste_mult = 1.3
	reagent_state = REAGENT_LIQUID
	metabolism_rate = REM * 5
	mrate_static = TRUE
	affects_dead = 1 //so you can pump blood into someone before defibbing them
	color = "#A80000"
	holds_data = TRUE
	blood_content = 4 //How effective this is for vampires.

	glass_name = "tomato juice"
	glass_desc = "Are you sure this is tomato juice?"
	var/volume_mod = 1	// So if you add different subtypes of blood, you can affect how much vessel blood each unit of reagent adds

/datum/reagent/blood/make_copy_data_initializer(datum/blood_mixture/data)
	return data

/datum/reagent/blood/preprocess_data(data_initializer)
	return data_initializer

/datum/reagent/blood/mix_data(datum/blood_mixture/old_data, old_volume, datum/blood_mixture/new_data, new_volume, datum/reagent_holder/holder)
	if(!old_data)
		old_data = new
	if(new_data)
		old_data.unsafe_merge_other_into_self(new_data, new_volume, old_volume)
	return old_data

/datum/reagent/blood/on_touch_turf(turf/target, remaining, allocated, data)
	. = ..()
	if(allocated < 3)
		return
	. = max(., min(allocated, 3))
	blood_splatter_legacy(target, data, TRUE)

/datum/reagent/blood/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	var/datum/blood_mixture/data = metabolism.legacy_data

	var/effective_dose = metabolism.total_processed_dose
	if(issmall(M))
		effective_dose *= 2

	var/nutritionvalue = 10 //for reference, normal nutrition has a value of about 30.
	var/is_vampire = M.species.is_vampire
	switch(alien) //unique interactions sorted from the species who benefit the least to the species who benefit the most.
		if(IS_SKRELL) //arguing that blood is "meat" and is still toxic for the vegan skrell at least
			if(effective_dose > 5)
				if(!is_vampire) //a vetalan skrell sounds funny as hell
					M.adjustToxLoss(removed)
			if(effective_dose > 15)
				if(!is_vampire)
					M.adjustToxLoss(removed)
		if(IS_SLIME)
			nutritionvalue = 20
			if(data["species"] == M.species.name) //just 'inject' the blood if it happens to be promethean "blood".
				M.regen_blood(metabolism.legacy_volume_remaining * volume_mod)
				metabolism.legacy_current_holder.remove_reagent(id, metabolism.legacy_current_holder)
				return
		if(IS_TESHARI) //birb.
			nutritionvalue = 30
		if(IS_UNATHI) //carnivorous lizord...
			nutritionvalue = 45
		if(IS_ALRAUNE) //lorewise, alraune are meant to enjoy blood.
			nutritionvalue = 60
		if(IS_CHIMERA) //obligate carnivores.
			nutritionvalue = 80

	if(is_vampire)
		handle_vampire(M, alien, removed, is_vampire)
		M.heal_organ_damage(0.7 * removed * volume_mod, 0) // Heals vampires more.
		M.adjust_hydration(7 * removed) // Hydrates vetalan better.
		M.add_chemical_effect(CE_BLOODRESTORE, 8 * removed) // Same rating as taking iron
	else
		M.adjust_nutrition(nutritionvalue * removed * volume_mod)
		M.adjust_hydration(2 * removed) // Still has some water in the form of plasma. Hydrates less than a normal drink.
		M.add_chemical_effect(CE_BLOODRESTORE, 4 * removed) //same rating as eating nutriment
		if(effective_dose >= 20 && prob(10))
			M.vomit(FALSE, FALSE) //Drinking blood makes you vomit, due to the high iron content and unpleasant consistency

	if(data && data["virus2"])
		var/list/vlist = data["virus2"]
		if(vlist.len)
			for(var/ID in vlist)
				var/datum/disease2/disease/V = vlist[ID]
				if(V.spreadtype == "Contact")
					infect_virus2(M, V.getcopy())

/datum/reagent/blood/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	var/datum/blood_mixture/data = metabolism.legacy_data
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.isSynthetic())
			return
	if(alien == IS_SLIME)
		legacy_affect_ingest(M, alien, removed, metabolism)
		return
	if(data && data["virus2"])
		var/list/vlist = data["virus2"]
		if(vlist.len)
			for(var/ID in vlist)
				var/datum/disease2/disease/V = vlist[ID]
				if(V.spreadtype == "Contact")
					infect_virus2(M, V.getcopy())
	if(data && data["antibodies"])
		M.antibodies |= data["antibodies"]

/datum/reagent/blood/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_SLIME) //They don't have blood, so it seems weird that they would instantly 'process' the chemical like another species does.
		legacy_affect_ingest(M, alien, removed, metabolism)
		return

	if(M.isSynthetic())
		return

	M.inject_blood_legacy(metabolism.legacy_data, volume_mod * metabolism.legacy_volume_remaining)
	metabolism.legacy_current_holder.remove_reagent(id, metabolism.legacy_volume_remaining)
