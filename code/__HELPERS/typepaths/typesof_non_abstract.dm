//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Grabs all datum typepaths under a path that are not abstract.
 *
 * * Runtimes if path is not a datum.
 */
/proc/typesof_non_abstract(datum_path)
	. = list()
	for(var/datum/dpath as anything in typesof(datum_path))
		if(initial(dpath.abstract_type) == dpath)
			continue
		. += dpath
