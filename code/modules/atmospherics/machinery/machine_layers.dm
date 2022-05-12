/**
 * If our pipe flags state to normalize cardinals, ensure that we're NORTH|SOUTH or EAST|WEST by normalizing to NORTH or EAST, instead of allowing all 4 directions.
 */
/obj/machinery/atmospherics/proc/NormalizeCardinalDirections()
	switch(dir)
		if(SOUTH)
			setDir(NORTH)
		if(WEST)
			setDir(EAST)

/**
 * Ensures our init directions are set properly
 */
/obj/machinery/atmospherics/proc/SetInitDirections()
	return

/**
 * Gets our init directions
 */
/obj/machinery/atmospherics/proc/GetInitDirections()
	return initialize_directions

/**
 * Modifies our piping layer.
 */
/obj/machinery/atmospherics/proc/SetPipingLayer(new_layer)
	if(!(CheckLocationConflict(loc, new_layer) != PIPE_LOCATION_CLEAR))
		CRASH("Attempted to set piping layer to a conflicting layer.")
	Leave()
	pipe_layer = (pipe_flags & PIPE_DEFAULT_LAYER_ONLY) ? PIPE_LAYER_DEFAULT : new_layer
	Join()
	update_appearance()

/**
 * Checks our current location for conflicts
 */
/obj/machinery/atmospherics/proc/CheckLocationConflict(turf/T = get_turf(src), layer = pipe_layer)
	var/turf_hogging = pipe_flags & PIPE_ONE_PER_TURF
	for(var/obj/machinery/atmospherics/A in T)
		if(A.pipe_flags & turf_hogging)
			return PIPE_LOCATION_TILE_HOGGED
		if((A.pipe_layer == pipe_layer) && (A.initialize_directions & initialize_directions))
			return PIPE_LOCATION_DIR_CONFLICT
	return PIPE_LOCATION_CLEAR

/**
 * Checks if a target pipe can be a node.
 */
/obj/machinery/atmospherics/proc/CanConnect(obj/machinery/atmospherics/other, node)
	return StandardConnectionCheck(other) && (pipe_flags & PIPE_NETWORK_JOINED) && (other.pipe_flags & PIPE_NETWORK_JOINED)

/**
 * Finds a connecting object in a direction + given layer
 * Explicitly does not return a list of objects.
 * The only things that should connect to more than one layer at a time right now are layer manifolds, and mains pipes
 * And in both cases there needs to be special handling.
 */
/// Unused for now - Attempting to have all behavior be generic for both one layer and all layer devices.
/obj/machinery/atmospherics/proc/FindConnecting(direction, layer = pipe_layer)
	for(var/obj/machinery/atmospherics/other in get_step(src, direction))
		if(CanConnect(other))
			return other

/**
 * Standard two-way connection check
 */
/obj/machinery/atmospherics/proc/StandardConnectionCheck(obj/machinery/atmospherics/other, layer = pipe_layer)
	return (initialize_directions & get_dir(src, other)) && (get_dist(other) <= 1) && (other.initialize_directions & get_dir(other, src)) && StandardCanLayersConnect(other, layer) && other.StandardCanLayersConnect(src, layer)

/**
 * One way connection check
 */
/obj/machinery/atmospherics/proc/StandardCanLayersConnect(obj/machinery/atmospherics/other, layer = pipe_layer)
	return (other.pipe_layer == layer) || (other.pipe_flags & PIPE_ALL_LAYER)
