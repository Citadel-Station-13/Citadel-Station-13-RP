/mob/living/carbon/Initialize(mapload)
	. = ..()
	//setup reagent holders
	bloodstr = new/datum/reagents/metabolism/bloodstream(500, src)
	ingested = new/datum/reagents/metabolism/ingested(500, src)
	touching = new/datum/reagents/metabolism/touch(500, src)
	reagents = bloodstr
	if (!default_language && species_language)
		default_language = SScharacters.resolve_language_name(species_language)

/mob/living/carbon/BiologicalLife(seconds, times_fired)
	if((. = ..()))
		return

	handle_viruses()

	// Increase germ_level regularly
	if(germ_level < GERM_LEVEL_AMBIENT && prob(30))	//if you're just standing there, you shouldn't get more germs beyond an ambient level
		germ_level++

/mob/living/carbon/Destroy()
	qdel(ingested)
	qdel(touching)
	// We don't qdel(bloodstr) because it's the same as qdel(reagents)
	for(var/guts in internal_organs)
		qdel(guts)
	for(var/food in stomach_contents)
		qdel(food)
	return ..()

/mob/living/carbon/rejuvenate()
	bloodstr.clear_reagents()
	ingested.clear_reagents()
	touching.clear_reagents()
	..()

/mob/living/carbon/gib()
	for(var/mob/M in src)
		if(M in src.stomach_contents)
			src.stomach_contents.Remove(M)
		M.loc = src.loc
		for(var/mob/N in viewers(src, null))
			if(N.client)
				N.show_message(text("<font color='red'><B>[M] bursts out of [src]!</B></font>"), 2)
	..()

