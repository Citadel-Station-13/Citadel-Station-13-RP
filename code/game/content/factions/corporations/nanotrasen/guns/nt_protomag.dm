//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Modular mag-boosted weapons, courtesy of the Nanotrasen Research Division.
 */
/obj/item/gun/projectile/ballistic/magnetic/nt_protomag
	abstract_type = /obj/item/gun/projectile/ballistic/magnetic/nt_protomag
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/protomag/gun.dmi'
	desc = "A modular ferromagnetic-boosted weapon. Uses experimental ferromagnetic ammunition."
	description_fluff = {"
		An experimental magnetic weapon from the Nanotrasen Research Division. The 'Protomag' series uses specially
		made ammunition capable of a hybrid launch, combining conventional propellant with an accelerating burst
		from a set of acceleration coils to throw a slug down-range. While still lacking in ammo capacity,
		this 'prototype' is already made in many Nanotrasen fleets for day-to-day usage. As of recent, designs
		for specialized cartridges have been released for field testing, though many of said rounds require
		a large amount of energy to discharge, in contrast to more normal hybrid rounds.
	"}
	caliber = /datum/ammo_caliber/nt_protomag

	modular_system = TRUE

//* Sidearm *//


/obj/item/gun/projectile/ballistic/magnetic/nt_protomag/sidearm
	name = "protomag sidearm"
	icon_state = "pistol-map"
	base_icon_state = "pistol"
	item_renderer = /datum/gun_item_renderer/overlays{
		count = 4;
		use_empty = TRUE;
		use_single = TRUE;
	}
	mob_renderer = /datum/gun_mob_renderer/overlays{
		count = 3;
		use_empty = TRUE;
		use_single = TRUE;
	}
	worn_render_flags = NONE
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	render_battery_overlay = MAGNETIC_RENDER_BATTERY_IN
	fire_sound = 'sound/content/factions/corporations/nanotrasen/protomag-pistol.ogg'
	base_shot_power = /obj/item/cell/device/weapon::maxcharge * (1 / (/obj/item/ammo_magazine/nt_protomag/sidearm::ammo_max * 4))

	modular_component_slots = list(
		GUN_COMPONENT_ACTIVE_COOLER = 1,
		GUN_COMPONENT_ENERGY_HANDLER = 1,
		GUN_COMPONENT_ACCELERATION_COIL = 1,
		GUN_COMPONENT_POWER_UNIT = 1,
	)

	materials_base = list(
		/datum/prototype/material/steel::id = 3500,
		/datum/prototype/material/glass::id = 500,
		/datum/prototype/material/silver::id = 750,
		/datum/prototype/material/gold::id = 350,
		/datum/prototype/material/copper::id = 750,
		/datum/prototype/material/diamond::id = 250,
		/datum/prototype/material/lead::id = 250,
	)

//* Rifle *//

/obj/item/gun/projectile/ballistic/magnetic/nt_protomag/rifle
	name = "protomag rifle"
	icon_state = "rifle-map"
	base_icon_state = "rifle"
	item_renderer = /datum/gun_item_renderer/overlays{
		count = 4;
		use_empty = TRUE;
		use_single = TRUE;
	}
	mob_renderer = /datum/gun_mob_renderer/overlays{
		count = 4;
		use_empty = TRUE;
		use_single = TRUE;
	}
	slot_flags = SLOT_BACK
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	render_mob_wielded = TRUE
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	render_battery_overlay = MAGNETIC_RENDER_BATTERY_IN
	base_shot_power = /obj/item/cell/device/weapon::maxcharge * (1 / (/obj/item/ammo_magazine/nt_protomag/rifle::ammo_max * 4))
	fire_sound = 'sound/content/factions/corporations/nanotrasen/protomag-rifle.ogg'

	modular_component_slots = list(
		GUN_COMPONENT_ACTIVE_COOLER = 1,
		GUN_COMPONENT_ENERGY_HANDLER = 2,
		GUN_COMPONENT_ACCELERATION_COIL = 2,
		GUN_COMPONENT_POWER_UNIT = 2,
	)

	materials_base = list(
		/datum/prototype/material/steel::id = 5000,
		/datum/prototype/material/glass::id = 1500,
		/datum/prototype/material/silver::id = 1500,
		/datum/prototype/material/gold::id = 800,
		/datum/prototype/material/copper::id = 1200,
		/datum/prototype/material/diamond::id = 350,
		/datum/prototype/material/lead::id = 450,
	)
