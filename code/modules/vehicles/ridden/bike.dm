/obj/vehicle/ridden/bike 	// TODO, make this fly @ktoma36
	name = "space-bike"
	desc = "Space wheelies! Woo! This one doesnt seem to fly!"
	icon = 'icons/obj/vehicles/bike.dmi'
	icon_state = "bike_off"
	integrity = 100
	integrity_max = 100
	cell_type = /obj/item/cell
	key_type = /obj/item/key/bike
	is_mechanical = FALSE
	riding_handler_type = /datum/component/riding_handler/vehicle/bike
	power_cost_to_move = 5
	can_paint = TRUE
	frame_state_name = "bike"
	var/datum/effect_system/ion_trail_follow/ion

/obj/item/key/bike
	name = "bike key"
	desc = "A keyring with a small steel key."
	icon_state = "keys"

/datum/component/riding_handler/vehicle/bike
	vehicle_move_delay = 0.5
	allowed_turf_types = list(
		/turf/simulated/floor,
		/turf/unsimulated/floor
	)
	vehicle_offsets = list(
		list(1, 2),
		list(1, 2),
		list(1, 2),
		list(1, 2)
	)

	rider_offsets = list(
		list(
			list(1, 7, 0.1, null),
			list(2, 2, 0.1, null),
			list(1, 10, 0.1, null),
			list(-2, 2, 0.1, null)
		)
	)
	rider_offset_format = CF_RIDING_OFFSETS_ENUMERATED
	riding_handler_flags = list(CF_RIDING_HANDLER_ALLOW_BORDER,
	CF_RIDING_HANDLER_IS_CONTROLLABLE)

/obj/vehicle/ridden/bike/Initialize(mapload)
	. = ..()
	ion = new /datum/effect_system/ion_trail_follow()
	ion.set_up(src)
	update_icon()

//Random bikes spawn with a random color
/obj/vehicle/ridden/bike/random_color/Initialize(mapload)
	. = ..()
	paint_color = rgb(rand(1,255),rand(1,255),rand(1,255))

/obj/vehicle/ridden/bike/turn_on()
	..()
	icon_state = "bike_on"
	ion.start()
/obj/vehicle/ridden/bike/turn_off()
	..()
	icon_state = "bike_off"
	ion.stop()

/obj/vehicle/ridden/bike/update_icon()
	..()
	update_overlay()
	return

//Make sure to cleanup when done.
/obj/vehicle/ridden/bike/Destroy()
	qdel(ion)
	..()

