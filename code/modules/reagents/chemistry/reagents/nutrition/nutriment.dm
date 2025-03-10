/**
 * datastruct for nutriment data.
 */
/datum/nutriment_data
	/// were we cooked?
	var/cooked = FALSE
	/// taste list as "description" = amount
	///
	/// * always sorted from largest to least
	var/list/taste
	/// total taste amount used for blending
	var/taste_total = 0

/datum/nutriment_data/proc/set_taste(description, amount)
	LAZYSET(taste, description, amount)

/datum/nutriment_data/proc/add_taste(description, amount, skip_culling)
	LAZYINITLIST(taste)
	taste[description] = taste[description] + amount

	if(!skip_culling)
		cull_taste()

/datum/nutriment_data/proc/remove_taste(description, amount)
	if(!amount)
		LAZYREMOVE(taste, description)
	else if(taste[description])
		taste[description] -= amount
		if(taste[description] <= 0)
			taste -= description

/datum/nutriment_data/proc/cull_taste()
	// this should be a define (10 being max) but idrc lol
	tim_sort(taste, /proc/cmp_numeric_dsc, TRUE)
	taste?.len = min(length(taste), 10)

/datum/nutriment_data/proc/merge_from(datum/nutriment_data/source)
	for(var/description in source.taste)
		var/power = source.taste[description]
		add_taste(description, power, TRUE)
	cull_taste()
	cooked ||= source.cooked

/datum/nutriment_data/clone(include_contents)
	var/datum/nutriment_data/copying = new
	copying.cooked = cooked
	copying.taste = taste?.Copy()
	copying.taste_total = taste_total
	return copying

/datum/nutriment_data/static_spawn_initializer
	cooked = TRUE

/**
 * * data: /datum/nutriment_data
 */
/datum/reagent/nutriment
	name = "Nutriment"
	id = "nutriment"
	holds_data = TRUE
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	taste_mult = 4
	reagent_state = REAGENT_SOLID
	metabolism_rate = REM * 4
	ingest_met = REM * 4
	var/nutriment_factor = 30 // Per unit
	var/hydration_factor = 0 //Per unit
	var/injectable = 0
	color = "#664330"

/datum/reagent/nutriment/make_copy_data_initializer(datum/nutriment_data/data)
	return data

/datum/reagent/nutriment/preprocess_data(datum/nutriment_data/data_initializer)
	return data_initializer

/datum/reagent/nutriment/mix_data(datum/nutriment_data/old_data, old_volume, datum/nutriment_data/new_data, new_volume, datum/reagent_holder/holder)
	if(!istype(new_data))
		return old_data
	old_data.merge_from(new_data)
	return old_data

/datum/reagent/nutriment/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(!injectable && alien != IS_SLIME && alien != IS_CHIMERA)
		M.adjustToxLoss(0.1 * removed)
		return
	legacy_affect_ingest(M, alien, removed, metabolism)

/datum/reagent/nutriment/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	switch(alien)
		if(IS_DIONA)
			return
		if(IS_UNATHI)
			removed *= 0.5
		if(IS_CHIMERA)
			removed *= 0.25
			if(issmall(M))
				removed *= 2 // Small bodymass, more effect from lower volume.
	M.heal_organ_damage(0.5 * removed, 0)
	if(!M.species.is_vampire && !(M.species.species_flags & NO_NUTRITION_GAIN)) // If this is set to 0, they don't get nutrition from food.
		M.nutrition += nutriment_factor * removed // For hunger and fatness
	M.adjust_hydration(hydration_factor * removed)
	M.add_chemical_effect(CE_BLOODRESTORE, 4 * removed)
