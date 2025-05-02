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
	chamber_simulation = FALSE
	modular_system = TRUE

	var/legacy_discharged_fire_sound

// todo: unified fire sound handling
/obj/item/gun/projectile/ballistic/magnetic/nt_protomag/legacy_resolve_fire_sound(mob/user, obj/projectile/P)
	if(istype(P, /obj/projectile/nt_protomag))
		var/obj/projectile/nt_protomag/fitted_projectile = P
		if(fitted_projectile.penalized)
			return legacy_discharged_fire_sound || ..()
	return ..()

/datum/prototype/design/generated/nt_protomag
	abstract_type = /datum/prototype/design/generated/nt_protomag
	category = DESIGN_CATEGORY_MUNITIONS
	subcategory = DESIGN_SUBCATEGORY_MAGNETIC

//* Sidearm *//

/datum/gun_item_renderer/overlays/nt_protomag/sidearm
	count = 4
	use_empty = TRUE
	use_single = TRUE

/datum/gun_mob_renderer/overlays/nt_protomag/sidearm
	count = 3
	use_empty = TRUE
	use_single = TRUE

/obj/item/gun/projectile/ballistic/magnetic/nt_protomag/sidearm
	name = "protomag sidearm"
	icon_state = "pistol-map"
	base_icon_state = "pistol"
	item_renderer = /datum/gun_item_renderer/overlays/nt_protomag/sidearm
	mob_renderer = /datum/gun_mob_renderer/overlays/nt_protomag/sidearm
	worn_render_flags = NONE
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	render_battery_overlay = MAGNETIC_RENDER_BATTERY_IN
	magazine_restrict = /obj/item/ammo_magazine/nt_protomag/sidearm
	fire_sound = /datum/soundbyte/guns/magnetic/magnetic_1/pistol
	// todo: boost this again maybe when weapon cells aren't tiny
	base_charge_cost = /obj/item/cell/device/weapon::maxcharge * (1 / (/obj/item/ammo_magazine/nt_protomag/sidearm::ammo_max * 2))

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
		/datum/prototype/material/gold::id = 750,
		/datum/prototype/material/copper::id = 750,
		/datum/prototype/material/lead::id = 250,
	)

	legacy_discharged_fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/gun/projectile/ballistic/magnetic/nt_protomag/sidearm/no_pin, /nt_protomag/sidearm, "nt-magpistol")
/obj/item/gun/projectile/ballistic/magnetic/nt_protomag/sidearm/no_pin
	pin = null

//* Rifle *//

/datum/gun_item_renderer/overlays/nt_protomag/rifle
	count = 4
	use_empty = TRUE
	use_single = TRUE

/datum/gun_mob_renderer/overlays/nt_protomag/rifle
	count = 4
	use_empty = TRUE
	use_single = TRUE

/obj/item/gun/projectile/ballistic/magnetic/nt_protomag/rifle
	name = "protomag rifle"
	icon_state = "rifle-map"
	base_icon_state = "rifle"
	item_renderer = /datum/gun_item_renderer/overlays/nt_protomag/rifle
	mob_renderer = /datum/gun_mob_renderer/overlays/nt_protomag/rifle
	slot_flags = SLOT_BACK
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	render_wielded = TRUE
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	render_battery_overlay = MAGNETIC_RENDER_BATTERY_IN
	magazine_restrict = /obj/item/ammo_magazine/nt_protomag/rifle
	fire_sound = /datum/soundbyte/guns/magnetic/magnetic_1/rifle
	// todo: boost this again maybe when weapon cells aren't tiny
	base_charge_cost = /obj/item/cell/device/weapon::maxcharge * (1 / (/obj/item/ammo_magazine/nt_protomag/rifle::ammo_max * 2))

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
		/datum/prototype/material/gold::id = 1250,
		/datum/prototype/material/copper::id = 1200,
		/datum/prototype/material/lead::id = 450,
	)

	legacy_discharged_fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/gun/projectile/ballistic/magnetic/nt_protomag/rifle, /nt_protomag/rifle, "nt-magrifle")
/obj/item/gun/projectile/ballistic/magnetic/nt_protomag/rifle/no_pin
	pin = null
