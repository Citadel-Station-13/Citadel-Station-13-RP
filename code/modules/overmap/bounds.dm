// file contains helpers for bounds visualization
/datum/controller/subsystem/overmaps
	var/static/list/entity_bounds_overlay_cache = list()
	var/static/list/tiled_bounds_overlay_cache = list()

/datum/controller/subsystem/overmaps/proc/entity_bounds_overlay(bound_x, bound_y, bound_width, bound_height, color)
	var/key
#warn impl

/datum/controller/subsystem/overmaps/proc/tiled_bounds_overlay(directions)

#warn impl

/atom/movable/overmap_object/proc/get_bounds_overlay()
	return

/atom/movable/overmap_object/proc/cut_bounds_overlay()
	if(bounds_overlay)
		cut_overlay(bounds_overlay)
		bounds_overlay = null

/atom/movable/overmap_object/proc/add_bounds_overlay()
	if(bounds_overlay)
		cut_bounds_overlay()
	bounds_overlay = get_bounds_overlay()
	if(bounds_overlay)
		add_overlay(bounds_overlay)
