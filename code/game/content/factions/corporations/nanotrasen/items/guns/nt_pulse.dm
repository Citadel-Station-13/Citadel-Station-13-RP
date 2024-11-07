//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/firemode/energy/nt_pulse
	abstract_type = /datum/firemode/energy/nt_pulse
	cycle_cooldown = 0.4 SECONDS

/**
 * NT's military (Asset Protection & Emergency Responder) energy rifles
 */
/obj/item/gun/energy/nt_pulse
	abstract_type = /obj/item/gun/energy/nt_pulse
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/pulse.dmi'
	description_fluff = {"
		A breakthrough weapon from Nanotrasen's Research Division, pulse weapons utilize rare crystals in its generation array,
		allowing for a more laminar and cohesive beam than prior thought possible. Closely guarded designs to this day,
		pulse weapons are some of the only energy-based armaments able to consistently outperform any kinetic alternative.
	"}

//* Rifle *//

/datum/firemode/energy/nt_pulse/rifle
	abstract_type = /datum/firemode/energy/nt_pulse/rifle

/datum/firemode/energy/nt_pulse/rifle/laser
	name = "laser"
	render_key = "kill"
	settings = list(mode_name = "lethal", projectile_type = /obj/projectile/beam, charge_cost = 80)

/datum/firemode/energy/nt_pulse/rifle/pulse
	name = "pulse"
	render_key = "destroy"
	settings = list(mode_name = "destroy", projectile_type = /obj/projectile/beam/pulse, charge_cost = 180)

/obj/item/gun/energy/nt_pulse/rifle
	prototype_id = "nt-pulse-rifle"
	name = "pulse rifle"
	desc = "A powerful energy rifle with multiple intensity selectors."
	icon_state = "rifle"
	base_icon_state = "rifle"
	base_mob_state = "pulse"
	slot_flags = SLOT_BACK
	// todo: firemode this
	one_handed_penalty = 10
	// todo: firemode this
	heavy = TRUE
	// todo: firemode this

	firemodes = list(
		/datum/firemode/energy/nt_pulse/rifle/laser,
		/datum/firemode/energy/nt_pulse/rifle/pulse,
	)

	item_renderer = /datum/gun_item_renderer/segments{
		count = 4;
		offset_x = 2;
		independent_firemode = TRUE;
		use_firemode = TRUE;
		use_empty = TRUE;
	}
	mob_renderer = /datum/gun_mob_renderer/states{
		use_firemode = TRUE;
		count = 4;
		empty_state = TRUE;
	}

//* Carbine *//

/datum/firemode/energy/nt_pulse/carbine
	abstract_type = /datum/firemode/energy/nt_pulse/carbine

/datum/firemode/energy/nt_pulse/carbine/laser
	name = "laser"
	render_key = "kill"
	settings = list(mode_name = "lethal", projectile_type = /obj/projectile/beam, charge_cost = 120)

/datum/firemode/energy/nt_pulse/carbine/pulse
	name = "pulse"
	render_key = "destroy"
	settings = list(mode_name = "destroy", projectile_type = /obj/projectile/beam/pulse, charge_cost = 240)

/obj/item/gun/energy/nt_pulse/carbine
	prototype_id = "nt-pulse-carbine"
	name = "pulse carbine"
	desc = "A powerful energy carbine with multiple intensity selectors."
	icon_state = "carbine"
	base_icon_state = "carbine"
	base_mob_state = "pulse"
	slot_flags = SLOT_BELT
	// todo: firemode this

	firemodes = list(
		/datum/firemode/energy/nt_pulse/carbine/laser,
		/datum/firemode/energy/nt_pulse/carbine/pulse,
	)

	item_renderer = /datum/gun_item_renderer/segments{
		count = 4;
		offset_x = 2;
		independent_firemode = TRUE;
		use_firemode = TRUE;
		use_empty = TRUE;
	}
	mob_renderer = /datum/gun_mob_renderer/states{
		use_firemode = TRUE;
		count = 4;
		empty_state = TRUE;
	}

//* Projectiles *//

/obj/projectile/beam/pulse
	name = "pulse"
	icon_state = "u_laser"
	fire_sound = 'sound/weapons/gauss_shoot.ogg'
	damage_force = 60
	damage_tier = LASER_TIER_EXTREME
	armor_penetration = 75
	light_color = "#0066FF"

	muzzle_type = /obj/effect/projectile/muzzle/laser_pulse
	tracer_type = /obj/effect/projectile/tracer/laser_pulse
	impact_type = /obj/effect/projectile/impact/laser_pulse

// todo: this shouldn't be here i think
/obj/projectile/beam/pulse/shotgun
	damage_force = 50
	armor_penetration = 25
