//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/admins/proc/admin_ghost() as /mob/observer/dead
	if(istype(owner.mob, /mob/observer/dead))
		return owner.mob
	var/mob/leaving_body = owner.mob
	var/mob/observer/dead/new_ghost = leaving_body.ghostize(TRUE)
	new_ghost.admin_ghosted = TRUE
	// setup audiovisual redirect
	leaving_body.teleop = new_ghost
	// mark them with the snowflake "@" of ss13 adminghost frameworking
	leaving_body.key = "@[owner.key]"
	return new_ghost
