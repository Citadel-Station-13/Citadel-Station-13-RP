/datum/category_item/catalogue/fauna/otie		//TODO: VIRGO_LORE_WRITING_WIP
	name = "Creature - Otie"
	desc = "A bioengineered longdog, the otie is very long, and very cute, depending on if you like dogs, \
	especially long ones. They are black-and-grey furred, typically, and tanky, hard to kill. \
	They seem hostile at first, but are also tame-able if you can approach one. Nipnipnip-ACK \
	**the catalogue entry ends here.**"
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/otie //Spawn this one only if you're looking for a bad time. Not friendly.
	name = "otie"
	desc = "The classic bioengineered longdog."
	tt_desc = "Otus robustus"
	icon = 'icons/mob/vore64x32.dmi'
	icon_state = "otie"
	icon_living = "otie"
	icon_dead = "otie-dead"
	icon_rest = "otie_rest"
	maxHealth = 150
	health = 150
	randomized = TRUE
	minbodytemp = 200
	legacy_melee_damage_lower = 2
	legacy_melee_damage_upper = 7 //Don't break my bones bro
	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = list("mauled")
	friendly = list("nuzzles", "slobberlicks", "noses softly at", "noseboops", "headbumps against", "leans on", "nibbles affectionately on")
	meat_amount = 6
	base_pixel_x = -16

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive/otie
	say_list_type = /datum/say_list/otie

	var/mob/living/carbon/human/friend
	var/tamed = 0
	var/tame_chance = 50 //It's a fiddy-fiddy default you may get a buddy pal or you may get mauled and ate. Win-win!

	meat_amount = 6
	bone_amount = 2
	hide_amount = 2

// Activate Noms!

/mob/living/simple_mob/otie

/mob/living/simple_mob/otie/feral //gets the pet2tame feature. starts out hostile tho so get gamblin'
	name = "mutated feral otie"
	desc = "The classic bioengineered longdog. No pets. Only bite. This one has mutated from too much time out on the surface of Virgo-3B."
	tt_desc = "Otus phoronis"
	icon_state = "photie"
	icon_living = "photie"
	icon_dead = "photie-dead"
	icon_rest = "photie_rest"
	tame_chance = 5 // Only a 1 in 20 chance of success. It's feral. What do you expect?
	// Lazy way of making sure this otie survives outside.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	has_eye_glow = TRUE

/mob/living/simple_mob/otie/red
	name = "feral red otie"
	desc = "Seems this ominous looking longdog has been infused with wicked infernal forces."
	tt_desc = "Otus infernalis"
	icon_state = "hotie"
	icon_living = "hotie"
	icon_dead = "hotie-dead"
	icon_rest = "hotie_rest"
	tame_chance = 20
	// Lazy way of making sure this otie survives outside.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	maxbodytemp = 1000
	has_eye_glow = TRUE

/mob/living/simple_mob/otie/red/friendly //gets the pet2tame feature and doesn't kill you right away
	name = "red otie"
	desc = "Seems this ominous looking longdog has been infused with wicked infernal forces. This one seems rather peaceful though."
	iff_factions = MOB_IFF_FACTION_NEUTRAL
	tamed = 1

/mob/living/simple_mob/otie/friendly //gets the pet2tame feature and doesn't kill you right away
	name = "otie"
	desc = "The classic bioengineered longdog. This one might even tolerate you!"
	iff_factions = MOB_IFF_FACTION_NEUTRAL
	tamed = 1

/mob/living/simple_mob/otie/cotie //same as above but has a little collar :v
	name = "tamed otie"
	desc = "The classic bioengineered longdog. This one has a nice little collar on its neck. However a proper domesticated otie is an oxymoron and the collar is likely just a decoration."
	icon_state = "cotie"
	icon_living = "cotie"
	icon_rest = "cotie_rest"
	iff_factions = MOB_IFF_FACTION_NEUTRAL
	tamed = 1

/mob/living/simple_mob/otie/cotie/phoron //friendly phoron pup with collar
	name = "mutated otie"
	desc = "Looks like someone did manage to domesticate one of those wild phoron mutants. What a badass."
	tt_desc = "Otus phoronis"
	icon_state = "pcotie"
	icon_living = "pcotie"
	icon_rest = "pcotie_rest"
	icon_dead = "photie-dead"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	has_eye_glow = TRUE

