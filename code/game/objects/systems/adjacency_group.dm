//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station developers.          *//

/**
 * Connects transitively to cardinals.
 */
/datum/object_system/adjacency_group
	/// string key
	var/key
	/// current group
	var/datum/adjacency_group/group
	/// rebuild queued?
	var/rebuild_queued = FALSE

/datum/object_system/adjacency_group/New(obj/parent)
	LAZYSET(parent.status_traits, TRAIT_OBJ_ADJACENCY_GROUP(key), src)
	queue_rebuild()
	return ..()

/datum/object_system/adjacency_group/Destroy()
	LAZYREMOVE(parent.status_traits, TRAIT_OBJ_ADJACENCY_GROUP(key))
	return ..()

/datum/object_system/adjacency_group/proc/create_initial_data()
	return parent.object_adjacency_group_create_initial_data(src)

/datum/object_system/adjacency_group/proc/queue_rebuild()
	addtimer(CALLBACK(src, PROC_REF(rebuild_if_needed)), 0)

/datum/object_system/adjacency_group/proc/rebuild_if_needed()
	if(!rebuild_queued)
		return
	rebuild_queued = FALSE
	rebuild()

/datum/object_system/adjacency_group/proc/rebuild()
	if(group)
		QDEL_NULL(group)
	var/datum/adjacency_group/new_group = new
	new_group.build(src)

/datum/adjacency_group
	/// all systems in group
	var/list/datum/object_system/adjacency_group/in_group
	/// string key
	var/key
	/// arbitrary data variable you can set to whatever you want
	var/data

/datum/adjacency_group/New()
	in_group = list()

/datum/adjacency_group/Destroy()
	teardown()
	return ..()

/datum/adjacency_group/proc/build(datum/object_system/adjacency_group/from_node)
	// very destructive build process; when encountering 'enemy', immediately destroy it and trample over
	var/list/datum/object_system/adjacency_group/expanding = list(from_node)
	while(length(expanding))
		var/datum/object_system/adjacency_group/expand_this = expanding[length(expanding)]
		--expanding.len
		if(expand_this.group)
			if(expand_this.group == src)
				CRASH("self-recursion during build")
			else
				qdel(expand_this.group)
				expand_this.group = null
		#warn logic




/datum/adjacency_group/proc/teardown()
	#warn logic
	



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
