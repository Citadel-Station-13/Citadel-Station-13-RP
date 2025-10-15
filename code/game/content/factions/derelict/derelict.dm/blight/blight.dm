


/mob/living/simple_mob/animal/space/blight/melee/swarmer
	name = "Blight Swarmer"
	desc = "A small, pale white creature around the size of the common cat or rodent. It appears to be quadrupedal, which each of its four legs sporting gruesome talons. "

	icon = 'code/game/content/factions/derelict/derelict.dmi/blight/swarmer.dmi'
	icon_state = "swarmer"
	icon_living = "swarmer"
	icon_rest = "swarmer_rest"
	icon_dead = "swarmer_dead"
	base_pixel_x = 0

	health = 130
	maxHealth = 130
	movement_base_speed = 10 / 2

	legacy_melee_damage_lower = 17
	legacy_melee_damage_upper = 17
	base_attack_cooldown = 7

	iff_factions = MOB_IFF_FACTION_DERELICT_BLIGHT
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee

	attack_sound =  'sound/mobs/blight/attack1.ogg'
	movement_sound = 'sound/mobs/blight/movement1.ogg'


/mob/living/simple_mob/animal/space/blight/melee/peon
	name = "Blight Peon"
	desc = "A moderately sized pale white organism, about the size of a dog. It scurries around on four legs that are ended with gnarly claws. You can also see a small mouth beneath its mis-shapen domed head."

	icon = 'code/game/content/factions/derelict/derelict.dmi/blight/peon.dmi'
	icon_state = "peon"
	icon_living = "peon"
	icon_rest = "peon_rest"
	icon_dead = "peon_dead"
	base_pixel_x = 0

	health = 200
	maxHealth = 200
	movement_base_speed = 10 / 3

	legacy_melee_damage_lower = 23
	legacy_melee_damage_upper = 23
	base_attack_cooldown = 9

	iff_factions = MOB_IFF_FACTION_DERELICT_BLIGHT
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee

	attack_sound =  'sound/mobs/blight/attack1.ogg'
	movement_sound = 'sound/mobs/blight/movement1.ogg'


/mob/living/simple_mob/animal/space/blight/melee/trooper
	name = "Blight Trooper"
	desc = "A tall, pale white organism around the size of the common Human if not a bit taller. This one seems much more developed, and often sprints around in a bipedal fashion.\
	It sports a pair of large claws on its hands, and a pair of diminished talons on its feet. You can also see a mouth, dripping with some sort of pale grey goo."

	icon = 'code/game/content/factions/derelict/derelict.dmi/blight/trooper.dmi'
	icon_state = "trooper"
	icon_living = "trooper"
	icon_rest = "trooper_rest"
	icon_dead = "trooper_dead"
	base_pixel_x = 0

	health = 300
	maxHealth = 300
	movement_base_speed = 10 / 3
	armor_legacy_mob = list(
		"melee" = 20,
		"bullet" = 20,
		"laser" = 0,
		"energy" = 0,
		"bomb" = 30,
		"bio" = 100,
		"rad" = 100,
	)

	legacy_melee_damage_lower = 26
	legacy_melee_damage_upper = 26
	attack_armor_pen = 15
	base_attack_cooldown = 11

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive
	iff_factions = MOB_IFF_FACTION_DERELICT_BLIGHT

	attack_sound =  'sound/mobs/biomorphs/drone_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/drone_move.ogg'


/mob/living/simple_mob/animal/space/blight/melee/dasher
	name = "Blight Dasher"
	desc = "A painfully elonated and quadrupedal creature, sporting a pale white exoskeleton with what appears to be red cracks forming in different key areas. \
	It appears capable of frightening speed, considering its well muscled rear and front legs that are ended with long claws."

	icon = 'code/game/content/factions/derelict/derelict.dmi/blight/dasher.dmi'
	icon_state = "dasher"
	icon_living = "dasher"
	icon_rest = "dasher_rest"
	icon_dead = "dasher_dead"
	base_pixel_x = 0

	health = 250
	maxHealth = 250
	movement_base_speed = 10 / 1
	armor_legacy_mob = list(
		"melee" = 20,
		"bullet" = 20,
		"laser" = -10,
		"energy" = -10,
		"bomb" = 30,
		"bio" = 100,
		"rad" = 100,
	)

	legacy_melee_damage_lower = 23
	legacy_melee_damage_upper = 23
	attack_armor_pen = 20
	base_attack_cooldown = 8

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/hunter_spider
	special_attack_min_range = 2
	special_attack_max_range = 7
	special_attack_cooldown = 10 SECONDS
	var/leap_warmup = 0.5 SECOND
	iff_factions = MOB_IFF_FACTION_DERELICT_BLIGHT

	attack_sound =  'sound/mobs/biomorphs/drone_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/drone_move.ogg'
