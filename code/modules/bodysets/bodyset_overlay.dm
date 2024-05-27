//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/bodyset_overlay
	/// identifier
	var/id
	/// icon, defaults to bodyset icon
	var/icon
	/// state, for uni-state overlays
	var/icon_state

#warn impl for husk

/datum/bodyset_overlay/New(id)
	src.id = id
