//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/area/orbital_deployment_area
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/modules/sectors/air_support/orbital_deployment_zone.dmi'
	icon_state = "armed-tile"
	alpha = 0
	color = "#ffaa00"

/area/orbital_deployment_area/New()
	..()
	name = "Deployment Zone [SSmapping.obfuscated_round_local_id("[uid]")]"

/area/orbital_deployment_area/grid_collect(grid_flags, turf/old_turf, turf/new_turf, baseturf_boundary)
	if(old_turf.type == old_turf.baseturf_bottom())
		return NONE
	return ..()
