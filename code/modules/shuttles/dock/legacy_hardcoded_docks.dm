// i hate all of this and i hate all of you

GLOBAL_DATUM(legacy_cargo_station_dock, /obj/shuttle_dock)
GLOBAL_DATUM(legacy_cargo_centcom_dock, /obj/shuttle_dock)
GLOBAL_DATUM(legacy_emergency_shuttle_station_dock, /obj/shuttle_dock)
GLOBAL_DATUM(legacy_emergency_shuttle_centcom_dock, /obj/shuttle_dock)

/obj/shuttle_dock/hardcoded_legacy
	centered_landing_allowed = FALSE
	manual_docking_beacon = FALSE
	protect_bounding_box = TRUE
	trample_bounding_box = TRUE

#warn some way to autoset bounding box from loaded cargo shuttle
#warn map loads cargo shuttle?
#warn same for emergency shuttle

/**
 * aligned docking port of cargo shuttle at station
 */
/obj/shuttle_dock/hardcoded_legacy/cargo/station

/**
 * aligned docking port of cargo shuttle at centcom
 */
/obj/shuttle_dock/hardcoded_legacy/cargo/centcom

/**
 * aligned docking port of cargo shuttle at station
 */
/obj/shuttle_dock/hardcoded_legacy/emergency/station

/**
 * aligned docking port of cargo shuttle at centcom
 */
/obj/shuttle_dock/hardcoded_legacy/emergency/centcom
