/mob/living/simple_mob/animal/monster/skallax
	icon = 'icons/mob/monsters/skallax.dmi'
	iff_factions = MOB_IFF_FACTION_MONSTER_SKALLAX
	see_in_dark = 10
	movement_sound = 'sound/effects/spider_loop.ogg'
	attack_sound = 'sound/weapons/slice.ogg'
	movement_base_speed = 10 / 4

/mob/living/simple_mob/animal/monster/skallax/young
	name = "young skallax"
	desc = "Some sort of insect.. Looks sort of like a beetle? Or a spider?"

	icon_state = "skallax_young"
	icon_living = "skallax_young"
	icon_dead = "skallax_young_dead"

	maxHealth = 150
	health = 150

	legacy_melee_damage_lower = 25
	legacy_melee_damage_upper = 20

	movement_base_speed = 10 / 4
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/event

/mob/living/simple_mob/animal/monster/skallax/worker
	name = "skallax worker"
	desc = "An insect with yellow stripes amongst its abdomen. Bears resemblance to a beetle or a spider."

	icon_state = "skallax_worker"
	icon_living = "skallax_worker"
	icon_dead = "skallax_worker_dead"

	maxHealth = 250
	health = 250
	armor_legacy_mob = list(
			"melee"		= 15,
			"bullet"	= 10,
			"laser"		= 20,
			"energy"	= 20,
			"bomb"		= 70,
			"bio"		= 0,
			"rad"		= 0
			)

	projectiletype = /obj/projectile/energy/acid/weak
	base_attack_cooldown = 11
	projectilesound = 'sound/effects/splat.ogg'

	movement_base_speed = 10 / 5
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/kiting

/mob/living/simple_mob/animal/monster/skallax/mature
	name = "mature skallax"
	desc = "A old and tough looking spider-like creature."

	icon_state = "skallax_mature"
	icon_living = "skallax_mature"
	icon_dead = "skallax_mature_dead"
	icon_scale_x = 1.2
	icon_scale_y = 1.2

	maxHealth = 350
	health = 350
	armor_legacy_mob = list(
			"melee"		= 20,
			"bullet"	= 30,
			"laser"		= 15,
			"energy"	= 15,
			"bomb"		= 70,
			"bio"		= 30,
			"rad"		= 0
			)

	legacy_melee_damage_lower = 35
	legacy_melee_damage_upper = 30

	movement_base_speed = 10 / 4
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive
