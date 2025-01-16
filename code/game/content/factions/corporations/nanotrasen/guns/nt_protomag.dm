//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Modular mag-boosted weapons, courtesy of the Nanotrasen Research Division.
 */
/obj/item/gun/ballistic/magnetic/modular/nt_protomag
	abstract_type = /obj/item/gun/ballistic/magnetic/modular/nt_protomag
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

//* Sidearm *//

#warn impl all

/obj/item/gun/ballistic/magnetic/modular/nt_protomag/sidearm
	name = "protomag sidearm"
	item_renderer = /datum/gun_item_renderer/overlays{
		count = 4;
		use_empty = TRUE;
		use_single = TRUE;
	}
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	render_battery_overlay = MAGNETIC_RENDER_BATTERY_IN
	fire_sound = 'sound/factions/corporations/nanotrasen/protomag-pistol.ogg'
	base_shot_power = /obj/item/cell/device/weapon::maxcharge * (1 / (/obj/item/ammo_magazine/nt_protomag/sidearm::ammo_max * 4))

//* Rifle *//

#warn impl all

/obj/item/gun/ballistic/magnetic/modular/nt_protomag/rifle
	name = "protomag rifle"
	item_renderer = /datum/gun_item_renderer/overlays{
		count = 4;
		use_empty = TRUE;
		use_single = TRUE;
	}
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	render_battery_overlay = MAGNETIC_RENDER_BATTERY_IN
	base_shot_power = /obj/item/cell/device/weapon::maxcharge * (1 / (/obj/item/ammo_magazine/nt_protomag/rifle::ammo_max * 4))
	fire_sound = 'sound/factions/corporations/nanotrasen/protomag-rifle.ogg'

#warn materials
