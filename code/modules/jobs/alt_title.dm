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

	/// restricted: require these hardcoded lore datums to be associated with the characters by typepath or id.
	/// null for anything/anyone
	var/list/background_restricted

/datum/prototype/alt_title/New()
	for(var/i in 1 to length(background_restricted))
		var/thing = background_restricted[i]
		if(ispath(thing))
			var/datum/lore/character_background/bg = thing
			background_restricted[i] = initial(bg.id)
	return ..()
