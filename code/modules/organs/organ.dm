/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	germ_level = 0
	drop_sound = 'sound/items/drop/flesh.ogg'
	pickup_sound = 'sound/items/pickup/flesh.ogg'

//! ## STRINGS VARS
	/// Unique identifier.
	var/organ_tag = "organ"
	/// The organ holding this object.
	var/parent_organ = BP_TORSO


//! STATUS VARS
	/// Various status flags
	var/status = 0
	/**
	 * Is this organ vital? If so, this being amputated / removed / dying will immediately kill someone.
	 *
	 * todo: some species shouldn't have the same organs vital as others (?)
	 */
	var/vital = FALSE
	/// Current damage to the organ
	var/damage = 0
	/// What kind of robotic organ, if valid.
	var/robotic = 0
	/// If true, this organ can't feel pain.
	var/stapled_nerves = FALSE


//! ##REFERENCE VARS
	/// Current mob owning the organ.
	var/mob/living/carbon/human/owner
	/// Transplant match data.
	var/list/transplant_data
	/// Trauma data for forensics.
	var/list/autopsy_data = list()
	/// Traces of chemicals in the organ.
	var/list/trace_chemicals = list()
	/// Original DNA.
	var/datum/dna/dna
	/// Original species.
	var/datum/species/species
	var/s_base


//! ## DAMAGE VARS
	/// Damage before considered bruised
	var/min_bruised_damage = 10
	/// Damage before becoming broken
	var/min_broken_damage = 30
	/// Damage cap
	var/max_damage
	/// Can this organ reject?
	var/can_reject = TRUE
	/// Is this organ already being rejected?
	var/rejecting
	/// Can this organ decay at all?
	var/decays = TRUE
	/// decay rate
	var/decay_rate = ORGAN_DECAY_PER_SECOND_DEFAULT

//! ## LANGUAGE VARS - For organs that assist with certain languages.
	var/list/will_assist_languages = list()
	var/list/datum/language/assists_languages = list()


//! ## VERB VARS
	/// Verbs added by the organ when present in the body.
	var/list/organ_verbs
	/// Is the parent supposed to be organic, robotic, assisted?
	var/list/target_parent_classes = list()
	/// Will the organ give its verbs when it isn't a perfect match? I.E., assisted in organic, synthetic in organic.
	var/forgiving_class = TRUE

	/// Can we butcher this organ.
	var/butcherable = TRUE
	/// What does butchering, if possible, make?
	var/meat_type

/obj/item/organ/Initialize(mapload, internal)
	. = ..(mapload)
	create_reagents(5)

	if(isliving(loc))
		owner = loc
		w_class = max(src.w_class + mob_size_difference(owner.mob_size, MOB_MEDIUM), 1) //smaller mobs have smaller organs.
		if(internal)
			if(!LAZYLEN(owner.internal_organs))
				owner.internal_organs = list()
			if(!LAZYLEN(owner.internal_organs_by_name))
				owner.internal_organs_by_name = list()

			owner.internal_organs |= src
			owner.internal_organs_by_name[organ_tag] = src

		else
			if(!LAZYLEN(owner.organs))
				owner.organs = list()
			if(!LAZYLEN(owner.organs_by_name))
				owner.organs_by_name = list()

			owner.organs |= src
			owner.organs_by_name[organ_tag] = src

	if(!max_damage)
		max_damage = min_broken_damage * 2

	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		species = SScharacters.resolve_species_path(/datum/species/human)
		if(owner.dna)
			dna = C.dna.Clone()
			species = C.species //For custom species
			if(ishuman(C))
				var/mob/living/carbon/human/H = C
				s_base = LAZYACCESS(species.base_skin_colours, H.s_base)
		else
			stack_trace("[src] at [loc] spawned without a proper DNA.")
		var/mob/living/carbon/human/H = C
		if(istype(H))
			if(internal)
				var/obj/item/organ/external/E = H.get_organ(parent_organ)
				if(E)
					if(E.internal_organs == null)
						E.internal_organs = list()
					E.internal_organs |= src
			if(dna)
				if(!blood_DNA)
					blood_DNA = list()
				blood_DNA[dna.unique_enzymes] = dna.b_type
	else
		species = SScharacters.resolve_species_path(/datum/species/human)

	if(owner)
		if(!meat_type)
			if(owner.isSynthetic())
				meat_type = /obj/item/stack/material/steel
			else if(ishuman(owner))
				var/mob/living/carbon/human/H = owner
				meat_type = H?.species?.meat_type

			if(!meat_type)
				if(owner.meat_type)
					meat_type = owner.meat_type
				else
					meat_type = /obj/item/reagent_containers/food/snacks/meat

	handle_organ_mod_special()

