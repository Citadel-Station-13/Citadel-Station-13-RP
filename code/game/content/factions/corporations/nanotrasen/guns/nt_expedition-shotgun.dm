//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: while this is all valid code, this file is commented out because the current weapon racking/pumping/chamber charging system is not good enough to support this.

//* Ammo *//

/obj/item/ammo_magazine/a12g/nt_expedition
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/shotgun.dmi'

	#warn restrict to NT-expeditionary

/obj/item/ammo_magazine/a12g/nt_expedition/slide
	name = "XNS slide magazine (a12g)"

/obj/item/ammo_magazine/a12g/nt_expedition/box
	name = "Box magazine (12g)"
	name = "ammo magazine (7.5mm LRC)"
	icon_state = "shotgun-1"
	base_icon_state = "shotgun"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	ammo_max = 8

	#warn slide-mag 0 to 5, box-mag 0 to 1

//* Shotguns *//

/obj/item/gun/projectile/ballistic/nt_expedition/shotgun
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/shotgun.dmi'
	caliber = /datum/ammo_caliber/a12g

//* Pump Shotgun *//

/**
 * * Requires pumping.
 * * Break action magazine load or single load.
 */
/obj/item/gun/projectile/ballistic/nt_expedition/shotgun/pump
	name = "pump shotgun"
	desc = "The XNS Mk.3 \"Standby\" pump-action shotgun; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		Based on the proven pump-action mechanism utilized by the Hephaestus KS-40, the XNS Mk.3 or \"Standby\" is designed around a
		tube magazine using 12/70 ammunition and features a modified barrel liner and extra design safety margins due to Nanotrasen's request
		for a shotgun that could operate safely using experimental ammunition.
	"} + "<br>"
	icon_state = "pump"
	#warn pump-open
	w_class = WEIGHT_CLASS_FOR_SHOTGUN

#warn impl

/obj/item/gun/projectile/ballistic/nt_expedition/shotgun/pump/short
	name = "pump shotgun"
	desc = "The XNS Mk.3 Mod I \"Standby\" pump-action shotgun; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A specialized variant of the Mk.3 \"Standby\", the Mod I has been reduced to the mechanical limits of the action, featuring a
		significantly shortened barrel, half the shell capacity, and no stock, it's intended for breaching or other applications where
		the shotgun is not expected act as the primary weapon, but the ability to fire 12 gauge shells is still required.
	"} + "<br>"
	icon_state = "shorty"
	#warn pump-open
	w_class = WEIGHT_CLASS_FOR_SHOTGUN

#warn impl

//* Semi-Automatic Shotgun *//

/**
 * * Magazine loaded.
 * * Semi-automatic.
 */
/obj/item/gun/projectile/ballistic/nt_expedition/shotgun/semiauto
	name = "semi-automatic shotgun"
	desc = "The XNS Mk.7 \"Peacemaker\" semi-automatic shotgun; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A semiautomatic shotgun chambered for 12/70 shells, the \"Peacemaker\" was designed for both Nanotrasen's exploration
		and internal security departments, it's surprisingly lightweight, magazine-fed, and equipped with a 1x reflex sight, compensator and
		a vertical grip integrated into the handguard to help control the significant recoil.
	"} + "<br>"
	icon_state = "semiauto"
	#warn semiauto-empty (magout)
	w_class = WEIGHT_CLASS_FOR_SHOTGUN

#warn impl
