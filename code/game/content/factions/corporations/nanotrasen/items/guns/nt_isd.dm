//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/firemode/energy/nt_isd

/**
 * Weapons for NT's Internal Security.
 *
 * * Above-average energy weapons
 * * Expensive
 * * Joint with Hephaestus / Vey-Med, canonically
 * * There's probably a neat amount of these just floating around the Frontier now from losses.
 */
/obj/item/gun/energy/nt_isd

//* Energy Sidearm *//

/datum/firemode/energy/nt_isd/sidearm

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

#warn impl

//* Energy Carbine *//

/datum/firemode/energy/nt_isd/carbine

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

#warn impl

//* Energy Lance *//

/datum/firemode/energy/nt_isd/lance

/datum/firemode/energy/nt_isd/lance/kill
	name = "kill"
	render_color = "#00ff00"

/obj/item/gun/energy/nt_isd/lance
	name = "energy lance"
	desc = "A particle rifle used by corporate security. Shoots focused particle beams."
	description_fluff = {""}

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
	desc = "A sidearm as versatile as it is expensive."
	description_fluff = {""}

#warn impl

//* Projectiles *//

/obj/projectile/nt_isd

/obj/projectile/nt_isd/laser/sidearm
	name = "phaser blast"

/obj/projectile/nt_isd/laser
	name = "laser"

/obj/projectile/nt_isd/laser/multiphase

/obj/projectile/nt_isd/laser/lance
	name = "particle beam"

/obj/projectile/nt_isd/shock
	name = "energy beam"

/obj/projectile/nt_isd/electrode
	name = "stun bolt"

/obj/projectile/nt_isd/disable
	name = "disabler beam"

// todo: this shouldn't be an emp, this should be like synthetik's
/obj/projectile/nt_isd/ion
	name = "ion bolt"


#warn impl all + sprites
