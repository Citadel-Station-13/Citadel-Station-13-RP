/obj/item/organ/external
	name = "external"
	max_damage = 0
	min_broken_damage = 30
	dir = SOUTH
	organ_tag = "limb"
	decays = FALSE

	//* Behaviour *//
	/// this covers things like 'can this limb be injected' or 'can this limb be healed'
	var/behaviour_flags = NONE

	//* Coverage *//
	/// body_cover_flags that count as covering us
	var/body_part_flags = NONE

	//* Damage
	/// https://www.desmos.com/calculator/eyn1lj5gq7
	/// intensifier value used for inverse-damage softcap
	var/damage_softcap_intensifier = 0

	//* Physiology *//
	/// local physiology holder
	var/datum/local_physiology/physiology
	/// local-ized physiology modifiers - these are always on us, even when we are mob-less
	var/list/datum/physiology_modifier/physiology_modifiers

	//* Wounds *//
	/// Wound datum list.
	var/list/wounds
	/// Number of wounds we have - some wounds like bruises will collate into one datum representing all of them.
	var/wound_tally

	//* ## STRINGS
	/// Fracture description if any.
	var/broken_description
	/// Modifier used for generating the on-mob damage overlay for this limb.
	var/damage_state = "00"


	//* ## DAMAGE VARS
	/// Multiplier for incoming brute damage.
	var/brute_mod = 1
	/// As above for burn.
	var/burn_mod = 1
	/// EMP damage multiplier
	var/emp_mod = 1
	/// Actual current brute damage.
	var/brute_dam = 0
	/// Actual current burn damage.
	var/burn_dam = 0
	/// Used in healing/processing calculations.
	var/last_dam = -1

	/// If damage done to this organ spreads to connected organs.
	var/spread_dam = FALSE
	/// If a needle has a chance to fail to penetrate.
	var/thick_skin = FALSE
	/// If a prosthetic limb is emagged, it will detonate when it fails.
	var/sabotaged = FALSE

	/// Chance of missing.
	var/base_miss_chance = 20


	//* ## APPEARANCE VARS
	/// Snowflake warning, reee. Used for slime limbs.
	var/nonsolid
	/// Also for slimes. Used for transparent limbs.
	var/transparent = 0
	/// Icon state base.
	var/icon_name = null
	/// Used in mob overlay layering calculations.
	var/icon_position = 0
	/// Used when caching robolimb icons.
	var/model
	/// Used to force override of species-specific limb icons (for prosthetics). Also used for any limbs chopped from a simple mob, and then attached to humans.
	var/force_icon
	/// Used to force the override of the icon-key generated using the species. Must be used in tandem with the above.
	var/force_icon_key
	/// Cached icon for use in mob overlays.
	var/icon/mob_icon
	/// Whether or not the icon state appends a gender.
	var/gendered_icon = FALSE
	/// Skin tone.
	var/s_tone
	/// Skin colour
	var/list/s_col
	/// How the skin colour is applied.
	var/s_col_blend = ICON_ADD
	/// Hair colour
	var/list/h_col
	/// Icon blend for body hair if any.
	var/body_hair
	var/mob/living/applied_pressure
	/// Markings (body_markings) to apply to the icon
	var/list/markings = list()

	//* ## STRUCTURAL VARS
	/// Master-limb.
	var/obj/item/organ/external/parent
	/// Sub-limbs.
	var/list/children = list()
	/// Internal organs of this body part
	var/list/internal_organs = list()
	/// Currently implanted objects.
	var/list/implants = list()
	/// Relative size of the organ.
	var/organ_rel_size = 25
	var/atom/movable/splinted

	//* ## JOINT/STATE VARS
	/// It would be more appropriate if these two were named "affects_grasp" and "affects_stand" at this point
	var/can_grasp
	/// Modifies stance tally/ability to stand.
	var/can_stand
	/// Scarred/burned beyond recognition.
	var/disfigured = FALSE
	/// Impossible to amputate.
	var/cannot_amputate
	/// Impossible to fracture.
	var/cannot_break
	/// Impossible to gib, distinct from amputation.
	var/cannot_gib
	/// Descriptive string used in dislocation.
	var/joint = "joint"
	/// Descriptive string used in amputation.
	var/amputation_point
	/// If you target a joint, you can dislocate the limb, impairing it's usefulness and causing pain.
	var/dislocated = FALSE
	/// Needs to be opened with a saw to access the organs.
	var/encased


	//* ## SURGERY VARS
	var/open   = FALSE
	var/stage  = FALSE
	var/cavity = FALSE

	/// Surgical repair stage for burn.
	var/burn_stage = 0
	/// Surgical repair stage for brute.
	var/brute_stage = 0

	/// HUD element variable, see organ_icon.dm get_damage_hud_image()
	var/image/hud_damage_image

	/// makes this dumb as fuck mechanic slightly less awful - records queued syringe infections instead of a spawn()
	var/syringe_infection_queued

/obj/item/organ/external/Initialize(mapload)
	init_local_physiology()
	. = ..(mapload, FALSE)
	if(istype(owner))
		replaced(owner)
		sync_colour_to_human(owner)
	addtimer(CALLBACK(src, PROC_REF(get_icon)), 1)

/obj/item/organ/external/Destroy()

	if(parent && parent.children)
		parent.children -= src

	if(children)
		for(var/obj/item/organ/external/C in children)
			qdel(C)

	if(internal_organs)
		for(var/obj/item/organ/O in internal_organs)
			qdel(O)

	if(splinted && splinted.loc == src)
		qdel(splinted)
	splinted = null

	if(istype(owner))
		owner.organs -= src
		owner.organs_by_name[organ_tag] = null
		owner.organs_by_name -= organ_tag
		while(null in owner.organs)
			owner.organs -= null

	implants.Cut() // Remove these too!

	return ..()

/obj/item/organ/external/emp_act(severity)
	if(!(robotic >= ORGAN_ROBOT))
		return
	var/burn_damage = 0
	switch(severity)
		if (1)
			burn_damage += rand(10, 12)
		if (2)
			burn_damage += rand(6.5, 8)
		if(3)
			burn_damage += rand(4, 8)
		if(4)
			burn_damage += rand(2, 5)

	if(burn_damage)
		inflict_bodypart_damage(
			burn = burn_damage * emp_mod,
			weapon_descriptor = "electromagnetic overload",
		)

/obj/item/organ/external/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(!contents.len)
		return ..()
	var/list/removable_objects = list()
	for(var/obj/item/organ/external/E in (contents + src))
		if(!istype(E))
			continue
		for(var/obj/item/I in E.contents)
			if(istype(I,/obj/item/organ))
				continue
			removable_objects |= I
	if(removable_objects.len)
		var/obj/item/I = pick(removable_objects)
		I.forceMove(get_turf(user)) //just in case something was embedded that is not an item
		if(istype(I))
			user.put_in_hands(I)
		user.visible_message("<span class='danger'>\The [user] rips \the [I] out of \the [src]!</span>")
		return //no eating the limb until everything's been removed
	return ..()

/obj/item/organ/external/examine()
	. = ..()
	if(in_range(usr, src) || istype(usr, /mob/observer/dead))
		for(var/obj/item/I in contents)
			if(istype(I, /obj/item/organ))
				continue
			. += "<span class='danger'>There is \a [I] sticking out of it.</span>"
	return

