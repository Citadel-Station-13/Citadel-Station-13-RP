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
	var/display_tile_icon = 'icons/overmaps/hazards.dmi'
	/// icon state this uses - can be a list to pick().
	var/display_tile_icon_state = ""

	// simulation
	/// when flattening scale to a severity multiplier, this is min amount
	var/multiplier_min = 0.01
	/// when flattening scale to a severity multiplier, this is max amount
	var/multiplier_max = 100
	/// modify the end multiplier by this much
	var/multiplier_add = 0
	/// multiply the end modifier by this much, goes before add
	var/multiplier_mod = 1

/**
 * scale is logarithmic
 */
/datum/overmap_hazard/proc/tick(atom/movable/overmap_object/entity/E, scale, seconds)

/datum/overmap_hazard/proc/cares_about(atom/movable/overmap_object/entity/E, scale)
	return E.is_instantiated()

/datum/overmap_hazard/proc/resolve_severity(scale)
	return clamp(((10 ** scale) * multiplier_mod) + multiplier_add, multiplier_min, multiplier_max)

/atom/movable/overmap_object/tiled/hazard

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

/atom/movable/overmap_object/tiled/hazard/single/Initialize(mapload, defer_smoothing)
	if(hazard_id)
		set_hazard(hazard_id)
	return ..()

/atom/movable/overmap_object/tiled/hazard/single/update_name()
	. = ..()
	name = hazard_ref?.display_name || "???"

/atom/movable/overmap_object/tiled/hazard/single/update_icon_state()
	. = ..()
	icon = hazard_ref?.display_tile_icon || 'icons/overmaps/hazards.dmi'
	icon_state = hazard_ref?.display_tile_icon_state || ""

/atom/movable/overmap_object/tiled/hazard/single/update_appearance()
	update_hazard_ref()
	return ..()

/atom/movable/overmap_object/tiled/hazard/single/is_similar(atom/movable/overmap_object/tiled/hazard/other)
	return other.hazard_id == hazard_id

/atom/movable/overmap_object/tiled/hazard/single/proc/update_hazard_ref()
	if(hazard_ref || !hazard_id)
		return
	hazard_ref = SSovermaps.resolve_hazard(hazard_id)

/atom/movable/overmap_object/tiled/hazard/single/proc/set_hazard(id)
	hazard_id = id
	update_hazard_ref()
	update_appearance()

/atom/movable/overmap_object/tiled/hazard/single/Crossed(atom/movable/AM)
	if(!hazard_ref)
		return ..()
	if(!istype(AM, /atom/movable/overmap_object/entity))
		return ..()
	var/atom/movable/overmap_object/entity/E = AM
	if(!hazard_ref.cares_about(E))
		return ..()
	E.register_hazard(hazard_id, hazard_scale, src)
	return ..()

/atom/movable/overmap_object/tiled/hazard/single/Uncrossed(atom/movable/AM)
	if(!hazard_id)
		return ..()
	if(!istype(AM, /atom/movable/overmap_object/entity))
		return ..()
	var/atom/movable/overmap_object/entity/E = AM
	E.unregister_hazard(hazard_id, src)
	return ..()

/atom/movable/overmap_object/tiled/hazard/single/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, hazard_id) || var_name == NAMEOF(src, hazard_scale))
		// lmfao
		for(var/atom/movable/AM in bounds(src, 0))
			Uncrossed(AM)
		hazard_ref = null
	. = ..()
	if(var_name == NAMEOF(src, hazard_id) || var_name == NAMEOF(src, hazard_scale))
		update_hazard_ref()
		for(var/atom/movable/AM in bounds(src, 0))
			Crossed(AM)
