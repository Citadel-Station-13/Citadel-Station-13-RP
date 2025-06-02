//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Caliber *//

/datum/ammo_caliber/nt_expedition/heavy_sidearm
	name = "NT-9-LR"
	id = "nt-heavy-sidearm"
	caliber = "nt-heavy-sidearm"
	diameter = 9
	length = 34

//* Designs *//

/datum/prototype/design/generated/nt_expedition_ammo/heavy_sidearm
	abstract_type = /datum/prototype/design/generated/nt_expedition_ammo/heavy_sidearm

//* Ammo Casings *//

/obj/item/ammo_casing/nt_expedition/heavy_sidearm
	name = "ammo casing (NT-9-LR)"
	desc = "A standardized 9mm cartridge for NT Expeditionary kinetics. This one seems to be for heavy-duty sidearms."
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/sidearm-heavy-ammo.dmi'
	icon_state = "basic"
	icon_spent = TRUE
	casing_caliber = /datum/ammo_caliber/nt_expedition/heavy_sidearm
	projectile_type = /obj/projectile/bullet/nt_expedition/heavy_sidearm

	materials_base = list(
		/datum/prototype/material/steel::id = 85,
	)

	/// specifically for /obj/item/ammo_magazine/nt_expedition/heavy_rifle's
	var/speedloader_state = "basic"

// todo: implement projectile + magazine
// /obj/item/ammo_casing/nt_expedition/heavy_sidearm/piercing
// 	icon_state = "piercing"
// 	speedloader_state = "piercing"

// todo: implement projectile + magazine
// /obj/item/ammo_casing/nt_expedition/heavy_sidearm/rubber
// 	icon_state = "rubber"
// 	speedloader_state = "rubber"

//* Magazines *//

/obj/item/ammo_magazine/nt_expedition/heavy_sidearm
	name = "ammo magazine (NT-9-LR)"
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/sidearm-heavy-ammo.dmi'
	rendering_system = GUN_RENDERING_DISABLED
	ammo_caliber = /datum/ammo_caliber/nt_expedition/heavy_sidearm
	ammo_preload = /obj/item/ammo_casing/nt_expedition/heavy_sidearm

/obj/item/ammo_magazine/nt_expedition/heavy_sidearm/speedloader
	name = "speedloader (NT-9-LR)"
	icon_state = "speedloader"
	base_icon_state = "speedloader"
	magazine_type = MAGAZINE_TYPE_SPEEDLOADER
	ammo_max = 6

/obj/item/ammo_magazine/nt_expedition/heavy_sidearm/speedloader/update_icon(updates)
	cut_overlays()
	. = ..()
	var/list/overlays_to_add = list()
	for(var/i in 1 to min(4, get_amount_remaining()))
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
	ammo_max = 10

GENERATE_DESIGN_FOR_AUTOLATHE(/obj/item/ammo_magazine/nt_expedition/heavy_sidearm/smg, /nt_expedition_ammo/heavy_sidearm/smg, "nt-ammo-9mmLR-smg");
/obj/item/ammo_magazine/nt_expedition/heavy_sidearm/smg
	name = "smg magazine (NT-9-LR)"
	icon_state = "smg-1"
	base_icon_state = "smg"
	rendering_static_overlay = "smg-stripe"
	magazine_type = MAGAZINE_TYPE_NORMAL
	ammo_max = 20
	materials_base = list(
		/datum/prototype/material/steel::id = 500,
		/datum/prototype/material/glass::id = 235,
	)

//* Projectiles *//

/obj/projectile/bullet/nt_expedition/heavy_sidearm
	name = "heavy bullet"
	damage_force = 30
	damage_tier = 3.75

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
	icon_state = "pistol-map"
	base_icon_state = "pistol"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/heavy_sidearm/pistol

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
	internal_magazine = TRUE
	internal_magazine_size = /obj/item/ammo_magazine/nt_expedition/heavy_sidearm/speedloader::ammo_max
	icon_state = "revolver"

/datum/firemode/nt_expedition_heavy_smg
	abstract_type = /datum/firemode/nt_expedition_heavy_smg

/datum/firemode/nt_expedition_heavy_smg/semi_auto
	name = "semi-auto"

/datum/firemode/nt_expedition_heavy_smg/three_burst
	name = "3-burst"
	burst_amount = 3
	burst_delay = 1.5
	projectile_base_dispersion = 7.5

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
	icon_state = "smg-map"
	base_icon_state = "smg"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/heavy_sidearm/smg
	materials_base = list(
		/datum/prototype/material/steel::id = 3200,
		/datum/prototype/material/glass::id = 1450,
		/datum/prototype/material/gold::id = 350,
		/datum/prototype/material/silver::id = 850,
		/datum/prototype/material/lead::id = 1000,
		/datum/prototype/material/copper::id = 500,
	)
	firemodes = list(
		/datum/firemode/nt_expedition_heavy_smg/semi_auto,
		/datum/firemode/nt_expedition_heavy_smg/three_burst,
	)

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/gun/projectile/ballistic/nt_expedition/heavy_sidearm/smg, /nt_expedition/heavy_smg, "nt-expeditionary-heavy_smg")
/obj/item/gun/projectile/ballistic/nt_expedition/heavy_sidearm/smg/no_pin
	pin = null
