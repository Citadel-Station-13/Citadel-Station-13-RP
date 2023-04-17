/datum/global_plane_holder

/datum/plane_holder
	/// plane masters by type
	var/list/masters

/datum/plane_holder/proc/generate()
	masters = list()
	for(var/atom/movable/screen/plane_master/path as anything in subtypesof(/atom/movable/screen/plane_master))
		var/atom/movable/screen/plane_master/creating = new path
		masters[path] = creating

/datum/plane_holder/proc/screens()
	. = list()
	for(var/key in masters)
		. += masters[key]
