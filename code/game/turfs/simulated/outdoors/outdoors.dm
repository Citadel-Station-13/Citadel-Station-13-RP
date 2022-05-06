var/list/turf_edge_cache = list()

/turf/
	// If greater than 0, this turf will apply edge overlays on top of other turfs cardinally adjacent to it, if those adjacent turfs are of a different icon_state,
	// and if those adjacent turfs have a lower edge_blending_priority.
	var/edge_blending_priority = 0
	// Outdoors var determines if the game should consider the turf to be 'outdoors', which controls certain things such as weather effects.
	var/outdoors = FALSE

/turf/simulated/floor/outdoors
	name = "generic ground"
	desc = "Rather boring."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = null
	edge_blending_priority = 1
	outdoors = TRUE					// This variable is used for weather effects.
	can_dirty = FALSE				// Looks hideous with dirt on it.
	can_build_into_floor = TRUE
	baseturfs = /turf/simulated/floor/outdoors/rocks

/turf/simulated/floor/outdoors/Initialize(mapload)
	update_icon()
	. = ..()

/turf/simulated/floor/Initialize(mapload)
	. = ..()
	if(outdoors)
		SSplanets.addTurf(src)

/turf/simulated/floor/Destroy()
	if(outdoors)
		SSplanets.removeTurf(src)
	return ..()

/turf/simulated/proc/make_outdoors()
	outdoors = TRUE
	SSplanets.addTurf(src)

/turf/simulated/proc/make_indoors()
	outdoors = FALSE
	SSplanets.removeTurf(src)

/turf/simulated/AfterChange(flags, oldType)
	. = ..()
	// If it was outdoors and still is, it will not get added twice when the planet controller gets around to putting it in.
	if(outdoors)
		make_outdoors()
	else
		make_indoors()

/turf/simulated/floor/outdoors/update_icon()
	..()
	update_icon_edge()

/turf/simulated/floor/outdoors/mud
	name = "mud"
	icon_state = "mud_dark"
	edge_blending_priority = 3

/turf/simulated/floor/outdoors/rocks
	name = "rocks"
	desc = "Hard as a rock."
	icon_state = "rock"
	edge_blending_priority = 1
	baseturfs = /turf/baseturf_bottom

/turf/simulated/floor/outdoors/rocks/caves
	outdoors = FALSE

// Called by weather processes, and maybe technomancers in the future.
/turf/simulated/floor/proc/chill()
	return

/turf/simulated/floor/outdoors/chill()
	PlaceOnTop(/turf/simulated/floor/outdoors/snow, flags = CHANGETURF_PRESERVE_OUTDOORS|CHANGETURF_INHERIT_AIR)

/turf/simulated/floor/outdoors/snow/chill()
	return // Todo: Add heavy snow.

/turf/simulated/floor/outdoors/ex_act(severity)
	switch(severity)
		//VOREStation Edit - Outdoor turfs less explosion resistant
		if(1)
			ScrapeAway(flags = CHANGETURF_INHERIT_AIR|CHANGETURF_PRESERVE_OUTDOORS)
		if(2)
			if(prob(66))
				ScrapeAway(flags = CHANGETURF_INHERIT_AIR|CHANGETURF_PRESERVE_OUTDOORS)
		//VOREStation Edit End
		if(3)
			if(prob(15))
				ScrapeAway(flags = CHANGETURF_INHERIT_AIR|CHANGETURF_PRESERVE_OUTDOORS)
