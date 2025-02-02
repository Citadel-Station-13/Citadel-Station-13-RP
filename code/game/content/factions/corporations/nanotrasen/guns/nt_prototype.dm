//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/firemode/energy/nt_prototype
	abstract_type = /datum/firemode/energy/nt_prototype

/**
 * Weapons built by the Nanotrasen Research Division
 *
 * * Above-average energy weapons
 * * Expensive
 * * Joint with Hephaestus / Vey-Med, canonically
 */
/obj/item/gun/projectile/energy/nt_prototype
	abstract_type = /obj/item/gun/projectile/energy/nt_prototype
	description_fluff = {"
		A modular energy weapon manufactured by the Nanotrasen Research Division
		for internal usage. A variety of modules can be installed inside, and the entire
		system is built to allow for easy maintenance out on the field.
	"}
	modular_system = TRUE

//* Sidearm *//

/datum/firemode/energy/nt_prototype/sidearm
	abstract_type = /datum/firemode/energy/nt_prototype/sidearm

/obj/item/gun/projectile/energy/nt_prototype/sidearm
	name = "energy sidearm"
	desc = "A versatile energy sidearm wielded by corporate expeditionary teams."
	icon = 'icons/content/faction/corporations/nanotrasen/items/guns/energy/sidearm.dmi'
	icon_state = "sidearm"

	w_class = WEIGHT_CLASS_NORMAL
	firemodes = list(
		/datum/firemode/energy/nt_prototype/sidearm,
	)
	attachment_alignment = list(
		GUN_ATTACHMENT_SLOT_SIDEBARREL = list(
			26,
			15,
		),
	)

	item_renderer = /datum/gun_item_renderer/overlays{
		count = 4;
		use_empty = TRUE;
		use_single = TRUE;
		use_color = TRUE;
	}
	mob_renderer = /datum/gun_mob_renderer/overlays{
		count = 4;
		use_empty = TRUE;
		use_single = TRUE;
		use_color = TRUE;
	}
	render_wielded = TRUE

	modular_component_slots = list(
		GUN_COMPONENT_ACTIVE_COOLER = 1,
		GUN_COMPONENT_ENERGY_HANDLER = 1,
		GUN_COMPONENT_FOCUSING_LENS = 1,
		GUN_COMPONENT_PARTICLE_ARRAY = 2,
		GUN_COMPONENT_POWER_UNIT = 1,
	)

//* Carbine *//

/datum/firemode/energy/nt_prototype/carbine
	abstract_type = /datum/firemode/energy/nt_prototype/carbine

/obj/item/gun/projectile/energy/nt_prototype/carbine
	name = "energy carbine"
	desc = "A versatile energy carbine wielded by corporate expeditionary teams."
	icon = 'icons/content/faction/corporations/nanotrasen/items/guns/energy/carbine.dmi'
	icon_state = "carbine"

	w_class = WEIGHT_CLASS_NORMAL
	firemodes = list(
		/datum/firemode/energy/nt_prototype/carbine,
	)
	attachment_alignment = list(
		GUN_ATTACHMENT_SLOT_SIDEBARREL = list(
			27,
			15,
		),
	)

	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	item_renderer = /datum/gun_item_renderer/overlays{
		count = 4;
		use_empty = TRUE;
		use_single = TRUE;
		use_color = TRUE;
	}
	mob_renderer = /datum/gun_mob_renderer/overlays{
		count = 4;
		use_empty = TRUE;
		use_single = TRUE;
		use_color = TRUE;
	}
	render_wielded = TRUE

	modular_component_slots = list(
		GUN_COMPONENT_ACTIVE_COOLER = 1,
		GUN_COMPONENT_ENERGY_HANDLER = 1,
		GUN_COMPONENT_FOCUSING_LENS = 2,
		GUN_COMPONENT_PARTICLE_ARRAY = 3,
		GUN_COMPONENT_POWER_UNIT = 1,
	)

//* Rifle *//

/datum/firemode/energy/nt_prototype/rifle
	abstract_type = /datum/firemode/energy/nt_prototype/rifle

/obj/item/gun/projectile/energy/nt_prototype/rifle
	name = "energy rifle"
	desc = "A versatile energy rifle wielded by corporate expeditionary teams."
	icon = 'icons/content/faction/corporations/nanotrasen/items/guns/energy/rifle.dmi'
	icon_state = "rifle"

	w_class = WEIGHT_CLASS_BULKY
	firemodes = list(
		/datum/firemode/energy/nt_prototype/rifle,
	)
	attachment_alignment = list(
		GUN_ATTACHMENT_SLOT_SIDEBARREL = list(
			28,
			13,
		),
	)

	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	item_renderer = /datum/gun_item_renderer/overlays{
		count = 4;
		use_empty = TRUE;
		use_single = TRUE;
		use_color = TRUE;
	}
	mob_renderer = /datum/gun_mob_renderer/overlays{
		count = 4;
		use_empty = TRUE;
		use_single = TRUE;
		use_color = TRUE;
	}
	render_wielded = TRUE

	modular_component_slots = list(
		GUN_COMPONENT_ACTIVE_COOLER = 1,
		GUN_COMPONENT_ENERGY_HANDLER = 2,
		GUN_COMPONENT_FOCUSING_LENS = 2,
		GUN_COMPONENT_PARTICLE_ARRAY = 3,
		GUN_COMPONENT_POWER_UNIT = 2,
	)
