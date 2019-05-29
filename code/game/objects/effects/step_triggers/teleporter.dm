/* Instant teleporter */

/obj/effect/step_trigger/teleporter
	var/teleport_x = 0	// teleportation coordinates (if one is null, then no teleport!)
	var/teleport_y = 0
	var/teleport_z = 0

/obj/effect/step_trigger/teleporter/trigger(atom/movable/AM)
	if(teleport_x && teleport_y && teleport_z)
		var/turf/T = locate(teleport_x, teleport_y, teleport_z)
		if(T)
			teleport_atom(AM, T)

/obj/effect/step_trigger/teleporter/proc/teleport_atom(atom/movable/AM, turf/T)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.pulling)
			var/atom/movable/P = L.pulling
			L.stop_pulling()
			P.forceMove(T)
			L.forceMove(T)
			L.start_pulling(P)
		else
			AM.forceMove(T)
	else
		AM.forceMove(T)

/* Random teleporter, teleports atoms to locations ranging from teleport_x - teleport_x_offset, etc */

/obj/effect/step_trigger/teleporter/random
	var/teleport_x_offset = 0
	var/teleport_y_offset = 0
	var/teleport_z_offset = 0

/obj/effect/step_trigger/teleporter/random/trigger(atom/movable/AM)
	if(teleport_x && teleport_y && teleport_z)
		var/turf/T = locate(teleport_x, teleport_y, teleport_z)
		if(!T)			//check if valid in world bounds
			return
		T = locate(
			rand(max(0, teleport_x - teleport_x_offset), min(world.maxx, teleport_x + teleport_x_offset)),
			rand(max(0, teleport_y - teleport_y_offset), min(world.maxy, teleport_y + teleport_y_offset)),
			rand(max(0, teleport_z - teleport_z_offset), min(world.maxz, teleport_z + teleport_z_offset))
		)
		teleport_atom(AM, T)

/* Teleporter that sends objects stepping on it to a specific landmark. */

/obj/effect/step_trigger/teleporter/landmark
	var/landmark_id

/obj/effect/step_trigger/teleporter/landmark/Initialize(mapload)
	. = ..()
	if(mapload)
		if(!landmark_id)
			stack_trace("Warning: Teleportation step trigger at [COORD(src)] that uses landmark ID target system does not have a set ID! Deleting!")
			return INITIALIZE_HINT_QDEL
		return INITIALIZE_HINT_LATELOAD

/obj/effect/step_trigger/teleporter/landmark/LateInitialize()
	if(!GLOB.landmarks_id_target[landmark_id])
		stack_trace("Warning: Teleportation step trigger at [COORD(src)] that uses landmark ID target system can't find its target landmark!")

/obj/effect/step_trigger/teleporter/landmark/trigger(atom/movable/AM)
	var/obj/effect/landmark/id_target/the_landmark = GLOB.landmarks_id_target[landmark_id]
	if(the_landmark)
		teleport_atom(AM, get_turf(the_landmark))

/obj/effect/step_trigger/teleporter/transition
	var/datum/space_level/zlevel
	var/zdir

/obj/effect/step_trigger/teleporter/transition/Destroy()
	zlevel.transition_effects["[zdir]"] -= src
	return ..()
