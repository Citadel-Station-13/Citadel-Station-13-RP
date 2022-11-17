/datum/category_group/player_setup_category/body
	name = "Body"
	sort_order = 1.25	// floating point gaming
	auto_split = FALSE
	auto_rule = TRUE

/datum/category_item/player_setup_item/body
	is_global = FALSE
	load_order = PREFERENCE_LOAD_ORDER_BODY

/datum/preferences/proc/sanitize_body()
	#warn impl

/datum/preferences/proc/reset_body()
	#warn impl
