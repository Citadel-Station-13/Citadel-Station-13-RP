//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/controller/subsystem/persistence/proc/build_prototype_id_lookup()
	var/list/constructing = list()

	var/last

	for(var/path in subtypesof(/atom))
		// so the key here is in most but not all cases,
		// if there's a case of intentional set-multiple-as-one-id,
		// they'll be relatively adjacent to each other
		// so we remember 'last' as an optimization since a comparison
		// is cheaper than a list lookup
		var/atom/casted = path
		var/casted_id = initial(casted.prototype_id)

		if(casted_id == last)
			continue
		if(constructing[casted_id])
			continue
		constructing[casted_id] = path
		last = path

	prototype_id_to_path = constructing
