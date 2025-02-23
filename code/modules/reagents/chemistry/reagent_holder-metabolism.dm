/datum/reagent_holder/metabolism
	/// reagent id to /datum/reagent_metabolism
	var/list/reagent_metabolisms

	var/metabolism_class //CHEM_TOUCH, CHEM_INGEST, or CHEM_INJECT
	var/metabolism_speed = 1	// Multiplicative, 1 is full speed, 0.5 is half, etc.
	var/mob/living/carbon/parent

/datum/reagent_holder/metabolism/New(var/max = 100, mob/living/carbon/parent_mob, var/met_class = null)
	..(max, parent_mob)

	if(met_class)
		metabolism_class = met_class
	if(istype(parent_mob))
		parent = parent_mob

/datum/reagent_holder/metabolism/proc/metabolize(speed_mult = 1, force_allow_dead)

	var/metabolism_type = 0 //non-human mobs
	if(ishuman(parent))
		var/mob/living/carbon/human/H = parent
		metabolism_type = H.species.reagent_tag

	for(var/datum/reagent/current in get_reagent_datums())
		current.on_mob_life(parent, metabolism_type, src, speed_mult, force_allow_dead)
	update_total()

/datum/reagent_holder/metabolism/add_reagent(id, amount, data_initializer, skip_reactions)
	. = ..()
	LAZYINITLIST(reagent_metabolisms)
	#warn impl

/datum/reagent_holder/metabolism/remove_reagent(id, amount, skip_reactions)
	. = ..()
	LAZYINITLIST(reagent_metabolisms)
	#warn impl

// "Specialized" metabolism datums
/datum/reagent_holder/metabolism/bloodstream
	metabolism_class = CHEM_INJECT

/datum/reagent_holder/metabolism/ingested
	metabolism_class = CHEM_INGEST
	metabolism_speed = 0.5

/datum/reagent_holder/metabolism/touch
	metabolism_class = CHEM_TOUCH
