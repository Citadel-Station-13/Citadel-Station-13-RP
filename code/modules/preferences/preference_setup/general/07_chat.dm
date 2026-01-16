/datum/category_item/player_setup_item/general/chat
	name = "Chat"
	sort_order = 7

/datum/category_item/player_setup_item/general/chat/load_character(savefile/S)
	S["floating_chat_color"] >> pref.floating_chat_color

/datum/category_item/player_setup_item/general/chat/save_character(savefile/S)
	S["floating_chat_color"] << pref.floating_chat_color

/datum/category_item/player_setup_item/general/chat/sanitize_character()
	pref.floating_chat_color = sanitize_hexcolor(pref.floating_chat_color, 6, TRUE, default = null)

/datum/category_item/player_setup_item/general/chat/copy_to_mob(datum/preferences/prefs, mob/M, data, flags)
	if(ismovable(M))
		var/atom/movable/movable_mob = M
		movable_mob.floating_chat_color = pref.floating_chat_color
	return TRUE

/datum/category_item/player_setup_item/general/chat/content(datum/preferences/prefs, mob/user, data)
	. = list()
	var/display = pref.floating_chat_color ? color_square(hex = pref.floating_chat_color) : "Random"
	. += "<b>Overhead Chat Color:</b> <a href='?src=\\ref[src];floating_chat_color=1'>[display]</a>"
	if(pref.floating_chat_color)
		. += " <a href='?src=\\ref[src];floating_chat_color_reset=1'>(Reset)</a>"
	. = jointext(., null)

/datum/category_item/player_setup_item/general/chat/OnTopic(href, list/href_list, mob/user)
	if(href_list["floating_chat_color"])
		var/default_color = pref.floating_chat_color || "#ffffff"
		var/new_color = input(user, "Choose your character's overhead chat color:", "Character Preference", default_color) as color|null
		if(!CanUseTopic(user))
			return PREFERENCES_NOACTION
		pref.floating_chat_color = isnull(new_color) ? null : sanitize_hexcolor(new_color, 6, TRUE, default = null)
		return PREFERENCES_REFRESH

	if(href_list["floating_chat_color_reset"])
		if(!CanUseTopic(user))
			return PREFERENCES_NOACTION
		pref.floating_chat_color = null
		return PREFERENCES_REFRESH

	return ..()
