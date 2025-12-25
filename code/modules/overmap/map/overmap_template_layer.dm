//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * generation layers
 */
/datum/overmap_template_layer

/**
 * apply to overmap
 *
 * * this doesn't have to be idempotent as of right now
 * * this is called after the overmap is instanced, so this can't be previewed properly
 * * this is called before anything is put on the overmap / build_map() is done
 */
/datum/overmap_template_layer/proc/apply_to(datum/overmap/map)
	return TRUE
