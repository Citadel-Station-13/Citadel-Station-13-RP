DECLARE_STATION_SHUTTLE_TEMPLATE(/tether, /securiship)
	id = "tether-securiship"
	name = "Securiship Shuttle"
	display_name = "Securiship Shuttle"

	descriptor = /datum/shuttle_descriptor{
		mass = 12500;
	}

	facing_dir = EAST

#warn impl

/area/shuttle/securiship
/area/shuttle/securiship/general
/area/shuttle/securiship/cockpit
/area/shuttle/securiship/engines
/obj/overmap/entity/visitable/ship/landable/securiship
