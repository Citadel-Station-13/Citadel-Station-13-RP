//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * a template used to construct an overmap
 */
/datum/overmap_template
	/// are we initialized?
	var/initialized = FALSE
	/// our width
	var/width
	/// our height
	var/height
	/// our layers
	/// typepath to init
	/// applied in order
	var/list/layers = list()

/datum/overmap_template/New(width, height, list/additional_layers)
	src.width = width
	src.height = height
	if(additional_layers)
		src.layers += additional_layers

/**
 * should be idempotent!
 */
/datum/overmap_template/proc/initialize()
	for(var/index in 1 to length(layers))
		var/datum/overmap_template_layer/maybe_layer = layers[index]
		if(istype(maybe_layer))
			continue
		maybe_layer = new maybe_layer
		layers[index] = maybe_layer

	initialized = TRUE

/**
 * called right after the turf reservation is allocated and initialized
 */
/datum/overmap_template/proc/on_allocation_initialized(datum/overmap/map)
	for(var/datum/overmap_template_layer/layer as anything in layers)
		layer.apply_to(map)

/**
 * called right after the turf reservation is allocated, but not initialized
 */
/datum/overmap_template/proc/on_allocation(datum/overmap/map)
	return

/**
 * default
 */
/datum/overmap_template/legacy_default
	width = 20
	height = 20

	/// event clouds to spawn
	var/event_clouds = 2

/datum/overmap_template/legacy_default/New(width, height, list/additional_layers, event_clouds)
	..()
	src.event_clouds = event_clouds

/datum/overmap_template/legacy_default/initialize()
	layers += new /datum/overmap_template_layer/legacy_events(event_clouds)
	return ..()
