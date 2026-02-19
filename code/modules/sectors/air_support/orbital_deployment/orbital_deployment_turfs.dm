//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * the system automatically makes this on the 4 corners outside of the bounding box.
 */
/turf/simulated/wall/orbital_deployment_superstructure
	name = "orbital deployment superstructure"
	desc = "A nigh-indestructible pylon able to withstand the immense stress of launching structures from orbit."
	icon = 'icons/modules/sectors/air_support/orbital_deployment_superstructure.dmi'
	icon_state = "superstructure"
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	material_system = FALSE
	smoothing_flags = NONE
	material_outer = null
	material_girder = null
	material_reinf = null

/turf/baseturf_skipover/orbital_deployment
	name = "orbital deployment skipover turf"
	desc = "Acts as a marker so the deployment zone knows when a turf is broken through."
