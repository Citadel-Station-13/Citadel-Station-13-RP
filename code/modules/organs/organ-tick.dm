
/**
 * called while alive
 *
 * preconditions: owner is a /mob
 */
/obj/item/organ/proc/tick_life(dt)
	if(loc != owner)
		stack_trace("organ outside of owner automatically yanked from owner. owner was [owner] ([REF(owner)]), src was [src] ([REF(src)])")
		owner = null
		return

	handle_organ_proc_special()

	//Process infections
	if(robotic >= ORGAN_ROBOT || (istype(owner) && (owner.species && (owner.species.species_flags & (IS_PLANT | NO_INFECT)))))
		germ_level = 0
		return

	if(owner?.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Handle antibiotics and curing infections
		handle_antibiotics()
		handle_rejection()
		handle_germ_effects()

/**
 * called while dead
 *
 * preconditions: owner is a /mob
 */
/obj/item/organ/proc/tick_death(dt)
	if(loc != owner)
		stack_trace("organ outside of owner automatically yanked from owner. owner was [owner] ([REF(owner)]), src was [src] ([REF(src)])")
		owner = null
		return

	handle_organ_proc_special()

	//Process infections
	if(robotic >= ORGAN_ROBOT || (istype(owner) && (owner.species && (owner.species.species_flags & (IS_PLANT | NO_INFECT)))))
		germ_level = 0
		return

	// removal temporary, pending health rework
	// if(owner?.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
	// 	//** Handle antibiotics and curing infections
	// 	handle_antibiotics()
	// 	handle_rejection()
	// 	handle_germ_effects()

	if(can_decay())
		handle_decay(dt)
	else
		reconsider_processing()
	update_health()

/**
 * called while removed from a mob
 */
/obj/item/organ/proc/tick_removed(dt)
	handle_organ_proc_special()

	if(can_decay())
		handle_decay(dt)
	else
		reconsider_processing()
	update_health()

	//Process infections
	if(reagents)
		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
		if(B && prob(40))
			reagents.remove_reagent("blood",0.1)
			blood_splatter(src,B,1)
		adjust_germ_level(rand(2,6))
		if(germ_level >= INFECTION_LEVEL_TWO)
			adjust_germ_level(rand(2,6))
		if(germ_level >= INFECTION_LEVEL_THREE)
			die()

/obj/item/organ/proc/handle_decay(dt)
	var/multiplier = CONFIG_GET(number/organ_decay_multiplier)
	take_damage(dt * decay_rate * multiplier, TRUE)

/**
 * do we need to process?
 * do NOT check owner for removed, listen to the params!
 * do NOT check owner for life/dead, listen to the params!
 *
 * ! DO NOT RELY ON THIS TO STOP PROCESSING.
 * Define your tick_life, tick_death, tick_removed properly!
 *
 * @params
 * - locality - check [code/__DEFINES/mobs/organs.dm]
 */
/obj/item/organ/proc/should_process(locality)
	switch(locality)
		if(ORGAN_LOCALITY_REMOVED)
			return can_decay() && !is_dead()
		if(ORGAN_LOCALITY_IN_LIVING_MOB)
			return TRUE
		if(ORGAN_LOCALITY_IN_DEAD_MOB)
			return can_decay() && !is_dead()

/**
 * reconsider if we need to process
 */
/obj/item/organ/proc/reconsider_processing()
	if(owner)
		// we're in someone we'll always tick from their handle_organs so don't process externally
		STOP_PROCESSING(SSobj, src)
		return
	// we're not in someone
	if(should_process(ORGAN_LOCALITY_REMOVED))
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/organ/proc/handle_antibiotics()
	if(istype(owner))
		var/antibiotics = owner.chem_effects[CE_ANTIBIOTIC] || 0

		if (!germ_level || antibiotics < ANTIBIO_NORM)
			return

		// Cure instantly
		if (germ_level < INFECTION_LEVEL_ONE)
			germ_level = 0

		/// At germ_level < 500, this should cure the infection in a minute
		else if (germ_level < INFECTION_LEVEL_TWO)
			adjust_germ_level(-antibiotics*4)

		/// At germ_level < 1000, this will cure the infection in 5 minutes
		else if (germ_level < INFECTION_LEVEL_THREE)
			adjust_germ_level(-antibiotics*2)

		else
			/// You waited this long to get treated, you don't really deserve this organ.
			adjust_germ_level(-antibiotics)

///A little wonky: internal organs stop calling this (they return early in process) when dead, but external ones cause further damage when dead
/obj/item/organ/proc/handle_germ_effects()
	//* Handle the effects of infections
	if(robotic >= ORGAN_ROBOT) //Just in case!
		germ_level = 0
		return 0

	var/antibiotics = iscarbon(owner) ? owner.chem_effects[CE_ANTIBIOTIC] || 0 : 0

	var/infection_damage = 0

	//* Infection damage *//

	//If the organ is dead, for the sake of organs that may have died due to non-infection, we'll only do damage if they have at least L1 infection (built up below)
	if((status & ORGAN_DEAD) && antibiotics < ANTIBIO_OD && germ_level >= INFECTION_LEVEL_ONE)
		infection_damage = max(1, 1 + round((germ_level - INFECTION_LEVEL_THREE)/200,0.25)) //1 Tox plus a little based on germ level

	else if(germ_level > INFECTION_LEVEL_TWO && antibiotics < ANTIBIO_OD)
		infection_damage = max(0.25, 0.25 + round((germ_level - INFECTION_LEVEL_TWO)/200,0.25))

	if(infection_damage)
		owner.adjustToxLoss(infection_damage)

	if (germ_level > 0 && germ_level < INFECTION_LEVEL_ONE/2 && prob(30))
		adjust_germ_level(-antibiotics)

	//* Germ Accumulation

	//Dead organs accumulate germs indefinitely
	if(status & ORGAN_DEAD)
		adjust_germ_level(1) 

	//Half of level 1 is growing but harmless
	if (germ_level >= INFECTION_LEVEL_ONE/2)
		//aiming for germ level to go from ambient to INFECTION_LEVEL_TWO in an average of 15 minutes
		if(!antibiotics && prob(round(germ_level/6)))
			adjust_germ_level(1)

	//Level 1 qualifies for specific organ processing effects
	if(germ_level >= INFECTION_LEVEL_ONE)
		. = 1 //Organ qualifies for effect-specific processing
		//var/fever_temperature = (owner.species.heat_level_1 - owner.species.body_temperature - 5)* min(germ_level/INFECTION_LEVEL_TWO, 1) + owner.species.body_temperature
		//owner.bodytemperature += between(0, (fever_temperature - T20C)/BODYTEMP_COLD_DIVISOR + 1, fever_temperature - owner.bodytemperature)
		var/fever_temperature = owner?.species.heat_discomfort_level * 1.10 //Heat discomfort level plus 10%
		if(owner?.bodytemperature < fever_temperature)
			owner?.bodytemperature += min(0.2,(fever_temperature - owner?.bodytemperature) / 10) //Will usually climb by 0.2, else 10% of the difference if less

	//Level two qualifies for further processing effects
	if (germ_level >= INFECTION_LEVEL_TWO)
		. = 2 //Organ qualifies for effect-specific processing
		//No particular effect on the general 'organ' at 3

	//Level three qualifies for significant growth and further effects
	if (germ_level >= INFECTION_LEVEL_THREE && antibiotics < ANTIBIO_OD)
		. = 3 //Organ qualifies for effect-specific processing
		adjust_germ_level(rand(5,10)) //Germ_level increases without overdose of antibiotics

/obj/item/organ/proc/handle_rejection()
	// Process unsuitable transplants. TODO: consider some kind of
	// immunosuppressant that changes transplant data to make it match.
	if(dna && can_reject)
		if(!rejecting)
			if(blood_incompatible(dna.b_type, owner.dna.b_type, species.name, owner.species.name)) // Process species by name.
				rejecting = 1
		else
			rejecting++ //Rejection severity increases over time.
			if(rejecting % 10 == 0) //Only fire every ten rejection ticks.
				switch(rejecting)
					if(1 to 50)
						adjust_germ_level(1)
					if(51 to 200)
						adjust_germ_level(rand(1,2))
					if(201 to 500)
						adjust_germ_level(rand(2,3))
					if(501 to INFINITY)
						adjust_germ_level(rand(3,5))
						owner.reagents.add_reagent("toxin", rand(1,2))

/// Called when processed.
/obj/item/organ/proc/handle_organ_proc_special()
	return
