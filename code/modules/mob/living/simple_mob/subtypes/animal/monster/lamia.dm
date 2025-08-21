// Lamias are fiercely territorial hunters, however staying away from their territory does not ensure you are safe. Engage with caution.

/mob/living/simple_mob/animal/monster/lamia
	icon = 'icons/mob/monsters/lamia.dmi'
	iff_factions = MOB_IFF_FACTION_MONSTER_LAMIA
	see_in_dark = 10
	movement_sound = 'sound/spooky/boneclak.ogg'
	attack_sound = 'sound/mobs/biomorphs/drone_attack.ogg'
	movement_base_speed = 10 / 4
	icon_dead = "lamia_dead"

/mob/living/simple_mob/animal/monster/lamia/male
	name = "lamia"
	desc = "A large creature with dark brown pigment. \
	Instead of legs, it has a snake-like tail and its four arms end with large blade-like scythes. \
	This one appears to be a male and is significantly tougher, yet slower."
	description_info = "From what you can see, its hide appears to be reinforced against projectiles. \
	Melee might be the best option."

	icon_state = "lamia"
	icon_living = "lamia"
	icon_scale_x = 1.3
	icon_scale_y = 1.3

	maxHealth = 350
	health = 350
	armor_legacy_mob = list(
			"melee"		= 0,
			"bullet"	= 60,
			"laser"		= 55,
			"energy"	= 50,
			"bomb"		= 70,
			"bio"		= 0,
			"rad"		= 0
			)

	legacy_melee_damage_lower = 30
	legacy_melee_damage_upper = 35

	movement_base_speed = 10 / 6
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/event


/mob/living/simple_mob/animal/monster/lamia/female
	name = "lamia"
	desc = "A large creature with dark brown pigment. \
	Instead of legs, it has a snake-like tail and its four arms end with large blade-like scythes. \
	This one appears to be a female and is significantly faster, yet weaker."
	description_info = "From what you can see, its hide appears to be reinforced against melee weapons. \
	Ranged might be the best option."

	icon_state = "lamia_f"
	icon_living = "lamia_f"
	icon_scale_x = 1.1
	icon_scale_y = 1.1

	maxHealth = 250
	health = 250
	armor_legacy_mob = list(
			"melee"		= 60,
			"bullet"	= 25,
			"laser"		= 15,
			"energy"	= 15,
			"bomb"		= 70,
			"bio"		= 0,
			"rad"		= 0
			)

	legacy_melee_damage_lower = 25
	legacy_melee_damage_upper = 30
	base_attack_cooldown = 9

	movement_base_speed = 10 / 3
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive

/mob/living/simple_mob/animal/monster/lamia/young
	name = "young lamia"
	desc = "A small creature with light brown pigment. \
	This one appears to walk on two legs, yet lacks a head. You can see a mouth in its torso area."
	description_info = "Fast and numerous, they appear to lack any armor yet can still cleave you in two."

	icon_state = "young"
	icon_living = "young"
	icon_dead = "young_dead"
	icon_scale_x = 0.9
	icon_scale_y = 0.9

	maxHealth = 200
	health = 200
	armor_legacy_mob = list(
			"melee"		= 0,
			"bullet"	= 0,
			"laser"		= 0,
			"energy"	= 0,
			"bomb"		= 70,
			"bio"		= 0,
			"rad"		= 0
			)

	legacy_melee_damage_lower = 15
	legacy_melee_damage_upper = 20

	movement_base_speed = 10 / 4
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/event
