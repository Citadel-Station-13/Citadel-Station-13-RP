/obj/item/ammo_casing/microbattery
	icon = 'icons/modules/projectiles/legacy/microbattery_old.dmi'
	icon_state = "nsfw_batt"
	w_class = WEIGHT_CLASS_TINY

/obj/item/ammo_casing/microbattery/update_icon()
	cut_overlays()

	var/image/ends = image(icon, icon_state = "[initial(icon_state)]_ends")
	ends.color = type_color
	add_overlay(ends)
#warn prune
