/obj/vehicle/ridden/boat
	name = "boat"
	desc = "It's a wooden boat. Looks like it'll hold two people. Oars not included."
	icon = 'icons/obj/vehicles_36x32.dmi'
	icon_state = "boat"
	integrity = 100
	max_integrity = 100
	base_pixel_x = -2
	icon_dimension_x = 36
	icon_dimension_y = 32
	buckle_max_mobs = 2
	riding_handler_type = /datum/component/riding_handler/vehicle/boat/small
	var/datum/material/material = null

/obj/vehicle/ridden/boat/Initialize(mapload, material_name)
	. = ..()
	if(!material_name)
		material_name = "wood"
	material = get_material_by_name("[material_name]")
	if(!material)
		qdel(src)
		return
	add_atom_colour(material.icon_colour, FIXED_COLOUR_PRIORITY)
	riding_datum = new riding_datum_type(src)

/obj/vehicle/ridden/boat/drive_check(mob/user)
	return !!user.get_held_item_of_type(/obj/item/oar)

/obj/vehicle/ridden/boat/sifwood/Initialize(mapload, material_name)
	return ..(mapload, MAT_SIFWOOD)

/obj/vehicle/ridden/boat/dragon
	name = "dragon boat"
	desc = "It's a large wooden boat, carved to have a nordic-looking dragon on the front. Looks like it'll hold five people. Oars not included."
	icon = 'icons/obj/64x32.dmi'
	icon_state = "dragon_boat"
	integrity = 250
	max_integrity = 250
	icon_dimension_x = 64
	icon_dimension_y = 32
	base_pixel_x = -16
	buckle_max_mobs = 5
	riding_handler_type = /datum/component/riding_handler/vehicle/boat/big

/obj/vehicle/ridden/boat/dragon/Initialize(mapload, material_name)
	. = ..(mapload, material_name)
	var/image/I = image(icon, src, "dragon_boat_underlay", BELOW_MOB_LAYER)
	underlays += I

/obj/vehicle/ridden/boat/dragon/sifwood/Initialize(mapload, material_name)
	return ..(mapload, MAT_SIFWOOD)

// Oars, which must be held inhand while in a boat to move it.
/obj/item/oar
	name = "oar"
	icon = 'icons/obj/vehicles.dmi'
	desc = "Used to provide propulsion to a boat."
	icon_state = "oar"
	item_state = "oar"
	force = 12
	var/datum/material/material = null

/obj/item/oar/sifwood/Initialize(mapload, material_name)
	return ..(mapload, MAT_SIFWOOD)

/obj/item/oar/Initialize(mapload, material_name)
	. = ..(mapload)
	if(!material_name)
		material_name = "wood"
	material = get_material_by_name("[material_name]")
	if(!material)
		qdel(src)
		return
	add_atom_colour(material.icon_colour, FIXED_COLOUR_PRIORITY)

/datum/component/riding_handler/vehicle/boat
	vehicle_move_delay = 3.5
	allowed_turf_types = list(
		/turf/simulated/floor/water
	)

/datum/component/riding_handler/vehicle/boat/small
	offset_layer = list(
		list(
			1,
			-1,
			-1,
			-1
		),
		list(
			2,
			-2,
			-2,
			-2
		)
	)
	offset_pixel = list(
		list(
			list(0, 7),
			list(7, 2),
			list(0, 2),
			list(-7, 2)
		),
		list(
			list(0, 2),
			list(0, 9),
			list(-7, 2),
			list(7, 2)
		)
	)

/datum/component/riding_handler/vehicle/boat/big
	offset_layer = list(
		list(
			1,
			-1,
			-1,
			-1
		),
		list(
			1,
			-1,
			-1,
			-1
		),		list(
			1,
			-1,
			-1,
			-1
		),		list(
			1,
			-1,
			-1,
			-1
		),		list(
			2,
			-2,
			-2,
			-2
		)
	)
	offset_pixel = list(
		list(
			list(0, 7),
			list(7, 2),
			list(0, 2),
			list(-7, 2)
		),
		list(
			list(0, 7),
			list(7, 2),
			list(0, 2),
			list(-7, 2)
		),		list(
			list(0, 7),
			list(7, 2),
			list(0, 2),
			list(-7, 2)
		),		list(
			list(0, 7),
			list(7, 2),
			list(0, 2),
			list(-7, 2)
		),		list(
			list(0, 2),
			list(0, 9),
			list(-7, 2),
			list(7, 2)
		)
	)

#warn REWRITE THE OFFSET SYSTEM, IT FUCKING SUCKS

/datum/riding/boat/big // 'Big' boats can hold up to five people.

/datum/riding/boat/big/get_offsets(pass_index) // list(dir = x, y, layer)
	var/H = 12 // Horizontal seperation. Halved when facing up-down.
	var/V = 4 // Vertical seperation.
	var/O = 7 // Vertical offset.
	switch(pass_index)
		if(1) // Person in center front, first row.
			return list(
				"[NORTH]" = list( 0,   O+V,   MOB_LAYER+0.1),
				"[SOUTH]" = list( 0,   O-V,   MOB_LAYER+0.3),
				"[EAST]"  = list( H,   O,     MOB_LAYER+0.1),
				"[WEST]"  = list(-H,   O,     MOB_LAYER+0.1)
				)
		if(2) // Person in left, second row.
			return list(
				"[NORTH]" = list( H/2, O,     MOB_LAYER+0.2),
				"[SOUTH]" = list(-H/2, O,     MOB_LAYER+0.2),
				"[EAST]"  = list( 0,   O-V,   MOB_LAYER+0.2),
				"[WEST]"  = list( 0,   O+V,   MOB_LAYER)
				)
		if(3) // Person in right, second row.
			return list(
				"[NORTH]" = list(-H/2, O,     MOB_LAYER+0.2),
				"[SOUTH]" = list( H/2, O,     MOB_LAYER+0.2),
				"[EAST]"  = list( 0,   O+V,   MOB_LAYER),
				"[WEST]"  = list( 0,   O-V,   MOB_LAYER+0.2)
				)
		if(4) // Person in left, third row.
			return list(
				"[NORTH]" = list( H/2, O-V,   MOB_LAYER+0.3),
				"[SOUTH]" = list(-H/2, O+V,   MOB_LAYER+0.1),
				"[EAST]"  = list(-H,   O-V,   MOB_LAYER+0.2),
				"[WEST]"  = list( H,   O+V,   MOB_LAYER)
				)
		if(5) // Person in right, third row.
			return list(
				"[NORTH]" = list(-H/2, O-V,   MOB_LAYER+0.3),
				"[SOUTH]" = list( H/2, O+V,   MOB_LAYER+0.1),
				"[EAST]"  = list(-H,   O+V,   MOB_LAYER),
				"[WEST]"  = list( H,   O-V,   MOB_LAYER+0.2)
				)
		else
			return null // This will runtime, but we want that since this is out of bounds.

/datum/riding/boat/big/handle_vehicle_layer()
	ridden.layer = MOB_LAYER+0.4

/datum/riding/boat/get_offsets(pass_index) // list(dir = x, y, layer)
	return list("[NORTH]" = list(1, 2), "[SOUTH]" = list(1, 2), "[EAST]" = list(1, 2), "[WEST]" = list(1, 2))
