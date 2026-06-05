//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Magazines *//

/obj/item/ammo_magazine/nt_expedition/antimateriel
	name = "ammo magazine (.50 Arc)"
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/antimateriel.dmi'
	icon_state = "antimateriel"
	base_icon_state = "antimateriel"
	ammo_caliber = /datum/ammo_caliber/hephaestus/antimateriel
	ammo_max = 5
	ammo_preload = /obj/item/ammo_casing/hephaestus/antimateriel
	weight_volume = ITEM_VOLUME_RIFLE_MAG
	magazine_type = MAGAZINE_TYPE_NORMAL

/obj/item/ammo_magazine/nt_expedition/antimateriel/update_icon(updates)
	cut_overlays()
	. = ..()
	var/list/overlays_to_add = list()
	for(var/i in 1 to min(5, get_amount_remaining()))
		var/obj/item/ammo_casing/hephaestus/antimateriel/casted_path_of_potential = peek_path_of_position(i)
		var/append = "basic"
		if(ispath(casted_path_of_potential, /obj/item/ammo_casing/hephaestus/antimateriel))
			append = initial(casted_path_of_potential.magazine_state)
		var/image/overlay = image(icon, "magazine-[append]")
		overlay.pixel_x = (i - 1) * -2
		overlay.pixel_y = (i - 1) * 2
		overlays_to_add += overlay
	add_overlay(overlays_to_add)

//* antimateriel Weapons *//

/obj/item/gun/projectile/ballistic/nt_expedition/antimateriel
	abstract_type = /obj/item/gun/projectile/ballistic/nt_expedition/antimateriel
	caliber = /datum/ammo_caliber/nt_expedition/antimateriel
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/expeditionary/antimateriel.dmi'

// todo: placeholder sprite
/obj/item/gun/projectile/ballistic/nt_expedition/antimateriel/rifle
	name = "anti-materiel rifle"
	desc = "The NT-F7 \"Immobilizer\" anti-materiel rifle; Designed by the Nanotrasen Research Division in conjunction with Hephaestus Industries."
	description_fluff = {"
		A downscaled version of Hephaestus Industries' \"Boltcaster\" anti-armour rifle from the days of the Phoron Wars,
		the NT-F7 \"Immobilizer\" is an accurate, long-range weapon intended for use on light mechs. Unfortunately, its performance
		suffers against heavy armor due to the limitations of using traditional ammunition in such a 'portable' package.
		Regardless, its relative ease of handling (and ability to be used by an unaugmented soldier) keeps it in the armories of some
		corporate militaries and emergency responders.
	"} + "<br>"
	icon_state = "antimateriel_rifle"
	render_magazine_overlay = MAGAZINE_CLASS_GENERIC
	magazine_restrict = /obj/item/ammo_magazine/hephaestus/antimateriel
