//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station developers.          *//

/**
 * Connects transitively to cardinals.
 *
 * Does something very, very evil to status_traits.
 */
/datum/object_system/adjacency_group
	/// string key
	var/key
	/// current group
	var/datum/adjacency_group/group
	/// rebuild queued?
	var/rebuild_queued = FALSE
	/// connected directions
	var/connected_directions = NONE

/datum/object_system/adjacency_group/New(obj/parent, key)
	src.key = key
	ASSERT(key)
	LAZYSET(parent.status_traits, TRAIT_OBJ_ADJACENCY_GROUP(src.key), src)
	queue_rebuild()
	return ..()

/datum/object_system/adjacency_group/Destroy()
	LAZYREMOVE(parent.status_traits, TRAIT_OBJ_ADJACENCY_GROUP(key))
	QDEL_NULL(group)
	rebuild_queued = FALSE
	return ..()

/datum/object_system/adjacency_group/proc/parent_moved()
	QDEL_NULL(group)
	queue_rebuild()

/datum/object_system/adjacency_group/proc/create_initial_data()
	if(rebuild_queued)
		return
	return parent.object_adjacency_group_create_initial_data(src)

/datum/object_system/adjacency_group/proc/queue_rebuild()
	addtimer(CALLBACK(src, PROC_REF(rebuild_if_needed)), 0)
	rebuild_queued = TRUE

/datum/object_system/adjacency_group/proc/rebuild_if_needed()
	if(!rebuild_queued)
		return
	rebuild_queued = FALSE
	if(group)
		return
	rebuild()

/datum/object_system/adjacency_group/proc/rebuild()
	QDEL_NULL(group)
	var/datum/adjacency_group/new_group = new(key, create_initial_data())
	new_group.build(src)

/datum/adjacency_group
	/// all systems in group
	var/list/datum/object_system/adjacency_group/in_group
	/// string key
	var/key
	/// arbitrary data variable you can set to whatever you want
	var/data

/datum/adjacency_group/New(key)
	src.key = key
	src.data = data
	in_group = list()

/datum/adjacency_group/Destroy()
	teardown()
	return ..()

/datum/adjacency_group/proc/build(datum/object_system/adjacency_group/from_node)
	// very destructive build process; when encountering 'enemy', immediately destroy it and trample over
	var/list/datum/object_system/adjacency_group/expanding = list(from_node)
	var/trait = TRAIT_OBJ_ADJACENCY_GROUP(key)
	while(length(expanding))
		var/datum/object_system/adjacency_group/expand_this = expanding[length(expanding)]
		--expanding.len
		var/dirs_connecting = NONE

		var/atom/expand_loc = expand_this.parent.loc
		if(isturf(expand_loc))
			for(var/dir in GLOB.cardinal)
				for(var/obj/in_cardinal_tile in get_step(expand_loc, dir))
					var/datum/object_system/adjacency_group/their_cardinal_group = in_cardinal_tile.status_traits?[trait]
					if(their_cardinal_group)
						dirs_connecting |= dir
						if(their_cardinal_group.group == src)
							break
						expanding += in_cardinal_tile.status_traits[trait]
						break

			for(var/obj/in_tile in expand_loc)
				var/datum/object_system/adjacency_group/their_group = in_tile.status_traits?[trait]
				if(!their_group || their_group == expand_this)
					continue
				dirs_connecting |= ONTOP_BIT
				if(their_group.group != src)
					if(their_group.group)
						qdel(their_group.group)
					their_group.group = src
					their_group.connected_directions = dirs_connecting
					in_group += their_group

		if(expand_this.group != src)
			if(expand_this.group)
				qdel(expand_this.group)
			expand_this.group = src
			expand_this.connected_directions = dirs_connecting
			in_group += expand_this

	for(var/datum/object_system/adjacency_group/member as anything in in_group)
		member.parent.object_adjacency_group_join(member, src, member.connected_directions)

/datum/adjacency_group/proc/teardown()
	for(var/datum/object_system/adjacency_group/member as anything in in_group)
		member.parent.object_adjacency_group_leave(member, src, member.connected_directions)
		member.group = null
		member.connected_directions = NONE
		member.queue_rebuild()
	in_group = null

//* /obj hooks *//

/**
 * Called when an adjacency group is being built from ourselves and initial data is needed
 */
/obj/proc/object_adjacency_group_create_initial_data(datum/object_system/adjacency_group/group_holder)
	return null

/**
 * Called on adjacency group join
 *
 * @params
 * * group_holder - object system handling the group
 * * group - the group in question
 * * directions - directions we're connecting in, as X_BIT (e.g. NORTHEAST_BIT). This will only have cardinals and ONTOP_BIT if something is atop us.
 */
/obj/proc/object_adjacency_group_join(datum/object_system/adjacency_group/group_holder, datum/object_system/adjacency_group/group, directions)
	return

/**
 * Called on adjacency group leave
 *
 * @params
 * * group_holder - object system handling the group
 * * group - the group in question
 * * directions - directions we **were** connected in, as X_BIT (e.g. NORTHEAST_BIT). This will only have cardinals and ONTOP_BIT if something was atop us.
 */
/obj/proc/object_adjacency_group_leave(datum/object_system/adjacency_group/group_holder, datum/object_system/adjacency_group/group, directions)
	return
