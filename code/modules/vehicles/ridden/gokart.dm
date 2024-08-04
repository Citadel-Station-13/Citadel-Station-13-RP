/obj/vehicle/ridden/gokart
	name = "go-kart"
	desc = "Moves fast. Built for smooth, purpose-built raceways."
	icon = 'icons/obj/gokart.dmi'
	icon_state = "orange"
	integrity = 200
	integrity_max = 200
	riding_handler_type = /datum/component/riding_handler/vehicle/gokart

/obj/vehicle/ridden/gokart/random/Initialize(mapload)
	. = ..()
	icon_state = pick("orange","black","blue","red","yellow","purple","brown","pink","white","cyan","lime","green","rainbow")
	update_icon()

/datum/component/riding_handler/vehicle/gokart
	vehicle_move_delay = 1
	allowed_turf_types = list(
		/turf/simulated,
		/turf/unsimulated
	)
	riding_handler_flags = list(CF_RIDING_HANDLER_ALLOW_BORDER,
	CF_RIDING_HANDLER_IS_CONTROLLABLE)


/datum/component/riding_handler/vehicle/gokart
	rider_offsets = list(
		list(
			list(0, 0, -0.1, null),
			list(0, 0, -0.1, null),
			list(0, 0, -0.1, null),
			list(0, 0, -0.1, null)
		)
	)
	rider_offset_format = CF_RIDING_OFFSETS_ENUMERATED
