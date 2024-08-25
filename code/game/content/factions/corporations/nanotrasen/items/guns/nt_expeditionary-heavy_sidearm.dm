//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Caliber *//

/datum/ammo_caliber/nt_expeditionary/heavy_sidearm
	caliber = "nt-heavy-sidearm"
	diameter = 9
	length = 34

//* Ammo Casings *//

/obj/item/ammo_casing/nt_expeditionary/pistol_heavy
	name = "ammo casing (NT-9-magnum)"
	desc = "A standardized 9mm cartridge for NT Expeditionary kinetics. This one seems to be for heavy-duty sidearms."
	caliber = /datum/ammo_caliber/nt_expeditionary/heavy_sidearm
	projectile_type = /obj/projectile/bullet/nt_expeditionary/pistol_heavy

//* Projectiles *//

/obj/projectile/bullet/nt_expeditionary/pistol_heavy
	name = "heavy bullet"
	damage = 35
	damage_tier = LERP(BULLET_TIER_LOW, BULLET_TIER_MEDIUM, 0.95)
	armor_penetration = 20

//* Heavy Sidearms *//

/obj/item/gun/ballistic/nt_expeditionary/heavy_sidearm
	abstract_type = /obj/item/gun/ballistic/nt_expeditionary/heavy_sidearm
	caliber = /datum/ammo_caliber/nt_expeditionary/heavy_sidearm

#warn sprites

/obj/item/gun/ballistic/nt_expeditionary/heavy_sidearm/pistol
	name = "heavy pistol"
	desc = "The XNP Mk.2 \"Angry Moth\" sidearm; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		Taking the original XNP Mk.1 to the next level, this time upscaling the frame to accept a
		magnum 9x34mm cartridge, the “Angry Moth” sidearm is best described
		as “Shaking hands with danger”. The recoil it imparts will make it hard to forget
		the experience, but the performance on target leaves little to complain about.
		Feeding from medium-sized magazines, this full-sized service pistol is seen when
		fighting is expected and not simply a possibility.
	"} + "<br>"

/obj/item/gun/ballistic/nt_expeditionary/heavy_sidearm/revolver
	name = "heavy revolver"
	desc = "The XNP Mk.5 \"Roller\" revolver; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		Something of a pet project of one member of the XN design team, the “Roller” harkens back
		to the revolvers of old, but chambered in the magnum 9x34mm cartridge.
		Sporting a medium-capacity cylinder and an inline barrel design to reduce muzzle flip,
		this weapon is seen in the hands of those who prefer style over functionality or want
		the fine trigger control a triple-action revolver provides.
	"} + "<br>"

/obj/item/gun/ballistic/nt_expeditionary/heavy_sidearm/smg
	name = "submachine gun"
	desc = "The XNMP Mk.8 \"Buzzsaw\" submachine gun; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		Taking design notes from the Mk.3 “Buzzer, the “Buzzsaw” sports a longer barrel,
		a thicker receiver, and a folding stock typically seen on rifles.
		Using the magnum 9x34mm round in long-form magazines, the “Buzzsaw”'s high rate of fire and
		punchy ammunition makes its unique sound hard to mistake when seen clearing rooms or
		in dense jungle foliage, where the high-velocity rounds batter aside light cover
		with relative ease.
	"} + "<br>"

#warn impl all
