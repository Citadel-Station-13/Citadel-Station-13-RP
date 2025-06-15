//Head Gear

/obj/item/clothing/head/soft/nanotrasen
	name = "Nanotrasen security cap"
	desc = "It's a NT blue ballcap with a Nanotrasen crest. It looks surprisingly sturdy."
	icon_state = "fleetsoft"
	item_state_slots = list(
		SLOT_ID_LEFT_HAND = "darkbluesoft",
		SLOT_ID_RIGHT_HAND = "darkbluesoft",
		)
	armor_type = /datum/armor/station/padded

/obj/item/clothing/head/beret/nanotrasen
	name = "Nanotrasen security beret"
	desc = "A NT blue beret belonging to the Nanotrasen security forces. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy"

//Armor

/obj/item/clothing/suit/storage/vest/nanotrasen
	name = "security armor vest"
	desc = "A Sturdy kevlar plate carrier with webbing attached."
	icon_state = "webvest"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	armor_type = /datum/armor/station/tactical
	weight = ITEM_WEIGHT_ARMOR_LIGHT
