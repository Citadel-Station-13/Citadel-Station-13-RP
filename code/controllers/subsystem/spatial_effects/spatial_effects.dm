//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * A handler for things like explosions, EMPs, concussive blasts, sharpnel, etc
 */
SUBSYSTEM_DEF(spatial_effects)
	name = "Spatial Effects"
	subsystem_flags = SS_NO_FIRE | SS_NO_INIT

/**
 * All procs should call this at the top.
 */
/datum/controller/subsystem/spatial_effects/proc/log_effect_invocation(effect_type, list/effect_params)
	// TODO: logging
