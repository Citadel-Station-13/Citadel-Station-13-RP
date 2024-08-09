/mob/living/silicon/emp_act(severity)
	switch(severity)
		if(1)
			src.take_random_targeted_damage(brute = 0, burn = 20, damage_mode = DAMAGE_MODE_INTERNAL, weapon_descriptor = "electromagnetic surge")
			Confuse(5)
		if(2)
			src.take_random_targeted_damage(brute = 0, burn = 15, damage_mode = DAMAGE_MODE_INTERNAL, weapon_descriptor = "electromagnetic surge")
			Confuse(4)
		if(3)
			src.take_random_targeted_damage(brute = 0, burn = 10, damage_mode = DAMAGE_MODE_INTERNAL, weapon_descriptor = "electromagnetic surge")
			Confuse(3)
		if(4)
			src.take_random_targeted_damage(brute = 0, burn = 5, damage_mode = DAMAGE_MODE_INTERNAL, weapon_descriptor = "electromagnetic surge")
			Confuse(2)
	flash_eyes(affect_silicon = 1)
	to_chat(src, "<span class='danger'><B>*BZZZT*</B></span>")
	to_chat(src, "<span class='danger'>Warning: Electromagnetic pulse detected.</span>")
	..()

/mob/living/silicon/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone, var/used_weapon=null)
	return	//immune

/mob/living/silicon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, var/def_zone = null, var/stun = 1)
	if(shock_damage > 0)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, loc)
		s.start()

		shock_damage *= siemens_coeff	//take reduced damage
		take_overall_damage(0, shock_damage)
		visible_message("<span class='warning'>[src] was shocked by \the [source]!</span>", \
			"<span class='danger'>Energy pulse detected, system damaged!</span>", \
			"<span class='warning'>You hear an electrical crack.</span>")
		if(prob(20))
			afflict_stun(20 * 2)
		return

/mob/living/silicon/legacy_ex_act(severity)
	if(!has_status_effect(/datum/status_effect/sight/blindness))
		flash_eyes()

	switch(severity)
		if(1.0)
			if (stat != 2)
				adjustBruteLoss(100)
				adjustFireLoss(100)
				if(!anchored)
					gib()
		if(2.0)
			if (stat != 2)
				adjustBruteLoss(60)
				adjustFireLoss(60)
		if(3.0)
			if (stat != 2)
				adjustBruteLoss(30)

	update_health()
