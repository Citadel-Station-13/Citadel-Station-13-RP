DECLARE_STATION_SHUTTLE_TEMPLATE(/minitest, /overmap_demo)
	id = "minitest-overmap_demo"
	name = "Overmap Demo Shuttle"
	display_name = "Overmap Demo Shuttle"

	descriptor = /datum/shuttle_descriptor{
		preferred_orientation = WEST;
		mass = 5000;
		overmap_icon_color = "#72388d";
		overmap_legacy_name = "VSS Overmap Demo";
		overmap_legacy_desc = "Small little shuttle nonetheless capable of overmap travel!";
	}


#warn impl
/area/shuttle/overmapdemo
/obj/overmap/entity/visitable/ship/landable/overmapdemo
/obj/effect/shuttle_landmark/station_dockpoint1
/obj/effect/shuttle_landmark/station_dockpoint2
/obj/effect/shuttle_landmark/station_inside
/obj/effect/shuttle_landmark/shared_space
	name = "Somewhere In Space"
