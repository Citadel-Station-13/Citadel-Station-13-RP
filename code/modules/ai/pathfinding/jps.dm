//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/ai_pathfinder/jps

/datum/ai_pathfinder/jps/search(atom/movable/agent, atom/source, atom/destination, limit, within, slack)
	#warn implement slack
	var/list/path = SSpathfinder.get_path_jps(
		agent,
		source,
		destination,
		within,
		limit,
	)
	if(isnull(path))
		return null
	return new /datum/ai_pathing(path, TRUE)
