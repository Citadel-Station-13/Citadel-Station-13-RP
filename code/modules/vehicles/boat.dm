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

/obj/vehicle/ridden/boat/ashlander
	name = "blessed boat"
	desc = "This vessel has been blessed by the priesthood to grant safe passage. Lined with goliath hide and studded with elderstone, these vessels are rarely seen outside of seafaring convoys."
	icon = 'icons/obj/vehicles_36x32.dmi'
	icon_state = "boat_older"
	integrity = 150
	max_integrity = 150
	buckle_flags = BUCKLING_PASS_PROJECTILES_UPWARDS|BUCKLING_GROUND_HOIST
	riding_handler_type = /datum/component/riding_handler/vehicle/boat/small/ashlander

/obj/vehicle/ridden/boat/ashlander/Initialize(mapload, material_name)
	return ..(mapload, "bone")

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

/obj/item/oar/ashlander
	name = "blessed oar"
	desc = "An oar carved from bone. It has been studded with elder stone and baffled with Goliath hide to protect it from lava while still providing propulsion to a boat."
	icon_state = "oar_ashlander"
	item_state = "oar_ashlander"

/obj/item/oar/ashlander/Initialize(mapload, material_name)
	return ..(mapload, "bone")

/datum/component/riding_handler/vehicle/boat
	vehicle_move_delay = 3.5
	allowed_turf_types = list(
		/turf/simulated/floor/water
	)
	vehicle_offsets = list(
		list(1, 2),
		list(1, 2),
		list(1, 2),
		list(1, 2)
	)
	riding_handler_flags = list(CF_RIDING_HANDLER_ALLOW_BORDER,
	CF_RIDING_HANDLER_IS_CONTROLLABLE)

/datum/component/riding_handler/vehicle/boat/small
	rider_offsets = list(
		list(
			list(0, 7, 0.1, null),
			list(7, 2, -0.1, null),
			list(0, 2, -0.1, null),
			list(-7, 2, 0.1, null)
		),
		list(
			list(0, 2, 0.2, null),
			list(-7, 2, -0.2, null),
			list(0, 9, -0.2, null),
			list(7, 2, 0.2, null)
		)
	)
	rider_offset_format = CF_RIDING_OFFSETS_ENUMERATED

/datum/component/riding_handler/vehicle/boat/small/ashlander
	allowed_turf_types = list(
		/turf/simulated/floor/water,
		/turf/simulated/floor/outdoors/lava
	)
	rider_offsets = list(
		list(
			list(1, 4, 0.1, null),
			list(6, 4, -0.1, null),
			list(1, 4, -0.1, null),
			list(-4, 4, -0.1, null)
		),
		list(
			list(1, 4, 0.2, null),
			list(-7, 4, -0.2, null),
			list(1, 9, -0.2, null),
			list(7, 4, -0.2, null)
		)
	)

/datum/component/riding_handler/vehicle/boat/big
	rider_offsets = list(
		list(
			list(0, 11, -0.5, null),
			list(12, 7, -0.5, null),
			list(0, 3, -0.3, null),
			list(-12, 7, -0.5, null)
		),
		list(
			list(6, 7, -0.4, null),
			list(0, 3, -0.4, null),
			list(-6, 7, -0.4, null),
			list(0, 11, -1, null)
		),
		list(
			list(-6, 7, -0.3, null),
			list(0, 11, -1, null),
			list(6, 7, -0.3, null),
			list(0, 3, -0.3, null)
		),
		list(
			list(6, 3, -0.2, null),
			list(-12, 3, -0.3, null),
			list(-6, 11, -0.5, null),
			list(12, 11, -1, null)
		),
		list(
			list(-6, 3, -0.2, null),
			list(-12, 11, -1, null),
			list(6, 11, -0.5, null),
			list(12, 3, -0.3, null)
		)
	)
	rider_offset_format = CF_RIDING_OFFSETS_ENUMERATED
