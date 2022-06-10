/obj/machinery/atmospherics/component/unary/oxygen_generator
	icon = 'icons/obj/atmospherics/oxygen_generator.dmi'
	icon_state = "intact_off"
	density = TRUE

	name = "Oxygen Generator"
	desc = ""

	dir = SOUTH
	initialize_directions = SOUTH

	var/on = TRUE

	var/oxygen_content = 10

/obj/machinery/atmospherics/component/unary/oxygen_generator/update_icon()
	if(node)
		icon_state = "intact_[on?("on"):("off")]"
	else
		icon_state = "exposed_off"

		on = FALSE

	return

/obj/machinery/atmospherics/component/unary/oxygen_generator/Initialize(mapload)
	. = ..()

	air_contents.volume = 50

/obj/machinery/atmospherics/component/unary/oxygen_generator/process(delta_time)
	. = ..()
	if(!on)
		return FALSE

	var/total_moles = air_contents.total_moles

	if(total_moles < oxygen_content)
		var/current_heat_capacity = air_contents.heat_capacity()

		var/added_oxygen = oxygen_content - total_moles

		air_contents.temperature = (current_heat_capacity*air_contents.temperature + 20*added_oxygen*T0C)/(current_heat_capacity+20*added_oxygen)
		air_contents.adjust_gas(/datum/gas/oxygen, added_oxygen)

		if(network)
			network.update = TRUE

	return TRUE
