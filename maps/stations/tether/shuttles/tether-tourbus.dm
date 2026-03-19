DECLARE_STATION_SHUTTLE_TEMPLATE(/tether, /tourbus)
	id = "tether-tourbus"
	name = "Tour Bus"
	desc = "A small 'space bus', if you will."
	descriptor = /datum/shuttle_descriptor{
		mass = 2000;
		legacy_overmap_scan_name = "Tour Bus";
		legacy_overmap_color = "#a890ac";
	}

	display_name = "Tour Bus"

#warn impl

/obj/overmap/entity/visitable/ship/landable/tourbus
