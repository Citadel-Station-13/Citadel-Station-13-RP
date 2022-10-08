/datum/controller/subsystem/characters
	//! Backgrounds - to be shoved into some lore system later (maybe)
	var/list/character_origins
	var/list/character_citizenships
	var/list/character_religions
	var/list/character_factions

/datum/controller/subsystem/characters/proc/rebuild_backgrounds()
	character_origins = list()
	character_citizenships = list()
	character_religions = list()
	character_factions = list()

	for(var/path in subtypesof(/datum/lore/character_background))
		var/datum/lore/character_background/L = path
		if(initial(L.abstract_type) == path)
			continue
		L = new path
		if(istype(L, /datum/lore/character_background/citizenship))
			character_citizenships += L
		if(istype(L, /datum/lore/character_background/origin))
			character_origins += L
		if(istype(L, /datum/lore/character_background/religion))
			character_religions += L
		if(istype(L, /datum/lore/character_background/faction))
			character_factions += L
