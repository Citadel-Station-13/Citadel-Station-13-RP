
/mob/living/simple_mob/proc/ai_autovore(mob/living/target_mob)
	ai_log_mob("vr/PunchTarget() [target_mob]", 3)

	// If we're not hungry, call the sideways "parent" to do normal punching
	if(!vore_active)
		return FALSE

	// If target is standing we might pounce and knock them down instead of attacking
	var/pouncechance = CanPounceTarget(target_mob)
	if(pouncechance)
		return PounceTarget(target_mob, pouncechance)

	// We're not attempting a pounce, if they're down or we can eat standing, do it as long as they're edible. Otherwise, hit normally.
	if(will_eat(target_mob) && (!target_mob.canmove || vore_standing_too))
		return EatTarget(target_mob)
	return FALSE

//Grab = Nomf
/mob/living/simple_mob/UnarmedAttack(var/atom/A, var/proximity)
	. = ..()
	if(a_intent == I_GRAB && isliving(A) && !has_hands)
		animal_nom(A)

/mob/living/simple_mob/proc/CanPounceTarget(mob/living/target_mob) //returns either FALSE or a %chance of success
	if(!target_mob.canmove || issilicon(target_mob) || world.time < vore_pounce_cooldown) //eliminate situations where pouncing CANNOT happen
		return FALSE
	if(!prob(vore_pounce_chance)) //mob doesn't want to pounce
		return FALSE
	if(will_eat(target_mob) && vore_standing_too) //100% chance of hitting people we can eat on the spot
		return 100
	var/TargetHealthPercent = (target_mob.health/target_mob.getMaxHealth())*100 //now we start looking at the target itself
	if (TargetHealthPercent > vore_pounce_maxhealth) //target is too healthy to pounce
		return FALSE
	else
		return max(0,(vore_pounce_successrate - (vore_pounce_falloff * TargetHealthPercent)))

/mob/living/simple_mob/proc/PounceTarget(mob/living/target_mob, successrate = 100)
	vore_pounce_cooldown = world.time + 20 SECONDS // don't attempt another pounce for a while
	if(prob(successrate)) // pounce success!
		target_mob.Weaken(5)
		target_mob.visible_message("<span class='danger'>\the [src] pounces on \the [target_mob]!</span>!")
	else // pounce misses!
		target_mob.visible_message("<span class='danger'>\the [src] attempts to pounce \the [target_mob] but misses!</span>!")
		playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

	if(will_eat(target_mob) && (!target_mob.canmove || vore_standing_too)) //if they're edible then eat them too
		return EatTarget()
	return FALSE

// Attempt to eat target
// TODO - Review this.  Could be some issues here
/mob/living/simple_mob/proc/EatTarget(mob/living/target_mob)
	ai_log_mob("vr/EatTarget() [target_mob]",2)
	if(ai_holder)
		set_AI_busy(TRUE)
	var/old_target = target_mob
	. = animal_nom(target_mob)
	playsound(src, swallowsound, 50, 1)
	update_icon()

	if(.)
		// If we succesfully ate them, lose the target
		if(ai_holder)
			ai_holder.lose_target()
		return old_target
	if(ai_holder)
		set_AI_busy(FALSE)

// Make sure you don't call ..() on this one, otherwise you duplicate work.
/mob/living/simple_mob/init_vore()
	if(!vore_active || no_vore)
		return

	if(!IsAdvancedToolUser())
		verbs |= /mob/living/simple_mob/proc/animal_nom
		verbs |= /mob/living/proc/shred_limb

	if(LAZYLEN(vore_organs))
		return

	//A much more detailed version of the default /living implementation
	var/obj/belly/B = new /obj/belly(src)
	vore_selected = B
	B.immutable = 1
	B.name = vore_stomach_name ? vore_stomach_name : "stomach"
	B.desc = vore_stomach_flavor ? vore_stomach_flavor : "Your surroundings are warm, soft, and slimy. Makes sense, considering you're inside \the [name]."
	B.digest_mode = vore_default_mode
	B.mode_flags = vore_default_flags
	B.escapable = vore_escape_chance > 0
	B.escapechance = vore_escape_chance
	B.digestchance = vore_digest_chance
	B.absorbchance = vore_absorb_chance
	B.human_prey_swallow_time = swallowTime
	B.nonhuman_prey_swallow_time = swallowTime
	B.vore_verb = "swallow"
	B.emote_lists[DM_HOLD] = list( // We need more that aren't repetitive. I suck at endo. -Ace
		"The insides knead at you gently for a moment.",
		"The guts glorp wetly around you as some air shifts.",
		"The predator takes a deep breath and sighs, shifting you somewhat.",
		"The stomach squeezes you tight for a moment, then relaxes harmlessly.",
		"The predator's calm breathing and thumping heartbeat pulses around you.",
		"The warm walls kneads harmlessly against you.",
		"The liquids churn around you, though there doesn't seem to be much effect.",
		"The sound of bodily movements drown out everything for a moment.",
		"The predator's movements gently force you into a different position.")
	B.emote_lists[DM_DIGEST] = list(
		"The burning acids eat away at your form.",
		"The muscular stomach flesh grinds harshly against you.",
		"The caustic air stings your chest when you try to breathe.",
		"The slimy guts squeeze inward to help the digestive juices soften you up.",
		"The onslaught against your body doesn't seem to be letting up; you're food now.",
		"The predator's body ripples and crushes against you as digestive enzymes pull you apart.",
		"The juices pooling beneath you sizzle against your sore skin.",
		"The churning walls slowly pulverize you into meaty nutrients.",
		"The stomach glorps and gurgles as it tries to work you into slop.")
