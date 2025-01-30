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

//* Sidearm *//

/datum/firemode/energy/nt_prototype/sidearm
	abstract_type = /datum/firemode/energy/nt_prototype/sidearm

/obj/item/gun/projectile/energy/nt_prototype/sidearm
	name = "energy sidearm"
	desc = "A versatile energy sidearm wielded by corporate expeditionary teams."
	icon = 'icons/content/faction/corporations/nanotrasen/items/guns/energy/sidearm.dmi'

	w_class = WEIGHT_CLASS_NORMAL
	firemodes = list(
		/datum/firemode/energy/nt_prototype/sidearm,
	)
	#warn attachment support

#warn impl

//* Carbine *//

/datum/firemode/energy/nt_prototype/carbine
	abstract_type = /datum/firemode/energy/nt_prototype/carbine

/obj/item/gun/projectile/energy/nt_prototype/carbine
	name = "energy carbine"
	desc = "A versatile energy carbine wielded by corporate expeditionary teams."
	icon = 'icons/content/faction/corporations/nanotrasen/items/guns/energy/carbine.dmi'

	w_class = WEIGHT_CLASS_NORMAL
	firemodes = list(
		/datum/firemode/energy/nt_prototype/carbine,
	)
	#warn attachment support

#warn impl

//* Rifle *//

/datum/firemode/energy/nt_prototype/rifle
	abstract_type = /datum/firemode/energy/nt_prototype/rifle

/obj/item/gun/projectile/energy/nt_prototype/rifle
	name = "energy rifle"
	desc = "A versatile energy rifle wielded by corporate expeditionary teams."
	icon = 'icons/content/faction/corporations/nanotrasen/items/guns/energy/rifle.dmi'

	w_class = WEIGHT_CLASS_BULKY
	firemodes = list(
		/datum/firemode/energy/nt_prototype/rifle,
	)

#warn impl
