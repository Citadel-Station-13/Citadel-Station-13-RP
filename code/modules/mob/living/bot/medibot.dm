// Medibot Info

#define MEDIBOT_PANIC_NONE   0
#define MEDIBOT_PANIC_LOW    15
#define MEDIBOT_PANIC_MED    35
#define MEDIBOT_PANIC_HIGH   55
#define MEDIBOT_PANIC_FUCK   70
#define MEDIBOT_PANIC_ENDING 90
#define MEDIBOT_PANIC_END    100

#define MEDIBOT_MIN_INJECTION 5
#define MEDIBOT_MAX_INJECTION 15

#define MEDIBOT_MIN_HEAL 0.1
#define MEDIBOT_MAX_HEAL 75

/datum/category_item/catalogue/technology/bot/medibot
	name = "Bot - Medibot"
	desc = "Medibots have become vital additions to hazardous workplaces \
	across the galaxy. A common sight on the Frontier, Medibots utilize \
	chemical synthesizers to deliver payloads of healing medications to injured \
	parties. Although not capable of more complex treatments, the standard Medibot \
	can stabilize a severely injured worker as easily as it can treat a minor scrape."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/bot/medibot
	name = "Medibot"
	desc = "A little medical robot. He looks somewhat underwhelmed."
	icon = 'icons/obj/bots/medibots.dmi'
	icon_state = "medibot"
	base_icon_state = "medkit"
	req_one_access = list(ACCESS_SCIENCE_ROBOTICS, ACCESS_MEDICAL_MAIN)
	botcard_access = list(ACCESS_MEDICAL_MAIN, ACCESS_MEDICAL_MORGUE, ACCESS_MEDICAL_SURGERY, ACCESS_MEDICAL_CHEMISTRY, ACCESS_MEDICAL_VIROLOGY, ACCESS_SCIENCE_GENETICS)
	catalogue_data = list(/datum/category_item/catalogue/technology/bot/medibot)

	var/healthanalyzer = /obj/item/healthanalyzer
	var/firstaid = /obj/item/storage/firstaid

	//! Appearance Vars
	/**
	 * This is a var to set for a medibot to not use overlays with their skin.
	 * Originally added cause of the bee medibot, which has unique handling.
	 */
	var/use_overlays = TRUE


	//! AI Vars
	var/last_newpatient_speak = 0
	var/vocal = TRUE

	//! Healing Vars
	/// Can be set to draw from this for reagents.
	var/obj/item/reagent_containers/glass/reagent_glass = null
	/// How much reagent do we inject at a time?
	var/injection_amount = 15
	/// Start healing when they have this much damage in a category.
	var/heal_threshold = 10
	/// Use reagents in beaker instead of default treatment agents.
	var/use_beaker = FALSE
	// TODO:
	var/treatment_brute = "tricordrazine"
	var/treatment_oxy   = "tricordrazine"
	var/treatment_fire  = "tricordrazine"
	var/treatment_tox   = "tricordrazine"
	var/treatment_virus = "spaceacillin"
	var/treatment_emag  = "toxin"
	/// When attempting to treat a patient, should it notify everyone wearing medhuds?
	var/declare_treatment = 0

	//! Tipping Vars
	// Are we tipped over?
	var/is_tipped = FALSE
	/// How panicked we are about being tipped over (why would you do this?)
	var/tipped_status = MEDIBOT_PANIC_NONE
	/// The name we got when we were tipped.
	var/tipper_name
	/// The last time we were tipped/righted and said a voice line, to avoid spam.
	var/last_tipping_action_voice = 0


/mob/living/bot/medibot/Initialize(mapload, new_skin)
	. = ..()

	skin ||= new_skin //? Will only apply new_skin if skin is null.

	update_appearance()

/mob/living/bot/medibot/update_icon_state()
	. = ..()

	if(skin)
		icon_state = "[base_icon_state]-[skin]"

/mob/living/bot/medibot/update_overlays()
	. = ..()

	if(!use_overlays)
		return

	cut_overlays()

	/// We add our overlays to this list, then add them all at once to reduce SSoverlays overhead.
	var/list/temp_overlays = list()
	temp_overlays.Add("[base_icon_state]-scanner")
	if(busy)
		temp_overlays.Add("[base_icon_state]-arm-syringe")
		temp_overlays.Add("[base_icon_state]-flash")
	else
		temp_overlays.Add("[base_icon_state]-arm")
		if(emagged)
			temp_overlays.Add("[base_icon_state]-spark")
		else
			temp_overlays.Add("[base_icon_state]-[on]")

	add_overlay(temp_overlays)


