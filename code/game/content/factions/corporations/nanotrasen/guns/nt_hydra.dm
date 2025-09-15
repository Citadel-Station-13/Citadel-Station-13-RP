//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/ammo_caliber/microbattery/nt_hydra

/obj/item/gun/projectile/ballistic/microbattery/nt_hydra
	abstract_type = /obj/item/gun/projectile/ballistic/microbattery/nt_hydra
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/nt_hydra.dmi'
	icon_state = "hydra"
	base_icon_state = "hydra"
	// todo: placeholder
	fire_sound = 'sound/weapons/Taser.ogg'

/obj/item/gun/projectile/ballistic/microbattery/nt_hydra/sidearm
	name = "cell-loaded revolver"
	desc = "An experimental revolver that uses microbattery cells instead of conventional kinetic ammunition."
	description_fluff = {"
		The NT-102b 'Hydra' is an experimental ammo-driven energy weapon powered by
		microbatteries. Developed by the Nanotrasen Research Division in an attempt
		to offer security personnel customizable loadouts in the field, this design
		was ultimately sidelined for cost in favor of standard armaments developed
		in joint with Hephaestus Industries. Still, this design remains popular amongst
		many personnel, and is occasionally seen in circulation amongst officers of the ISD.
	"}
	item_renderer = /datum/gun_item_renderer/segments{
		count = 5;
		offset_x = 1;
		use_color = TRUE;
		independent_colored_firemode = TRUE;
	}
	magazine_restrict = /obj/item/ammo_magazine/microbattery/nt_hydra
	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 4, TECH_MAGNETS = 3)

/obj/item/gun/projectile/ballistic/microbattery/nt_hydra/sidearm/prototype
	name = "prototype cell-loaded revolver"
	desc = "An experimental revolver that uses microbattery cells instead of conventional kinetic ammunition. \
		This one is unfortunately a prototype, and cannot use full-sized magazines."
	magazine_restrict = /obj/item/ammo_magazine/microbattery/nt_hydra/prototype

/obj/item/ammo_magazine/microbattery/nt_hydra
	name = "microbattery magazine (NT-Hydra)"
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/nt_hydra.dmi'
	icon_state = "mag"
	ammo_caliber = /datum/ammo_caliber/microbattery/nt_hydra
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_MAGNETS = 2)
	ammo_max = 2

	var/segment_count = 2
	var/segment_x_start = 0
	var/segment_x_offset = 6

/obj/item/ammo_magazine/microbattery/nt_hydra/update_icon()
	cut_overlays()
	. = ..()
	if(segment_count <= 0)
		return
	var/amount = 0
	for(var/obj/item/ammo_casing/microbattery/nt_hydra/microbattery in ammo_internal)
		var/image/segment = image('icons/content/factions/corporations/nanotrasen/items/guns/nt_hydra.dmi', "mag-cap")
		segment.pixel_x = segment_x_start + segment_x_offset * amount
		segment.color = microbattery.stripe_color || microbattery.microbattery_mode_color
		add_overlay(segment)
		var/image/segment_charge = image('icons/content/factions/corporations/nanotrasen/items/guns/nt_hydra.dmi', "mag-charge-[clamp(ceil(microbattery.get_remaining_ratio()), 0, 4) * 4]")
		segment_charge.pixel_x = segment_x_start + segment_x_offset * amount
		segment_charge.color = microbattery.stripe_color || microbattery.microbattery_mode_color
		add_overlay(segment_charge)
		++amount
		if(amount > segment_count)
			break

/obj/item/ammo_magazine/microbattery/nt_hydra/prototype
	name = "prototype microbattery magazine (NT-Hydra)"

/obj/item/ammo_magazine/microbattery/nt_hydra/advanced
	name = "advanced microbattery magazine (NT-Hydra)"
	icon_state = "mag_ext"
	ammo_max = 4

	segment_count = 4
	segment_x_start = 0
	segment_x_offset = 4

/obj/item/ammo_casing/microbattery/nt_hydra
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/nt_hydra.dmi'
	icon_state = "hydracell"
	base_icon_state = "hydracell"
	casing_caliber = /datum/ammo_caliber/microbattery/nt_hydra
	shots_capacity = 4

	var/stripe_color

/obj/item/ammo_casing/microbattery/nt_hydra/Initialize()
	. = ..()
	update_icon()

/obj/item/ammo_casing/microbattery/nt_hydra/update_icon()
	cut_overlays()
	. = ..()
	var/image/stripe = image(icon, "[base_icon_state]-stripe")
	stripe.color = stripe_color || microbattery_mode_color
	add_overlay(stripe)
