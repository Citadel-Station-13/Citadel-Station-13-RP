/datum/wires/breakerbox
	wire_count = 2
	holder_type = /obj/machinery/power/breakerbox
	proper_name = "Breaker Box"

/datum/wires/breakerbox/New(atom/_holder)
	wires = list(WIRE_BREAKER_TOGGLE, WIRE_BREAKER_LOCK)
	return ..()

/datum/wires/breakerbox/interactable(mob/user)
	var/obj/machinery/power/breakerbox/B = holder
	if(B.panel_open)
		return TRUE
	return FALSE

/datum/wires/breakerbox/on_cut(wire, mend)
	var/obj/machinery/power/breakerbox/B = holder
	switch(wire)
		if(WIRE_BREAKER_LOCK)
			if(!mend)
				B.update_locked = TRUE
			else
				B.update_locked = FALSE

/datum/wires/breakerbox/on_pulse(wire)
	switch(wire)
		if(WIRE_BREAKER_TOGGLE)
			var/obj/machinery/power/breakerbox/B= holder
			var/on = B.on
			B.set_state(!on)
