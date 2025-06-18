//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/component/eldritch_fracturing
	var/duration

/datum/component/eldritch_fracturing/Initialize(duration)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	src.duration = duration
	QDEL_IN(src, duration)

/datum/component/eldritch_fracturing/RegisterWithParent()
	var/atom/atom_parent = parent

/datum/component/eldritch_fracturing/UnregisterFromParent()
	var/atom/atom_parent = parent