/obj/item/organ/external/attackby(obj/item/W as obj, mob/living/user as mob)
	switch(stage)
		if(0)
			if(istype(W,/obj/item/surgical/scalpel))
				user.visible_message("<span class='danger'><b>[user]</b> cuts [src] open with [W]!</span>")
				stage++
				return
		if(1)
			if(istype(W,/obj/item/surgical/retractor))
				user.visible_message("<span class='danger'><b>[user]</b> cracks [src] open like an egg with [W]!</span>")
				stage++
				return
		if(2)
			if(istype(W,/obj/item/surgical/hemostat))
				if(contents.len)
					var/obj/item/removing = pick(contents)
					removing.forceMove(get_turf(user.loc))
					user.put_in_hands(removing)
					user.visible_message("<span class='danger'><b>[user]</b> extracts [removing] from [src] with [W]!</span>")
				else
					user.visible_message("<span class='danger'><b>[user]</b> fishes around fruitlessly in [src] with [W].</span>")
				return
	..()

/obj/item/organ/external/proc/is_dislocated()
	if(dislocated > 0)
		return 1
	if(is_parent_dislocated())
		return 1//if any parent is dislocated, we are considered dislocated as well
	return 0

/obj/item/organ/external/proc/is_parent_dislocated()
	var/obj/item/organ/external/O = parent
	while(O && O.dislocated != -1)
		if(O.dislocated == 1)
			return 1
		O = O.parent
	return 0


/obj/item/organ/external/proc/dislocate()
	if(dislocated == -1)
		return

	dislocated = 1
	if(istype(owner))
		add_verb(owner, /mob/living/carbon/human/proc/relocate)

/obj/item/organ/external/proc/relocate()
	if(dislocated == -1)
		return

	dislocated = 0
	if(istype(owner))
		owner.shock_stage += 20

		//check to see if we still need the verb
		for(var/obj/item/organ/external/limb in owner.organs)
			if(limb.dislocated == 1)
				return
		remove_verb(owner, /mob/living/carbon/human/proc/relocate)

/obj/item/organ/external/update_health()
	damage = min(max_damage, (brute_dam + burn_dam))

/obj/item/organ/external/replaced(var/mob/living/carbon/human/target)
	owner = target
	forceMove(owner)

	// todo: removed() is not necessarily reliable.
	for(var/datum/physiology_modifier/modifier as anything in owner.physiology_modifiers)
		// todo: check biology
		physiology.apply(modifier)

	if(istype(owner))
		owner.organs_by_name[organ_tag] = src
		owner.organs |= src
		for(var/obj/item/organ/organ in src)
			organ.replaced(owner,src)

	if(parent_organ)
		parent = owner.organs_by_name[src.parent_organ]
		if(parent)
			if(!parent.children)
				parent.children = list()
			parent.children.Add(src)
			//Remove all stump wounds since limb is not missing anymore
			parent.cure_specific_wound(/datum/wound/lost_limb)

/****************************************************
			   DAMAGE PROCS
****************************************************/

/obj/item/organ/external/proc/is_damageable(check_damage_cap)
	// todo: rework
	if(check_damage_cap)
		//Continued damage to vital organs can kill you, and robot organs don't count towards total damage so no need to cap them.
		// todo: this is absolutely fucking stupid, rework asap.
		if(vital || (robotic >= ORGAN_ROBOT) || brute_dam + burn_dam < max_damage)
			return TRUE
		return FALSE
	return TRUE

/**
 * process incoming damage
 *
 * @params
 * * brute - brute damage to take
 * * burn - burn damage to take
 * * damage_mode - DAMAG_EMODE_* flags for the form of this damage
 * * weapon descriptor - a string describing how it happened ("flash burns", "multiple precision cuts", etc)
 * * defer_host_updates - update health / perform damage checks? this is only for owner updates, not self updates!!
 */
/obj/item/organ/external/proc/inflict_bodypart_damage(brute, burn, damage_mode, weapon_descriptor, defer_host_updates)
	// todo: get rid of this shit, should be physiology
	// legacy: brute/burnmod
	brute = round(brute * brute_mod, 0.1)
	burn = round(burn * burn_mod, 0.1)

	// todo: better way to godmode
	if(src.owner?.status_flags & STATUS_GODMODE)
		return 0

	if(!brute && !burn)
		return 0

	// todo: this is awful
	var/sharp = damage_mode & DAMAGE_MODE_SHARP
	var/edge = damage_mode & DAMAGE_MODE_EDGE
	// cache owner incase we get detached
	// todo: this is awful
	var/mob/living/carbon/owner = src.owner

	// todo: lol this is shit
	// legacy: organ damage on high damage
	if(internal_organs && (brute_dam >= max_damage || (((sharp && brute >= 5) || brute >= 10) && prob(5))))
		// Damage an internal organ
		if(internal_organs && internal_organs.len)
			var/obj/item/organ/I = pick(internal_organs)
			brute *= 0.5
			I.take_damage(brute)

	// todo: lol this is shit
	// legacy: jostle if broken
	if(is_broken() && brute && !(damage_mode & DAMAGE_MODE_GRADUAL))
		jostle_bone(brute)
		if(organ_can_feel_pain() && IS_CONSCIOUS(owner) && prob(40))
			spawn(-1)
				owner.emote_nosleep("scream")	//getting hit on broken hand hurts

	// todo: optimization
	// legacy: autopsy data
	if(weapon_descriptor)
		add_autopsy_data(weapon_descriptor, brute + burn)

		//* LEGACY BELOW

	var/can_cut = (sharp) && (robotic < ORGAN_ROBOT)

	// If the limbs can break, make sure we don't exceed the maximum damage a limb can take before breaking
	// Non-vital organs are limited to max_damage. You can't kill someone by bludeonging their arm all the way to 200 -- you can
	// push them faster into paincrit though, as the additional damage is converted into shock.
	if(brute)
		var/can_inflict_brute = max(0, max_damage - brute_dam)
		if(can_inflict_brute >= brute)
			if(can_cut)
				if(sharp && !edge)
					create_wound( WOUND_TYPE_PIERCE, brute )
				else
					create_wound( WOUND_TYPE_CUT, brute )
			else
				create_wound( WOUND_TYPE_BRUISE, brute )
		else if(!(damage_mode & DAMAGE_MODE_NO_OVERFLOW))
			var/overflow_brute = brute - can_inflict_brute
			// keep allowing it, but, diminishing returns
			var/damage_anyways_brute = !(damage_mode & DAMAGE_MODE_NO_OVERFLOW) && ( \
				overflow_brute * min(1, 1 / ((max(brute_dam, max_damage) + damage_softcap_intensifier) / (damage_softcap_intensifier + max_damage))) \
			)
			overflow_brute -= damage_anyways_brute
			if(can_cut)
				if(sharp && !edge)
					create_wound( WOUND_TYPE_PIERCE, damage_anyways_brute )
				else
					create_wound( WOUND_TYPE_CUT, damage_anyways_brute )
			else
				create_wound( WOUND_TYPE_BRUISE, damage_anyways_brute )
			// rest goes into shock
			owner.shock_stage += overflow_brute * 0.33
	if(burn)
		var/can_inflict_burn = max(0, max_damage - burn_dam)
		if(can_inflict_burn >= burn)
			create_wound( WOUND_TYPE_BURN, burn )
		else
			var/overflow_burn = burn - can_inflict_burn
			var/damage_anyways_burn = !(damage_mode & DAMAGE_MODE_NO_OVERFLOW) && ( \
				overflow_burn  * min(1, 1 / ((max(burn_dam, max_damage) + damage_softcap_intensifier) / (damage_softcap_intensifier + max_damage))) \
			)
			overflow_burn -= damage_anyways_burn
			create_wound(WOUND_TYPE_BURN, damage_anyways_burn + can_inflict_burn)
			// rest goes into shock
			owner.shock_stage += overflow_burn * 0.33

	// sync the organ's damage with its wounds
	update_damages()

	// break it if needed
	// todo: shit code lmao
	if(brute_dam > min_broken_damage && prob((brute * ((brute_dam - min_broken_damage) / min_broken_damage)) * 2))
		fracture()

	//If limb took enough damage, try to cut or tear it off
	if(!(damage_mode & DAMAGE_MODE_GRADUAL) && !is_stump() && !cannot_amputate && ((brute_dam > max_damage) || (burn_dam > max_damage)))
		//organs can come off in three cases
		//1. If the damage source is edge_eligible and the brute damage dealt exceeds the edge threshold, then the organ is cut off.
		//2. If the damage amount dealt exceeds the disintegrate threshold, the organ is completely obliterated.
		//3. If the organ has already reached or would be put over it's max damage amount (currently redundant),
		//   and the brute damage dealt exceeds the tearoff threshold, the organ is torn off.

		//Check edge eligibility
			//* edge eligibility disabled; organs should optimally not reqiure the item reference and should instead
			//* get descriptors (damage, damage mode, etc) of the inbound attack.
		var/edge_eligible = edge
		// var/edge_eligible = 0
		// if(edge)
		// 	if(istype(used_weapon,/obj/item))
		// 		var/obj/item/W = used_weapon
		// 		if(W.w_class >= w_class)
		// 			edge_eligible = 1
		// 	else
		// 		edge_eligible = 1

		if(nonsolid && damage >= max_damage)
			droplimb(TRUE, DROPLIMB_EDGE)
		else if (robotic >= ORGAN_NANOFORM && damage >= max_damage)
			droplimb(TRUE, DROPLIMB_BURN)
		else if(edge_eligible && brute >= max_damage / DROPLIMB_THRESHOLD_EDGE && prob(brute))
			droplimb(0, DROPLIMB_EDGE)
		else if((burn >= max_damage / DROPLIMB_THRESHOLD_DESTROY) && prob(burn*0.33))
			droplimb(0, DROPLIMB_BURN)
		else if((brute >= max_damage / DROPLIMB_THRESHOLD_DESTROY && prob(brute)))
			droplimb(0, DROPLIMB_BLUNT)
		else if(brute >= max_damage / DROPLIMB_THRESHOLD_TEAROFF && prob(brute*0.33))
			droplimb(0, DROPLIMB_EDGE)
			//* damage spreading disabled; the attacking weapon should handle this if necessary.
		// else if(spread_dam && owner && parent && (brute_overflow || burn_overflow) && (brute_overflow >= 5 || burn_overflow >= 5) && !permutation) //No infinite damage loops.
		// 	var/brute_third = brute_overflow * 0.33
		// 	var/burn_third = burn_overflow * 0.33
		// 	if(children && children.len)
		// 		var/brute_on_children = brute_third / children.len
		// 		var/burn_on_children = burn_third / children.len
		// 		spawn()
		// 			for(var/obj/item/organ/external/C in children)
		// 				if(!C.is_stump())
		// 					C.take_damage(brute_on_children, burn_on_children, 0, 0, null, forbidden_limbs, 1) //Splits the damage to each individual 'child', incase multiple exist.
		// 	parent.take_damage(brute_third, burn_third, 0, 0, null, forbidden_limbs, 1)

		//* LEGACY ABOVE

	if(!defer_host_updates)
		owner?.update_health()

	update_icon()

