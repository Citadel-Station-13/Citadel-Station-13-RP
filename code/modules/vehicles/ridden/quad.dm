/obj/vehicle/ridden/quadbike
	name = "electric all terrain vehicle"
	desc = "A ridable electric ATV designed for all terrain. Except space."
	icon = 'icons/obj/vehicles/quad_64x64.dmi'
	icon_state = "quad"
	integrity = 200
	integrity_max = 200
	riding_handler_type = /datum/component/riding_handler/vehicle/ridden/quadbike
	is_mechanical = FALSE
	cell_type = /obj/item/cell
	power_cost_to_move = 5
	key_type = /obj/item/key/quadbike
	can_paint = TRUE
	custom_icon_path = 'icons/obj/custom_items_vehicle.dmi'
	frame_state_name = "quad"

/obj/vehicle/ridden/quadbike/random_color/Initialize(mapload)
	. = ..()
	paint_color = rgb(rand(1,255),rand(1,255),rand(1,255))
	update_icon()

/obj/vehicle/ridden/quadbike/nokey
	key_type = null

/obj/vehicle/ridden/quadbike/random_color/nokey
	key_type = null

/obj/item/key/quadbike
	name = "quadbike key"
	desc = "A keyring with a small steel key, and a blue fob reading \"ZOOM!\"."
	icon_state = "quad_keys"


/datum/component/riding_handler/vehicle/ridden/quadbike
	vehicle_move_delay = 2
	allowed_turf_types = list(
		/turf/simulated,
		/turf/unsimulated
	)
	vehicle_offsets = list(-16, 0)
	rider_check_flags = list(CF_RIDING_CHECK_ARMS,
	CF_RIDING_CHECK_RESTRAINED,
	CF_RIDING_CHECK_UNCONSCIOUS,
	CF_RIDING_CHECK_INCAPACITATED
	)

	rider_offsets = list(
		list(
			list(0, 7, 0.1, null),
			list(2, 2, 0.1, null),
			list(0, 7, 0.1, null),
			list(-2, 2, 0.1, null)
		)
	)
	rider_offset_format = CF_RIDING_OFFSETS_ENUMERATED
	riding_handler_flags = list(CF_RIDING_HANDLER_ALLOW_BORDER,
	CF_RIDING_HANDLER_IS_CONTROLLABLE)

/obj/vehicle/ridden/quadbike/update_icon()
	..()
	update_overlay()
	return
