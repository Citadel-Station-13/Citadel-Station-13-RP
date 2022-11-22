//these need item states -S2-
/obj/item/clothing/under/syndicate //Merc Tactleneck
	name = "tactical turtleneck"
	desc = "It's some non-descript, slightly suspicious looking, civilian clothing."
	icon_state = "syndicate"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "black", SLOT_ID_LEFT_HAND = "black")
	has_sensors = UNIFORM_HAS_NO_SENSORS
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/syndicate/skirt_pleated
	name = "tactical pleated skirt"
	icon_state = "syndicate_skirt"

/obj/item/clothing/under/syndicate/combat //ERT tactleneck
	name = "combat turtleneck"
	desc = "It's some non-descript, slightly suspicious looking, civilian clothing."
	icon_state = "combat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "black", SLOT_ID_LEFT_HAND = "black")
	has_sensors = UNIFORM_HAS_SUIT_SENSORS
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/syndicate/tacticool
	name = "\improper Tacticool turtleneck"
	desc = "Just looking at it makes you want to buy an SKS, go into the woods, and -operate-."
	icon_state = "tactifool"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "black", SLOT_ID_LEFT_HAND = "black")
	siemens_coefficient = 1

/obj/item/clothing/under/syndicate/tacticool/skirt_pleated
	name = "tacticool pleated skirt"
	icon_state = "tactifool_skirt"

/obj/item/clothing/under/syndicate/combat
	name = "syndicate combat suit"
	desc = "This streamlined tactical suit is a cut above the tactical turtleneck. It has four more pockets."
	icon_state = "syndicate_combat"
