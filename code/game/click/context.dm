//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * get context options
 *
 * key is a text string
 * value are tuples; use ATOM_CONTEXT_TUPLE to create.
 *
 * @return list(key = value)
 */
/atom/proc/context_query(datum/event_args/actor/e_args)
	. = list()
	SEND_SIGNAL(src, COMSIG_ATOM_CONTEXT_QUERY, ., e_args)

/**
 * act on a context option
 *
 * things in this should re-check validity / sanity!
 *
 * @return TRUE / FALSE; TRUE if handled.
 */
/atom/proc/context_act(datum/event_args/actor/e_args, key)
	if(SEND_SIGNAL(src, COMSIG_ATOM_CONTEXT_ACT, key, e_args) & RAISE_ATOM_CONTEXT_ACT_HANDLED)
		return TRUE
	return FALSE

/atom/proc/context_menu(datum/event_args/actor/e_args)
	set waitfor = FALSE
	// admin proccall support
	WRAP_MOB_TO_ACTOR_EVENT_ARGS(e_args)
	// todo: dynamically rebuild menu based on distance?
	var/client/receiving = e_args.initiator.client
	if(isnull(receiving))
		// well what the hell are we doing here?
		// automated functions should be using context_query and context_act directly
		return FALSE
	if(context_menus?[receiving])
		// close
		log_click_context(e_args, src, "menu close")
		qdel(context_menus[receiving])
		return TRUE
	var/list/menu_options = context_query(e_args)
	if(!length(menu_options))
		return FALSE
	// open
	log_click_context(e_args, src, "menu open")
	. = TRUE
	blocking_context_menu(e_args, receiving, menu_options, e_args.performer)

/atom/proc/blocking_context_menu(datum/event_args/actor/e_args, client/receiving, list/menu_options, mob/actor)
	// for now, we just filter without auto-updating/rebuilding when things change
	var/list/transformed = list()
	var/list/inverse_lookup = list()
	for(var/key as anything in menu_options)
		var/list/data = menu_options[key]
		if(!CHECK_ALL_MOBILITY(actor, data[4]))
			continue
		if(isnull(data[3])? !actor.Adjacent(src) : get_dist(actor, src) > data[3])
			continue
		var/image/I = data[2]
		// todo: why isn't radial menu doing this procesisng?
		if(I)
			I.maptext_x = -16
			I.maptext_y = 32
			I.maptext_width = 64
			I.maptext = MAPTEXT_CENTER(data[1])
		transformed[data[1]] = I
		inverse_lookup[data[1]] = key

	var/datum/radial_menu/context_menu/menu = new
	var/id = "context_[REF(e_args.initiator)]"
	GLOB.radial_menus[id] = menu
	LAZYSET(context_menus, receiving, menu)

	menu.radius = 32
	menu.host = src
	menu.anchor = src
	menu.check_screen_border(receiving.mob)
	menu.set_choices(transformed, FALSE)
	menu.show_to(receiving.mob)
	menu.wait(receiving.mob, src, TRUE)

	var/chosen_name = menu.selected_choice

	qdel(menu)
	GLOB.radial_menus -= id

	if(isnull(chosen_name))
		return

	var/key = inverse_lookup[chosen_name]
	context_act(e_args, key)

/atom/proc/context_close()
	for(var/client/C as anything in context_menus)
		qdel(context_menus[C])
