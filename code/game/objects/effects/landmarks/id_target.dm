//landmarks meant to be kept around and accessed associatively for targets like teleportation etc etc.
GLOBAL_LIST_EMPTY(landmarks_id_target)

/obj/effect/landmark/id_target
	var/landmark_id
	var/static/next_id = 1

/obj/effect/landmark/id_target/Initialize(mapload)
	. = ..()
	if(!landmark_id)
		if(mapload)
			stack_trace("Warning: ID target landmark at mapload without an ID! This should never happen outside of admin fuckups!")
			return INITIALIZE_HINT_QDEL
		else
			landmark_id = next_id++
	if(GLOB.landmarks_id_target[landmark_id])
		stack_trace("Warning: ID target landmark collision at [COORD(src)] with ID [landmark_id]!")
		return INITIALIZE_HINT_QDEL
	else
		GLOB.landmarks_id_target[landmark_id] = src

/obj/effect/landmark/id_target/Destroy()
	GLOB.landmarks_id_target -= landmark_id
	return ..()

/obj/effect/landmark/id_target/vv_edit_var(var_name, var_value)
	var/old_landmark_id
	var/editing_id = var_name == NAMEOF(src, landmark_id)
	if(editing_id)
		old_landmark_id = landmark_id
	. = ..()
	if(.)
		if(editing_id)
			GLOB.landmarks_id_target -= old_landmark_id
			GLOB.landmarks_id_target[landmark_id] = src
