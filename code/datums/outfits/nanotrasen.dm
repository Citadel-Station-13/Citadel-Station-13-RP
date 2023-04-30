/datum/outfit/nanotrasen
	abstract_type = /datum/outfit/nanotrasen
	uniform = /obj/item/clothing/under/rank/centcom
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/white
	l_ear = /obj/item/radio/headset/heads/hop
	glasses = /obj/item/clothing/glasses/sunglasses

	id_slot = SLOT_ID_WORN_ID
	id_type = /obj/item/card/id/centcom	//station
	pda_slot = SLOT_ID_RIGHT_POCKET
	pda_type = /obj/item/pda/heads

/datum/outfit/nanotrasen/representative
	name = "Nanotrasen representative"
	belt = /obj/item/clipboard
	id_pda_assignment = "NanoTrasen Representative"

/datum/outfit/nanotrasen/officer
	name = "Nanotrasen officer"
	head = /obj/item/clothing/head/beret/centcom/officer
	l_ear = /obj/item/radio/headset/heads/captain
	belt = /obj/item/gun/energy
	id_pda_assignment = "NanoTrasen Officer"

/datum/outfit/nanotrasen/commander
	name = "Nanotrasen commander"
	uniform = /obj/item/clothing/under/rank/centcom
	l_ear = /obj/item/radio/headset/heads/captain
	head = /obj/item/clothing/head/beret/centcom/captain
	belt = /obj/item/gun/energy
	id_pda_assignment = "NanoTrasen Commander"
