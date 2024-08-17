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

#warn impl all

//* Energy Sidearm *//

/datum/firemode/energy/nt_isd/sidearm

/datum/firemode/energy/nt_isd/sidearm/stun

/datum/firemode/energy/nt_isd/sidearm/disable

/datum/firemode/energy/nt_isd/sidearm/lethal

/obj/item/gun/energy/nt_isd/sidearm
	name = "hybrid taser"
	desc = "A versatile energy sidearm used by corporate security."
	description_fluff = {""}

//* Energy Carbine *//

/datum/firemode/energy/nt_isd/carbine

/datum/firemode/energy/nt_isd/carbine/disable

/datum/firemode/energy/nt_isd/carbine/shock

/datum/firemode/energy/nt_isd/carbine/kill

/obj/item/gun/energy/nt_isd/carbine
	name = "energy carbine"
	desc = "A versatile energy carbine used by corporate security."
	description_fluff = {""}

//* Energy Lance *//

/datum/firemode/energy/nt_isd/lance

/datum/firemode/energy/nt_isd/lance/kill

/obj/item/gun/energy/nt_isd/lance
	name = "energy lance"
	desc = "A particle rifle used by corporate security. Shoots focused particle beams."
	description_fluff = {""}

//* Multiphase Sidearm *//

/datum/firemode/energy/nt_isd/multiphase

/datum/firemode/energy/nt_isd/multiphase/disable

/datum/firemode/energy/nt_isd/multiphase/kill

// todo: this is an ion beam, not an EMP pulse
/datum/firemode/energy/nt_isd/multiphase/ion

/obj/item/gun/energy/nt_isd/multiphase

	name = "multiphase sidearm"
	desc = "A rare sidearm as versatile as it is expensive."
	description_fluff = {""}
