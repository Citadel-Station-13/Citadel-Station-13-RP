// todo: rework all of this shit, jfc
/obj/item/gun/projectile/ballistic/microbattery
	name = "multipurpose cell-loaded revolver"
	desc = "Variety is the spice of life! This weapon is a hybrid of the NT-102b 'Nanotech Selectable-Fire Weapon' and the Vey-Med ML-3 'Medigun', dubbed the 'NSFW-ML3M'. \
	It can fire both harmful and healing cells with an internal nanite fabricator and energy weapon cell loader. Up to three combinations of \
	energy beams can be configured at once. Ammo not included."
	//catalogue_data = list(/datum/category_item/catalogue/information/organization/nanotrasen)

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "nsfw"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "gun"

	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 6, TECH_MAGNETS = 4)

	caliber = /datum/ammo_caliber/microbattery
	handle_casings = HOLD_CASINGS //Don't eject batteries!
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


