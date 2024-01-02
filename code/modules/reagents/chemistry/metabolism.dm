/datum/reagents/metabolism
	var/metabolism_class //REAGENT_APPLY_TOUCH, REAGENT_APPLY_INGEST, or REAGENT_APPLY_INJECT
	var/metabolism_speed = 1	// Multiplicative, 1 is full speed, 0.5 is half, etc.
	var/mob/living/carbon/parent

/datum/reagents/metabolism/New(var/max = 100, mob/living/carbon/parent_mob, var/met_class = null)
	..(max, parent_mob)

	if(met_class)
		metabolism_class = met_class
	if(istype(parent_mob))
		parent = parent_mob

/datum/reagents/metabolism/proc/metabolize(speed_mult = 1, force_allow_dead)

	var/metabolism_type = 0 //non-human mobs
	if(ishuman(parent))
		var/mob/living/carbon/human/H = parent
		metabolism_type = H.species.reagent_tag

	for(var/datum/reagent/current in reagent_list)
		current.on_mob_life(parent, metabolism_type, src, speed_mult, force_allow_dead)
	update_total()

// "Specialized" metabolism datums
/datum/reagents/metabolism/bloodstream
	metabolism_class = REAGENT_APPLY_INJECT

/datum/reagents/metabolism/ingested
	metabolism_class = REAGENT_APPLY_INGEST
	metabolism_speed = 0.5

/datum/reagents/metabolism/touch
	metabolism_class = REAGENT_APPLY_TOUCH
