//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * A standalone version of the guidebook system.
 *
 * Open when you want a detached reference, like for chemical dispensers to hook into.
 */
/datum/guidebook_standalone

/datum/guidebook_standalone/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(isnull(ui))
		ui = new(user, src, "TGUIGuidebook")
		ui.open()

/datum/guidebook_standalone/ui_state(mob/user, datum/tgui_module/module)
	return GLOB.always_state

/**
 * @params
 * * user - person viewing
 * * sections - list of section instances, ids, or paths
 */
/datum/guidebook_standalone/proc/open(mob/user, list/datum/prototype/guidebook_section/sections)
	// build
	var/list/built = list()
	// preprocess sections & inject
	for(var/datum/prototype/guidebook_section/section as anything in sections)
		if(!istype(section))
			section = RCguidebook.fetch(section)
			if(!istype(section))
				CRASH("invalid section, aborting")
		built[++built.len] = section.interface_data()
	// build interface list
	var/list/data = list(
		"sections" = built,
	)
	// open
	ui_interact(user)
	// send
	push_ui_data(user, data = data)
