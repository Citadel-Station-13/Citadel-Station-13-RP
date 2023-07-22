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

	data["oocnotes"] = H?.ooc_notes || ""
	data["headshot_url"] = H?.client?.prefs?.headshot_url
	data["fullref_url"] = H?.client?.prefs?.full_ref_url
	data["fullref_toggle"] = H?.client?.prefs?.full_ref_toggle
	data["directory_visible"] = H?.client?.prefs?.show_in_directory
	data["vore_tag"] = H?.client?.prefs?.directory_tag || "Unset"
	data["erp_tag"] = H?.client?.prefs?.directory_erptag || "Unset"
	data["species_name"] = H?.species?.name
	data["species_text"] = html_decode(replacetext(H?.species?.blurb, "<br/>", "\n"))
	data["flavortext_general"] = html_decode(replacetext(H?.flavor_texts["general"], "\n", "<BR>") || "")
	data["flavortext_head"] = html_decode(replacetext(H?.flavor_texts["head"], "\n", "<BR>") || "")
	data["flavortext_face"] = html_decode(replacetext(H?.flavor_texts["face"], "\n", "<BR>") || "")
	data["flavortext_eyes"] = html_decode(replacetext(H?.flavor_texts["eyes"], "\n", "<BR>") || "")
	data["flavortext_torso"] = html_decode(replacetext(H?.flavor_texts["torso"], "\n", "<BR>") || "")
	data["flavortext_arms"] = html_decode(replacetext(H?.flavor_texts["arms"], "\n", "<BR>") || "")
	data["flavortext_hands"] = html_decode(replacetext(H?.flavor_texts["hands"], "\n", "<BR>") || "")
	data["flavortext_legs"] = html_decode(replacetext(H?.flavor_texts["legs"], "\n", "<BR>") || "")
	data["flavortext_feet"] = html_decode(replacetext(H?.flavor_texts["feet"], "\n", "<BR>") || "")

	return data

/datum/description_profile/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	var/mob/living/carbon/human/H = host.resolve()
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "CharacterProfile", "[H]'s Profile")
		ui.open()
