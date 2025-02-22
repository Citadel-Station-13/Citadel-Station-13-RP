//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Caliber *//

/datum/ammo_caliber/nt_expedition/heavy_sidearm
	caliber = "nt-heavy-sidearm"
	diameter = 9
	length = 34

//* Ammo Casings *//

/obj/item/ammo_casing/nt_expedition/heavy_sidearm
	name = "ammo casing (NT-9-magnum)"
	desc = "A standardized 9mm cartridge for NT Expeditionary kinetics. This one seems to be for heavy-duty sidearms."
	caliber = /datum/ammo_caliber/nt_expedition/heavy_sidearm
	projectile_type = /obj/projectile/bullet/nt_expedition/heavy_sidearm

	/// specifically for /obj/item/ammo_magazine/nt_expedition/heavy_rifle's
	var/speedloader_state = "basic"

/obj/item/ammo_casing/nt_expedition/heavy_sidearm/piercing
	icon_state = "piercing"
	speedloader_state = "piercing"
	// todo: implement casing + magazine

/obj/item/ammo_casing/nt_expedition/heavy_sidearm/rubber
	icon_state = "rubber"
	speedloader_state = "rubber"
	// todo: implement casing + magazine

//* Magazines *//

/obj/item/ammo_magazine/nt_expedition/heavy_sidearm
	name = "ammo magazine (NT-9-LR)"
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/sidearm-heavy-ammo.dmi'
	rendering_system = GUN_RENDERING_DISABLED
	ammo_caliber = /datum/ammo_caliber/nt_expedition/heavy_sidearm
	ammo_max = 5
	ammo_preload = /obj/item/ammo_casing/nt_expedition/heavy_sidearm

/obj/item/ammo_magazine/nt_expedition/heavy_sidearm/speedloader
	name = "speedloader (NT-9-LR)"
	icon_state = "speedloader"
	base_icon_state = "speedloader"
	magazine_type = MAGAZINE_TYPE_SPEEDLOADER

/obj/item/ammo_magazine/nt_expedition/heavy_sidearm/speedloader/update_icon(updates)
	cut_overlays()
	. = ..()
	var/list/overlays_to_add = list()
	for(var/i in 1 to min(4, amount_remaining()))
		var/obj/item/ammo_casing/nt_expedition/heavy_sidearm/predicted_path = peek_path_of_position(i)
		var/append = "basic"
		if(ispath(predicted_path, /obj/item/ammo_casing/nt_expedition/heavy_sidearm))
			append = initial(predicted_path.speedloader_state)
		var/image/overlay = image(icon, "speedloader-[append]")
		overlay.pixel_x = (i - 1) * 2 - 1
		overlay.pixel_y = (i - 1) * -2 + 1
		overlays_to_add += overlay
	add_overlay(overlays_to_add)

/obj/item/ammo_magazine/nt_expedition/heavy_sidearm/pistol
	name = "pistol magazine (NT-9-LR)"
	icon_state = "magazine-5"
	base_icon_state = "magazine"
	rendering_static_overlay = "magazine-stripe"
	magazine_type = MAGAZINE_TYPE_NORMAL

/obj/item/ammo_magazine/nt_expedition/heavy_sidearm/smg
	name = "smg magazine (NT-9-LR)"
	icon_state = "smg-1"
	base_icon_state = "smg"
	rendering_static_overlay = "smg-stripe"
	magazine_type = MAGAZINE_TYPE_NORMAL

//* Projectiles *//

/obj/projectile/bullet/nt_expedition/heavy_sidearm
	name = "heavy bullet"
	damage_force = 35
	damage_tier = LERP(BULLET_TIER_LOW, BULLET_TIER_MEDIUM, 0.95)
	armor_penetration = 20

//* Heavy Sidearms *//

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_sidearm
	abstract_type = /obj/item/gun/projectile/ballistic/nt_expedition/heavy_sidearm
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/sidearm-heavy.dmi'
	caliber = /datum/ammo_caliber/nt_expedition/heavy_sidearm

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_sidearm/pistol
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
	load_method = SINGLE_CASING | MAGAZINE
	icon_state = "pistol-map"
	base_icon_state = "pistol"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_sidearm/revolver
	name = "heavy revolver"
	desc = "The XNP Mk.5 \"Roller\" revolver; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		Something of a pet project of one member of the XN design team, the “Roller” harkens back
		to the revolvers of old, but chambered in the magnum 9x34mm cartridge.
		Sporting a medium-capacity cylinder and an inline barrel design to reduce muzzle flip,
		this weapon is seen in the hands of those who prefer style over functionality or want
		the fine trigger control a triple-action revolver provides.
	"} + "<br>"
	load_method = SINGLE_CASING | SPEEDLOADER
	icon_state = "revolver"

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_sidearm/smg
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
	load_method = SINGLE_CASING | MAGAZINE
	icon_state = "smg-map"
	base_icon_state = "smg"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