/mob/living/bot/medibot/handleIdle()
	if(is_tipped) // Don't handle idle things if we're incapacitated!
		return

	if(vocal && prob(1))
		// TODO: These should be soundbytes. @Zandario
		var/message_options = list(
			"Radar, put a mask on!" = 'sound/voice/medibot/mradar.ogg',
			"There's always a catch, and I'm the best there is." = 'sound/voice/medibot/mcatch.ogg',
			"I knew it, I should've been a plastic surgeon." = 'sound/voice/medibot/msurgeon.ogg',
			"What kind of medbay is this? Everyone's dropping like flies." = 'sound/voice/medibot/mflies.ogg',
			"Delicious!" = 'sound/voice/medibot/mdelicious.ogg',
		)
		var/message = pick(message_options)
		say(message)
		playsound(loc, message_options[message], 50, FALSE)


/mob/living/bot/medibot/handleAdjacentTarget()
	if(is_tipped) //Don't handle targets if we're incapacitated!
		return
	UnarmedAttack(target)


/mob/living/bot/medibot/lookForTargets()
	if(is_tipped) // Don't look for targets if we're incapacitated!
		return

	for(var/mob/living/carbon/human/H in view(7, src)) // Time to find a patient!
		if(confirmTarget(H))
			target = H
			if(last_newpatient_speak + 30 SECONDS < world.time)
				if(vocal)
					// TODO: These should be soundbytes. @Zandario
					var/message_options = list(
						"Hey, [H.name]! Hold on, I'm coming." = 'sound/voice/medibot/mcoming.ogg',
						"Wait [H.name]! I want to help!" = 'sound/voice/medibot/mhelp.ogg',
						"[H.name], you appear to be injured!" = 'sound/voice/medibot/minjured.ogg',
					)
					var/message = pick(message_options)
					say(message)
					playsound(loc, message_options[message], 50, FALSE)
				custom_emote(1, "points at [H.name].")
				last_newpatient_speak = world.time
			break

/mob/living/bot/medibot/UnarmedAttack(mob/living/carbon/human/victim)
	if(!..())
		return

	if(!on)
		return

	if(!istype(victim))
		return

	if(busy)
		return

	var/t = confirmTarget(victim)
	if(!t)
		return

	visible_message(SPAN_WARNING("[src] is trying to inject [victim]!"))
	if(declare_treatment)
		var/area/location = get_area(src)
		GLOB.global_announcer.autosay("[src] is treating <b>[victim]</b> in <b>[location]</b>", "[src]", "Medical")
	busy = TRUE
	update_appearance()
	if(do_mob(src, victim, 30))
		if(t == 1)
			reagent_glass.reagents.trans_to_mob(victim, injection_amount, CHEM_BLOOD)
		else
			victim.reagents.add_reagent(t, injection_amount)
		visible_message(SPAN_WARNING("[src] injects [victim] with the syringe!"))

	if(victim.stat == DEAD) //This is down here because this proc won't be called again due to losing a target because of parent AI loop.
		target = null
		if(vocal)
			var/death_messages = list(
				"No! Stay with me!" = 'sound/voice/medibot/mno.ogg',
				"Live, damnit! LIVE!" = 'sound/voice/medibot/mlive.ogg',
				"I... I've never lost a patient before. Not today, I mean." = 'sound/voice/medibot/mlost.ogg',
			)
			var/message = pick(death_messages)
			say(message)
			playsound(loc, death_messages[message], 50, FALSE)

	// This is down here for the same reason as above.
	else
		t = confirmTarget(victim)
		if(!t)
			target = null
			if(vocal)
				var/possible_messages = list(
					"All patched up!" = 'sound/voice/medibot/mpatchedup.ogg',
					"An apple a day keeps me away." = 'sound/voice/medibot/mapple.ogg',
					"Feel better soon!" = 'sound/voice/medibot/mfeelbetter.ogg',
				)
				var/message = pick(possible_messages)
				say(message)
				playsound(loc, possible_messages[message], 50, FALSE)

	busy = FALSE
	update_appearance()

