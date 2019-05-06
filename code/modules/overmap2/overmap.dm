//Overmap datum that holds the "virtual form" of the physical overmap area.
/datum/overmap
	var/datum/turf_reservation/realspace_reservation
	var/list/datum/overmap_entity/entities
	var/list/atom/movable/overmap_object/objects
	var/list/turf/space/overmap_turf/realspace_turfs
	var/size_x
	var/size_y
	var/allocated = FALSE

/datum/overmap/New()
	entities = list()
	objects = list()
	turfs = list()

/datum/overmap/Destroy()
	//TODO: Handle entity/object GC.
	. = ..()
	QDEL_NULL(realspace_reservation)

/datum/overmap/proc/initialize_allocation(sx, sy)
	if(allocated)
		return


/datum/overmap/proc/overmap_turf_destroy(turf/space/overmap_turf/T)
	realspace_turfs -= T
	if(!QDELETING(src))
		stack_trace("Huh?! An overmap turf was destroyed/deallocated without the map being destroyed. This'll likely cause problems!")
