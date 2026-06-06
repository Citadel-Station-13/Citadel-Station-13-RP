//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Caliber *//

/datum/ammo_caliber/nt_expedition/light_rifle
	name = "7.5mm LRC"
	id = "nt-light-rifle"
	caliber = "nt-light-rifle"
	diameter = 7.5
	length = 39

//* Ammo Casings *//

/obj/item/ammo_casing/nt_expedition/light_rifle
	name = "ammo casing (7.5mm LRC)"
	desc = "A standardized 7.5x39mm cartridge for NT Expeditionary kinetics."
	description_fluff = "The 7.5mm LRC or Light Rifle Cartridge round was designed by Nanotrasen in collaboration with Hephaestus Industries to fulfill their exploration department's requirement for a rifle cartridge that weighed significantly less than 7.5mm Ares while still retaining sufficient effectiveness against lightly armored targets."
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/rifle-light-ammo.dmi'
	icon_state = "lightrifle_cartridge"
	icon_spent = TRUE
	casing_caliber = /datum/ammo_caliber/nt_expedition/light_rifle
	projectile_type = /obj/projectile/bullet/nt_expedition/light_rifle

	/// specifically for /obj/item/ammo_magazine/nt_expedition/light_rifle's
//	var/speedloader_state = "basic"

///obj/item/ammo_casing/nt_expedition/light_rifle/piercing
//	icon_state = "piercing_cartridge"
//	speedloader_state = "piercing"
	// todo: implement casing + magazine

///obj/item/ammo_casing/nt_expedition/light_rifle/rubber
//	icon_state = "rubber_cartridge"
//	speedloader_state = "rubber"
	// todo: implement casing + magazine

//* Magazines *//

/obj/item/ammo_magazine/nt_expedition/light_rifle
	name = "ammo magazine (7.5mm LRC)"
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/rifle-light.dmi'
	icon_state = "lightrifle_magazine"
	base_icon_state = "lightrifle_magazine"
	weight_volume = ITEM_VOLUME_PISTOL_MAG
	rendering_system = GUN_RENDERING_DISABLED
	ammo_caliber = /datum/ammo_caliber/nt_expedition/light_rifle
	ammo_preload = /obj/item/ammo_casing/nt_expedition/light_rifle

///obj/item/ammo_magazine/nt_expedition/light_rifle/speedloader
//	name = "speedloader (7.5mm LRC)"
//	icon_state = "speedloader"
//	base_icon_state = "speedloader"
//	ammo_max = 6

///obj/item/ammo_magazine/nt_expedition/light_rifle/speedloader/update_icon(updates)
//	cut_overlays()
//	. = ..()
//	var/list/overlays_to_add = list()
//	var/static/list/pos_x = list(
//		2,
//		4,
//		6,
//		1,
//		2,
//		4,
//	)
//	var/static/list/pos_y = list(
//		-2,
//		-4,
//		-6,
//		-1,
//		-2,
//		-4
//	)
//	for(var/i in 1 to min(6, get_amount_remaining()))
//		var/obj/item/ammo_casing/nt_expedition/light_rifle/predicted_path = peek_path_of_position(i)
//		var/append = "basic"
//		if(ispath(predicted_path, /obj/item/ammo_casing/nt_expedition/light_rifle))
//			append = initial(predicted_path.speedloader_state)
//		var/image/overlay = image(icon, "speedloader-[append]")
//		overlay.pixel_x = pos_x[i]
//		overlay.pixel_y = pos_y[i]
//		overlays_to_add += overlay
//	add_overlay(overlays_to_add)

/obj/item/ammo_magazine/nt_expedition/light_rifle/doublestack
	name = "ammo magazine (7.5mm LRC)"
	icon_state = "rifle-1"
	base_icon_state = "rifle"
	weight_volume = ITEM_VOLUME_RIFLE_MAG
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	rendering_static_overlay = "rifle-stripe"
	ammo_max = 16

/obj/item/ammo_magazine/nt_expedition/light_rifle/doublestack/extended
	name = "extended magazine (7.5mm LRC)"
	icon_state = "lightrifle-ext-1"
	base_icon_state = "lightrifle-ext"
	rendering_count = 1
	rendering_static_overlay = "lightrifle-ext-stripe"
	ammo_max = 24

/obj/item/ammo_magazine/nt_expedition/light_rifle/doublestack/drum
	name = "drum magazine (7.5mm LRC)"
	icon_state = "lightrifle-drum-1"
	base_icon_state = "lightrifle-drum"
	rendering_count = 1
	rendering_static_overlay = "lightrifle-drum-stripe"
	ammo_max = 40

//* Projectiles *//

/obj/projectile/bullet/nt_expedition/light_rifle
	name = "rifle bullet"
	damage_force = 32.5
	damage_tier = 4.25

