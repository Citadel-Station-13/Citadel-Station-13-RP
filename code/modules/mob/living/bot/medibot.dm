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
	req_one_access = list(access_robotics, access_medical)
	botcard_access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	catalogue_data = list(/datum/category_item/catalogue/technology/bot/medibot)

	var/healthanalyzer = /obj/item/healthanalyzer
	var/firstaid = /obj/item/storage/firstaid

	//AI vars
	var/last_newpatient_speak = 0
	var/vocal = 1

	//Healing vars
	var/obj/item/reagent_containers/glass/reagent_glass = null //Can be set to draw from this for reagents.
	var/injection_amount = 15 //How much reagent do we inject at a time?
	var/heal_threshold = 10 //Start healing when they have this much damage in a category
	var/use_beaker = 0 //Use reagents in beaker instead of default treatment agents.
	var/treatment_brute = "tricordrazine"
	var/treatment_oxy = "tricordrazine"
	var/treatment_fire = "tricordrazine"
	var/treatment_tox = "tricordrazine"
	var/treatment_virus = "spaceacillin"
	var/treatment_emag = "toxin"
	var/declare_treatment = 0 //When attempting to treat a patient, should it notify everyone wearing medhuds?

/mob/living/bot/medibot/Initialize(mapload, new_skin)
	. = ..()
	skin = new_skin
	busy = FALSE //So medibots don't spawn bugged.
	update_icon()

/mob/living/bot/medibot/update_icon()
	. = ..()
	cut_overlays()

	if(skin)
		icon_state = "[base_icon_state]-[skin]"
	add_overlay("[base_icon_state]-scanner")
	if(busy)
		add_overlay("[base_icon_state]-arm-syringe")
		add_overlay("[base_icon_state]-flash")
	else
		add_overlay("[base_icon_state]-arm")
		if(emagged)
			add_overlay("[base_icon_state]-spark")
		else
			add_overlay("[base_icon_state]-[on]")

//Subtypes & Cosmetics
/mob/living/bot/medibot/fire
	name = "\improper Mr. Burns"
	skin = "burn"

/mob/living/bot/medibot/toxin
	name = "\improper Toxic"
	skin = "antitoxin"

/mob/living/bot/medibot/o2
	name = "\improper Lifeless"
	skin = "o2"

/mob/living/bot/medibot/red
	name = "\improper Super Medibot"
	skin = "advfirstaid"

/mob/living/bot/medibot/mysterious
	name = "\improper Mysterious Medibot"
	desc = "International Medibot of mystery."
	skin = "bezerk"
	treatment_brute = "bicaridine"
	treatment_fire  = "dermaline"
	treatment_oxy   = "dexalin"
	treatment_tox   = "anti_toxin"

/mob/living/bot/medibot/purple
	name = "\improper Leaky"
	skin = "clottingkit"

/mob/living/bot/medibot/pink
	name = "\improper Pinky"
	skin = "pinky"

/mob/living/bot/medibot/medass //Don't laugh, she's trying her hardest :(
	name = "\improper Miss Bandages"
	desc = "A little medical robot. This one looks very busy."
	skin = "assistant"

/mob/living/bot/medibot/apidean
	name = "\improper Apidean Beebot"
	desc = "An organic creature heavily augmented with components from a medical drone. It was made to assist nurses in Apidaen hives."
	icon_state = "beebot0"
	base_icon_state = "beebot"

/mob/living/bot/medibot/apidean/update_icons()
	cut_overlays()
	if(skin)
		add_overlay("[base_icon_state]-[skin]")
	if(busy)
		icon_state = "beebots"
	else
		icon_state = "beebot[on]"

/mob/living/bot/medibot/apidean/handleIdle()
	if(vocal && prob(1))
		var/message_options = list(
			"Bzzz bzzz!" = 'sound/voice/moth/scream_moth.ogg',
			"Chk scchk hhk!" = 'sound/voice/moth/mothchitter.ogg',
			"Hhhk bzchk." = 'sound/voice/moth/mothsqueak.ogg',
			)
		var/message = pick(message_options)
		say(message)
		playsound(loc, message_options[message], 50, 0)

