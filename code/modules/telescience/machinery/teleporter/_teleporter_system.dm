//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//? System procs go in here, namespaced to the teleporter controller, as well as the subsystem
//? as teleporter mainframes are what networks everything together
//? Oh, and other stuff like teleporter context go in here.

/**
 * Context object
 *
 * Allows us to cache many calculations.
 */
/datum/teleporter_context
	//* locality
	/// overmap entity we're attached to; if null, we are considered an orphaned context
	/// orphaned contexts are considered on the same world / planet / sector as signals
	/// depending on how SSmapping is set up
	//  todo: given SSmapping only supports overmaps mode and doesn't have a massive differentiation system yet,
	//  todo: this basically is required for telescience to operate; otherwise, only orphaned/standalone signals
	//  todo: will be allowed to be used by this teleporter.
	var/obj/overmap/entity/overmap_anchor
	/// whether orphaned or non-orphaned, this is part of the coordinate tuple of where the center of our sensor fields map to
	var/sensor_center_x
	/// whether orphaned or non-orphaned, this is part of the coordinate tuple of where the center of our sensor fields map to
	var/sensor_center_y
	/// whether orphaned or non-orphaned, this is part of the coordinate tuple of where the center of our sensor fields map to
	var/sensor_center_z
	/// cached - overall sensor strength, in kilowatts, at the center of our sensor fields
	var/sensor_center_magnitude

/obj/machinery/teleporter_controller/proc/create_context()
	context = new
	rebuild_context()

/obj/machinery/teleporter_controller/proc/rebuild_context()
	rebuild_context_locality()

/obj/machinery/teleporter_controller/proc/rebuild_context_locality()
	#warn impl

#warn im gonna scream

/obj/machinery/teleporter_controller/proc/attempt_signal_lock(datum/bluespace_signal/signal)

/obj/machinery/teleporter_controller/proc/drop_signal_lock(datum/bluespace_signal/signal)

/**
 * @params
 * * dt - time elapsed in seconds
 */
/obj/machinery/teleporter_controller/proc/process_signal_locks(dt)

