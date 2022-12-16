//! these usually do shallow lookups
//! we do not get_turf

/proc/station_apcs()
	. = list()
	for(var/obj/machinery/power/apc/A in GLOB.apcs)
		if(!A.z || !SSmapping.level_trait(A.z, ZTRAIT_STATION))
			continue
		. += A

/proc/station_smes()
	. = list()
	for(var/obj/machinery/smes/S in GLOB.machines)
		if(!S.z || !SSmapping.level_trait(S.z, ZTRAIT_STATION))
			continue
		. += S

/proc/station_cameras()
	. = list()
	for(var/obj/machinery/camera/C in GLOB.machines)
		if(!C.z || !SSmapping.level_trait(C.z, ZTRAIT_STATION))
			continue
		. += C

/proc/station_ventcrawl_vents()
	. = list()
	for(var/obj/machinery/atmospherics/component/unary/vent_pump/P in GLOB.machines)
		if(P.welded)
			continue
		if(!P.network)
			continue
		if(!P.z || !SSmapping.level_trait(P.z, ZTRAIT_STATION))
			continue
		. += P

/proc/station_ventcrawl_scrubbers()
	. = list()
	for(var/obj/machinery/atmospherics/component/unary/vent_scrubber/P in GLOB.machines)
		if(P.welded)
			continue
		if(!P.network)
			continue
		if(!P.z || !SSmapping.level_trait(P.z, ZTRAIT_STATION))
			continue
		. += P

/proc/station_ventcrawl_components()
	. = list()
	for(var/obj/machinery/atmospherics/component/unary/vent_pump/P in GLOB.machines)
		if(P.welded)
			continue
		if(!P.network)
			continue
		if(!P.z || !SSmapping.level_trait(P.z, ZTRAIT_STATION))
			continue
		. += P
	for(var/obj/machinery/atmospherics/component/unary/vent_scrubber/P in GLOB.machines)
		if(P.welded)
			continue
		if(!P.network)
			continue
		if(!P.z || !SSmapping.level_trait(P.z, ZTRAIT_STATION))
			continue
		. += P
