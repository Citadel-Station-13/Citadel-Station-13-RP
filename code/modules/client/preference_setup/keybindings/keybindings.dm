/datum/preferences
	//These are stored as /datum/keybind/path/to/keybind = keystring
	var/list/keybindings_hotkey_primary
	var/list/keybindings_hotkey_secondary
	var/list/keybindings_hotkey_tertiary
	var/list/keybindings_classic_primary
	var/list/keybindings_classic_secondary
	var/list/keybindings_classic_tertiary
	//This is generated from the above and stored as keystring = /datum/keybind/path/to/keybind
	var/list/hotkey_keybindings_by_keystring
	var/list/classic_keybindings_by_keystring

//DOES NOT CHECK FOR DUPLICATES!
/datum/preferences/proc/generate_keybindings_by_keystring()
	var/list/hotkey_bindings = keybindings_hotkey_primary | keybindings_hotkey_secondary | keybindings_hotkey_tertiary
	var/list/classic_bindings = keybindings_classic_primary | keybindings_classic_secondary | keybindings_classic_tertiary



/datum/category_group/player_setup_category/keybindings
	name = "Keybindings"
	sort_order = 7
	category_item_type = /datum/category_item/player_setup_item/keybinding_category

/datum/category_group/player_setup_category/keybindings/init_items()
	for(var/i in SSinput.keybind_categories)
		var/datum/category_item/player_setup_item/keybinding_category/I = new(src)
		I.name = i
		items += I
		items_by_name[I.name] = I

/datum/category_item/player_setup_item/keybinding_category/content(mob/user)

	for(var/i in SSinput.keybind_categories[name])











#define TOPIC_NOACTION 0
#define TOPIC_HANDLED 1
#define TOPIC_REFRESH 2
#define TOPIC_UPDATE_PREVIEW 4
#define TOPIC_REFRESH_UPDATE_PREVIEW (TOPIC_REFRESH|TOPIC_UPDATE_PREVIEW)


/**************************
* Category Category Setup *
**************************/
/datum/category_group/player_setup_category
	var/sort_order = 0

/datum/category_group/player_setup_category/dd_SortValue()
	return sort_order

/datum/category_group/player_setup_category/proc/sanitize_setup()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_preferences()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_character()

/datum/category_group/player_setup_category/proc/load_character(var/savefile/S)
	// Load all data, then sanitize it.
	// Need due to, for example, the 01_basic module relying on species having been loaded to sanitize correctly but that isn't loaded until module 03_body.
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.load_character(S)

/datum/category_group/player_setup_category/proc/save_character(var/savefile/S)
	// Sanitize all data, then save it
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_character()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.save_character(S)

/datum/category_group/player_setup_category/proc/load_preferences(var/savefile/S)
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.load_preferences(S)

/datum/category_group/player_setup_category/proc/save_preferences(var/savefile/S)
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_preferences()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.save_preferences(S)

/datum/category_group/player_setup_category/proc/copy_to_mob(var/mob/living/carbon/human/C)
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.copy_to_mob(C)

/datum/category_group/player_setup_category/proc/content(var/mob/user)
	. = "<table style='width:100%'><tr style='vertical-align:top'><td style='width:50%'>"
	var/current = 0
	var/halfway = items.len / 2
	for(var/datum/category_item/player_setup_item/PI in items)
		if(halfway && current++ >= halfway)
			halfway = 0
			. += "</td><td></td><td style='width:50%'>"
		. += "[PI.content(user)]<br>"
	. += "</td></tr></table>"

/datum/category_group/player_setup_category/occupation_preferences/content(var/mob/user)
	for(var/datum/category_item/player_setup_item/PI in items)
		. += "[PI.content(user)]<br>"

/**********************
* Category Item Setup *
**********************/
/datum/category_item/player_setup_item
	var/sort_order = 0
	var/datum/preferences/pref

/datum/category_item/player_setup_item/New()
	..()
	var/datum/category_collection/player_setup_collection/psc = category.collection
	pref = psc.preferences

/datum/category_item/player_setup_item/Destroy()
	pref = null
	return ..()

/datum/category_item/player_setup_item/dd_SortValue()
	return sort_order

/*
* Called when the item is asked to load per character settings
*/
/datum/category_item/player_setup_item/proc/load_character(var/savefile/S)
	return

/*
* Called when the item is asked to save per character settings
*/
/datum/category_item/player_setup_item/proc/save_character(var/savefile/S)
	return

/*
* Called when the item is asked to load user/global settings
*/
/datum/category_item/player_setup_item/proc/load_preferences(var/savefile/S)
	return

/*
* Called when the item is asked to save user/global settings
*/
/datum/category_item/player_setup_item/proc/save_preferences(var/savefile/S)
	return

/*
* Called when the item is asked to apply its per character settings to a new mob.
*/
/datum/category_item/player_setup_item/proc/copy_to_mob(var/mob/living/carbon/human/C)
	return

/datum/category_item/player_setup_item/proc/content()
	return

/datum/category_item/player_setup_item/proc/sanitize_character()
	return

/datum/category_item/player_setup_item/proc/sanitize_preferences()
	return

/datum/category_item/player_setup_item/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	var/mob/pref_mob = preference_mob()
	if(!pref_mob || !pref_mob.client)
		return 1

	. = OnTopic(href, href_list, usr)
	if(. & TOPIC_UPDATE_PREVIEW)
		pref_mob.client.prefs.preview_icon = null
	if(. & TOPIC_REFRESH)
		pref_mob.client.prefs.ShowChoices(usr)

/datum/category_item/player_setup_item/CanUseTopic(var/mob/user)
	return 1

/datum/category_item/player_setup_item/proc/OnTopic(var/href,var/list/href_list, var/mob/user)
	return TOPIC_NOACTION

