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
		A modular
		A sidearm designed and manufactured by the Nanotrasen Research Division for its internal
		security needs. Specialized in non-lethal takedowns of high-risk perpetrators, the ENP-17
		is reminiscent of older electro-neural disruption devices used by less advanced societies in
		how it operates.

		After an increase in the presence of non-humanoid threats against Nanotrasen's operations in the
		Frontier, this standard sidearm received an upgrade adding a more powerful focusing lens used for
		a lethal setting that can be used in emergencies.
	"}
	#warn desc

//* Sidearm *//

/datum/firemode/energy/nt_prototype/sidearm
	abstract_type = /datum/firemode/energy/nt_prototype/sidearm

/obj/item/gun/projectile/energy/nt_prototype/sidearm
	name = "energy sidearm"
	desc = "A versatile energy sidearm wielded by corporate expeditionary teams."

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

	w_class = WEIGHT_CLASS_BULKY
	firemodes = list(
		/datum/firemode/energy/nt_prototype/rifle,
	)

#warn impl
