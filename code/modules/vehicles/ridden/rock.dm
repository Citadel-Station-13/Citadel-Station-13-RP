/obj/vehicle/ridden/rock	// The pioneers used to ride these babies for miles
	name = "rock"
	desc = "Its not just a boulder, its a rock"
	icon = 'icons/obj/flora/rocks.dmi'
	icon_state = "basalt3"
	integrity = 200
	max_integrity = 200
	riding_handler_type = /datum/component/riding_handler/vehicle/rock

/obj/vehicle/ridden/rock/drive_check(mob/user)
	return !!user.get_held_item_of_type(/obj/item/pizzabox)

/datum/component/riding_handler/vehicle/rock
	vehicle_move_delay = 1
	allowed_turf_types = list(
		/turf/simulated,
		/turf/unsimulated
	)
	riding_handler_flags = list(CF_RIDING_HANDLER_ALLOW_BORDER,
	CF_RIDING_HANDLER_IS_CONTROLLABLE)


/datum/component/riding_handler/vehicle/rock
	rider_offsets = list(
		list(
			list(1, 16, 0.1, null),
			list(2, 16, 0.1, null),
			list(1, 16, 0.1, null),
			list(-2, 16, 0.1, null)
		)
	)
	rider_offset_format = CF_RIDING_OFFSETS_ENUMERATED

