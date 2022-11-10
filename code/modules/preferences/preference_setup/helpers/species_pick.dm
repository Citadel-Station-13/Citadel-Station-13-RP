// todo: proper tgui preferences

/datum/preferences/proc/species_pick(mob/user)
	if(GLOB.species_picker_active[REF(user)])
		return
	var/current_species_id = character_species_id()
	new /datum/tgui_species_picker(user, resolve_whitelisted_species(), current_species_id, src)

/**
 * gets list of species we can play of those who are whitelisted
 */
/datum/preferences/proc/resolve_whitelisted_species()
	var/list/names = config.all_alien_whitelists_for(client_ckey)
	. = list()
	for(var/datum/character_species/CS as anything in SScharacters.all_character_species())
		if(ckey(CS.name) in names)
			. += CS.uid

/**
 * check if we can play a species
 */
/datum/preferences/proc/check_character_species(datum/character_species/CS)
	if(CS.whitelisted && !(config.check_alien_whitelist(ckey(CS.name), client_ckey)))
		return FALSE
	return TRUE

/datum/preferences/proc/route_species_pick(uid, mob/user)
	// return true to close window
	return species_pick_finalize(uid, user)

/datum/preferences/proc/species_pick_finalize(uid, mob/user)
	var/datum/character_species/CS = SScharacters.resolve_character_species(uid)
	if(!CS)
		to_chat(user, SPAN_WARNING("No species by id [uid] found; this is likely a bug!"))
		return TRUE // close window; it shouldn't be letting us select null species
	if(!check_character_species(CS, user))
		return TRUE	// close window; it shouldn't be letting us select whitelisted speices
	set_character_species(CS, user)
	refresh(user, TRUE)
	return TRUE	// yay done

/datum/preferences/proc/set_character_species(datum/character_species/CS, mob/user)
	// first set their vars
	set_preference(/datum/category_item/player_setup_item/background/real_species, CS.real_species_uid())
	set_preference(/datum/category_item/player_setup_item/background/char_species, CS.uid)
	custom_species = null
	//! WARNING: SHITCODE AHEAD / LEGACY SHIMS
	// so because the guy who made body limbs was too lazy to make sanitization, we have to fully reset it
	// as well as some other stuff
	// are you fucking kidding me lol
	// gender
	if(!(biological_gender in CS.genders))
		biological_gender = SAFEACCESS(CS.genders, 1) || MALE
	// hair/fhair
	var/list/valid_hair = get_valid_hairstyles()
	var/list/valid_fhair = get_valid_facialhairstyles()
	if(!(h_style in valid_hair))
		var/datum/sprite_accessory/hair/H = /datum/sprite_accessory/hair/bald
		h_style = initial(H.name)
	if(!(f_style in valid_fhair))
		var/datum/sprite_accessory/facial_hair/FH = /datum/sprite_accessory/facial_hair/shaved
		f_style = initial(FH.name)
	// limbs/markings
	reset_limbs()
	body_markings.Cut()
	// age
	age = clamp(age, CS.min_age, CS.max_age)
	//! END
	// then resanitize literally everything
	player_setup.sanitize_setup()	// todo: legacy, remove
	sanitize_everything()
	// then update their join menu if they're a chucklefuck and had it open
	GLOB.join_menu?.update_static_data(user)

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
	GLOB.species_picker_active[user_ref] = src
	open()

/datum/tgui_species_picker/Destroy()
	SStgui.close_uis(src)
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
	var/list/data = ..()
	data["whitelisted"] = whitelisted
	data["species"] = SScharacters.character_species_cache
	data["default"] = default
	data["admin"] = !!admin_datums[user.ckey]
	return data

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