/mob/living/bot/medibot/attack_hand(mob/living/carbon/human/attacker)
	if(attacker.a_intent == INTENT_DISARM && !is_tipped)
		attacker.visible_message(
			SPAN_DANGER("[attacker] begins tipping over [src]."),
			SPAN_WARNING("You begin tipping over [src]..."),
			SPAN_HEAR("You hear a loud clunk.")
		)

		if(world.time > last_tipping_action_voice + 15 SECONDS)
			last_tipping_action_voice = world.time // Message for tipping happens when we start interacting, message for righting comes after finishing.
			var/list/messagevoice = list(
				"Hey, wait..." = 'sound/voice/medibot/hey_wait.ogg',
				"Please don't..." = 'sound/voice/medibot/please_dont.ogg',
				"I trusted you..." = 'sound/voice/medibot/i_trusted_you.ogg',
				"Nooo..." = 'sound/voice/medibot/nooo.ogg',
				"Oh fuck-" = 'sound/voice/medibot/oh_fuck.ogg',
			)
			var/message = pick(messagevoice)
			say(message)
			playsound(src, messagevoice[message], 70, FALSE)

		if(do_after(attacker, 3 SECONDS, target=src))
			tip_over(attacker)

	else if(attacker.a_intent == INTENT_HELP && is_tipped)
		attacker.visible_message(
			SPAN_NOTICE("[attacker] begins righting [src]."),
			SPAN_NOTICE("You begin righting [src]..."),
			SPAN_HEAR("You hear a loud clunk.")
		)
		if(do_after(attacker, 3 SECONDS, target=src))
			set_right(attacker)
	else
		ui_interact(attacker)

/mob/living/bot/medibot/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Medibot", name)
		ui.open()

/mob/living/bot/medibot/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = ..()
	data["on"] = on
	data["open"] = open
	data["beaker"] = FALSE
	if(reagent_glass)
		data["beaker"] = TRUE
		data["beaker_total"] = reagent_glass.reagents.total_volume
		data["beaker_max"] = reagent_glass.reagents.maximum_volume
	data["locked"] = locked
	data["heal_threshold"] = null
	data["heal_threshold_max"] = MEDIBOT_MAX_HEAL
	data["injection_amount_min"] = MEDIBOT_MIN_INJECTION
	data["injection_amount"] = null
	data["injection_amount_max"] = MEDIBOT_MAX_INJECTION
	data["use_beaker"] = null
	data["declare_treatment"] = null
	data["vocal"] = null
	if(!locked || issilicon(user))
		data["heal_threshold"] = heal_threshold
		data["injection_amount"] = injection_amount
		data["use_beaker"] = use_beaker
		data["declare_treatment"] = declare_treatment
		data["vocal"] = vocal
	return data

/mob/living/bot/medibot/attackby(obj/item/target_item, mob/user)
	if(istype(target_item, /obj/item/reagent_containers/glass))
		if(locked)
			to_chat(user, SPAN_NOTICE("You cannot insert a beaker because the panel is locked."))
			return
		if(!isnull(reagent_glass))
			to_chat(user, SPAN_NOTICE("There is already a beaker loaded."))
			return
		if(!user.attempt_insert_item_for_installation(target_item, src))
			return
		reagent_glass = target_item
		to_chat(user, SPAN_NOTICE("You insert [target_item]."))
		return
	else
		..()

/mob/living/bot/medibot/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	usr.set_machine(src)

	. = TRUE
	switch(action)
		if("power")
			if(!access_scanner.allowed(usr))
				return FALSE
			if(on)
				turn_off()
			else
				turn_on()

	if(locked && !issilicon(usr))
		return TRUE

	switch(action)
		if("adj_threshold")
			heal_threshold = clamp(text2num(params["val"]), MEDIBOT_MIN_HEAL, MEDIBOT_MAX_HEAL)
			. = TRUE

		if("adj_inject")
			injection_amount = clamp(text2num(params["val"]), MEDIBOT_MIN_INJECTION, MEDIBOT_MAX_INJECTION)
			. = TRUE

		if("use_beaker")
			use_beaker = !use_beaker
			. = TRUE

		if("eject")
			if(reagent_glass)
				reagent_glass.forceMove(get_turf(src))
				reagent_glass = null
			. = TRUE

		if("togglevoice")
			vocal = !vocal
			. = TRUE

		if("declaretreatment")
			declare_treatment = !declare_treatment
			. = TRUE

