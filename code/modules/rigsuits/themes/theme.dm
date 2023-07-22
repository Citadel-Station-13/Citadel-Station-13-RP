//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/rig_theme
	/// in code theme name
	var/name = "unknown rig"
	/// visible description
	var/desc = "A powered exochassis of unknown design."
	/// visible fluff description
	var/fluff_desc
	/// display name - overrides name on UIs
	var/display_name
	/// visible name - overrides display name, which overrides name. renders as [visible_name][piece.visible_name]
	var/visible_name
	/// base icon
	var/icon
	/// base icon state
	/// combined as "[base_state][piece_state_append][sealed_state_append]" to get final state
	var/base_state

/datum/rig_theme_piece
	abstract_type = /datum/rig_theme_piece
	/// path
	var/path
	/// display name - overrides name on UIs
	var/display_name
	/// visible name - appended directly to host theme's visible name
	var/visible_name
	/// piece component flags
	var/rig_piece_flags = NONE
	/// multiplier for armor to apply - does not affect tier.
	/// > 1 values don't scale the same as < 1 for balancing reasons,
	/// and will intsead use 2 = 50% *more armor* as opposed to 2x raw armor
	/// e.g. 1 = 0.5, 2 = 0.75, 3 = 0.875, etc.
	var/armor_multiplier = 1
	/// this piece's state append - this is separate from base_state so overriding is easier
	var/piece_state_append
	/// sealed state append
	var/sealed_state_append = "-sealed"

/**
 * returns rig_piece component
 */
/datum/rig_theme_piece/proc/instantiate()
	ASSERT(ispath(path, /obj/item))
	var/obj/item/created_item = new path
	var/datum/component/rig_piece/created_piece = created_item.AddComponent(/datum/component/rig_piece)

/datum/rig_theme_piece/helmet
	display_name = " helmet"
	visible_name = " helmet"
	path = /obj/item/clothing/head/rig
	rig_piece_flags = RIG_PIECE_APPLY_ARMOR | RIG_PIECE_APPLY_ENVIRONMENTALS
	piece_state_append = "-helmet"

/datum/rig_theme_piece/suit
	display_name = " chassis"
	visible_name = " chassis"
	path = /obj/item/clothing/head/rig
	rig_piece_flags = RIG_PIECE_APPLY_ARMOR | RIG_PIECE_APPLY_ENVIRONMENTALS
	piece_state_append = "-suit"

/datum/rig_theme_piece/gloves
	display_name = " gauntlets"
	visible_name = " gauntlets"
	path = /obj/item/clothing/gloves/rig
	rig_piece_flags = RIG_PIECE_APPLY_ARMOR | RIG_PIECE_APPLY_ENVIRONMENTALS
	piece_state_append = "-gloves"

/datum/rig_theme_piece/shoes
	display_name = " boots"
	visible_name = " boots"
	path = /obj/item/clothing/shoes/rig
	rig_piece_flags = RIG_PIECE_APPLY_ARMOR | RIG_PIECE_APPLY_ENVIRONMENTALS
	piece_state_append = "-shoes"
