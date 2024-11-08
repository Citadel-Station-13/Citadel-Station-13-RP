//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: type-gen all of these.
/obj/item/ammo_magazine/nt_protomag
	abstract_type = /obj/item/ammo_magazine/nt_protomag
	desc = "A magazine for a magnetic weapon of some kind."
	ammo_caliber = /datum/caliber/nt_protomag

#warn first two should fit in webbing, but not boxes

//* Sidearm Magazines *//

/obj/item/ammo_magazine/nt_protomag/sidearm
	name = "protomag sidearm magazine"
	ammo_max = 8

	w_class = WEIGHT_CLASS_NORMAL // no boxes
	weight_volume = WEIGHT_VOLUME_TINY
	slot_flags = SLOT_POCKET

//* Rifle Magazines *//

/obj/item/ammo_magazine/nt_protomag/rifle
	name = "protomag rifle magazine"
	ammo_max = 16

	w_class = WEIGHT_CLASS_NORMAL // no boxes
	weight_volume = WEIGHT_VOLUME_SMALL
	slot_flags = SLOT_POCKET

//* Boxes *//

/obj/item/ammo_magazine/nt_protomag/box
	abstract_type = /obj/item/ammo_magazine/nt_protomag/box
	name = "protomag ammo box"
	desc = "A box of experimental magnetic ammunition."
	ammo_max = 32

	w_class = WEIGHT_CLASS_NORMAL // no boxes
	weight_volume = WEIGHT_VOLUME_NORMAL
	slot_flags = SLOT_POCKET

/obj/item/ammo_magazine/nt_protomag/box/standard
	name = "protomag ammo box (standard)"
	ammo_preload = /obj/item/ammo_casing/nt_protomag/magboosted/standard

/obj/item/ammo_magazine/nt_protomag/box/sabot
	name = "protomag ammo box (sabot)"
	ammo_preload = /obj/item/ammo_casing/nt_protomag/magboosted/sabot

// todo: this is currently disabled as medcode is not verbose enough for this to work
// /obj/item/ammo_magazine/nt_protomag/box/shredder
// 	name = "protomag ammo box (shredder)"
// 	ammo_preload = /obj/item/ammo_casing/nt_protomag/magboosted/shredder

/obj/item/ammo_magazine/nt_protomag/box/impact
	name = "protomag ammo box (impact)"
	ammo_preload = /obj/item/ammo_casing/nt_protomag/magboosted/impact

/obj/item/ammo_magazine/nt_protomag/box/practice
	name = "protomag ammo box (practice)"
	ammo_preload = /obj/item/ammo_casing/nt_protomag/magboosted/practice

/obj/item/ammo_magazine/nt_protomag/box/smoke
	name = "protomag ammo box (smoke)"
	ammo_preload = /obj/item/ammo_casing/nt_protomag/magnetic/smoke

/obj/item/ammo_magazine/nt_protomag/box/emp
	name = "protomag ammo box (emp)"
	ammo_preload = /obj/item/ammo_casing/nt_protomag/magnetic/emp

// todo: this is currently disabled as simplemobs are not complex-AI enough for us to do this, and we don't need a PVP-only tool
// /obj/item/ammo_magazine/nt_protomag/box/concussive
// 	name = "protomag ammo box (concussive)"
// 	ammo_preload = /obj/item/ammo_casing/nt_protomag/magnetic/concussive

/obj/item/ammo_magazine/nt_protomag/box/penetrator
	name = "protomag ammo box (penetrator)"
	ammo_preload = /obj/item/ammo_casing/nt_protomag/magnetic/penetrator

/obj/item/ammo_magazine/nt_protomag/box/shock
	name = "protomag ammo box (shock)"
	ammo_preload = /obj/item/ammo_casing/nt_protomag/magnetic/shock

/obj/item/ammo_magazine/nt_protomag/box/flare
	name = "protomag ammo box (flare)"
	ammo_preload = /obj/item/ammo_casing/nt_protomag/magnetic/flare

// todo: fuck no, rework fire stacks / fire first, holy crap; even then this should take multiple hits to ignite.
// /obj/item/ammo_magazine/nt_protomag/box/incendiary
// 	name = "protomag ammo box (incendiary)"
// 	ammo_preload = /obj/item/ammo_casing/nt_protomag/magnetic/incendiary

// todo: fuck no, not until chloral and chemicals are reworked; this round is meant to take like 2-3 units maximum, on that note.
// /obj/item/ammo_magazine/nt_protomag/box/reagent
// 	name = "protomag ammo box (reagent)"
// 	ammo_preload = /obj/item/ammo_casing/nt_protomag/magnetic/reagent

#warn impl all
#warn materials & R&D designs for all of the abvoe
