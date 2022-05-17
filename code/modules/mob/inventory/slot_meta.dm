/// global slot meta cache - all ids must be string!
GLOBAL_LIST_INIT(inventory_slot_meta, init_inventory_slot_meta())

/proc/init_inventory_slot_meta()
	. = list()
	for(var/path in subtypesof(/datum/inventory_slot_meta))
		var/datum/inventory_slot_meta/M = path
		if(initial(M.abstract_type) == path)
			continue
		.["[path]"] = new path

/proc/all_inventory_slot_ids()
	. = list()
	for(var/id in GLOB.inventory_slot_meta)
		. += id

/**
 * returns inventory slot meta for an id
 */
/proc/get_inventory_slot_meta(id)
	return GLOB.inventory_slot_meta["[id]"]

/**
 * inventory slot meta
 * stores all the required information for an inventory slot
 */
/datum/inventory_slot_meta
	/// slot name
	var/name = "unknown"
	/// abstract type
	var/abstract_type = /datum/inventory_slot_meta
	/// is inventory? if not, this won't be rendered as part of the hud's inventory
	var/is_inventory = FALSE
	/// always show on strip/force equip menu, or only show when full
	var/always_show_on_strip_menu = TRUE

/datum/inventory_slot_meta/restraints

	#warn impl
#define slot_back_str		"slot_back"
#define slot_l_hand_str		"slot_l_hand"
#define slot_r_hand_str		"slot_r_hand"
#define slot_w_uniform_str	"slot_w_uniform"
#define slot_head_str		"slot_head"
#define slot_wear_suit_str	"slot_suit"
#define slot_l_ear_str      "slot_l_ear"
#define slot_r_ear_str      "slot_r_ear"
#define slot_belt_str       "slot_belt"
#define slot_shoes_str      "slot_shoes"
#define slot_handcuffed_str "slot_handcuffed"
#define slot_legcuffed_str	"slot_legcuffed"
#define slot_wear_mask_str 	"slot_wear_mask"
#define slot_wear_id_str  	"slot_wear_id"
#define slot_gloves_str  	"slot_gloves"
#define slot_glasses_str  	"slot_glasses"
#define slot_s_store_str	"slot_s_store"
#define slot_tie_str		"slot_tie"