/datum/category_item/player_setup_item/proc/preference_mob()
	if(!pref.client)
		for(var/client/C)
			if(C.ckey == pref.client_ckey)
				pref.client = C
				break

	if(pref.client)
		return pref.client.mob

/datum/preferences
	var/preferences_enabled = null
	var/preferences_disabled = null

/datum/category_item/player_setup_item/player_global/settings
	name = "Settings"
	sort_order = 2

/datum/category_item/player_setup_item/player_global/settings/load_preferences(var/savefile/S)
	S["lastchangelog"]			>> pref.lastchangelog
	S["lastnews"]				>> pref.lastnews
	S["default_slot"]			>> pref.default_slot
	S["preferences"]			>> pref.preferences_enabled
	S["preferences_disabled"]	>> pref.preferences_disabled
	S["menuoptions"]			>> pref.menuoptions

/datum/category_item/player_setup_item/player_global/settings/save_preferences(var/savefile/S)
	S["lastchangelog"]			<< pref.lastchangelog
	S["lastnews"]				<< pref.lastnews
	S["default_slot"]			<< pref.default_slot
	S["preferences"]			<< pref.preferences_enabled
	S["preferences_disabled"]	<< pref.preferences_disabled
	S["menuoptions"]			<< pref.menuoptions
/datum/category_item/player_setup_item/player_global/settings/sanitize_preferences()
	// Ensure our preferences are lists.
	if(!istype(pref.preferences_enabled, /list))
		pref.preferences_enabled = list()
	if(!istype(pref.preferences_disabled, /list))
		pref.preferences_disabled = list()

	// Arrange preferences that have never been enabled/disabled.
	var/list/client_preference_keys = list()
	for(var/cp in get_client_preferences())
		var/datum/client_preference/client_pref = cp
		client_preference_keys += client_pref.key
		if((client_pref.key in pref.preferences_enabled) || (client_pref.key in pref.preferences_disabled))
			continue

		if(client_pref.enabled_by_default)
			pref.preferences_enabled += client_pref.key
		else
			pref.preferences_disabled += client_pref.key

	// Clean out preferences that no longer exist.
	for(var/key in pref.preferences_enabled)
		if(!(key in client_preference_keys))
			pref.preferences_enabled -= key
	for(var/key in pref.preferences_disabled)
		if(!(key in client_preference_keys))
			pref.preferences_disabled -= key

	pref.lastchangelog	= sanitize_text(pref.lastchangelog, initial(pref.lastchangelog))
	pref.lastnews		= sanitize_text(pref.lastnews, initial(pref.lastnews))
	pref.default_slot	= sanitize_integer(pref.default_slot, 1, config.character_slots, initial(pref.default_slot))
	pref.menuoptions		= SANITIZE_LIST(pref.menuoptions)

/datum/category_item/player_setup_item/player_global/settings/content(var/mob/user)
	. = list()
	. += "<b>Preferences</b><br>"
	. += "<table>"
	var/mob/pref_mob = preference_mob()
	for(var/cp in get_client_preferences())
		var/datum/client_preference/client_pref = cp
		if(!client_pref.may_toggle(pref_mob))
			continue

		. += "<tr><td>[client_pref.description]: </td>"
		if(pref_mob.is_preference_enabled(client_pref.key))
			. += "<td><span class='linkOn'><b>[client_pref.enabled_description]</b></span></td> <td><a href='?src=\ref[src];toggle_off=[client_pref.key]'>[client_pref.disabled_description]</a></td>"
		else
			. += "<td><a  href='?src=\ref[src];toggle_on=[client_pref.key]'>[client_pref.enabled_description]</a></td> <td><span class='linkOn'><b>[client_pref.disabled_description]</b></span></td>"
		. += "</tr>"

	. += "</table>"
	return jointext(., "")

/datum/category_item/player_setup_item/player_global/settings/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/mob/pref_mob = preference_mob()
	if(href_list["toggle_on"])
		. = pref_mob.set_preference(href_list["toggle_on"], TRUE)
	else if(href_list["toggle_off"])
		. = pref_mob.set_preference(href_list["toggle_off"], FALSE)
	if(.)
		return TOPIC_REFRESH

	return ..()

/client/proc/is_preference_enabled(var/preference)
	var/datum/client_preference/cp = get_client_preference(preference)
	return cp && (cp.key in prefs.preferences_enabled)

/client/proc/set_preference(var/preference, var/set_preference)
	var/datum/client_preference/cp = get_client_preference(preference)
	if(!cp)
		return FALSE
	preference = cp.key

	if(set_preference && !(preference in prefs.preferences_enabled))
		return toggle_preference(cp)
	else if(!set_preference && (preference in prefs.preferences_enabled))
		return toggle_preference(cp)

/client/proc/toggle_preference(var/preference, var/set_preference)
	var/datum/client_preference/cp = get_client_preference(preference)
	if(!cp)
		return FALSE
	preference = cp.key

	var/enabled
	if(preference in prefs.preferences_disabled)
		prefs.preferences_enabled  |= preference
		prefs.preferences_disabled -= preference
		enabled = TRUE
		. = TRUE
	else if(preference in prefs.preferences_enabled)
		prefs.preferences_enabled  -= preference
		prefs.preferences_disabled |= preference
		enabled = FALSE
		. = TRUE
	if(.)
		cp.toggled(mob, enabled)

/mob/proc/is_preference_enabled(var/preference)
	if(!client)
		return FALSE
	return client.is_preference_enabled(preference)

/mob/proc/set_preference(var/preference, var/set_preference)
	if(!client)
		return FALSE
	if(!client.prefs)
		log_debug("Client prefs found to be null for mob [src] and client [ckey], this should be investigated.")
		return FALSE

	return client.set_preference(preference, set_preference)
