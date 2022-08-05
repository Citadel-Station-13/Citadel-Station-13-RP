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

/mob/living/carbon/proc/attempt_cpr(atom/actor, delay = 1)

/mob/living/carbon/proc/__cpr_ventilation_end()
	REMOVE_TRAIT(src, TRAIT_MECHANICAL_VENTILATION, CPR_TRAIT)

/mob/living/carbon/proc/__cpr_organ_stasis_end()
	REMOVE_TRAIT(src, TRAIT_NO_BRAIN_DECAY, CPR_TRAIT)

/mob/living/carbon/proc/__cpr_off_cooldown()
	REMOVE_TRAIT(src, TRAIT_CPR_COOLDOWN, CPR_TRAIT)


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
	ADD_TRAIT(src, TRAIT_NO_BRAIN_DECAY, CPR_TRAIT)
	ADD_TRAIT(src, TRAIT_MECHANICAL_VENTILATION, CPR_TRAIT)

	addtimer(CALLBACK(src, .proc/__cpr_ventilation_end), CPR_VENTILATION_TIME, TIMER_OVERRIDE | TIMER_UNIQUE)
	addtimer(CALLBACK(src, .proc/__cpr_off_cooldown), CPR_NOMINAL_COOLDOWN, TIMER_OVERRIDE | TIMER_UNIQUE)
	addtimer(CALLBACK(src, .proc/__cpr_organ_stasis_end), CPR_BRAIN_STASIS_TIME, TIMER_OVERRIDE | TIMER_UNIQUE)

#warn hook brain decay
#warn hook mechanical ventilation
#warn cpr probably needs to do something about bloodloss/lung/heart damage oxyloss or it'll be useless

/*

			if(istype(H) && health < config_legacy.health_threshold_crit)
				if(!H.check_has_mouth())
					to_chat(H, "<span class='danger'>You don't have a mouth, you cannot perform CPR!</span>")
					return
				if(!check_has_mouth())
					to_chat(H, "<span class='danger'>They don't have a mouth, you cannot perform CPR!</span>")
					return
				if((H.head && (H.head.body_parts_covered & FACE)) || (H.wear_mask && (H.wear_mask.body_parts_covered & FACE)))
					to_chat(H, "<span class='notice'>Remove your mask!</span>")
					return 0
				if((head && (head.body_parts_covered & FACE)) || (wear_mask && (wear_mask.body_parts_covered & FACE)))
					to_chat(H, "<span class='notice'>Remove [src]'s mask!</span>")
					return 0

				if (!cpr_time)
					return 0

				cpr_time = 0
				spawn(30)
					cpr_time = 1

				H.visible_message("<span class='danger'>\The [H] is trying to perform CPR on \the [src]!</span>")

				if(!do_after(H, 30))
					return

				H.visible_message("<span class='danger'>\The [H] performs CPR on \the [src]!</span>")
				to_chat(H, "<span class='warning'>Repeat at least every 7 seconds.</span>")

				if(istype(H) && health > config_legacy.health_threshold_dead)
					adjustOxyLoss(-(min(getOxyLoss(), 5)))
					updatehealth()
					to_chat(src, "<span class='notice'>You feel a breath of fresh air enter your lungs. It feels good.</span>")
*/