/obj/item/organ/external/proc/heal_damage(brute, burn, internal = 0, robo_repair = 0)
	if(robotic >= ORGAN_ROBOT && !robo_repair)
		return

	//Heal damage on the individual wounds
	for(var/datum/wound/W as anything in wounds)
		if(brute == 0 && burn == 0)
			break

		// heal brute damage
		if(W.wound_type == WOUND_TYPE_BURN)
			burn = W.heal_damage(burn)
		else
			brute = W.heal_damage(brute)

	if(internal)
		status &= ~ORGAN_BROKEN

	//Sync the organ's damage with its wounds
	src.update_damages()
	src.process_wounds() // todo: this should not be here - this has side effects of processing.
	owner.update_health()

	var/result = update_icon()
	return result

/// Helper proc used by various tools for repairing robot limbs
/obj/item/organ/external/proc/robo_repair(repair_amount, damage_type, damage_desc, obj/item/tool, mob/living/user)
	if((src.robotic < ORGAN_ROBOT))
		return FALSE

	var/damage_amount
	switch(damage_type)
		if(DAMAGE_TYPE_BRUTE)
			damage_amount = brute_dam
		if(DAMAGE_TYPE_BURN)
			damage_amount = burn_dam
		if("omni")
			damage_amount = max(brute_dam,burn_dam)
		else
			return FALSE

	if(!damage_amount)
		to_chat(user, SPAN_NOTICE("Nothing to fix!"))
		return FALSE

	// Makes robotic limb damage scalable.
	if(brute_dam + burn_dam >= min_broken_damage)
		to_chat(user, SPAN_DANGER("The damage is far too severe to patch over externally."))
		return FALSE

	if(user == src.owner)
		if(owner.get_hand_organ(owner.get_held_index(tool)) == src)
			to_chat(user, SPAN_WARNING("You can't reach your [src] while holding [tool] in the same hand!"))
			return FALSE

	user.setClickCooldownLegacy(user.get_attack_speed_legacy(tool))
	if(!do_mob(user, owner, 10))
		to_chat(user, SPAN_WARNING("You must stand still to do that."))
		return FALSE

	switch(damage_type)
		if(DAMAGE_TYPE_BRUTE)
			src.heal_damage(repair_amount, 0, 0, 1)
		if(DAMAGE_TYPE_BURN)
			src.heal_damage(0, repair_amount, 0, 1)
		if("omni")
			src.heal_damage(repair_amount, repair_amount, 0, 1)

	if(damage_desc)
		if(user == src.owner)
			var/datum/gender/T = GLOB.gender_datums[user.get_visible_gender()]
			user.visible_message(SPAN_NOTICE("\The [user] patches [damage_desc] on [T.his] [src.name] with [tool]."))
		else
			user.visible_message(SPAN_NOTICE("\The [user] patches [damage_desc] on [owner]'s [src.name] with [tool]."))

	return TRUE

/obj/item/organ/external/rejuvenate()
	..()
	brute_dam = 0
	burn_dam = 0
	wounds = null
	wound_tally = 0

/**
 * This function completely restores a damaged organ to perfect condition.
 */
/obj/item/organ/external/rejuvenate_legacy(ignore_prosthetic_prefs)
	rejuvenate()
	damage_state = "00"
	status = 0

	// handle internal organs
	for(var/obj/item/organ/current_organ in internal_organs)
		current_organ.rejuvenate_legacy(ignore_prosthetic_prefs)

	// remove embedded objects and drop them on the floor
	for(var/obj/implanted_object in implants)
		if(!istype(implanted_object,/obj/item/implant) && !istype(implanted_object,/obj/item/nif))	// We don't want to remove REAL implants. Just shrapnel etc.
			implanted_object.forceMove(get_turf(src))
			implants -= implanted_object

	if(owner && !ignore_prosthetic_prefs)
		if(owner.client && owner.client.prefs && owner.client.prefs.real_name == owner.real_name)
			var/status = owner.client.prefs.organ_data[organ_tag]
			if(status == "amputated")
				remove_rejuv()
			else if(status == "cyborg")
				var/robodata = owner.client.prefs.rlimb_data[organ_tag]
				if(robodata)
					robotize(robodata, null, null, TRUE)
				else
					robotize()
		owner.update_health()

