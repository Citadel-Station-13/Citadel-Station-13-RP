//this exists purely to avoid meta by pre-loading all language icons.
/datum/asset_pack/language

/datum/asset_pack/language/register()
	set waitfor = FALSE

	for(var/path in typesof(/datum/language))
		var/datum/language/language = new path()
		language.get_icon()
