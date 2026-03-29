DECLARE_STATION_SHUTTLE_TEMPLATE(/tether, /tourbus)
	id = "tether-tourbus"
	name = "Tour Bus"
	desc = "A small 'space bus', if you will."
	descriptor = /datum/shuttle_descriptor{
		mass = 2000;
		overmap_legacy_scan_name = "Tour Bus";
		overmap_icon_color = "#a890ac";
	}

	display_name = "Tour Bus"

#warn impl

/area/shuttle/tourbus
/area/shuttle/tourbus/general
/area/shuttle/tourbus/cockpit
/area/shuttle/tourbus/engines

/obj/overmap/entity/visitable/ship/landable/tourbus
