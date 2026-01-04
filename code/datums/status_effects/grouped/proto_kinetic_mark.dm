//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Basic proto-kinetic mark.
 */
/datum/status_effect/grouped/proto_kinetic_mark
	identifier = "proto_kinetic_mark"
	duration = 300

/datum/status_effect/grouped/proto_kinetic_mark/on_apply()
	RegisterSignal(owner, COMSIG_MOVABLE_PROTO_KINETIC_SCAN, PROC_REF(signal_scan))
	RegisterSignal(owner, COMSIG_MOVABLE_PROTO_KINETIC_DETONATION, PROC_REF(signal_detonation))
	inject_visual_filter()
	return ..()

/datum/status_effect/grouped/proto_kinetic_mark/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_PROTO_KINETIC_SCAN)
	UnregisterSignal(owner, COMSIG_MOVABLE_PROTO_KINETIC_DETONATION)
	owner.update_filters()
	return ..()

/datum/status_effect/grouped/proto_kinetic_mark/proc/signal_scan(datum/source, list/detonation_data)
	SIGNAL_HANDLER
	detonation_data[PROTO_KINETIC_DETONATION_DATA_IDX_MARKED] = TRUE

/datum/status_effect/grouped/proto_kinetic_mark/proc/signal_detonation(datum/source, list/detonation_data)
	SIGNAL_HANDLER
	qdel(src)

/datum/status_effect/grouped/proto_kinetic_mark/proc/inject_visual_filter(datum/source)
	SIGNAL_HANDLER

	add_filters(list(
		list(
			"name" = "pkm-blur",
			"priority" = 1,
			"params" = motion_blur_filter(0, 0),
		),
		list(
			"name" = "pkm-shadow",
			"priority" = 1,
			"params" = drop_shadow_filter(0.5, 0.5, 0, 0, "#1c1c1c77"),
		),
	))

	var/pkm_blur = get_filter("pkm-blur")
	animate(pkm_blur, appearance = list(x = 1.5), time = 0.33 SECONDS, loop = -1, easing = QUAD_EASING)
	animate(pkm_blur, appearance = list(x = 0), time = 0.33 SECONDS, loop = -1, easing = LINEAR_EASING, flags = ANIMATION_CONTINUE)

	var/pkm_shadow = get_filter("pkm-shadow")
	animate(pkm_shadow, appearance = list(size = 1.65), time = 0.33 SECONDS, loop = -1, easing = QUAD_EASING, flags = ANIMATION_PARALLEL)
	animate(pkm_shadow, appearance = list(size = 0), time = 0.33 SECONDS, loop = -1, easing = LINEAR_EASING, flags = ANIMATION_CONTINUE)

