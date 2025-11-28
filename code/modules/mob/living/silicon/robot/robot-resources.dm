//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Regenerates our resources.
 *
 * * Used by chargers.
 */
/mob/living/silicon/robot/proc/regenerate_resources_from_charger(seconds, multiplier = 1)
	SHOULD_NOT_OVERRIDE(TRUE) // no excuses, don't do it! robots are composition.

	module?.legacy_custom_regenerate_resources(src, seconds, multiplier)
