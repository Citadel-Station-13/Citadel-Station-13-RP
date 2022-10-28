/obj/vehicle/ridden/cart
	name = "The essence of a cart"
	desc = "Yell a mapper if you see this."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "changeme"
	integrity = 200
	max_integrity = 200
	riding_handler_type = /datum/component/riding_handler/vehicle/ridden/cart



/datum/component/riding_handler/vehicle/ridden/cart
	vehicle_move_delay = 0.5
	allowed_turf_types = list(
		/turf/simulated,
		/turf/unsimulated
	)
	vehicle_offsets = list(0, 0)


/datum/component/riding_handler/vehicle/ridden/cart
	rider_offsets = list(
		list(
			list(0, 7, 0.1, null),
			list(2, 2, 0.1, null),
			list(0, 7, -0.1, null),
			list(-2, 2, 0.1, null)
		)
	)
	rider_offset_format = CF_RIDING_OFFSETS_ENUMERATED
	rider_check_flags = list(CF_RIDING_CHECK_ARMS,
	CF_RIDING_CHECK_RESTRAINED,
	CF_RIDING_CHECK_UNCONSCIOUS,
	CF_RIDING_CHECK_INCAPACITATED
	)
	riding_handler_flags = list(CF_RIDING_HANDLER_ALLOW_BORDER,
	CF_RIDING_HANDLER_IS_CONTROLLABLE)

/obj/vehicle/ridden/cart/security
	name = "Security Cart"
	desc = "A ridable electric cart designed for personal transport."
	icon_state = "paddywagon"
	key_type = /obj/item/key/security_cart

/obj/item/key/security_cart
	name = "The Security Cart key"
	desc = "The Security Cart Key used to start it."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "securikey"
	w_class = ITEMSIZE_TINY


/obj/vehicle/ridden/cart/medical
	name = "Medical Cart"
	desc = "A ridable electric cart designed for personal transport"
	icon_state = "medicalbus"
	key_type = /obj/item/key/medical_cart

/obj/item/key/medical_cart
	name = "The Medical Cart key"
	desc = "The Medical Cart Key used to start it."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "medikey"
	w_class = ITEMSIZE_TINY
