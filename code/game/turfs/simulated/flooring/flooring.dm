// State values:
// [icon_base]: initial base icon_state without edges or corners.
// if has_base_range is set, append 0-has_base_range ie.
//   [icon_base][has_base_range]
// [icon_base]_broken: damaged overlay.
// if has_damage_range is set, append 0-damage_range for state ie.
//   [icon_base]_broken[has_damage_range]
// [icon_base]_edges: directional overlays for edges.
// [icon_base]_corners: directional overlays for non-edge corners.

/datum/prototype/flooring
	anonymous = TRUE
	anonymous_namespace = "flooring"

	//*                      Internal                       *//

	/// Set to TRUE by DECLARE_FLOORING macro. This is to signal to the system
	/// that certain optimizations only valid on new flooring declaration system
	/// can be made (like not eagerly setting turf variables already set by the define).
	var/__is_not_legacy = FALSE

	//*                  Direct Interpolation                     *//
	//* These variables are set on the preset turf automatically. *//

	/// Turf name override. directly interpolated into the turf's `name` variable.
	var/name = "floor"
	/// The icon to use
	var/icon
	/// The base icon state to use.
	///
	/// * This is also the preview state, so it must exist.
	var/icon_base
	/// Same z flags used for turfs, i.e ZMIMIC_DEFAULT etc.
	var/mz_flags = MZ_ATMOS_UP | MZ_OPEN_UP

	//*                      Appearance                     *//
	//* These variables are accessed as needed by the turf. *//

	/// Examine description. Read on runtime if the turf has a floor.
	var/desc

	//*                      Composition                    *//
	//* These variables are accessed as needed by the turf. *//

	/// Are we considered plating? Normally, floor is only plating if it's, well, un-floor'd,
	/// but plating-types are also valid types of flooring.
	var/is_plating = FALSE
	/// Flooring type we tear down to.
	///
	/// * This is a very dangerous variable. Much like a turf's baseturfs,
	///   but this is per-flooring-singleton instead of per-turf, upping the complexity
	///   of setting it.
	/// * This basically lets you setup flooring stacks, much like baseturfs, but with
	///   custom types of flooring.
	/// * If this is 'null' (which it will be usually), removing this flooring
	///   will tear down to plating.
	var/base_flooring

	//*                      Construction                   *//
	//* These variables are accessed as needed by the turf. *//

	/// product type to drop, if any. usually a `/obj/item/stack` path.
	///
	/// * Supports /obj/item/stack
	/// * Supports /datum/material
	/// * If this is not set, we will use `build_type` and `build_cost` instead.
	var/dismantle_product
	/// product amount to drop
	var/dismantle_product_amount = 1
	/// Material needed to build.
	///
	/// * Supports /obj/item/stack
	/// * Supports /datum/material
	///
	/// todo: as of right now, only a single floor can ever be allowed to be built in this way
	///       for a given stack or material id.
	///       at some point, we need to investigate having multiple possibilities
	/// todo: remove 'subtype build_type suppression' from New()
	var/build_type
	/// Amount of material needed to build.
	var/build_cost = 1
	/// Amount of time required to build us.
	var/build_time = 0 SECONDS
	/// TOOL_* or list of TOOL_* enums of what will cleanly dismantle us.
	///
	/// * Initialized to a list if it's not a list.
	var/list/dismantle_tool
	/// Time to dismantle with a tool.
	///
	/// * Initialized to a list if it's not a list.
	var/dismantle_time = 0 SECONDS
	/// TOOL_* or list of TOOL_* enums of what will destroy us.
	var/list/destroy_tool
	/// Time to destroy with a tool.
	var/destroy_time = 0 SECONDS
	/// Do we allow tile painters and similar decal appliers to paint us?
	var/can_paint_on = TRUE

	//*                    LEGACY BELOW                    *//

	var/has_base_range
	var/has_damage_range
	var/has_burn_range
	var/damage_temperature

	var/descriptor = "tiles"
	var/flooring_flags
	var/list/footstep_sounds = list() // key=species name, value = list of soundss
	var/list/flooring_cache = list() // Cached overlays for our edges and corners and junk

	//Flooring Icon vars

	//The rest of these x_smooth vars use one of the following options
	//SMOOTH_NONE: Ignore all of type
	//SMOOTH_ALL: Smooth with all of type
	//SMOOTH_WHITELIST: Ignore all except types on this list
	//SMOOTH_BLACKLIST: Smooth with all except types on this list
	//SMOOTH_GREYLIST: Objects only: Use both lists

	//How we smooth with other flooring
	var/floor_smooth = SMOOTH_NONE
	var/list/flooring_whitelist = list() //Smooth with nothing except the contents of this list
	var/list/flooring_blacklist = list() //Smooth with everything except the contents of this list

	//How we smooth with walls
	var/wall_smooth = SMOOTH_NONE
	//There are no lists for walls at this time

	//How we smooth with space and openspace tiles
	var/space_smooth = SMOOTH_NONE
	//There are no lists for spaces

	/*
	How we smooth with movable atoms
	These are checked after the above turf based smoothing has been handled
	SMOOTH_ALL or SMOOTH_NONE are treated the same here. Both of those will just ignore atoms
	Using the white/blacklists will override what the turfs concluded, to force or deny smoothing

	Movable atom lists are much more complex, to account for many possibilities
	Each entry in a list, is itself a list consisting of three items:
		Type: The typepath to allow/deny. This will be checked against istype, so all subtypes are included
		Priority: Used when items in two opposite lists conflict. The one with the highest priority wins out.
		Vars: An associative list of variables (varnames in text) and desired values
			Code will look for the desired vars on the target item and only call it a match if all desired values match
			This can be used, for example, to check that objects are dense and anchored
			there are no safety checks on this, it will probably throw runtimes if you make typos

	Common example:
	Don't smooth with dense anchored objects except airlocks

	smooth_movable_atom = SMOOTH_GREYLIST
	movable_atom_blacklist = list(
		list(/obj, list("density" = TRUE, "anchored" = TRUE), 1)
		)
	movable_atom_whitelist = list(
	list(/obj/machinery/door/airlock, list(), 2)
	)

	*/
	var/smooth_movable_atom = SMOOTH_NONE
	var/list/movable_atom_whitelist = list()
	var/list/movable_atom_blacklist = list()

