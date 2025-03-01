#warn purge
/obj/item/gun/projectile/ballistic/microbattery
	var/charge_left = 0
	var/max_charge = 0

/obj/item/gun/projectile/ballistic/microbattery/proc/update_charge()
	charge_left = 0
	max_charge = 0

	if(!chambered)
		return

	var/obj/item/ammo_casing/microbattery/batt = chambered

	charge_left = batt.shots_left
	max_charge = initial(batt.shots_left)
	if(magazine) //Crawl to find more
		for(var/B in ammo_magazine.ammo_internal)
			var/obj/item/ammo_casing/microbattery/bullet = B
			if(istype(bullet,batt.type))
				charge_left += bullet.shots_left
				max_charge += initial(bullet.shots_left)

/obj/item/gun/projectile/ballistic/microbattery/proc/switch_to(obj/item/ammo_casing/microbattery/new_batt)
	if(ishuman(loc))
		if(chambered && new_batt.type == chambered.type)
			to_chat(loc,"<span class='warning'>\The [src] is now using the next [new_batt.type_name] power cell.</span>")
		else
			to_chat(loc,"<span class='warning'>\The [src] is now firing [new_batt.type_name].</span>")

	chambered = new_batt
	update_charge()
	update_icon()

/obj/item/gun/projectile/ballistic/microbattery/update_overlays()
	. = ..()

	update_charge()

	if(!chambered)
		return

	var/obj/item/ammo_casing/microbattery/batt = chambered
	var/batt_color = batt.type_color //Used many times

	//Mode bar
	var/image/mode_bar = image(icon, icon_state = "[initial(icon_state)]_type")
	mode_bar.color = batt_color
	. += mode_bar

	//Barrel color
	var/image/barrel_color = image(icon, icon_state = "[initial(icon_state)]_barrel")
	barrel_color.alpha = 150
	barrel_color.color = batt_color
	. += barrel_color

	//Charge bar
	var/ratio = CEILING(((charge_left / max_charge) * charge_sections), 1)
	for(var/i = 0, i < ratio, i++)
		var/image/charge_bar = image(icon, icon_state = "[initial(icon_state)]_charge")
		charge_bar.pixel_x = i
		charge_bar.color = batt_color
		. += charge_bar


