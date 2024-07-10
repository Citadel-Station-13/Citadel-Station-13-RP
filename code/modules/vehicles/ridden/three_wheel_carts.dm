/obj/vehicle/ridden/cart
	name = "The essence of a cart"
	desc = "Yell at a mapper if you see this."
	icon = 'icons/obj/vehicles/three_wheel_carts.dmi'
	icon_state = "oops"
	integrity = 200
	integrity_max = 200
	mechanical = FALSE
	riding_handler_type = /datum/component/riding_handler/vehicle/ridden/cart



/datum/component/riding_handler/vehicle/ridden/cart
	vehicle_move_delay = 1.25
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
	icon_state = "securikey"

/obj/vehicle/ridden/cart/medical
	name = "Medical Cart"
	desc = "A ridable electric cart designed for personal transport"
	icon_state = "medicalbus"
	key_type = /obj/item/key/medical_cart

/obj/item/key/medical_cart
	name = "The Medical Cart key"
	desc = "The Medical Cart Key used to start it."
	icon_state = "medikey"

/obj/vehicle/ridden/cart/janicart
	name = "Janicart"
	desc = "A pimpin' ride designed for custodian transport"
	icon_state = "pussywagon"
	key_type = /obj/item/key/medical_cart

/obj/item/key/janicart
	name = "key"
	desc = "A keyring with a small steel key, and a pink fob reading \"Pussy Wagon\"."
	icon_state = "keys"
/*
	if(SOUTH)
		L.pixel_x = 0
		L.pixel_y = 7
	if(WEST)
		L.pixel_x = 13
		L.pixel_y = 7
	if(NORTH)
		L.pixel_x = 0
		L.pixel_y = 4
	if(EAST)
		L.pixel_x = -13
		L.pixel_y = 7
*/
