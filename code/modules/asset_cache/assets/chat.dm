/datum/asset_pack/spritesheet/chat
	name = "chat"

/datum/asset_pack/spritesheet/chat/generate()
	insert_all("emoji", EMOJI_SET)
	insert_all("emoji", EMOJI32_SET)
	/*
	// pre-loading all lanugage icons also helps to avoid meta
	insert_all("language", 'icons/misc/language.dmi')
	// catch languages which are pulling icons from another file
	for(var/path in typesof(/datum/prototype/language))
		var/datum/prototype/language/L = path
		var/icon = initial(L.icon)
		if (icon != 'icons/misc/language.dmi')
			var/icon_state = initial(L.icon_state)
			Insert("language-[icon_state]", icon, icon_state=icon_state)
	*/
