//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Caliber *//

/datum/ammo_caliber/nt_expedition/antimaterial
	name = "NT-12-AM"
	id = "nt-antimaterial"
	caliber = "nt-antimaterial"
	diameter = 12
	length = 92

//* Ammo Casings *//

/obj/item/ammo_casing/nt_expedition/antimaterial
	name = "ammo casing (NT-12.5-antimaterial)"
	desc = "A standardized 12.5x92mm cartridge for NT Expeditionary kinetics. This one seems ridiculously large, and is probably for a very powerful weapon."
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/antimaterial-ammo.dmi'
	icon_state = "basic"
	icon_spent = TRUE
	casing_caliber = /datum/ammo_caliber/nt_expedition/antimaterial
	projectile_type = /obj/projectile/bullet/nt_expedition/antimaterial

	/// specifically for /obj/item/ammo_magazine/nt_expedition/antimaterial's
	///
	/// * null to default to "[base_icon_state || initial(icon_state)]"
	var/magazine_state

/obj/item/ammo_casing/nt_expedition/antimaterial/penetrator
	icon_state = "penetrator"
	// todo: implement casing + magazine

/obj/item/ammo_casing/nt_expedition/antimaterial/emp
	icon_state = "emp"
	// todo: implement casing + magazine

/obj/item/ammo_casing/nt_expedition/antimaterial/explosive
	icon_state = "explosive"
	// todo: implement casing + magazine

/obj/item/ammo_casing/nt_expedition/antimaterial/titanium
	icon_state = "titanium"
	// todo: implement casing + magazine

//* Magazines *//

/obj/item/ammo_magazine/nt_expedition/antimaterial
	name = "ammo magazine (NT-12.5-antimaterial)"
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/antimaterial-ammo.dmi'
	icon_state = "magazine"
	base_icon_state = "magazine"
	ammo_caliber = /datum/ammo_caliber/nt_expedition/antimaterial
	ammo_max = 5
	ammo_preload = /obj/item/ammo_casing/nt_expedition/antimaterial
	magazine_type = MAGAZINE_TYPE_NORMAL

/obj/item/ammo_magazine/nt_expedition/antimaterial/update_icon(updates)
	cut_overlays()
	. = ..()
	var/list/overlays_to_add = list()
	for(var/i in 1 to min(5, get_amount_remaining()))
		var/obj/item/ammo_casing/nt_expedition/antimaterial/casted_path_of_potential = peek_path_of_position(i)
		var/append = "basic"
		if(ispath(casted_path_of_potential, /obj/item/ammo_casing/nt_expedition/antimaterial))
			append = initial(casted_path_of_potential.magazine_state)
		var/image/overlay = image(icon, "magazine-[append]")
		overlay.pixel_x = (i - 1) * -2
		overlay.pixel_y = (i - 1) * 2
		overlays_to_add += overlay
	add_overlay(overlays_to_add)

//* Projectiles *//

/obj/projectile/bullet/nt_expedition/antimaterial
	name = "antimaterial sabot"
	damage_force = 55
	damage_tier = 6

//* Antimaterial Weapons *//

/obj/item/gun/projectile/ballistic/nt_expedition/antimaterial
	abstract_type = /obj/item/gun/projectile/ballistic/nt_expedition/antimaterial
	caliber = /datum/ammo_caliber/nt_expedition/antimaterial
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/antimaterial.dmi'

// todo: placeholder sprite
/obj/item/gun/projectile/ballistic/nt_expedition/antimaterial/singleshot
	name = "anti-material rifle"
	desc = "The XNR Mk.11 \"Immobilizer\" anti-material rifle; a refined design output by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A chemical-propelled knockoff of a prototype Hephaestus Industries anti-armour rifle from the days of the Phoron Wars,
		the XNR Mk.11 "Immobilizer" is an accurate, long-range weapon intended for use on lighter mecha. Unfortunately, its performance
		suffers against heavier armor due to the limitations of using traditional ammunition in such a 'portable' package.
		Regardless, its relative ease of handling (and noted ability to be used by an unaugmented soldier) keeps it in the armories of some
		corporate militaries and emergency responders.
	"} + "<br>"
	icon_state = "rifle"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	magazine_restrict = /obj/item/ammo_magazine/nt_expedition/antimaterial
