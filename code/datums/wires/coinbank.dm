/datum/wires/coinbank
	holder_type = /obj/machinery/coinbank
	wire_count = 3

var/const/COINBANK_WIRE_ELECTRIFY	= 1
var/const/COINBANK_WIRE_THROW		= 2

/datum/wires/coinbank/CanUse(var/mob/living/L)
	var/obj/machinery/coinbank/C = holder
	if(C.panel_open)
		return 1
	return 0

/datum/wires/coinbank/GetInteractWindow()
	var/obj/machinery/coinbank/C = holder
	. += ..()
	. += "<BR>The orange light is [C.seconds_electrified ? "off" : "on"].<BR>"
	. += "The red light is [C.shoot_inventory ? "off" : "blinking"].<BR>"

/datum/wires/coinbank/UpdatePulsed(var/index)
	var/obj/machinery/coinbank/C = holder
	switch(index)
		if(SMARTFRIDGE_WIRE_THROW)
			C.shoot_inventory = !C.shoot_inventory
		if(SMARTFRIDGE_WIRE_ELECTRIFY)
			C.seconds_electrified = 30

/datum/wires/coinbank/UpdateCut(var/index, var/mended)
	var/obj/machinery/coinbank/C = holder
	switch(index)
		if(COINBANK_WIRE_THROW)
			C.shoot_inventory = !mended
		if(COINBANK_WIRE_ELECTRIFY)
			if(mended)
				C.seconds_electrified = 0
			else
				C.seconds_electrified = -1
