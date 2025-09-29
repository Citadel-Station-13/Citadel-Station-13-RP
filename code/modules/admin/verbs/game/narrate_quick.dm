//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

ADMIN_VERB_DEF_PANEL_ONLY(narrate_quick, R_ADMIN, "Narrate (Quick)", "Perform narration.", VERB_CATEGORY_GAME, atom/target as turf|mob|obj|null)

	var/use_global
	var/datum/weakref/use_viewers
	var/datum/weakref/use_overmap
	var/datum/weakref/use_direct

	#warn title/msg
	var/emit = tgui_input_text(caller, "MESSAGE", "Narration to ", "", 16535, TRUE, FALSE)
	if(!emit)
		return

	var/list/mob/targets = list()
	var/reject

	if(use_global)
		for(var/client/C as anything in GLOB.clients)
			targets += C.mob
	else if(use_viewers)
		var/atom/resolved = use_viewers.resolve()
		if(!istype(resolved))
			reject = "use_viewers failed atom resolution; this is a bug."
		else
			for(var/mob/maybe_viewing in viewers(35, resolved))
				targets += maybe_viewing
	else if(use_overmap)
		var/obj/overmap/entity/resolved = use_viewers.resolve()
		if(!istype(resolved))
			reject = "use_overmap failed entity resolution; this is a bug."
		else
			#warn impl
	else if(use_direct)
		var/atom/movable/resolved = use_viewers.resolve()
		if(!istype(resolved))
			reject = "use_direct failed target resolution; this is a bug."
		else
			targets = resolved.admin_resolve_narrate()


	#warn log / whatnot
