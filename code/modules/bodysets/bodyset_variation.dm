//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/bodyset_variation
	/// our name, defaults to id
	var/name
	/// our identifier
	var/id
	/// icon state append; not having any is fine if you override icon.
	var/state_append
	/// icon override
	var/icon

/datum/bodyset_variation/New(id)
	src.id = id
	if(isnull(name))
		name = src.id
