/datum/description_profile
	var/mob/living/carbon/human/host

/datum/description_profile/Destroy(force, ...)
	. = ..()
	host = null

/datum/description_profile/ui_state()
	return GLOB.always_state

/datum/description_profile/ui_assets(mob/user)
	var/mob/living/carbon/human/H = host
	var/datum/asset/simple/character_profile/resource = new()
	resource.host = H
	resource.generate_assets()
	resource.register()
	resource.send(user)
	return list(resource)

/datum/description_profile/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/data[0]
	var/mob/living/carbon/human/H = host
	data["flavortext"] = H.print_flavor_text(FALSE)
	data["oocnotes"] = H.ooc_notes
	data["profiletext"] = say_emphasis(H.profile_text)
	data["headshot_url"] = host.client.prefs.headshot_url
	return data

/datum/description_profile/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	var/mob/living/carbon/human/H = host
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "CharacterProfile", "[H]'s Profile")
		ui.open()
