//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * a discrete stage in a construction frame
 */
/datum/frame_stage
	/// name; for vv. defaults to key
	var/name
	/// key; autoset from key if associating via frames.
	var/key
	/// list of step datums
	/// set to typepaths to init
	/// anonymous typepaths are allowed and encouraged.
	var/list/datum/frame_step/steps = list()
	/// name prepend; if existing, will be prepended with a space
	var/name_prepend
	/// name append; if existing, will be appended with a space
	/// * the (xyz) format e.g. "(wired)" is recommended, resulting in a render of "frame (wired)"
	var/name_append
	/// name override; if existing, will override base name (prepend/append are still used)
	/// * the bare format e.g. "wired" is recommended, resulting in a render of "wired frame"
	var/name_override
	/// "the [name] [descriptor]" on examine
	var/descriptor
	/// default require anchor for steps; if null, default to frame
	/// * this is for steps going from us, not steps going to us!
	var/requires_anchored
	/// allow unanchor while in this stage
	/// if null, defaults to frame not being requires_anchored **or** us being the first stage.
	var/allow_unanchor

/datum/frame_stage/New(set_key)
	if(!isnull(set_key))
		key = set_key
	if(isnull(name))
		name = key
	for(var/i in 1 to length(steps))
		var/datum/frame_step/step_casted = steps[i]
		if(istype(step_casted))
			continue
		var/datum/frame_step/creating = new step_casted
		if(isnull(creating.requires_anchored))
			creating.requires_anchored = src.requires_anchored
		steps[i] = creating

/datum/frame_stage/proc/on_examine(obj/structure/frame2/frame, datum/event_args/actor/actor, list/examine_list, distance)
	if(descriptor)
		examine_list += span_notice("[frame] [descriptor]")
