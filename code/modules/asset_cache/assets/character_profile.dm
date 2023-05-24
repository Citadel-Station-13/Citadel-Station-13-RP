/datum/asset/simple/character_profile
	var/mob/living/carbon/human/host

/datum/asset/simple/character_profile/Destroy(force, ...)
	. = ..()
	host = null

/datum/asset/simple/character_profile/proc/generate_assets()
	var/image/ingame_preview = getIconMask(host)
	if(!ingame_preview)
		ingame_preview = image('icons/404_profile_not_found.dmi')
	assets = list(
		"character_preview.png" = ingame_preview
	)
