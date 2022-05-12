/**
 * Called to join its place in a network.
 */
/obj/machinery/atmospherics/proc/Join()
	if(QDELETED(src))
		CRASH("Attempted to Join() while waiting for GC")
	if(pipe_flags & PIPE_NETWORK_JOINED)
		CRASH("Attempted to Join() while already joined to network.")
	var/conflict
	if(!((conflict = CheckLocationConflict(loc, pipe_layer)) == PIPE_LOCATION_CLEAR))
		CRASH("Attempted to Join() with a conflict([conflict]) at location.")
	PreJoin()
	pipe_flags |= PIPE_NETWORK_JOINED
	if(Connect())
		QueueRebuild()
	update_appearance()

/**
 * Called during Join() just before connecting
 */
/obj/machinery/atmospherics/proc/PreJoin()
	if(pipe_flags & PIPE_CARDINAL_AUTONORMALIZE)
		NormalizeCardinalDirections()
	SetInitDirections()

/**
 * Called to leave its place in a network.
 */
/obj/machinery/atmospherics/proc/Leave()
	if(QDELETED(src))
		CRASH("Attempted to Leave() while waiting for GC")
	if(!(pipe_flags & PIPE_NETWORK_JOINED))
		CRASH("Attempted to Leave() without being joined to network.")
	pipe_flags &= ~PIPE_NETWORK_JOINED
	Disconnect()
	update_appearance()

/obj/machinery/atmospherics/Moved(atom/OldLoc, Dir)
	. = ..()
	if(pipe_flags & PIPE_NETWORK_JOINED)
		stack_trace("Atmos machinery moved while network was joined. This is bad.")
		Leave()
		Join()

/obj/machinery/atmospherics/forceMove(atom/destination)
	Leave()
	. = ..()
	Join()

/obj/machinery/atmospherics/Move(atom/newloc, direct, glide_size_override)
	Leave()
	. = ..()
	Join()

/obj/machinery/atmospherics/setDir(newdir, ismousemovement)
	Leave()
	. = ..()
	Join()

/**
 * Called to rebuild its pipenet(s)
 */
/obj/machinery/atmospherics/proc/Rebuild()
	pipe_flags &= ~PIPE_REBUILD_QUEUED
	Build()

/**
 * Queues us for a pipenet rebuild.
 */
/obj/machinery/atmospherics/proc/QueueRebuild()
	if(pipe_flags & PIPE_REBUILD_QUEUED)
		return
	SSair.queue_for_rebuild(src)
	pipe_flags |= PIPE_REBUILD_QUEUED

/**
 * Disconnects us from our neighbors.
 * Immediately tears down networks.
 */
/obj/machinery/atmospherics/proc/Disconnect()
	Teardown()
	for(var/obj/machinery/atmospherics/other as anything in connected)
		var/pos = other.connected.Find(src)
		if(!pos)
			stack_trace("Couldn't find ourselves in other while disconnecting.")
			continue
		other.connected[pos] = null
		other.update_appearance()
	connected.len = 0
	connected.len = device_type

/**
 * Constructs our pipeline if we don't have one
 */
/obj/machinery/atmospherics/proc/Build()
	return

/**
 * Tears down our pipeline.
 */
/obj/machinery/atmospherics/proc/Teardown()
	return

/**
 * Gets the maximum number of nodes we can have.
 * This determines the size of our nodes list.
 */
/obj/machinery/atmospherics/proc/MaximumPossibleNodes()
	return device_type * ((pipe_flags & PIPE_ALL_LAYER)? PIPE_LAYER_TOTAL : 1)
/**
 * Connects us to our neighbors.
 * Does not build network, just sets nodes.
 * Returns if we found anyone.
 */
