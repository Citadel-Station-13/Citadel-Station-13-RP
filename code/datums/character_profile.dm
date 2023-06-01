GLOBAL_LIST_EMPTY(cached_previews)

/datum/description_profile
	var/datum/weakref/host

/datum/description_profile/New(var/host_mob)
	. = ..()
	host = WEAKREF(host_mob)


/datum/description_profile/Destroy(force, ...)
	. = ..()
	host = null

/datum/description_profile/ui_state()
	return GLOB.always_state

/datum/description_profile/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/data[0]
	var/mob/living/carbon/human/H = host.resolve()
	var/image/ingame_preview
	var/preview_name = "preview_[rand(1,9999)]_[H.name].png" //nobody should ever be named the same in a round, but just in case, a little randomness to prevent collisions.

	if (!(H.name in GLOB.cached_previews))
		ingame_preview = get_flat_icon(H)
		if(!ingame_preview) //flat icon fails for whatever reason, this should probably throw an error.
			ingame_preview = image('icons/404_profile_not_found.dmi')
		GLOB.cached_previews[H.name] = ingame_preview
	else
		ingame_preview = GLOB.cached_previews[H.name]

	user << browse_rsc(ingame_preview, preview_name)

	data["flavortext"] = H?.flavor_text || ""
	data["oocnotes"] = H?.ooc_notes || ""
	data["headshot_url"] = H?.client?.prefs?.headshot_url || ""
	data["preview_name"] = preview_name
	data["directory_visible"] = H?.client?.prefs?.show_in_directory
	data["vore_tag"] = H?.client?.prefs?.directory_tag || "Unset"
	data["erp_tag"] = H?.client?.prefs?.directory_erptag || "Unset"
	data["species_name"] = H?.species?.name
	data["species_text"] = replacetext(H?.species?.blurb, "<br/>", "\n")

	return data

/datum/description_profile/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	var/mob/living/carbon/human/H = host.resolve()
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "CharacterProfile", "[H]'s Profile")
		ui.open()
