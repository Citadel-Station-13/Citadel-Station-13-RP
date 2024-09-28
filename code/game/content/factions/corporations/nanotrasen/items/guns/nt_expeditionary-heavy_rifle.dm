//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Caliber *//

/datum/ammo_caliber/nt_expeditionary/heavy_rifle
	caliber = "nt-heavy-rifle"
	diameter = 7.5
	length = 54

//* Ammo Casings *//

/obj/item/ammo_casing/nt_expeditionary/heavy_rifle
	name = "ammo casing (NT-7.5-LR)"
	desc = "A standardized 7.5x54mm cartridge for NT Expeditionary kinetics. This one seems to be for heavy rifles."
	caliber = /datum/ammo_caliber/nt_expeditionary/heavy_rifle
	projectile_type = /obj/projectile/bullet/nt_expeditionary/heavy_rifle

//* Magazines *//

/obj/item/ammo_magazine/nt_expeditionary/heavy_rifle
	name = "ammo magazine (NT-7.5-LR)"
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/rifle-heavy-ammo.dmi'
	icon_state = "magazine"
	base_icon_state = "magazine"
	rendering_system = GUN_RENDERING_DISABLED
	ammo_caliber = /datum/ammo_caliber/nt_expeditionary/heavy_rifle
	ammo_max = 5
	ammo_preload = /obj/item/ammo_casing/nt_expeditionary/heavy_rifle

/obj/item/ammo_magazine/nt_expeditionary/heavy_rifle

/obj/item/ammo_magazine/nt_expeditionary/heavy_rifle/clip/update_icon(updates)

	#warn impl; overlay via "[base_icon_state]-[casing.magazine_state]", shift -2, -2

//* Projectiles *//

/obj/projectile/bullet/nt_expeditionary/heavy_rifle
	name = "heavy rifle bullet"
	damage_force = 40
	damage_tier = LERP(BULLET_TIER_MEDIUM, BULLET_TIER_HIGH, 1)
	armor_penetration = 50

//* Heavy Rifles *//

/obj/item/gun/ballistic/nt_expeditionary/heavy_rifle
	abstract_type = /obj/item/gun/ballistic/nt_expeditionary/heavy_rifle
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/rifle-heavy.dmi'
	caliber = /datum/ammo_caliber/nt_expeditionary/heavy_rifle

#warn sprites

/obj/item/gun/ballistic/nt_expeditionary/heavy_rifle/singleshot
	name = "marksman rifle"
	desc = "The XNR(S) Mk.10 \"Old Man\" marksman rifle; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A single shot, break action rifle chambered in 7.5x54mm, and sporting a 2x magnified optic,
		this is the go-to hunting rifle for long-range patrols.
		Light, uncomplicated, and rugged, the “Old Man” has nothing fancy about it.
		But, time and again, it works, day in, and day out.
	"} + "<br>"

/obj/item/gun/ballistic/nt_expeditionary/heavy_rifle/semirifle
	name = "heavy rifle"
	desc = "The XNR Mk.9 \"Ranger\" heavy rifle; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		Using the Mk.4 “Scout” as a baseline, this semiautomatic rifle is akin to holding a monster,
		disguised in the skin of a dearly beloved friend in your hands.
		Using full-powered rifle rounds (7.5x54mm), this rifle is broken out when you absolutely
		positively have to blow a fist-sized hole in something and don't have time to wait.
		A scaled-up version of the Scout, with box magazines, this long gun is often seen issued
		to hunters looking to take down game to sustain an expedition.
	"} + "<br>"

/obj/item/gun/ballistic/nt_expeditionary/heavy_rifle/autorifle
	name = "heavy automatic rifle"
	desc = "The XNR MK.9 Mod.1 \"Auto Ranger\" heavy rifle; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		“What if we just.. Put a bigger magazine in it and a full auto trigger pack?” is the
		question that led to the development of the “Auto Ranger”, at first.
		Then, after an 'eventful' initial test, a gyroscopic stabilizer was added below
		the handguard and a fixed stock was installed to handle the 'roller coaster' as one test
		participant described the experience. Limiting the rifle
		to burst fire keeps the rifle on target through most situations.
	"} + "<br>"

/obj/item/gun/ballistic/nt_expeditionary/heavy_rifle/lmg
	name = "light machine gun"
	desc = "The XNR Mk.9 Mod.2 \"Hailmaker\" light machine gun; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		The tests of the Mod.2 design quickly turned development towards a
		general purpose machine gun (GPMG) version of the Ranger series, the “Hailmaker.”.
		Sporting a frame-mounted cryo-stabilized heavy barrel, a feed tray for quickly reloading
		via an assistant gunner, a belt box for 100 rounds of 7.5x54mm, and a gyroscopic assist system,
		this weapon is seen in the guard towers of base camps and atop vehicles in addition to
		dedicated machine gun teams. The patter this weapon makes as it suppresses any hostile
		force makes this weapon's name a logical choice.
	"} + "<br>"

#warn impl all
