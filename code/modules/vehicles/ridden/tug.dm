/obj/vehicle/ridden/tug
	name = "Train Tug"
	desc = "A ridable electric car designed for pulling trolleys."
	icon = 'icons/obj/vehicles/tug.dmi'
	icon_state = "tug_base"
	overlays = list ("wheels","cargo_pride_base","standard_wheels")
	integrity = 200
	max_integrity = 200
	riding_handler_type = /datum/component/riding_handler/vehicle/ridden/tug

/obj/vehicle/ridden/tug/update_icon(initialized)
	..()
	overlays.Cut()
	add_overlay(image(icon = 'icons/obj/vehicles/tug.dmi', icon_state = "wheels", layer = src.layer + 1))
	return

/datum/component/riding_handler/vehicle/ridden/tug
	vehicle_move_delay = 3
	allowed_turf_types = list(
		/turf/simulated,
		/turf/unsimulated
	)

/datum/component/riding_handler/vehicle/ridden/tug
	rider_offsets = list(
		list(
			list(0, 16, 0.1, null),
			list(-7, 13, 0.1, null),
			list(0, 16, -0.1, null),
			list(7, 13, 0.1, null)
		)
	)
	rider_offset_format = CF_RIDING_OFFSETS_ENUMERATED
	rider_check_flags = list(CF_RIDING_CHECK_ARMS,
	CF_RIDING_CHECK_LEGS,
	CF_RIDING_CHECK_RESTRAINED,
	CF_RIDING_CHECK_UNCONSCIOUS,
	CF_RIDING_CHECK_INCAPACITATED
	)
	riding_handler_flags = list(CF_RIDING_HANDLER_ALLOW_BORDER,
	CF_RIDING_HANDLER_IS_CONTROLLABLE)


/obj/vehicle/ridden/tug/cargo
	name = "Cargo Train Tug"
	desc = "A ridable electric car designed for pulling trolleys. This one sports cargo livery"

/obj/vehicle/ridden/tug/cargo/update_icon(initalized)
	..()
	overlays.Cut()
	add_overlay(image(icon = 'icons/obj/vehicles/tug.dmi', icon_state = "cargo_pride_base", layer = src.layer + 1.1))
	add_overlay(image(icon = 'icons/obj/vehicles/tug.dmi', icon_state = "standard_wheels", layer = src.layer + 1.1))
	return
