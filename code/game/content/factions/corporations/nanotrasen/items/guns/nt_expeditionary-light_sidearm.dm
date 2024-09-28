//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Caliber *//

/datum/ammo_caliber/nt_expeditionary/light_sidearm
	caliber = "nt-light-sidearm"
	diameter = 9
	length = 29

//* Ammo Casings *//

/obj/item/ammo_casing/nt_expeditionary/light_sidearm
	name = "ammo casing (NT-9)"
	desc = "A standardized 9mm cartridge for NT Expeditionary kinetics. This one seems to be for lightweight pistols and sidearms."
	caliber = /datum/ammo_caliber/nt_expeditionary/light_sidearm
	projectile_type = /obj/projectile/bullet/nt_expeditionary/light_sidearm

//* Magazines *//

/obj/item/ammo_magazine/nt_expeditionary/light_sidearm
	name = "ammo magazine (NT-7.5-LR)"
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/rifle-heavy-ammo.dmi'
	icon_state = "magazine"
	base_icon_state = "magazine"
	rendering_system = GUN_RENDERING_DISABLED
	ammo_caliber = /datum/ammo_caliber/nt_expeditionary/light_sidearm
	ammo_max = 5
	ammo_preload = /obj/item/ammo_casing/nt_expeditionary/light_sidearm

/obj/item/ammo_magazine/nt_expeditionary/light_sidearm/speedloader

/obj/item/ammo_magazine/nt_expeditionary/light_sidearm/speedloader/update_icon(updates)
	cut_overlays()
	. = ..()
	#warn impl; overlay via "[base_icon_state]-[casing.magazine_state]", shift -2, -2

/obj/item/ammo_magazine/nt_expeditionary/light_sidearm/pistol

/obj/item/ammo_magazine/nt_expeditionary/light_sidearm/smg

#warn impl all

//* Projectiles *//

/obj/projectile/bullet/nt_expeditionary/light_sidearm
	name = "bullet"
	damage_force = 35
	damage_tier = LERP(BULLET_TIER_LOW, BULLET_TIER_MEDIUM, 0.25)
	armor_penetration = 10

//* Light Sidearms *//

/obj/item/gun/ballistic/nt_expeditionary/light_sidearm
	abstract_type = /obj/item/gun/ballistic/nt_expeditionary/light_sidearm
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/sidearm-light.dmi'
	caliber = /datum/ammo_caliber/nt_expeditionary/light_sidearm

#warn sprites

//* Pistol *//

/obj/item/gun/ballistic/nt_expeditionary/light_sidearm/pistol
	name = "light pistol"
	desc = "The XNP Mk.1 \"Noisy Moth\" pistol; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A hold-out semiautomatic pistol designed to fit in the pocket and with an easy-to-use
		system of controls, the “Noisy Moth” is chambered in a lengthened version of the classic 9mm,
		packing a little more punch than traditional sidearms in this caliber.
		A small compensator and internal recoil dampeners make the increase in felt recoil negligible,
		while its magazine gives it enough ammunition for those in a pinch to take chance shots.
	"} + "<br>"

//* SMG *//

/obj/item/gun/ballistic/nt_expeditionary/light_sidearm/smg
	name = "machine pistol"
	desc = "The XNMP Mk.3 \"Buzzer\" machine pistol; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A personal defense weapon with collapsing stock, the “Buzzer” is chambered in 9x29mm.
		A short-barreled weapon easily hung on a belt, and feeding from medium-sized magazines to
		keep it handy, the simple “Buzzer” does tend to make more sound and fury than an effective
		combat weapon, but it will certainly raise the alarm when its shrill report sounds in
		the dead of night.
	"} + "<br>"

#warn impl all
