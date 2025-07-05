/mob/living/simple_mob/animal/mansus
	icon = 'code/game/content/factions/mansus/mansus.dmi/mobs.dmi'

/mob/living/simple_mob/humanoid/animal/mansus/death()
	..(null,"emits an inexplainable sound as its body ceases to exist.")
	ghostize()
	qdel(src)


/mob/living/simple_mob/animal/mansus/rust_walker
	name = "Rust Walker"
	desc = "A construct made up of a combination of skulls, rusted metal and an unidentifiable fluid. You swear you hear whispers..."
	icon_living = "rust_walker"
	icon_living = "rust_walker"
	health = "500"
	maxHealth = "500"
	movement_base_speed = 10 / 3
	legacy_melee_damage_lower = 25
	legacy_melee_damage_upper = 25
	base_attack_cooldown = 10
	attack_sound = 'sound/weapons/bladeslice.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive
