// ToDo: Make this code not a fucking snowflaky horrible broken mess. Do not use until it's actually fixed. It's miserably bad right now.
// Also ToDo: Dev-to-dev communication to ensure responsible parties (if available. In this case, yes.) are aware of what's going on and what's broken.
// Probably easier to troubleshoot when we ain't breaking the server by spawning a buttload of heavily extra feature coded snowflake mobs to the wilderness as mass cannonfodder.
// Also ToDo: An actual "simple" mob for that purpose if necessary :v

/mob/living/simple_mob/animal/otie //Spawn this one only if you're looking for a bad time. Not friendly.
	name = "otie"
	desc = "The classic bioengineered longdog."
	tt_desc = "Otus robustus"
	icon = 'icons/mob/vore64x32.dmi'
	icon_state = "otie"
	icon_living = "otie"
	icon_dead = "otie-dead"
	icon_rest = "otie_rest"
	faction = "otie"
	say_list_type = /datum/say_list/otie
	ai_holder_type = /datum/ai_holder/simple_mob/otie
	maxHealth = 150
	health = 150
	minbodytemp = 200
	speak_emote = list("growls", "roars", "yaps", "Awoos")
	melee_damage_lower = 5
	melee_damage_upper = 15 //Don't break my bones bro
	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = list("mauled")
	friendly = list("nuzzles", "slobberlicks", "noses softly at", "noseboops", "headbumps against", "leans on", "nibbles affectionately on")
	meat_amount = 6
	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0

	max_buckled_mobs = 1 //Yeehaw
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	mount_offset_y = 10

	vore_active = 1
	vore_capacity = 1
	vore_pounce_chance = 20
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

	var/glowyeyes = FALSE
	var/eyetype
	var/mob/living/carbon/human/friend
	var/tamed = 0
	var/tame_chance = 50 //It's a fiddy-fiddy default you may get a buddy pal or you may get mauled and ate. Win-win!

/datum/say_list/otie
	speak = list("Boof.","Waaf!","Prurr.","Bork!","Rurrr..","Arf.")
	emote_hear = list("rurrs", "rumbles", "rowls", "groans softly", "murrs", "sounds hungry", "yawns")
	emote_see = list("stares ferociously", "snarls", "licks their chops", "stretches", "yawns")
	say_maybe_target = list("Ruh?", "Waf?")
	say_got_target = list("Rurrr!", "ROAR!", "MARR!", "RERR!", "RAHH!", "RAH!", "WARF!")

/mob/living/simple_mob/animal/otie/feral //gets the pet2tame feature. starts out hostile tho so get gamblin'
	name = "mutated feral otie"
	desc = "The classic bioengineered longdog. No pets. Only bite. This one has mutated from too much time out on the surface of Virgo-3B."
	tt_desc = "Otus phoronis"
	icon_state = "siftusian"
	icon_living = "siftusian"
	icon_dead = "siftusian-dead"
	icon_rest = "siftusian_rest"
	faction = "virgo3b"
	tame_chance = 5 // Only a 1 in 20 chance of success. It's feral. What do you expect?
	melee_damage_lower = 10
	melee_damage_upper = 25
	// Lazy way of making sure this otie survives outside.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	glowyeyes = TRUE
	eyetype = "photie"

/mob/living/simple_mob/animal/otie/red
	name = "feral red otie"
	desc = "Seems this ominous looking longdog has been infused with wicked infernal forces."
	tt_desc = "Otus infernalis"
	icon_state = "hotie"
	icon_living = "hotie"
	icon_dead = "hotie-dead"
	icon_rest = "hotie_rest"
	faction = "cult"
	tame_chance = 20
	melee_damage_lower = 10
	melee_damage_upper = 25
	// Lazy way of making sure this otie survives outside.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	glowyeyes = TRUE
	eyetype = "hotie"

/mob/living/simple_mob/animal/otie/red/friendly //gets the pet2tame feature and doesn't kill you right away
	name = "red otie"
	desc = "Seems this ominous looking longdog has been infused with wicked infernal forces. This one seems rather peaceful though."
	faction = "neutral"
	tamed = 1

/mob/living/simple_mob/animal/otie/friendly //gets the pet2tame feature and doesn't kill you right away
	name = "otie"
	desc = "The classic bioengineered longdog. This one might even tolerate you!"
	faction = "neutral"
	tamed = 1

