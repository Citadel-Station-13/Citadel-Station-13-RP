/*
	Animals
*/
/mob/living/simple_mob/UnarmedAttack(var/atom/A, var/proximity)
	if(!(. = ..()))
		return

//	setClickCooldown(get_attack_speed())

	if(has_hands && istype(A,/obj) && a_intent != INTENT_HARM)
		var/obj/O = A
		return O.attack_hand(src)

	switch(a_intent)
		if(INTENT_HELP)
			if(isliving(A))
				custom_emote(1,"[pick(friendly)] \the [A]!")

		if(INTENT_HARM)
			if(can_special_attack(A) && special_attack_target(A))
				return

			else if(melee_damage_upper == 0 && istype(A,/mob/living))
				custom_emote(1,"[pick(friendly)] \the [A]!")

			else
				attack_target(A)

		if(INTENT_GRAB)
			if(has_hands)
				A.attack_hand(src)
			else
				attack_target(A)

		if(INTENT_DISARM)
			if(has_hands)
				A.attack_hand(src)
			else
				attack_target(A)

/mob/living/simple_mob/RangedAttack(var/atom/A)
//	setClickCooldown(get_attack_speed())

	if(can_special_attack(A) && special_attack_target(A))
		return

	if(projectiletype)
		shoot_target(A)