/obj/item/organ/Destroy()
	handle_organ_mod_special(TRUE)
	STOP_PROCESSING(SSobj, src)
	if(owner)
		owner = null
	if(transplant_data)
		transplant_data.Cut()
	if(autopsy_data)
		autopsy_data.Cut()
	if(trace_chemicals)
		trace_chemicals.Cut()
	dna = null
	species = null
	return ..()

/obj/item/organ/proc/update_health()
	// TODO: refactor, this should only be on internal!
	if(damage >= max_damage)
		die()

/obj/item/organ/proc/set_dna(datum/dna/new_dna)
	if(new_dna)
		dna = new_dna.Clone()
		if(blood_DNA)
			blood_DNA.Cut()
			blood_DNA[dna.unique_enzymes] = dna.b_type

	s_base = new_dna.s_base

/obj/item/organ/proc/is_dead()
	return (status & ORGAN_DEAD)

/**
 * Checks if we can currently die.
 */
/obj/item/organ/proc/can_die()
	return (robotic < ORGAN_ROBOT)

/**
 * Called to kill this organ.
 *
 * @params
 * * force - ignore can_die()
 *
 * @return TRUE / FALSE based on if this actually killed the organ. Returns TRUE if the organ was already dead.
 */
/obj/item/organ/proc/die(force = FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!can_die() && !force)
		return FALSE
	if(is_dead())
		return TRUE
	status |= ORGAN_DEAD
	damage = max_damage
	on_die()
	if(owner)
		handle_organ_mod_special(TRUE)
		if(vital)
			owner.death()
	reconsider_processing()
	return TRUE

/**
 * Called when we die (*not* our owner).
 */
/obj/item/organ/proc/on_die()
	return

/**
 * Checks if we're currently able to be revived.
 */
/obj/item/organ/proc/can_revive()
	return damage < max_damage

/**
 * Called to heal all damages
 */
/obj/item/organ/proc/rejuvenate()
	damage = 0
	germ_level = 0

/**
 * Called to bring us back to life.
 *
 * @params
 * * full_heal - heal all maladies
 * * force - ignore can_revive()
 *
 * @return TRUE / FALSE based on if this actually ended up reviving the organ. Returns TRUE if organ was already alive.
 */
