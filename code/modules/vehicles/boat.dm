/obj/vehicle/boat
	name = "boat"
	desc = "It's a wooden boat. Looks like it'll hold two people. Oars not included."
	icon = 'icons/obj/vehicles_36x32.dmi'
	icon_state = "boat"
	health = 100
	maxhealth = 100
	charge_use = 0 // Boats use oars.
	pixel_x = -2
	move_delay = 3 // Rather slow, but still faster than swimming, and won't get you wet.
	max_buckled_mobs = 2
	anchored = FALSE
	material_primary = MATERIAL_ID_WOOD
	var/riding_datum_type = /datum/riding/boat/small

/obj/vehicle/boat/sifwood/Initialize(mapload)
	. = ..()
	riding_datum = new riding_datum_type(src)

/obj/vehicle/boat/sifwood
	priamry_material = MATERIAL_ID_SIFWOOD

/obj/vehicle/boat/dragon
	name = "dragon boat"
	desc = "It's a large wooden boat, carved to have a nordic-looking dragon on the front. Looks like it'll hold five people. Oars not included."
	icon = 'icons/obj/64x32.dmi'
	icon_state = "dragon_boat"
	health = 250
	maxhealth = 250
	pixel_x = -16
	max_buckled_mobs = 5
	riding_datum_type = /datum/riding/boat/big

/obj/vehicle/boat/dragon/Initialize(mapload)
	var/image/I = image(icon, src, "dragon_boat_underlay", BELOW_MOB_LAYER)
	underlays += I

/obj/vehicle/boat/dragon/sifwood
	material_primary = MATERIAL_ID_SIFWOOD

/obj/vehicle/boat/SetMaterial(datum/material/M, index = MATERIAL_INDEX_PRIMARY)
	. = ..()
	material_primary = M

/obj/vehicle/boat/GetMaterial(index)
	return material_primary

// Oars, which must be held inhand while in a boat to move it.
/obj/item/weapon/oar
	name = "oar"
	icon = 'icons/obj/vehicles.dmi'
	desc = "Used to provide propulsion to a boat."
	icon_state = "oar"
	item_state = "oar"
	force = 12
	material_primary = MATERIAL_ID_WOOD

/obj/item/weapon/oar/sifwood
	material_primary = MATERIAL_ID_SIFWOOD

// Boarding.
/obj/vehicle/boat/MouseDrop_T(var/atom/movable/C, mob/user)
	if(ismob(C))
		user_buckle_mob(C, user)
	else
		..(C, user)

/obj/vehicle/boat/load(mob/living/L, mob/living/user)
	if(!istype(L)) // Only mobs on boats.
		return FALSE
	..(L, user)
