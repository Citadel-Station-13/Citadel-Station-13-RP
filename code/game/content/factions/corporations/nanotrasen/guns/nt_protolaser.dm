//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/firemode/energy/nt_protolaser
	abstract_type = /datum/firemode/energy/nt_protolaser

/**
 * Weapons built by the Nanotrasen Research Division
 *
 * * Above-average energy weapons
 * * Expensive
 * * Joint with Hephaestus / Vey-Med, canonically
 */
/obj/item/gun/projectile/energy/nt_protolaser
	abstract_type = /obj/item/gun/projectile/energy/nt_protolaser
	description_fluff = {"
		A modular energy weapon manufactured by the Nanotrasen Research Division
		for internal usage. A variety of modules can be installed inside, and the entire
		system is built to allow for easy maintenance out on the field.
	"}
	modular_system = TRUE

/datum/prototype/design/generated/nt_protolaser
	abstract_type = /datum/prototype/design/generated/nt_protolaser
	category = DESIGN_CATEGORY_MUNITIONS
	subcategory = DESIGN_SUBCATEGORY_ENERGY

/datum/prototype/design/generated/nt_protolaser/generate_name(template)
	return ..("modular energy prototype - [template]")

//* Sidearm *//

/datum/firemode/energy/nt_protolaser/sidearm

/obj/item/gun/projectile/energy/nt_protolaser/sidearm
	name = "energy sidearm"
	desc = "A versatile energy sidearm wielded by corporate expeditionary teams."
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/energy/sidearm.dmi'
	icon_state = "sidearm"

	w_class = WEIGHT_CLASS_NORMAL
	firemodes = list(
		/datum/firemode/energy/nt_protolaser/sidearm,
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

	modular_component_slots = list(
		GUN_COMPONENT_ACTIVE_COOLER = 1,
		GUN_COMPONENT_ENERGY_HANDLER = 1,
		GUN_COMPONENT_FOCUSING_LENS = 1,
		GUN_COMPONENT_PARTICLE_ARRAY = 2,
		GUN_COMPONENT_POWER_UNIT = 1,
	)

	materials_base = list(
		/datum/prototype/material/steel::id = 1750,
		/datum/prototype/material/glass::id = 500,
		/datum/prototype/material/silver::id = 250,
		/datum/prototype/material/gold::id = 125,
		/datum/prototype/material/copper::id = 500,
	)

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/gun/projectile/energy/nt_protolaser/sidearm/no_pin, /nt_protolaser/sidearm, "nt-protolaser-sidearm")
/obj/item/gun/projectile/energy/nt_protolaser/sidearm/no_pin
	pin = null

//* Carbine *//

/datum/firemode/energy/nt_protolaser/carbine

/obj/item/gun/projectile/energy/nt_protolaser/carbine
	name = "energy carbine"
	desc = "A versatile energy carbine wielded by corporate expeditionary teams."
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/energy/carbine.dmi'
	icon_state = "carbine"

	w_class = WEIGHT_CLASS_NORMAL
	firemodes = list(
		/datum/firemode/energy/nt_protolaser/carbine,
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

	materials_base = list(
		/datum/prototype/material/steel::id = 2750,
		/datum/prototype/material/glass::id = 750,
		/datum/prototype/material/silver::id = 750,
		/datum/prototype/material/gold::id = 250,
		/datum/prototype/material/copper::id = 500,
	)

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/gun/projectile/energy/nt_protolaser/carbine/no_pin, /nt_protolaser/carbine, "nt-protolaser-carbine")
/obj/item/gun/projectile/energy/nt_protolaser/carbine/no_pin
	pin = null

//* Rifle *//

/datum/firemode/energy/nt_protolaser/rifle

/obj/item/gun/projectile/energy/nt_protolaser/rifle
	name = "energy rifle"
	desc = "A versatile energy rifle wielded by corporate expeditionary teams."
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/energy/rifle.dmi'
	icon_state = "rifle"

	w_class = WEIGHT_CLASS_BULKY
	firemodes = list(
		/datum/firemode/energy/nt_protolaser/rifle,
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

	materials_base = list(
		/datum/prototype/material/steel::id = 4000,
		/datum/prototype/material/glass::id = 1250,
		/datum/prototype/material/silver::id = 1250,
		/datum/prototype/material/gold::id = 750,
		/datum/prototype/material/copper::id = 500,
	)

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/gun/projectile/energy/nt_protolaser/rifle/no_pin, /nt_protolaser/rifle, "nt-protolaser-rifle")
/obj/item/gun/projectile/energy/nt_protolaser/rifle/no_pin
	pin = null
