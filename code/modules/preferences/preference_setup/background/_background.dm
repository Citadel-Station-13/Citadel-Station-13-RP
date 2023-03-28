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
	sanitize_preference(/datum/category_item/player_setup_item/background/culture)
	// do language last
	sanitize_preference(/datum/category_item/player_setup_item/background/language)
	// lastly, do general job titles after
	sanitize_preference(/datum/category_item/player_setup_item/occupation/alt_titles)

/datum/preferences/proc/all_background_datums()
	return list(
		lore_faction_datum(),
		lore_citizenship_datum(),
		lore_origin_datum(),
		lore_religion_datum(),
		lore_culture_datum(),
	)

/datum/preferences/proc/all_background_ids()
	. = list()
	for(var/datum/lore/character_background/bg as anything in all_background_datums())
		. += bg.id

/datum/preferences/proc/tally_background_economic_factor()
	. = 1
	for(var/datum/lore/character_background/bglore as anything in all_background_datums())
		. *= bglore.economy_payscale
	// todo: character species when *necessary*
	var/datum/species/S = real_species_datum()
	. *= S.economy_payscale
	. *= GLOB.economic_class_payscale_lookup[economic_status] || 1
