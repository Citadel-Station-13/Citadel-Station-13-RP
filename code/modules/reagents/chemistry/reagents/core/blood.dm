/**
 * Reagent blood data
 */
/datum/blood_data
	/// species id
	///
	/// * this is the UID of the species, so subspecies does matter.
	var/species_id
	/// the blood's color
	var/color

	//! LEGACY FIELDS
	var/legacy_viruses
	var/legacy_virus2
	var/legacy_blood_dna
	var/legacy_blood_type
	var/legacy_trace_chem
	var/legacy_resistances
	var/legacy_donor
	//! END


/datum/blood_data/reagent
	/// % of the reagent this is
	var/ratio

/**
 * Blood.
 *
 * I'm not sure what you expected this to say.
 *
 * * `data_initializer` for this is a `/datum/blood_data` instance.
 *
 * Data format:
 *
 * list(
 *     /datum/blood_data instance,
 *     ...
 * )
 */
/datum/reagent/blood
	holds_data = TRUE
	#warn nuke this
	data = new/list("donor" = null,
		"viruses" = null,
		"species" = SPECIES_HUMAN,
		"blood_DNA" = null,
		"blood_type" = null,
		"blood_colour" = "#A10808",
		"resistances" = null,
		"trace_chem" = null,
		"antibodies" = list())
	name = "Blood"
	id = "blood"
	taste_description = "iron"
	taste_mult = 1.3
	reagent_state = REAGENT_LIQUID
	metabolism = REM * 5
	mrate_static = TRUE
	affects_dead = 1 //so you can pump blood into someone before defibbing them
	color = "#C80000"
	var/volume_mod = 1	// So if you add different subtypes of blood, you can affect how much vessel blood each unit of reagent adds
	blood_content = 4 //How effective this is for vampires.

	glass_name = "tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

/datum/reagent/blood/initialize_data(newdata)
	..()
	if(data && data["blood_colour"])
		color = data["blood_colour"]
	return

/datum/reagent/blood/get_data() // Just in case you have a reagent that handles data differently.
	var/t = data.Copy()
	if(t["virus2"])
		var/list/v = t["virus2"]
		t["virus2"] = v.Copy()
	return t

/datum/reagent/blood/touch_turf(turf/simulated/T)
	if(!istype(T) || volume < 3)
		return
	if(!data["donor"] || istype(data["donor"], /mob/living/carbon/human))
		blood_splatter(T, src, 1)
	else if(istype(data["donor"], /mob/living/carbon/alien))
		var/obj/effect/debris/cleanable/blood/B = blood_splatter(T, src, 1)
		if(B)
			B.blood_DNA["UNKNOWN DNA STRUCTURE"] = "X*"

/datum/reagent/blood/affect_ingest(mob/living/carbon/M, alien, removed)

	var/effective_dose = dose
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
				M.inject_blood(src, volume * volume_mod)
				remove_self(volume)
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
		M.heal_organ_damage(0.2 * removed * volume_mod, 0)	// Heal brute slightly like normal nutrition. More 'effective' blood means more usable material.
		M.adjust_hydration(2 * removed) // Still has some water in the form of plasma. Hydrates less than a normal drink.
		M.add_chemical_effect(CE_BLOODRESTORE, 4 * removed) //same rating as eating nutriment

	if(data && data["virus2"])
		var/list/vlist = data["virus2"]
		if(vlist.len)
			for(var/ID in vlist)
				var/datum/disease2/disease/V = vlist[ID]
				if(V.spreadtype == "Contact")
					infect_virus2(M, V.getcopy())

/datum/reagent/blood/affect_touch(mob/living/carbon/M, alien, removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.isSynthetic())
			return
	if(alien == IS_SLIME)
		affect_ingest(M, alien, removed)
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

/datum/reagent/blood/affect_blood(mob/living/carbon/M, alien, removed)
	if(alien == IS_SLIME) //They don't have blood, so it seems weird that they would instantly 'process' the chemical like another species does.
		affect_ingest(M, alien, removed)
		return

	if(M.isSynthetic())
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		var/datum/reagent/blood/recipient = H.get_blood(H.vessel)

		if(recipient && blood_incompatible(data["blood_type"], recipient.data["blood_type"], data["species"], recipient.data["species"]))
			H.inject_blood(src, removed * volume_mod)

			if(!H.isSynthetic() && data["species"] == "synthetic") // Remember not to inject oil into your veins, it's bad for you.
				H.reagents.add_reagent("toxin", removed * 1.5)

			return

	M.inject_blood(src, volume * volume_mod)
	remove_self(volume)

/datum/reagent/blood/synthblood
	name = "Synthetic blood"
	id = "synthblood"
	color = "#999966"
	volume_mod = 2

/datum/reagent/blood/synthblood/initialize_data(newdata)
	..()
	if(data && !data["blood_type"])
		data["blood_type"] = "O-"
	return

/datum/reagent/blood/bludbloodlight
	name = "Synthetic blood"
	id = "bludbloodlight"
	color = "#999966"
	volume_mod = 2

/datum/reagent/blood/bludbloodlight/initialize_data(newdata)
	..()
	if(data && !data["blood_type"])
		data["blood_type"] = "AB+"
	return
