/datum/outfit/spec_op_officer
	name = "Special ops - Officer"
	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/armor/swat/officer
	l_ear = /obj/item/radio/headset/ert
	glasses = /obj/item/clothing/glasses/thermal/plain/eyepatch
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/havana
	head = /obj/item/clothing/head/beret	//deathsquad
	belt = /obj/item/gun/energy/pulse_pistol
	back = /obj/item/storage/backpack/satchel
	shoes = /obj/item/clothing/shoes/boots/combat
	gloves = /obj/item/clothing/gloves/combat

	id_slot = SLOT_ID_WORN_ID
	id_type = /obj/item/card/id/centcom/ERT
	id_desc = "Special operations ID."
	id_pda_assignment = "Special Operations Officer"

/datum/outfit/spec_op_officer/space
	name = "Special ops - Officer in space"
	suit = /obj/item/clothing/suit/armor/swat	//obj/item/clothing/suit/space/void/swat
	back = /obj/item/tank/jetpack/oxygen
	mask = /obj/item/clothing/mask/gas/swat

	flags = OUTFIT_HAS_JETPACK

/datum/outfit/ert
	name = "Spec ops - Emergency response team"
	uniform = /obj/item/clothing/under/ert
	shoes = /obj/item/clothing/shoes/boots/swat
	gloves = /obj/item/clothing/gloves/swat
	l_ear = /obj/item/radio/headset/ert
	belt = /obj/item/gun/energy/gun
	glasses = /obj/item/clothing/glasses/sunglasses
	back = /obj/item/storage/backpack/satchel

	id_slot = SLOT_ID_WORN_ID
	id_type = /obj/item/card/id/centcom/ERT

/datum/outfit/death_command
	name = "Spec ops - Death commando"

/datum/outfit/death_command/equip(var/mob/living/carbon/human/H)
	deathsquad.equip(H)
	return 1

/datum/outfit/syndicate_command
	name = "Spec ops - Syndicate commando"

/datum/outfit/syndicate_command/equip(var/mob/living/carbon/human/H)
	commandos.equip(H)
	return 1

/datum/outfit/mercenary
	name = "Spec ops - Mercenary"
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/boots/combat
	l_ear = /obj/item/radio/headset/syndicate
	belt = /obj/item/storage/belt/security
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/swat

	l_pocket = /obj/item/reagent_containers/pill/cyanide

	id_slot = SLOT_ID_WORN_ID
	id_type = /obj/item/card/id/syndicate
	id_pda_assignment = "Mercenary"

	flags = OUTFIT_HAS_BACKPACK

/datum/outfit/PARA
	name = "Spec ops - PARA"
	uniform = /obj/item/clothing/under/para
	suit = /obj/item/clothing/suit/armor/vest/para
	shoes = /obj/item/clothing/shoes/boots/swat/para
	gloves = /obj/item/clothing/gloves/swat/para
	l_ear = /obj/item/radio/headset/ert
	belt = /obj/item/nullrod
	head = /obj/item/clothing/head/helmet/para
	back = /obj/item/storage/backpack/ert/para
	l_pocket = /obj/item/grenade/chem_grenade/holy
	l_hand = /obj/item/clothing/accessory/holster/holy

	id_slot = SLOT_ID_WORN_ID
	id_type = /obj/item/card/id/centcom/ERT/PARA

/datum/outfit/PARA/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(H.mind)
		H.mind.isholy = TRUE
