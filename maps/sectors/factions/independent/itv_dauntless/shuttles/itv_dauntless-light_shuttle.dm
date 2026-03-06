/**
 * A shuttle for the ITV Dauntless, originally.
 */
DECLARE_SECTOR_SHUTTLE_TEMPLATE(/itv_dauntless, /light_shuttle)
	id = "itv_dauntless-light_shuttle"


#warn impl


/area/shuttle/itglightshuttle
	name = "ITG Shuttlecraft"
	requires_power = 1
	dynamic_lighting = 1

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/itglightshuttle
	name = "ITG Dauntless - Shuttle Bay"
	shuttle_type = /datum/shuttle/autodock/overmap/itglightshuttle

// The 'shuttle'
/datum/shuttle/autodock/overmap/itglightshuttle
	name = "ITG Shuttlecraft"
	shuttle_area = /area/shuttle/itglightshuttle
