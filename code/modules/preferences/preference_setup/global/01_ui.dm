/datum/category_item/player_setup_item/player_global/ui
	name = "UI"
	sort_order = 1

/datum/category_item/player_setup_item/player_global/ui/load_preferences(var/savefile/S)
	S["UI_style"]		>> pref.UI_style
	S["UI_style_color"]	>> pref.UI_style_color
	S["UI_style_alpha"]	>> pref.UI_style_alpha
	S["ooccolor"]		>> pref.ooccolor
	S["tooltipstyle"]	>> pref.tooltipstyle
	S["client_fps"]		>> pref.client_fps

/datum/category_item/player_setup_item/player_global/ui/save_preferences(var/savefile/S)
	S["UI_style"]		<< pref.UI_style
	S["UI_style_color"]	<< pref.UI_style_color
	S["UI_style_alpha"]	<< pref.UI_style_alpha
	S["ooccolor"]		<< pref.ooccolor
	S["tooltipstyle"]	<< pref.tooltipstyle
	S["client_fps"]		<< pref.client_fps

/datum/category_item/player_setup_item/player_global/ui/sanitize_preferences()
	pref.UI_style		= sanitize_inlist(pref.UI_style, all_ui_styles, initial(pref.UI_style))
	pref.UI_style_color	= sanitize_hexcolor(pref.UI_style_color, 6, 1, default = initial(pref.UI_style_color))
	pref.UI_style_alpha	= sanitize_integer(pref.UI_style_alpha, 0, 255, initial(pref.UI_style_alpha))
	pref.ooccolor		= sanitize_hexcolor(pref.ooccolor, 6, 1, initial(pref.ooccolor))
	pref.tooltipstyle	= sanitize_inlist(pref.tooltipstyle, all_tooltip_styles, initial(pref.tooltipstyle))
	pref.client_fps		= sanitize_integer(pref.client_fps, 0, MAX_CLIENT_FPS, initial(pref.client_fps))

/datum/category_item/player_setup_item/player_global/ui/content(datum/preferences/prefs, mob/user, data)
	. = "<b>UI Style:</b> <a href='?src=\ref[src];select_style=1'><b>[pref.UI_style]</b></a><br>"
	. += "<b>Custom UI</b> (recommended for White UI):<br>"
	. += "-Color: <a href='?src=\ref[src];select_color=1'><b>[pref.UI_style_color]</b></a> [color_square(hex = pref.UI_style_color)] <a href='?src=\ref[src];reset=ui'>reset</a><br>"
	. += "-Alpha(transparency): <a href='?src=\ref[src];select_alpha=1'><b>[pref.UI_style_alpha]</b></a>�<a href='?src=\ref[src];reset=alpha'>reset</a><br>"
	. += "<b>Tooltip Style:</b> <a href='?src=\ref[src];select_tooltip_style=1'><b>[pref.tooltipstyle]</b></a><br>"
	. += "<b>Client FPS:</b> <a href='?src=\ref[src];select_client_fps=1'><b>[pref.client_fps]</b></a><br>"
	if(can_select_ooc_color(user))
		. += "<b>OOC Color:</b>"
		if(pref.ooccolor == initial(pref.ooccolor))
			. += "<a href='?src=\ref[src];select_ooc_color=1'><b>Using Default</b></a><br>"
		else
			. += "<a href='?src=\ref[src];select_ooc_color=1'><b>[pref.ooccolor]</b></a> <table style='display:inline;' bgcolor='[pref.ooccolor]'><tr><td>__</td></tr></table>�<a href='?src=\ref[src];reset=ooc'>reset</a><br>"

/datum/category_item/player_setup_item/player_global/ui/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["select_style"])
		var/UI_style_new = tgui_input_list(user, "Choose UI style.", "Character Preference", all_ui_styles, pref.UI_style)
		if(!UI_style_new || !CanUseTopic(user)) return PREFERENCES_NOACTION
		pref.UI_style = UI_style_new
		return PREFERENCES_REFRESH

	else if(href_list["select_color"])
		var/UI_style_color_new = input(user, "Choose UI color, dark colors are not recommended!", "Global Preference", pref.UI_style_color) as color|null
		if(isnull(UI_style_color_new) || !CanUseTopic(user)) return PREFERENCES_NOACTION
		pref.UI_style_color = UI_style_color_new
		return PREFERENCES_REFRESH

	else if(href_list["select_alpha"])
		var/UI_style_alpha_new = input(user, "Select UI alpha (transparency) level, between 50 and 255.", "Global Preference", pref.UI_style_alpha) as num|null
		if(isnull(UI_style_alpha_new) || (UI_style_alpha_new < 50 || UI_style_alpha_new > 255) || !CanUseTopic(user)) return PREFERENCES_NOACTION
		pref.UI_style_alpha = UI_style_alpha_new
		return PREFERENCES_REFRESH

	else if(href_list["select_ooc_color"])
		var/new_ooccolor = input(user, "Choose OOC color:", "Global Preference") as color|null
		if(new_ooccolor && can_select_ooc_color(user) && CanUseTopic(user))
			pref.ooccolor = new_ooccolor
			return PREFERENCES_REFRESH

	else if(href_list["select_tooltip_style"])
		var/tooltip_style_new = tgui_input_list(user, "Choose tooltip style.", "Global Preference", all_tooltip_styles, pref.tooltipstyle)
		if(!tooltip_style_new || !CanUseTopic(user)) return PREFERENCES_NOACTION
		pref.tooltipstyle = tooltip_style_new
		return PREFERENCES_REFRESH

	else if(href_list["select_client_fps"])
		var/fps_new = input(user, "Input Client FPS (1-200, 0 uses server FPS)", "Global Preference", pref.client_fps) as null|num
		if(isnull(fps_new) || !CanUseTopic(user)) return PREFERENCES_NOACTION
		if(fps_new < 0 || fps_new > MAX_CLIENT_FPS) return PREFERENCES_NOACTION
		pref.client_fps = fps_new
		if(pref.client)
			pref.client.fps = fps_new
		return PREFERENCES_REFRESH

	else if(href_list["reset"])
		switch(href_list["reset"])
			if("ui")
				pref.UI_style_color = initial(pref.UI_style_color)
			if("alpha")
				pref.UI_style_alpha = initial(pref.UI_style_alpha)
			if("ooc")
				pref.ooccolor = initial(pref.ooccolor)
		return PREFERENCES_REFRESH

	return ..()

/datum/category_item/player_setup_item/player_global/ui/proc/can_select_ooc_color(var/mob/user)
	return CONFIG_GET(flag/allow_admin_ooccolor) && check_rights(R_ADMIN, 0, user)
