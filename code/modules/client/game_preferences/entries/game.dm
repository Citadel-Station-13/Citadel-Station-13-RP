//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/game_preference_entry/dropdown/hud_style
	name = "HUD Style"
	description = "Set the style of your inventory / game HUD"
	key = "hud_style"
	category = GAME_PREFERENCE_CATEGORY_GAME
	subcategory = "HUD Overlay"
	legacy_savefile_key = "UI_style"

/datum/game_preference_entry/dropdown/hud_style/New()
	options = list()
	for(var/key in all_ui_styles)
		options += key
	..()

/datum/game_preference_entry/dropdown/hud_style/on_set(client/user, value, first_init)
	. = ..()
	user.set_ui_style(value)
	user.mob.resync_rendering()

/datum/game_preference_entry/simple_color/hud_color
	name = "HUD Color"
	description = "Manually recolor your inventory / game HUD"
	key = "hud_color"
	category = GAME_PREFERENCE_CATEGORY_GAME
	subcategory = "HUD Overlay"
	default_value = "#ffffff"
	legacy_savefile_key = "UI_style_color"

/datum/game_preference_entry/simple_color/hud_color/on_set(client/user, value, first_init)
	. = ..()
	user.set_ui_color(value)
	user.mob.resync_rendering()

/datum/game_preference_entry/number/hud_alpha
	name = "HUD Alpha"
	description = "Manually set the transparency of your inventory / game HUD"
	key = "hud_alpha"
	category = GAME_PREFERENCE_CATEGORY_GAME
	subcategory = "HUD Overlay"
	default_value = 255
	min_value = 0
	max_value = 255
	round_to_nearest = 1
	legacy_savefile_key = "UI_style_alpha"

/datum/game_preference_entry/number/hud_alpha/on_set(client/user, value, first_init)
	. = ..()
	user.set_ui_alpha(value)
	user.mob.resync_rendering()

/datum/game_preference_entry/dropdown/tooltip_style
	name = "Tooltips Style"
	description = "Set the HUD style of pop up tooltips."
	key = "tooltip_style"
	category = GAME_PREFERENCE_CATEGORY_GAME
	subcategory = "Tooltips"
	legacy_savefile_key = "tooltipstyle"

/datum/game_preference_entry/dropdown/tooltip_style/New()
	options = all_tooltip_styles.Copy()
	..()

/datum/game_preference_entry/simple_color/admin_ooc_color
	name = "OOC Color (Admin)"
	description = "Choose your OOC color. Do not make it too eye-searing. Set to #000001 or reset to default to sync with server color."
	key = "admin_ooc_color"
	category = GAME_PREFERENCE_CATEGORY_GAME
	subcategory = "OOC"
	default_value = "#000001"
	legacy_savefile_key = "ooccolor"

/datum/game_preference_entry/simple_color/admin_ooc_color/is_visible(client/user)
	return check_rights(C = user, show_msg = FALSE) && CONFIG_GET(flag/allow_admin_ooccolor)

/datum/game_preference_entry/toggle/tgui_fancy
	name = "Enable fancy TGUI"
	description = "Makes TGUI windows look better, at the cost of compatibility."
	key = "tgui-fancy"
	category = GAME_PREFERENCE_CATEGORY_GAME
	subcategory = "UI"
	default_value = TRUE

/datum/game_preference_entry/toggle/tgui_fancy/on_set(client/user, value, first_init)
	. = ..()
	INVOKE_ASYNC(user, TYPE_PROC_REF(/client, refresh_tgui))

/datum/game_preference_entry/toggle/tgui_lock
	name = "Lock TGUI to main monitor"
	description = "Locks TGUI windows to your main monitor."
	key = "tgui-monitor-lock"
	category = GAME_PREFERENCE_CATEGORY_GAME
	subcategory = "UI"
	default_value = FALSE

/datum/game_preference_entry/toggle/tgui_lock/on_set(client/user, value, first_init)
	. = ..()
	INVOKE_ASYNC(user, TYPE_PROC_REF(/client, refresh_tgui))

/datum/game_preference_entry/toggle/ui_scale
	name = "Toggle UI scaling"
	description = "If UIs should scale up to match your monitor scaling."
	key = "tgui-scaling"
	category = GAME_PREFERENCE_CATEGORY_GAME
	subcategory = "UI"
	default_value = TRUE

/datum/game_preference_entry/toggle/ui_scale/on_set(client/user, value, first_init)
	. = ..()
	INVOKE_ASYNC(user, TYPE_PROC_REF(/client, refresh_tgui))

/datum/game_preference_entry/toggle/tgui_input
	name = "Toggle TGUI Input"
	description = "Toggle TGUI Input."
	key = "tgui-input"
	category = GAME_PREFERENCE_CATEGORY_GAME
	subcategory = "UI"
	default_value = TRUE
