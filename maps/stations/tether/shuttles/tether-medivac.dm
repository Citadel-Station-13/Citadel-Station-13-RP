DECLARE_STATION_SHUTTLE_TEMPLATE(/tether, /medivac)
	id = "tether-medivac"
	name = "Medivac Shuttle"
	display_name = "Medivac Shuttle"

	descriptor = /datum/shuttle_descriptor{
		mass = 8500;
		overmap_legacy_scan_name = "Medivac Shuttle";
		overmap_icon_color = "#ff0000";
	}
	facing_dir = EAST

#warn impl

/area/shuttle/medivac
/area/shuttle/medivac/general
/area/shuttle/medivac/cockpit
/area/shuttle/medivac/engines

/obj/overmap/entity/visitable/ship/landable/medivac
