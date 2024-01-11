/datum/reagent/blood
	name = "Blood"
	id = "blood"
	taste_description = "iron"
	taste_mult = 1.3
	reagent_state = REAGENT_LIQUID
	bloodstream_metabolism_multiplier = 5
	mrate_static = TRUE
	affects_dead = 1 //so you can pump blood into someone before defibbing them
	color = "#A10808"
	blood_content = 4 //How effective this is for vampires.

	glass_name = "tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

	ingested_overdose_threshold = 5
	ingested_overdose_metabolism_multiplier = 2
	ingested_overdose_toxin_scaling = 0.25

	var/default_type = "O-"

/datum/reagent/blood/mix_data(datum/reagent_holder/holder, list/current_data, current_amount, list/new_data, new_amount)
	// kinda tragic, but, until rework, this is what we're stuck with
	// just merge-replace.
	// not like we can do otherwise anyways while still being memory-efficient
	// sucks lol.
	#warn deep merge virus2, antibodies list
	return current_data | new_data

/datum/reagent/blood/init_data(datum/reagent_holder/holder, amount, list/given_data)
	. = list(
		"blood_type" = default_type,
		"blood_color" = "#A10808",
		"species_id" = SPECIES_ID_HUMAN,
		"blood_name" = "blood",
	)
	#warn deep merge virus2, antibodies list
	if(!isnull(given_data))
		. |= given_data

/datum/reagent/blood/contact_expose_turf(turf/target, volume, list/data, vapor)
	blood_splatter(target, data, TRUE)

/datum/reagent/blood/on_metabolize_ingested(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed, obj/item/organ/internal/container)
	. = ..()

	// Treat it like nutriment for the jello, but not equivalent.
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		/// Unless it's Promethean goo, then refill this one's goo.
		if(data["species_id"] == entity.species.id)
			// shitcode, but only blood does this, generally
			entity.inject_blood(data, entity.reagents_ingested.reagent_volumes[id])
			return entity.reagents_ingested.reagent_volumes[id]

		entity.heal_organ_damage(0.2 * removed, 0.2 * removed)
		entity.adjust_nutrition(20 * removed)
		entity.add_reagent_cycle_effect(CHEMICAL_EFFECT_BLOODRESTORE, 4 * removed)
		entity.adjustToxLoss(removed / 2)
		return

	#warn below
	var/is_vampire = M.species.is_vampire
	if(is_vampire)
		handle_vampire(M, alien, removed, is_vampire)
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
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
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

/datum/reagent/blood/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)]) //They don't have blood, so it seems weird that they would instantly 'process' the chemical like another species does.
		affect_ingest(M, alien, removed)
		return

	if(M.isSynthetic())
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		var/datum/reagent/blood/recipient = H.get_blood(H.vessel)

		if(recipient && blood_incompatible_legacy(data["blood_type"], recipient.data["blood_type"], data["species"], recipient.data["species"]))
			H.inject_blood(data, removed * volume_mod)

			if(!H.isSynthetic() && data["species"] == "synthetic") // Remember not to inject oil into your veins, it's bad for you.
				H.reagents_bloodstream.add_reagent("toxin", removed * 1.5)

			return

	M.inject_blood(data, volume * volume_mod)
	remove_self(volume)

/datum/reagent/blood/synthblood
	name = "Synthetic blood"
	id = "synthblood"
	color = "#999966"
	default_type = "O-"
/datum/reagent/blood/bludbloodlight
	name = "Synthetic blood"
	id = "bludbloodlight"
	color = "#999966"
	default_type = "AB+"