/obj/item/organ/external/remove_rejuv()
	if(owner)
		owner.organs -= src
		owner.organs_by_name[organ_tag] = null
		owner.organs_by_name -= organ_tag
		while(null in owner.organs) owner.organs -= null
	if(children && children.len)
		for(var/obj/item/organ/external/E in children)
			E.remove_rejuv()
	children.Cut()
	for(var/obj/item/organ/internal/I in internal_organs)
		I.remove_rejuv()
	..()

/****************************************************
			   PROCESSING & UPDATING
****************************************************/

//external organs handle brokenness a bit differently when it comes to damage. Instead brute_dam is checked inside process()
//this also ensures that an external organ cannot be "broken" without broken_description being set.
/obj/item/organ/external/is_broken()
	return (status & ORGAN_CUT_AWAY) || ((status & ORGAN_BROKEN) && !splinted)

//Determines if we even need to process this organ.
/obj/item/organ/external/proc/need_process()
	if(status & (ORGAN_CUT_AWAY|ORGAN_BLEEDING|ORGAN_BROKEN|ORGAN_DESTROYED|ORGAN_DEAD|ORGAN_MUTATED))
		return 1
	if(brute_dam || burn_dam) //Robot limbs don't autoheal and thus don't need to process when damaged. Aside from medichines.
		return 1
	if(last_dam != brute_dam + burn_dam) // Process when we are fully healed up.
		last_dam = brute_dam + burn_dam
		return 1
	else
		last_dam = brute_dam + burn_dam
	if(germ_level && (owner && !IS_DEAD(owner)))
		return 1
	if(length(wounds))
		return TRUE
	return 0

/obj/item/organ/external/tick_life(dt)
	. = ..()

	if(owner)
		//Dismemberment
		//if(parent && parent.is_stump()) //should never happen
		//	warning("\The [src] ([src.type]) belonging to [owner] ([owner.type]) was attached to a stump")
		//	remove()
		//	return

		// Process wounds, doing healing etc. Only do this every few ticks to save processing power
		process_wounds()

		//Chem traces slowly vanish
		if(owner.life_tick % 10 == 0)
			for(var/chemID in trace_chemicals)
				trace_chemicals[chemID] = trace_chemicals[chemID] - 1
				if(trace_chemicals[chemID] <= 0)
					trace_chemicals.Remove(chemID)

		//Infections
		update_germs()

