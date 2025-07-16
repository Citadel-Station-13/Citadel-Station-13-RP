/**
 * outdoors floor types
 */
/turf/simulated/floor/outdoors
	name = "generic ground"
	desc = "Rather boring."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = null
	edge_blending_priority = 1
	outdoors = TRUE
	can_dirty = FALSE
	can_build_into_floor = TRUE
	baseturfs = /turf/simulated/floor/outdoors/rocks

/turf/simulated/floor/outdoors/mud
	name = "mud"
	icon_state = "mud_dark"

CREATE_STANDARD_TURFS(/turf/simulated/floor/outdoors/mud)
/turf/simulated/floor/outdoors/rocks
	name = "rocks"
	desc = "Hard as a rock."
	icon_state = "rock"
	baseturfs = /turf/baseturf_bottom

CREATE_STANDARD_TURFS(/turf/simulated/floor/outdoors/rocks)
/turf/simulated/floor/outdoors/rocks/caves
	outdoors = FALSE

// Called by weather processes, and maybe technomancers in the future.
/turf/simulated/floor/proc/chill()
	if(outdoors)
		PlaceOnTop(/turf/simulated/floor/outdoors/snow, flags = CHANGETURF_PRESERVE_OUTDOORS|CHANGETURF_INHERIT_AIR)

/turf/simulated/floor/outdoors/legacy_ex_act(severity)
	if(integrity_flags & INTEGRITY_INDESTRUCTIBLE)
		return
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
