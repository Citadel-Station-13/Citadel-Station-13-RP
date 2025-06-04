//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/atom/proc/antimagic_check(magic_potency, magic_type, list/magic_data, target_zone)
	var/datum/component/antimagic_coverage/coverage_tracker = GetComponent(/datum/component/antimagic_coverage)
	#warn impl

/atom/proc/antimagic_emit_vfx(vfx_path = /atom/movable/render/antimagic, potency, ...)
	var/list/modified_args = args.Copy()
	modified_args[1] = src
	return new vfx_path(arglist(modified_args))
