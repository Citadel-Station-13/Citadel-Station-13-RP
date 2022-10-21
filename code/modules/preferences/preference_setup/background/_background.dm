/datum/category_group/player_setup_category/background
	name = "Background"
	sort_order = 1.5		// floating point gaming
	category_item_type = /datum/category_item/player_setup_item/background
	auto_split = FALSE
	auto_rule = TRUE

/datum/category_item/player_setup_item/background
	is_global = FALSE
	load_order = PREFERENCE_LOAD_ORDER_LORE

/datum/preferences/proc/sanitize_background_lore()
	sanitize_preference(/datum/category_item/player_setup_item/background/citizenship)
	sanitize_preference(/datum/category_item/player_setup_item/background/faction)
	sanitize_preference(/datum/category_item/player_setup_item/background/origin)
	sanitize_preference(/datum/category_item/player_setup_item/background/religion)
	// do language last
	sanitize_preference(/datum/category_item/player_setup_item/background/language)