/mob/living/simple_mob/otie/security //tame by default unless you're a marked crimester. can be befriended to follow with pets tho.
	name = "guard otie"
	desc = "The VARMAcorp bioengineering division flagship product on trained optimal snowflake guard dogs."
	icon_state = "sotie"
	icon_living = "sotie"
	icon_rest = "sotie_rest"
	icon_dead = "sotie-dead"
	iff_factions = MOB_IFF_FACTION_NEUTRAL
	maxHealth = 200 //armored or something
	health = 200
	tamed = 1
	has_eye_glow = TRUE

/mob/living/simple_mob/otie/security/phoron
	name = "mutated guard otie"
	desc = "An extra rare phoron resistant version of the VARMAcorp trained snowflake guard dogs for infernal environments."
	tt_desc = "Otus phoronis"
	icon_state = "secphotie"
	icon_living = "secphotie"
	icon_rest = "secphotie_rest"
	icon_dead = "secphotie-dead"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

/mob/living/simple_mob/otie/security/phoron/red
	name = "red guard otie"
	desc = "An ominous looking version of the VARMAcorp trained snowflake guard dogs."
	tt_desc = "Otus infernalis"
	icon_state = "sechotie"
	icon_living = "sechotie"
	icon_rest = "sechotie_rest"
	icon_dead = "sechotie-dead"
	maxbodytemp = 1000

/mob/living/simple_mob/otie/security/phoron/red/Frankie
	name = "Frankie"
	desc = "Madame Foster's personal guard dog, Frankie!  It seems he's gotten some new toys, a metal band on his head lets him manipulate objects with the power of his mind!  What do giant dogs even think about all day?"
	mod_min = 150
	mod_max = 150

//Pet 4 friendly

/mob/living/simple_mob/otie/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)

	var/mob/living/M = user
	if(!istype(M))
		return
	switch(M.a_intent)
		if(INTENT_HELP)
			if(health > 0)
				M.visible_message("<span class='notice'>[M] [response_help] \the [src].</span>")
				if(has_polaris_AI())
					var/datum/ai_holder/polaris/AI = ai_holder
					AI.set_stance(STANCE_IDLE)
					if(prob(tame_chance))
						AI.hostile = FALSE
						friend = M
						AI.set_follow(friend)
						if(tamed != 1)
							tamed = 1
							copy_iff_factions(M)
					sleep(1 SECOND)

		if(INTENT_GRAB)
			if(health > 0)
				if(has_polaris_AI())
					var/datum/ai_holder/polaris/AI = ai_holder
					audible_emote("growls disapprovingly at [M].")
					if(M == friend)
						AI.lose_follow()
						friend = null
				return
			else
				..()

		else
			..()

/mob/living/simple_mob/otie/death(gibbed, deathmessage = "dies!")
	.=..()
	resting = 0
	icon_state = icon_dead

/mob/living/simple_mob/otie/Login()
	. = ..()
	AddComponent(/datum/component/riding_filter/mob/animal)

/mob/living/simple_mob/otie/Logout()
	. = ..()
	DelComponent(/datum/component/riding_filter, /datum/component/riding_filter/mob/animal)

/mob/living/simple_mob/otie/MouseDroppedOnLegacy(mob/living/M, mob/living/user)
	return

/datum/say_list/otie
	speak = list("Boof.","Waaf!","Prurr.","Bork!","Rurrr..","Arf.")
	emote_hear = list("rurrs", "rumbles", "rowls", "groans softly", "murrs", "yawns")
	emote_see = list("stares ferociously", "snarls", "licks their chops", "stretches", "yawns")
	say_maybe_target = list("Ruh?", "Waf?")
	say_got_target = list("Rurrr!", "ROAR!", "MARR!", "RERR!", "RAHH!", "RAH!", "WARF!")

/datum/ai_holder/polaris/simple_mob/melee/evasive/otie

/datum/ai_holder/polaris/simple_mob/melee/evasive/otie/New(var/mob/living/simple_mob/otie/new_holder)
	.=..()
	if(new_holder.tamed)
		hostile = FALSE
