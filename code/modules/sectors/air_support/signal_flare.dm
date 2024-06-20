//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/obj/item/signal_flare
	name = "signal flare"
	desc = "A specialized flare used for signalling. Burns at specific frequency and projects a signal visible from high altitudes."
	#warn sprite

	var/ignited = FALSE
	var/ready = FALSE
	var/warmup_time = 20 SECONDS
	var/burn_time = 5 MINUTES
	#warn impl

/obj/item/signal_flare/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/spatial_grid, SSspatial_grids.signal_flares)

/obj/item/signal_flare/proc/ignite()
	if(ignited)
		return
	ignited = TRUE
	addtimer(CALLBACK(src, ready), warmup_time)
	addtimer(CALLBACK(src, fizzle), burn_time)

/obj/item/signal_flare/proc/ready()
	if(!ignited)
		return
	ready = TRUE
	#warn message

/obj/item/signal_flare/proc/fizzle()
	#warn message
	qdel(src)

#warn impl
#warn let you quench it / destroy it