/mob/living/bot/medibot/emag_act(remaining_uses, mob/user)
	. = ..()
	if(!emagged)
		if(user)
			to_chat(user, SPAN_WARNING("You short out [src]'s reagent synthesis circuits."))
		visible_message(SPAN_WARNING("[src] buzzes oddly!"))
		flick("[base_icon_state]-light-spark", src)
		target = null
		busy = FALSE
		emagged = TRUE
		on = TRUE
		update_appearance()
		. = TRUE
	ignore_list |= user

/mob/living/bot/medibot/explode()
	on = FALSE
	visible_message(SPAN_DANGER("[src] blows apart!"))
	var/turf/Tsec = get_turf(src)

	new /obj/item/storage/firstaid(Tsec)
	new /obj/item/assembly/prox_sensor(Tsec)
	new /obj/item/healthanalyzer(Tsec)
	if (prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	if(reagent_glass)
		reagent_glass.loc = Tsec
		reagent_glass = null

	if(emagged && prob(25))
		playsound(loc, 'sound/voice/medibot/minsult.ogg', 50, FALSE)

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)

/mob/living/bot/medibot/handleRegular()
	. = ..()

	if(is_tipped)
		handle_panic()
		return

/mob/living/bot/medibot/proc/tip_over(mob/horrible_human_being)
	playsound(src, 'sound/machines/warning-buzzer.ogg', 50)
	horrible_human_being.visible_message(
		SPAN_DANGER("[horrible_human_being] tips over [src]!"),
		SPAN_DANGER("You tip [src] over!"),
		SPAN_HEAR("You hear a loud clunk."),
	)
	is_tipped = TRUE
	tipper_name = horrible_human_being.name
	var/matrix/mat = transform
	transform = mat.Turn(180)

/mob/living/bot/medibot/proc/set_right(mob/wonderful_human_being)
	var/list/messagevoice
	if(wonderful_human_being)
		wonderful_human_being.visible_message(
			SPAN_NOTICE("[wonderful_human_being] sets [src] right-side up!"),
			SPAN_GREEN("You set [src] right-side up!"),
			SPAN_HEAR("You hear a loud clunk."),
		)
		// TODO: Small chance for the bot to not forgive you. @Zandario
		if (wonderful_human_being.name == tipper_name) // The false prophet has been forgiven.
			messagevoice = list(
				"I forgive you." = 'sound/voice/medibot/forgive.ogg',
			)
		else
			messagevoice = list(
				"Thank you!" = 'sound/voice/medibot/thank_you.ogg',
				"You are a good person." = 'sound/voice/medibot/youre_good.ogg',
			)
	else
		visible_message(
			SPAN_NOTICE("[src] manages to [pick("writhe", "wriggle", "wiggle")] enough to right itself."),
		)
		messagevoice = list(
			"Fuck you." = 'sound/voice/medibot/fuck_you.ogg',
			"Your behavior has been reported, have a nice day." = 'sound/voice/medibot/reported.ogg',
		)

	tipper_name = null
	if(world.time > last_tipping_action_voice + 15 SECONDS)
		last_tipping_action_voice = world.time
		var/message = pick(messagevoice)
		say(message)
		playsound(src, messagevoice[message], 70)
	tipped_status = MEDIBOT_PANIC_NONE
	is_tipped = FALSE
	transform = matrix()