/mob/living/carbon/attack_hand(mob/M as mob)
	if(!istype(M, /mob/living/carbon)) return ..()
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if (H.hand)
			temp = H.organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(H, "<font color='red'>You can't use your [temp.name]</font>")
			return
	return ..()

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/M)
	if(src.health >= config_legacy.health_threshold_crit)
		if(src == M && istype(src, /mob/living/carbon/human))

			var/mob/living/carbon/human/H = src
			var/datum/gender/T = GLOB.gender_datums[H.get_visible_gender()]
			var/to_send = "<blockquote class ='notice'>"
			src.visible_message("[src] examines [T.himself].", \
				SPAN_NOTICE("You check yourself for injuries."))

			for(var/obj/item/organ/external/org in H.organs)
				var/list/status = list()
				var/brutedamage = org.brute_dam
				var/burndamage = org.burn_dam

				if(hallucination) // Funny halloss
					if(prob(30))
						brutedamage += rand(30,40)
					if(prob(30))
						burndamage += rand(30,40)

				switch(brutedamage)
					if(1 to 20)
						status += "bruised"
					if(20 to 40)
						status += "wounded"
					if(40 to INFINITY)
						status += "mangled"

				switch(burndamage)
					if(1 to 10)
						status += "numb"
					if(10 to 40)
						status += "blistered"
					if(40 to INFINITY)
						status += "peeling away"

				if(org.is_stump())
					status += "MISSING"
				if(org.status & ORGAN_MUTATED)
					status += "weirdly shapen"
				if(org.dislocated == 2)
					status += "dislocated"
				if(org.status & ORGAN_BROKEN)
					status += "hurts when touched"
				if(org.status & ORGAN_DEAD)
					status += "is bruised and necrotic"
				if(!org.is_usable() || org.is_dislocated())
					status += "dangling uselessly"

				to_send += "<span class='[status.len ? "warning" : "notice"]'>Your [org.name] is [status.len ? "[english_list(status)]" : "OK"].</span>\n"
			to_send += "</blockquote>"
			to_chat(src, to_send)

			if((MUTATION_SKELETON in H.mutations) && (!H.w_uniform) && (!H.wear_suit))
				H.play_xylophone()
		else if (on_fire)
			playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
			if (M.on_fire)
				M.visible_message(SPAN_WARNING("[M] tries to pat out [src]'s flames, but to no avail!"),
					SPAN_WARNING("You try to pat out [src]'s flames, but to no avail! Put yourself out first!"))
			else
				M.visible_message(SPAN_WARNING("[M] tries to pat out [src]'s flames!"),
					SPAN_WARNING("You try to pat out [src]'s flames! Hot!"))
				if(do_mob(M, src, 15))
					src.adjust_fire_stacks(-0.5)
					if (prob(10) && (M.fire_stacks <= 0))
						M.adjust_fire_stacks(1)
					M.IgniteMob()
					if (M.on_fire)
						M.visible_message(SPAN_DANGER("The fire spreads from [src] to [M]!"),
							SPAN_DANGER("The fire spreads to you as well!"))
					else
						src.adjust_fire_stacks(-0.5) //Less effective than stop, drop, and roll - also accounting for the fact that it takes half as long.
						if (src.fire_stacks <= 0)
							M.visible_message(SPAN_WARNING("[M] successfully pats out [src]'s flames."),
								SPAN_WARNING("You successfully pat out [src]'s flames."))
							src.ExtinguishMob()
							src.fire_stacks = 0
		else
			if (istype(src,/mob/living/carbon/human) && src:w_uniform)
				var/mob/living/carbon/human/H = src
				H.w_uniform.add_fingerprint(M)

			var/show_ssd
			var/mob/living/carbon/human/H = src
			var/datum/gender/T = GLOB.gender_datums[H.get_visible_gender()] // make sure to cast to human before using get_gender() or get_visible_gender()!
			if(istype(H))
				show_ssd = H.species.show_ssd
			if(show_ssd && !client && !teleop && (!istype(H) || !H.override_ssd))
				M.visible_message(SPAN_NOTICE("[M] shakes [src] trying to wake [T.him] up!"),
					SPAN_NOTICE("You shake [src], but [T.he] [T.does] not respond... Maybe [T.he] [T.has] S.S.D?"))
			else if(lying || src.sleeping)
				AdjustSleeping(-5)
				if(H) H.in_stasis = 0
				M.visible_message(SPAN_NOTICE("[M] shakes [src] trying to wake [T.him] up!"),
					SPAN_NOTICE("You shake [src] trying to wake [T.him] up!"))
			else
				var/mob/living/carbon/human/hugger = M
				var/datum/gender/TM = GLOB.gender_datums[M.get_visible_gender()]
				if(M.resting == 1) //Are they resting on the ground?
					M.visible_message(SPAN_NOTICE("[M] grabs onto [src] and pulls [TM.himself] up."),
						SPAN_NOTICE("You grip onto [src] and pull yourself up off the ground!"))
					if(M.fire_stacks >= (src.fire_stacks + 3)) //Fire checks.
						src.adjust_fire_stacks(1)
						M.adjust_fire_stacks(-1)
					if(M.on_fire)
						src.IgniteMob()
					if(do_after(M, 0.5 SECONDS)) //.5 second delay. Makes it a bit stronger than just typing rest.
						M.resting = 0 //Hoist yourself up up off the ground. No para/stunned/weakened removal.
				else if(istype(hugger))
					hugger.species.hug(hugger,src)
				else
					M.visible_message(SPAN_NOTICE("[M] hugs [src] to make [T.him] feel better!"),
						SPAN_NOTICE("You hug [src] to make [T.him] feel better!"))
				if(M.fire_stacks >= (src.fire_stacks + 3))
					src.adjust_fire_stacks(1)
					M.adjust_fire_stacks(-1)
				if(M.on_fire)
					src.IgniteMob()
			AdjustUnconscious(-3)
			AdjustStunned(-3)
			AdjustWeakened(-3)

			playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

/mob/living/carbon/proc/eyecheck()
	return 0

/mob/living/carbon/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /atom/movable/screen/fullscreen/tiled/flash)
	if(eyecheck() < intensity || override_blindness_check)
		return ..()

// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching.
// Stop! ... Hammertime! ~Carn

/mob/living/carbon/proc/getDNA()
	return dna

/mob/living/carbon/proc/setDNA(var/datum/dna/newDNA)
	dna = newDNA

// ++++ROCKDTBEN++++ MOB PROCS //END

/mob/living/carbon/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	var/temp_inc = max(min(BODYTEMP_HEATING_MAX*(1-get_heat_protection()), exposed_temperature - bodytemperature), 0)
	bodytemperature += temp_inc

