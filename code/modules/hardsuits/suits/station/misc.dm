/obj/item/hardsuit/internalaffairs
	name = "augmented tie"
	suit_type = "augmented suit"
	desc = "The last suit you'll ever wear."
	icon_state = "internalaffairs_rig"
	armor_type = /datum/armor/none
	siemens_coefficient = 0.9
	encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_LIGHT
	offline_encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_LIGHT * 2
	offline_vision_restriction = 0

	glove_type = null
	helm_type = null
	boot_type = null

/obj/item/hardsuit/internalaffairs/equipped
	initial_modules = list(
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/device/flash,
		/obj/item/hardsuit_module/device/paperdispenser,
		/obj/item/hardsuit_module/device/pen,
		/obj/item/hardsuit_module/device/stamp
		)

	glove_type = null
	helm_type = null
	boot_type = null
