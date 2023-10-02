//TFF 5/8/19 - moved /datum/preferences to preferences_vr.dm

/datum/category_item/player_setup_item/vore/misc
	name = "Misc Settings"
	sort_order = 10

/datum/category_item/player_setup_item/vore/misc/load_character(var/savefile/S)
	S["show_in_directory"]		>> pref.show_in_directory
	S["directory_tag"]			>> pref.directory_tag
	S["directory_erptag"]			>> pref.directory_erptag
	S["directory_ad"]			>> pref.directory_ad
	S["sensorpref"]				>> pref.sensorpref	//TFF 5/8/19 - add sensor pref setting to load after saved

/datum/category_item/player_setup_item/vore/misc/save_character(var/savefile/S)
	S["show_in_directory"]		<< pref.show_in_directory
	S["directory_tag"]			<< pref.directory_tag
	S["directory_erptag"]			<< pref.directory_erptag
	S["directory_ad"]			<< pref.directory_ad
	S["sensorpref"]				<< pref.sensorpref	//TFF 5/8/19 - add sensor pref setting to be saveable

//TFF 5/8/19 - add new datum category to allow for setting multiple settings when this is selected in the loadout.
/datum/category_item/player_setup_item/vore/misc/copy_to_mob(datum/preferences/prefs, mob/M, data, flags)
	// todo: this is just a shim
	if(!ishuman(M))
		return TRUE
	var/mob/living/carbon/human/character = M
	if(pref.sensorpref > 5 || pref.sensorpref < 1)
		pref.sensorpref = 5
	character.sensorpref = pref.sensorpref
	return TRUE

/datum/category_item/player_setup_item/vore/misc/sanitize_character()
	pref.show_in_directory		= sanitize_integer(pref.show_in_directory, 0, 1, initial(pref.show_in_directory))
	pref.directory_tag			= sanitize_inlist(pref.directory_tag, GLOB.char_directory_tags, initial(pref.directory_tag))
	pref.directory_erptag			= sanitize_inlist(pref.directory_erptag, GLOB.char_directory_erptags, initial(pref.directory_erptag))
	pref.sensorpref				= sanitize_integer(pref.sensorpref, 1, sensorpreflist.len, initial(pref.sensorpref))	//TFF - 5/8/19 - add santisation for sensor prefs

/datum/category_item/player_setup_item/vore/misc/content(datum/preferences/prefs, mob/user, data)
	. += "<br>"
	. += "<b>Appear in Character Directory:</b> <a [pref.show_in_directory ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_show_in_directory=1'><b>[pref.show_in_directory ? "Yes" : "No"]</b></a><br>"
	. += "<b>Character Directory Vore Tag:</b> <a href='?src=\ref[src];directory_tag=1'><b>[pref.directory_tag]</b></a><br>"
	. += "<b>Character Directory ERP Tag:</b> <a href='?src=\ref[src];directory_erptag=1'><b>[pref.directory_erptag]</b></a><br>"
	. += "<b>Suit Sensors Preference:</b> <a [pref.sensorpref ? "" : ""] href='?src=\ref[src];toggle_sensor_setting=1'><b>[sensorpreflist[pref.sensorpref]]</b></a><br>"	//TFF 5/8/19 - Allow selection of sensor settings from off, binary, vitals, tracking, or random

/datum/category_item/player_setup_item/vore/misc/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(href_list["toggle_show_in_directory"])
		pref.show_in_directory = pref.show_in_directory ? 0 : 1;
		return PREFERENCES_REFRESH
	else if(href_list["directory_tag"])
		var/new_tag = tgui_input_list(user, "Pick a new tag for the character directory", "Character Tag", GLOB.char_directory_tags, pref.directory_tag)
		if(!new_tag)
			return
		pref.directory_tag = new_tag
		return PREFERENCES_REFRESH
	else if(href_list["directory_erptag"])
		var/new_erptag = tgui_input_list(user, "Pick a new ERP tag for the character directory", "Character ERP Tag", GLOB.char_directory_erptags, pref.directory_erptag)
		if(!new_erptag)
			return
		pref.directory_erptag = new_erptag
		return PREFERENCES_REFRESH
	else if(href_list["directory_ad"])
		var/msg = sanitize(input(user,"Write your advertisement here!", "Flavor Text", html_decode(pref.directory_ad)) as message, extra = 0)
		pref.directory_ad = msg
		return PREFERENCES_REFRESH
	//TFF 5/8/19 - add new thing so you can choose the sensor setting your character can get.
	else if(href_list["toggle_sensor_setting"])
		var/new_sensorpref = tgui_input_list(user, "Choose your character's sensor preferences:", "Character Preferences", sensorpreflist, sensorpreflist[pref.sensorpref])
		if (!isnull(new_sensorpref) && CanUseTopic(user))
			pref.sensorpref = sensorpreflist.Find(new_sensorpref)
			return PREFERENCES_REFRESH
	return ..();
