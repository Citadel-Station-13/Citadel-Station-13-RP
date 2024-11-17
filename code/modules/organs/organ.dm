/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	germ_level = 0
	drop_sound = 'sound/items/drop/flesh.ogg'
	pickup_sound = 'sound/items/pickup/flesh.ogg'

	//* Actions *//
	/// actions to give the owner of this organ
	///
	/// valid starting values include:
	/// * list of actions / typepaths
	/// * single action / typepath
	var/list/datum/action/organ_actions
	/// set to a string to initialize organ_actions with a generic action of this name
	var/organ_action_name
	/// description for organ action; defaults to [desc]
	var/organ_action_desc

	//* Insert / Remove *//
	/// Always drop, except for ashing / dusting a mob.
	///
	/// * Admin deletions will still delete the organ.
	var/always_drop_on_gib = FALSE
	#warn hook
	/// Always drop, including for ash / dust.
	///
	/// *  Admin deletions will still delete the organ.
	/// * Implies [always_drop_on_gib]
	var/always_drop_on_everything = FALSE
	#warn hook

	//! legacy below !//

	//* ## STRINGS VARS
	/// Unique identifier.
	var/organ_tag = "organ"
	/// The organ holding this object.
	var/parent_organ = BP_TORSO


	//* STATUS VARS
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


	//* ##REFERENCE VARS
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


	//* ## DAMAGE VARS
	/// Damage before considered bruised
	var/min_bruised_damage = 10
	/// Damage before becoming broken
	var/min_broken_damage = 30
	/// Damage cap
	/// For external organs / bodyparts, this is actually both brute and burn separate, so, you can have for 50 max damage 50 brute and 50 burn.
	var/max_damage
	/// Can this organ reject?
	var/can_reject = TRUE
	/// Is this organ already being rejected?
	var/rejecting
	/// Can this organ decay at all?
	var/decays = TRUE
	/// decay rate
	var/decay_rate = ORGAN_DECAY_PER_SECOND_DEFAULT

	//* ## LANGUAGE VARS - For organs that assist with certain languages.
	var/list/will_assist_languages = list()
	var/list/datum/language/assists_languages = list()


	//* ## VERB VARS
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

	// HACK: if we're in repository subsystem load, skip brainmob
	if(!SSrepository.initialized)
		return

	if(isliving(loc))
		owner = loc
		set_weight_class(max(src.w_class + mob_size_difference(owner.mob_size, MOB_MEDIUM), 1)) //smaller mobs have smaller organs.
		if(internal)
			LAZYDISTINCTADD(owner.internal_organs, src)
			LAZYSET(owner.internal_organs_by_name, organ_tag, src)
		else
			LAZYDISTINCTADD(owner.organs, src)
			LAZYSET(owner.organs_by_name, organ_tag, src)

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
				var/obj/item/organ/external/E = H.legacy_organ_by_zone(parent_organ)
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
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		owner.internal_organs_by_name -= null
		owner.internal_organs -= src

		var/obj/item/organ/external/affected = owner.legacy_organ_by_zone(parent_organ)
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
	target.internal_organs |= src
	affected.internal_organs |= src
	target.internal_organs_by_name[organ_tag] = src
	handle_organ_mod_special()
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

//* Actions *//

/obj/item/organ/update_action_buttons()
	. = ..()
	if(islist(organ_actions))
		for(var/datum/action/action in organ_actions)
			action.update_buttons()
	else if(istype(organ_actions, /datum/action))
		var/datum/action/action = organ_actions
		action.update_buttons()

/obj/item/organ/proc/ensure_organ_actions_loaded()
	if(islist(organ_actions))
		for(var/i in 1 to length(organ_actions))
			var/key = organ_actions[i]
			if(ispath(key, /datum/action))
				organ_actions[i] = key = new key(src)
	else if(ispath(organ_actions, /datum/action))
		organ_actions = new organ_actions
	else if(istype(organ_actions, /datum/action))
	else if(organ_action_name)
		var/datum/action/organ_action/creating = new(src)
		organ_actions = creating
		creating.name = organ_action_name
		creating.desc = organ_action_desc || desc

/obj/item/organ/proc/grant_organ_actions(mob/target)
	if(islist(organ_actions))
		for(var/datum/action/action in organ_actions)
			action.grant(target.actions_innate)
	else if(istype(organ_actions, /datum/action))
		var/datum/action/action = organ_actions
		action.grant(target.actions_innate)

/obj/item/organ/proc/revoke_organ_actions(mob/target)
	if(islist(organ_actions))
		for(var/datum/action/action in organ_actions)
			action.revoke(target.actions_innate)
	else if(istype(organ_actions, /datum/action))
		var/datum/action/action = organ_actions
		action.revoke(target.actions_innate)

//* Biologies *//

/**
 * checks if we're any of the given biology types
 */
/obj/item/organ/proc/is_any_biology_type(biology_types)
	switch(robotic)
		if(ORGAN_FLESH)
			return biology_types & BIOLOGY_TYPE_HUMAN
		if(ORGAN_ASSISTED)
			return biology_types & BIOLOGY_TYPE_HUMAN
		if(ORGAN_CRYSTAL)
			return biology_types & BIOLOGY_TYPE_CRYSTALLINE
		if(ORGAN_ROBOT)
			return biology_types & BIOLOGY_TYPE_SYNTH
		if(ORGAN_NANOFORM)
			return biology_types & BIOLOGY_TYPE_SYNTH
		if(ORGAN_LIFELIKE)
			return biology_types & BIOLOGY_TYPE_SYNTH

//* Insert / Remove *//

/**
 * Inserts into a mob.
 *
 * @params
 * * target - person being inserted into
 * * from_init - we are performing initial setup in Initialize() after we've grabbed our organs and templates from species / persistence.
 *                  this is not set in any other case.
 */
/obj/item/organ/proc/insert(mob/living/carbon/target, from_init)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * Removes from a mob.
 *
 * @params
 * * move_to - forceMove to this location. if null, we will not move out of our old container.
 * * from_qdel - our owner and the organ are being qdeleted in the QDEL_LIST loop.
 *               this is not set in any other case, including on gib and set_species().
 */
/obj/item/organ/proc/remove(atom/move_to, from_qdel)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(isnull(move_to) && (loc == null))
		CRASH("no move_to destination and our loc was null. this can result in a memory leak if the organ is unpredictably referenced, and the calling proc fails to delete or move us.")

#warn impl

/**
 * called on being put into a mob
 *
 * @params
 * * target - person being inserted into
 * * from_init - we are performing initial setup in Initialize() after we've grabbed our organs and templates from species / persistence.
 *                  this is not set in any other case.
 */
#warn audit calls
/obj/item/organ/proc/on_insert(mob/living/carbon/target, from_init)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	ensure_organ_actions_loaded()
	grant_organ_actions(target)

/**
 * called on being removed from a mob
 *
 * @params
 * * target - person being removed from
 * * from_qdel - we and the organ are being qdeleted in the QDEL_LIST loop.
 *               this is not set in any other case, including on gib and set_species().
 */
#warn audit calls
/obj/item/organ/proc/on_remove(mob/living/carbon/target, from_qdel)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	revoke_organ_actions(target)
