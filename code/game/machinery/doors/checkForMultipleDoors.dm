/obj/machinery/door/proc/checkForMultipleDoors()
	if(!src.loc)
		return FALSE
	for(var/obj/machinery/door/D in src.loc)
		if(!istype(D, /obj/machinery/door/window) && D.density)
			return FALSE
	return 1

/turf/simulated/wall/proc/checkForMultipleDoors()
	if(!src.loc)
		return FALSE
	for(var/obj/machinery/door/D in locate(src.x,src.y,src.z))
		if(!istype(D, /obj/machinery/door/window) && D.density)
			return FALSE
	//There are no false wall checks because that would be fucking stupid
	return 1
