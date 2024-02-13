//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/game_preference_entry/dropdown/hud_style
	name = ""
	description = ""
	key = ""
	category = "Game"
	subcategory = ""
	legacy_savefile_key = "UI_style"

/datum/game_preference_entry/dropdown/hud_style/New()
	options = all_ui_styles.Copy()
	..()

/datum/game_preference_entry/simple_color/hud_color
	name = ""
	description = ""
	key = ""
	category = "Game"
	subcategory = ""
	default_value = "#ffffff"
	legacy_savefile_key = "UI_style_color"

/datum/game_preference_entry/number/hud_alpha
	name = ""
	description = ""
	key = ""
	category = "Game"
	subcategory = ""
	default_value = 255
	legacy_savefile_key = "UI_style_alpha"

/datum/game_preference_entry/dropdown/tooltip_style
	name = "Tooltips Style"
	description = ""
	key = ""
	category = "Game"
	subcategory = ""
	legacy_savefile_key = "tooltipstyle"

/datum/game_preference_entry/dropdown/tooltip_style/New()
	options = all_tooltip_styles.Copy()
	..()
