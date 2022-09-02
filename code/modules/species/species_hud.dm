/datum/hud_data
	var/icon              // If set, overrides ui_style.
	var/has_a_intent = 1  // Set to draw intent box.
	var/has_m_intent = 1  // Set to draw move intent box.
	var/has_warnings = 1  // Set to draw environment warnings.
	var/has_pressure = 1  // Draw the pressure indicator.
	var/has_nutrition = 1 // Draw the nutrition indicator.
	var/has_bodytemp = 1  // Draw the bodytemp indicator.
	var/has_hands = 1     // Set to draw hands.
	var/has_drop = 1      // Set to draw drop button.
	var/has_throw = 1     // Set to draw throw button.
	var/has_resist = 1    // Set to draw resist button.
	var/has_internals = 1 // Set to draw the internals toggle button.
	var/list/equip_slots = list() // Checked by mob_can_equip().

	// Contains information on the position and tag for all inventory slots
	// to be drawn for the mob. This is fairly delicate, try to avoid messing with it
	// unless you know exactly what it does.
	// keyed by slot ID.
	var/list/gear = list(
		SLOT_ID_UNIFORM =   list("loc" = ui_iclothing, "name" = "Uniform",      "slot" = SLOT_ID_UNIFORM, "state" = "center", "toggle" = 1),
		SLOT_ID_SUIT =   list("loc" = ui_oclothing, "name" = "Suit",         "slot" = SLOT_ID_SUIT, "state" = "suit",   "toggle" = 1),
		SLOT_ID_MASK =         list("loc" = ui_mask,      "name" = "Mask",         "slot" = SLOT_ID_MASK, "state" = "mask",   "toggle" = 1),
		SLOT_ID_GLOVES =       list("loc" = ui_gloves,    "name" = "Gloves",       "slot" = SLOT_ID_GLOVES,    "state" = "gloves", "toggle" = 1),
		SLOT_ID_GLASSES =         list("loc" = ui_glasses,   "name" = "Glasses",      "slot" = SLOT_ID_GLASSES,   "state" = "glasses","toggle" = 1),
		SLOT_ID_LEFT_EAR =        list("loc" = ui_l_ear,     "name" = "Left Ear",     "slot" = SLOT_ID_LEFT_EAR,     "state" = "ears",   "toggle" = 1),
		SLOT_ID_RIGHT_EAR =        list("loc" = ui_r_ear,     "name" = "Right Ear",    "slot" = SLOT_ID_RIGHT_EAR,     "state" = "ears",   "toggle" = 1),
		SLOT_ID_HEAD =         list("loc" = ui_head,      "name" = "Hat",          "slot" = SLOT_ID_HEAD,      "state" = "hair",   "toggle" = 1),
		SLOT_ID_SHOES =        list("loc" = ui_shoes,     "name" = "Shoes",        "slot" = SLOT_ID_SHOES,     "state" = "shoes",  "toggle" = 1),
		SLOT_ID_SUIT_STORAGE = list("loc" = ui_sstore1,   "name" = "Suit Storage", "slot" = SLOT_ID_SUIT_STORAGE,   "state" = "suitstore"),
		SLOT_ID_BACK =         list("loc" = ui_back,      "name" = "Back",         "slot" = SLOT_ID_BACK,      "state" = "back"),
		SLOT_ID_WORN_ID =           list("loc" = ui_id,        "name" = "ID",           "slot" = SLOT_ID_WORN_ID,   "state" = "id"),
		SLOT_ID_LEFT_POCKET =     list("loc" = ui_storage1,  "name" = "Left Pocket",  "slot" = SLOT_ID_LEFT_POCKET,   "state" = "pocket"),
		SLOT_ID_RIGHT_POCKET =     list("loc" = ui_storage2,  "name" = "Right Pocket", "slot" = SLOT_ID_RIGHT_POCKET,   "state" = "pocket"),
		SLOT_ID_BELT =         list("loc" = ui_belt,      "name" = "Belt",         "slot" = SLOT_ID_BELT,      "state" = "belt")
		)

/datum/hud_data/New()
	..()
	for(var/slot in gear)
		equip_slots |= gear[slot]["slot"]

	if(has_hands)
		equip_slots |= SLOT_ID_HANDCUFFED

	equip_slots |= SLOT_ID_LEGCUFFED

/datum/hud_data/diona
	has_internals = 0
	gear = list(
		SLOT_ID_UNIFORM =   list("loc" = ui_iclothing, "name" = "Uniform",      "slot" = SLOT_ID_UNIFORM, "state" = "center", "toggle" = 1),
		SLOT_ID_SUIT =   list("loc" = ui_shoes, "name" = "Suit",         "slot" = SLOT_ID_SUIT, "state" = "suit",   "toggle" = 1),
		SLOT_ID_LEFT_EAR =        list("loc" = ui_gloves,     "name" = "Left Ear",     "slot" = SLOT_ID_LEFT_EAR,     "state" = "ears",   "toggle" = 1),
		SLOT_ID_HEAD =         list("loc" = ui_oclothing,      "name" = "Hat",          "slot" = SLOT_ID_HEAD,      "state" = "hair",   "toggle" = 1),
		SLOT_ID_SUIT_STORAGE = list("loc" = ui_sstore1,   "name" = "Suit Storage", "slot" = SLOT_ID_SUIT_STORAGE,   "state" = "suitstore"),
		SLOT_ID_BACK =         list("loc" = ui_back,      "name" = "Back",         "slot" = SLOT_ID_BACK,      "state" = "back"),
		SLOT_ID_WORN_ID =           list("loc" = ui_id,        "name" = "ID",           "slot" = SLOT_ID_WORN_ID,   "state" = "id"),
		SLOT_ID_LEFT_POCKET =     list("loc" = ui_storage1,  "name" = "Left Pocket",  "slot" = SLOT_ID_LEFT_POCKET,   "state" = "pocket"),
		SLOT_ID_RIGHT_POCKET =     list("loc" = ui_storage2,  "name" = "Right Pocket", "slot" = SLOT_ID_RIGHT_POCKET,   "state" = "pocket"),
		)

/datum/hud_data/monkey
	gear = list(
		SLOT_ID_MASK =         list("loc" = ui_shoes,     "name" = "Mask", "slot" = SLOT_ID_MASK, "state" = "mask",  "toggle" = 1),
		SLOT_ID_BACK =         list("loc" = ui_sstore1,   "name" = "Back", "slot" = SLOT_ID_BACK,      "state" = "back"),
		)
