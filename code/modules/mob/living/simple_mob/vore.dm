
/mob/living/simple_mob/proc/ai_autovore(atom/A)
	ai_log_mob("vr/PunchTarget() [target_mob]", 3)

	// If we're not hungry, call the sideways "parent" to do normal punching
	if(!vore_active)
		return TRUE

	// If target is standing we might pounce and knock them down instead of attacking
	var/pouncechance = CanPounceTarget(A)
	if(pouncechance)
		return PounceTarget(A, pouncechance)

	// We're not attempting a pounce, if they're down or we can eat standing, do it as long as they're edible. Otherwise, hit normally.
	if(will_eat(target_mob) && (!target_mob.canmove || vore_standing_too))
		return EatTarget(A)
	else
		return TRUE

//Grab = Nomf
/mob/living/simple_mob/UnarmedAttack(var/atom/A, var/proximity)
	. = ..()

	if(a_intent == I_GRAB && isliving(A) && !has_hands)
		animal_nom(A)
