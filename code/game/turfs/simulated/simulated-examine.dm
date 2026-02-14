//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/turf/examine(mob/user, dist)
	. = ..()
	if(SSmap_sectors.is_turf_visible_from_high_altitude(src))
		. += span_notice("The ground could likely be seen here from high altitudes.")
