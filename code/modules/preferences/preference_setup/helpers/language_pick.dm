// todo: proper tgui preferences

/datum/preferences/proc/language_pick(mob/user)
	if(GLOB.language_picker_active[REF(user)])
		return
	new /datum/tgui_language_picker(user, src)

/datum/preferences/proc/route_language_pick(id, mob/user)
	return language_pick_finalize(id, user)

/datum/preferences/proc/language_pick_finalize(id, mob/user)
	var/datum/language/L = SScharacters.resolve_language_id(id)
	if(!L)
		to_chat(user, SPAN_WARNING("BUG: Invalid language ID: [id]"))
		return TRUE
	if(extraneous_language_ids().len > extraneous_languages_max())
		to_chat(user, SPAN_WARNING("You cannot select another language!"))
		return TRUE
	var/datum/character_species/CS = character_species_datum()
	if((L.language_flags & WHITELISTED) && !((L.id in CS.whitelist_languages) || config.check_alien_whitelist(ckey(L.name), client_ckey)))
		to_chat(user, SPAN_WARNING("[L.name] is a whitelisted language!"))
		return FALSE
	var/list/current = get_character_data(CHARACTER_DATA_LANGUAGES)
	current += L.id
	set_character_data(CHARACTER_DATA_LANGUAGES, current)
	refresh(user)
	return TRUE

GLOBAL_LIST_EMPTY(language_picker_active)
/datum/tgui_language_picker
	/// user ref
	var/user_ref
	/// preferences
	var/datum/preferences/prefs

/datum/tgui_language_picker/New(mob/user, datum/preferences/prefs)
	if(!istype(user) || !istype(prefs))
		qdel(src)
		CRASH("what?")
	src.prefs = prefs
	user_ref = REF(user)
	GLOB.language_picker_active[user_ref] = src
	open()

/datum/tgui_language_picker/Destroy()
	SStgui.close_uis(src)
	GLOB.language_picker_active -= user_ref
	return ..()

/datum/tgui_language_picker/proc/open()
	var/mob/M = locate(user_ref)
	ASSERT(M)
	ui_interact(M)

/datum/tgui_language_picker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LanguagePicker", "Choose language")
		ui.autoupdate = FALSE			// why the fuck are you updating language data??
		ui.open()

/datum/tgui_language_picker/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/datum/tgui_language_picker/ui_static_data(mob/user)
	var/list/data = ..()
	var/list/built = list()
	var/list/categories = list("General")
	for(var/datum/language/L as anything in SScharacters.all_languages())
		if(L.language_flags & RESTRICTED)
			continue
		built[++built.len] = list(
			"id" = L.id,
			"name" = L.name,
			"desc" = L.desc,
			"category" = L.category
		)
		LAZYOR(categories, L.category)
	data["languages"] = built
	data["categories"] = categories
	return data

/datum/tgui_language_picker/ui_close(mob/user)
	. = ..()
	if(!QDELING(src))
		qdel(src)

/datum/tgui_language_picker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("pick")
			if(prefs.route_language_pick(params["id"], usr))
				qdel(src)
