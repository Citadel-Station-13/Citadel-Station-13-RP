//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//? System procs go in here, namespaced to the teleporter controller, as well as the subsystem
//? as teleporter mainframes are what networks everything together
//? Oh, and other stuff like teleporter context go in here.

//? Context System

/**
 * Context object
 *
 * Allows us to cache many calculations.
 */
/datum/teleporter_context
	//* locality
	/// overmap entity we're attached to; if null, we are considered an orphaned context
	/// orphaned contexts are considered on the same world / planet / sector as orphaned signals
	/// depending on how SSmapping is set up
	//  todo: given SSmapping only supports overmaps mode and doesn't have a massive differentiation system yet,
	//  todo: this basically is required for telescience to operate; otherwise, only orphaned/standalone signals
	//  todo: will be allowed to be used by this teleporter.
	//
	//  todo: we also don't really have 'z' / verticality considered.
	var/obj/overmap/entity/overmap_anchor

	//* sensors
	/// whether orphaned or non-orphaned, this is part of the coordinate tuple of where the center of our sensor fields map to
	var/sensor_center_x
	/// whether orphaned or non-orphaned, this is part of the coordinate tuple of where the center of our sensor fields map to
	var/sensor_center_y
	/// cached - overall sensor strength, in kilowatts, at the center of our sensor fields
	var/sensor_center_magnitude

/obj/machinery/teleporter_controller/proc/create_context()
	context = new(src)
	rebuild_context()

/obj/machinery/teleporter_controller/proc/rebuild_context()
	rebuild_context_locality()
	rebuild_context_sensors()

/obj/machinery/teleporter_controller/proc/rebuild_context_locality()
	var/obj/overmap/entity/entity = get_overmap_sector(src)

	context.overmap_anchor = entity

/obj/machinery/teleporter_controller/proc/rebuild_context_sensors()
	var/avg_x = 0
	var/avg_y = 0
	var/avg_power = 0
	var/div_len = 0

	for(var/obj/machinery/teleporter/bluespace_scanner/scanner as anything in scanners)
		var/turf/anchor = get_turf(scanner)
		if(isnull(anchor))
			stack_trace("scanner not on turf")
			continue
		++div_len
		avg_x += anchor.x
		avg_y += anchor.y
		avg_power += scanner.effective_power()

	context.sensor_center_x = avg_x / div_len
	context.sensor_center_y = avg_y / div_len
	context.sensor_center_magnitude = avg_power / div_len

//? Linkage System

/// list format: [key] = list(...)
///
/// sub-list contents:
/// * list of machines if the controller isn't around yet
/// * controller if the controller is
///
/// machines auto-link to the controller if it's around when they init
/// controller auto-link to the machines that already init'd if the machines are around first
GLOBAL_LIST_EMPTY(telescience_linkage_buffers)

//? Lock System

/obj/machinery/teleporter_controller/proc/attempt_signal_lock(datum/bluespace_signal/signal)
	#warn impl

/obj/machinery/teleporter_controller/proc/drop_signal_lock(datum/bluespace_signal/signal)
	#warn impl

/**
 * @params
 * * dt - time elapsed in seconds
 */
/obj/machinery/teleporter_controller/proc/process_signal_locks(dt)
	#warn impl

//? Signal Scanning

/**
 * @return list of viable signals
 */
/obj/machinery/teleporter_controller/proc/signal_query()
	#warn impl