/obj/machinery/atmospherics/proc/Connect()
	. = FALSE
	connected = list()
	var/list/current = list()
	var/list/node_order = NodeScanOrder()
	for(var/i in 1 to MaximumPossibleNodes())
		for(var/obj/machinery/atmospherics/other in get_step(src, node_order[i]))
			if(current[other])
				continue
			if(CanConnect(other, i))
				. = TRUE
				current[other] = TRUE
				connected[GetNodeIndex(node_order[i], other.layer)] = other
				var/their_order = other.GetNodeIndex(get_dir(other, src), pipe_layer)
				if(!their_order)
					stack_trace("Couldn't find where to place ourselves in other's nodes. Us: [src]([COORD(src)]) Them: [other]([COORD(other)]")
				else if(their_order != null)
					stack_trace("Attempted to connect to something that's already connected on that side. Us: [src]([COORD(src)]) Them: [other]([COORD(other)]")
				other.connected[their_order] = src
				other.update_appearance()

/**
 * Determines node order.
 * This should always be deterministic!
 */
/obj/machinery/atmospherics/proc/GetNodeIndex(dir, layer)
	. = 0
	for(var/D in GLOB.cardinals_multiz)
		if(D & GetInitDirections())
			++.
		if(D == dir)
			return (pipe_flags & PIPE_ALL_LAYER)? (. + ((. - 1) * PIPE_LAYER_TOTAL)) : .
	CRASH("Failed to find valid index ([dir], [layer])")

/**
 * Gets the order to scan nodes in.
 * This should always be deterministic!
 */
/obj/machinery/atmospherics/proc/NodeScanOrder()
	. = new /list(device_type)
	for(var/i in 1 to device_type)
		for(var/D in GLOB.cardinals_multiz)
			if(D & GetInitDirections())
				if(D in .)
					continue
				.[i] = D
				break
	if(pipe_flags & PIPE_ALL_LAYER)
#if PIPE_LAYER_TOTAL == 1
		return
#else
		// duplicate the list by PIPE_LAYER_TOTAL
		var/list/L = .
		L.len *= PIPE_LAYER_TOTAL
		for(var/i in 1 to device_type)
			for(var/j in 2 to (PIPE_LAYER_TOTAL))
				L[((j - 1) * PIPE_LAYER_TOTAL) + i] = L[i]
#endif

/**
 * Calls update appearance on all connected nodes
 */
/obj/machinery/atmospherics/proc/UpdateConnectedIcons()
	for(var/obj/machinery/atmospherics/A in connected)
		A.update_appearance()

/**
 * Used during pipeline builds.
 * Returns a list of things we're directly connected to.
 */
/obj/machinery/atmospherics/proc/DirectConnection(datum/pipeline/querying, obj/machinery/atmospherics/source)
	return list()

/**
 * Replaces a pipenet with another
 */
/obj/machinery/atmospherics/proc/ReplacePipeline(datum/pipeline/old, datum/pipeline/replacing)
	CRASH("Base ReplacePipeline called [old] [replacing] on [src]")

/**
 * Sets our pipenet to something. Used during pipeline initial builds.
 */
/obj/machinery/atmospherics/proc/SetPipeline(datum/pipeline/setting, obj/machinery/atmospherics/source)
	CRASH("Base SetPipeline called [setting] [source] on [src]")

/**
 * Nullifies a pipenet from us
 */
/obj/machinery/atmospherics/proc/NullifyPipeline(datum/pipeline/removing)
	CRASH("Base NullifyPipeline called [removing] on [src]")

/**
 * Releases our air to the environment
 */
/obj/machinery/atmospherics/proc/ReleaseAirToTurf()
	CRASH("Base ReleaseAirToTurf called on [src]")

/**
 * Returns all pipelines this is a part of.
 */
/obj/machinery/atmospherics/proc/ReturnPipelines()
	return list()

/**
 * Returns the volume we contribute to a pipeline. Currently ignored for components.
 */
/obj/machinery/atmospherics/proc/PipelineVolume()
	CRASH("Base PipelineVolume() called on [src]")