/mob/living/bot/medibot/handleIdle()
	if(vocal && prob(1))
		var/message_options = list(
			"Radar, put a mask on!" = 'sound/voice/medibot/mradar.ogg',
			"There's always a catch, and it's the best there is." = 'sound/voice/medibot/mcatch.ogg',
			"I knew it, I should've been a plastic surgeon." = 'sound/voice/medibot/msurgeon.ogg',
			"What kind of medbay is this? Everyone's dropping like flies." = 'sound/voice/medibot/mflies.ogg',
			"Delicious!" = 'sound/voice/medibot/mdelicious.ogg'
			)
		var/message = pick(message_options)
		say(message)
		playsound(loc, message_options[message], 50, 0)

/mob/living/bot/medibot/handleAdjacentTarget()
	UnarmedAttack(target)

/mob/living/bot/medibot/handlePanic()	// Speed modification based on alert level.
	. = 0
	switch(get_security_level())
		if(SEC_LEVEL_GREEN)
			. = 0

		if(SEC_LEVEL_BLUE)
			. = 0

		if(SEC_LEVEL_YELLOW)
			. = 1

		if(SEC_LEVEL_VIOLET)
			. = 1

		if(SEC_LEVEL_ORANGE)
			. = 2

		if(SEC_LEVEL_RED)
			. = 3

		if(SEC_LEVEL_DELTA) //FAST AS FUCK BOOOYYEEEE
			. = 4

	return .

/mob/living/bot/medibot/lookForTargets()
	for(var/mob/living/carbon/human/H in view(7, src)) // Time to find a patient!
		if(confirmTarget(H))
			target = H
			if(last_newpatient_speak + 30 SECONDS < world.time)
				if(vocal)
					var/message_options = list(
						"Hey, [H.name]! Hold on, I'm coming." = 'sound/voice/medibot/mcoming.ogg',
						"Wait [H.name]! I want to help!" = 'sound/voice/medibot/mhelp.ogg',
						"[H.name], you appear to be injured!" = 'sound/voice/medibot/minjured.ogg'
						)
					var/message = pick(message_options)
					say(message)
					playsound(loc, message_options[message], 50, 0)
				custom_emote(1, "points at [H.name].")
				last_newpatient_speak = world.time
			break

/mob/living/bot/medibot/UnarmedAttack(var/mob/living/carbon/human/H)
	if(!..())
		return

	if(!on)
		return

	if(!istype(H))
		return

	if(busy)
		return

	var/t = confirmTarget(H)
	if(!t)
		return

	visible_message(SPAN_WARNING("[src] is trying to inject [H]!"))
	if(declare_treatment)
		var/area/location = get_area(src)
		GLOB.global_announcer.autosay("[src] is treating <b>[H]</b> in <b>[location]</b>", "[src]", "Medical")
	busy = TRUE
	update_icons()
	if(do_mob(src, H, 30))
		if(t == 1)
			reagent_glass.reagents.trans_to_mob(H, injection_amount, CHEM_BLOOD)
		else
			H.reagents.add_reagent(t, injection_amount)
		visible_message(SPAN_WARNING("[src] injects [H] with the syringe!"))

	if(H.stat == DEAD) //This is down here because this proc won't be called again due to losing a target because of parent AI loop.
		target = null
		if(vocal)
			var/death_messages = list(
				"No! Stay with me!" = 'sound/voice/medibot/mno.ogg',
				"Live, damnit! LIVE!" = 'sound/voice/medibot/mlive.ogg',
				"I... I've never lost a patient before. Not today, I mean." = 'sound/voice/medibot/mlost.ogg'
				)
			var/message = pick(death_messages)
			say(message)
			playsound(loc, death_messages[message], 50, FALSE)

	// This is down here for the same reason as above.
	else
		t = confirmTarget(H)
		if(!t)
			target = null
			if(vocal)
				var/possible_messages = list(
					"All patched up!" = 'sound/voice/medibot/mpatchedup.ogg',
					"An apple a day keeps me away." = 'sound/voice/medibot/mapple.ogg',
					"Feel better soon!" = 'sound/voice/medibot/mfeelbetter.ogg'
					)
				var/message = pick(possible_messages)
				say(message)
				playsound(loc, possible_messages[message], 50, FALSE)

	busy = FALSE
	update_icons()

