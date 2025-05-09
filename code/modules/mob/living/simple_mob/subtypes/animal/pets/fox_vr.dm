/datum/category_item/catalogue/fauna/fox
	name = "Fox"
	desc = "Vulpine creatures, commonly referred to as foxes, are a \
	somewhat distant cousin of Canines. Due to their elegant features \
	and coloration, the Fox symbolises beauty and agility. It is frequently \
	adopted as a covert military icon - a trend that rose in popularity during \
	the 20th and 21st Centuries on Pre-War Earth."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/passive/fox
	name = "fox"
	desc = "It's a fox. I wonder what it says?"
	tt_desc = "Vulpes vulpes"
	catalogue_data = list(/datum/category_item/catalogue/fauna/fox)

	icon_state = "fox2"
	icon_living = "fox2"
	icon_dead = "fox2_dead"
	icon_rest = "fox2_rest"
	icon = 'icons/mob/fox_vr.dmi'

	movement_base_speed = 10 / 0.5
	see_in_dark = 6
	mob_size = MOB_SMALL //Foxes are not smaller than cats so bumping them up to small
	randomized = TRUE

	iff_factions = MOB_IFF_FACTION_BIND_TO_MAP

	response_help = "scritches"
	response_disarm = "gently pushes aside"
	response_harm = "kicks"

	min_oxy = 16 			//Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323		//Above 50 Degrees Celcius

	meat_amount = 1
	meat_type = /obj/item/reagent_containers/food/snacks/meat/fox
	bone_amount = 1
	hide_amount = 3

	say_list_type = /datum/say_list/fox
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/fox

	var/turns_since_scan = 0
	var/mob/flee_target

/datum/say_list/fox
	speak = list("Ack-Ack","Ack-Ack-Ack-Ackawoooo","Awoo","Tchoff")
	emote_hear = list("howls","barks","geckers",)
	emote_see = list("shakes its head", "shivers", "geckers")
	say_maybe_target = list("Yip?","Yap?")
	say_got_target = list("YAP!","YIP!")

/datum/ai_holder/polaris/simple_mob/fox
	hostile = FALSE
	cooperative = TRUE
	returns_home = FALSE
	retaliate = TRUE
	can_flee = TRUE
	speak_chance = 1 // If the mob's saylist is empty, nothing will happen.
	wander = TRUE
	base_wander_delay = 4

/mob/living/simple_mob/animal/passive/fox/apply_melee_effects(var/atom/A)
	if(ismouse(A))
		var/mob/living/simple_mob/animal/passive/mouse/mouse = A
		if(mouse.getMaxHealth() < 20) // In case a badmin makes giant mice or something.
			mouse.splat()
			visible_emote(pick("bites \the [mouse]!", "toys with \the [mouse].", "chomps on \the [mouse]!"))
	else
		..()

/mob/living/simple_mob/animal/passive/fox/OnMouseDropLegacy(atom/over_object)
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

/mob/living/simple_mob/animal/passive/fox/renault/IIsAlly(mob/living/L)
	if(L == friend) // Always be pals with our special friend.
		return TRUE

	. = ..()

	if(.) // We're pals, but they might be a dirty mouse...
		if(ismouse(L))
			return FALSE // Cats and mice can never get along.

/mob/living/simple_mob/animal/passive/fox/renault/verb/become_friends()
	set name = "Become Friends"
	set category = VERB_CATEGORY_IC
	set src in view(1)

	var/mob/living/L = usr
	if(!istype(L))
		return // Fuck off ghosts.

	if(friend)
		if(friend == usr)
			to_chat(L, SPAN_NOTICE("\The [src] is already your friend!"))
			return
		else
			to_chat(L, SPAN_WARNING( "\The [src] ignores you."))
			return

	friend = L
	face_atom(L)
	to_chat(L, SPAN_NOTICE("\The [src] is now your friend!"))
	visible_emote(pick("nips [friend].", "brushes against [friend].", "tugs on [friend].", "chrrrrs."))

	if(has_polaris_AI())
		var/datum/ai_holder/polaris/AI = ai_holder
		AI.set_follow(friend)

/obj/item/reagent_containers/food/snacks/meat/fox
	name = "Fox meat"
	desc = "The fox doesn't say a goddamn thing, now."

//Captain fox
/mob/living/simple_mob/animal/passive/fox/renault
	name = "Renault"
	desc = "Renault, the Facility Director's trustworthy fox. I wonder what it says?"
	tt_desc = "Vulpes nobilis"
	//befriend_job = "Facility Director" Sebbe edit: couldn't make this work, commenting out for now.

	var/mob/living/friend = null // Our best pal, who we'll follow. awoo.
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/passive
	makes_dirt = FALSE	// No more dirt
	randomized = FALSE

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