//Updating germ levels. Handles organ germ levels and necrosis.
/*
The INFECTION_LEVEL values defined in setup.dm control the time it takes to reach the different
infection levels. Since infection growth is exponential, you can adjust the time it takes to get
from one germ_level to another using the rough formula:

desired_germ_level = initial_germ_level*e^(desired_time_in_seconds/1000)

So if I wanted it to take an average of 15 minutes to get from level one (100) to level two
I would set INFECTION_LEVEL_TWO to 100*e^(15*60/1000) = 245. Note that this is the average time,
the actual time is dependent on RNG.

INFECTION_LEVEL_ONE		below this germ level nothing happens, and the infection doesn't grow
INFECTION_LEVEL_TWO		above this germ level the infection will start to spread to internal and adjacent organs
INFECTION_LEVEL_THREE	above this germ level the player will take additional toxin damage per second, and will die in minutes without
						antitox. also, above this germ level you will need to overdose on spaceacillin to reduce the germ_level.

Note that amputating the affected organ does in fact remove the infection from the player's body.
*/
/obj/item/organ/external/proc/update_germs()

	if(robotic >= ORGAN_ROBOT || (owner.species && (owner.species.species_flags & IS_PLANT || (owner.species.species_flags & NO_INFECT)))) //Robotic limbs shouldn't be infected, nor should nonexistant limbs.
		germ_level = 0
		return

	if(owner && !IS_DEAD(owner))
		return

	if(owner.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Syncing germ levels with external wounds
		handle_germ_sync()

		// removal temporary, pending health rework
		//** Handle antibiotics and curing infections
		// handle_antibiotics()

		// //** Handle the effects of infections
		// handle_germ_effects()

/obj/item/organ/external/proc/handle_germ_sync()
	var/antibiotics = owner.chem_effects[CE_ANTIBIOTIC]
	for(var/datum/wound/W as anything in wounds)
		//Open wounds can become infected
		if (owner.germ_level > W.germ_level && W.infection_check())
			W.germ_level++

	if (antibiotics < ANTIBIO_NORM)
		for(var/datum/wound/W as anything in wounds)
			//Infected wounds raise the organ's germ level
			if (W.germ_level > germ_level)
				germ_level++
				break	//limit increase to a maximum of one per second

/obj/item/organ/external/handle_germ_effects()
	. = ..() //May be null or an infection level, if null then no specific processing needed here
	if(!.)
		return

	var/antibiotics = owner.chem_effects[CE_ANTIBIOTIC]

	if(. >= 2 && antibiotics < ANTIBIO_NORM) //INFECTION_LEVEL_TWO
		//spread the infection to internal organs
		var/obj/item/organ/target_organ = null	//make internal organs become infected one at a time instead of all at once
		for (var/obj/item/organ/I in internal_organs)
			if (I.germ_level > 0 && I.germ_level < min(germ_level, INFECTION_LEVEL_TWO))	//once the organ reaches whatever we can give it, or level two, switch to a different one
				if (!target_organ || I.germ_level > target_organ.germ_level)	//choose the organ with the highest germ_level
					target_organ = I

		if (!target_organ)
			//figure out which organs we can spread germs to and pick one at random
			var/list/candidate_organs = list()
			for (var/obj/item/organ/I in internal_organs)
				if (I.germ_level < germ_level)
					candidate_organs |= I
			if (candidate_organs.len)
				target_organ = pick(candidate_organs)

		if (target_organ)
			target_organ.germ_level++

		//spread the infection to child and parent organs
		if (children)
			for (var/obj/item/organ/external/child in children)
				if (child.germ_level < germ_level && (child.robotic < ORGAN_ROBOT))
					if (child.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
						child.germ_level++

		if (parent)
			if (parent.germ_level < germ_level && (parent.robotic < ORGAN_ROBOT))
				if (parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
					parent.germ_level++

	if(. >= 3 && antibiotics < ANTIBIO_OD)	//INFECTION_LEVEL_THREE
		if (!(status & ORGAN_DEAD))
			status |= ORGAN_DEAD
			to_chat(owner, "<span class='notice'>You can't feel your [name] anymore...</span>")
			owner.update_icons_body()
			for (var/obj/item/organ/external/child in children)
				child.germ_level += 110 //Burst of infection from a parent organ becoming necrotic

//Updating wounds. Handles wound natural I had some free spachealing, internal bleedings and infections
/obj/item/organ/external/proc/process_wounds()

	if((robotic >= ORGAN_ROBOT) || (species.species_flags & UNDEAD)) //Robotic and dead limbs don't heal or get worse.
		for(var/datum/wound/W as anything in wounds) //Repaired wounds disappear though
			if(W.damage <= 0)  //and they disappear right away
				wounds -= W    //TODO: robot wounds for robot limbs
				src.update_damages()
				if (update_icon())
					owner.update_damage_overlay(1)
		return

	for(var/datum/wound/W as anything in wounds)
		// wounds can disappear after 10 minutes at the earliest
		if(W.damage <= 0 && W.created + 10 * 10 * 60 <= world.time)
			wounds -= W
			continue
			// let the GC handle the deletion of the wound

		// Internal wounds get worse over time. Low temperatures (cryo) stop them.
		if(W.internal && owner.bodytemperature >= 170)
			var/bicardose = owner.reagents.get_reagent_amount("bicaridine")
			var/inaprovaline = owner.reagents.get_reagent_amount("inaprovaline")
			var/myeldose = owner.reagents.get_reagent_amount("myelamine")
			if(!(W.can_autoheal() || (bicardose && inaprovaline) || myeldose))	//bicaridine and inaprovaline stop internal wounds from growing bigger with time, unless it is so small that it is already healing
				W.open_wound(0.1)

			owner.erase_blood(W.damage / 40)
			if(prob(1))
				owner.custom_pain("You feel a stabbing pain in your [name]!", 50)

		// slow healing
		var/heal_amt = 0

		// if damage >= 50 AFTER treatment then it's probably too severe to heal within the timeframe of a round.
		if (W.can_autoheal() && W.wound_damage() < 50)
			heal_amt += 0.5

		// todo: config entry after more med refactors
		// amount of healing is spread over all the wounds
		heal_amt = heal_amt / (length(wounds) + 1)
		// making it look prettier on scanners
		heal_amt = round(heal_amt,0.1)
		W.heal_damage(heal_amt)

		// Salving also helps against infection
		if(W.germ_level > 0 && W.salved && prob(2))
			W.disinfected = 1
			W.germ_level = 0

	// sync the organ's damage with its wounds
	src.update_damages()
	if (update_icon())
		owner.update_damage_overlay(1)

//Updates brute_damn and burn_damn from wound damages. Updates BLEEDING status.
/obj/item/organ/external/proc/update_damages()
	wound_tally = 0
	brute_dam = 0
	burn_dam = 0
	status &= ~ORGAN_BLEEDING
	var/clamped = 0

	var/mob/living/carbon/human/H
	if(istype(owner,/mob/living/carbon/human))
		H = owner

	//update damage counts
	for(var/datum/wound/W as anything in wounds)
		if(!W.internal) //so IB doesn't count towards crit/paincrit
			if(W.wound_type == WOUND_TYPE_BURN)
				burn_dam += W.damage
			else
				brute_dam += W.damage

		if(!(robotic >= ORGAN_ROBOT) && W.bleeding() && (H && H.should_have_organ(O_HEART)) && !(H.species.species_flags & NO_BLOOD))
			W.bleed_timer--
			status |= ORGAN_BLEEDING

		clamped |= W.clamped

		wound_tally += W.amount

	//things tend to bleed if they are WOUND_TYPE_CUT OPEN
	if (open && !clamped && (H && H.should_have_organ(O_HEART)))
		status |= ORGAN_BLEEDING

	update_health()

// new damage icon system
// adjusted to set damage_state to brute/burn code only (without r_name0 as before)
/obj/item/organ/external/update_icon()
	var/n_is = damage_state_text()
	if (n_is != damage_state)
		damage_state = n_is
		return 1
	return 0

// new damage icon system
// returns just the brute/burn damage code
/obj/item/organ/external/proc/damage_state_text()

	var/tburn = 0
	var/tbrute = 0

	if(burn_dam ==0)
		tburn =0
	else if (burn_dam < (max_damage * 0.25 / 2))
		tburn = 1
	else if (burn_dam < (max_damage * 0.75 / 2))
		tburn = 2
	else
		tburn = 3

	if (brute_dam == 0)
		tbrute = 0
	else if (brute_dam < (max_damage * 0.25 / 2))
		tbrute = 1
	else if (brute_dam < (max_damage * 0.75 / 2))
		tbrute = 2
	else
		tbrute = 3
	return "[tbrute][tburn]"

/****************************************************
			   DISMEMBERMENT
****************************************************/

//Handles dismemberment
/obj/item/organ/external/proc/droplimb(var/clean, var/disintegrate = DROPLIMB_EDGE, var/ignore_children = null)

	if(cannot_amputate || !owner)
		return
	if(robotic >= ORGAN_NANOFORM)
		disintegrate = DROPLIMB_BURN //Ashes will be fine
	else if(disintegrate == DROPLIMB_EDGE && nonsolid)
		disintegrate = DROPLIMB_BLUNT //splut

	switch(disintegrate)
		if(DROPLIMB_EDGE)
			if(!clean)
				var/gore_sound = "[(robotic >= ORGAN_ROBOT) ? "tortured metal" : "ripping tendons and flesh"]"
				owner.visible_message(
					"<span class='danger'>\The [owner]'s [src.name] flies off in an arc!</span>",\
					"<span class='moderate'><b>Your [src.name] goes flying off!</b></span>",\
					"<span class='danger'>You hear a terrible sound of [gore_sound].</span>")
		if(DROPLIMB_BURN)
			if(cannot_gib)
				return
			var/gore = "[(robotic >= ORGAN_ROBOT) ? "": " of burning flesh"]"
			owner.visible_message(
				"<span class='danger'>\The [owner]'s [src.name] flashes away into ashes!</span>",\
				"<span class='moderate'><b>Your [src.name] flashes away into ashes!</b></span>",\
				"<span class='danger'>You hear a crackling sound[gore].</span>")
		if(DROPLIMB_BLUNT)
			if(cannot_gib)
				return
			var/gore = "[(robotic >= ORGAN_ROBOT) ? "": " in shower of gore"]"
			var/gore_sound = "[(status >= ORGAN_ROBOT) ? "rending sound of tortured metal" : "sickening splatter of gore"]"
			owner.visible_message(
				"<span class='danger'>\The [owner]'s [src.name] explodes[gore]!</span>",\
				"<span class='moderate'><b>Your [src.name] explodes[gore]!</b></span>",\
				"<span class='danger'>You hear the [gore_sound].</span>")

	var/mob/living/carbon/human/victim = owner //Keep a reference for post-removed().
	var/obj/item/organ/external/parent_organ = parent

	var/use_flesh_colour = species?.get_flesh_colour(owner) ? species.get_flesh_colour(owner) : "#C80000"
	var/use_blood_colour = species?.get_blood_colour(owner) ? species.get_blood_colour(owner) : "#C80000"

	removed(null, ignore_children)
	victim?.traumatic_shock += 60

	if(parent_organ)
		var/datum/wound/lost_limb/W = new (src, disintegrate, clean)
		if(clean)
			LAZYDISTINCTADD(parent_organ.wounds, W)
			parent_organ.update_damages()
		else
			var/obj/item/organ/external/stump/stump = new (victim, 0, src)
			if(robotic >= ORGAN_ROBOT)
				stump.robotize()
			LAZYDISTINCTADD(stump.wounds, W)
			victim.organs |= stump
			stump.update_damages()

	spawn(1)
		if(istype(victim))
			victim.update_health()
			victim.update_damage_overlay()
			victim.update_icons_body()
		else
			victim.update_icons()
		dir = 2

	var/atom/droploc = victim.drop_location()
	switch(disintegrate)
		if(DROPLIMB_EDGE)
			appearance_flags &= ~PIXEL_SCALE
			compile_icon()
			add_blood(victim)
			var/matrix/M = matrix()
			M.Turn(rand(180))
			src.transform = M
			if(!clean)
				// Throw limb around.
				if(src && istype(loc,/turf))
					throw_at_old(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),5)
				dir = 2
		if(DROPLIMB_BURN)
			new /obj/effect/debris/cleanable/ash(droploc)
			for(var/obj/item/I in src)
				if(I.w_class > WEIGHT_CLASS_SMALL && !istype(I,/obj/item/organ))
					I.forceMove(droploc)
			qdel(src)
		if(DROPLIMB_BLUNT)
			var/obj/effect/debris/cleanable/blood/gibs/gore
			if(robotic >= ORGAN_ROBOT)
				gore = new /obj/effect/debris/cleanable/blood/gibs/robot(droploc)
			else
				gore = new /obj/effect/debris/cleanable/blood/gibs(droploc)
				if(species)
					gore.fleshcolor = use_flesh_colour
					gore.basecolor =  use_blood_colour
					gore.update_icon()

			gore.throw_at_old(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),5)

			for(var/obj/item/organ/I in internal_organs)
				I.removed()
				if(istype(loc,/turf))
					I.throw_at_old(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),5)

			for(var/obj/item/I in src)
				if(I.w_class <= WEIGHT_CLASS_SMALL)
					qdel(I)
					continue
				I.forceMove(droploc)
				I.throw_at_old(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),5)

			qdel(src)

