//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/atom/movable/render/orbital_deployment_telegraph
	name = "orbital deployment landing"
	desc = "Usually, when you see a building about to land on you from orbit, you run away. \
	Stop gawking and start doing that."
	icon = 'icons/modules/sectors/air_support/orbital_deployment_telegraph.dmi'
	icon_state = "warning"

/atom/movable/render/orbital_deployment_telegraph/Initialize(mapload, landing_time)
	. = ..()
	QDEL_IN(src, landing_time)
