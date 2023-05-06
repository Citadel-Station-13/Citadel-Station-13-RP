
/datum/supply_pack
	// the contained
	/// what we contain - list of typepaths associated to count. if no count is associated, it's assumed to be one.
	var/list/contains

/**
 * generates our HTML manifest as a **list**
 *
 * argument is provided for container incase you want to modify based on what actually spawned
 */
/datum/supply_pack/proc/get_html_manifest(atom/movable/container)
	RETURN_TYPE(/list)
	var/list/lines = list()
	lines += "Contents:<br>"
	lines += "<ul>"
	for(var/path in contains)
		var/amount = contains[path] || 1
		var/atom/movable/AM = path
		var/name = initial(AM.name)
		lines += "<li>[amount > 1? "[amount] [name](s)" : "[name]"]</li>"
	lines += "</ul>"
	return lines

	// ^\s+to_chat\(world\s*,\s*"[a-zA-Z0-9 .\[\]_]*"\)\n

/**
 * returns if we're random. if we are, return number of items.
 * required for old nanoui
 * this proc's existence, as well as hardcoded ui data for packs, really makes me hate life
 * but i'm not doing nanoui/tgui conversion today.
 */
/datum/supply_pack/proc/is_random()
	return FALSE

/**
 * gets a list of things to show on nanoui
 * god, i hate nanoui
 * burn this proc and is_random() with fire at some point, please.
 */
/datum/supply_pack/proc/flattened_nanoui_manifest()
	. = list()
	for(var/path in contains)
		var/amount = contains[path] || 1
		var/atom/movable/AM = path
		var/name = initial(AM.name)
		. += "[amount > 1? "[amount] [name](s)" : "[name]"]"

/datum/supply_pack/randomised/get_html_manifest(atom/movable/container)
	var/list/lines = list()
	lines += "Contains any [num_contained] of the following:<br>"
	lines += "<ul>"
	for(var/path in contains)
		var/amount = contains[path] || 1
		var/atom/movable/AM = path
		var/name = initial(AM.name)
		lines += "<li>[amount > 1? "[amount] [name](s)" : "[name]"]</li>"
	lines += "</ul>"
	return lines


/datum/supply_pack/randomised/is_random()
	return num_contained