/mob/living/bot/medibot/attack_hand(var/mob/user)
	var/dat
	dat += "<TT><B>Automatic Medical Unit v1.0</B></TT><BR><BR>"
	dat += "Status: <A href='?src=\ref[src];power=1'>[on ? "On" : "Off"]</A><BR>"
	dat += "Maintenance panel is [open ? "opened" : "closed"]<BR>"
	dat += "Beaker: "
	if (reagent_glass)
		dat += "<A href='?src=\ref[src];eject=1'>Loaded \[[reagent_glass.reagents.total_volume]/[reagent_glass.reagents.maximum_volume]\]</a>"
	else
		dat += "None Loaded"
	dat += "<br>Behaviour controls are [locked ? "locked" : "unlocked"]<hr>"
	if(!locked || issilicon(user))
		dat += "<TT>Healing Threshold: "
		dat += "<a href='?src=\ref[src];adj_threshold=-10'>--</a> "
		dat += "<a href='?src=\ref[src];adj_threshold=-5'>-</a> "
		dat += "[heal_threshold] "
		dat += "<a href='?src=\ref[src];adj_threshold=5'>+</a> "
		dat += "<a href='?src=\ref[src];adj_threshold=10'>++</a>"
		dat += "</TT><br>"

		dat += "<TT>Injection Level: "
		dat += "<a href='?src=\ref[src];adj_inject=-5'>-</a> "
		dat += "[injection_amount] "
		dat += "<a href='?src=\ref[src];adj_inject=5'>+</a> "
		dat += "</TT><br>"

		dat += "Reagent Source: "
		dat += "<a href='?src=\ref[src];use_beaker=1'>[use_beaker ? "Loaded Beaker (When available)" : "Internal Synthesizer"]</a><br>"

		dat += "Treatment report is [declare_treatment ? "on" : "off"]. <a href='?src=\ref[src];declaretreatment=[1]'>Toggle</a><br>"

		dat += "The speaker switch is [vocal ? "on" : "off"]. <a href='?src=\ref[src];togglevoice=[1]'>Toggle</a><br>"

	user << browse("<HEAD><TITLE>Medibot v1.0 controls</TITLE></HEAD>[dat]", "window=automed")
	onclose(user, "automed")
	return

/mob/living/bot/medibot/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/reagent_containers/glass))
		if(locked)
			to_chat(user, SPAN_NOTICE("You cannot insert a beaker because the panel is locked."))
			return
		if(!isnull(reagent_glass))
			to_chat(user, SPAN_NOTICE("There is already a beaker loaded."))
			return

		user.drop_item()
		O.loc = src
		reagent_glass = O
		to_chat(user, SPAN_NOTICE("You insert [O]."))
		return
	else
		..()

/mob/living/bot/medibot/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	if ((href_list["power"]) && access_scanner.allowed(usr))
		if (on)
			turn_off()
		else
			turn_on()

	else if((href_list["adj_threshold"]) && (!locked || issilicon(usr)))
		var/adjust_num = text2num(href_list["adj_threshold"])
		heal_threshold += adjust_num
		if(heal_threshold <= 0)
			heal_threshold = 0.1
		if(heal_threshold > 75)
			heal_threshold = 75

	else if((href_list["adj_inject"]) && (!locked || issilicon(usr)))
		var/adjust_num = text2num(href_list["adj_inject"])
		injection_amount += adjust_num
		if(injection_amount < 5)
			injection_amount = 5
		if(injection_amount > 15)
			injection_amount = 15

	else if((href_list["use_beaker"]) && (!locked || issilicon(usr)))
		use_beaker = !use_beaker

	else if (href_list["eject"] && (!isnull(reagent_glass)))
		if(!locked)
			reagent_glass.loc = get_turf(src)
			reagent_glass = null
		else
			to_chat(usr, SPAN_NOTICE("You cannot eject the beaker because the panel is locked."))

	else if ((href_list["togglevoice"]) && (!locked || issilicon(usr)))
		vocal = !vocal

	else if ((href_list["declaretreatment"]) && (!locked || issilicon(usr)))
		declare_treatment = !declare_treatment

	attack_hand(usr)
	return

/mob/living/bot/medibot/emag_act(var/remaining_uses, var/mob/user)
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
		update_icons()
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
		playsound(loc, 'sound/voice/medibot/minsult.ogg', 50, 0)

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)

