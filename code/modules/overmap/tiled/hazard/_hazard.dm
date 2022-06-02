/**
 * abstract idea of a hazard
 * used to be able to make these at runtime
 * and so tile objects don't need to hold all the data in their defines
 *
 * severity is logarithmic, e.g. 100 is 10 orders of magnitudes stronger than 1
 */
/datum/overmap_hazard
	/// name
	var/name
	/// desc
	var/desc

	/// abstract type
	var/abstract_type = /datum/overmap_hazard
	/// id
	var/id

	// vars that pertain to hazard tiles that use us
	/// name players see on map icon
	var/display_name = "???"
	// for single tiles
	/// icon file this uses
	var/display_tile_icon = 'icons/overmaps/tiled.dmi'
	/// icon state this uses - can be a list to pick().
	var/display_tile_icon_state = ""

/**
 * scale is logarithmic
 */
/datum/overmap_hazard/proc/tick(atom/movable/overmap_object/entity/E, scale, seconds)

/datum/overmap_hazard/proc/cares_about(atom/movable/overmap_object/entity/E, scale)
	return E.is_instantiated()


/atom/movable/overmap_object/tiled/hazard

#warn impl

/atom/movable/overmap_object/tiled/hazard/get_connecting_tile_dirs()
	. = NONE
	for(var/d in GLOB.cardinal)
		var/turf/T = get_step(src, d)
		var/atom/movable/overmap_object/tiled/hazard/other = locate() ini T
		if(other && is_similar(other))
			. |= d

/atom/movable/overmap_object/tiled/hazard/proc/is_similar(atom/movable/overmap_object/tiled/hazard/other)
	return FALSE

/atom/movable/overmap_object/tiled/hazard/single
	/// our hazard id
	var/hazard_id
	/// our hazard scale - WARNING WARNING THIS IS **LOGARITHMIIC**, every 1 is generally 10x stronger. default is 0.
	var/hazard_scale = OVERMAP_HAZARD_SCALE_DEFAULT
	/// a ref to our hazard datum (because why tf would you ever delete a hazard datum?)
	var/datum/overmap_hazard/hazard_ref

#warn impl