/mob/living/simple_mob/animal/otie/cotie //same as above but has a little collar :v
	name = "tamed otie"
	desc = "The classic bioengineered longdog. This one has a nice little collar on its neck. However a proper domesticated otie is an oxymoron and the collar is likely just a decoration."
	icon_state = "cotie"
	icon_living = "cotie"
	icon_rest = "cotie_rest"
	faction = "neutral"
	tamed = 1

/mob/living/simple_mob/animal/otie/cotie/phoron //friendly phoron pup with collar
	name = "mutated otie"
	desc = "Looks like someone did manage to domesticate one of those wild phoron mutants. What a badass."
	tt_desc = "Otus phoronis"
	icon_state = "pcotie"
	icon_living = "pcotie"
	icon_rest = "pcotie_rest"
	icon_dead = "siftusian-dead"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	glowyeyes = TRUE
	eyetype = "photie"

/mob/living/simple_mob/animal/otie/security //tame by default unless you're a marked crimester. can be befriended to follow with pets tho.
	name = "guard otie"
	desc = "The VARMAcorp bioengineering division flagship product on trained optimal snowflake guard dogs."
	icon_state = "sotie"
	icon_living = "sotie"
	icon_rest = "sotie_rest"
	icon_dead = "sotie-dead"
	faction = "neutral"
	maxHealth = 200 //armored or something
	health = 200
	tamed = 1
	glowyeyes = TRUE
	eyetype = "sotie"
	loot_list = list(/obj/item/clothing/glasses/sunglasses/sechud,/obj/item/clothing/suit/armor/vest/alt)
	vore_pounce_chance = 60 // Good boys don't do too much police brutality.

	ai_holder_type = /datum/ai_holder/simple_mob/otie/security

	var/check_records = 0 // If true, arrests people without a record.
	var/check_arrest = 1 // If true, arrests people who are set to arrest.

/mob/living/simple_mob/animal/otie/security/phoron
	name = "mutated guard otie"
	desc = "An extra rare phoron resistant version of the VARMAcorp trained snowflake guard dogs."
	tt_desc = "Otus phoronis"
	icon_state = "sifguard"
	icon_living = "sifguard"
	icon_rest = "sifguard_rest"
	icon_dead = "sifguard-dead"
	melee_damage_lower = 10
	melee_damage_upper = 25
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	glowyeyes = TRUE
	eyetype = "sotie"

/mob/living/simple_mob/animal/otie/attack_target(atom/target_mob)
	if(istype(target_mob,/mob/living/simple_animal/mouse))
		return EatTarget()
	else ..()

/datum/ai_holder/simple_mob/otie
	hostile = TRUE
	specific_target = TRUE
	retaliate = TRUE
	use_astar = TRUE
	speak_chance = 4

/datum/ai_holder/simple_mob/otie/found(atom/A)
	var/mob/living/simple_mob/animal/otie/holder = src.holder
	if(!istype(holder))
		return ..()
	if(!can_attack(A))
		return ..()
	if(ismouse(A))
		return TRUE
	if(isliving(A))
		var/mob/living/found = A
		if(found.faction == holder.faction)
			return ..()
		if(holder.tamed && (ishuman(found) || isrobot(found)))
			return ..()
		else
			if(holder.resting)
				holder.lay_down()
			return found
	return ..()

/datum/ai_holder/simple_mob/otie/handle_special_strategical()
	var/mob/living/simple_mob/animal/otie/holder = src.holder
	if(!istype(holder))
		return
	if(prob(5) && stance == STANCE_IDLE)
		holder.lay_down()
	if(holder.friend)
		var/dist = get_dist(holder, holder.friend)
		if(dist <= 14)		//reasonable sight range
			if(dist <= 4)
				if(stance == STANCE_IDLE)
					set_follow(holder.friend)
					set_stance(STANCE_FOLLOW)
					if(holder.resting)
						holder.lay_down()
			if(dist <= 1)
				if(holder.friend.stat >= DEAD || holder.friend.health <= config.health_threshold_softcrit)
					if (prob((holder.friend.stat < DEAD)? 50 : 15))
						var/verb = pick("whines", "yelps", "whimpers")
						holder.audible_emote(pick("[verb] in distress.", "[verb] anxiously."))
				else
					if (prob(5))
						holder.visible_emote(pick("nuzzles [holder.friend].",
										   "brushes against [holder.friend].",
										   "rubs against [holder.friend].",
										   "noses at [holder.friend].",
										   "slobberlicks [holder.friend].",
										   "murrs contently.",
										   "leans on [holder.friend].",
										   "nibbles affectionately on [holder.friend]."))
			else if (holder.friend.health <= 50)
				if (prob(10))
					var/verb = pick("whines", "yelps", "whimpers")
					holder.audible_emote("[verb] anxiously.")

