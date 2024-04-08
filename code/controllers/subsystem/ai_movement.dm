//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Handles processing /datum/ai_movement's.
 */
SUBSYSTEM_DEF(ai_movement)
	name = "AI Movement"

	#warn impl

	var/list/ai_pathfinders

/datum/controller/subsystem/ai_movement/Initialize()
	#warn a

/datum/controller/subsystem/ai_movement/proc/init_ai_pathfinders()
	ai_pathfinders = list()
	for(var/datum/ai_pathfinder/path as anything in subtypesof(/datum/ai_pathfinder))
		if(initial(path.abstract_type) == path)
			continue
		ai_pathfinders[path] = new path
