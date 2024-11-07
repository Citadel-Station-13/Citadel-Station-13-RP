//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/firemode/energy/nt_isd
	abstract_type = /datum/firemode/energy/nt_isd

/**
 * Weapons for NT's Internal Security.
 *
 * * Above-average energy weapons
 * * Expensive
 * * Joint with Hephaestus / Vey-Med, canonically
 * * There's probably a neat amount of these just floating around the Frontier now from losses.
 */
/obj/item/gun/energy/nt_isd
	abstract_type = /obj/item/gun/energy/nt_isd

//* Energy Sidearm *//

/datum/firemode/energy/nt_isd/sidearm
	abstract_type = /datum/firemode/energy/nt_isd/sidearm

/datum/firemode/energy/nt_isd/sidearm/stun
	name = "disrupt"
	render_color = "#ffff00"

/datum/firemode/energy/nt_isd/sidearm/disable
	name = "disable"
	render_color = "#77ffff"

/datum/firemode/energy/nt_isd/sidearm/lethal
	name = "kill"
	render_color = "#ff0000"

/obj/item/gun/energy/nt_isd/sidearm
	name = "hybrid taser"
	desc = "A versatile energy sidearm used by corporate security."
	description_fluff = {""}
	firemodes = list(
		/datum/firemode/energy/nt_isd/sidearm/stun,
		/datum/firemode/energy/nt_isd/sidearm/disable,
		/datum/firemode/energy/nt_isd/sidearm/lethal,
	)

#warn impl

//* Energy Carbine *//

/datum/firemode/energy/nt_isd/carbine
	abstract_type = /datum/firemode/energy/nt_isd/carbine

/datum/firemode/energy/nt_isd/carbine/disable
	name = "disable"
	render_color = "#77ffff"

/datum/firemode/energy/nt_isd/carbine/shock
	name = "shock"
	render_color = "#ffff00"

/datum/firemode/energy/nt_isd/carbine/kill
	name = "kill"
	render_color = "#ff0000"

/obj/item/gun/energy/nt_isd/carbine
	name = "energy carbine"
	desc = "A versatile energy carbine used by corporate security."
	description_fluff = {""}
	firemodes = list(
		/datum/firemode/energy/nt_isd/carbine/disable,
		/datum/firemode/energy/nt_isd/carbine/shock,
		/datum/firemode/energy/nt_isd/carbine/kill,
	)

#warn impl

//* Energy Lance *//

/datum/firemode/energy/nt_isd/lance
	abstract_type = /datum/firemode/energy/nt_isd/lance

/datum/firemode/energy/nt_isd/lance/kill
	name = "kill"
	render_color = "#00ff00"

/obj/item/gun/energy/nt_isd/lance
	name = "energy lance"
	desc = "A particle rifle used by corporate security. Shoots focused particle beams."
	description_fluff = {""}
	firemodes = list(
		/datum/firemode/energy/nt_isd/lance/kill,
	)

#warn impl

//* Multiphase Sidearm *//

/datum/firemode/energy/nt_isd/multiphase

/datum/firemode/energy/nt_isd/multiphase/disable
	name = "disable"
	render_color = "#77ffff"

/datum/firemode/energy/nt_isd/multiphase/kill
	name = "kill"
	render_color = "#ff0000"

// todo: this is an ion beam, not an EMP pulse
/datum/firemode/energy/nt_isd/multiphase/ion
	name = "ion"
	render_color = "#456aaa"

/obj/item/gun/energy/nt_isd/multiphase
	name = "multiphase sidearm"
	desc = "A prototype sidearm for high-ranking corporate security."
	description_fluff = {""}
	firemodes = list(
		/datum/firemode/energy/nt_isd/multiphase/disable,
		/datum/firemode/energy/nt_isd/multiphase/kill,
		/datum/firemode/energy/nt_isd/multiphase/ion,
	)

#warn impl

//* Projectiles *//

/obj/projectile/nt_isd
	abstract_type = /obj/projectile/nt_isd

/obj/projectile/nt_isd/laser
	abstract_type = /obj/projectile/nt_isd/laser
	damage_type = DAMAGE_TYPE_BURN

/obj/projectile/nt_isd/laser/rifle
	name = "laser"
	damage_force = 40
	damage_tier = LASER_TIER_MEDIUM

/obj/projectile/nt_isd/laser/sidearm
	name = "phaser blast"
	damage_force = 20
	damage_tier = LASER_TIER_HIGH

/obj/projectile/nt_isd/laser/multiphase
	name = "focused laser"
	damage_force = 40
	damage_tier = LASER_TIER_HIGH

/obj/projectile/nt_isd/laser/lance
	name = "particle beam"
	damage_force = 30
	damage_tier = LASER_TIER_HIGH

#warn sprites for above

/obj/projectile/nt_isd/shock
	name = "energy beam"
	#warn impl

/obj/projectile/nt_isd/electrode
	name = "stun bolt"
	#warn impl

/obj/projectile/nt_isd/disable
	name = "disabler beam"
	#warn impl

// todo: this shouldn't be an emp, this should be like synthetik's
/obj/projectile/nt_isd/ion
	name = "ion bolt"
	base_projectile_effects = list(
		/datum/projectile_effect/detonation/legacy_emp{
			sev_2 = 1;
			sev_3 = 2;
		},
	)
