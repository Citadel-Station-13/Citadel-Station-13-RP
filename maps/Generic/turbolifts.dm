/obj/turbolift_map_holder/rift
	name = "Atlas Lift"
	depth = 5
	lift_size_x = 2
	lift_size_y = 2
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	wall_type = null // Don't make walls

	areas_to_use = list(
		/area/turbolift/runder/level2,
		/area/turbolift/runder/level1,
		/area/turbolift/rsurface/level1,
		/area/turbolift/rsurface/level2,
		/area/turbolift/rsurface/level3
		)

/obj/turbolift_map_holder/rift_mining
	name = "Atlas Minging Lift"
	depth = 4
	lift_size_x = 2
	lift_size_y = 1
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	wall_type = null // Don't make walls

	areas_to_use = list(
		/area/turbolift/rmine/under3,
		/area/turbolift/rmine/under2,
		/area/turbolift/rmine/under1,
		/area/turbolift/rmine/surface
		)


/obj/turbolift_map_holder/triumph
	name = "Triumph Climber"
	depth = 4
	lift_size_x = 3
	lift_size_y = 1
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	wall_type = null // Don't make walls

	areas_to_use = list(
		/area/turbolift/t_ship/level1,
		/area/turbolift/t_ship/level2,
		/area/turbolift/t_ship/level3,
		/area/turbolift/t_ship/level4
		)


/obj/turbolift_map_holder/tether
	name = "Tether Climber"
	depth = 6
	lift_size_x = 3
	lift_size_y = 3
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	wall_type = null // Don't make walls

	areas_to_use = list(
		/area/turbolift/t_surface/level1,
		/area/turbolift/t_surface/level2,
		/area/turbolift/t_surface/level3,
		/area/turbolift/tether/transit,
		/area/turbolift/t_station/level1,
		/area/turbolift/t_station/level2
		)




/* SHUT UP
/datum/turbolift
	music = list('sound/music/elevator1.ogg', 'sound/music/elevator2.ogg')  // Woo elevator music!
*/
