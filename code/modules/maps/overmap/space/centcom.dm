//Overmap Controller
/obj/effect/overmap/visitable/sector/centcom
	name = "NTS Demeter"
	desc = "The seat of NanoTrasen's power in the Lythios system."
	scanner_desc = @{"[i]Information[/i]: NanoTrasen's hub station for the system, and the base of local Central Command."}
	in_space = 1
	known = TRUE
	icon_state = "fueldepot"
	color = "#007396"
	start_x = 17
	start_y = 12

	initial_restricted_waypoints = list(
		"NDV Quicksilver" = list("specops_hangar")
		)

//This is an Orbit system I tried to write to get the Demeter to simulate an orbit around Lythios.
//It "works", but sadly the object is placed on the Overmap before these variables run, preventing it from actually functioning as intended.
/*
	var/randxloc = null
	var/randyloc = null
	start_x = null
	start_y = null

/obj/effect/overmap/visitable/sector/centcom/Initialize()
	. = ..()
	Orbit()

/obj/effect/overmap/visitable/sector/centcom/proc/Orbit()
	if(!randxloc)
		start_x = pick(13, 14, 16, 17)
	if(!randyloc)
		start_y = pick(8, 9, 11, 12)
*/

/obj/landmark/map_data/centcom
    height = 1

// ERT Shuttle can be found at '/maps/overmap/shuttles/specialops.dm'

// EXCLUSIVE NAV POINT FOR DOCKING INSIDE (ERT SHUTTLE ONLY)
/obj/effect/shuttle_landmark/specops/hangar
	name = "NTS Demeter Hangar"
	landmark_tag = "specops_hangar"
	docking_controller = "specops_hangar_dock"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/centcom/specops/dock

//ERT Cryo
/obj/machinery/cryopod/robot/door/travel/specops
	name = "Transfer Elevator"
	announce_channel = "Response Team"
	on_store_message = "has departed to the Civilian district."
	on_store_name = "Central Command ST-ERT"
	on_enter_visible_message = "steps into the"
	on_enter_occupant_message = "The elevator door closes slowly, ready to bring you down to the ST-ERT personnel deck."
	on_store_visible_message_1 = "makes a ding as it moves"
	on_store_visible_message_2 = "to the ST-ERT personnel deck."
