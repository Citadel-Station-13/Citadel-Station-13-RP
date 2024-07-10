/**
 * returns a knot cable that's on us if there is one
 */
/turf/proc/get_power_cable_node()
	for(var/obj/structure/wire/power_cable/W in src)
		if(W.d1 == 0)
			return W
