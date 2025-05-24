//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Caliber *//

/datum/ammo_caliber/nt_expedition/light_rifle
	name = "NT-7.5"
	id = "nt-light-rifle"
	caliber = "nt-light-rifle"
	diameter = 7.5
	length = 39

//* Ammo Casings *//

/obj/item/ammo_casing/nt_expedition/light_rifle
	name = "ammo casing (NT-7.5)"
	desc = "A standardized 7.5x39mm cartridge for NT Expeditionary kinetics. This one seems to be for lightweight automatics."
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/rifle-light-ammo.dmi'
	icon_state = "basic"
	icon_spent = TRUE
	casing_caliber = /datum/ammo_caliber/nt_expedition/light_rifle
	projectile_type = /obj/projectile/bullet/nt_expedition/light_rifle

	/// specifically for /obj/item/ammo_magazine/nt_expedition/light_rifle's
	var/speedloader_state = "basic"

/obj/item/ammo_casing/nt_expedition/light_rifle/piercing
	icon_state = "piercing"
	speedloader_state = "piercing"
	// todo: implement casing + magazine

/obj/item/ammo_casing/nt_expedition/light_rifle/rubber
	icon_state = "rubber"
	speedloader_state = "rubber"
	// todo: implement casing + magazine

//* Magazines *//

/obj/item/ammo_magazine/nt_expedition/light_rifle
	name = "ammo magazine (NT-7.5)"
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/rifle-light-ammo.dmi'
	icon_state = "magazine"
	base_icon_state = "magazine"
	rendering_system = GUN_RENDERING_DISABLED
	ammo_caliber = /datum/ammo_caliber/nt_expedition/light_rifle
	ammo_preload = /obj/item/ammo_casing/nt_expedition/light_rifle

/obj/item/ammo_magazine/nt_expedition/light_rifle/speedloader
	name = "speedloader (NT-7.5)"
	icon_state = "speedloader"
	base_icon_state = "speedloader"
	ammo_max = 6

/obj/item/ammo_magazine/nt_expedition/light_rifle/speedloader/update_icon(updates)
	cut_overlays()
	. = ..()
	var/list/overlays_to_add = list()
	var/static/list/pos_x = list(
		2,
		4,
		6,
		1,
		2,
		4,
	)
	var/static/list/pos_y = list(
		-2,
		-4,
		-6,
		-1,
		-2,
		-4
	)
	for(var/i in 1 to min(6, get_amount_remaining()))
		var/obj/item/ammo_casing/nt_expedition/light_rifle/predicted_path = peek_path_of_position(i)
		var/append = "basic"
		if(ispath(predicted_path, /obj/item/ammo_casing/nt_expedition/light_rifle))
			append = initial(predicted_path.speedloader_state)
		var/image/overlay = image(icon, "speedloader-[append]")
		overlay.pixel_x = pos_x[i]
		overlay.pixel_y = pos_y[i]
		overlays_to_add += overlay
	add_overlay(overlays_to_add)

/obj/item/ammo_magazine/nt_expedition/light_rifle/stick
	name = "ammo magazine (NT-7.5)"
	icon_state = "rifle-1"
	base_icon_state = "rifle"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	rendering_static_overlay = "rifle-stripe"
	ammo_max = 16

/obj/item/ammo_magazine/nt_expedition/light_rifle/stick/extended
	name = "extended magazine (NT-7.5)"
	icon_state = "rifle-ext-1"
	base_icon_state = "rifle-ext"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	rendering_static_overlay = "rifle-ext-stripe"
	ammo_max = 24

/obj/item/ammo_magazine/nt_expedition/light_rifle/stick/drum
	name = "drum magazine (NT-7.5)"
	icon_state = "rifle-drum-1"
	base_icon_state = "rifle-drum"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	rendering_static_overlay = "rifle-drum-stripe"
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