/mob/living/carbon/can_use_hands()
	if(handcuffed)
		return 0
	if(buckled && ! istype(buckled, /obj/structure/bed/chair)) // buckling does not restrict hands
		return 0
	return 1

/mob/living/carbon/restrained()
	if (handcuffed)
		return 1
	return

//generates realistic-ish pulse output based on preset levels
/mob/living/carbon/proc/get_pulse(var/method)	//method 0 is for hands, 1 is for machines, more accurate
	var/temp = 0								//see setup.dm:694
	switch(src.pulse)
		if(PULSE_NONE)
			return "0"
		if(PULSE_SLOW)
			temp = rand(40, 60)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_NORM)
			temp = rand(60, 90)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_FAST)
			temp = rand(90, 120)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_2FAST)
			temp = rand(120, 160)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_THREADY)
			return method ? ">250" : "extremely weak and fast, patient's artery feels like a thread"
//			output for machines^	^^^^^^^output for people^^^^^^^^^

/mob/living/carbon/verb/mob_sleep()
	set name = "Sleep"
	set category = "IC"

	if(usr.sleeping)
		to_chat(usr, "<font color='red'>You are already sleeping</font>")
		return
	if(alert(src,"You sure you want to sleep for a while?","Sleep","Yes","No") == "Yes")
		usr.AdjustSleeping(20)

/mob/living/carbon/Bump(atom/A)
	. = ..()
	if(istype(A, /mob/living/carbon) && prob(10))
		spread_disease_to(A, "Contact")

/mob/living/carbon/cannot_use_vents()
	return

/mob/living/carbon/slip(var/slipped_on,stun_duration=8)
	if(buckled)
		return 0
	stop_pulling()
	to_chat(src, "<span class='warning'>You slipped on [slipped_on]!</span>")
	playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
	Weaken(FLOOR(stun_duration/2, 1))
	return 1

/mob/living/carbon/proc/add_chemical_effect(var/effect, var/magnitude = 1)
	if(effect in chem_effects)
		chem_effects[effect] += magnitude
	else
		chem_effects[effect] = magnitude

/mob/living/carbon/get_default_language()
	if(default_language)
		if(can_speak(default_language))
			return default_language
		else
			return SScharacters.resolve_language_name(LANGUAGE_GIBBERISH)

	if(!species)
		return null

	return species.default_language ? SScharacters.resolve_language(species.default_language) : null

/mob/living/carbon/proc/should_have_organ(var/organ_check)
	return 0

/mob/living/carbon/can_feel_pain(var/check_organ)
	if(isSynthetic())
		return 0
	return !(species.species_flags & NO_PAIN)

/mob/living/carbon/needs_to_breathe()
	if(does_not_breathe)
		return FALSE
	return ..()

/mob/living/carbon/proc/set_nutrition(amount)
	nutrition = clamp(amount, 0, initial(nutrition) * 1.5)

/mob/living/carbon/proc/adjust_nutrition(amount)
	set_nutrition(nutrition + amount)

/mob/living/carbon/proc/set_hydration(amount)
	hydration = clamp(amount, 0, initial(hydration)  * 1.5) //We can overeat but not to ludicrous amounts, otherwise we'd never be normal again

/mob/living/carbon/proc/adjust_hydration(amount)
	set_hydration(hydration + amount)

/mob/living/carbon/proc/update_handcuffed()
	if(handcuffed)
		drop_all_held_items()
		stop_pulling()
	update_action_buttons() //some of our action buttons might be unusable when we're handcuffed.
	update_inv_handcuffed()

/mob/living/carbon/check_obscured_slots()
	// if(slot)
	// 	if(head.inv_hide_flags & HIDEMASK)
	// 		LAZYOR(., SLOT_MASK)
	// 	if(head.inv_hide_flags & HIDEEYES)
	// 		LAZYOR(., SLOT_EYES)
	// 	if(head.inv_hide_flags & HIDEEARS)
	// 		LAZYOR(., SLOT_EARS)

	if(wear_mask)
		if(wear_mask.inv_hide_flags & HIDEEYES)
			LAZYOR(., SLOT_EYES)
