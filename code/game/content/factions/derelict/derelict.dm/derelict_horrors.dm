// Contains the special mobs for the Derelict.
// Most of these creatures are made or evolved with a substance named 'Ether.'
// I won't explain what Ether is here, but it has interesting effects on life.


/mob/living/simple_mob/animal/event/derelict/horror
	name = "horror"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_horrors.dmi'
	desc = "A hulking creature, towering above the usual person. Its five glowing blue eyes shine in the darkness, and its claws practically glow with some sort of energy."
	icon_state = "horror"
	icon_living = "horror"
	icon_dead = "horror_dead"
	maxHealth = 400
	health = 400
	icon_scale_x = 1.1
	icon_scale_y = 1.1
	movement_base_speed = 10 / 3
	legacy_melee_damage_lower = 30
	legacy_melee_damage_upper = 30
	base_attack_cooldown = 8
	attack_sound = 'sound/mobs/biomorphs/drone_attack.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/event

/mob/living/simple_mob/animal/event/derelict/geist
	name = "geist"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_horrors.dmi'
	desc = "A floating orb of barely contained energy. It moves through the air with some sort of purpose, and fills the area around it with static electricity. Physical objects seem to just phase through it without issue, maybe energy would be different...?"
	icon_state = "geist"
	icon_living = "geist"
	maxHealth = 200
	health = 200
	armor_legacy_mob = list(
		"melee" = 100,
		"bullet" = 100,
		"laser" = 0,
		"energy" = 0,
		"bomb" = 100,
		"bio" = 100,
		"rad" = 100,
	)
	movement_base_speed = 10 / 10
	legacy_melee_damage_lower = 0
	legacy_melee_damage_upper = 0
	base_attack_cooldown = 10
	projectiletype = /obj/projectile/temp/hot
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/kiting/threatening

/mob/living/simple_mob/animal/event/derelict/swarm
	name = "!"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_horrors.dmi'
	desc = "What looks like a... Glowing butterfly? No, that can't be right. Its form warps eratically, as if its out of sync with reality. Energy seems to just... Pass through it, and you can't seem to hit it. Ballistic weaponry may work."
	icon_state = "swarm"
	icon_living = "swarm"
	maxHealth = 150
	health = 150
	armor_legacy_mob = list(
		"melee" = 100,
		"bullet" = 0,
		"laser" = 100,
		"energy" = 100,
		"bomb" = 100,
		"bio" = 100,
		"rad" = 100,
	)
	movement_base_speed = 10 / 1
	legacy_melee_damage_lower = 15
	legacy_melee_damage_upper = 15
	base_attack_cooldown = 6
	attack_sound = 'sound/effects/stealthoff.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/event

/mob/living/simple_mob/animal/event/derelict/phantom
	name = "?"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_horrors.dmi'
	desc = "Something isn't right. It's as if the shadows themselves have manifested into physical being, looking at it for too long causes whispers to start building up in your head. Oddly, projectiles just... Pass through whatever this might be, melee might work better."
	icon_state = "phantom"
	icon_living = "phantom"
	maxHealth = 250
	health = 250
	armor_legacy_mob = list(
		"melee" = 0,
		"bullet" = 100,
		"laser" = 100,
		"energy" = 100,
		"bomb" = 100,
		"bio" = 100,
		"rad" = 100,
	)
	movement_base_speed = 10 / 3
	legacy_melee_damage_lower = 25
	legacy_melee_damage_upper = 25
	base_attack_cooldown = 9
	attack_sound = 'sound/effects/stealthoff.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/event

/mob/living/simple_mob/animal/event/derelict/vortex
	name = "%%$%&"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_horrors.dmi'
	desc = "A swirling mass of matter that doesn't seem to be entirely within reality. It discharges incessant amounts of black energy that wreak havoc on the nervous system. Any projectiles seem to just phase through it, melee might work better."
	icon_state = "vortex"
	icon_living = "vortex"
	maxHealth = 150
	health = 150
	armor_legacy_mob = list(
		"melee" = 0,
		"bullet" = 100,
		"laser" = 100,
		"energy" = 100,
		"bomb" = 100,
		"bio" = 100,
		"rad" = 100,
	)
	movement_base_speed = 10 / 6
	legacy_melee_damage_lower = 25
	legacy_melee_damage_upper = 25
	base_attack_cooldown = 11
	attack_sound = 'sound/effects/stealthoff.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/kiting/threatening
	projectiletype = /obj/projectile/beam/stun

/mob/living/simple_mob/animal/event/derelict/hallucination
	name = "WE SEE YOU"
	icon = 'code/game/content/factions/derelict/derelict.dmi/derelict_horrors.dmi'
	desc = "Its form shimmers eratically, it doesn't even have a head, just a glowing ball of fire that doesn't stop burning. Your attacks don't even make it flinch. IT SEES YOU. IT KNOWS YOU. DON'T TRY TO RUN."
	icon_state = "hallucination"
	icon_living = "hallucination"
	maxHealth = 300
	health = 300
	icon_scale_x = 1.2
	icon_scale_y = 1.2
	movement_base_speed = 10 / 2
	base_attack_cooldown = 8
	attack_sound = 'sound/hallucinations/growl1.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/event
