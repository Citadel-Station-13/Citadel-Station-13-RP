//! ## Soundbyte Mangaer
/datum/controller/subsystem/sounds
	/// soundbytes by id - text id = sound
	var/list/soundbytes_by_id
	/// soundbytes by alias - alias = list(sounds)
	var/list/soundbytes_by_alias

/datum/controller/subsystem/sounds/proc/setup_soundbytes()
	// kill old
	if(islist(soundbytes_by_id))
		for(var/datum/soundbyte/SB in soundbytes_by_id)
			qdel(SB)
	soundbytes_by_id = list()
	if(islist(soundbytes_by_alias))
		for(var/alias in soundbytes_by_alias)
			var/list/L = soundbytes_by_alias[alias]
			if(L)
				for(var/datum/soundbyte/SB in L)
					qdel(SB)
	soundbytes_by_alias = list()
	for(var/T in subtypesof(/datum/soundbyte))
		var/datum/soundbyte/SB = T
		if(!initial(SB.path) && !ispath(SB, /datum/soundbyte/grouped))
			continue
		SB = new T
		if(!ispath(SB, /datum/soundbyte/grouped))
			// detect runtime loading
			SB.runtime_loaded = (istext(SB.path) && (findtext(SB.path, "sound/runtime") == 1)) || FALSE
		SB.id = "[T]"			// let's have only text in here, eh?
		soundbytes_by_id[SB.id] = SB
		if(SB.alias)
			if(!soundbytes_by_alias[SB.alias])
				soundbytes_by_alias[SB.alias] = list()
			soundbytes_by_alias[SB.alias] += SB

	// TODO: unit test the shit out of soundbytes so no one does stupid things, like empty grouped lists since we can't initial that

/**
 * fetch soundbyte by alias or id
 * you should almost never need to do this
 */
/datum/controller/subsystem/sounds/proc/fetch_soundbyte(alias)
	RETURN_TYPE(/datum/soundbyte)
	alias = "[alias]"
	if(soundbytes_by_alias[alias])
		return pick(soundbytes_by_alias[alias])
	return soundbytes_by_id[alias]

/**
 * fetch sound file/path/asset by alias or id
 * defaults to alias itself if not found, so passing in a valid sound datum is fine
 */
/datum/controller/subsystem/sounds/proc/fetch_asset(alias)
	return fetch_soundbyte(alias)?.get_asset() || alias

/**
 * fetch sound object
 * defaults to alias itself, so passing in a valid sound datum is fine
 */
/datum/controller/subsystem/sounds/proc/create_sfx(alias)
	return fetch_soundbyte(alias)?.instance_sound() || alias

///////////// TODO: dynamic soundbyte creation but we can deal with this later ////////////
