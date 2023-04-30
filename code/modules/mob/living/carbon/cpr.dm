// someday, we'll combine /carbon and /human to /complex
// let me believe.......

//! CPR code

/**
 * call to automatically attepmt a CPR interaction
 * usually done in attack hand for help intent
 *
 * return true to break the rest of the interaction chain (aka don't try to hug, etc)
 */
/mob/living/carbon/proc/attempt_cpr_interaction(mob/user)
	. = TRUE
	// must be in crit or dead
	// crit isn't a stat value so..
	if(!is_in_critical() && !IS_DEAD(src))
		return FALSE
	if(!check_has_mouth())
		to_chat(user, SPAN_WARNING("[src] has no mouth."))
		return
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.check_has_mouth())
		to_chat(user, SPAN_WARNING("You are either not human, or have no mouth."))
		return
	var/obj/item/in_the_way
	for(in_the_way as anything in get_equipped_items_in_slots(
		SLOT_ID_HEAD,
		SLOT_ID_MASK
	))
		if(!(in_the_way.body_cover_flags & FACE))
			continue
		to_chat(user, SPAN_WARNING("[src]'s [in_the_way] is in the way!"))
		return
	for(in_the_way as anything in user.get_equipped_items_in_slots(
		SLOT_ID_HEAD,
		SLOT_ID_MASK
	))
		if(!(in_the_way.body_cover_flags & FACE))
			continue
		to_chat(user, SPAN_WARNING("Your [in_the_way] is in the way!"))
		return
	if(HAS_TRAIT(src, TRAIT_CPR_IN_PROGRESS))
		to_chat(user, SPAN_WARNING("Someone is already doing CPR on [src]!"))
		return
	INVOKE_ASYNC(src, .proc/attempt_cpr, user)

/mob/living/carbon/proc/attempt_cpr(atom/actor, delay_mod = 1)
	actor.visible_message(SPAN_NOTICE("[actor] is trying to perform CPR on [src]!"))

	ADD_TRAIT(src, TRAIT_CPR_IN_PROGRESS, GENERIC_TRAIT)
	if(!do_after(actor, CPR_ACTION_TIME, src))
		REMOVE_TRAIT(src, TRAIT_CPR_IN_PROGRESS, GENERIC_TRAIT)
		return
	REMOVE_TRAIT(src, TRAIT_CPR_IN_PROGRESS, GENERIC_TRAIT)

	actor.visible_message(
		SPAN_BOLDNOTICE("[actor] performs CPR on [src]!"),
		SPAN_BOLDNOTICE("You perform CPR on [src]. Repeat at least every [CPR_NOMINAL_COOLDOWN * 0.1] seconds.")
	)

	cpr_act(actor)

/mob/living/carbon/proc/__cpr_ventilation_end()
	REMOVE_TRAIT(src, TRAIT_MECHANICAL_VENTILATION, CPR_TRAIT)

/mob/living/carbon/proc/__cpr_organ_stasis_end()
	REMOVE_TRAIT(src, TRAIT_PRESERVE_ALL_ORGANS, CPR_TRAIT)

/mob/living/carbon/proc/__cpr_off_cooldown()
	REMOVE_TRAIT(src, TRAIT_CPR_COOLDOWN, CPR_TRAIT)

/mob/living/carbon/proc/__cpr_circulation_end()
	REMOVE_TRAIT(src, TRAIT_MECHANICAL_CIRCULATION, CPR_TRAIT)

/mob/living/carbon/proc/__cpr_forced_metabolism(strength = 1)
	if(stat != DEAD)
		// nah we're still breathin'
		return

	bloodstr?.metabolize(strength, TRUE)
	ingested?.metabolize(strength, TRUE)
	touching?.metabolize(strength, TRUE)


/mob/living/carbon/proc/cpr_act(atom/actor)
	var/clipping = HAS_TRAIT(src, TRAIT_CPR_COOLDOWN)

	ADD_TRAIT(src, TRAIT_CPR_COOLDOWN, CPR_TRAIT)
	ADD_TRAIT(src, TRAIT_PRESERVE_ALL_ORGANS, CPR_TRAIT)
	ADD_TRAIT(src, TRAIT_MECHANICAL_VENTILATION, CPR_TRAIT)
	ADD_TRAIT(src, TRAIT_MECHANICAL_CIRCULATION, CPR_TRAIT)

	__cpr_forced_metabolism(clipping? CPR_FORCED_METABOLISM_STRENGTH_CLIPPED : CPR_FORCED_METABOLISM_STRENGTH_NOMINAL)

	if(!IS_DEAD(src))
		to_chat(src, SPAN_NOTICE("You feel a breath of fresh air enter your lungs. It feels good."))

	if(clipping)
		to_chat(actor, SPAN_WARNING("Too fast! Wait [(CPR_NOMINAL_COOLDOWN - CPR_ACTION_TIME) * 0.1] seconds after finishing a set of compressions to start another!"))

	addtimer(CALLBACK(src, .proc/__cpr_ventilation_end), CPR_VENTILATION_TIME, TIMER_OVERRIDE | TIMER_UNIQUE)
	addtimer(CALLBACK(src, .proc/__cpr_off_cooldown), CPR_NOMINAL_COOLDOWN, TIMER_OVERRIDE | TIMER_UNIQUE)
	addtimer(CALLBACK(src, .proc/__cpr_organ_stasis_end), CPR_BRAIN_STASIS_TIME, TIMER_OVERRIDE | TIMER_UNIQUE)
	addtimer(CALLBACK(src, .proc/__cpr_circulation_end), CPR_CIRCULATION_TIME, TIMER_OVERRIDE | TIMER_UNIQUE)
