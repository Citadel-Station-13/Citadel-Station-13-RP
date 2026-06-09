//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Designs *//

/datum/prototype/design/generated/nt_expedition_ammo/heavy_sidearm
	abstract_type = /datum/prototype/design/generated/nt_expedition_ammo/heavy_sidearm

//* Magazines *//

/obj/item/ammo_magazine/nt_expedition/heavy_sidearm
	name = "ammo magazine (.355 special)"
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/sidearm-heavy.dmi'
	rendering_system = GUN_RENDERING_DISABLED
	ammo_caliber = /datum/ammo_caliber/hephaestus/heavy_sidearm
	ammo_preload = /obj/item/ammo_casing/hephaestus/heavy_sidearm

/obj/item/ammo_magazine/nt_expedition/heavy_sidearm/speedloader
	name = "speedloader (.355 special)"
	icon_state = "speedloader"
	base_icon_state = "speedloader"
	magazine_type = MAGAZINE_TYPE_SPEEDLOADER
	weight_volume = ITEM_VOLUME_PISTOL_MAG
	ammo_max = 6

/obj/item/ammo_magazine/nt_expedition/heavy_sidearm/speedloader/update_icon(updates)
	cut_overlays()
	. = ..()
	var/list/overlays_to_add = list()
	for(var/i in 1 to min(4, get_amount_remaining()))
		var/obj/item/ammo_casing/hephaestus/heavy_sidearm/predicted_path = peek_path_of_position(i)
		var/append = "basic"
		if(ispath(predicted_path, /obj/item/ammo_casing/hephaestus/heavy_sidearm))
			append = initial(predicted_path.speedloader_state)
		var/image/overlay = image(icon, "speedloader-[append]")
		overlay.pixel_x = (i - 1) * 2 - 1
		overlay.pixel_y = (i - 1) * -2 + 1
		overlays_to_add += overlay
	add_overlay(overlays_to_add)

/obj/item/ammo_magazine/nt_expedition/heavy_sidearm/pistol
	name = "pistol magazine (.355 special)"
	icon_state = "magazine-10"
	base_icon_state = "magazine"
	rendering_static_overlay = "magazine-stripe"
	magazine_type = MAGAZINE_TYPE_NORMAL
	weight_volume = ITEM_VOLUME_PISTOL_MAG
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 10
	ammo_max = 10

GENERATE_DESIGN_FOR_AUTOLATHE(/obj/item/ammo_magazine/nt_expedition/heavy_sidearm/smg, /nt_expedition_ammo/heavy_sidearm/smg, "nt-ammo-9mmLR-smg");
/obj/item/ammo_magazine/nt_expedition/heavy_sidearm/smg
	name = "smg magazine (.355 special)"
	icon_state = "smg-1"
	base_icon_state = "smg"
	weight_volume = ITEM_VOLUME_RIFLE_MAG
	rendering_static_overlay = "smg-stripe"
	magazine_type = MAGAZINE_TYPE_NORMAL
	ammo_max = 20
	materials_base = list(
		/datum/prototype/material/steel::id = 500,
		/datum/prototype/material/glass::id = 235,
	)

//* Heavy Sidearms *//

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_sidearm
	abstract_type = /obj/item/gun/projectile/ballistic/nt_expedition/heavy_sidearm
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/sidearm-heavy.dmi'
	caliber = /datum/ammo_caliber/hephaestus/heavy_sidearm

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_sidearm/pistol
	name = "heavy pistol"
	desc = "The XNP Mk.2 \"Ketch\" handgun; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A large handgun chambered in .355 Special, the \"Ketch\" features an integrated light module by default, helping to balance the gun
		at the cost of added weight. It's two-part slide construction is reminiscent of Hephaestus' 10mm handguns, with a long travel length
		on the rear assembly that gives it a very smooth, if somewhat unusual recoil impulse.
	"} + "<br>"
	icon_state = "pistol"
	base_icon_state = "pistol"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/heavy_sidearm/pistol
	w_class = WEIGHT_CLASS_FOR_SIDEARM

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_sidearm/pistol/update_icon_state()
	. = ..()
	if(magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_sidearm/revolver
	name = "heavy revolver"
	desc = "The XNP Mk.4 \"Roller\" revolver; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A sturdy revolver chambered in .355 Special, it has a six-round capacity and was meticulously designed to minimize muzzle flip.
		This weapon is usually seen in the hands of those who prefer the unmatched reliability and
		fine trigger control a double-action revolver provides.
	"} + "<br>"
	internal_magazine = TRUE
	internal_magazine_revolver_mode = TRUE
	chamber_cycle_after_fire = FALSE
	chamber_spin_after_fire = TRUE
	chamber_spin_after_inert = TRUE
	internal_magazine_size = /obj/item/ammo_magazine/nt_expedition/heavy_sidearm/speedloader::ammo_max
	icon_state = "revolver"
	w_class = WEIGHT_CLASS_FOR_SIDEARM
	magazine_insert_sound = 'sound/weapons/guns/interaction/rev_magin.ogg'
	magazine_remove_sound = 'sound/weapons/guns/interaction/rev_magout.ogg'
	chamber_manual_cycle_sound = /datum/soundbyte/guns/ballistic/rack_chamber/revolver

/datum/firemode/nt_expedition_heavy_smg
	abstract_type = /datum/firemode/nt_expedition_heavy_smg

/datum/firemode/nt_expedition_heavy_smg/semi_auto
	name = "semi-auto"

/datum/firemode/nt_expedition_heavy_smg/three_burst
	name = "3-burst"
	burst_amount = 3
	burst_delay = 1.5
	projectile_base_dispersion = 6.5

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_sidearm/smg
	name = "submachine gun"
	desc = "The XNMP Mk.5 \"Auger\" submachine gun; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A rugged submachine gun equipped with a 1x holographic sight. The \"Auger\" extracts every last
		bit of ballistic performance out of .355 Special with it's bullpup configuration, which allows for
		a relatively long barrel despite the gun's overall short length.
	"} + "<br>"
	icon_state = "smg"
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
	w_class = WEIGHT_CLASS_FOR_SHORT_RIFLE

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_sidearm/smg/update_icon_state()
	. = ..()
	if(magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/gun/projectile/ballistic/nt_expedition/heavy_sidearm/smg, /nt_expedition/heavy_smg, "nt-expeditionary-heavy_smg")
/obj/item/gun/projectile/ballistic/nt_expedition/heavy_sidearm/smg/no_pin
	pin = null
