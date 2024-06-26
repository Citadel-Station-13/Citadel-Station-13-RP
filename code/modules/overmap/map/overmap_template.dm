//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * a template used to construct an overmap
 */
/datum/overmap_template
	/// our width
	var/width
	/// our height
	var/height
	/// our layers
	/// typepath to init
	/// applied in order
	var/list/layers = list()

/datum/overmap_template/proc/initialize()
	#warn impl 

#warn impl

/**
 * default
 */
/datum/overmap_template/legacy_default
	width = 20
	height = 20

	/// event clouds to spawn
	var/event_clouds = 2

/datum/overmap_template/legacy_default/initialize()
	. = ..()
	layers += new /datum/overmap_template_layer/legacy_events(2)
