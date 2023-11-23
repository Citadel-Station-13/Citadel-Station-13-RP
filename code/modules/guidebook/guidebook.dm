//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

GLOBAL_DATUM_INIT(guidebook, /datum/guidebook, new)

/**
 * A standalone version of the guidebook system.
 *
 * Open when you want a detached reference, like for chemical dispensers to hook into.
 */
/datum/guidebook
	/// open instances mapped to list of ids
	var/list/opened = list()

/datum/guidebook/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(isnull(ui))
		ui = new(user, src, "TGUIGuidebook")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/guidebook/ui_state(mob/user, datum/tgui_module/module)
	return GLOB.always_state

/datum/guidebook/ui_close(mob/user, datum/tgui_module/module)
	opened -= user
	return ..()

/datum/guidebook/on_ui_transfer(mob/old_mob, mob/new_mob, datum/tgui/ui)
	opened[new_mob] = opened[old_mob]
	opened -= old_mob
	return ..()

/**
 * @params
 * * user - person viewing
 * * sections - list of section instances, ids, or paths
 */
/datum/guidebook/proc/open(mob/user, list/datum/prototype/guidebook_section/sections)
	// build
	var/list/built = list()
	var/list/sections = list()
	var/list/hash = list()
	// preprocess sections & inject
	for(var/datum/prototype/guidebook_section/section as anything in sections)
		if(!istype(section))
			section = RCguidebook.fetch(section)
			if(!istype(section))
				CRASH("invalid section, aborting")
			hash += section.id
	// hash
	hash = jointext(hash, "-")
	// check if we need to re-open
	if(opened[user] == hash)
		return
	opened[user] = hash
	// inject
	for(var/datum/prototype/guidebook_section/section as anything in sections)
		built[section.id] = section.interface_data()
		sections[section.id] = section.title
	// open
	ui_interact(user)
	// send
	push_ui_modules(user, updates = built)
	push_ui_data(user, data = list("sections" = sections))
