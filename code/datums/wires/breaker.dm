/datum/wires/breakerbox
	wire_count = 2
	holder_type = /obj/machinery/power/breakerbox

var/const/WIRE_TOGGLE = 1
var/const/WIRE_LOCK = 2

/datum/wires/breakerbox/UpdatePulsed(var/index)
	switch(index)
		if(WIRE_TOGGLE)
			var/obj/machinery/power/breakerbox/B= holder
			var/on = B.on
			B.set_state(!on)

/datum/wires/breakerbox/UpdateCut(var/index, var/mended)
	var/obj/machinery/power/breakerbox/B = holder
	switch(index)
		if(WIRE_LOCK)
			if(!mended)
				B.update_locked = TRUE
			else
				B.update_locked = FALSE
/datum/wires/breakerbox/CanUse(var/mob/living/L)
	var/obj/machinery/power/breakerbox/B = holder
	if(B.panel_open)
		return TRUE
	return FALSE
