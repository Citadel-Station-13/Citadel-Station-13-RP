//Wizard Rig
/obj/item/clothing/head/helmet/space/void/wizard
	name = "gem-encrusted voidsuit helmet"
	desc = "A bizarre gem-encrusted helmet that radiates magical energies."
	icon_state = "rig0-wiz"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "wiz_helm", SLOT_ID_LEFT_HAND = "wiz_helm")
	integrity_flags = INTEGRITY_ACIDPROOF
	armor_type = /datum/armor/wizard
	siemens_coefficient = 0.7
	sprite_sheets_refit = null
	sprite_sheets_obj = null
	wizard_garb = 1

/obj/item/clothing/suit/space/void/wizard
	icon_state = "rig-wiz"
	name = "gem-encrusted voidsuit"
	desc = "A bizarre gem-encrusted suit that radiates magical energies."
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "wiz_voidsuit", SLOT_ID_LEFT_HAND = "wiz_voidsuit")
	encumbrance = ITEM_ENCUMBRANCE_VOIDSUIT_LIGHT
	weight = ITEM_WEIGHT_VOIDSUIT_LIGHT
	w_class = ITEMSIZE_NORMAL
	integrity_flags = INTEGRITY_ACIDPROOF
	armor_type = /datum/armor/wizard
	siemens_coefficient = 0.7
	sprite_sheets_refit = null
	sprite_sheets_obj = null
	wizard_garb = 1

//Chaos Berserker "Costume" Armor
/obj/item/clothing/head/helmet/space/void/wizard/berserk_knight
	name = "berserk knight helmet"
	desc = "A bulky helmet that radiates ravenous magical energies."
	icon_state = "knight_berserker"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndie_helm", SLOT_ID_LEFT_HAND = "syndie_helm")
	armor_type = /datum/armor/wizard/beserk
	light_overlay = "bk_overlay"

/obj/item/clothing/suit/space/void/wizard/berserk_knight
	name = "berserk knight voidsuit"
	desc = "A bloodsoaked suit that emits a nauseating aura of hatred."
	icon_state = "knight_berserker"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndie_voidsuit", SLOT_ID_LEFT_HAND = "syndie_voidsuit")
	armor_type = /datum/armor/wizard/beserk
