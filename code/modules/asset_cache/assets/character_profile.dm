/datum/asset/simple/character_profile
	var/mob/living/carbon/human/host

/datum/asset/simple/character_profile/proc/generate_assets()
	var/headshot_path
	if(fexists("headshot_images/[host.name].png"))
		headshot_path = "headshot_images/[host.name].png"
	else
		headshot_path = "icons/headshot_not_found.png"
	var/image/ingame_preview = getIconMask(host)
	if(!ingame_preview)
		ingame_preview = image('icons/404_profile_not_found.dmi')
	assets = list(
		"character_headshot.png" = headshot_path,
		"character_preview.png" = ingame_preview
	)
