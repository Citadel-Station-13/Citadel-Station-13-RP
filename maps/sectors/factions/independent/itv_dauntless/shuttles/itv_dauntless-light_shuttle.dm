/**
 * A shuttle for the ITV Dauntless, originally.
 */
DECLARE_SECTOR_SHUTTLE_TEMPLATE(/itv_dauntless, /light_shuttle)
	id = "sector-itv_dauntless-light_shuttle"
	name = "Dauntless Transport Shuttle"
	desc = "A transport shuttle for the ITV Dauntless"
	descriptor = /datum/shuttle_descriptor{
		overmap_legacy_scan_name = "ITV Dauntless Shuttlecraft";
	}

#warn impl

#warn map

/area/shuttle/itglightshuttle
/obj/effect/shuttle_landmark/shuttle_initializer/itglightshuttle
/datum/shuttle/autodock/overmap/itglightshuttle
