//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Magazines *//

/obj/item/ammo_magazine/nt_expedition/heavy_rifle
	name = "ammo magazine (7.5mm ares)"
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/rifle-heavy.dmi'
	ammo_caliber = /datum/ammo_caliber/hephaestus/heavy_rifle
	ammo_preload = /obj/item/ammo_casing/hephaestus/heavy_rifle

// todo: needs sprites
///obj/item/ammo_magazine/nt_expedition/heavy_rifle/stripper_clip
//	name = "stripper clip (7.5mm Ares)"
//	icon_state = "stripper"
//	base_icon_state = "stripper"
//	ammo_max = 6
//	weight_volume = ITEM_VOLUME_PISTOL_MAG
//	magazine_type = MAGAZINE_TYPE_CLIP

///obj/item/ammo_magazine/nt_expedition/heavy_rifle/stripper_clip/update_icon(updates)
//	cut_overlays()
//	. = ..()
//	var/list/overlays_to_add = list()
//	for(var/i in 1 to min(5, get_amount_remaining()))
//		var/obj/item/ammo_casing/hephaestus/heavy_rifle/casted_path_of_potential = peek_path_of_position(i)
//		var/append = "basic"
//		if(ispath(casted_path_of_potential, /obj/item/ammo_casing/hephaestus/heavy_rifle))
//			append = initial(casted_path_of_potential.stripper_state)
//		var/image/overlay = image(icon, "stripper-[append]")
//		overlay.pixel_x = (i - 1) * -2 - 8
//		overlay.pixel_y = (i - 1) * 2 - 8
//		overlays_to_add += overlay
//	add_overlay(overlays_to_add)

/obj/item/ammo_magazine/nt_expedition/heavy_rifle/doublestack
	name = "ammo magazine (7.5mm ares)"
	icon_state = "mag-basic-1"
	base_icon_state = "mag-basic"
	weight_volume = ITEM_VOLUME_RIFLE_MAG
	magazine_type = MAGAZINE_TYPE_NORMAL
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	ammo_max = 16

/obj/item/ammo_magazine/nt_expedition/heavy_rifle/doublestack/extended
	name = "extended magazine (7.5mm ares)"
	icon_state = "mag-ext-basic-1"
	base_icon_state = "mag-ext-basic"
	ammo_max = 24

/obj/item/ammo_magazine/nt_expedition/heavy_rifle/doublestack/drum
	name = "drum magazine (7.5mm ares)"
	icon_state = "mag-drum-basic-1"
	base_icon_state = "mag-drum-basic"
	ammo_max = 40

//* Heavy Rifles *//

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_rifle
	abstract_type = /obj/item/gun/projectile/ballistic/nt_expedition/heavy_rifle
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/rifle-heavy.dmi'
	caliber = /datum/ammo_caliber/hephaestus/heavy_rifle

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_rifle/singleshot
	name = "break-action rifle"
	desc = "The XNR Mk.3 \"Huntsman\" break-action rifle; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A single shot rifle chambered in 7.5mm Ares, equipped with a 2x magnified optic,
		this is a light, uncomplicated design for low-stakes applications where rapid follow-up shots are not needed.
		It's greatest strength is the sheer reliability of the action: There is very little there that can go wrong.
	"} + "<br>"
	icon_state = "singleshot"
	base_icon_state = "singleshot"
	internal_magazine = TRUE
	internal_magazine_size = 1
	w_class = WEIGHT_CLASS_FOR_LONG_RIFLE
	chamber_simulation = TRUE
	chamber_cycle_after_fire = FALSE
	bolt_simulation = TRUE
	bolt_auto_eject_on_open = TRUE
	var/icon_retracted = "singleshot-empty"

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_rifle/singleshot/update_icon_state()
	icon_state = bolt_closed ? initial(icon_state) : icon_retracted
	return ..()

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_rifle/semirifle
	name = "heavy rifle"
	desc = "The NT-D9 \"Sentinel\" heavy rifle; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		Utilizing the NT-D3 \"Scout\" as a baseline, this semi-automatic rifle is chambered in the full-powered 7.5mm Ares cartridge and
		comes equipped with an enclosed 1x red dot sight.
		Introduced late into the Phoron Wars as a streamlined, improved version of the Scout, it was Nanotrasen's latest attempt at
		leveraging the power 7.5mm Ares, as it was capable of taking down most of the Syndicate's armored hardsuits with enough volume of fire.
	"} + "<br>"
	icon_state = "semi"
	base_icon_state = "semi"
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/heavy_rifle/doublestack
	w_class = WEIGHT_CLASS_FOR_LONG_RIFLE

/datum/firemode/nt_expedition_heavy_autorifle
	abstract_type = /datum/firemode/nt_expedition_heavy_autorifle

/datum/firemode/nt_expedition_heavy_autorifle/semi_auto
	name = "semi-auto"

/datum/firemode/nt_expedition_heavy_autorifle/three_burst
	name = "3-burst"
	burst_amount = 3
	burst_delay = 1.5
	projectile_base_dispersion = 4.5

/datum/firemode/nt_expedition_heavy_autorifle/automatic
	name = "automatic"
	burst_amount = 1
	burst_delay = 0
	cycle_cooldown = 0.2
	projectile_base_dispersion = 6.5

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_rifle/autorifle
	name = "heavy automatic rifle"
	desc = "The NT-D9 Mod I \"Sentinel\" heavy rifle; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		Building upon the D9's strengths, this automatic rifle is chambered in the full-powered 7.5mm Ares cartridge and
		comes equipped with a wide-FOV 1x reflex sight, heavy muzzle break, vertical grip and lightweight stock.
		Introduced in the final years of the Phoron Wars as an update to the Mk.9 pattern, this was Nanotrasen's finest attempt at
		leveraging the power 7.5mm Ares, as it was capable of taking down most of the Syndicate's armored hardsuits with enough volume of fire.
		Although the fully automatic setting was still useful in some situations, the Mod I's three-round burst proved to be the most effective
		way to deliver shots at range.
	"} + "<br>"
	icon_state = "auto"
	base_icon_state = "auto"
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/heavy_rifle/doublestack
	w_class = WEIGHT_CLASS_FOR_LONG_RIFLE
	firemodes = list(
		/datum/firemode/nt_expedition_heavy_autorifle/semi_auto,
		/datum/firemode/nt_expedition_heavy_autorifle/three_burst,
		/datum/firemode/nt_expedition_heavy_autorifle/automatic,
	)

// todo: needs sprite
///obj/item/gun/projectile/ballistic/nt_expedition/heavy_rifle/lmg
//	name = "light machine gun"
//	desc = "The NT-G7  \"Nemesis\" light machine gun; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
//	description_fluff = {"
//
//	"} + "<br>"
//	icon_state = "lmg"
//	// todo: box mag
//	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/heavy_rifle/doublestack/drum
//	w_class = WEIGHT_CLASS_FOR_LIGHT_MACHINE_GUN

	// todo: rendering; how are we going to render both unloaded and open?
	// todo: rendering; maybe expand the render additional to allow for generation of a list?