/****************************************************
			   HELPERS
****************************************************/

/obj/item/organ/external/proc/is_stump()
	return 0

/obj/item/organ/external/proc/release_restraints(var/mob/living/carbon/human/holder)
	if(!holder)
		holder = owner
	if(!holder)
		return
	if (holder.handcuffed && (body_part_flags in list(ARM_LEFT, ARM_RIGHT, HAND_LEFT, HAND_RIGHT)))
		holder.visible_message(\
			"\The [holder.handcuffed.name] falls off of [holder.name].",\
			"\The [holder.handcuffed.name] falls off you.")
		holder.drop_item_to_ground(holder.handcuffed, INV_OP_FORCE)
	if (holder.legcuffed && (body_part_flags in list(FOOT_LEFT, FOOT_RIGHT, LEG_LEFT, LEG_RIGHT)))
		holder.visible_message(\
			"\The [holder.legcuffed.name] falls off of [holder.name].",\
			"\The [holder.legcuffed.name] falls off you.")
		holder.drop_item_to_ground(holder.legcuffed, INV_OP_FORCE)

// checks if all wounds on the organ are bandaged
/obj/item/organ/external/proc/is_bandaged()
	for(var/datum/wound/W as anything in wounds)
		if(W.internal) continue
		if(!W.bandaged)
			return 0
	return 1

// checks if all wounds on the organ are salved
/obj/item/organ/external/proc/is_salved()
	for(var/datum/wound/W as anything in wounds)
		if(W.internal) continue
		if(!W.salved)
			return 0
	return 1

// checks if all wounds on the organ are disinfected
/obj/item/organ/external/proc/is_disinfected()
	for(var/datum/wound/W as anything in wounds)
		if(W.internal) continue
		if(!W.disinfected)
			return 0
	return 1

/obj/item/organ/external/proc/bandage()
	var/rval = 0
	status &= ~ORGAN_BLEEDING
	for(var/datum/wound/W as anything in wounds)
		if(W.internal) continue
		rval |= !W.bandaged
		W.bandaged = 1
	return rval

/obj/item/organ/external/proc/salve()
	var/rval = 0
	for(var/datum/wound/W as anything in wounds)
		rval |= !W.salved
		W.salved = 1
	return rval

/obj/item/organ/external/proc/disinfect()
	var/rval = 0
	for(var/datum/wound/W as anything in wounds)
		if(W.internal) continue
		rval |= !W.disinfected
		W.disinfected = 1
		W.germ_level = 0
	return rval

/obj/item/organ/external/proc/organ_clamp()
	var/rval = 0
	src.status &= ~ORGAN_BLEEDING
	for(var/datum/wound/W as anything in wounds)
		if(W.internal) continue
		rval |= !W.clamped
		W.clamped = 1
	return rval

/obj/item/organ/external/proc/fracture()
	if(robotic >= ORGAN_ROBOT)
		return	//ORGAN_BROKEN doesn't have the same meaning for robot limbs
	if((status & ORGAN_BROKEN) || cannot_break)
		return

	if(owner)
		owner.visible_message(\
			"<span class='danger'>You hear a loud cracking sound coming from \the [owner].</span>",\
			"<span class='danger'>Something feels like it shattered in your [name]!</span>",\
			"<span class='danger'>You hear a sickening crack.</span>")
		jostle_bone()
		if(organ_can_feel_pain() && IS_CONSCIOUS(owner) && !isbelly(owner.loc))
			INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob, emote), "scream")

	playsound(src.loc, "fracture", 10, 1, -2)
	status |= ORGAN_BROKEN
	broken_description = pick("broken","fracture","hairline fracture")

	// Fractures have a chance of getting you out of restraints
	if (prob(25))
		release_restraints()

	// This is mostly for the ninja suit to stop ninja being so crippled by breaks.
	// TODO: consider moving this to a suit proc or process() or something during
	// hardsuit rewrite.

	if(!(splinted) && owner && istype(owner.wear_suit, /obj/item/clothing/suit/space))
		var/obj/item/clothing/suit/space/suit = owner.wear_suit
		suit.handle_fracture(owner, src)

	return 1

/obj/item/organ/external/proc/mend_fracture()
	if(robotic >= ORGAN_ROBOT)
		return 0	//ORGAN_BROKEN doesn't have the same meaning for robot limbs
	if(brute_dam > min_broken_damage)
		return 0	//will just immediately fracture again

	status &= ~ORGAN_BROKEN
	return 1

/obj/item/organ/external/proc/apply_splint(var/atom/movable/splint)
	if(!splinted)
		splinted = splint
		if(!applied_pressure)
			applied_pressure = splint
		return 1
	return 0

/obj/item/organ/external/proc/remove_splint()
	if(splinted)
		if(splinted.loc == src)
			splinted.dropInto(owner? owner.loc : src.loc)
		if(applied_pressure == splinted)
			applied_pressure = null
		splinted = null
		return 1
	return 0

/obj/item/organ/external/robotize(var/company, var/skip_prosthetics = 0, var/keep_organs = 0, force)
		//* SHITCODE ALERT: REFACTOR ORGANS ASAP; FORCE IS JUST SO PREFS WORK.
	if(robotic >= ORGAN_ROBOT && !force)
		return

	..()

	if(company)
		model = company
		var/datum/robolimb/R = GLOB.all_robolimbs[isnum(company) ? GLOB.all_robolimbs[company] : company]
		if(!R || (species && (species.name in R.species_cannot_use)))
			R = GLOB.basic_robolimb
		if(R)
			force_icon = R.icon
			brute_mod = initial(brute_mod)
			burn_mod = initial(brute_mod)
			brute_mod *= R.robo_brute_mod
			burn_mod *= R.robo_burn_mod
			if(R.lifelike)
				robotic = ORGAN_LIFELIKE
				name = "[initial(name)]"
			else if(R.modular_bodyparts == MODULAR_BODYPART_PROSTHETIC)
				name = "prosthetic [initial(name)]"
			else
				name = "robotic [initial(name)]"
			desc = "[R.desc] It looks like it was produced by [R.company]."

	dislocated = -1
	cannot_break = 1
	min_broken_damage = ROBOLIMB_REPAIR_CAP // Makes robotic limb damage scalable
	remove_splint()
	get_icon()
	unmutate()

	for(var/obj/item/organ/external/T in children)
		T.robotize(company, keep_organs = keep_organs)

	if(owner)

		if(!keep_organs)
			for(var/obj/item/organ/thing in internal_organs)
				if(istype(thing))
					if(thing.vital)
						continue
					internal_organs -= thing
					owner.internal_organs_by_name[thing.organ_tag] = null
					owner.internal_organs_by_name -= thing.organ_tag
					owner.internal_organs.Remove(thing)
					qdel(thing)

		while(null in owner.internal_organs)
			owner.internal_organs -= null
		owner.refresh_modular_limb_verbs()
	return 1

	//* ## VIRGO HOOK, TODO: Integrate this.
