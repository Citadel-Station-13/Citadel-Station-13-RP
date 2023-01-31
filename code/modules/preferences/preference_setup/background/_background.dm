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

/datum/preferences/proc/get_background_lore_datums()
	. = list()
	var/datum/lore/character_background/bglore
	bglore = SScharacters.resolve_citizenship(get_preference(/datum/category_item/player_setup_item/background/citizenship))
	if(bglore)
		. += bglore
	bglore = SScharacters.resolve_faction(get_preference(/datum/category_item/player_setup_item/background/faction))
	if(bglore)
		. += bglore
	bglore = SScharacters.resolve_origin(get_preference(/datum/category_item/player_setup_item/background/origin))
	if(bglore)
		. += bglore
	bglore = SScharacters.resolve_religion(get_preference(/datum/category_item/player_setup_item/background/religion))
	if(bglore)
		. += bglore

/datum/preferences/proc/tally_background_economic_factor()
	. = 1
	for(var/datum/lore/character_background/bglore as anything in get_background_lore_datums())
		. *= bglore.economy_payscale
	// todo: character species when *necessary*
	var/datum/species/S = real_species_datum()
	. *= S.economy_payscale
	. *= economic_class_payscale_lookup[economic_status] || 1
