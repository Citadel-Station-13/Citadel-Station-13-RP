// todo: proper tgui preferences

/datum/preferences/proc/species_pick(mob/user)
	#warn impl

/**
 * returns list(category = list({id, name, desc: 1 | 0}, ...))
 */
/datum/preferences/proc/resolve_species_data()
	return SScharacters.species_ui_cache

/**
 * gets list of species we *can't* play
 */
/datum/preferences/proc/resolve_locked_species()

/**
 * check if we can play a species
 */
/datum/preferences/proc/check_species_id(uid)
	var/datum/species/S = get_static_species_meta(uid)


/datum/tgui_species_picker
	/// allowed species ids


/datum/tgui_species_picker
