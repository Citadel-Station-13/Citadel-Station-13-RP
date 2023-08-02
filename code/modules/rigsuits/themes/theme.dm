//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/rig_theme
	/// in code theme name
	var/name = "unknown rig"
	/// visible description
	var/desc = "A powered exochassis of unknown design."
	/// visible fluff description
	var/fluff_desc
	/// display name - overrides name on internal UIs.
	var/display_name
	/// visible name - overrides display name, which overrides name. renders as [visible_name][piece.visible_name]
	var/visible_name
	/// what this is called; usually just 'RIG'
	var/suit_name = "RIG"
	/// pieces - paths. init'd on, well, new/init.
	var/list/pieces = list(
		/datum/rig_piece/helmet,
		/datum/rig_piece/chestplate,
		/datum/rig_piece/gloves,
		/datum/rig_piece/boots,
	)
	/// base icon
	var/base_icon
	/// base icon state
	/// combined as "[base_state][piece_state_append][sealed_state_append]" to get final state
	var/base_state
	/// control module state
	var/control_state_append = "-control"
	/// control module sealed append
	var/control_sealed_append = "-sealed"

	#warn coloration system start

/datum/rig_theme/New()
	#warn init pieces

/datum/rig_piece
	abstract_type = /datum/rig_piece
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
	/// worn rendering flags
	var/worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	/// bodytypes implemented
	var/worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	/// bodytypes squashed
	var/worn_bodytypes_fallback = BODYTYPES_ALL
	/// slot this goes in - SLOT_ID_HANDS for an inhand item. specific-hand binding not supported yet.
	var/equip_slot
	/// inv hide flags while unsealed
	var/inv_hide_flags_inactive = NONE
	/// inv hide flags while sealed
	var/inv_hide_flags_active = NONE

/datum/rig_piece/New()
	CONSTRUCT_BODYTYPES(worn_bodytypes)
	CONSTRUCT_BODYTYPES(worn_bodytypes_fallback)

/**
 * returns rig_piece component
 */
/datum/rig_piece/proc/instantiate()
	ASSERT(ispath(path, /obj/item))
	var/obj/item/created_item = new path
	var/datum/component/rig_piece/created_piece = created_item.AddComponent(/datum/component/rig_piece)

/datum/rig_piece/helmet
	display_name = "helmet"
	visible_name = "Helmet"
	path = /obj/item/clothing/head/rig
	rig_piece_flags = RIG_PIECE_APPLY_ARMOR | RIG_PIECE_APPLY_ENVIRONMENTALS
	piece_state_append = "-helmet"

/datum/rig_piece/chestplate
	display_name = "chestplate"
	visible_name = "Chestplate"
	path = /obj/item/clothing/suit/rig
	rig_piece_flags = RIG_PIECE_APPLY_ARMOR | RIG_PIECE_APPLY_ENVIRONMENTALS
	piece_state_append = "-chestplate"

/datum/rig_piece/gloves
	display_name = "gauntlets"
	visible_name = "Gauntlets"
	path = /obj/item/clothing/gloves/rig
	rig_piece_flags = RIG_PIECE_APPLY_ARMOR | RIG_PIECE_APPLY_ENVIRONMENTALS
	piece_state_append = "-gloves"

/datum/rig_piece/boots
	display_name = "boots"
	visible_name = "Boots"
	path = /obj/item/clothing/shoes/rig
	rig_piece_flags = RIG_PIECE_APPLY_ARMOR | RIG_PIECE_APPLY_ENVIRONMENTALS
	piece_state_append = "-boots"
