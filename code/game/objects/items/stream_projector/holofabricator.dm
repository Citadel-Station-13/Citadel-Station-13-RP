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
ITEM_AUTO_BINDS_SINGLE_INTERFACE_TO_VAR(/obj/item/stream_projector/holofabricator, interface)
/obj/item/stream_projector/holofabricator
	name = "holofabricator"
	desc = "A precise triage tool used by many frontier engineers. Uses materials from a loaded cartridge \
	to rapidly fabricate a generated holotemplate."
	#warn icon

	// todo: proper cataloguing fluff desc system
	description_fluff = "Despite having been around for hundreds of years, holofabricators are still a novel, alpha-stage concept \
	being iterated upon by many scientists across the galaxy. While not as reliable as traditional methods of construction, they nonetheless \
	make for a coveted item on many installations due to the ease of which they can perform emergency triage and the rapid prototyping of rooms. \
	<br>A holofabricator constructs a prefab by generating a hardlight template with its guide projector, then filling it \
	in with confined particular beams. Unfortunately, the resulting fabrication tends to be noticeably less weaker than \
	a conventional construction of the same design - it seems science has yet to nullify one of the core weaknesses of \
	3d-printing technologies. \
	<br>Deconstruction is performed instead by abrasively blasting a target with a particulate beam. Only some materials and \
	designs are weak enough to be sliced apart this way; deconstructed matter can normally be recycled or disposed of as an installation \
	sees fit."

	#warn impl

	/// selected template
	var/datum/holofabricator_template/selected_template
	/// interface to draw from if provided
	var/datum/item_interface/interface

#warn impl all

/obj/item/stream_projector/holofabricator/examine(mob/user, dist)
	. = ..()
	. += SPAN_RED("Things constructed with holofabricators do not have the same structural integrity as things built by conventional means.")
	. += SPAN_RED("Transfer efficiency is lowered quadratically with a target's distance from the applied holofabricator.")

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
