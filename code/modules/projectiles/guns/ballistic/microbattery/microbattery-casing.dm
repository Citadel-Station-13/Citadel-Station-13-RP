/obj/item/ammo_casing/microbattery
	name = "\'NSFW\' microbattery - UNKNOWN"
	desc = "A miniature battery for an energy weapon."
	icon = 'icons/modules/projectiles/legacy/microbattery_old.dmi'
	icon_state = "nsfw_batt"
	slot_flags = SLOT_BELT | SLOT_EARS
	throw_force = 1
	w_class = WEIGHT_CLASS_TINY
	var/shots_left = 4

	leaves_residue = 0
	caliber = /datum/ammo_caliber/microbattery
	var/type_color = null
	var/type_name = null
	projectile_type = /obj/projectile/beam

	casing_primer = CASING_PRIMER_MICROBATTERY

/obj/item/ammo_casing/microbattery/Initialize(mapload)
	. = ..()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
	update_icon()

/obj/item/ammo_casing/microbattery/update_icon()
	cut_overlays()

	var/image/ends = image(icon, icon_state = "[initial(icon_state)]_ends")
	ends.color = type_color
	add_overlay(ends)

/obj/item/ammo_casing/microbattery/expend()
	shots_left--
