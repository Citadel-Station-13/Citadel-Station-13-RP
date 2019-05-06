//The turfs of the overmap's real space representation.
/turf/space/overmap
	name = "space"
	var/datum/overmap/map

/turf/space/overmap/Destroy()
	map?.overmap_turf_destroy(src)
	return ..()
