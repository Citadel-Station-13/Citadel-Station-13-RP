//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/atom/proc/antimagic_fetch_or_init_coverage() as /datum/component/antimagic_coverage
	return LoadComponent(/datum/component/antimagic_coverage)

/**
 * @return modified args; access with ANTIMAGIC_ARG_*
 */
/atom/proc/antimagic_check(magic_potency, magic_type, list/magic_data, antimagic_flags, atom/target, target_zone, efficiency = 1)
	var/datum/component/antimagic_coverage/coverage_tracker = GetComponent(/datum/component/antimagic_coverage)
	if(coverage_tracker)
		return coverage_tracker.antimagic_check(magic_potency, magic_type, magic_data, antimagic_flags, target, target_zone, efficiency)
	else
		return args.Copy()

/atom/proc/antimagic_emit_vfx(vfx_path = /atom/movable/render/antimagic, potency, ...)
	var/list/modified_args = args.Copy()
	modified_args[1] = src
	return new vfx_path(arglist(modified_args))
