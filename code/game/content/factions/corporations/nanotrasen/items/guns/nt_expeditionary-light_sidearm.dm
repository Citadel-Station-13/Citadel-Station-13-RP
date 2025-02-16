//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Caliber *//

/datum/ammo_caliber/nt_expedition/light_sidearm
	caliber = "nt-light-sidearm"
	diameter = 9
	length = 29

//* Ammo Casings *//

/obj/item/ammo_casing/nt_expedition/light_sidearm
	name = "ammo casing (NT-9)"
	desc = "A standardized 9mm cartridge for NT Expeditionary kinetics. This one seems to be for lightweight pistols and sidearms."
	caliber = /datum/ammo_caliber/nt_expedition/light_sidearm
	projectile_type = /obj/projectile/bullet/nt_expedition/light_sidearm

	/// specifically for /obj/item/ammo_magazine/nt_expedition/light_sidearm's
	var/speedloader_state = "basic"

//* Magazines *//

/obj/item/ammo_magazine/nt_expedition/light_sidearm
	name = "ammo magazine (NT-9)"
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/rifle-heavy-ammo.dmi'
	icon_state = "magazine"
	base_icon_state = "magazine"
	rendering_system = GUN_RENDERING_DISABLED
	ammo_caliber = /datum/ammo_caliber/nt_expedition/light_sidearm
	ammo_max = 5
	ammo_preload = /obj/item/ammo_casing/nt_expedition/light_sidearm

/obj/item/ammo_magazine/nt_expedition/light_sidearm/speedloader
	icon_state = "speedloader"
	base_icon_state = "speedloader"
	ammo_max = 6

/obj/item/ammo_magazine/nt_expedition/light_sidearm/speedloader/update_icon(updates)
	cut_overlays()
	. = ..()
	var/list/overlays_to_add = list()
	// todo: make this look better, this is the lazy locations.
	var/static/list/pos_x = list(
		0,
		1,
		2,
		3,
		4,
		5,
	)
	var/static/list/pos_y = list(
		-0,
		-1,
		-2,
		-3,
		-4,
		-5,
	)
	for(var/i in 1 to min(6, amount_remaining()))
		var/obj/item/ammo_casing/nt_expedition/light_sidearm/predicted_path = peek_path_of_position(i)
		var/append = "basic"
		if(ispath(predicted_path, /obj/item/ammo_casing/nt_expedition/light_sidearm))
			append = initial(predicted_path.speedloader_state)
		var/image/overlay = image(icon, "speedloader-[append]")
		overlay.pixel_x = pos_x[i]
		overlay.pixel_y = pos_y[i]
		overlays_to_add += overlay
	add_overlay(overlays_to_add)

/obj/item/ammo_magazine/nt_expedition/light_sidearm/pistol
	name = "pistol magazine (NT-9)"
	icon_state = "pistol-5"
	base_icon_state = "pistol"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 5
	rendering_static_overlay = "pistol-stripe"
	ammo_max = 8

/obj/item/ammo_magazine/nt_expedition/light_sidearm/smg
	icon_state = "smg-1"
	base_icon_state = "smg"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	rendering_static_overlay = "smg-stripe"
	ammo_max = 24

//* Projectiles *//

/obj/projectile/bullet/nt_expedition/light_sidearm
	name = "bullet"
	damage_force = 35
	damage_tier = LERP(BULLET_TIER_LOW, BULLET_TIER_MEDIUM, 0.25)
	armor_penetration = 10

//* Light Sidearms *//

/obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm
	abstract_type = /obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/sidearm-light.dmi'
	caliber = /datum/ammo_caliber/nt_expedition/light_sidearm

//* Pistol *//

/obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm/pistol
	name = "light pistol"
	desc = "The XNP Mk.1 \"Noisy Moth\" pistol; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A hold-out semiautomatic pistol designed to fit in the pocket and with an easy-to-use
		system of controls, the “Noisy Moth” is chambered in a lengthened version of the classic 9mm,
		packing a little more punch than traditional sidearms in this caliber.
		A small compensator and internal recoil dampeners make the increase in felt recoil negligible,
		while its magazine gives it enough ammunition for those in a pinch to take chance shots.
	"} + "<br>"
	load_method = SINGLE_CASING | MAGAZINE
	icon_state = "pistol-map"
	base_icon_state = "pistol"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC

//* SMG *//

/obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm/smg
	name = "machine pistol"
	desc = "The XNMP Mk.3 \"Buzzer\" machine pistol; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A personal defense weapon with collapsing stock, the “Buzzer” is chambered in 9x29mm.
		A short-barreled weapon easily hung on a belt, and feeding from medium-sized magazines to
		keep it handy, the simple “Buzzer” does tend to make more sound and fury than an effective
		combat weapon, but it will certainly raise the alarm when its shrill report sounds in
		the dead of night.
	"} + "<br>"
	load_method = SINGLE_CASING | MAGAZINE
	icon_state = "smg-map"
	base_icon_state = "smg"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC | MAGAZINE_CLASS_EXTENDED
