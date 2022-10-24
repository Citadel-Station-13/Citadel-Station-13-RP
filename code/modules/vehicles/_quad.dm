/obj/vehicle/ridden/quadbike
	name = "electric all terrain vehicle"
	desc = "A ridable electric ATV designed for all terrain. Except space."
	icon = 'icons/obj/vehicles_64x64.dmi'
	icon_state = "quad"
	integrity = 200
	max_integrity = 200
	riding_handler_type = /datum/component/riding_handler/vehicle/ridden/quadbike
	key_type = /obj/item/key/quadbike
	var/paint_color = "#666666" // Todo, put on _vehicle.dm
	var/frame_state = "quad" //Custom-item proofing!
	var/custom_frame = FALSE



/obj/vehicle/ridden/quadbike/nokey
	key_type = null

/obj/item/key/quadbike
	name = "key"
	desc = "A keyring with a small steel key, and a blue fob reading \"ZOOM!\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "quad_keys"
	w_class = ITEMSIZE_TINY


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

/datum/component/riding_handler/vehicle/ridden/quadbike/

/datum/component/riding_handler/vehicle/ridden/quadbike
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

		// Overlay shenanagens, WIP @ktoma36
/obj/vehicle/ridden/quadbike/random/Initialize(mapload)
	. = ..()
	paint_color = rgb(rand(1,255),rand(1,255),rand(1,255))
	update_icon()

/obj/vehicle/ridden/quadbike/update_icon()
	..()
	overlays.Cut()
	if(custom_frame)
		var/image/Bodypaint = new(icon = 'icons/obj/custom_items_vehicle.dmi', icon_state = "[frame_state]_a", layer = src.layer)
		Bodypaint.color = paint_color
		overlays += Bodypaint

		var/image/Overmob = new(icon = 'icons/obj/custom_items_vehicle.dmi', icon_state = "[frame_state]_overlay", layer = src.layer + 0.2) //over mobs
		var/image/Overmob_color = new(icon = 'icons/obj/custom_items_vehicle.dmi', icon_state = "[frame_state]_overlay_a", layer = src.layer + 0.2) //over the over mobs, gives the color.
		Overmob.plane = FLY_LAYER
		Overmob_color.plane = FLY_LAYER
		Overmob_color.color = paint_color

		overlays += Overmob
		overlays += Overmob_color
		return

	var/image/Bodypaint = new(icon = 'icons/obj/vehicles_64x64.dmi', icon_state = "[frame_state]_a", layer = src.layer)
	Bodypaint.color = paint_color
	overlays += Bodypaint

	var/image/Overmob = new(icon = 'icons/obj/vehicles_64x64.dmi', icon_state = "[frame_state]_overlay", layer = src.layer + 0.2) //over mobs
	var/image/Overmob_color = new(icon = 'icons/obj/vehicles_64x64.dmi', icon_state = "[frame_state]_overlay_a", layer = src.layer + 0.2) //over the over mobs, gives the color.
	Overmob.plane = FLY_LAYER
	Overmob_color.plane = FLY_LAYER
	Overmob_color.color = paint_color

	overlays += Overmob
	overlays += Overmob_color


