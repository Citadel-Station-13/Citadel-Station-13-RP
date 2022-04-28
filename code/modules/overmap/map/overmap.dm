/**
 * overmap datums
 */
/datum/overmap
	/// name
	var/name = "Overmap"
	/// desc
	var/desc = "???"

	// map physicality
	/// are we initialized
	var/initialized = FALSE
	/// our space reservation
	var/datum/turf_reservation/turf_reservation
	/// width
	var/width
	/// height
	var/height
	/// cached actual z
	var/cached_z
	/// cached actual x of start
	var/cached_x_start
	/// cached actual y of start
	var/cached_y_start
	/// cached actual x of end
	var/cached_x_end
	/// cached actual y of end
	var/cached_y_end

	// virtual locations
	/// our stellar location
	var/datum/stellar_location/stellar_location

	// entity stuff
	/// all entities in us
	var/list/atom/movable/overmap_object/entity/entities
	/// all ticking entities in us
	var/list/atom/movable/overmap_object/entity/ticking

/datum/overmap/New()
	stellar_location = new

/datum/overmap/Destroy()
	#warn unregister entities and move to nullspace
	#warn get rid of space
	if(stellar_location)
		QDEL_NULL(stellar_location)
	return ..()

/datum/overmap/proc/SetName(name)
	src.name = name
	stellar_location?.name = name

/datum/overmap/proc/SetDesc(desc)
	src.desc = desc
	stellar_location?.desc = desc

/datum/overmap/proc/Initialize(width, height, list/datum/overmap_generator/generators = list())
	src.width = width
	src.height = height
	Allocate()
	SetupBounds()
	SetupVisuals()
	Generate(generators)

/datum/overmap/proc/Allocate()
	if(turf_reservation)
		CRASH("Already allocated")
	#warn check bounds of width/height vs world maxx/maxy
	turf_reservation = SSmapping.RequestBlockReservation(width = width, height = height, type = /datum/turf_reservation/overmap, turf_type_override = /turf/overmap)
	if(!turf_reservation)
		CRASH("Failed to allocate.")
	cached_z = turf_reservation.bottom_left_coords[3]
	cached_x_start = turf_reservation.bottom_left_coords[1]
	cached_y_start = turf_reservation.bottom_left_coords[2]
	cached_x_end = turf_reservation.top_right_coords[1]
	cached_y_end = turf_reservation.top_right_coords[2]

/datum/overmap/proc/SetupBounds()
	ASSERT(turf_reservation)


/datum/overmap/proc/Generate(list/datum/overmap_generator/generators = list())

/datum/overmap/proc/SetupVisuals()

/datum/overmap/proc/RegisterEntity(atom/movable/overmap_object/entity/E)

/datum/overmap/proc/UnregisterEntity(atom/movable/overmap_object/entity/E)

/datum/overmap/proc/Tick(seconds)
	for(var/atom/movable/overmap_object/entity/E as anything in ticking)
		E.Tick(seconds)

/datum/overmap/proc/Recover()
	entities = list()
	ticking = list()
	#warn get all entities
	#warn check if they need to tick

/**
 * render a x/y as text "x, y units" (where units is probably l-s for light-seconds)
 */
/datum/overmap/proc/render_location(x, y)

/**
 * wrap x
 */
/datum/overmap/proc/wrap_x(x)

/**
 * wrap y
 */
/datum/overmap/proc/wrap_y()
