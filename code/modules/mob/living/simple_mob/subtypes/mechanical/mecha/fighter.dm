// Base type for the fighters
// They generally are fast and hit like hell

var/gps_tag = "HOSTILE"

/mob/living/simple_mob/mechanical/mecha/fighter
	name = "Fighter"
	desc = "Fly in space"

	movement_base_speed = 10 / 1
	legacy_melee_damage_lower = 30
	legacy_melee_damage_upper = 30
	melee_attack_delay = 1 SECOND
	attacktext = list("rammed")
	flying = 1

	armor_legacy_mob = list(
				"melee"		= 30,
				"bullet"	= 30,
				"laser"		= 15,
				"energy"	= 0,
				"bomb"		= 20,
				"bio"		= 100,
				"rad"		= 100
				)

	var/weaken_amount = 2 // Be careful with this number. High values can equal a permastun.

//No melee attack normaly
