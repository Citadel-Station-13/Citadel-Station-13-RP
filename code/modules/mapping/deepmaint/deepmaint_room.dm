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
	/// index in the generation - 1 = we are the first room to be placed, etc
	var/index

/**
 * return list coordinates of center
 */
/datum/deepmaint_room/proc/Center()
	#warn impl
