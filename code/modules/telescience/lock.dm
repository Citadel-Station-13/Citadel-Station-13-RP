//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/bluespace_lock
	/// target signal
	var/datum/bluespace_signal/target
	/// current instability
	var/instability = 0
	/// current inaccuracy
	var/inaccuracy = 0
	/// current relative signal power (signal power minus jamming powers)
	var/power = 0
	/// current relative signal boost (signal boost minus jamming boosts)
	var/boost = 0
	/// being affected by a lensing field
	var/is_being_lensed = FALSE

/datum/bluespace_lock/New(datum/bluespace_signal/target)
	src.target = target



#warn uhh
