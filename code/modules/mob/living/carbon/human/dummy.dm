/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = STATUS_GODMODE | STATUS_CAN_PUSH
	ssd_visible = FALSE
	no_vore = TRUE //Dummies don't need bellies.

// NO STOP USING THESE FOR ANYTHING BUT PREFS SETUP
// MAKE SOMETHING THAT ISN'T /HUMAN IF YOU JUST WANT A MANNEQUIN THIS IS NOT HARD TO FIGURE OUT
// DONT USE THE SUPER COMPLICATED PLAYER MOB WITH ORGANS FOR A *MANNEQUIN*, WHY??
INITIALIZE_IMMEDIATE(/mob/living/carbon/human/dummy/mannequin)
/mob/living/carbon/human/dummy/mannequin
	/// currently locked for usage
	var/in_use = FALSE

/mob/living/carbon/human/dummy/mannequin/Initialize(mapload)
	. = ..()
	GLOB.mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	delete_inventory()

/mob/living/carbon/human/dummy/mannequin/proc/wipe_state()
	delete_inventory(TRUE, TRUE)
	set_species(/datum/species/human, TRUE, TRUE)

/mob/living/carbon/human/dummy/mannequin/proc/unset_busy()
	wipe_state()
	in_use = FALSE

//Inefficient pooling/caching way.
GLOBAL_LIST_EMPTY(human_dummy_list)
GLOBAL_LIST_EMPTY(dummy_mob_list)

/proc/generate_or_wait_for_human_dummy(slotkey)
	if(!slotkey)
		return new /mob/living/carbon/human/dummy/mannequin
	var/mob/living/carbon/human/dummy/mannequin/D = GLOB.human_dummy_list[slotkey]
	if(istype(D))
		UNTIL(!D.in_use)
	else
		pass()
	if(QDELETED(D))
		D = new
		GLOB.human_dummy_list[slotkey] = D
		GLOB.dummy_mob_list += D
	else
		D.regenerate_icons() //they were cut in wipe_state()
	D.in_use = TRUE
	return D

/*
/proc/generate_dummy_lookalike(slotkey, mob/target)
	if(!istype(target))
		return generate_or_wait_for_human_dummy(slotkey)

	var/mob/living/carbon/human/dummy/mannequin/copycat = generate_or_wait_for_human_dummy(slotkey)

	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.dna.transfer_identity(copycat, transfer_SE = TRUE)

		if(ishuman(target))
			var/mob/living/carbon/human/human_target = target
			human_target.copy_clothing_prefs(copycat)

		copycat.updateappearance(icon_update=TRUE, mutcolor_update=TRUE, mutations_overlay_update=TRUE)
	else
		//even if target isn't a carbon, if they have a client we can make the
		//dummy look like what their human would look like based on their prefs
		target?.client?.prefs?.copy_to(copycat, icon_updates=TRUE, roundstart_checks=FALSE)

	return copycat
*/

/proc/unset_busy_human_dummy(slotkey)
	if(!slotkey)
		return
	var/mob/living/carbon/human/dummy/mannequin/D = GLOB.human_dummy_list[slotkey]
	if(istype(D))
		D.unset_busy()

/proc/clear_human_dummy(slotkey)
	if(!slotkey)
		return

	var/mob/living/carbon/human/dummy/mannequin/dummy = GLOB.human_dummy_list[slotkey]

	GLOB.human_dummy_list -= slotkey
	if(istype(dummy))
		GLOB.dummy_mob_list -= dummy
		qdel(dummy)
