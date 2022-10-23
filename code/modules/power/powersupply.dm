/**
 * This file contains a subtype of machinery/power, that is used by other machinery as an interior object
 */
/obj/machinery/power/powersupply
    name = "power supply"
    desc = "An interior component of another machine meant to supply it with power."

/obj/machinery/power/powersupply/connect_to_network()
	var/turf/T = src.loc.loc//double loc, first loc is the machine we are in, second one gives us the turf of the machine we are in
	if(!T || !istype(T))
		return 0

	var/obj/structure/cable/C = T.get_cable_node() //check if we have a node cable on the machine turf, the first found is picked
	if(!C || !C.powernet)
		return 0

	C.powernet.add_machine(src)
	return 1
