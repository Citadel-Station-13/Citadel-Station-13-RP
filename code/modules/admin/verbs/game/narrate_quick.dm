//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

ADMIN_VERB_DEF(narrate_quick, R_ADMIN, "Narrate (Quick)", "Perform narration.", VERB_CATEGORY_GAME, atom/target as null|obj|mob|turf in world)

	var/use_global
	var/datum/weakref/use_viewers
	var/datum/weakref/use_overmap
	var/datum/weakref/use_direct

	var/target_name_descriptor = "ERROR"
	var/target_long_descriptor = "ERROR"

	if(isnull(target))
		use_global = TRUE
		target_name_descriptor = "(Everyone)"
		target_long_descriptor = "Narrate to the entire server, even those in lobby."
	else if(istype(target, /obj/overmap/entity))
		use_overmap = WEAKREF(target)
		target_name_descriptor = "([target])"
		target_long_descriptor = "Narrate to everyone aboard / present on \the [target]."
	else if(isturf(target))
		use_viewers = WEAKREF(target)
		target_name_descriptor = "(viewing [target] @ [target.x], [target.y], [target.y])"
		target_long_descriptor = "Narrate to everyone who can view the turf ([target]) at [target.x], [target.y], [target.z]."
	else if(ismovable(target))
		var/atom/movable/target_movable = target
		if(target_movable.admin_resolve_narrate())
			use_direct = WEAKREF(target_movable)
			target_name_descriptor = "([target])"
			target_long_descriptor = "Narrate to everyone inside / the person at / the target of '[target]' (currently at \the [get_area(target)])."
		else
			use_viewers = WEAKREF(target_movable)
			target_name_descriptor = "(viewing [target])"
			target_long_descriptor = "Narrate to everyone who can see '[target]' (currently at \the [get_area(target)])."

	var/emit = tgui_input_text(invoking, target_long_descriptor, "Narrate to [target_name_descriptor]", "", 65535, TRUE, FALSE)
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
				if(!maybe_viewing.client)
					continue
				targets += maybe_viewing
	else if(use_overmap)
		var/obj/overmap/entity/resolved = use_viewers.resolve()
		if(!istype(resolved))
			reject = "use_overmap failed entity resolution; this is a bug."
		else
			// sigh make this better later
			for(var/client/C as anything in GLOB.clients)
				if(get_overmap_sector(C.mob) == resolved)
					targets += C.mob
	else if(use_direct)
		var/atom/movable/resolved = use_viewers.resolve()
		if(!istype(resolved))
			reject = "use_direct failed target resolution; this is a bug."
		else
			targets = resolved.admin_resolve_narrate()
	else
		reject = "no narrate mode resolved; this is a bug."

	if(!reject && !length(targets))
		reject = "no targets in range; skipping narrate sequence."

	if(reject)
		var/list/html = list(
			"<hr>",
			SPAN_BLOCKQUOTE(emit, null),
			"<hr>",
			"<center><span style='font-weight: bold; color: red;'>^^^ ERROR: The above was not sent; [reject] ^^^</span></center>",
		)
		to_chat(invoking, jointext(html, ""))
		return

	var/list/view_target_to_list = list()
	for(var/mob/viewing in targets)
		view_target_to_list += "[key_name(viewing)]"
	var/view_target_list = jointext(view_target_to_list, ", ")
	message_admins("[key_name(invoking)] sent a [SPAN_TOOLTIP("[html_encode(emit)]", "global narrate")] to [SPAN_TOOLTIP("[view_target_list]", "[length(targets)] target(s)")].")
	log_admin("[key_name(invoking)] sent a global narrate to [length(targets)] targets; VIEWERS: '[view_target_list]'', TEXT: '[emit]'")

	for(var/mob/viewing in targets)
		to_chat(viewing, emit)
