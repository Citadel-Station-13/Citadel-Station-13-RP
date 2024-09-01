//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/**
 * Controller datum for quantum archways
 */
/datum/quantum_archway
	/// active?
	var/active = FALSE
	/// segments in us
	var/list/obj/machinery/quantum_archway_segment/segments
	/// our linked archway
	///
	/// * UI/UX reasons: must be same axis as us (so no NORTH to EAST, only NORTH to SOUTH)
	/// * simulation reasons: must be opposite dir as us (so NORTH to SOUTH, no NORTH to NORTH)
	/// * lazy, can be fixed later: must be same length
	var/datum/quantum_archway/linked

/datum/quantum_gateway/New(obj/machinery/quantum_gateway_segment/segment)
	#warn impl

/datum/quantum_gateway/Destroy()
	#warn impl
	return ..()

/datum/quantum_gateway/proc/activate()

/datum/quantum_gateway/proc/deactivate()

/datum/quantum_gateway/proc/set_activation(new_activation)
	if(new_activation == active)
		return
	if(new_activation)
		activate()
	else
		deactivate()

/datum/quantum_gateway/proc/merge_with(datum/quantum_gateway/other)

/datum/quantum_gateway/proc/split_at(obj/machinery/quantum_gateway_segment/segment)

/datum/quantum_gateway/proc/set_linked(datum/quantum_gateway/other)

/datum/quantum_gateway/proc/get_length()
	return length(segments)

#warn impl