//* Light Rifles *//

/obj/item/gun/projectile/ballistic/nt_expedition/light_rifle
	abstract_type = /obj/item/gun/projectile/ballistic/nt_expedition/light_rifle
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/rifle-light.dmi'
	caliber = /datum/ammo_caliber/nt_expedition/light_rifle

// grumble grumble, rifle cartridge revolvers are actually a terrible idea...
// this also needs a sprite

///obj/item/gun/projectile/ballistic/nt_expedition/light_rifle/revolver
//	name = "high-caliber revolver"
//	desc = "The XNP Mk.13 \"David\" revolver; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
//	description_fluff = {"
//		An oddball of a revolver, the Mark 13 was made as little more than a proof of concept.
//		Chambering 7.5x39mm light rifle ammunition, the "David" sidearm is capable of consistently,
//		and accurately (for its uncanny size) punching above its paygrade.
//		Unfortunately, the downsides of using such a heavy caliber in a sidearm package limits its
//		practical use. This is nonetheless seen now and then in the hands of enthusiasts.
//	"} + "<br>"
//	internal_magazine = TRUE
//	internal_magazine_size = /obj/item/ammo_magazine/nt_expedition/light_rifle/speedloader::ammo_max
//	icon_state = "revolver"
//	base_icon_state = "revolver"
//	render_break_overlay = BALLISTIC_RENDER_BREAK_OPEN
//	w_class = WEIGHT_CLASS_FOR_SIDEARM

/obj/item/gun/projectile/ballistic/nt_expedition/light_rifle/rifle
	name = "semi-automatic rifle"
	desc = "The XNR Mk.2 \"Mallet\" light rifle; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		The baseline to a recent family of rifles developed to make use of Nanotrasen's 7.5mm LRC,
		the \"Mallet\" is a traditional pattern of semi-automatic rifle with 15 inch barrel and
		mid-length direct impingement gas system.
		The basic design is fitted with a 1-1.5x variable optic integrally mounted to the carry handle.
	"} + "<br>"
	icon_state = "semi-map"
	base_icon_state = "semi"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/light_rifle/doublestack
	w_class = WEIGHT_CLASS_FOR_LONG_RIFLE

/obj/item/gun/projectile/ballistic/nt_expedition/light_rifle/autorifle
	name = "automatic rifle"
	desc = "The XNR Mk.2 Mod I \"Mallet\" light rifle; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		The first modification of the Mk.2 rifle, the Mod I is the next logical step
		of the platform by adding an automatic fire control group. Still using the same 15 inch barrel and
		mid-length direct impingement gas system, it comes with a 1x red dot sight and extended handguard that houses
		a suppressor-compatible muzzle device.
	"} + "<br>"
	icon_state = "auto-map"
	base_icon_state = "auto"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/light_rifle/doublestack
	w_class = WEIGHT_CLASS_FOR_LONG_RIFLE

// todo: needs sprite
///obj/item/gun/projectile/ballistic/nt_expedition/light_rifle/carbine
//	name = "semi-automatic carbine"
//	desc = "The XNR Mk.2 Mod II \"Mallet\" light rifle; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
//	description_fluff = {"
//
//	"} + "<br>"
//	icon_state = "lightrifle_pdw-map"
//	base_icon_state = "pdw"
//	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
//	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/light_rifle/doublestack
//	w_class = WEIGHT_CLASS_FOR_SHORT_RIFLE

// todo: needs sprite
///obj/item/gun/projectile/ballistic/nt_expedition/light_rifle/lmg
//	name = "squad automatic weapon"
//	desc = "The XNR Mk.2 Mod III \"Mallet\" squad automatic weapon; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
//	description_fluff = {"
//		A light suppport weapon version of the Mk.2 \"Mallet\" pattern, utilizing a completely reworked upper assembly configured to fire from an open bolt, it features a heavier
//		barrel profile,	piston-operated gas system, quick-change barrel mechanism and aluminum heatsinks. It accepts both linked belts of ammunition
//		and standard magazines and weighs significantly less than most LMGs due to it's rifle-based architecture
//		being relatively 'fragile' by support weapon standards, deemed acceptable due to the expectation of being operated by a single person with short
//		deployments and regular maintenance cycles.
//	"} + "<br>"
//	icon_state = "lightrifle_saw-map"
//	base_icon_state = "lightrifle_saw"
//	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
//	render_bolt_overlay = BALLISTIC_RENDER_BOLT_CLOSE
//	render_break_overlay = BALLISTIC_RENDER_BREAK_BOTH
//	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/light_rifle/doublestack
//	w_class = WEIGHT_CLASS_FOR_LIGHT_MACHINE_GUN
