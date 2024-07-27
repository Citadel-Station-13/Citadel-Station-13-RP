
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
