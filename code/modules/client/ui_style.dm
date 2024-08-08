
// todo: lol we should datumize these probably?
// todo: refactor all of this

/var/global/list/all_ui_styles = list(
	UI_STYLE_MIDNIGHT     = 'icons/mob/screen/midnight.dmi',
	UI_STYLE_ORANGE       = 'icons/mob/screen/orange.dmi',
	UI_STYLE_OLD          = 'icons/mob/screen/old.dmi',
	UI_STYLE_WHITE        = 'icons/mob/screen/white.dmi',
	UI_STYLE_MINIMALIST   = 'icons/mob/screen/minimalist.dmi',
	UI_STYLE_HOLOGRAM     = 'icons/mob/screen/holo.dmi',
	)

/var/all_ui_style_ids = list(
	UI_STYLE_MIDNIGHT     = "midnight",
	UI_STYLE_ORANGE       = "orange",
	UI_STYLE_OLD          = "old",
	UI_STYLE_WHITE        = "white",
	UI_STYLE_MINIMALIST   = "minimalist",
	UI_STYLE_HOLOGRAM     = "holo",
	)

/var/global/list/all_ui_styles_robot = list(
	UI_STYLE_MIDNIGHT     = 'icons/mob/screen1_robot.dmi',
	UI_STYLE_ORANGE       = 'icons/mob/screen1_robot.dmi',
	UI_STYLE_OLD          = 'icons/mob/screen1_robot.dmi',
	UI_STYLE_WHITE        = 'icons/mob/screen1_robot.dmi',
	UI_STYLE_MINIMALIST   = 'icons/mob/screen1_robot_minimalist.dmi',
	UI_STYLE_HOLOGRAM     = 'icons/mob/screen1_robot_minimalist.dmi',
	)

var/global/list/all_tooltip_styles = list(
	"Midnight",		//Default for everyone is the first one,
	"Plasmafire",
	"Retro",
	"Slimecore",
	"Operative",
	"Clockwork"
	)

/proc/ui_style2icon(ui_style)
	if(ui_style in all_ui_styles)
		return all_ui_styles[ui_style]
	return all_ui_styles[UI_STYLE_WHITE]

// todo: refactor
/client/proc/set_ui_style(style)
	if(!usr?.hud_used.adding)
		return
	var/UI_style_new = style
	//update UI
	var/list/icons = usr.hud_used.adding + usr.hud_used.other + usr.hud_used.hotkeybuttons
	icons.Add(usr.zone_sel)
	icons.Add(usr.gun_setting_icon)
	icons.Add(usr.item_use_icon)
	icons.Add(usr.gun_move_icon)
	icons.Add(usr.radio_use_icon)

	var/icon/ic = all_ui_styles[UI_style_new]
	if(isrobot(usr))
		ic = all_ui_styles_robot[UI_style_new]

	for(var/atom/movable/screen/I in icons)
		if(I.name in list(INTENT_HELP, INTENT_HARM, INTENT_DISARM, INTENT_GRAB)) continue
		I.icon = ic

// todo: refactor
/client/proc/set_ui_alpha(alpha)
	if(!usr?.hud_used.adding)
		return
	//update UI
	var/list/icons = usr.hud_used.adding + usr.hud_used.other + usr.hud_used.hotkeybuttons
	icons.Add(usr.zone_sel)
	icons.Add(usr.gun_setting_icon)
	icons.Add(usr.item_use_icon)
	icons.Add(usr.gun_move_icon)
	icons.Add(usr.radio_use_icon)

	for(var/atom/movable/screen/I in icons)
		if(I.name in list(INTENT_HELP, INTENT_HARM, INTENT_DISARM, INTENT_GRAB)) continue
		I.alpha = alpha

// todo: refactor
/client/proc/set_ui_color(color)
	if(!usr?.hud_used.adding)
		return
	//update UI
	var/list/icons = usr.hud_used.adding + usr.hud_used.other + usr.hud_used.hotkeybuttons
	icons.Add(usr.zone_sel)
	icons.Add(usr.gun_setting_icon)
	icons.Add(usr.item_use_icon)
	icons.Add(usr.gun_move_icon)
	icons.Add(usr.radio_use_icon)

	for(var/atom/movable/screen/I in icons)
		if(I.name in list(INTENT_HELP, INTENT_HARM, INTENT_DISARM, INTENT_GRAB)) continue
		I.color = color
