/datum/category_item/catalogue/fauna/bats
	name = "Space Bats"
	desc = "The byproduct of Human terraforming and genetics \
	experimentation focusing on creating fauna more adapted to \
	space travel, Space Bats are vampiric abominations that try \
	to suck the life out of any warm creature they can find."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/space/bats
	name = "space bat swarm"
	desc = "A swarm of cute little blood sucking bats that looks pretty upset."
	tt_desc = "N Bestia gregaria" //Nispean swarm bats, because of course Nisp has swarm bats
	icon = 'icons/mob/bats.dmi'
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	icon_gib = "bat_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/bats)

	faction = "scarybat"

	maxHealth = 20
	health = 20
	randomized = TRUE

	attacktext = list("bites")
	attack_sound = 'sound/weapons/bite.ogg'

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	harm_intent_damage = 10

	melee_damage_lower = 5
	melee_damage_upper = 5
	attack_sharp = TRUE

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

	has_langs = list("Mouse")

	meat_amount = 1
	bone_amount = 1
	hide_amount = 1

	say_list_type = /datum/say_list/mouse	// Close enough

	var/scare_chance = 15

/mob/living/simple_mob/animal/space/bats/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(prob(scare_chance))
			L.Stun(1)
			L.visible_message("<span class='danger'>\the [src] scares \the [L]!</span>")

// Spookiest of bats
/mob/living/simple_mob/animal/space/bats/cult
	faction = "cult"
	supernatural = TRUE

/mob/living/simple_mob/animal/space/bats/cult/cultify()
	return

//Lavaland Bats
/mob/living/simple_mob/animal/space/bats/surt
	name = "volcanic bat swarm"
	desc = "A swarm of blood sucking bats that have adapted to exist on this volatile planet. They are extremely hostile."

	heat_resist = 1
