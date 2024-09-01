//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/**
 * A segment of a quantum arch: A mapped archway allowing instant transportation between two locales.
 *
 * * autolinking, adminbus support included
 */
/obj/machinery/quantum_archway_segment
	name = "quantum archway"
	desc = "A massive, nigh-indestructible archway connecting to a linked line-gate in another locale."
	#warn sprite

	opacity = TRUE
	density = FALSE
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

	use_power = USE_POWER_OFF

	/// are we active?
	var/active = FALSE
	/// our archway controller datum
	var/datum/quantum_archway/controller

/obj/machinery/quantum_archway_segment/Initialize()
	form_network()
	return ..()

/obj/machinery/quantum_archway_segment/Destroy()
	break_network()
	return ..()

#warn impl

/obj/machinery/quantum_archway_segment/proc/form_network()
	if(!controller)
		controller = new(src)

/obj/machinery/quantum_archway_segment/proc/break_network()
	controller?.split_at(src)

/obj/machinery/quantum_archway_segment/proc/activate()

/obj/machinery/quantum_archway_segment/proc/deactivate()

/obj/machinery/quantum_archway_segment/proc/set_active(new_activation)

/obj/machinery/quantum_archway_segment/proc/set_partner(obj/machinery/quantum_archway_segment/partner)
	ASSERT(partner.dir == turn(dir, 108))

