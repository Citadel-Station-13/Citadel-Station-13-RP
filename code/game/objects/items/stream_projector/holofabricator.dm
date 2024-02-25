//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//? initialized by SSearly_init due to icon ops
//  maybe a serializable/persistable repository someday idfk
GLOBAL_LIST_EMPTY(holofabricator_templates)

/proc/init_holofabricator_templates()
	var/list/built = list()
	GLOB.holofabricator_templates = built
	for(var/datum/holofabricator_template/path as anything in subtypesof(/datum/holofabricator_template))
		if(initial(path.abstract_type) == path)
			continue
		var/datum/holofabricator_template/creating = new path
		creating.initialize()
		built += creating
	tim_sort(built, /proc/cmp_holofabricator_templates)

#define HOLOFABRICATOR_MODE_CONSTRUCT 1
#define HOLOFABRICATOR_MODE_REPAIR 2
#define HOLOFABRICATOR_MODE_DECONSTRUCT 3

/**
 * new RCDs
 */
/obj/item/stream_projector/holofabricator

	#warn impl

	/// selected template
	var/datum/holofabricator_template/selected_template


#warn impl all

/proc/cmp_holofabricator_templates(datum/holofabricator_template/A, datum/holofabricator_template/B)
	if(A.priority != B.priority)
		return B.priority - A.priority
	return sorttext(A.name, B.name)

/**
 * rcd templates
 */
/datum/holofabricator_template
	/// our name
	var/name = "unkw (?)"
	/// templates are sorted by priority, ascending, then name
	var/priority = 0
	/// tgui module to load for options
	var/tgui_module = "HolofabTemplateSimple"

/**
 * initializes and generates icons
 */
/datum/holofabricator_template/proc/initialize()
	#warn impl

#warn impl all

/datum/holofabricator_template/wall
	name = "Walls"

/datum/holofabricator_template/floor
	name = "Floors"

/datum/holofabricator_template/structure
	name = "Structure"
	priority = 10

/datum/holofabricator_template/airlock
	name = "Airlock"

/datum/holofabricator_template/standing_frame
	name = "Frame (Floor)"

/datum/holofabricator_template/wall_frame
	name = "Frame (wall)"

/datum/holofabricator_template/window
	name = "Window"

/datum/holofabricator_template/divider
	name = "Dividers"

#undef HOLOFABRICATOR_MODE_CONSTRUCT
#undef HOLOFABRICATOR_MODE_DECONSTRUCT
#undef HOLOFABRICATOR_MODE_REPAIR
