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
	var/datum/species/S = SScharacters.resolve_species_path(uid)
	#warn impl

/datum/preferences/proc/route_species_pick(uid, mob/user)
	// return true to close window
#warn besure to pick real species using this as fallback for char species removals
#warn besure to refresh

/datum/preferences/proc/species_pick_finalize(uid, mob/user)

/datum/preferences/proc/set_character_species(datum/character_species/S, mob/user)

#warn impl below :/
/*

	else if(href_list["set_species"])
		user << browse(null, "window=species")
		if(!pref.species_preview || !(pref.species_preview in SScharacters.all_species_names()))
			return PREFERENCES_NOACTION

		var/datum/species/setting_species

		if(SScharacters.resolve_species_name(href_list["set_species"]))
			setting_species = SScharacters.resolve_species_name(href_list["set_species"])
		else
			return PREFERENCES_NOACTION

		if(((!(setting_species.species_spawn_flags & SPECIES_SPAWN_ALLOWED)) || (!is_alien_whitelisted(preference_mob(),setting_species))) && !check_rights(R_ADMIN, 0) && !(setting_species.species_spawn_flags & SPECIES_SPAWN_WHITELIST_SELECTABLE))
			return PREFERENCES_NOACTION

		var/prev_species = pref.species
		pref.species = href_list["set_species"]
		if(prev_species != pref.species)
			if(!(pref.biological_gender in mob_species.genders))
				pref.set_biological_gender(mob_species.genders[1])
			pref.custom_species = null // This is cleared on species changes

			//grab one of the valid hair styles for the newly chosen species
			var/list/valid_hairstyles = pref.get_valid_hairstyles()

			if(valid_hairstyles.len)
				pref.h_style = pick(valid_hairstyles)
			else
				//this shouldn't happen
				pref.h_style = hair_styles_list["Bald"]

			//grab one of the valid facial hair styles for the newly chosen species
			var/list/valid_facialhairstyles = pref.get_valid_facialhairstyles()

			if(valid_facialhairstyles.len)
				pref.f_style = pick(valid_facialhairstyles)
			else
				//this shouldn't happen
				pref.f_style = facial_hair_styles_list["Shaved"]

			//reset hair colour and skin colour
			pref.r_hair = 0//hex2num(copytext(new_hair, 2, 4))
			pref.g_hair = 0//hex2num(copytext(new_hair, 4, 6))
			pref.b_hair = 0//hex2num(copytext(new_hair, 6, 8))
			pref.s_tone = 0

			reset_limbs() // Safety for species with incompatible manufacturers; easier than trying to do it case by case.
			pref.body_markings.Cut() // Basically same as above.

			var/min_age = get_min_age()
			var/max_age = get_max_age()
			pref.age = max(min(pref.age, max_age), min_age)

			return PREFERENCES_REFRESH_UPDATE_PREVIEW
*/


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

#warn make ui
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
	.["species"] = SScharacters.character_species_cache
	.["default"] = default

/datum/tgui_species_picker/ui_close(mob/user)
	. = ..()
	if(!QDELING(src))
		qdel(src)

/datum/tgui_species_picker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("pick")
			if(prefs.route_species_pick(params["id"], usr))
				qdel(src)
