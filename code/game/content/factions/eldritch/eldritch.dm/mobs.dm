/mob/living/simple_mob/animal/eldritch
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/mobs.dmi'
	iff_factions = MOB_IFF_FACTION_ELDRITCH_CULT

/mob/living/simple_mob/animal/eldritch/death()
	..(null,"emits an unexplainable sound as its body ceases to exist.")
	ghostize()
	qdel(src)


/mob/living/simple_mob/animal/eldritch/rust_walker
	name = "Rust Walker"
	desc = "A construct made up of a combination of skulls, rusted metal and an unidentifiable fluid. You swear you hear whispers..."

	icon_living = "rust_walker_s"
	icon_state = "rust_walker_s"

	health = "350"
	maxHealth = "350"
	armor_legacy_mob = list(
				"melee"		= 30,
				"bullet"	= 40,
				"laser"		= 50,
				"energy"	= 40,
				"bomb"		= 70,
				"bio"		= 100,
				"rad"		= 100
				)

	movement_base_speed = 10 / 3
	movement_sound = 'sound/effects/metalscrape1.ogg'

	legacy_melee_damage_lower = 25
	legacy_melee_damage_upper = 25
	base_attack_cooldown = 10
	attack_sound = 'sound/weapons/sonic_jackhammer.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive
