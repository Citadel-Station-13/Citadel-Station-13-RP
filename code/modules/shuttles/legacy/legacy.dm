//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

// i hate all of this and i hate all of you

GLOBAL_DATUM(legacy_cargo_station_dock, /obj/shuttle_dock)
GLOBAL_DATUM(legacy_cargo_centcom_dock, /obj/shuttle_dock)
GLOBAL_DATUM(legacy_cargo_shuttle, /datum/shuttle)

GLOBAL_DATUM(legacy_emergency_shuttle_station_dock, /obj/shuttle_dock)
GLOBAL_DATUM(legacy_emergency_shuttle_centcom_dock, /obj/shuttle_dock)
GLOBAL_DATUM(legacy_emergency_shuttle, /datum/shuttle)

GLOBAL_DATUM(legacy_belter_station_dock, /obj/shuttle_dock)
GLOBAL_DATUM(legacy_belter_away_dock, /obj/shuttle_dock)
GLOBAL_DATUM(legacy_belter_shuttle, /datum/shuttle)

/obj/shuttle_dock/hardcoded_legacy
	centered_landing_allowed = FALSE
	manual_docking_beacon = FALSE
	protect_bounding_box = TRUE
	trample_bounding_box = TRUE

#warn some way to autoset bounding box from loaded cargo shuttle
#warn map loads cargo shuttle?
#warn same for emergency shuttle

/obj/shuttle_dock/hardcoded_legacy/Initialize(mapload)
	. = ..()
	set_global_datum()

/obj/shuttle_dock/hardcoded_legacy/proc/set_global_datum()
	CRASH("um")

/obj/shuttle_dock/hardcoded_legacy/cargo

/obj/shuttle_dock/hardcoded_legacy/cargo/ready_shuttle(datum/shuttle/loaded)
	. = ..()
	GLOB.legacy_cargo_shuttle = loaded

/obj/shuttle_dock/hardcoded_legacy/cargo/init_shuttle(datum/shuttle/shuttle)
	. = ..()

	var/datum/shuttle_controller/ferry/controller = new("!cargo-station", "!cargo-away")
	shuttle.bind_controller(controller)

/**
 * aligned docking port of cargo shuttle at station
 */
/obj/shuttle_dock/hardcoded_legacy/cargo/station
	dock_id = "!cargo-station"

/obj/shuttle_dock/hardcoded_legacy/cargo/station/set_global_datum()
	GLOB.legacy_cargo_station_dock = src

/**
 * aligned docking port of cargo shuttle at centcom
 */
/obj/shuttle_dock/hardcoded_legacy/cargo/centcom
	dock_id = "!cargo-away"

/obj/shuttle_dock/hardcoded_legacy/cargo/centcom/set_global_datum()
	GLOB.legacy_cargo_centcom_dock = src

/obj/shuttle_dock/hardcoded_legacy/emergency

/obj/shuttle_dock/hardcoded_legacy/emergency/ready_shuttle(datum/shuttle/loaded)
	. = ..()
	GLOB.legacy_emergency_shuttle = loaded

/obj/shuttle_dock/hardcoded_legacy/emergency/init_shuttle(datum/shuttle/shuttle)
	. = ..()

	var/datum/shuttle_controller/ferry/controller = new("!emergency-station", "!emergency-away")
	shuttle.bind_controller(controller)

/**
 * aligned docking port of cargo shuttle at station
 */
/obj/shuttle_dock/hardcoded_legacy/emergency/station
	dock_id = "!emergency-station"

/obj/shuttle_dock/hardcoded_legacy/emergency/station/set_global_datum()
	GLOB.legacy_emergency_shuttle_station_dock = src

/**
 * aligned docking port of cargo shuttle at centcom
 */
/obj/shuttle_dock/hardcoded_legacy/emergency/centcom
	dock_id = "!emergency-away"

/obj/shuttle_dock/hardcoded_legacy/emergency/centcom/set_global_datum()
	GLOB.legacy_emergency_shuttle_centcom_dock = src

/obj/shuttle_dock/hardcoded_legacy/belter

/obj/shuttle_dock/hardcoded_legacy/belter/ready_shuttle(datum/shuttle/loaded)
	. = ..()
	GLOB.legacy_belter_shuttle = loaded

/obj/shuttle_dock/hardcoded_legacy/belter/init_shuttle(datum/shuttle/shuttle)
	. = ..()

	var/datum/shuttle_controller/ferry/controller = new("!belter-station", "!belter-away")
	shuttle.bind_controller(controller)

/**
 * aligned docking port of belter shuttle at station
 */
/obj/shuttle_dock/hardcoded_legacy/belter/station
	dock_id = "!belter-station"

/obj/shuttle_dock/hardcoded_legacy/belter/station/set_global_datum()
	GLOB.legacy_belter_station_dock = src

/**
 * aligned docking port of belter shuttle at centcom
 */
/obj/shuttle_dock/hardcoded_legacy/belter/away
	dock_id = "!belter-away"

/obj/shuttle_dock/hardcoded_legacy/belter/away/set_global_datum()
	GLOB.legacy_belter_away_dock = src
