/datum/wires/coinbank
	holder_type = /obj/machinery/coinbank
	wire_count = 3
	proper_name = "Coin Bank"

/datum/wires/coinbank/New(atom/_holder)
	wires = list(WIRE_ELECTRIFY, WIRE_THROW_ITEM)
	return ..()

/datum/wires/coinbank/interactable(mob/user)
	var/obj/machinery/coinbank/C = holder
	if(C.panel_open)
		return TRUE
	return FALSE

/datum/wires/coinbank/get_status()
	var/obj/machinery/coinbank/C = holder
	. = ..()
	. += "The orange light is [C.seconds_electrified ? "off" : "on"]."
	. += "The red light is [C.shoot_inventory ? "off" : "blinking"]."

/datum/wires/coinbank/on_pulse(wire)
	var/obj/machinery/coinbank/C = holder
	switch(wire)
		if(WIRE_THROW_ITEM)
			C.shoot_inventory = !C.shoot_inventory
		if(WIRE_ELECTRIFY)
			C.seconds_electrified = 30

/datum/wires/coinbank/on_cut(wire, mend)
	var/obj/machinery/coinbank/C = holder
	switch(wire)
		if(WIRE_THROW_ITEM)
			C.shoot_inventory = !mend
		if(WIRE_ELECTRIFY)
			if(mend)
				C.seconds_electrified = 0
			else
				C.seconds_electrified = -1
