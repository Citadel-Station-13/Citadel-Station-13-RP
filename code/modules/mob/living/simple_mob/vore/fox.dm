/mob/living/simple_mob/animal/passive/fox
	name = "fox"
	desc = "It's a fox. I wonder what it says?"
	tt_desc = "Vulpes vulpes"
	icon = 'icons/mob/fox_vr.dmi'
	icon_state = "fox2"
	icon_living = "fox2"
	icon_dead = "fox2_dead"
	icon_rest = "fox2_rest"

	movement_cooldown = 5
	see_in_dark = 6
	mob_size = MOB_TINY

	response_help = "scritches"
	response_disarm = "gently pushes aside"
	response_harm = "kicks"

	min_oxy = 16 			//Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323		//Above 50 Degrees Celcius

	ai_holder_type = /datum/ai_holder/simple_mob/passive/fox
	say_list_type = /datum/say_list/fox
	speak_emote = list("geckers", "barks")

	meat_amount = 1
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/fox

	var/turns_since_scan = 0
	var/mob/flee_target
	var/mob/living/carbon/human/friend

/mob/living/simple_mob/animal/passive/fox/Destroy()
	flee_target = null
	friend = null
	return ..()

/datum/say_list/fox
	speak = list("Ack-Ack","Ack-Ack-Ack-Ackawoooo","Awoo","Tchoff")
	emote_hear = list("howls","barks")
	emote_see = list("shakes its head", "shivers", "geckers")
	say_maybe_target = list("Yip?","Yap?")
	say_got_target = list("YAP!","YIP!")

/mob/living/simple_mob/animal/passive/fox/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "Stomach"
	B.desc = "Slick foxguts. Cute on the outside, slimy on the inside!"

	B.emote_lists[DM_HOLD] = list(
		"The foxguts knead and churn around you harmlessly.",
		"With a loud glorp, some air shifts inside the belly.",
		"A thick drop of warm bellyslime drips onto you from above.",
		"The fox turns suddenly, causing you to shift a little.",
		"During a moment of relative silence, you can hear the fox breathing.",
		"The slimey stomach walls squeeze you lightly, then relax.")

	B.emote_lists[DM_DIGEST] = list(
		"The guts knead at you, trying to work you into thick soup.",
		"You're ground on by the slimey walls, treated like a mouse.",
		"The acrid air is hard to breathe, and stings at your lungs.",
		"You can feel the acids coating you, ground in by the slick walls.",
		"The fox's stomach churns hungrily over your form, trying to take you.",
		"With a loud glorp, the stomach spills more acids onto you.")

/mob/living/simple_mob/animal/passive/fox/do_attack(atom/target)
	if(istype(target,/mob/living/simple_mob/animal/passive/mouse))
		var/mob/living/simple_mob/animal/passive/mouse = target
		if(mouse.stat != DEAD)
			mouse.death()
			visible_emote(pick("bites \the [mouse]!","pounces on \the [mouse]!","chomps on \the [mouse]!"))
	else
		return ..()

/datum/ai_holder/simple_mob/passive/fox
	hostile = TRUE		//Scan for targets
	specific_target = TRUE		//Only attack those found()
	outmatched_threshold = 0

/datum/ai_holder/simple_mob/passive/fox/found(atom/A)
	if(istype(A, /mob/living/simple_mob/animal/passive/mouse))
		return A
	return ..()

/datum/ai_holder/simple_mob/passive/fox/react_to_attack(atom/A)
	give_target(A)
	flee_from_target()

/datum/ai_holder/simple_mob/passive/fox/special_flee_check()
	return TRUE