/mob/living/simple_mob/animal/otie/attack_hand(mob/living/carbon/human/M as mob)
	switch(M.a_intent)
		if(I_HELP)
			if(health > 0)
				M.visible_message("<span class='notice'>[M] [response_help] \the [src].</span>")
				if(!ai_holder)
					return
				ai_holder.lose_target()
				if(prob(tame_chance))
					friend = M
					if(!tamed)
						tamed = TRUE
						faction = M.faction

		if(I_GRAB)
			if(health > 0)
				if(!ai_holder)
					return
				audible_emote("growls disapprovingly at [M].")
				if(M == friend)
					friend = null
				return
			else
				..()

		else
			..()

/datum/ai_holder/simple_mob/otie/security/found(atom/A)
	if(!istype(holder, /mob/living/simple_mob/animal/otie/security))
		return ..()
	var/mob/living/simple_mob/animal/otie/security/O = holder
	if(O.check_threat(A) >= 4)
		if(holder.resting)
			holder.lay_down()
		return A
	return ..()

/mob/living/simple_mob/animal/otie/attackby(var/obj/item/O, var/mob/user) // Trade donuts for bellybrig victims.
	if(istype(O, /obj/item/weapon/reagent_containers/food))
		qdel(O)
		playsound(src.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
		if(!get_AI_stance())//No autobarf on player control.
			return
		if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/donut) && istype(src, /mob/living/simple_mob/animal/otie/security))
			to_chat(user,"<span class='notice'>The guard pup accepts your offer for their catch.</span>")
			release_vore_contents()
		else if(prob(2)) //Small chance to get prey out from non-sec oties.
			to_chat(user,"<span class='notice'>The pup accepts your offer for their catch.</span>")
			release_vore_contents()
		return
	. = ..()

/mob/living/simple_mob/animal/otie/security/feed_grabbed_to_self(var/mob/living/user, var/mob/living/prey) // Make the gut start out safe for bellybrigging.
	if(ishuman(prey))
		vore_selected.digest_mode = DM_HOLD
		if(check_threat(prey) >= 4)
			global_announcer.autosay("[src] has detained suspect <b>[target_name(prey)]</b> in <b>[get_area(src)]</b>.", "SmartCollar oversight", "Security")
	if(istype(prey,/mob/living/simple_animal/mouse))
		vore_selected.digest_mode = DM_DIGEST
	. = ..()

/mob/living/simple_mob/animal/otie/security/proc/check_threat(var/mob/living/M)
	if(!M || !ishuman(M) || M.stat == DEAD || src == M)
		return 0
	return M.assess_perp(0, 0, 0, check_records, check_arrest)

/datum/ai_holder/simple_mob/otie/security
	var/radio_attacks = TRUE

/datum/ai_holder/simple_mob/otie/security/give_target(atom/M)
	var/mob/living/simple_mob/animal/otie/security/S = holder
	if(!istype(S))
		return ..()
	if(radio_attacks && S.check_threat(M) >= 4)
		global_announcer.autosay("[src] is attempting to detain suspect <b>[M]</b> in <b>[get_area(src)]</b>.", "SmartCollar oversight", "Security")
	return ..()

/mob/living/simple_mob/animal/otie/security/proc/target_name(mob/living/T)
	if(ishuman(T))
		var/mob/living/carbon/human/H = T
		return H.get_id_name("unidentified person")
	return "unidentified lifeform"

/mob/living/simple_mob/animal/otie/add_eyes()
	if(!eye_layer)
		eye_layer = image(icon, "[eyetype]-eyes")
		eye_layer.plane = PLANE_LIGHTING_ABOVE
	add_overlay(eye_layer)

/mob/living/simple_mob/animal/otie/remove_eyes()
	cut_overlay(eye_layer)

/mob/living/simple_mob/animal/otie/Initialize()
	. = ..()
	if(glowyeyes)
		add_eyes()

/mob/living/simple_mob/animal/otie/update_icon()
	. = ..()
	remove_eyes()
	if(glowyeyes && stat == CONSCIOUS && !resting)
		add_eyes()

/mob/living/simple_mob/animal/otie/death(gibbed, deathmessage = "dies!")
	.=..()
	resting = 0
	icon_state = icon_dead

/mob/living/simple_mob/animal/otie/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	verbs |= /mob/living/simple_mob/proc/animal_mount
