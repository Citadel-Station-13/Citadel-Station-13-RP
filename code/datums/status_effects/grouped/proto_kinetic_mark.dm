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
	RegisterSignal(owner, COMSIG_ATOM_RELOAD_FILTERS, PROC_REF(inject_visual_filter))
	inject_visual_filter()
	return ..()

/datum/status_effect/grouped/proto_kinetic_mark/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_PROTO_KINETIC_SCAN, PROC_REF(signal_scan))
	UnregisterSignal(owner, COMSIG_MOVABLE_PROTO_KINETIC_DETONATION, PROC_REF(signal_detonation))
	UnregisterSignal(owner, COMSIG_ATOM_RELOAD_FILTERS, PROC_REF(signal_detonation))
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

	// TODO: 516 added assoc filters; touch-up the datum filter procs and stop doing this.
	// the reason we do this is because update_filters() tramples 'manual filters'
	// so we have to redo everything
	var/list/creating_filter_args
	var/list/animating_filter_args
	var/target_filter

	creating_filter_args = list(
		type = "motion_blur",
		x = 0,
		y = 0,
	)
	owner.filters += filter(arglist(creating_filter_args))
	target_filter = owner.filters[length(owner.filters)]

	animating_filter_args = list(
		x = 1.5,
	)
	animate(
		target_filter,
		appearance = animating_filter_args,
		easing = QUAD_EASING,
		time = 0.33 SECONDS,
		loop = -1,
	)
	animating_filter_args = list(
		x = 0,
	)
	animate(
		target_filter,
		appearance = animating_filter_args,
		easing = LINEAR_EASING,
		time = 0.33 SECONDS,
		flags = ANIMATION_CONTINUE,
	)

	creating_filter_args = list(
		type = "drop_shadow",
		x = 0.5,
		y = 0.5,
		size = 0,
		offset = 0,
		color = "#1c1c1c77"
	)
	owner.filters += filter(arglist(creating_filter_args))
	target_filter = owner.filters[length(owner.filters)]

	animating_filter_args = list(
		size = 1.65,
	)
	animate(
		target_filter,
		appearance = animating_filter_args,
		easing = QUAD_EASING,
		time = 0.33 SECONDS,
		loop = -1,
		flags = ANIMATION_PARALLEL
	)
	animating_filter_args = list(
		size = 0,
	)
	animate(
		target_filter,
		appearance = animating_filter_args,
		easing = LINEAR_EASING,
		time = 0.33 SECONDS,
		flags = ANIMATION_CONTINUE,
	)
