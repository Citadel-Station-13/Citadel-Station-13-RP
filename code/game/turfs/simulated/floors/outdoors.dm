/turf/simulated/outdoors
	name = "generic ground"
	desc = "Rather boring."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = null
	edge_blending_priority = 1
	outdoors = TRUE					// This variable is used for weather effects.
	can_dirty = FALSE				// Looks hideous with dirt on it.
	can_build_into_floor = TRUE
	baseturfs = /turf/simulated/outdoors/rocks

/turf/simulated/outdoors/Initialize(mapload)
	QUEUE_SMOOTH(src)
	return ..()

/turf/simulated/outdoors/mud
	name = "mud"
	icon_state = "mud_dark"
	edge_blending_priority = 3

/turf/simulated/outdoors/rocks
	name = "rocks"
	desc = "Hard as a rock."
	icon_state = "rock"
	edge_blending_priority = 1
	baseturfs = /turf/baseturf_bottom

/turf/simulated/outdoors/rocks/caves
	outdoors = FALSE

// Called by weather processes, and maybe technomancers in the future.
/turf/simulated/proc/chill()
	return

/turf/simulated/outdoors/chill()
	PlaceOnTop(/turf/simulated/snow, flags = CHANGETURF_PRESERVE_OUTDOORS|CHANGETURF_INHERIT_AIR)

/turf/simulated/snow/chill()
	return // Todo: Add heavy snow.

/turf/simulated/outdoors/ex_act(severity)
	switch(severity)
		// Outdoor turfs are less explosion resistant
		if(1)
			ScrapeAway(flags = CHANGETURF_INHERIT_AIR|CHANGETURF_PRESERVE_OUTDOORS)
		if(2)
			if(prob(66))
				ScrapeAway(flags = CHANGETURF_INHERIT_AIR|CHANGETURF_PRESERVE_OUTDOORS)
		if(3)
			if(prob(15))
				ScrapeAway(flags = CHANGETURF_INHERIT_AIR|CHANGETURF_PRESERVE_OUTDOORS)
