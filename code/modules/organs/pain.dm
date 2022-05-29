/mob/proc/flash_pain()
	flick("pain",pain)

/mob/var/list/pain_stored = list()
/mob/var/last_pain_message = ""
/mob/var/next_pain_time = 0

// message is the custom message to be displayed
// power decides how much painkillers will stop the message
// force means it ignores anti-spam timer
/mob/living/carbon/proc/custom_pain(message, power, force)
	if(!message || stat || !can_feel_pain() || chem_effects[CE_PAINKILLER] > power)
		return 0
	message = "<span class='danger'>[message]</span>"
	if(power >= 50)
		message = "<font size=3>[message]</font>"

	// Anti message spam checks
	if(force || (message != last_pain_message) || (world.time >= next_pain_time))
		last_pain_message = message
		to_chat(src, message)
		next_pain_time = world.time + (100 - power)

/mob/living/carbon/human/proc/handle_pain()
	if(stat)
		return

	if(!can_feel_pain())
		return

	if(world.time < next_pain_time)
		return
	var/maxdam = 0
	var/obj/item/organ/external/damaged_organ = null
	for(var/obj/item/organ/external/E in organs)
		if(!E.organ_can_feel_pain())
			continue
		var/dam = E.get_damage()
		// make the choice of the organ depend on damage,
		// but also sometimes use one of the less damaged ones
		if(dam > maxdam && (maxdam == 0 || prob(70)) )
			damaged_organ = E
			maxdam = dam
	if(damaged_organ && chem_effects[CE_PAINKILLER] < maxdam)
		if(maxdam > 10 && paralysis)
			AdjustParalysis(-round(maxdam/10))
		if(maxdam > 50 && prob(maxdam / 5))
			drop_item()
		var/burning = damaged_organ.burn_dam > damaged_organ.brute_dam
		var/msg
		if(painmsg)
			switch(maxdam)
				if(1 to 10)
					msg =  "<font size=3>Your [damaged_organ.name] [burning ? "burns" : "hurts"].</font>"
				if(11 to 90)
					flash_weak_pain()
					msg = "<font size=4>Your [damaged_organ.name] [burning ? "burns" : "hurts"] badly!</font>"
				if(91 to 10000)
					flash_pain()
					msg = "<font size=5>OH GOD! Your [damaged_organ.name] is [burning ? "on fire" : "hurting terribly"]!</font>"
		custom_pain(msg, maxdam, prob(10)) // keep this uniform with the other pain values

	// Damage to internal organs hurts a lot.
	for(var/obj/item/organ/I in internal_organs)
		if((I.status & ORGAN_DEAD) || I.robotic >= ORGAN_ROBOT)
			continue
		if(I.damage > 2)
			if(prob(25) && painmsg)
				var/obj/item/organ/external/parent = get_organ(I.parent_organ)
				src.custom_pain("You feel a sharp pain in your [parent.name]", 50)

	if(prob(25) && painmsg)
		switch(getToxLoss())
			if(1 to 10)
				custom_pain("Your body stings slightly.", getToxLoss())
			if(11 to 30)
				custom_pain("Your body hurts a little.", getToxLoss())
			if(31 to 60)
				custom_pain("Your whole body hurts badly.", getToxLoss())
			if(61 to INFINITY)
				custom_pain("Your body aches all over, it's driving you mad.", getToxLoss())


/*
/obj/item/organ/external/proc/stun_act(var/stun_amount, var/agony_amount)
	return
	if(agony_amount > 5 && owner && vital && get_pain() > 0.5 * max_damage)
		owner.visible_message("<span class='warning'>[owner] reels in pain!</span>")
		if(has_genitals() || get_pain() + agony_amount > max_damage)
			owner.Weaken(6)
		else
			owner.Stun(6)
			owner.drop_l_hand()
			owner.drop_r_hand()
		return 1

/obj/item/organ/external/proc/get_agony_multiplier()
	return has_genitals() ? 2 : 1
*/
