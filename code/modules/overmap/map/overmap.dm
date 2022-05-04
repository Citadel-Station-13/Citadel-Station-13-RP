/**
 * overmap datums
 *
 * an explanation of how overmaps coordinates works:
 * since we use byond for half of our physics backend and to render,
 * everything is on the byond world
 *
 * therefore, every entity, tiled or simulated, has 3 sets of coordinates
 * - byond coordinates, including x, y, step_x, step_y (currently pixel_x pixel_y until we do pixel movement)
 * - overmaps coordinates, which is OVERMAP_DISTANCE_PIXEL times pixels from bottomleft - so currently 32 * 3 per tile
 * - player-facing coordinates. this is +- some value, and the exact coodinate center of the overmap is treated as the center
 * 	so if your overmap is, say, 9600x9600 (100x100 overmap), 4800, 4800 would be the "center", and someone at 1, 1 would have their
 * 	coordinates rendered as -4799, -4799
 *
 * furthermore, wraparound is a thing, so use spatial_ops.dm procs to get dist for accuracy! otherwise things
 * won't take into account wraparound and so on/so forth.
 */
/datum/overmap
	/// name
	var/name = "Overmap"
	/// desc
	var/desc = "???"
	/// id
	var/id
	/// next id
	var/static/id_next = 0

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
	/// cached size in overmaps coordinates
	var/cached_coordinate_width
	/// cached size in overmaps coordinates
	var/cached_coordinate_height
	/// cached coordinate of center
	var/cached_coordinate_center_x
	/// cached coordinate of center
	var/cached_coordinate_center_y
	/// cached bottomleft first absolute byond pixel
	var/cached_bottomleft_pixel_x
	/// cached bottomleft first absolute byond pixel
	var/cached_bottomleft_pixel_y
	/// cached byond pixel size
	var/cached_pixel_width
	/// cached byond pixel size
	var/cached_pixel_height

	// virtual locations
	/// our stellar location
	var/datum/stellar_location/stellar_location

	// entity stuff
	/// all entities in us
	var/list/atom/movable/overmap_object/entity/entities
	/// all ticking entities in us
	var/list/atom/movable/overmap_object/entity/ticking
	/// all moving entities in us
	var/list/atom/movable/overmap_object/entity/moving
	/// entity spatial hash <DANGER DANGER DO NOT TOUCH THIS UNLESS YOU KNOW WHAT YOU ARE DOING>
	var/list/spatial_hash
	/// spatial hash width
	var/spatial_hash_width
	/// spatial hash height
	var/spatial_hash_height

/datum/overmap/New()
	id = "[++id_next]"
	stellar_location = new
	entities = list()
	ticking = list()
	moving = list()

/datum/overmap/Destroy()
	#warn unregister entities and move to nullspace
	initialized = FALSE
	spatial_hash = null
	if(turf_reservation)
		QDEL_NULL(turf_reservation)
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
	SetupSpatialHash()
	Generate(generators)

/datum/overmap/proc/Generate(list/datum/overmap_generator/generators = list())

/datum/overmap/proc/RegisterEntity(atom/movable/overmap_object/entity/E)

/datum/overmap/proc/UnregisterEntity(atom/movable/overmap_object/entity/E)

#warn redo this it should be for non physics ticks
/datum/overmap/proc/Tick(seconds)
	for(var/atom/movable/overmap_object/entity/E as anything in ticking)
		E.Tick(seconds)

/**
 * ticks physics of all entities in us
 */
/datum/overmap/proc/PhysicsTick(seconds)
	for(var/atom/movable/overmap_object/entity/E as anything in moving)
		E.PhysicsTick(seconds)

#warn admin simulation pause

/datum/overmap/proc/Recover()
	entities = list()
	ticking = list()
	SetupSpatialHash()
	#warn get all entities
	#warn check if they need to tick

/**
 * render a x/y as text "x, y units" (where units is probably l-s for light-seconds)
 */
/datum/overmap/proc/render_location(x, y)
