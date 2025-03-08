//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/ammo_caliber/microbattery/vm_aml

/obj/item/gun/projectile/ballistic/microbattery/vm_aml
	abstract_type = /obj/item/gun/projectile/ballistic/microbattery/vm_aml
	icon = 'icons/content/factions/corporations/veymed/items/guns/vm_aml.dmi'
	icon_state = "sidearm"
	base_icon_state = "sidearm"
	// todo: placeholder
	fire_sound = 'sound/weapons/Taser.ogg'

/obj/item/gun/projectile/ballistic/microbattery/vm_aml/sidearm
	name = "cell-loaded medigun"
	desc = "An experimental medigun fueled by nanite microbatteries."
	description_fluff = {"
		The Vey-Med Adaptive Medical Laser is an experimental medical device used
		for the ranged delivery of medical nanomachines.
		Developed in joint with the Nanotrasen Research Division - whom provided their expertise with
		particle physics and nanotechnology delivery mechanisms - this tool was the
		expensive, and perhaps niche culmination of multiple attempts at providing
		high-end emergency responders an option to use if triage is needed at a distance.
	"}
	item_renderer = /datum/gun_item_renderer/segments{
		count = 5;
		offset_x = 1;
		use_color = TRUE;
		independent_colored_firemode = TRUE;
	}
	magazine_restrict = /obj/item/ammo_magazine/microbattery/vm_aml
	no_pin_required = TRUE

/obj/item/gun/projectile/ballistic/microbattery/vm_aml/sidearm/advanced
	name = "advanced cell-loaded medigun"
	desc = "An experimental medigun fueled by nanite microbatteries. This one is an upgraded design."
	icon_state = "sidearm_cmo"
	base_icon_state = "sidearm_cmo"

/obj/item/ammo_magazine/microbattery/vm_aml
	icon = 'icons/content/factions/corporations/veymed/items/guns/vm_aml.dmi'
	icon_state = "mag"
	ammo_caliber = /datum/ammo_caliber/microbattery/vm_aml
	ammo_max = 3

	var/segment_count = 3
	var/segment_x_start = 0
	var/segment_x_offset = 5

/obj/item/ammo_magazine/microbattery/vm_aml/update_icon()
	cut_overlays()
	. = ..()
	if(segment_count <= 0)
		return
	var/amount = 0
	for(var/obj/item/ammo_casing/microbattery/vm_aml/microbattery in ammo_internal)
		var/image/segment = image('icons/content/factions/corporations/veymed/items/guns/vm_aml.dmi', "mag-cap")
		segment.pixel_x = segment_x_start + segment_x_offset * amount
		segment.color = microbattery.stripe_color || microbattery.microbattery_mode_color
		add_overlay(segment)
		var/image/segment_charge = image('icons/content/factions/corporations/veymed/items/guns/vm_aml.dmi', "mag-charge-[clamp(ceil(microbattery.get_remaining_ratio()), 0, 4) * 4]")
		segment_charge.pixel_x = segment_x_start + segment_x_offset * amount
		segment_charge.color = microbattery.stripe_color || microbattery.microbattery_mode_color
		add_overlay(segment_charge)
		++amount
		if(amount > segment_count)
			break

/obj/item/ammo_magazine/microbattery/vm_aml/sidearm/advanced
	icon_state = "mag_ext"
	ammo_max = 6

	segment_count = 6
	segment_x_start = 0
	segment_x_offset = 3

/obj/item/ammo_casing/microbattery/vm_aml
	icon = 'icons/content/factions/corporations/veymed/items/guns/vm_aml.dmi'
	icon_state = "medicell"
	base_icon_state = "medicell"
	casing_caliber = /datum/ammo_caliber/microbattery/vm_aml
	shots_capacity = 4

	var/stripe_color

/obj/item/ammo_casing/microbattery/vm_aml/Initialize()
	. = ..()
	update_icon()

/obj/item/ammo_casing/microbattery/vm_aml/update_icon()
	cut_overlays()
	. = ..()
	var/image/stripe = image(icon, "[base_icon_state]-stripe")
	stripe.color = stripe_color || microbattery_mode_color
	add_overlay(stripe)
