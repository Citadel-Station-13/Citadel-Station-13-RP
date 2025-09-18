/obj/item/organ
	abstract_type = /obj/item/organ
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

	//* Biology *//

	/// Our biology. Set to type to init.
	///
	/// * Null biology is allowed but is usually not what you want.
	var/datum/biology/biology
	/// Our biology's scratch space.
	///
	/// * Only set if our biology requires a state.
	var/datum/biology_organ_state/biology_state
	#warn impl

	//* Flags *//

	/// Our organ flags.
	var/organ_flags = NONE
	/// Our organ discovery flags
	var/organ_discovery_flags = NONE

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
	/// Our organ key to register as.
	///
	/// * This is **not** arbitrary. Keys have type semantics.
	var/organ_key

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
	var/list/datum/prototype/language/assists_languages = list()


	//* ## VERB VARS
	#warn deal with this nightmare
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

/obj/item/organ/Initialize(mapload)
	. = ..()
	create_reagents(5)

	// HACK: if we're in repository subsystem load, skip brainmob
	if(!SSrepository.initialized)
		return

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

/obj/item/organ/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(owner)
		remove(null, TRUE)
	if(transplant_data)
		transplant_data.Cut()
	if(autopsy_data)
		autopsy_data.Cut()
	if(trace_chemicals)
		trace_chemicals.Cut()
	dna = null
	species = null
	return ..()

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

#warn impl

//* Insert / Remove *//

/**
 * Inserts into a mob.
 *
 * @params
 * * target - person being inserted into
 * * from_init - we are performing initial setup in Initialize() after we've grabbed our organs and templates from species / persistence.
 *                  this is not set in any other case.
 *
 * @return TRUE on success, FALSE on failure
 */
/obj/item/organ/proc/insert(mob/living/carbon/target, from_init)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	#warn check for organ key

/**
 * Removes from a mob.
 *
 * @params
 * * move_to - forceMove to this location. if null, we will not move out of our old container.
 * * from_qdel - our owner and the organ are being qdeleted in the QDEL_LIST loop.
 *               this is not set in any other case, including on gib and set_species().
 *
 * @return TRUE on success, FALSE on failure
 */
/obj/item/organ/proc/remove(atom/move_to, from_qdel)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(isnull(move_to) && (loc == null))
		CRASH("no move_to destination and our loc was null. this can result in a memory leak if the organ is unpredictably referenced, and the calling proc fails to delete or move us.")

	#warn impl

/**
 * Replaces into a mob.
 *
 * @params
 * * target - person being inserted into
 *
 * @return TRUE on success, FALSE on failure
 */
/obj/item/organ/proc/replace(mob/living/carbon/target)
	#warn impl

#warn impl

/**
 * called on being put into a mob
 *
 * @params
 * * target - person being inserted into
 * * replacing - called as part of a replacement
 * * from_init - we are performing initial setup in Initialize() after we've grabbed our organs and templates from species / persistence.
 *                  this is not set in any other case.
 */
#warn audit calls
/obj/item/organ/proc/on_insert(mob/living/carbon/target, from_init)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	register(target)

	ensure_organ_actions_loaded()
	grant_organ_actions(target)

	//! LEGACY !//
	handle_organ_mod_special(FALSE)
	//! END !//

/**
 * called during a replace() operation
 *
 * * called before on_remove is called on the old
 *
 * @params
 * * target - person being replaced into
 * * replacing - (optional) old organ, if any
 */
/obj/item/organ/proc/before_replace(mob/living/carbon/target, obj/item/organ/replacing)
	return

/**
 * called during a replace() operation
 *
 * * called after on_insert is called on the ourselves
 *
 * @params
 * * target - person being replaced into
 * * replacing - (optional) old organ, if any
 */
/obj/item/organ/proc/after_replace(mob/living/carbon/target, obj/item/organ/replacing)
	return

/**
 * called on being removed from a mob
 *
 * @params
 * * target - person being removed from
 * * replacing - called as part of a replacement
 * * from_qdel - we and the organ are being qdeleted in the QDEL_LIST loop.
 *               this is not set in any other case, including on gib and set_species().
 */
#warn audit calls
/obj/item/organ/proc/on_remove(mob/living/carbon/target, from_qdel)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	revoke_organ_actions(target)

	unregister(target)

	//! LEGACY !//
	handle_organ_mod_special(TRUE)
	//! END !//

/**
 * Performs base registration.
 *
 * * Do not put custom behavior in here. This should only be implemented on base subtypes of /organ.
 */
/obj/item/organ/proc/register(mob/living/carbon/target)
	CRASH("base registration unimplemented on [type]")

/**
 * Performs base unregistration.
 *
 * * Do not put custom behavior in here. This should only be implemented on base subtypes of /organ.
 */
/obj/item/organ/proc/unregister(mob/living/carbon/target)
	CRASH("base registration unimplemented on [type]")