/datum/ai_holder/simple_mob/passive/fox/handle_special_strategical()
	if(!istype(src.holder, /mob/living/simple_mob/animal/passive/fox))
		return
	var/mob/living/simple_mob/animal/passive/fox/holder = src.holder
	if(holder.friend)
		var/friend_dist = get_dist(holder, holder.friend)
		if(friend_dist <= 4)
			if(stance == STANCE_IDLE)
				set_follow(holder.friend)
				set_stance(STANCE_FOLLOW)
		if (friend_dist <= 1)
			if (holder.friend.stat >= DEAD || holder.friend.health <= config.health_threshold_softcrit)
				if (prob((holder.friend.stat < DEAD)? 50 : 15))
					var/verb = pick("yaps", "howls", "whines")
					holder.audible_emote(pick("[verb] in distress.", "[verb] anxiously."))
			else
				if (prob(5))
					holder.visible_emote(pick("nips [holder.friend].",
									   "brushes against [holder.friend].",
									   "tugs on [holder.friend].",
									   "chrrrrs."))
		else if (holder.friend.health <= 50)
			if (prob(10))
				var/verb = pick("yaps", "howls", "whines")
				holder.audible_emote("[verb] anxiously.")

/mob/living/simple_mob/animal/passive/fox/MouseDrop(atom/over_object)
	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H)) return ..()

	if(H.a_intent == "help")
		get_scooped(H)
		return
	else
		return ..()

/mob/living/simple_mob/animal/passive/fox/get_scooped(var/mob/living/carbon/grabber)
	if (stat >= DEAD)
		return //since the holder icon looks like a living cat
	..()

/mob/living/simple_mob/animal/passive/fox/fluff
	var/befriend_job

/mob/living/simple_mob/animal/passive/fox/fluff/verb/friend()
	set name = "Become Friends"
	set category = "IC"
	set src in view(1)

	if(friend && usr == friend)
		set_dir(get_dir(src, friend))
		say("Yap!")
		return

	if (!(ishuman(usr) && befriend_job && usr.job == befriend_job))
		to_chat(usr, "<span class='notice'>[src] ignores you.</span>")
		return

	friend = usr

	set_dir(get_dir(src, friend))
	say("Yap!")

/obj/item/weapon/reagent_containers/food/snacks/meat/fox
	name = "Fox meat"
	desc = "The fox doesn't say a goddamn thing, now."

//Captain fox
/mob/living/simple_mob/animal/passive/fox/fluff/Renault
	name = "Renault"
	desc = "Renault, the Colony Director's trustworthy fox. I wonder what it says?"
	tt_desc = "Vulpes nobilis"
	befriend_job = "Colony Director"

/mob/living/simple_mob/animal/passive/fox/fluff/Renault/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "Stomach"
	B.desc = "Slick foxguts. They seem somehow more regal than perhaps other foxes!"

	B.emote_lists[DM_HOLD] = list(
		"Renault's stomach walls squeeze around you more tightly for a moment, before relaxing, as if testing you a bit.",
		"There's a sudden squeezing as Renault presses a forepaw against his gut over you, squeezing you against the slick walls.",
		"The 'head fox' has a stomach that seems to think you belong to it. It might be hard to argue, as it kneads at your form.",
		"If being in the captain's fox is a promotion, it might not feel like one. The belly just coats you with more thick foxslime.",
		"It doesn't seem like Renault wants to let you out. The stomach and owner possessively squeeze around you.",
		"Renault's stomach walls squeeze closer, as he belches quietly, before swallowing more air. Does he do that on purpose?")

	B.emote_lists[DM_DIGEST] = list(
		"Renault's stomach walls grind hungrily inwards, kneading acids against your form, and treating you like any other food.",
		"The captain's fox impatiently kneads and works acids against you, trying to claim your body for fuel.",
		"The walls knead in firmly, squeezing and tossing you around briefly in disorienting aggression.",
		"Renault belches, letting the remaining air grow more acrid. It burns your lungs with each breath.",
		"A thick glob of acids drip down from above, adding to the pool of caustic fluids in Renault's belly.",
		"There's a loud gurgle as the stomach declares the intent to make you a part of Renault.")

/mob/living/simple_mob/animal/passive/fox/syndicate
	name = "syndi-fox"
	desc = "It's a DASTARDLY fox! The horror! Call the shuttle!"
	tt_desc = "Vulpes malus"
	icon = 'icons/mob/fox_vr.dmi'
	icon_state = "syndifox"
	icon_living = "syndifox"
	icon_dead = "syndifox_dead"
	icon_rest = "syndifox_rest"

	// this fox wears a hardsuit
	maxHealth = 100
	health = 100
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0