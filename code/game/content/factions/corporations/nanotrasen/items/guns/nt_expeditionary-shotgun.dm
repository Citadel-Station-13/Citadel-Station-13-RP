//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

// todo: while this is all valid code, this file is commented out because the current weapon racking/pumping/chamber charging system is not good enough to support this.

//* Ammo *//

/obj/item/ammo_magazine/a12g/nt_expeditionary
	icon = 'icons/content/factions/corporations/nanotrasen/items/gun/expeditionary/shotgun-ammo.dmi'

	#warn restrict to NT-expeditionary

/obj/item/ammo_magazine/a12g/nt_expeditionary/slide
	name = "XNS slide magazine (a12g)"

/obj/item/ammo_magazine/a12g/nt_expeditionary/box
	name = "XNS box magazine (12g)"

	#warn slide-mag 0 to 5, box-mag 0 to 1

//* Shotguns *//

/obj/item/gun/ballistic/nt_expeditionary/shotgun
	icon = 'icons/content/factions/corporations/nanotrasen/items/gun/expeditionary/shotgun.dmi'
	caliber = /datum/ammo_caliber/a12g

//* Basic Shotgun *//

/**
 * * Requires pumping.
 * * Break action magazine load or single load.
 */
/obj/item/gun/ballistic/nt_expeditionary/shotgun/pump
	name = "pump shotgun"
	desc = "The XNS MK.6 \"Standby\" pump-action shotgun; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A pump-action design based on the proven pump-action mechanism developed centuries ago,
		the XNS Mk.6 or “Standby” is designed around a tube magazine using 12-gauge ammunition.
		Rugged, if not fancy, this weapon is a good fallback option for anyone
		requiring access to a long arm when out on their own or in small groups.
	"} + "<br>" +/obj/item/gun/ballistic/nt_expeditionary::description_fluff
	icon_state = "pump"
	#warn pump-open

#warn impl

//* Semi-Automatic Shotgun *//

/**
 * * Magazine loaded.
 * * Semi-automatic.
 */
/obj/item/gun/ballistic/nt_expeditionary/shotgun/semiauto
	name = "semi-automatic shotgun"
	desc = "The XNS MK.7 \"Peacemaker\" pump-action shotgun; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A semiautomatic evolution of the XNS Mk.6, using an internal inertial locking system and
		muzzle brake. Big, blocky, and using detachable box magazines of 12-gauge ammunition,
		the barrel tends to get quite warm if fired without pause. A common sight seen with
		specialist security personnel supporting work crews, the somewhat bulky weapon
		lives up to its name in helping deter both hostile animals and bandits from
		thinking they can make an easy score.
	"} + "<br>" +/obj/item/gun/ballistic/nt_expeditionary::description_fluff
	icon_state = "semiauto"
	#warn semiauto-empty (magout)

#warn impl
