/datum/outfit/standard_space_gear
	name = "Standard space gear"
	shoes = /obj/item/clothing/shoes/black
	head = /obj/item/clothing/head/helmet/space
	suit = /obj/item/clothing/suit/space
	uniform = /obj/item/clothing/under/color/grey
	back = /obj/item/tank/jetpack/oxygen
	mask = /obj/item/clothing/mask/breath
	flags = OUTFIT_HAS_JETPACK

/datum/outfit/emergency_space_gear
	name = "Emergency space gear"
	shoes = /obj/item/clothing/shoes/black
	head = /obj/item/clothing/head/helmet/space/emergency
	suit = /obj/item/clothing/suit/space/emergency
	uniform = /obj/item/clothing/under/color/grey
	back = /obj/item/tank/oxygen
	mask = /obj/item/clothing/mask/breath

/datum/outfit/soviet_soldier
	name = "Soviet soldier"
	uniform = /obj/item/clothing/under/soviet
	shoes = /obj/item/clothing/shoes/boots/combat
	head = /obj/item/clothing/head/ushanka
	gloves = /obj/item/clothing/gloves/combat
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/gun/ballistic/revolver/mateba

/datum/outfit/soviet_soldier/admiral
	name = "Soviet admiral"
	head = /obj/item/clothing/head/hgpiratecap
	l_ear = /obj/item/radio/headset/heads/captain
	glasses = /obj/item/clothing/glasses/thermal/plain/eyepatch
	suit = /obj/item/clothing/suit/hgpirate

	id_slot = SLOT_ID_WORN_ID
	id_type = /obj/item/card/id/centcom	//station
	id_pda_assignment = "Admiral"

/datum/outfit/merchant
	name = "Nebula Gas Merchant"
	shoes = /obj/item/clothing/shoes/black
	gloves = /obj/item/clothing/gloves/brown
	back = /obj/item/storage/backpack/satchel
	l_ear = /obj/item/radio/headset/trader
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/trader_coveralls
	id_slot = SLOT_ID_WORN_ID
	id_type = /obj/item/card/id/external/merchant	//created a new ID so merchant can open their doors
	pda_slot = SLOT_ID_RIGHT_POCKET
	pda_type = /obj/item/pda/chef //cause I like the look
	id_pda_assignment = "Merchant"

/datum/outfit/merchant/vox //This needs to be updated.
	name = "Nebula Gas Merchant - Vox"
	shoes = /obj/item/clothing/shoes/boots/jackboots/toeless
	back = /obj/item/tank/vox
	uniform = /obj/item/clothing/under/vox/vox_robes
	suit = /obj/item/clothing/suit/armor/vox_scrap
	mask = /obj/item/clothing/mask/breath

/datum/outfit/zaddat
	name = "Zaddat Suit"
	suit = /obj/item/clothing/suit/space/void/zaddat/
	mask = /obj/item/clothing/mask/gas/zaddat
