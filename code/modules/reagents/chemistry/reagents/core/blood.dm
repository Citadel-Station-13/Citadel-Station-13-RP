// todo: stuff in this file might need to be moved somewhere else, this being in reagents/core is weird.

/**
 * Blood holder.
 *
 * This is basically just a blood mixture datum but permanent. Caching is more pronounced,
 * and things can be stored that otherwise wouldn't be because we're considered cheap to store.
 *
 * * We own all fragments in us. We always copy when giving references, and always copy
 *   when accepting references.
 */
/datum/blood_holder
	/// Our host blood.
	var/datum/blood_fragment/host_blood
	/// Amount of host blood we have
	var/host_blood_volume = 0
	/// Our fragments that aren't ourselves, associated to amount.
	var/list/datum/blood_fragment/guest_bloods
	/// Total amount of guest blood volume
	var/guest_blood_volume = 0

	//! legacy crap !//
	var/list/legacy_antibodies
	var/list/legacy_virus2
	var/legacy_trace_chem
	//! end !//

/datum/blood_holder/proc/set_host_fragment_to(datum/blood_fragment/fragment)
	host_blood = fragment.clone()

/datum/blood_holder/proc/set_host_volume(amount)
	host_blood_volume = amount

/datum/blood_holder/proc/adjust_host_volume(amount)
	host_blood_volume = max(host_blood_volume + amount, 0)

/datum/blood_holder/proc/set_volume(datum/blood_fragment/fragment, amount)
	#warn impl

/datum/blood_holder/proc/adjust_volume(datum/blood_fragment/fragment, amount)
	#warn impl

/datum/blood_holder/proc/get_total_volume()
	return host_blood_volume + guest_blood_volume

/**
 * Takes a blood mixture from us.
 *
 * * Expensive.
 *
 * @params
 * * amount - amount to take
 * * infinite - don't actually take any, and allow drawing any amount
 *
 * @return mixture taken
 */
/datum/blood_holder/proc/take_blood_mixture(amount, infinite) as /datum/blood_mixture
	var/datum/blood_mixture/creating = new
	if(legacy_antibodies)
		creating.legacy_antibodies = legacy_antibodies.Copy()
	if(legacy_virus2)
		creating.legacy_virus2 = legacy_virus2.Copy()
	if(legacy_trace_chem)
		creating.legacy_trace_chem = legacy_trace_chem
	creating.fragments = list()
	#warn impl fragments self/others
	return creating

/**
 * Reagent blood data
 */
/datum/blood_mixture
	var/list/legacy_antibodies
	var/list/legacy_virus2
	#warn uhh
	var/legacy_trace_chem

	/// Fragments, associated to **ratio of total**.
	var/list/datum/blood_fragment/fragments

	/// The total amount of all of our fragments
	/// * Only useful in a return-value context. This is to avoid needing to recalcualte this.
	/// * This can, in-fact, be '0'.
	/// * In a reagent / storage context, the reagent's volume will always supercede this.
	/// * This is not copied during a clone, as it's purely return-value context.
	var/tmp/ctx_return_amount = 0

/datum/blood_mixture/clone(include_contents)
	var/datum/blood_mixture/copy = new /datum/blood_mixture
	if(legacy_trace_chem)
		copy.legacy_trace_chem = legacy_trace_chem
	if(legacy_antibodies)
		copy.legacy_antibodies = legacy_antibodies
	if(legacy_virus2)
		copy.legacy_virus2 = legacy_virus2
	if(length(fragments))
		copy.fragments = list()
		for(var/datum/blood_fragment/data as anything in fragments)
			copy.fragments[data.clone()] = fragments[data]
	return copy

/**
 * Reagent blood data
 */
/datum/blood_fragment
	/// the blood's color
	var/color

	//! LEGACY FIELDS
	var/legacy_species
	var/legacy_blood_dna
	var/legacy_blood_type
	var/legacy_donor
	var/legacy_name
	//! END

/datum/blood_fragment/clone(include_contents)
	var/datum/blood_fragment/copy = new /datum/blood_fragment
	copy.color = color
	if(legacy_blood_dna)
		copy.legacy_blood_dna = legacy_blood_dna
	if(legacy_blood_type)
		copy.legacy_blood_type = legacy_blood_type
	if(legacy_donor)
		copy.legacy_donor = legacy_donor
	if(legacy_name)
		copy.legacy_name = legacy_name
	if(legacy_species)
		copy.legacy_species = legacy_species
	return copy

/**
 * Checks if other is equivalent to self.
 *
 * * We intentionally do not check color. It's too expensive to, given this is used for
 *   deduping.
 * * We intentionally do not check name. It's too expensive to, given this is used for
 *   deduping.
 * * This implies that color / name should implicitly be the same if this proc returns TRUE
 *   for two given blood fragments.
 */
/datum/blood_fragment/proc/equivalent(datum/blood_fragment/other)
	if(other.legacy_species != src.legacy_species)
		return FALSE
	if(other.legacy_blood_dna != src.legacy_blood_dna)
		return FALSE
	if(other.legacy_blood_type != src.legacy_blood_type)
		return FALSE
	return TRUE

/**
 * Blood.
 *
 * I'm not sure what you expected this to say.
 *
 * * `data_initializer` for this is a `/datum/blood_fragment` instance.
 *
 * Data format:
 *
 * list(
 *     /datum/blood_fragment/reagent instance,
 *     ...
 * )
 */
/datum/reagent/blood
	name = "Blood"
	id = "blood"
	taste_description = "iron"
	taste_mult = 1.3
	reagent_state = REAGENT_LIQUID
	metabolism = REM * 5
	mrate_static = TRUE
	affects_dead = 1 //so you can pump blood into someone before defibbing them
	color = "#A80000"
	holds_data = TRUE
	var/volume_mod = 1	// So if you add different subtypes of blood, you can affect how much vessel blood each unit of reagent adds
	blood_content = 4 //How effective this is for vampires.

	glass_name = "tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

/datum/reagent/blood/make_copy_data_initializer(datum/blood_mixture/data)
	return data

/datum/reagent/blood/mix_data(datum/blood_mixture/old_data, old_volume, datum/blood_mixture/new_data, new_volume, datum/reagent_holder/holder)
	. = ..()
	#warn impl ; hard limit of 10 blood instances. also, dedupe. also, never evict holder's blood,

/datum/reagent/blood/touch_turf(turf/simulated/T)
	if(!istype(T) || volume < 3)
		return
	if(!data["donor"] || istype(data["donor"], /mob/living/carbon/human))
		blood_splatter(T, src, 1)
	else if(istype(data["donor"], /mob/living/carbon/alien))
		var/obj/effect/debris/cleanable/blood/B = blood_splatter(T, src, 1)
		if(B)
			B.blood_DNA["UNKNOWN DNA STRUCTURE"] = "X*"

/datum/reagent/blood/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)

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

// todo: this should be the same as /datum/reagent/blood!
/datum/reagent/blood/synthblood
	name = "Synthetic blood"
	id = "synthblood"
	color = "#999966"
	volume_mod = 2

/datum/reagent/blood/synthblood/initialize_data(newdata)
	..()
	if(data && !data["blood_type"])
		data["blood_type"] = "O-"

// todo: this should be the same as /datum/reagent/blood!
/datum/reagent/blood/bludbloodlight
	name = "Synthetic blood"
	id = "bludbloodlight"
	color = "#999966"
	volume_mod = 2

// todo: this should be the same as /datum/reagent/blood!
/datum/reagent/blood/bludbloodlight/initialize_data(newdata)
	..()
	if(data && !data["blood_type"])
		data["blood_type"] = "AB+"
