/*
*	"Former" Syndicate workwear
*/

/obj/item/clothing/under/syndicate //Merc Tactleneck
	name = "tactical turtleneck"
	desc = "It's some non-descript, slightly suspicious looking, civilian clothing."
	icon = 'icons/clothing/uniform/workwear/syndicate/syndicate.dmi'
	icon_state = "syndicate"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "black", SLOT_ID_LEFT_HAND = "black")
	has_sensors = UNIFORM_HAS_NO_SENSORS
	armor_type = /datum/armor/agent/jumpsuit
	siemens_coefficient = 0.9

/obj/item/clothing/under/syndicate/skirt_pleated
	name = "tactical pleated skirt"
	icon = 'icons/clothing/uniform/workwear/syndicate/syndicate_skirt.dmi'
	icon_state = "syndicate_skirt"

/obj/item/clothing/under/syndicate/combat //ERT tactleneck
	name = "combat turtleneck"
	desc = "It's some non-descript, slightly suspicious looking, civilian clothing."
	icon = 'icons/clothing/uniform/workwear/syndicate/combat.dmi'
	icon_state = "combat"
	has_sensors = UNIFORM_HAS_SUIT_SENSORS
	siemens_coefficient = 0.9

/obj/item/clothing/under/syndicate/tacticool
	name = "\improper Tacticool turtleneck"
	desc = "Just looking at it makes you want to buy an SKS, go into the woods, and -operate-."
	icon = 'icons/clothing/uniform/workwear/syndicate/tactifool.dmi'
	icon_state = "tactifool"
	siemens_coefficient = 1

/obj/item/clothing/under/syndicate/tacticool/skirt_pleated
	name = "tacticool pleated skirt"
	icon = 'icons/clothing/uniform/workwear/syndicate/tactifool_skirt.dmi'
	icon_state = "tactifool_skirt"

/obj/item/clothing/under/syndicate/combat/suit
	name = "syndicate combat suit"
	desc = "This streamlined tactical suit is a cut above the tactical turtleneck. It has four more pockets."
	icon = 'icons/clothing/uniform/workwear/syndicate/syndicate_combat.dmi'
	icon_state = "syndicate_combat"
