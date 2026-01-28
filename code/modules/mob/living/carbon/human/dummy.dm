/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = STATUS_GODMODE | STATUS_CAN_PUSH
	ssd_visible = FALSE
	no_vore = TRUE //Dummies don't need bellies.
	var/in_use = FALSE

INITIALIZE_IMMEDIATE(/mob/living/carbon/human/dummy)

/mob/living/carbon/human/dummy/Destroy()
	in_use = FALSE
	return ..()

/mob/living/carbon/human/dummy/Life(seconds_per_tick)
	SHOULD_CALL_PARENT(FALSE) // no.
	return

/mob/living/carbon/human/dummy/proc/wipe_state()
	delete_inventory(TRUE, TRUE)
	set_species(/datum/species/human, TRUE, TRUE)
	cut_overlays(TRUE)

// NO STOP USING THESE FOR ANYTHING BUT PREFS SETUP <- no fuck off i need standardized humans for ci
// MAKE SOMETHING THAT ISN'T /HUMAN IF YOU JUST WANT A MANNEQUIN THIS IS NOT HARD TO FIGURE OUT
// DONT USE THE SUPER COMPLICATED PLAYER MOB WITH ORGANS FOR A *MANNEQUIN*, WHY??
INITIALIZE_IMMEDIATE(/mob/living/carbon/human/dummy/mannequin)
/mob/living/carbon/human/dummy/mannequin

/mob/living/carbon/human/dummy/mannequin/Initialize(mapload)
	. = ..()
	delete_inventory()

//Inefficient pooling/caching way.
GLOBAL_LIST_EMPTY(human_dummy_list)
GLOBAL_LIST_EMPTY(dummy_mob_list)

/proc/generate_or_wait_for_human_dummy(slotkey)
	if(!slotkey)
		return new /mob/living/carbon/human/dummy/mannequin
	var/mob/living/carbon/human/dummy/mannequin/D = GLOB.human_dummy_list[slotkey]
	if(istype(D))
		UNTIL(!D.in_use)
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
		carbon_target.dna = copycat.dna.Clone()

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
	var/mob/living/carbon/human/dummy/D = GLOB.human_dummy_list[slotkey]
	if(istype(D))
		D.wipe_state()
		D.in_use = FALSE

/proc/clear_human_dummy(slotkey)
	if(!slotkey)
		return

	var/mob/living/carbon/human/dummy/mannequin/dummy = GLOB.human_dummy_list[slotkey]

	GLOB.human_dummy_list -= slotkey
	if(istype(dummy))
		GLOB.dummy_mob_list -= dummy
		qdel(dummy)

/// Provides a dummy for unit_tests that functions like a normal human, but with a standardized appearance
/// Copies the stock dna setup from the dummy/consistent type
/mob/living/carbon/human/consistent
	ssd_visible = FALSE

// make it "consistent" enough
/mob/living/carbon/human/consistent/Initialize(mapload, datum/species/specieslike)
	. = ..()
	set_species(/datum/species/human, force = TRUE, regen_icons = FALSE)
	real_name = "John Doe"
	name = "John Doe"

	nutrition = 400
	hydration = 400

	// retrigger dna creation since its name based
	if(dna)
		dna.ready_dna(src)
		dna.real_name = real_name
		sync_organ_dna()