/datum/prototype/flooring/New()
	..()
	if(!islist(dismantle_tool))
		dismantle_tool = dismantle_tool ? list(dismantle_tool) : list()
	if(!islist(destroy_tool))
		destroy_tool = destroy_tool ? list(destroy_tool) : list()
	// subtype build suppression
	// erase our build_type if our parent type defaults to it
	// this way only the first declaration on the tree of a certain build type applies
	if(ispath(parent_type, /datum/prototype/flooring))
		var/datum/prototype/flooring/parent = parent_type
		if(initial(parent.build_type) == build_type)
			build_type = null

/datum/prototype/flooring/proc/get_flooring_overlay(cache_key, base_state, icon_dir = 0, layer = FLOOR_DECAL_LAYER)
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = icon, icon_state = base_state, dir = icon_dir)
		I.layer = layer
		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]

/**
 * Drops our dismantled product.
 */
/datum/prototype/flooring/proc/drop_product(turf/location)
	var/effective_type
	var/effective_amount

	if(dismantle_product)
		effective_type = dismantle_product
		effective_amount = dismantle_product_amount
	else
		effective_type = build_type
		effective_amount = build_cost

	if(ispath(effective_type, /obj/item/stack))
		new effective_type(location, effective_amount)
	else if(istext(effective_type) || ispath(effective_type, /datum/prototype/material))
		var/datum/prototype/material/resolved_material = RSmaterials.fetch(effective_type)
		if(resolved_material)
			resolved_material.place_sheet(location, effective_amount)
	else
		if(effective_amount > 20)
			CRASH("attempted to make too many atoms during a floor dismantle product drop.")
		for(var/i in 1 to effective_amount)
			new effective_type(location)

