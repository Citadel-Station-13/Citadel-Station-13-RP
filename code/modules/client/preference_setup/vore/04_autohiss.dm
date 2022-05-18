#define AUTOHISS_OFF 0
#define AUTOHISS_BASIC 1
#define AUTOHISS_FULL 2
///The number of autohiss types that we have. Used for sanitization
#define AUTOHISS_NUM 3
///Equivalent to being off
#define AUTOHISS_TYPE_NONE  0
#define AUTOHISS_TYPE_UNATHI 1
#define AUTOHISS_TYPE_TAJARAN 2
///The number of autohiss types that we have. Used for sanitization
#define AUTOHISS_TYPE_NUM 3
// Define a place to save in character setup
/datum/preferences
	var/autohiss = AUTOHISS_OFF
	var/autohiss_type = AUTOHISS_TYPE_NONE

// Definition of the stuff for autohiss
/datum/category_item/player_setup_item/vore/autohiss
	name = "Autohiss"
	sort_order = 4

/datum/category_item/player_setup_item/vore/autohiss/load_character(var/savefile/S)
	S["autohiss"] >> pref.autohiss
	S["autohiss_type"] >> pref.autohiss_type


/datum/category_item/player_setup_item/vore/autohiss/save_character(var/savefile/S)
	S["autohiss"] << pref.autohiss
	S["autohiss_type"] << pref.autohiss_type

/datum/category_item/player_setup_item/vore/autohiss/sanitize_character()
	pref.autohiss = sanitize_integer(pref.autohiss, AUTOHISS_OFF, AUTOHISS_NUM, AUTOHISS_OFF)
	pref.autohiss_type = sanitize_integer(pref.autohiss_type, AUTOHISS_TYPE_NONE, AUTOHISS_TYPE_NUM, AUTOHISS_TYPE_NONE)

/datum/category_item/player_setup_item/vore/autohiss/copy_to_mob(var/mob/living/carbon/human/character)
	character.autohiss_mode = pref.autohiss
	character.autohiss_type = pref.autohiss_type

/datum/category_item/player_setup_item/vore/autohiss/content(var/mob/user)
	. += "<br>"
	. += "<b>Autohiss Type:</b> "

	//These switches looks scary but we're essentially determining which button to highlight based on the current state of the prefs.
	//Thank you UI code.

	//If we get more species we'll probably have to convert this to a dropdown.
	switch(pref.autohiss_type)
		if(AUTOHISS_TYPE_NONE,null)
			. += "<span class='linkOn'><b>None</b></span> <a href='?src=\ref[src];toggle_type_unathi=1'>Unathi</a> <a href='?src=\ref[src];toggle_type_tajaran=1'>Tajaran</a>"
		if(AUTOHISS_TYPE_UNATHI)
			. += "<a href='?src=\ref[src];toggle_type_none=1'>None</a> <span class='linkOn'><b>Unathi</b></span> <a href='?src=\ref[src];toggle_type_tajaran=1'>Tajaran</a>"
		if(AUTOHISS_TYPE_TAJARAN)
			. += "<a href='?src=\ref[src];toggle_type_none=1'>None</a> <a href='?src=\ref[src];toggle_type_unathi=1'>Unathi</a> <span class='linkOn'><b>Tajaran</b></span>"
		else
			CRASH("Invalid autohiss type preference! '[pref.autohiss]'")

	. += "<br>"
	. += "<b>Autohiss Mode:</b> "

	switch(pref.autohiss)
		if(AUTOHISS_OFF,null)
			. += "<span class='linkOn'><b>Off</b></span> <a href='?src=\ref[src];toggle_basic=1'>Basic</a> <a href='?src=\ref[src];toggle_full=1'>Full</a>"
		if(AUTOHISS_BASIC)
			. += "<a href='?src=\ref[src];toggle_off=1'>Off</a> <span class='linkOn'><b>Basic</b></span> <a href='?src=\ref[src];toggle_full=1'>Full</a>"
		if(AUTOHISS_FULL)
			. += "<a href='?src=\ref[src];toggle_off=1'>Off</a> <a href='?src=\ref[src];toggle_basic=1'>Basic</a> <span class='linkOn'><b>Full</b></span>"
		else
			CRASH("Invalid autohiss preference! '[pref.autohiss]'")

/datum/category_item/player_setup_item/vore/autohiss/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(href_list["toggle_off"])
		pref.autohiss = AUTOHISS_OFF
		return TOPIC_REFRESH
	if(href_list["toggle_basic"])
		pref.autohiss = AUTOHISS_BASIC
		return TOPIC_REFRESH
	if(href_list["toggle_full"])
		pref.autohiss = AUTOHISS_FULL
		return TOPIC_REFRESH

	if(href_list["toggle_type_none"])
		pref.autohiss_type = AUTOHISS_TYPE_NONE
		return TOPIC_REFRESH
	if(href_list["toggle_type_unathi"])
		pref.autohiss_type = AUTOHISS_TYPE_UNATHI
		return TOPIC_REFRESH
	if(href_list["toggle_type_tajaran"])
		pref.autohiss_type = AUTOHISS_TYPE_TAJARAN
		return TOPIC_REFRESH

	return ..();
