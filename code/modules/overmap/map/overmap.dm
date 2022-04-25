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
	var/datum/space_reservation/space_reservation
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

/datum/overmap/proc/Allocate()

/datum/overmap/proc/SetupBounds()

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
