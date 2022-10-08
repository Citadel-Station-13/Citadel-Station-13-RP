// todo: proper tgui preferences

/datum/preferences/proc/species_pick(mob/user)
	if(GLOB.species_picker_active[REF(user)])
		return
	var/current_species_id
	#warn impl
	new /datum/tgui_species_picker(user, resolve_whitelisted_species(), current_species_id, src)

/**
 * gets list of species we can play of those who are whitelisted
 */
/datum/preferences/proc/resolve_whitelisted_species()
	#warn impl

/**
 * check if we can play a species
 */
/datum/preferences/proc/check_species_id(uid)
	var/datum/species/S = get_static_species_meta(uid)
	#warn impl

/datum/preferences/proc/route_species_pick(uid)

GLOBAL_LIST_EMPTY(species_picker_active)
/datum/tgui_species_picker
	/// user ref
	var/user_ref
	/// whitelisted uids
	var/list/whitelisted
	/// default uid
	var/default
	/// preferences
	var/datum/preferences/prefs

/datum/tgui_species_picker/New(mob/user, list/whitelisted_for = list(), default_id, datum/preferences/prefs)
	if(!istype(user) || !istype(prefs))
		qdel(src)
		CRASH("what?")
	src.whitelisted = whitelisted_for
	src.default = default_id
	src.prefs = prefs
	user_ref = REF(user)
	GLOB.species_picker_active += user_ref
	open()

/datum/tgui_species_picker/Destroy()
	GLOB.species_picker_active -= user_ref
	return ..()

/datum/tgui_species_picker/proc/open()
	var/mob/M = locate(user_ref)
	ASSERT(M)
	ui_interact(M)

/datum/tgui_species_picker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpeciesPicker", "Choose Species")
		ui.autoupdate = FALSE			// why the fuck are you updating species data??
		ui.open()

/datum/tgui_species_picker/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/datum/tgui_species_picker/ui_static_data(mob/user)
	. = ..()
	.["whitelisted"] = whitelisted
	.["species"] = SScharacters.species_cache
	.["default"] = default

/datum/tgui_species_picker/ui_close(mob/user)
	. = ..()
	if(!QDELING(src))
		qdel(src)

/datum/tgui_species_picker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("pick")
			prefs.route_species_pick(params["id"])
			qdel(src)
