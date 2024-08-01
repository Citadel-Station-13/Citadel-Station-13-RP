// todo: /ammo_magazine/microbattery

/obj/item/ammo_magazine/cell_mag
	name = "microbattery magazine"
	desc = "A microbattery holder for a cell-based variable weapon."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "cell_mag"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5, TECH_MAGNETS = 3)
	caliber = "nsfw"
	ammo_type = /obj/item/ammo_casing/microbattery
	initial_ammo = 0
	ammo_max = 3
	var/x_offset = 5  //for update_icon() shenanigans- moved here so it can be adjusted for bigger mags
	var/capname = "nsfw_mag" //as above
	var/chargename = "nsfw_mag" //as above
	mag_type = MAGAZINE

	var/list/modes = list()

/obj/item/ammo_magazine/cell_mag/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/ammo_casing/microbattery))
		var/obj/item/ammo_casing/microbattery/B = W
		if(!istype(B, ammo_type))
			to_chat(user, "<span class='warning'>[B] does not fit into [src].</span>")
			return
		if(stored_ammo.len >= ammo_max)
			to_chat(user, "<span class='warning'>[src] is full!</span>")
			return
		if(!user.attempt_insert_item_for_installation(B, src))
			return
		stored_ammo.Add(B)
		update_icon()
	playsound(user.loc, 'sound/weapons/flipblade.ogg', 50, 1)
	update_icon()

/obj/item/ammo_magazine/cell_mag/update_icon()
	cut_overlays()
	if(!stored_ammo.len)
		return //Why bother

	var/current = 0
	for(var/B in stored_ammo)
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

/obj/item/ammo_magazine/cell_mag/advanced
	name = "advanced microbattery magazine"
	desc = "A microbattery holder for a cell-based variable weapon. This one has much more cell capacity!"
	ammo_max = 6
	x_offset = 3
	icon_state = "cell_mag_extended"
