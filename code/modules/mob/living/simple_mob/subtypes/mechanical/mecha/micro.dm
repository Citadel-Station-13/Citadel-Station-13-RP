// Tiny mecha.
// Designed for ranged attacks.

/datum/category_item/catalogue/technology/mouse_tank
	name = "Mouse Tank"
	desc = "Although it lacks a proper designation, the 'Mouse Tank' is not unfamiliar \
	in several neighboring sectors. Known for its speed and small size, theories \
	on the origin of these devices cover a wide array of probabilities. The general \
	consensus is that these tanks were designed as weapons of sabotage that never saw wide\
	deployment. Since that theoretical time, others may have discovered and modified this \
	technology for their own twisted ends."
	value = CATALOGUER_REWARD_EASY


/mob/living/simple_mob/mechanical/mecha/mouse_tank
	name = "\improper Mouse Tank"
	desc = "A shockingly functional, miniaturized tank. Its inventor is unknown, but widely reviled."
	catalogue_data = list(/datum/category_item/catalogue/technology/mouse_tank)
	icon_state = "mousetank"
	wreckage = /obj/structure/loot_pile/mecha/mouse_tank

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

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

/mob/living/simple_mob/mechanical/mecha/mouse_tank/manned
	pilot_type = /mob/living/simple_mob/animal/passive/mouse/mouse_op

// Immune to heat damage, resistant to lasers, and it spits fire.
/datum/category_item/catalogue/technology/mouse_tank/livewire
	name = "Livewire Assault Tank"
	desc = "Dubbed the 'Livewire Assault Tank' this pattern of the somewhat standard \
	due to its infamous brutality. The utilization of this kind of technology would \
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

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

/mob/living/simple_mob/mechanical/mecha/mouse_tank/livewire/manned
	pilot_type = /mob/living/simple_mob/animal/passive/mouse/pyro
