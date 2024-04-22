//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

// i hate all of this and i hate all of you

GLOBAL_DATUM(legacy_cargo_station_dock, /obj/shuttle_dock)
GLOBAL_DATUM(legacy_cargo_centcom_dock, /obj/shuttle_dock)
GLOBAL_DATUM(legacy_cargo_shuttle, /datum/shuttle/supply)

GLOBAL_DATUM(legacy_emergency_shuttle_station_dock, /obj/shuttle_dock)
GLOBAL_DATUM(legacy_emergency_shuttle_centcom_dock, /obj/shuttle_dock)
GLOBAL_DATUM(legacy_emergency_shuttle, /datum/shuttle/emergency)

GLOBAL_DATUM(legacy_belter_station_dock, /obj/shuttle_dock)
GLOBAL_DATUM(legacy_belter_away_dock, /obj/shuttle_dock)
GLOBAL_DATUM(legacy_belter_shuttle, /datum/shuttle/belter)

/obj/shuttle_dock/hardcoded_legacy
	centered_landing_allowed = FALSE
	manual_docking_beacon = FALSE
	protect_bounding_box = TRUE
	trample_bounding_box = TRUE

#warn some way to autoset bounding box from loaded cargo shuttle
#warn map loads cargo shuttle?
#warn same for emergency shuttle
#warn make sure to set the ferry controllers properly (home is where it starts)...

/obj/shuttle_dock/hardcoded_legacy/Initialize(mapload)
	. = ..()
	set_global_datum()

/obj/shuttle_dock/hardcoded_legacy/proc/set_global_datum()
	CRASH("um")

/obj/shuttle_dock/hardcoded_legacy/cargo

/obj/shuttle_dock/hardcoded_legacy/cargo/loaded_shuttle(datum/shuttle/loaded)
	. = ..()
	GLOB.legacy_cargo_shuttle = loaded

/**
 * aligned docking port of cargo shuttle at station
 */
/obj/shuttle_dock/hardcoded_legacy/cargo/station

/obj/shuttle_dock/hardcoded_legacy/cargo/station/set_global_datum()
	GLOB.legacy_cargo_station_dock = src

/**
 * aligned docking port of cargo shuttle at centcom
 */
/obj/shuttle_dock/hardcoded_legacy/cargo/centcom

/obj/shuttle_dock/hardcoded_legacy/cargo/centcom/set_global_datum()
	GLOB.legacy_cargo_centcom_dock = src

/obj/shuttle_dock/hardcoded_legacy/emergency

/obj/shuttle_dock/hardcoded_legacy/emergency/loaded_shuttle(datum/shuttle/loaded)
	. = ..()
	GLOB.legacy_emergency_shuttle = loaded

/**
 * aligned docking port of cargo shuttle at station
 */
/obj/shuttle_dock/hardcoded_legacy/emergency/station

/obj/shuttle_dock/hardcoded_legacy/emergency/station/set_global_datum()
	GLOB.legacy_emergency_shuttle_station_dock = src

/**
 * aligned docking port of cargo shuttle at centcom
 */
/obj/shuttle_dock/hardcoded_legacy/emergency/centcom

/obj/shuttle_dock/hardcoded_legacy/emergency/centcom/set_global_datum()
	GLOB.legacy_emergency_shuttle_centcom_dock = src

/obj/shuttle_dock/hardcoded_legacy/belter

/obj/shuttle_dock/hardcoded_legacy/belter/loaded_shuttle(datum/shuttle/loaded)
	. = ..()
	GLOB.legacy_belter_shuttle = loaded

/**
 * aligned docking port of belter shuttle at station
 */
/obj/shuttle_dock/hardcoded_legacy/belter/station

/obj/shuttle_dock/hardcoded_legacy/belter/station/set_global_datum()
	GLOB.legacy_belter_station_dock = src

/**
 * aligned docking port of belter shuttle at centcom
 */
/obj/shuttle_dock/hardcoded_legacy/belter/away

/obj/shuttle_dock/hardcoded_legacy/belter/away/set_global_datum()
	GLOB.legacy_belter_away_dock = src