/obj/item/gun/projectile/ballistic/nt_expedition/light_rifle/pistol
	name = "high-caliber pistol"
	desc = "The XNP Mk.9 \"David\" revolver; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		An oddball of a revolver, the Mark 9 was made as little more than a proof of concept.
		Chambering 7.5x39mm light rifle ammunition, the "David" sidearm is capable of consistently,
		and accurately (for its uncanny size) punching above its paygrade.
		Unfortunately, the downsides of using such a heavy caliber in a sidearm package limits its
		practical use. This is nonetheless seen now and then in the hands of enthusiasts.
	"} + "<br>"
	internal_magazine = TRUE
	internal_magazine_size = /obj/item/ammo_magazine/nt_expedition/light_rifle/speedloader::ammo_max
	icon_state = "revolver"
	base_icon_state = "revolver"
	render_break_overlay = BALLISTIC_RENDER_BREAK_OPEN

/obj/item/gun/projectile/ballistic/nt_expedition/light_rifle/semirifle
	name = "semi-automatic rifle"
	desc = "The XNR Mk.4 \"Scout\" light rifle; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		The basis of a new family of carbines developed to make use of 7.5x39mm ammunition,
		the “Scout is a traditional pattern of semi-automatic rifle with a mid-length barrel and
		adjustable stock, using a short stroke gas piston to cycle the action.
		The basic design is fitted with a zero magnification optic and comes packaged with
		relatively compact magazines. However, larger magazines will also work with this
		workhorse of a weapon.
	"} + "<br>"
	icon_state = "semi-map"
	base_icon_state = "semi"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/light_rifle/stick

/obj/item/gun/projectile/ballistic/nt_expedition/light_rifle/autorifle
	name = "automatic rifle"
	desc = "The XNR Mk.4 Mod.1 \"Auto Scout\" light rifle; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		The first modification of the Mk.4 carbine, the “Auto Scout” is the next logical step
		of the platform by adding an automatic fire control group. Still using the same short-stroke
		gas piston and featuring a compensator on the end to help control recoil,
		this rifle still sports a zero-magnification optic and adds a short vertical grip as
		standard to the forward handguard. Issued with larger magazines to make better use of
		the automatic fire this weapon is capable of.
	"} + "<br>"
	icon_state = "auto-map"
	base_icon_state = "auto"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/light_rifle/stick

/obj/item/gun/projectile/ballistic/nt_expedition/light_rifle/pdw
	name = "personal defense weapon"
	desc = "The XNR Mk.4 Mod.2 \"Little Scout\" personal defense weapon; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		Taking the concept of the original “Scout” and chopping the barrel, this weapon is lighter,
		more handy, and easier to carry when you need something more than a pistol,
		but a rifle would interfere with other duties. Sticking to the semi-automatic fire
		control of the parent, but chopping the barrel and adding the compensator of the Mod.1,
		this weapon's ability to fold away helps make it easy to package and
		store inside cramped cockpits and into survival kits with its compact magazines.
	"} + "<br>"
	icon_state = "pdw-map"
	base_icon_state = "pdw"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/light_rifle/stick

/obj/item/gun/projectile/ballistic/nt_expedition/light_rifle/lmg
	name = "squad automatic weapon"
	desc = "The XNR Mk.4 Mod.3 \"Machine Scout\" squad automatic weapon; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		The final entry of the “Scout” series, the “Machine Scout” makes use of a heavier barrel,
		a recoil compensating gyro on the bottom of the handguard,
		and the option to feed from larger box and drum magazines, this gives a heavy punch to
		recon teams and security units while keeping a common set of parts
		to reduce the complexities of servicing and maintaining the series as a whole.
	"} + "<br>"
	icon_state = "saw-map"
	base_icon_state = "saw"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	render_bolt_overlay = BALLISTIC_RENDER_BOLT_CLOSE
	render_break_overlay = BALLISTIC_RENDER_BREAK_BOTH
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/light_rifle/stick