//Sideways override for nanoform limbs (ugh)
/obj/item/organ/external/robotize(var/company, var/skip_prosthetics = FALSE, var/keep_organs = FALSE, force)
	var/original_robotic = robotic
	if(original_robotic >= ORGAN_NANOFORM)
		var/o_encased = encased
		var/o_max_damage = max_damage
		var/o_min_broken_damage = min_broken_damage
		robotic = FALSE
		. = ..(company = company, keep_organs = TRUE)
		robotic = original_robotic
		encased = o_encased
		max_damage = o_max_damage
		min_broken_damage = o_min_broken_damage
	else
		return ..()

/obj/item/organ/external/proc/mutate()
	if(src.robotic >= ORGAN_ROBOT)
		return
	src.status |= ORGAN_MUTATED
	if(owner) owner.update_icons_body()

/obj/item/organ/external/proc/unmutate()
	src.status &= ~ORGAN_MUTATED
	if(owner) owner.update_icons_body()

/obj/item/organ/external/proc/get_damage()	//returns total damage
	return (brute_dam+burn_dam)	//could use max_damage?

/obj/item/organ/external/proc/has_infected_wound()
	for(var/datum/wound/W as anything in wounds)
		if(W.germ_level > INFECTION_LEVEL_ONE)
			return 1
	return 0

/obj/item/organ/external/proc/is_usable()
	return !(status & (ORGAN_MUTATED|ORGAN_DEAD))

/obj/item/organ/external/proc/is_malfunctioning()
	return ((robotic >= ORGAN_ROBOT) && (brute_dam + burn_dam) >= min_broken_damage*0.83 && prob(brute_dam + burn_dam)) // Makes robotic limb damage scalable

// TODO: rework embeds, this only works for tiny items right now as
//       larger ones won't be removable!!
/obj/item/organ/external/proc/embed(var/obj/item/W, var/silent = 0)
	if(!owner || loc != owner)
		return
	if(owner.species.reagent_tag == IS_SLIME)
		create_wound( WOUND_TYPE_CUT, 15 )  //fixes proms being bugged into paincrit;instead whatever would embed now just takes a chunk out
		src.visible_message("<font color='red'>[owner] has been seriously wounded by [W]!</font>")
		W.add_blood(owner)
		return 0
	if(ismob(W.loc))
		var/mob/M = W.loc
		if(!M.can_unequip(W))
			return
	if(!silent)
		owner.visible_message("<span class='danger'>\The [W] sticks in the wound!</span>")
	implants += W
	owner.embedded_flag = 1
	// add_verb(owner, /mob/proc/yank_out_object)
	if(!(owner.species.species_flags & NO_BLOOD))
		W.add_blood(owner)
	W.forceMove(owner)

/obj/item/organ/external/removed(var/mob/living/user, var/ignore_children = 0)
	if(!owner)
		return
	owner.reconsider_inventory_slot_bodypart(organ_tag)
	var/is_robotic = robotic >= ORGAN_ROBOT
	var/mob/living/carbon/human/victim = owner

	// todo: removed() is not necessarily reliable.
	for(var/datum/physiology_modifier/modifier as anything in owner.physiology_modifiers)
		// todo: check biology
		if(!physiology.revert(modifier))
			// todo: optimize?
			rebuild_physiology()
			for(var/datum/physiology_modifier/rebuilding as anything in owner.physiology_modifiers)
				// todo: check biology
				physiology.apply(rebuilding)

	..()

	victim.bad_external_organs -= src

	for(var/atom/movable/implant in implants)
		//large items and non-item objs fall to the floor, everything else stays
		var/obj/item/I = implant
		if(istype(I) && I.w_class < WEIGHT_CLASS_NORMAL)
			implant.forceMove(victim.drop_location())
		else
			implant.forceMove(src)
	implants.Cut()

	// Attached organs also fly off.
	if(!ignore_children)
		for(var/obj/item/organ/external/O in children)
			O.removed()
			if(O)
				O.forceMove(src)
				for(var/obj/item/I in O.contents)
					I.forceMove(src)

	// Grab all the internal giblets too.
	for(var/obj/item/organ/organ in internal_organs)
		organ.removed()
		organ.forceMove(src)

	// Remove parent references
	parent?.children -= src
	parent = null

	release_restraints(victim)
	victim.organs -= src
	victim.organs_by_name[organ_tag] = null // Remove from owner's vars.

	status |= ORGAN_CUT_AWAY //Checked during surgeries to reattach it

	//Robotic limbs explode if sabotaged.
	if(is_robotic && sabotaged)
		victim.visible_message(
			"<span class='danger'>\The [victim]'s [src.name] explodes violently!</span>",\
			"<span class='danger'>Your [src.name] explodes!</span>",\
			"<span class='danger'>You hear an explosion!</span>")
		explosion(get_turf(owner),-1,-1,2,3)
		var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
		spark_system.set_up(5, 0, victim)
		spark_system.attach(owner)
		spark_system.start()
		spawn(10)
			qdel(spark_system)
		qdel(src)

	victim.refresh_modular_limb_verbs()
	victim.update_icons_body()

/obj/item/organ/external/proc/disfigure(var/type = "brute")
	if (disfigured)
		return
	if(owner)
		if(type == "brute")
			owner.visible_message("<span class='danger'>You hear a sickening cracking sound coming from \the [owner]'s [name].</span>",	\
			"<span class='danger'>Your [name] becomes a mangled mess!</span>",	\
			"<span class='danger'>You hear a sickening crack.</span>")
		else
			owner.visible_message("<span class='danger'>\The [owner]'s [name] melts away, turning into mangled mess!</span>",	\
			"<span class='danger'>Your [name] melts away!</span>",	\
			"<span class='danger'>You hear a sickening sizzle.</span>")
	disfigured = 1

/obj/item/organ/external/proc/jostle_bone(force)
	if(!(status & ORGAN_BROKEN)) //intact bones stay still
		return
	if(brute_dam + force < min_broken_damage/5)	//no papercuts moving bones
		return
	if(internal_organs.len && prob(brute_dam + force))
		owner.custom_pain("A piece of bone in your [encased ? encased : name] moves painfully!", 50)
		var/obj/item/organ/I = pick(internal_organs)
		I.take_damage(rand(3,5))

