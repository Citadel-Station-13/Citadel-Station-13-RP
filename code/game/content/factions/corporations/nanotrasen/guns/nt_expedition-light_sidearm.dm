//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Designs *//

/datum/prototype/design/generated/nt_expedition_ammo/light_sidearm
	abstract_type = /datum/prototype/design/generated/nt_expedition_ammo/light_sidearm

//* Magazines *//

/obj/item/ammo_magazine/nt_expedition/light_sidearm
	name = "ammo magazine (.355 Auto)"
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/sidearm-light.dmi'
	icon_state = "magazine"
	base_icon_state = "magazine"
	rendering_system = GUN_RENDERING_DISABLED
	ammo_caliber = /datum/ammo_caliber/hephaestus/light_sidearm
	ammo_preload = /obj/item/ammo_casing/hephaestus/light_sidearm

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
	for(var/i in 1 to min(6, get_amount_remaining()))
		var/obj/item/ammo_casing/hephaestus/light_sidearm/predicted_path = peek_path_of_position(i)
		var/append = "basic"
		if(ispath(predicted_path, /obj/item/ammo_casing/hephaestus/light_sidearm))
			append = initial(predicted_path.speedloader_state)
		var/image/overlay = image(icon, "speedloader-[append]")
		overlay.pixel_x = pos_x[i]
		overlay.pixel_y = pos_y[i]
		overlays_to_add += overlay
	add_overlay(overlays_to_add)

/obj/item/ammo_magazine/nt_expedition/light_sidearm/pistol
	name = "pistol magazine (.355 Auto)"
	icon_state = "pistol-5"
	base_icon_state = "pistol"
	rendering_system = GUN_RENDERING_STATES
	weight_volume = ITEM_VOLUME_PISTOL_MAG
	rendering_count = 5
	rendering_static_overlay = "pistol-stripe"
	ammo_max = 14

GENERATE_DESIGN_FOR_AUTOLATHE(/obj/item/ammo_magazine/nt_expedition/light_sidearm/smg, /nt_expedition_ammo/light_sidearm/smg, "nt-ammo-9mm-smg");
/obj/item/ammo_magazine/nt_expedition/light_sidearm/smg
	name = "smg magazine (.355 Auto)"
	icon_state = "smg-1"
	base_icon_state = "smg"
	weight_volume = ITEM_VOLUME_RIFLE_MAG
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	rendering_static_overlay = "smg-stripe"
	ammo_max = 28
	materials_base = list(
		/datum/prototype/material/steel::id = 325,
		/datum/prototype/material/glass::id = 125,
	)

//* Light Sidearms *//

/obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm
	abstract_type = /obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/sidearm-light.dmi'
	caliber = /datum/ammo_caliber/hephaestus/light_sidearm

//* Pistol *//

/obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm/pistol
	name = "light pistol"
	desc = "The XNP Mk.1 \"Chisel\" pistol; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A semi-compact semiautomatic pistol designed to fit in the pocket, the \"Chisel\" was designed in the late 2560s alongside Hephaestus Industries after
		the failure of Nanotrasen's internal AXHS program left their exploration department without a suitable ballistic handgun. In comparison to it's predecessor,
		the new design is much streamlined, chambered for Hephaestus' .355 Auto caliber, and devoid of unecessary features, making it exceptionally handy.
	"} + "<br>"
	icon_state = "pistol-map"
	base_icon_state = "pistol"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/light_sidearm/pistol
	w_class = WEIGHT_CLASS_FOR_SIDEARM

//* SMG *//

/datum/firemode/nt_expedition_light_smg
	abstract_type = /datum/firemode/nt_expedition_light_smg

/datum/firemode/nt_expedition_light_smg/semi_auto
	name = "semi-auto"

/datum/firemode/nt_expedition_light_smg/two_burst
	name = "2-burst"
	burst_amount = 2
	burst_delay = 1.5
	projectile_base_dispersion = 5.75

/obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm/smg
	name = "machine pistol"
	desc = "The XNP Mk.3 \"Sawtooth\" machine pistol; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A highly-portable machine pistol with a collapsible stock and folding vertical grip, the \"Sawtooth\" is chambered in .355 Auto. The
		standard exploration model does not feature a fully automatic firemode to prevent excessive ammo consumption due to the very fast cyclic rate.
	"} + "<br>"
	icon_state = "smg-map"
	base_icon_state = "smg"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC | MAGAZINE_CLASS_EXTENDED
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/light_sidearm/smg
	materials_base = list(
		/datum/prototype/material/steel::id = 2500,
		/datum/prototype/material/glass::id = 1250,
		/datum/prototype/material/gold::id = 250,
		/datum/prototype/material/silver::id = 750,
		/datum/prototype/material/lead::id = 700,
		/datum/prototype/material/copper::id = 400,
	)
	firemodes = list(
		/datum/firemode/nt_expedition_light_smg/semi_auto,
		/datum/firemode/nt_expedition_light_smg/two_burst,
	)
	w_class = WEIGHT_CLASS_FOR_SHORT_RIFLE

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm/smg/no_pin, /nt_expedition/light_smg, "nt-expeditionary-light_smg")
/obj/item/gun/projectile/ballistic/nt_expedition/light_sidearm/smg/no_pin
	pin = null
