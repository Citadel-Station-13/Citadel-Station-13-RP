//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/firemode/energy/nt_pulse
	abstract_type = /datum/firemode/energy/nt_pulse
	cycle_cooldown = 0.4 SECONDS

/**
 * NT's military (Asset Protection & Emergency Responder) energy rifles
 */
/obj/item/gun/projectile/energy/nt_pulse
	abstract_type = /obj/item/gun/projectile/energy/nt_pulse
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/nt_pulse.dmi'
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
	// todo: function of defines for weapon cell standard capacities
	charge_cost = 80
	projectile_type = /obj/projectile/beam

/datum/firemode/energy/nt_pulse/rifle/pulse
	name = "pulse"
	render_key = "destroy"
	// todo: function of defines for weapon cell standard capacities
	charge_cost = 160
	projectile_type = /obj/projectile/beam/pulse

/obj/item/gun/projectile/energy/nt_pulse/rifle
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
		use_firemode = TRUE;
		use_firemode = TRUE;
		use_empty = TRUE;
	}
	mob_renderer = /datum/gun_mob_renderer/states{
		use_firemode = TRUE;
		count = 4;
		use_empty = TRUE;
	}

//* Carbine *//

/datum/firemode/energy/nt_pulse/carbine
	abstract_type = /datum/firemode/energy/nt_pulse/carbine

/datum/firemode/energy/nt_pulse/carbine/laser
	name = "laser"
	render_key = "kill"
	// todo: function of defines for weapon cell standard capacities
	charge_cost = 120
	projectile_type = /obj/projectile/beam

/datum/firemode/energy/nt_pulse/carbine/pulse
	name = "pulse"
	render_key = "destroy"
	// todo: function of defines for weapon cell standard capacities
	charge_cost = 240
	projectile_type = /obj/projectile/beam/pulse

/obj/item/gun/projectile/energy/nt_pulse/carbine
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
		use_firemode = TRUE;
		use_firemode = TRUE;
		use_empty = TRUE;
	}
	mob_renderer = /datum/gun_mob_renderer/states{
		use_firemode = TRUE;
		count = 4;
		use_empty = TRUE;
	}

//* Projectiles *//

// todo: nt_pulse?
/obj/projectile/beam/pulse
	name = "pulse"
	fire_sound = 'sound/weapons/gauss_shoot.ogg'
	damage_force = 60
	damage_tier = 6
	light_color = "#0066FF"

	tracer_icon = 'icons/content/factions/corporations/nanotrasen/items/guns/nt_pulse-projectile.dmi'
	tracer_icon_state = "pulse"

	impact_sound = PROJECTILE_IMPACT_SOUNDS_ENERGY

// todo: this shouldn't be here i think
/obj/projectile/beam/pulse/shotgun
	damage_force = 50
	damage_tier = 4.25
