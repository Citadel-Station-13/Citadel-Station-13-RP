/datum/global_plane_holder

/datum/plane_holder
	/// plane masters by type
	var/list/masters

/datum/plane_holder/proc/generate()
	masters = list()

/datum/plane_holder/proc/screens()
	. = list()
	ensure()
	for(var/key in masters)
		. += masters[key]

/datum/plane_holder/proc/ensure()
	if(isnull(masters))
		generate()

/datum/plane_holder/proc/by_type(path)
	RETURN_TYPE(/atom/movable/screen/plane_master)
	ensure()
	return masters[path]

/datum/plane_holder/proc/sync_owner(client/C)
	#warn AO

/datum/plane_holder/mob_perspective

/datum/plane_holder/mob_perspective/generate()
	masters = list()
	for(var/atom/movable/screen/plane_master/path as anything in subtypesof(/atom/movable/screen/plane_master))
		if(initial(path.abstract_type) == path)
			continue
		if(initial(path.client_global))
			continue
		var/atom/movable/screen/plane_master/creating = new path
		masters[path] = creating

/datum/plane_holder/parallax

/datum/plane_holder/parallax/generate()
	masters = list()
	masters[/atom/movable/screen/plane_master/parallax] = new /atom/movable/screen/plane_master/parallax
	masters[/atom/movable/screen/plane_master/space] = new /atom/movable/screen/plane_master/space

/datum/plane_holder/tgui_camera

/datum/plane_holder/tgui_camera/generate()
	masters = list()
	for(var/atom/movable/screen/plane_master/path as anything in subtypesof(/atom/movable/screen/plane_master))
		if(initial(path.abstract_type) == path)
			continue
		if(initial(path.special_managed))
			continue
		var/atom/movable/screen/plane_master/creating = new path
		masters[path] = creating

/datum/plane_holder/everything

/datum/plane_holder/everything/generate()
	masters = list()
	for(var/atom/movable/screen/plane_master/path as anything in subtypesof(/atom/movable/screen/plane_master))
		if(initial(path.abstract_type) == path)
			continue
		var/atom/movable/screen/plane_master/creating = new path
		masters[path] = creating