/obj/item/organ/proc/revive(full_heal = FALSE, force = FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(full_heal)
		rejuvenate()
	if(!is_dead())
		return TRUE
	if(!can_revive() && !force)
		return FALSE
	status &= ~ORGAN_DEAD
	on_revive()
	if(owner)
		handle_organ_mod_special(FALSE)
	reconsider_processing()
	return TRUE

/**
 * Called when we're brought back to life.
 */
/obj/item/organ/proc/on_revive()
	return

/obj/item/organ/proc/adjust_germ_level(var/amount)		// Unless you're setting germ level directly to 0, use this proc instead
	germ_level = clamp(germ_level + amount, 0, INFECTION_LEVEL_MAX)

/obj/item/organ/examine(mob/user)
	. = ..()
	if(status & ORGAN_DEAD)
		. += "<span class='notice'>The decay has set in.</span>"

/obj/item/organ/proc/receive_chem(chemical as obj)
	return 0

/obj/item/organ/proc/remove_rejuv()
	qdel(src)

/obj/item/organ/proc/rejuvenate_legacy(var/ignore_prosthetic_prefs)
	damage = 0
	status = 0
	germ_level = 0
	if(owner)
		handle_organ_mod_special()
	if(!ignore_prosthetic_prefs && owner && owner.client && owner.client.prefs && owner.client.prefs.real_name == owner.real_name)
		var/status = owner.client.prefs.organ_data[organ_tag]
		if(status == "assisted")
			mechassist()
		else if(status == "mechanical")
			robotize()

/obj/item/organ/proc/is_damaged()
	return damage > 0

/obj/item/organ/proc/is_bruised()
	return damage >= min_bruised_damage

/obj/item/organ/proc/is_broken()
	return (damage >= min_broken_damage || (status & ORGAN_CUT_AWAY) || (status & ORGAN_BROKEN))

///Adds autopsy data for used_weapon.
/obj/item/organ/proc/add_autopsy_data(var/used_weapon, var/damage)
	var/datum/autopsy_data/W = autopsy_data[used_weapon]
	if(!W)
		W = new()
		W.weapon = used_weapon
		autopsy_data[used_weapon] = W

	W.hits += 1
	W.damage += damage
	W.time_inflicted = world.time

//Note: external organs have their own version of this proc
/obj/item/organ/take_damage(amount, var/silent=0)
	ASSERT(amount >= 0)
	if(src.robotic >= ORGAN_ROBOT)
		src.damage = between(0, src.damage + (amount * 0.8), max_damage)
	else
		src.damage = between(0, src.damage + amount, max_damage)

		//only show this if the organ is not robotic
		if(owner && parent_organ && amount > 0)
			var/obj/item/organ/external/parent = owner?.get_organ(parent_organ)
			if(parent && !silent)
				owner.custom_pain("Something inside your [parent.name] hurts a lot.", amount)

/obj/item/organ/proc/bruise()
	damage = max(damage, min_bruised_damage)

/// Being used to make robutt hearts, etc
/obj/item/organ/proc/robotize()
	robotic = ORGAN_ROBOT
	src.status &= ~ORGAN_BROKEN
	src.status &= ~ORGAN_BLEEDING
	src.status &= ~ORGAN_CUT_AWAY

/// Used to add things like pacemakers, etc
/obj/item/organ/proc/mechassist()
	robotize()
	robotic = ORGAN_ASSISTED
	min_bruised_damage = 15
	min_broken_damage = 35
	butcherable = FALSE

///Used to make the circuit-brain. On this level in the event more circuit-organs are added/tweaks are wanted.
/obj/item/organ/proc/digitize()
	robotize()

/obj/item/organ/emp_act(severity)
	if(!(robotic >= ORGAN_ASSISTED))
		return
	for(var/i = 1; i <= robotic; i++)
		switch (severity)
			if (1)
				take_damage(rand(5,9))
			if (2)
				take_damage(rand(3,7))
			if (3)
				take_damage(rand(2,5))
			if (4)
				take_damage(rand(1,3))

/obj/item/organ/proc/removed(var/mob/living/user)
	if(owner)
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		owner.internal_organs_by_name -= null
		owner.internal_organs -= src

		var/obj/item/organ/external/affected = owner.get_organ(parent_organ)
		if(affected) affected.internal_organs -= src

		forceMove(owner.drop_location())
		rejecting = null

	if(istype(owner))
		var/datum/reagent/blood/organ_blood = locate(/datum/reagent/blood) in reagents.reagent_list
		if(!organ_blood || !organ_blood.data["blood_DNA"])
			owner.vessel.trans_to(src, 5, 1, 1)

		if(owner && vital)
			if(user)
				add_attack_logs(user, owner, "Removed vital organ [src.name]")
			if(owner.stat != DEAD)
				owner.can_defib = 0
				owner.death()

	handle_organ_mod_special(TRUE)
	owner = null
	reconsider_processing()

/obj/item/organ/proc/replaced(var/mob/living/carbon/human/target,var/obj/item/organ/external/affected)

	if(!istype(target)) return

	var/datum/reagent/blood/transplant_blood = locate(/datum/reagent/blood) in reagents.reagent_list
	transplant_data = list()
	if(!transplant_blood)
		transplant_data["species"] =    target?.species.name
		transplant_data["blood_type"] = target?.dna.b_type
		transplant_data["blood_DNA"] =  target?.dna.unique_enzymes
	else
		transplant_data["species"] =    transplant_blood?.data["species"]
		transplant_data["blood_type"] = transplant_blood?.data["blood_type"]
		transplant_data["blood_DNA"] =  transplant_blood?.data["blood_DNA"]

	owner = target
	loc = owner
	target.internal_organs |= src
	affected.internal_organs |= src
	target.internal_organs_by_name[organ_tag] = src
	handle_organ_mod_special()
	reconsider_processing()

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

/**
 * can we decay?
 */
/obj/item/organ/proc/can_decay()
	return CONFIG_GET(flag/organ_decay) && !HAS_TRAIT(src, TRAIT_ORGAN_PRESERVED) && (!loc || !HAS_TRAIT(loc, TRAIT_ORGAN_PRESERVED)) && (!owner || !HAS_TRAIT(owner, TRAIT_PRESERVE_ALL_ORGANS)) && decays

/**
 * preserved trait wrapper
 */
/obj/item/organ/proc/preserve(source)
	ASSERT(source)
	ADD_TRAIT(src, TRAIT_ORGAN_PRESERVED, source)
	reconsider_processing()

/**
 * preserved trait wrapper
 */
/obj/item/organ/proc/unpreserve(source)
	ASSERT(source)
	REMOVE_TRAIT(src, TRAIT_ORGAN_PRESERVED, source)
	reconsider_processing()

//Germs
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

/obj/item/organ/proc/bitten(mob/user)

	if(robotic >= ORGAN_ROBOT)
		return

	to_chat(user, SPAN_NOTICE("You take an experimental bite out of \the [src]."))
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
	blood_splatter(src,B,1)

	user.temporarily_remove_from_inventory(src, INV_OP_FORCE)

	var/obj/item/reagent_containers/food/snacks/organ/O = new(get_turf(src))
	O.name = name
	O.icon = icon
	O.icon_state = icon_state

	// Pass over the blood.
	reagents.trans_to(O, reagents.total_volume)

	if(fingerprints)
		O.fingerprints = fingerprints.Copy()
	if(fingerprintshidden)
		O.fingerprintshidden = fingerprintshidden.Copy()
	if(fingerprintslast)
		O.fingerprintslast = fingerprintslast

	user.put_in_active_hand(O)
	qdel(src)

/obj/item/organ/attack_self(mob/user as mob)

	// Convert it to an edible form, yum yum.
	if(!(robotic >= ORGAN_ROBOT) && user.a_intent == INTENT_HELP && user.zone_sel.selecting == O_MOUTH)
		bitten(user)
		return

/obj/item/organ/attackby(obj/item/W as obj, mob/user as mob)
	if(can_butcher(W, user))
		butcher(W, user)
		return

	return ..()

/obj/item/organ/proc/can_butcher(var/obj/item/O, var/mob/living/user)
	if(butcherable && meat_type)

		if(istype(O, /obj/machinery/gibber))	// The great equalizer.
			return TRUE

		if(robotic >= ORGAN_ROBOT)
			if(O.is_screwdriver())
				return TRUE

		else
			if(is_sharp(O) && has_edge(O))
				return TRUE

	return FALSE

/obj/item/organ/proc/butcher(var/obj/item/O, var/mob/living/user, var/atom/newtarget)
	if(robotic >= ORGAN_ROBOT)
		user?.visible_message(SPAN_NOTICE("[user] disassembles \the [src]."))

	else
		user?.visible_message(SPAN_NOTICE("[user] butchers \the [src]."))

	if(!newtarget)
		newtarget = get_turf(src)

	var/obj/item/newmeat = new meat_type(newtarget)

	if(istype(newmeat, /obj/item/reagent_containers/food/snacks/meat))
		newmeat.name = "[src.name] [newmeat.name]"	// "liver meat" "heart meat", etc.

	qdel(src)


/obj/item/organ/proc/organ_can_feel_pain()
	if(species.species_flags & NO_PAIN)
		return FALSE
	if(status & ORGAN_DESTROYED)
		return FALSE
	if(robotic && robotic < ORGAN_LIFELIKE)	//Super fancy humanlike robotics probably have sensors, or something?
		return FALSE
	if(stapled_nerves)
		return FALSE
	return 1

/obj/item/organ/proc/handle_organ_mod_special(var/removed = FALSE)	// Called when created, transplanted, and removed.
	// todo: better way
	if(owner)
		rad_flags |= RAD_NO_CONTAMINATE
	else
		rad_flags &= ~RAD_NO_CONTAMINATE

	if(!istype(owner))
		return

	var/list/save_verbs = list()

	if(removed && organ_verbs)	// Do we share verbs with any other organs? Are they functioning?
		var/list/all_organs = list()
		all_organs |= owner.organs
		all_organs |= owner.internal_organs

		for(var/obj/item/organ/O in all_organs)
			if(!(O.status & ORGAN_DEAD) && O.organ_verbs && O.check_verb_compatability())
				for(var/verb_type in O.organ_verbs)
					if(verb_type in organ_verbs)
						save_verbs |= verb_type

	if(!removed && organ_verbs && check_verb_compatability())
		for(var/verb_path in organ_verbs)
			add_verb(owner, verb_path)
	else if(organ_verbs)
		for(var/verb_path in organ_verbs)
			if(!(verb_path in save_verbs))
				remove_verb(owner, verb_path)
	return

/// Called when processed.
/obj/item/organ/proc/handle_organ_proc_special()
	return

/// Used for determining if an organ should give or remove its verbs. I.E., FBP part in a human, no verbs. If true, keep or add.
/obj/item/organ/proc/check_verb_compatability()
	if(owner)
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			var/obj/item/organ/O = H.get_organ(parent_organ)
			if(forgiving_class)
				if(O.robotic <= ORGAN_ASSISTED && robotic <= ORGAN_LIFELIKE)	// Parent is organic or assisted, we are at most synthetic.
					return TRUE

				if(O.robotic >= ORGAN_ROBOT && robotic >= ORGAN_ASSISTED)		// Parent is synthetic, and we are biosynthetic at least.
					return TRUE

			if(!target_parent_classes || !target_parent_classes.len)	// Default checks, if we're not looking for a Specific type.

				if(O.robotic == robotic)	// Same thing, we're fine.
					return TRUE

				if(O.robotic < ORGAN_ROBOT && robotic < ORGAN_ROBOT)
					return TRUE

				if(O.robotic > ORGAN_ASSISTED && robotic > ORGAN_ASSISTED)
					return TRUE

			else
				if(O.robotic in target_parent_classes)
					return TRUE

	return FALSE

/obj/item/organ/proc/refresh_action_button()
	return action

// todo: unified organ damage system
// for now, this is how to heal internal organs
/obj/item/organ/proc/heal_damage_i(amount, force, can_revive)
	ASSERT(amount > 0)
	var/dead = !!(status & ORGAN_DEAD)
	if(dead && !force && !can_revive)
		return FALSE
	//? which is better again..?
	// damage = clamp(damage - round(amount, DAMAGE_PRECISION), 0, max_damage)
	damage = clamp(round(damage - amount, DAMAGE_PRECISION), 0, max_damage)
	if(dead && can_revive)
		revive()
