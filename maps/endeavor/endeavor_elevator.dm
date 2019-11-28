//Turbolift stuff
//Endeavor ship main elevator
/obj/turbolift_map_holder/endeavor
	name = "Endeavor Elevator"
	depth = 5
	lift_size_x = 4
	lift_size_y = 4
	icon = 'icons/obj/turbolift_preview_5x5.dmi'
	wall_type = null

	areas_to_use = list(
		/area/turbolift/endeavor/deckone,
		/area/turbolift/endeavor/decktwo,
		/area/turbolift/endeavor/deckthree,
		/area/turbolift/endeavor/deckfour,
		/area/turbolift/endeavor/deckfive
		)

/datum/turbolift
	music = list('sound/music/elevator.ogg')
