//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * denotes a potential role spawn
 */
/obj/map_helper/role_marker
	icon = 'icons/mapping/helpers/role_marker.dmi'
	icon_state = "grey-x"

	/// role tag
	var/role_tag

/obj/map_helper/role_marker/preloading_from_mapload(datum/dmm_context/context)
	LAZYINITLIST(context.role_markers_by_tag[role_tag])
	context.role_markers_by_tag[role_tag] += src
	return ..()
