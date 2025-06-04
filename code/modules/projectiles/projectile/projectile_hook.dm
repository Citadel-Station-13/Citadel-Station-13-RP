//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//
/**
 * projectile hooks
 * * pretty much the low level version of [/datum/projectile_hook]
 */
/datum/projectile_hook
	var/hook_impact = FALSE

/**
 * Low level hook for impact. Fired after pre_impact(), ignores pre_impact() flags other than delete.
 * * Modify caller using `impact_args`.
 */
/datum/projectile_hook/proc/on_impact(list/impact_args)
	SHOULD_NOT_SLEEP(TRUE)
