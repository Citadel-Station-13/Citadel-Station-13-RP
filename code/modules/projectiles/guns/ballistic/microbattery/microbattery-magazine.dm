// todo: /ammo_magazine/microbattery

/obj/item/ammo_magazine/microbattery
	name = "microbattery magazine"
	desc = "A microbattery holder for a cell-based variable weapon."
	icon = 'icons/modules/projectiles/legacy/microbattery_old.dmi'
	icon_state = "cell_mag"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5, TECH_MAGNETS = 3)
	ammo_caliber = /datum/ammo_caliber/microbattery
	ammo_max = 3
	ammo_current = 0
	ammo_legacy_init_everything = TRUE
	var/x_offset = 5  //for update_icon() shenanigans- moved here so it can be adjusted for bigger mags
	var/capname = "nsfw_mag" //as above
	var/chargename = "nsfw_mag" //as above

/obj/item/ammo_magazine/microbattery/why_cant_load_casing(obj/item/ammo_casing/casing)
	if(!istype(casing, /obj/item/ammo_casing/microbattery))
		return "not a microbattery"
	return ..()

/obj/item/ammo_magazine/microbattery/update_icon()
	cut_overlays()
	if(!ammo_internal.len)
		return //Why bother

	var/current = 0
	for(var/B in ammo_internal)
		var/obj/item/ammo_casing/microbattery/batt = B
		var/image/cap = image(icon, icon_state = "[capname]_cap")
		cap.color = batt.type_color
		cap.pixel_x = current * x_offset //Caps don't need a pixel_y offset
		add_overlay(cap)

		if(batt.shots_left)
			var/ratio = CEILING(((batt.shots_left / initial(batt.shots_left)) * 4), 1) //4 is how many lights we have a sprite for
			var/image/charge = image(icon, icon_state = "[chargename]_charge-[ratio]")
			charge.color = "#29EAF4" //Could use battery color but eh.
			charge.pixel_x = current * x_offset
			add_overlay(charge)

		current++ //Increment for offsets

/obj/item/ammo_magazine/microbattery/advanced
	name = "advanced microbattery magazine"
	desc = "A microbattery holder for a cell-based variable weapon. This one has much more cell capacity!"
	ammo_max = 6
	x_offset = 3
	icon_state = "cell_mag_extended"
