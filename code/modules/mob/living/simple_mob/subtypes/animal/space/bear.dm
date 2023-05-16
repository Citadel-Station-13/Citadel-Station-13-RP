/datum/category_item/catalogue/fauna/space_bear
	name = "Space Bear"
	desc = "Often treated as a joke, or a byproduct of space madness, \
	the existences of Space Bears is unfortunately very real. Similarly to \
	Space Bats, these bears were created as part of a wide ranging genetic \
	manipulation initiative. The process of cultivating and breeding these \
	bears has largely been lost, but due to failures in procreation safeguards \
	they have been able to reproduce naturally. Often kept as novelty pets on \
	the Frontier, these bears sometimes escape confinement and wreak havoc."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/space/bear
	name = "space bear"
	desc = "A product of Space Russia?"
	tt_desc = "U Ursinae aetherius" //...bearspace? Maybe.
	icon_state = "bear"
	icon_living = "bear"
	icon_dead = "bear_dead"
	icon_gib = "bear_gib"
	catalogue_data = list(/datum/category_item/catalogue/fauna/space_bear)

	faction = "russian"

	maxHealth = 125
	health = 125
	randomized = TRUE

	movement_cooldown = 0.5 SECONDS

	melee_damage_lower = 15
	melee_damage_upper = 35
	attack_armor_pen = 15
	attack_sharp = TRUE
	attack_edge = TRUE
	melee_attack_delay = 1 SECOND
	attacktext = list("mauled")

	meat_amount = 5
	meat_type = /obj/item/reagent_containers/food/snacks/bearmeat
	bone_amount = 3
	hide_amount = 5

	say_list_type = /datum/say_list/bear

/datum/say_list/bear
	speak = list("RAWR!","Rawr!","GRR!","Growl!")
	emote_see = list("stares ferociously", "stomps")
	emote_hear = list("rawrs","grumbles","grawls", "growls", "roars")

// Is it time to be mad?
/mob/living/simple_mob/animal/space/bear/handle_special()
	if((get_AI_stance() in list(STANCE_APPROACH, STANCE_FIGHT)) && !is_AI_busy() && isturf(loc))
		if(health <= (maxHealth * 0.5)) // At half health, and fighting someone currently.
			berserk()

// So players can use it too.
/mob/living/simple_mob/animal/space/bear/verb/berserk()
	set name = "Berserk"
	set desc = "Enrage and become vastly stronger for a period of time, however you will be weaker afterwards."
	set category = "Abilities"

	add_modifier(/datum/modifier/berserk, 30 SECONDS)