// if someone tipped us over, check whether we should ask for help or just right ourselves eventually
/mob/living/bot/medibot/proc/handle_panic()
	tipped_status++
	var/list/messagevoice
	switch(tipped_status)
		if(MEDIBOT_PANIC_LOW)
			messagevoice = list(
				"I require assistance." = 'sound/voice/medibot/i_require_asst.ogg',
			)
		if(MEDIBOT_PANIC_MED)
			messagevoice = list(
				"Please put me back." = 'sound/voice/medibot/please_put_me_back.ogg',
			)
		if(MEDIBOT_PANIC_HIGH)
			messagevoice = list(
				"Please, I am scared!" = 'sound/voice/medibot/please_im_scared.ogg',
			)
		if(MEDIBOT_PANIC_FUCK)
			messagevoice = list(
				"I don't like this, I need help!" = 'sound/voice/medibot/dont_like.ogg',
				"This hurts, my pain is real!" = 'sound/voice/medibot/pain_is_real.ogg',
			)
		if(MEDIBOT_PANIC_ENDING)
			messagevoice = list(
				"Is this the end?" = 'sound/voice/medibot/is_this_the_end.ogg',
				"Nooo!" = 'sound/voice/medibot/nooo.ogg',
			)
		if(MEDIBOT_PANIC_END)
			GLOB.global_announcer.autosay("PSYCH ALERT: Crewmember [tipper_name] recorded displaying antisocial tendencies torturing bots in [get_area(src)]. Please schedule psych evaluation.", "[src]", "Medical")
			set_right() // Strong independent Medibot don't need no crew!

	// if(prob(tipped_status)) // Commented out pending introduction of jitter stuff from /tg/
		// do_jitter_animation(tipped_status * 0.1)

	if(messagevoice)
		var/message = pick(messagevoice)
		say(message)
		playsound(src, messagevoice[message], 70)
	else if(prob(tipped_status * 0.2))
		playsound(src, 'sound/machines/warning-buzzer.ogg', 30, extrarange=-2)

/mob/living/bot/medibot/examine(mob/user)
	. = ..()
	if(tipped_status == MEDIBOT_PANIC_NONE)
		return

	switch(tipped_status)
		if(MEDIBOT_PANIC_NONE to MEDIBOT_PANIC_LOW)
			. += "It appears to be tipped over, and is quietly waiting for someone to set it right."
		if(MEDIBOT_PANIC_LOW to MEDIBOT_PANIC_MED)
			. += "It is tipped over and requesting help."
		//Now we humanize the Medibot as a they, not an it. FEEL THE GUILT!
		if(MEDIBOT_PANIC_MED to MEDIBOT_PANIC_HIGH)
			. += "They are tipped over and appear visibly distressed."
		if(MEDIBOT_PANIC_HIGH to MEDIBOT_PANIC_FUCK)
			. += SPAN_WARNING("They are tipped over and visibly panicking!")
		if(MEDIBOT_PANIC_FUCK to INFINITY)
			. += SPAN_BOLDWARNING("They are freaking out from being tipped over!")

/mob/living/bot/medibot/confirmTarget(mob/living/carbon/human/victim)
	if(!..())
		return FALSE

	if(victim.isSynthetic()) // Don't treat FBPs.
		return FALSE

	if(victim.stat == DEAD) // He's dead, Jim.
		return FALSE

	if(victim.suiciding)
		return FALSE

	if(emagged)
		return treatment_emag

	// If they're injured, we're using a beaker, and they don't have on of the chems in the beaker.
	if(reagent_glass && use_beaker && ((victim.getBruteLoss() >= heal_threshold) || (victim.getToxLoss() >= heal_threshold) || (victim.getToxLoss() >= heal_threshold) || (victim.getOxyLoss() >= (heal_threshold + 15))))
		for(var/datum/reagent/R in reagent_glass.reagents.reagent_list)
			if(!victim.reagents.has_reagent(R))
				return 1
			continue

	if((victim.getBruteLoss() >= heal_threshold) && (!victim.reagents.has_reagent(treatment_brute)))
		return treatment_brute //If they're already medicated don't bother!

	if((victim.getOxyLoss() >= (15 + heal_threshold)) && (!victim.reagents.has_reagent(treatment_oxy)))
		return treatment_oxy

	if((victim.getFireLoss() >= heal_threshold) && (!victim.reagents.has_reagent(treatment_fire)))
		return treatment_fire

	if((victim.getToxLoss() >= heal_threshold) && (!victim.reagents.has_reagent(treatment_tox)))
		return treatment_tox


// Undefine these.
#undef MEDIBOT_PANIC_NONE
#undef MEDIBOT_PANIC_LOW
#undef MEDIBOT_PANIC_MED
#undef MEDIBOT_PANIC_HIGH
#undef MEDIBOT_PANIC_FUCK
#undef MEDIBOT_PANIC_ENDING
#undef MEDIBOT_PANIC_END
