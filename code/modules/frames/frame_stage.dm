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
	var/name_append
	/// name override; if existing, will override base name (prepend/append are still used)
	var/name_override
	/// "the [name] [descriptor]" on examine
	var/descriptor
	#warn hook above 4 + name

/datum/frame_stage/New(set_key)
	if(!isnull(set_key))
		key = set_key
	if(isnull(name))
		name = key
	for(var/i in 1 to length(steps))
		var/datum/frame_step/step_casted = steps[i]
		if(istype(step_casted))
			continue
		steps[i] = new step_casted
