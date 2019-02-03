/mob/living/simple_mob/animal/space/bear
	name = "space bear"
	desc = "A product of Space Russia?"
	tt_desc = "U Ursinae aetherius" //...bearspace? Maybe.

	faction = "russian"

	maxHealth = 125
	health = 125

	movement_cooldown = 0.5 SECONDS

	melee_damage_lower = 15
	melee_damage_upper = 35
	attack_armor_pen = 15
	attack_sharp = TRUE
	attack_edge = TRUE
	melee_attack_delay = 1 SECOND
	attacktext = list("mauled")

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/bearmeat

	say_list_type = /datum/say_list/bear

	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "spacebear"
	icon_living = "spacebear"
	icon_dead = "spacebear-dead"
	icon_gib = "bear-gib"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/animal/space/bear/hudson
	name = "Hudson"

/mob/living/simple_mob/animal/space/bear/brown
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	name = "brown bear"
	icon_state = "brownbear"
	icon_living = "brownbear"
	icon_dead = "brownbear-dead"
	icon_gib = "bear-gib"
	vore_icons = SA_ICON_LIVING

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