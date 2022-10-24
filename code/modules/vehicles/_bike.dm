/obj/vehicle/ridden/bike 	// TODO, make this fly @ktoma36
	name = "space-bike"
	desc = "Space wheelies! Woo! This one doesnt seem to fly!"
	icon = 'icons/obj/bike.dmi'
	icon_state = "bike_off"
	dir = SOUTH
	integrity = 100
	max_integrity = 100
	riding_handler_type = /datum/component/riding_handler/vehicle/bike/small


/datum/component/riding_handler/vehicle/bike
	vehicle_move_delay = 2
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



/datum/component/riding_handler/vehicle/bike/small
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

//	load_item_visible = 1
//	mob_offset_y = 5
//	health = 100
//	maxhealth = 100

//	locked = 0
//	powered = 1

//	fire_dam_coeff = 0.6
//	brute_dam_coeff = 0.5
//	cell = /obj/item/cell/high
//	var/protection_percent = 60

//	var/land_speed = 0.5 //if 0 it can't go on turf
//	var/space_speed = 0.4
//	var/bike_icon = "bike"
//	var/custom_icon = FALSE

//	paint_color = "#ffffff"

//	var/datum/effect_system/ion_trail_follow/ion
//	var/kickstand = 1
