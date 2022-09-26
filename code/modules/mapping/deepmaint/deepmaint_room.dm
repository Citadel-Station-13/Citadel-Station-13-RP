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
	var/orientation = NORTH
	/// index in the generation - 1 = we are the first room to be placed, etc
	var/index
	/// did we spawn yet
	var/loaded = FALSE
	/// our loaded bounds, if we're loaded
	var/list/loaded_bounds

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
