/obj/vehicle/ridden/quadbike
	name = "electric all terrain vehicle"
	desc = "A ridable electric ATV designed for all terrain. Except space."
	icon = 'icons/obj/vehicles_64x64.dmi'
	icon_state = "quad"
	integrity = 200
	max_integrity = 200
	riding_handler_type = /datum/component/riding_handler/vehicle/ridden/quadbike
/*		/// Need 	var/paint_color = "#666666" on vehicle base for random colros to work
	var/frame_state = "quad" //Custom-item proofing!
	var/custom_frame = FALSE
*/
//	pixel_x = -16 	// Sometimes gets reset?

/datum/component/riding_handler/vehicle/ridden/quadbike
	vehicle_move_delay = 2
	allowed_turf_types = list(
		/turf/simulated/floor,
		/turf/unsimulated/floor
	)
	vehicle_offsets = list(-16, 0)



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

/*		// Overlay shenanagens, WIP @ktoma36
/obj/vehicle/ridden/quadbike/random/Initialize(mapload)
	. = ..()
	paint_color = rgb(rand(1,255),rand(1,255),rand(1,255))
	update_icon()

/obj/vehicle/ridden/quadbike/update_icon()
	..()
	overlays.Cut()
	var/image/Bodypaint = new(icon = 'icons/obj/vehicles_64x64.dmi', icon_state = "[frame_state]_a", layer = src.layer)
	Bodypaint.color = paint_color
	overlays += Bodypaint

	var/image/Overmob = new(icon = 'icons/obj/vehicles_64x64.dmi', icon_state = "[frame_state]_overlay", layer = src.layer + 0.2) //over mobs
	var/image/Overmob_color = new(icon = 'icons/obj/vehicles_64x64.dmi', icon_state = "[frame_state]_overlay_a", layer = src.layer + 0.2) //over the over mobs, gives the color.
	Overmob.plane = MOB_PLANE
	Overmob_color.plane = MOB_PLANE
	Overmob_color.color = paint_color

	overlays += Overmob
	overlays += Overmob_color
*/
