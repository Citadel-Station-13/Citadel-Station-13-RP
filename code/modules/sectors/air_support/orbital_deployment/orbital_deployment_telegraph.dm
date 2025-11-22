//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/atom/movable/render/orbital_deployment_telegraph
	name = "orbital deployment landing"
	desc = "Usually, when you see a building about to land on you from orbit, you run away. \
	Stop gawking and start doing that."
	#warn sprite

/atom/movable/render/orbital_deployment_telegraph/Initialize(mapload, packaged_width, packaged_height, landing_time)
	. = ..()
	QDEL_IN(src, landing)

	#warn sprite

/atom/movable/render/orbital_deployment_telegraph/proc/scale_to_packaged(width, height)
/atom/movable/render/orbital_deployment_telegraph/proc/animation(width, height)
