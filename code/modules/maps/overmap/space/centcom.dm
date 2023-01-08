//Overmap Controller
/obj/effect/overmap/visitable/sector/centcom
	name = "NTS Demeter"
	desc = "The seat of NanoTrasen's power in the Lythios system."
	scanner_desc = @{"[i]Information[/i]: NanoTrasen's hub station for the system, and the base of local Central Command."}
	in_space = 1
	known = TRUE
	icon_state = "fueldepot"
	color = "#007396"

	initial_generic_waypoints = list(
		"NDV Quicksilver" = list("specops_hangar")
		)

/obj/landmark/map_data/centcom
    height = 1

// ERT Shuttle can be found at '/maps/overmap/shuttles/specialops.dm'

// EXCLUSIVE NAV POINT FOR DOCKING INSIDE (ERT SHUTTLE ONLY)
/obj/effect/shuttle_landmark/specops/hangar
	name = "NTS Demeter Hangar"
	landmark_tag = "specops_hangar"
	docking_controller = "specops_hangar_dock"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid
	base_area = /area/centcom/specops/dock
