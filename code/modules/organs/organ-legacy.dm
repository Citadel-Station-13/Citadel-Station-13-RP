
/obj/item/organ/proc/set_dna(datum/dna/new_dna)
	if(new_dna)
		dna = new_dna.Clone()
		if(blood_DNA)
			blood_DNA.Cut()
			blood_DNA[dna.unique_enzymes] = dna.b_type

	s_base = new_dna.s_base

/obj/item/organ/proc/adjust_germ_level(var/amount)		// Unless you're setting germ level directly to 0, use this proc instead
	germ_level = clamp(germ_level + amount, 0, INFECTION_LEVEL_MAX)

/obj/item/organ/examine(mob/user, dist)
	. = ..()
	if(status & ORGAN_DEAD)
		. += "<span class='notice'>The decay has set in.</span>"

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

#warn obliterate
/obj/item/organ/proc/removed(var/mob/living/user)
	if(owner)
		var/obj/item/organ/external/affected = owner.legacy_organ_by_zone(parent_organ)
		if(affected)
			affected.internal_organs -= src

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

	owner = null
	reconsider_processing()

#warn obliterate
/obj/item/organ/proc/replaced(var/mob/living/carbon/human/target,var/obj/item/organ/external/affected)
	if(!istype(target))
		return

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
	reconsider_processing()

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

	if(removed)
		on_remove(owner)
	else
		on_insert(owner)

/// Used for determining if an organ should give or remove its verbs. I.E., FBP part in a human, no verbs. If true, keep or add.
/obj/item/organ/proc/check_verb_compatability()
	if(owner)
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			var/obj/item/organ/O = H.legacy_organ_by_zone(parent_organ)
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
