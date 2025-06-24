//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station developers.          *//

/datum/object_system/adjacency_group

/datum/adjacency_group
	/// all systems in group
	var/list/datum/object_system/adjacency_group/in_group

/datum/adjacency_group/New()
	in_group = list()

/datum/adjacency_group/Destroy()
	teardown()
	return ..()

/datum/adjacency_group/proc/build(datum/object_system/adjacency_group/from_node)


