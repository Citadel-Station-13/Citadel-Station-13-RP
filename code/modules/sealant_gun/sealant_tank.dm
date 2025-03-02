//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/sealant_tank
	name = "sealant tank"
	desc = "A pressurized tank of space-grade sealant."
	icon = 'icons/modules/sealant_gun/sealant_tank.dmi'
	weight_volume = WEIGHT_VOLUME_SMALL
	w_class = WEIGHT_CLASS_NORMAL

	var/ammo_overlay_amount = 5

	// todo: reagent system; for now, this is just flat numbers.

	var/volume_current = 0
	var/volume_capacity = 360

/obj/item/sealant_tank/Initialize()
	. = ..()
	update_icon()

/obj/item/sealant_tank/update_icon()
	cut_overlays()
	. = ..()
	var/ratio = volume_current / volume_capacity
	add_overlay("[base_icon_state]-[min(ammo_overlay_amount, ceil(ammo_overlay_amount * ratio))]")

/obj/item/sealant_tank/proc/pull_projectile_with_ratio(ratio)
	return pull_projectile_with_volume(clamp(ratio * volume_capacity, 0, volume_capacity))

/obj/item/sealant_tank/proc/pull_projectile_with_volume(volume)
	if(volume_current < volume)
		return null
	. = new /obj/projectile/sealant
	volume_current -= volume
	update_icon()

/obj/item/sealant_tank/proc/push_default_sealant_volume(volume, force)
	if(!force)
		. = min(volume, volume_capacity - volume_current)
		volume_current += .
	else
		. = volume
		volume_current += volume
	update_icon()

// todo: on destruction, explode and release reagent contents.

/obj/item/sealant_tank/loaded
	volume_current = /obj/item/sealant_tank::volume_capacity
