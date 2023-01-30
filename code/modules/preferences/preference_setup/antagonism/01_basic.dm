var/global/list/uplink_locations = list("PDA", "Headset", "None")

/datum/category_item/player_setup_item/antagonism/basic
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/antagonism/basic/load_character(var/savefile/S)
	S["uplinklocation"] >> pref.uplinklocation
	S["exploit_record"] >> pref.exploit_record
	S["antag_faction"]	>> pref.antag_faction
	S["antag_vis"]		>> pref.antag_vis

/datum/category_item/player_setup_item/antagonism/basic/save_character(var/savefile/S)
	S["uplinklocation"] << pref.uplinklocation
	S["exploit_record"] << pref.exploit_record
	S["antag_faction"]	<< pref.antag_faction
	S["antag_vis"]		<< pref.antag_vis

/datum/category_item/player_setup_item/antagonism/basic/sanitize_character()
	pref.uplinklocation	= sanitize_inlist(pref.uplinklocation, uplink_locations, initial(pref.uplinklocation))
	if(!pref.antag_faction) pref.antag_faction = "None"
	if(!pref.antag_vis) pref.antag_vis = "Hidden"

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/antagonism/basic/copy_to_mob(datum/preferences/prefs, mob/M, data, flags)
	// todo: this is just a shim
	if(!ishuman(M))
		return TRUE
	var/mob/living/carbon/human/character = M
	character.exploit_record = pref.exploit_record
	character.antag_faction = pref.antag_faction
	character.antag_vis = pref.antag_vis
	return TRUE

/datum/category_item/player_setup_item/antagonism/basic/content(datum/preferences/prefs, mob/user, data)
	. += "Faction: <a href='?src=\ref[src];antagfaction=1'>[pref.antag_faction]</a><br/>"
	. += "Visibility: <a href='?src=\ref[src];antagvis=1'>[pref.antag_vis]</a><br/>"
	. +="<b>Uplink Type : <a href='?src=\ref[src];antagtask=1'>[pref.uplinklocation]</a></b>"
	. +="<br>"
	. +="<b>Exploitable information:</b><br>"
	if(jobban_isbanned(user, "Records"))
		. += "<b>You are banned from using character records.</b><br>"
	else
		. +="<a href='?src=\ref[src];exploitable_record=1'>[TextPreview(pref.exploit_record,40)]</a><br>"

/datum/category_item/player_setup_item/antagonism/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	if (href_list["antagtask"])
		pref.uplinklocation = next_list_item(pref.uplinklocation, uplink_locations)
		return PREFERENCES_REFRESH

	if(href_list["exploitable_record"])
		var/exploitmsg = sanitize(input(user,"Set exploitable information about you here.","Exploitable Information", html_decode(pref.exploit_record)) as message|null, MAX_RECORD_LENGTH, extra = 0)
		if(!isnull(exploitmsg) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.exploit_record = exploitmsg
			return PREFERENCES_REFRESH

	if(href_list["antagfaction"])
		var/choice = input(user, "Please choose an antagonistic faction to work for.", "Character Preference", pref.antag_faction) as null|anything in antag_faction_choices + list("None","Other")
		if(!choice || !CanUseTopic(user))
			return PREFERENCES_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter a faction.", "Character Preference")  as text|null, MAX_NAME_LEN)
			if(raw_choice)
				pref.antag_faction = raw_choice
		else
			pref.antag_faction = choice
		return PREFERENCES_REFRESH

	if(href_list["antagvis"])
		var/choice = input(user, "Please choose an antagonistic visibility level.", "Character Preference", pref.antag_vis) as null|anything in antag_visiblity_choices
		if(!choice || !CanUseTopic(user))
			return PREFERENCES_NOACTION
		else
			pref.antag_vis = choice
		return PREFERENCES_REFRESH

	return ..()
