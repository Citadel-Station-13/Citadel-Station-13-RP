/obj/structure/closet/secure_closet/guncabinet
	name = "gun cabinet"
	icon = 'icons/obj/guncabinet.dmi'
	icon_state = "base"
	icon_off ="base"
	icon_broken ="base"
	icon_locked ="base"
	icon_closed ="base"
	icon_opened = "base"
	req_one_access = list(ACCESS_SECURITY_ARMORY)

/obj/structure/closet/secure_closet/guncabinet/Initialize(mapload)
	. = ..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/toggle()
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/update_icon()
	cut_overlays()
	var/list/overlays_to_add = list()
	if(opened)
		overlays_to_add += icon(icon,"door_open")
	else
		var/lazors = 0
		var/shottas = 0
		for (var/obj/item/gun/G in contents)
			if (istype(G, /obj/item/gun/energy))
				lazors++
			if (istype(G, /obj/item/gun/ballistic))
				shottas++
		for (var/i = 0 to 2)
			if(lazors || shottas) // only make icons if we have one of the two types.
				var/image/gun = image(icon(src.icon))
				if (lazors > shottas)
					lazors--
					gun.icon_state = "laser"
				else if (shottas)
					shottas--
					gun.icon_state = "projectile"
				gun.pixel_x = i*4
				overlays_to_add += gun

		overlays_to_add += icon(src.icon, "door")

		if(sealed)
			overlays_to_add += icon(src.icon,"sealed")

		if(broken)
			overlays_to_add += icon(src.icon,"broken")
		else if (locked)
			overlays_to_add += icon(src.icon,"locked")
		else
			overlays_to_add += icon(src.icon,"open")

	add_overlay(overlays_to_add)

//SC Guncabinet files
/obj/structure/closet/secure_closet/guncabinet/sidearm
	name = "emergency weapon cabinet"
	req_one_access = list(ACCESS_SECURITY_ARMORY,ACCESS_COMMAND_CAPTAIN)

	starts_with = list(
		/obj/item/gun/energy/gun = 4)


/obj/structure/closet/secure_closet/guncabinet/rifle
	name = "rifle cabinet"
	req_one_access = list(ACCESS_GENERAL_EXPLORER,ACCESS_SECURITY_BRIG)

	starts_with = list(
		/obj/item/ammo_magazine/clip/c762/hunter = 9,
		/obj/item/gun/ballistic/shotgun/pump/rifle = 2)

/obj/structure/closet/secure_closet/guncabinet/rifle/Initialize(mapload)
	if(prob(85))
		starts_with += /obj/item/gun/ballistic/shotgun/pump/rifle
	else
		starts_with += /obj/item/gun/ballistic/shotgun/pump/rifle/lever
	return ..()

/obj/structure/closet/secure_closet/guncabinet/phase
	name = "explorer weapon cabinet"
	req_one_access = list(ACCESS_GENERAL_EXPLORER,ACCESS_SECURITY_BRIG)

	starts_with = list(
		/obj/item/gun/energy/phasegun = 2,
		/obj/item/cell/device/weapon = 2,
		/obj/item/clothing/accessory/permit/gun/planetside)

/obj/structure/closet/secure_closet/guncabinet/robotics
	name = "exosuit equipment cabinet"
	req_one_access = list(ACCESS_SCIENCE_ROBOTICS,ACCESS_SCIENCE_MAIN)

/obj/structure/closet/secure_closet/guncabinet/excursion
	name = "expedition weaponry cabinet"
	req_one_access = list(ACCESS_GENERAL_EXPLORER,ACCESS_SECURITY_ARMORY)

/obj/structure/closet/secure_closet/guncabinet/excursion/PopulateContents()
	for(var/i in 1 to 4)
		new /obj/item/gun/energy/frontier/locked(src)
	for(var/i in 1 to 4)
		new /obj/item/gun/energy/frontier/locked/holdout
