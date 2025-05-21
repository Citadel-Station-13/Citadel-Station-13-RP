//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Caliber *//

/datum/ammo_caliber/nt_expedition/heavy_rifle
	name = "NT-7.5-LR"
	id = "nt-heavy-rifle"
	caliber = "nt-heavy-rifle"
	diameter = 7.5
	length = 54

//* Ammo Casings *//

/obj/item/ammo_casing/nt_expedition/heavy_rifle
	name = "ammo casing (NT-7.5-LR)"
	desc = "A standardized 7.5x54mm cartridge for NT Expeditionary kinetics. This one seems to be for heavy rifles."
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/rifle-heavy-ammo.dmi'
	icon_state = "basic"
	icon_spent = TRUE
	casing_caliber = /datum/ammo_caliber/nt_expedition/heavy_rifle
	projectile_type = /obj/projectile/bullet/nt_expedition/heavy_rifle

	/// specifically for /obj/item/ammo_magazine/nt_expedition/heavy_rifle's
	var/stripper_state = "basic"

/obj/item/ammo_casing/nt_expedition/heavy_rifle/piercing
	icon_state = "piercing"
	stripper_state = "piercing"
	// todo: implement casing + magazine

/obj/item/ammo_casing/nt_expedition/heavy_rifle/rubber
	icon_state = "rubber"
	stripper_state = "rubber"
	// todo: implement casing + magazine

//* Magazines *//

/obj/item/ammo_magazine/nt_expedition/heavy_rifle
	name = "ammo magazine (NT-7.5-LR)"
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/rifle-heavy-ammo.dmi'
	ammo_caliber = /datum/ammo_caliber/nt_expedition/heavy_rifle
	ammo_preload = /obj/item/ammo_casing/nt_expedition/heavy_rifle

/obj/item/ammo_magazine/nt_expedition/heavy_rifle/stripper_clip
	name = "stripper clip (NT-7.5-LR)"
	icon_state = "stripper"
	base_icon_state = "stripper"
	ammo_max = 6
	magazine_type = MAGAZINE_TYPE_CLIP

/obj/item/ammo_magazine/nt_expedition/heavy_rifle/stripper_clip/update_icon(updates)
	cut_overlays()
	. = ..()
	var/list/overlays_to_add = list()
	for(var/i in 1 to min(5, get_amount_remaining()))
		var/obj/item/ammo_casing/nt_expedition/heavy_rifle/casted_path_of_potential = peek_path_of_position(i)
		var/append = "basic"
		if(ispath(casted_path_of_potential, /obj/item/ammo_casing/nt_expedition/heavy_rifle))
			append = initial(casted_path_of_potential.stripper_state)
		var/image/overlay = image(icon, "stripper-[append]")
		overlay.pixel_x = (i - 1) * -2 - 8
		overlay.pixel_y = (i - 1) * 2 - 8
		overlays_to_add += overlay
	add_overlay(overlays_to_add)

/obj/item/ammo_magazine/nt_expedition/heavy_rifle/stick
	name = "ammo magazine (NT-7.5-LR)"
	icon_state = "mag-basic-0"
	base_icon_state = "mag-basic"
	magazine_type = MAGAZINE_TYPE_NORMAL
	ammo_max = 16

/obj/item/ammo_magazine/nt_expedition/heavy_rifle/stick/extended
	name = "extended magazine (NT-7.5-LR)"
	icon_state = "mag-ext-basic-0"
	base_icon_state = "mag-ext-basic"
	ammo_max = 24

/obj/item/ammo_magazine/nt_expedition/heavy_rifle/stick/drum
	name = "drum magazine (NT-7.5-LR)"
	icon_state = "mag-drum-basic-0"
	base_icon_state = "mag-drum-basic"
	ammo_max = 40

//* Projectiles *//

/obj/projectile/bullet/nt_expedition/heavy_rifle
	name = "heavy rifle bullet"
	damage_force = 32.5
	damage_tier = 4.75

//* Heavy Rifles *//

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_rifle
	abstract_type = /obj/item/gun/projectile/ballistic/nt_expedition/heavy_rifle
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/rifle-heavy.dmi'
	caliber = /datum/ammo_caliber/nt_expedition/heavy_rifle

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_rifle/singleshot
	name = "marksman rifle"
	desc = "The XNR(S) Mk.10 \"Old Man\" marksman rifle; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A single shot, break action rifle chambered in 7.5x54mm, and sporting a 2x magnified optic,
		this is the go-to hunting rifle for long-range patrols.
		Light, uncomplicated, and rugged, the “Old Man” has nothing fancy about it.
		But, time and again, it works, day in, and day out.
	"} + "<br>"
	icon_state = "single"
	base_icon_state = "single"
	item_renderer = /datum/gun_item_renderer/empty_state
	internal_magazine = TRUE
	internal_magazine_size = 1

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_rifle/semirifle
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
	icon_state = "semi"
	base_icon_state = "semi"
	item_renderer = /datum/gun_item_renderer/empty_state
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/heavy_rifle/stick

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_rifle/autorifle
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
	icon_state = "auto-map"
	base_icon_state = "auto"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/heavy_rifle/stick

/obj/item/gun/projectile/ballistic/nt_expedition/heavy_rifle/lmg
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
	icon_state = "lmg"
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/heavy_rifle/stick

	// todo: rendering; how are we going to render both unloaded and open?
	// todo: rendering; maybe expand the render additional to allow for generation of a list?
