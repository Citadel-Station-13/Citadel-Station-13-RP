//Nanotrasen Security Uniforms

/obj/item/clothing/under/nanotrasen
	name = "Nanotrasen uniform"
	desc = "A comfortable turtleneck and black trousers sporting nanotrasen symbols."
	icon_state = "navyutility"
	snowflake_worn_state = "navyutility"
	armor_type = /datum/armor/none
	siemens_coefficient = 0.9

/obj/item/clothing/under/nanotrasen/security
	name = "Nanotrasen security uniform"
	desc = "The security uniform of Nanotrasen's security. It looks sturdy and well padded"
	icon_state = "navyutility_sec"
	snowflake_worn_state = "navyutility_sec"
	armor_type = /datum/armor/station/padded

/obj/item/clothing/under/nanotrasen/security/warden
	name = "Nanotrasen warden uniform"
	desc = "The uniform of the Nanotrasen's prison wardens. It looks sturdy and well padded. This one has gold cuffs."
	icon_state = "navyutility_com"
	snowflake_worn_state = "navyutility_com"

/obj/item/clothing/under/nanotrasen/security/commander
	name = "Nanotrasen security command uniform"
	desc = "The uniform of the Nanotrasen's security commanding officers. It looks sturdy and well padded. This one has gold trim and red blazes."
	icon_state = "blackutility_seccom"
	snowflake_worn_state = "blackutility_seccom"

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
