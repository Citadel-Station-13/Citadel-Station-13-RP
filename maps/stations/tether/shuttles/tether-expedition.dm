DECLARE_STATION_SHUTTLE_TEMPLATE(/tether, /excursion)
	id = "tether-excursion"
	name = "Excursion Shuttle"
	display_name = "Excursion Shuttle"

	descriptor = /datum/shuttle_descriptor{
	}
	facing_dir = NORTH

#warn impl

/area/shuttle/excursion
/area/shuttle/excursion/general
/area/shuttle/excursion/cockpit
/area/shuttle/excursion/cargo
/obj/overmap/entity/visitable/ship/landable/excursion/tether
