//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/component/laser_designator_target
	/// allow weapons guidance
	var/allow_weapons_guidance = FALSE
	/// projecting rangefinder
	var/obj/item/rangefinder/projector
	/// we are visible
	var/visible

/datum/component/laser_designator_target/Initialize(obj/item/rangefinder/projector)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. & COMPONENT_INCOMPATIBLE)
		return
	src.projector = projector
	src.allow_weapons_guidance = projector.laser_weapons_guidance
	src.visible = projector.laser_visible

/datum/component/laser_designator_target/RegisterWithParent()
	parent.AddComponent(/datum/component/spatial_grid, SSspatial_grids.laser_designations)

/datum/component/laser_designator_target/UnregisterFromParent()
	for(var/datum/component/spatial_grid/grid_component in parent.GetComponents(/datum/component/spatial_grid))
		if(grid_component.grid == SSspatial_grids.laser_designations)
			qdel(grid_component)
			break

#warn impl - visibile dot if visible

/**
 * citadel rp's rangefinders / LDs work somewhat differently from CM's
 *
 * mostly because we're not balancing this for CAS, we're balancing this for utility functions
 *
 * short list:
 *
 * * the zoom works very differently
 * * LDs can track targets
 * * LDs are not usually visible to the target
 * * (backend) rangefinders are designed in a way to be usable as a component of another object, which is usually not what i do for this use case but whatever
 */
/obj/item/rangefinder
	name = "rangefinder"
	desc = "A handy pair of binoculars used to perform rangefinding."

	#warn sprite

	/// can be used as a rangefinder
	var/is_rangefinder = TRUE
	/// can be used as a laser designator
	var/is_designator = FALSE

	/// laser designation is not visible to target
	var/laser_visible = FALSE
	/// allow weapon guidance - if you turn this on without turning on laser_visible i will replace your eyelids with lemons
	var/laser_weapons_guidance = FALSE

#warn impl

/obj/item/rangefinder/laser_designator
	name = "laser designator"
	desc = "An upgraded rangefinder that can mark an entity with a laser beam visible from high altitude."

	#warn sprite

	is_designator = TRUE
