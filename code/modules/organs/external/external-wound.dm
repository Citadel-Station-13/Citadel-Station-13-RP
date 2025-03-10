/**
 * Creates a wound on this organ.
 *
 * todo: better documentation
 */
/obj/item/organ/external/proc/create_wound(var/type = WOUND_TYPE_CUT, var/damage)
	if(damage == 0)
		return

	//moved this before the open_wound check so that having many small wounds for example doesn't somehow protect you from taking internal damage (because of the return)
	//Possibly trigger an internal wound, too.
	var/local_damage = brute_dam + burn_dam + damage
	if((damage > 15) && (type != WOUND_TYPE_BURN) && (local_damage > 30) && prob(damage) && (robotic < ORGAN_ROBOT) && !(species.species_flags & NO_BLOOD))
		create_specific_wound(/datum/wound/internal_bleeding, min(damage - 15, 15))
		if(!(behaviour_flags & BODYPART_SILENT_WOUNDS))
			owner.custom_pain("You feel something rip in your [name]!", 50)

//Burn damage can cause fluid loss due to blistering and cook-off

	if((damage > 5 || damage + burn_dam >= 15) && type == WOUND_TYPE_BURN && (robotic < ORGAN_ROBOT) && !(species.species_flags & NO_BLOOD))
		var/fluid_loss = 0.4 * (damage/(owner.getMaxHealth() - owner.getMinHealth())) * owner.species.blood_volume*(1 - owner.species.blood_level_fatal)
		owner.erase_blood(fluid_loss)

	// first check whether we can widen an existing wound
	if(length(wounds) > 0 && prob(max(50+(wound_tally-1)*10,90)))
		if((type == WOUND_TYPE_CUT || type == WOUND_TYPE_BRUISE) && damage >= 5)
			//we need to make sure that the wound we are going to worsen is compatible with the type of damage...
			var/list/compatible_wounds = list()
			for (var/datum/wound/W as anything in wounds)
				if (W.can_worsen(type, damage))
					compatible_wounds += W

			if(compatible_wounds.len)
				var/datum/wound/W = pick(compatible_wounds)
				W.open_wound(damage)
				if(!(behaviour_flags & BODYPART_SILENT_WOUNDS) && prob(25))
					if(robotic >= ORGAN_ROBOT)
						owner.visible_message("<span class='danger'>The damage to [owner.name]'s [name] worsens.</span>",\
						"<span class='danger'>The damage to your [name] worsens.</span>",\
						"<span class='danger'>You hear the screech of abused metal.</span>")
					else
						owner.visible_message("<span class='danger'>The wound on [owner.name]'s [name] widens with a nasty ripping noise.</span>",\
						"<span class='danger'>The wound on your [name] widens with a nasty ripping noise.</span>",\
						"<span class='danger'>You hear a nasty ripping noise, as if flesh is being torn apart.</span>")
				return

	//Creating wound
	var/wound_type = get_wound_type(type, damage)

	if(wound_type)
		var/datum/wound/W = new wound_type(damage, behaviour_flags & BODYPART_NO_INFECTION)

		//Check whether we can add the wound to an existing wound
		for(var/datum/wound/other as anything in wounds)
			if(other.can_merge(W))
				other.merge_wound(W)
				W = null // to signify that the wound was added
				break
		if(W)
			LAZYADD(wounds, W)

/**
 * Creates a specific kind of wound on this organ.
 *
 * This only creates the wound, it does not do damage side effects,
 * like vaporizing blood with burns, etc
 *
 * Such side effects should not be in the procs for making wounds!
 *
 * If you need to modify variables other than "damage", grab the returned wound.
 *
 * @params
 * * path - typepath of /datum/wound to create.
 * * damage - amount of damage it should have.
 * * updating - update damages?
 *
 * @return the /datum/wound created, *or* the /datum/wound merged, *or* null if it was rejected.
 */
/obj/item/organ/external/proc/create_specific_wound(path, damage, updating = TRUE)
	ASSERT(ispath(path, /datum/wound))

	var/datum/wound/creating = new path(damage, behaviour_flags & BODYPART_NO_INFECTION)
	var/datum/wound/merged

	for(var/datum/wound/other as anything in wounds)
		if(other.can_merge(creating))
			other.merge_wound(creating)
			merged = other
			break

	if(isnull(merged))
		// didn't merge, add
		LAZYADD(wounds, creating)
		. = creating
	else
		// merged, return merged
		// we don't manually qdel creating - hopefully no one actually does something
		// deranged down the line like making wounds reference externally!
		. = merged

	if(updating)
		update_damages()

/**
 * Immediately cures a specific typepath of wound, or a specific instance of wound
 *
 * @params
 * * path - path of wound to cure, all subtypes count!
 * * all - cure all instances, or just one?
 * * updating - update damages?
 *
 * @return TRUE / FALSE based on if anything was removed.
 */
/obj/item/organ/external/proc/cure_specific_wound(datum/wound/path_or_instance, all = FALSE, updating = TRUE)
	. = FALSE
	// todo: remove the assert / is in check, free performance, only here to prevent accidental misuse for now.
	ASSERT(ispath(path_or_instance, /datum/wound))
	for(var/datum/wound/W in wounds)
		if(istype(W, path_or_instance))
			wounds -= W
			. = TRUE
			if(all)
				break

	if(!.)
		return

	if(updating)
		update_damages()

/**
 * Immediately cures a wound instance.
 *
 * Use this proc from within loops over the wounds list.
 *
 * Warning: We do not check if the wound exists.s
 *
 * @params
 * * wound - the wound to cure
 * * updating - update damages?
 */
/obj/item/organ/external/proc/cure_exact_wound(datum/wound/wound, updating = TRUE)
	wounds -= wound

	if(updating)
		update_damages()
