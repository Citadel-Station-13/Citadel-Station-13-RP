DECLARE_SECTOR_SHUTTLE_TEMPLATE(/itv_talon, /talon_boat)
	id = "sector-itv_talon-talonboat"
	name = "Talon's Boat"
	desc = "A small transport shuttle from the ITV Talon."
	path = "maps/sectors/factions/independent/itv_talon/shuttles/itv_talon-talon_boat.dmm"
	descriptor = /datum/shuttle_descriptor{
		mass = 5000;
		overmap_legacy_scan_name = "ITV Talon Transport Shuttle";
	}

#warn impl
/obj/effect/shuttle_landmark/shuttle_initializer/talonboat
/area/shuttle/talonboat
