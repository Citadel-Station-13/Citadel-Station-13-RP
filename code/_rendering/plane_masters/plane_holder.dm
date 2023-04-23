/datum/global_plane_holder

/datum/plane_holder
	/// plane masters by type
	var/list/masters
	/// map id, if not main map
	var/map_id

/datum/plane_holder/Destroy()
	QDEL_LIST_ASSOC_VAL(masters)
	return ..()

/datum/plane_holder/proc/generate()
	masters = list()

/datum/plane_holder/proc/sync()
	for(var/key in masters)
		sync_plane(masters[key])

/datum/plane_holder/proc/sync_plane(atom/movable/screen/plane_master/plane)
	plane.screen_loc = "[map_id? "[map_id]:" : ""]CENTER"

/datum/plane_holder/proc/screens()
	. = list()
	ensure()
	for(var/key in masters)
		. += masters[key]

/datum/plane_holder/proc/ensure()
	if(isnull(masters))
		generate()
		sync()

/datum/plane_holder/proc/apply(client/C)
	C.screen |= screens()

/datum/plane_holder/proc/remove(client/C)
	C.screen -= screens()

/datum/plane_holder/proc/by_type(path)
	RETURN_TYPE(/atom/movable/screen/plane_master)
	ensure()
	. = masters[path]
	if(isnull(.))
		CRASH("invalid fetch")

/datum/plane_holder/proc/sync_owner(client/C)
	set_fake_ambient_occlusion(C.is_preference_enabled(/datum/client_preference/ambient_occlusion))

/datum/plane_holder/proc/set_fake_ambient_occlusion(enabled)
	by_type(/atom/movable/screen/plane_master/objs).set_fake_ambient_occlusion(enabled)
	by_type(/atom/movable/screen/plane_master/mobs).set_fake_ambient_occlusion(enabled)

/**
 * What the mob perspective is in charge of
 */
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

/**
 * Client global planes
 */
/datum/plane_holder/client_global

/datum/plane_holder/client_global/generate()
	masters = list()
	for(var/atom/movable/screen/plane_master/path as anything in subtypesof(/atom/movable/screen/plane_master))
		if(initial(path.abstract_type) == path)
			continue
		if(!initial(path.client_global))
			continue
		var/atom/movable/screen/plane_master/creating = new path
		masters[path] = creating

/**
 * Parallax holder managed planes
 */
/datum/plane_holder/parallax

/datum/plane_holder/parallax/generate()
	masters = list()
	masters[/atom/movable/screen/plane_master/parallax] = new /atom/movable/screen/plane_master/parallax
	masters[/atom/movable/screen/plane_master/space] = new /atom/movable/screen/plane_master/space

/**
 * TGUI camera consoles make these
 */
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

/**
 * All planes
 */
/datum/plane_holder/everything

/datum/plane_holder/everything/generate()
	masters = list()
	for(var/atom/movable/screen/plane_master/path as anything in subtypesof(/atom/movable/screen/plane_master))
		if(initial(path.abstract_type) == path)
			continue
		var/atom/movable/screen/plane_master/creating = new path
		masters[path] = creating