/mob/living/bot/medibot/confirmTarget(var/mob/living/carbon/human/H)
	if(!..())
		return FALSE

	if(H.isSynthetic()) // Don't treat FBPs
		return FALSE

	if(H.stat == DEAD) // He's dead, Jim
		return FALSE

	if(H.suiciding)
		return FALSE

	if(emagged)
		return treatment_emag

	// If they're injured, we're using a beaker, and they don't have on of the chems in the beaker
	if(reagent_glass && use_beaker && ((H.getBruteLoss() >= heal_threshold) || (H.getToxLoss() >= heal_threshold) || (H.getToxLoss() >= heal_threshold) || (H.getOxyLoss() >= (heal_threshold + 15))))
		for(var/datum/reagent/R in reagent_glass.reagents.reagent_list)
			if(!H.reagents.has_reagent(R))
				return 1
			continue

	if((H.getBruteLoss() >= heal_threshold) && (!H.reagents.has_reagent(treatment_brute)))
		return treatment_brute //If they're already medicated don't bother!

	if((H.getOxyLoss() >= (15 + heal_threshold)) && (!H.reagents.has_reagent(treatment_oxy)))
		return treatment_oxy

	if((H.getFireLoss() >= heal_threshold) && (!H.reagents.has_reagent(treatment_fire)))
		return treatment_fire

	if((H.getToxLoss() >= heal_threshold) && (!H.reagents.has_reagent(treatment_tox)))
		return treatment_tox

/* Construction */

/obj/item/storage/firstaid/attackby(var/obj/item/robot_parts/I, mob/user, params)

	if(istype(I, /obj/item/robot_parts/l_arm) || istype(I, /obj/item/robot_parts/r_arm) || (istype(I, /obj/item/organ/external/arm) && ((I.name == "robotic right arm") || (I.name == "robotic left arm"))))
		return ..()

	if(contents.len >= 1)
		to_chat(user, SPAN_NOTICE("You need to empty [src] out first."))
		return

	var/obj/item/bot_assembly/medibot/A = new /obj/item/bot_assembly/medibot
	if(istype(src, /obj/item/storage/firstaid/fire))
		A.created_name = "\improper Mr. Burns"
		A.skin = "burn"
	else if(istype(src, /obj/item/storage/firstaid/toxin))
		A.created_name = "\improper Toxic"
		A.skin = "toxin"
	else if(istype(src, /obj/item/storage/firstaid/o2))
		A.created_name = "\improper Lifeless"
		A.skin = "o2"
	else if(istype(src, /obj/item/storage/firstaid/adv))
		A.created_name = "\improper Super Medibot"
		A.skin = "advfirstaid"
	else if(istype(src, /obj/item/storage/firstaid/clotting))
		A.created_name = "\improper Leaky"
		A.skin = "clottingkit"
	else if(istype(src, /obj/item/storage/firstaid/bonemed))
		A.created_name = "\improper Pinky"
		A.skin = "bonemed"
	else if(istype(src, /obj/item/storage/firstaid/combat))
		A.created_name = "\improper Mysterious Medibot"
		A.desc = "International Medibot of mystery. Though after a closer look, it looks like a fraud."
		A.skin = "bezerk"

	user.put_in_hands(A)
	to_chat(user, SPAN_NOTICE("You add [I] to [src]."))
	A.robot_arm = I.type
	A.firstaid = type
	qdel(I)
	qdel(src)

/obj/item/bot_assembly/medibot
	name = "incomplete medibot assembly"
	desc = "A first aid kit with a robot arm permanently grafted to it."
	icon = 'icons/obj/bots/medibots.dmi'
	icon_state = "medibot"
	base_icon_state = "medkit"
	w_class = ITEMSIZE_NORMAL
	created_name = "Medibot" //To preserve the name if it's a unique medibot I guess
	var/healthanalyzer = /obj/item/healthanalyzer
	var/firstaid = /obj/item/storage/firstaid

/obj/item/bot_assembly/medibot/Initialize()
	. = ..()
	spawn(1)
		if(skin)
			add_overlay("[base_icon_state]-[skin]")
		add_overlay("[base_icon_state]-arm")


/obj/item/bot_assembly/medibot/attackby(obj/item/W, mob/user, params)
	..()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(istype(W, /obj/item/healthanalyzer))
				user.drop_item()
				healthanalyzer = W.type
				to_chat(user, SPAN_NOTICE("You add the health sensor to [src]."))
				qdel(W)
				name = "First aid/robot arm/health analyzer assembly"
				add_overlay("[base_icon_state]-scanner")
				build_step++

		if(ASSEMBLY_SECOND_STEP)
			if(isprox(W))
				if(!can_finish_build(W, user))
					return
				qdel(W)
				var/mob/living/bot/medibot/S = new(drop_location(), skin)
				to_chat(user, SPAN_NOTICE("You complete the Medibot! Beep boop."))
				S.name = created_name
				S.firstaid = firstaid
				S.robot_arm = robot_arm
				S.healthanalyzer = healthanalyzer
				user.drop_from_inventory(src)
				qdel(src)
