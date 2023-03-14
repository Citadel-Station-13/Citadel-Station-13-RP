/////////////////////////////////////////
//			Alt Title Code
/////////////////////////////////////////

/datum/prototype/alt_title
	abstract_type = /datum/prototype/alt_title
	namespace = "role_title"
	anonymous = TRUE

	var/title = "GENERIC ALT TITLE"				// What the Alt-Title is called
	var/title_blurb = null						// What's amended to the job description for this Job title. If nothing's added, leave null.
	var/title_outfit = null						// The outfit used by the alt-title. If it's the same as the base job, leave this null.

	/// restricted: require these hardcoded lore datums, by typepath or id.
	/// null for anything/anyone
	var/list/background_allow
	/// restricted: forbid anyone with these hardcoded lore datums, by typepath or id.
	/// null for anything/anyone
	var/list/background_forbid
	/// strictness: if a title has this on and someone is able to choose it, they can only choose jobs they're allowed to in background_allow
	var/background_enforce = FALSE

/datum/prototype/alt_title/New()
	for(var/i in 1 to length(background_allow))
		var/thing = background_allow[i]
		if(ispath(thing))
			var/datum/lore/character_background/bg = thing
			background_allow[i] = initial(bg.id)
	for(var/i in 1 to length(background_forbid))
		var/thing = background_forbid[i]
		if(ispath(thing))
			var/datum/lore/character_background/bg = thing
			background_forbid[i] = initial(bg.id)
	return ..()

/**
 * checks if a list of background ids is valid to use us as a title
 *
 * note: this technically returns any number from 0 to inf,
 * so, use !! on your side to trample to 0 or 1 if you really need that.
 *
 * @params
 * * background_ids - background ids as list
 * * strict - if enabled, only returns true if an id has an exact match with allow.
 */
/datum/prototype/alt_title/proc/check_background_ids(list/background_ids, strict)
	if(strict)
		return length(background_allow & background_ids)
	if(isnull(background_allow))
		return !length(background_forbid & background_ids)
	return length(background_allow & background_ids)
