/**
 * datum for holding the pattern we need to do the spawning of a deepmaint room
 */
/datum/deepmaint_room
	/// x - lower left
	var/x
	/// y - lower left
	var/y
	/// z - lower left
	var/z
	/// width
	var/width
	/// height
	var/height
	/// depth
	var/depth
	/// path to deepmaint template
	var/datum/map_template/submap/deepmaint/template
	/// which way to rotate the map
	var/orientation = SOUTH
	/// index in the generation - 1 = we are the first room to be placed, etc
	var/index
	/// did we spawn yet
	var/loaded = FALSE
	/// our loaded bounds, if we're loaded
	var/list/loaded_bounds

/datum/deepmaint_room/New(datum/map_template/submap/deepmaint/template, orientation = NORTH)
	src.template = template
	SetOrientation(orientation)

#warn impl

/**
 * set location of lower left
 */
/datum/deepmaint_room/proc/SetLocationAbsolute(x, y, z)
	ASESRT(!loaded)
	src.x = x
	src.y = y
	src.z = z

/**
 * set location of center
 */
/datum/deepmaint_room/proc/SetLocationCenter(x, y, z)
	var/translated_x
	var/translated_y
	var/translated_z
	#warn common #defines to manage translations for both map templates and this?
	return SetLocationAbsolute(translated_x, translated_y, translated_z)

/**
 * set orientation
 */
/datum/deepmaint_room/proc/SetOrientation(orientation)
	ASSERT(!loaded)
	src.orientation = orientation
	UpdateBoundingBox()

/**
 * updates width/height/depth
 */
/datum/deepmaint_room/proc/UpdateBoundingBox()
	#warn implw

/**
 * spawn us in
 */
/datum/deepmaint_room/proc/Load()
	ASSERT(!loaded)
	template.load(locate(x, y, z), orientation)
	loaded = TRUE

/**
 * return list coordinates of center
 */
/datum/deepmaint_room/proc/Center()
	#warn impl

/**
 * check if we're overlapping another
 */
/datum/deepmaint_room/proc/Overlaps(datum/deepmaint_room/other)

/**
 * get center distance to other
 */
/datum/deepmaint_room/proc/CenterDistance(datum/deepmaint_room/other)

/**
 * get edge distance to other
 */
/datum/deepmaint_room/proc/EdgeDistance(datum/deepmaint_room/other)
