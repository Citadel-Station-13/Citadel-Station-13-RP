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
	var/list/names = config.all_alien_whitelists_for(client_ckey)
	. = list()
	for(var/n in names)
		var/datum/character_species/CS = SScharacters.resolve_character_species(n)
		if(CS)
			. += CS.uid

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

/*

/datum/category_item/player_setup_item/general/body/proc/SetSpecies(mob/user)
	#warn what the fuck
	if(!pref.species_preview || !(pref.species_preview in SScharacters.all_species_names()))
		pref.species_preview = SPECIES_HUMAN
	var/datum/species/current_species = SScharacters.resolve_species_name(pref.species_preview)
	var/dat = "<body>"
	dat += "<center><h2>[current_species.name] \[<a href='?src=\ref[src];show_species=1'>change</a>\]</h2></center><hr/>"
	dat += "<table padding='8px'>"
	dat += "<tr>"
	if(current_species.wikilink)
		dat += "<td width = 400>[current_species.blurb]<br><br>See <a href=[current_species.wikilink]>the wiki</a> for more details.</td>"
	else
		dat += "<td width = 400>[current_species.blurb]</td>"
	dat += "<td width = 200 align='center'>"
	if(current_species.preview_icon)
		usr << browse_rsc(icon(icon = current_species.preview_icon, icon_state = ""), "species_preview_[current_species.name].png")
		dat += "<img src='species_preview_[current_species.name].png' width='64px' height='64px'><br/><br/>"
	dat += "<b>Language:</b> [current_species.species_language]<br/>"
	dat += "<small>"
	if(current_species.species_spawn_flags & SPECIES_SPAWN_ALLOWED)
		switch(current_species.rarity_value)
			if(1 to 2)
				dat += "</br><b>Often present on human stations.</b>"
			if(3 to 4)
				dat += "</br><b>Rarely present on human stations.</b>"
			if(5)
				dat += "</br><b>Unheard of on human stations.</b>"
			else
				dat += "</br><b>May be present on human stations.</b>"
	if(current_species.species_spawn_flags & SPECIES_SPAWN_WHITELISTED)
		dat += "</br><b>Whitelist restricted.</b>"
	if(!current_species.has_organ[O_HEART])
		dat += "</br><b>Does not have a circulatory system.</b>"
	if(!current_species.has_organ[O_LUNGS])
		dat += "</br><b>Does not have a respiratory system.</b>"
	if(current_species.species_flags & NO_SCAN)
		dat += "</br><b>Does not have DNA.</b>"
	if(current_species.species_flags & NO_PAIN)
		dat += "</br><b>Does not feel pain.</b>"
	if(current_species.species_flags & NO_SLIP)
		dat += "</br><b>Has excellent traction.</b>"
	if(current_species.species_flags & NO_POISON)
		dat += "</br><b>Immune to most poisons.</b>"
	if(current_species.species_appearance_flags & HAS_SKIN_TONE)
		dat += "</br><b>Has a variety of skin tones.</b>"
	if(current_species.species_appearance_flags & HAS_BASE_SKIN_COLOR)
		dat += "</br><b>Has a small number of base skin colors.</b>"
	if(current_species.species_appearance_flags & HAS_SKIN_COLOR)
		dat += "</br><b>Has a variety of skin colours.</b>"
	if(current_species.species_appearance_flags & HAS_EYE_COLOR)
		dat += "</br><b>Has a variety of eye colours.</b>"
	if(current_species.species_flags & IS_PLANT)
		dat += "</br><b>Has a plantlike physiology.</b>"
	dat += "</small></td>"
	dat += "</tr>"
	dat += "</table><center><hr/>"

	var/restricted = 0

	if(!(current_species.species_spawn_flags & SPECIES_SPAWN_ALLOWED))
		restricted = 2
	else if(!is_alien_whitelisted(preference_mob(),current_species))
		restricted = 1

	if(restricted)
		if(restricted == 1)
			dat += "<font color='red'><b>You cannot play as this species.</br><small>If you wish to be whitelisted, you can make an application post on <a href='?src=\ref[user];preference=open_whitelist_forum'>the forums</a>.</small></b></font></br>"
		else if(restricted == 2)
			dat += "<font color='red'><b>You cannot play as this species.</br><small>This species is not available for play as a station race..</small></b></font></br>"
	if(!restricted || check_rights(R_ADMIN, 0) || current_species.species_spawn_flags & SPECIES_SPAWN_WHITELIST_SELECTABLE)	//selectability
		dat += "\[<a href='?src=\ref[src];set_species=[pref.species_preview]'>select</a>\]"
	dat += "</center></body>"

	user << browse(dat, "window=species;size=700x400")

AAAAAAAAAAA
*/

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
