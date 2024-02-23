//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/game_preference_entry/dropdown/hud_style
	name = "HUD Style"
	description = "Set the style of your inventory / game HUD"
	key = "hud_style"
	category = "Game"
	subcategory = "HUD Overlay"
	legacy_savefile_key = "UI_style"

/datum/game_preference_entry/dropdown/hud_style/New()
	options = all_ui_styles.Copy()
	..()

/datum/game_preference_entry/simple_color/hud_color
	name = "HUD Color"
	description = "Manually recolor your inventory / game HUD"
	key = "hud_color"
	category = "Game"
	subcategory = "HUD Overlay"
	default_value = "#ffffff"
	legacy_savefile_key = "UI_style_color"

/datum/game_preference_entry/number/hud_alpha
	name = "HUD Alpha"
	description = "Manually set the transparency of your inventory / game HUD"
	key = "hud_alpha"
	category = "Game"
	subcategory = "HUD Overlay"
	default_value = 255
	legacy_savefile_key = "UI_style_alpha"

/datum/game_preference_entry/dropdown/tooltip_style
	name = "Tooltips Style"
	description = "Set the HUD style of pop up tooltips."
	key = "tooltip_style"
	category = "Game"
	subcategory = "Tooltips"
	legacy_savefile_key = "tooltipstyle"

/datum/game_preference_entry/dropdown/tooltip_style/New()
	options = all_tooltip_styles.Copy()
	..()
