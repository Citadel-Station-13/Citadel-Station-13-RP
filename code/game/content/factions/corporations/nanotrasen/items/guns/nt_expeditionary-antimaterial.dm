//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Ammo Casings *//

/obj/item/ammo_casing/nt_expeditionary/antimaterial
	name = "ammo casing (NT-12.5-antimaterial)"
	desc = "A standardized 12.5x92mm cartridge for NT Expeditionary kinetics. This one seems ridiculous large, and is probably for a very powerful weapon."
	caliber = /datum/ammo_caliber/nt_expeditionary/antimaterial
	projectile_type = /obj/projectile/bullet/nt_expeditionary/antimaterial

//* Projectiles *//

/obj/projectile/bullet/nt_expeditionary/antimaterial
	name = "antimaterial sabot"
	damage = 55
	damage_tier = LERP(BULLET_TIER_HIGH, BULLET_TIER_EXTREME, 1)
	armor_penetration = 75

//* Antimaterial Weapons *//

/obj/item/gun/ballistic/nt_expeditionary/antimaterial
	abstract_type = /obj/item/gun/ballistic/nt_expeditionary/antimaterial
	caliber = /datum/ammo_caliber/nt_expeditionary/antimaterial

/obj/item/gun/ballistic/nt_expeditionary/antimaterial/singleshot
	name = "anti-material rifle"
	desc = "The XNS MK.6 \"Standby\" pump-action shotgun; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A pump-action design based on the proven pump-action mechanism developed centuries ago,
		the XNS Mk.6 or “Standby” is designed around a tube magazine using 12-gauge ammunition.
		Rugged, if not fancy, this weapon is a good fallback option for anyone
		requiring access to a long arm when out on their own or in small groups.
	"} + "<br>"

#warn impl all