/obj/item/organ/external/proc/get_wounds_desc()
	. = ""
	if(status & ORGAN_DESTROYED && !is_stump())
		. += "tear at [amputation_point] so severe that it hangs by a scrap of flesh"

	//Handle robotic and synthetic organ damage
	if(robotic >= ORGAN_ROBOT)
		var/LL //Life-Like, aka only show that it's robotic in heavy damage
		if(robotic >= ORGAN_LIFELIKE)
			LL = 1
		if(brute_dam)
			switch(brute_dam)
				if(0 to 20)
					. += "some [LL ? "cuts" : "dents"]"
				if(21 to INFINITY)
					. += "[LL ? pick("exposed wiring","torn-back synthflesh") : pick("a lot of dents","severe denting")]"

		if(brute_dam && burn_dam)
			. += " and "

		if(burn_dam)
			switch(burn_dam)
				if(0 to 20)
					. += "some burns"
				if(21 to INFINITY)
					. += "[LL ? pick("roasted synth-flesh","melted internal wiring") : pick("many burns","scorched metal")]"

		if(open)
			if(brute_dam || burn_dam)
				. += " and "
			if(open == 1)
				. += "some exposed screws"
			else
				. += "an open panel"

		return

	//Normal organic organ damage
	var/list/wound_descriptors = list()
	if(open > 1)
		wound_descriptors["an open incision"] = 1
	else if (open)
		wound_descriptors["an incision"] = 1
	for(var/datum/wound/W as anything in wounds)
		if(W.internal && !open) continue // can't see internal wounds
		var/this_wound_desc = W.desc

		if(W.wound_type == WOUND_TYPE_BURN && W.salved)
			this_wound_desc = "salved [this_wound_desc]"

		if(W.bleeding())
			this_wound_desc = "bleeding [this_wound_desc]"
		else if(W.bandaged)
			this_wound_desc = "bandaged [this_wound_desc]"

		if(W.germ_level > 600)
			this_wound_desc = "badly infected [this_wound_desc]"
		else if(W.germ_level > 330)
			this_wound_desc = "lightly infected [this_wound_desc]"

		if(wound_descriptors[this_wound_desc])
			wound_descriptors[this_wound_desc] += W.amount
		else
			wound_descriptors[this_wound_desc] = W.amount

	if(wound_descriptors.len)
		var/list/flavor_text = list()
		var/list/no_exclude = list("gaping wound", "big gaping wound", "massive wound", "large bruise",\
		"huge bruise", "massive bruise", "severe burn", "large burn", "deep burn", "carbonised area") //note to self make this more robust
		for(var/wound in wound_descriptors)
			switch(wound_descriptors[wound])
				if(1)
					flavor_text += "[prob(10) && !(wound in no_exclude) ? "what might be " : ""]a [wound]"
				if(2)
					flavor_text += "[prob(10) && !(wound in no_exclude) ? "what might be " : ""]a pair of [wound]s"
				if(3 to 5)
					flavor_text += "several [wound]s"
				if(6 to INFINITY)
					flavor_text += "a ton of [wound]\s"
		return english_list(flavor_text)

// Returns a list of the clothing (not glasses) that are covering this part
/obj/item/organ/external/proc/get_covering_clothing(var/target_covering)	// target_covering checks for mouth/eye coverage
	var/list/covering_clothing = list()

	if(!target_covering)
		target_covering = src.body_part_flags

	if(owner)
		var/list/protective_gear = list(owner.head, owner.wear_mask, owner.wear_suit, owner.w_uniform, owner.gloves, owner.shoes, owner.glasses)
		for(var/obj/item/clothing/gear in protective_gear)
			if(gear.body_cover_flags & target_covering)
				covering_clothing |= gear
			if(LAZYLEN(gear.accessories))
				for(var/obj/item/clothing/accessory/bling in gear.accessories)
					if(bling.body_cover_flags & src.body_part_flags)
						covering_clothing |= bling

	return covering_clothing

/obj/item/organ/external/proc/queue_syringe_infection()
	if(!syringe_infection_queued)
		syringe_infection_queued = 100
		addtimer(CALLBACK(src, PROC_REF(do_syringe_infection)), rand(5, 10) MINUTES)
	else
		syringe_infection_queued = clamp(syringe_infection_queued + 10, 0, 300)

/obj/item/organ/external/proc/do_syringe_infection()
	if(germ_level < syringe_infection_queued)
		germ_level = syringe_infection_queued
	syringe_infection_queued = null

/obj/item/organ/external/proc/has_genitals()
	return !BP_IS_ROBOTIC(src) && species && species.sexybits_location == organ_tag

/obj/item/organ/external/proc/is_hidden_by_tail()
	if(owner && owner.tail_style && owner.tail_style.hide_body_parts && (organ_tag in owner.tail_style.hide_body_parts))
		return TRUE

/mob/living/carbon/human/proc/has_embedded_objects()
	. = 0
	for(var/obj/item/organ/external/L in organs)
		for(var/obj/item/I in L.implants)
			if(!istype(I,/obj/item/implant) && !istype(I,/obj/item/nif))
				return TRUE

//* Hand Integration *//

// todo: some kind of API for querying what hands this organ provides
//       this will require organs be composition instead of inheritance,
//       as defining this on every left / right hand would be satanic.

//* Environmentals *//

// todo: limb specific

//* Physiology *//

/obj/item/organ/external/proc/rebuild_physiology()
	physiology = new
	for(var/datum/physiology_modifier/modifier as anything in physiology_modifiers)
		if(!istype(modifier))
			physiology_modifiers -= modifier
			continue
		physiology.apply(modifier)

/obj/item/organ/external/proc/init_local_physiology()
	for(var/i in 1 to length(physiology_modifiers))
		if(ispath(physiology_modifiers[i]))
			physiology_modifiers[i] = cached_physiology_modifier(physiology_modifiers[i])
	rebuild_physiology()

/obj/item/organ/external/proc/add_local_physiology_modifier(datum/physiology_modifier/modifier)
	if(ispath(modifier))
		modifier = cached_physiology_modifier(modifier)
	ASSERT(!(modifier in physiology_modifiers))
	LAZYADD(physiology_modifiers, modifier)
	physiology.apply(modifier)
	return TRUE

/obj/item/organ/external/proc/remove_local_physiology_modifier(datum/physiology_modifier/modifier)
	if(ispath(modifier))
		modifier = cached_physiology_modifier(modifier)
	ASSERT(modifier in physiology_modifiers)
	LAZYREMOVE(physiology_modifiers, modifier)
	if(!physiology.revert(modifier))
		// todo: optimize with reset().
		rebuild_physiology()
	return TRUE

/obj/item/organ/external/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(null, "-----")
	VV_DROPDOWN_OPTION(VV_HK_ADD_PHYSIOLOGY_MODIFIER, "Add Physiology Modifier")
	VV_DROPDOWN_OPTION(VV_HK_REMOVE_PHYSIOLOGY_MODIFIER, "Remove Physiology Modifier")

/obj/item/organ/external/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_ADD_PHYSIOLOGY_MODIFIER])
		// todo: this should be able to be done globally via admin panel and then added to mobs

		var/datum/physiology_modifier/modifier = ask_admin_for_a_physiology_modifier(usr)

		if(isnull(modifier))
			return
		if(QDELETED(src))
			return

		log_admin("[key_name(usr)] --> organ [ref(src)] - added physiology modifier [json_encode(modifier.serialize())]")
		add_local_physiology_modifier(modifier)
		return TRUE

	if(href_list[VV_HK_REMOVE_PHYSIOLOGY_MODIFIER])
		var/list/assembled = list()
		var/i = 0
		for(var/datum/physiology_modifier/modifier as anything in physiology_modifiers)
			assembled["[modifier.name] (#[++i])"] = modifier
		var/picked = input(usr, "Which modifier to remove? Please do not do this unless you know what you are doing.", "Remove Physiology Modifier") as null|anything in assembled
		var/datum/physiology_modifier/removing = assembled[picked]
		if(!(removing in physiology_modifiers))
			return TRUE
		log_admin("[key_name(usr)] --> organ [ref(src)] - removed physiology modifier [json_encode(removing.serialize())]")
		remove_local_physiology_modifier(removing)
		return TRUE

// i'm not going to fucking support vv without automated backreferences and macros, holy shit.
// /obj/item/organ/external/proc/get_varedit_physiology_modifier()
// 	RETURN_TYPE(/datum/physiology_modifier)
// 	. = locate(/datum/physiology_modifier/varedit) in physiology_modifiers
// 	if(!isnull(.))
// 		return
// 	var/datum/physiology_modifier/varedit/new_holder = new
// 	add_local_physiology_modifier(new_holder)
// 	return new_holder
