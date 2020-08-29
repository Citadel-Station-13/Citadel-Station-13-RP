// Tiny mecha.
// Designed for ranged attacks.

/datum/category_item/catalogue/technology/mouse_tank
	name = "Whisker Tank"
	desc = "Unofficially dubbed the 'Whisker Tank', this micro mecha is not unfamiliar \
	in several neighboring sectors. Known for its speed and small size, theories \
	on the origin of these devices cover a wide array of probabilities. The general \
	consensus is that these tanks were designed as weapons of sabotage that never saw wide\
	deployment. Since that theoretical time, others may have discovered and modified this \
	technology for their own twisted ends."
	value = CATALOGUER_REWARD_EASY


/mob/living/simple_mob/mechanical/mecha/mouse_tank
	name = "\improper Whisker Tank"
	desc = "A shockingly functional, miniaturized tank. Its inventor is unknown, but widely reviled."
	catalogue_data = list(/datum/category_item/catalogue/technology/mouse_tank)
	icon = 'icons/mecha/micro.dmi'
	icon_state = "whisker"
	wreckage = /obj/structure/loot_pile/mecha/mouse_tank
	faction = "mouse_army"

	maxHealth = 150
	armor = list(
				"melee" = 25,
				"bullet" = 20,
				"laser" = 30,
				"energy" = 15,
				"bomb" = 0,
				"bio" = 100,
				"rad" = 100
				)

	projectiletype = /obj/item/projectile/bullet/pistol/medium

	movement_cooldown = 2
	base_attack_cooldown = 8

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

/mob/living/simple_mob/mechanical/mecha/mouse_tank/manned
	pilot_type = /mob/living/simple_mob/animal/space/mouse_army/operative

// Immune to heat damage, resistant to lasers, and it spits fire.
/datum/category_item/catalogue/technology/mouse_tank/livewire
	name = "Livewire Assault Tank"
	desc = "Dubbed the 'Livewire Assault Tank', this pattern of the 'standard' Whisker \
	tank has been condemned by multiple governments and corporations due to the \
	infamous brutality of its armaments. The utilization of this kind of technology would \
	spark a major scandal if its origins could ever be proven."
	value = CATALOGUER_REWARD_EASY


/mob/living/simple_mob/mechanical/mecha/mouse_tank/livewire
	name = "\improper Livewire Assault Tank"
	desc = "A scorched, miniaturized light tank. It is mentioned only in hushed whispers."
	catalogue_data = list(/datum/category_item/catalogue/technology/mouse_tank/livewire)
	icon_state = "livewire"
	wreckage = /obj/structure/loot_pile/mecha/mouse_tank/livewire

	maxHealth = 200
	heat_resist = 1
	armor = list(
				"melee" = 0,
				"bullet" = 20,
				"laser" = 50,
				"energy" = 0,
				"bomb" = 50,
				"bio" = 100,
				"rad" = 100
				)

	projectiletype = /obj/item/projectile/bullet/incendiary/flamethrower/large

	movement_cooldown = 3
	base_attack_cooldown = 15

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

/mob/living/simple_mob/mechanical/mecha/mouse_tank/livewire/manned
	pilot_type = /mob/living/simple_mob/animal/space/mouse_army/pyro

//Rockets? Rockets.
/datum/category_item/catalogue/technology/mouse_tank/eraticator
	name = "Eraticator Artillery Platform"
	desc = "Rare and fearsome weapons platforms, 'Eraticators', as they have come to be \
	known, are frighteningly powerful long ranged tanks built entirely around exotic \
	gyrojet technology. The raw cost and specialized nature of its design makes it a rare \
	but formidable foe. It is often accompanied by mechanized reinforcements."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/mechanical/mecha/mouse_tank/eraticator
	name = "\improper Eraticator Artillery Platform"
	desc = "A heavy, miniaturized artillery platform. If you can hear it squeaking, you're too close."
	catalogue_data = list(/datum/category_item/catalogue/technology/mouse_tank/eraticator)
	icon_state = "eraticator"
	wreckage = /obj/structure/loot_pile/mecha/mouse_tank/eraticator

	maxHealth = 300
	heat_resist = 1
	armor = list(
				"melee" = 20,
				"bullet" = 50,
				"laser" = 50,
				"energy" = 20,
				"bomb" = 80,
				"bio" = 100,
				"rad" = 100
				)

	projectiletype = /obj/item/projectile/bullet/gyro

	movement_cooldown = 5
	base_attack_cooldown = 15

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

/mob/living/simple_mob/mechanical/mecha/mouse_tank/eraticator/manned
	pilot_type = /mob/living/simple_mob/animal/space/mouse_army/ammo
