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

/datum/guidebook/ui_state()
	return GLOB.always_state

/datum/guidebook/on_ui_close(mob/user, datum/tgui/ui, embedded)
	opened -= user
	return ..()

/datum/guidebook/on_ui_transfer(mob/old_mob, mob/new_mob, datum/tgui/ui, embedded)
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
	var/list/hash = list()
	var/list/fetched = list()
	var/list/lookup = list()
	// preprocess sections & inject
	for(var/datum/prototype/guidebook_section/section as anything in sections)
		if(!istype(section))
			section = RSguidebook.fetch(section)
			if(!istype(section))
				CRASH("invalid section, aborting")
		fetched += section
		hash += section.id
	// hash
	hash = jointext(hash, "-")
	// check if we need to re-open
	if(opened[user] == hash)
		return
	opened[user] = hash
	// inject
	for(var/datum/prototype/guidebook_section/section as anything in fetched)
		built[section.id] = section.interface_data()
		lookup[section.id] = section.title
	// open
	var/datum/tgui/ui = SStgui.try_update_ui(user, src)
	if(isnull(ui))
		ui = new(user, src, "TGUIGuidebook")
		ui.set_autoupdate(FALSE)
		ui.open(data = list("sections" = lookup), nested_data = built)
	else
		push_ui_data(user, data = list("sections" = lookup), nested_data = built)

/client/verb/access_guidebook()
	set name = "Access Guidebook"
	set category = VERB_CATEGORY_OOC

	GLOB.guidebook.ui_interact(src)
