/datum/wires/breakerbox
	holder_type = /obj/machinery/power/breakerbox
	wire_count = 2
	proper_name = "Breaker box"

/datum/wires/breakerbox/New(atom/_holder)
	wires = list(WIRE_POWER, WIRE_IDSCAN)
	return ..()

/datum/wires/breakerbox/interactable(mob/user)
	var/obj/machinery/power/breakerbox/B = holder
	if(B.panel_open)
		return TRUE
	return FALSE

/datum/wires/breakerbox/on_pulse(wire)
	switch(wire)
		if(WIRE_POWER)
			var/obj/machinery/power/breakerbox/B= holder
			var/on = B.on
			B.set_state(!on)

/datum/wires/breakerbox/on_cut(wire, mend)
	var/obj/machinery/power/breakerbox/B = holder
	switch(wire)
		if(WIRE_IDSCAN)
			if(!mend)
				B.update_locked = TRUE
			else
				B.update_locked = FALSE
