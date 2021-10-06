/decl/hierarchy/outfit/job/centcom_officer
	name = OUTFIT_JOB_NAME("CentCom Officer")
	glasses = /obj/item/clothing/glasses/omnihud/all
	uniform = /obj/item/clothing/under/rank/centcom
	l_ear = /obj/item/radio/headset/centcom
	shoes = /obj/item/clothing/shoes/laceup
	id_type = /obj/item/card/id/centcom
	pda_type = /obj/item/pda/centcom
	gloves = /obj/item/clothing/gloves/white
	head = /obj/item/clothing/head/beret/centcom/officer
	r_pocket = /obj/item/pda/heads
	id_pda_assignment = "CentCom Officer"

/decl/hierarchy/outfit/job/emergency_responder
	name = OUTFIT_JOB_NAME("Emergency Responder")
	uniform = /obj/item/clothing/under/ert
	shoes = /obj/item/clothing/shoes/boots/swat
	gloves = /obj/item/clothing/gloves/swat
	l_ear = /obj/item/radio/headset/ert
	glasses = /obj/item/clothing/glasses/sunglasses
	back = /obj/item/storage/backpack/satchel
	id_type = /obj/item/card/id/centcom/ERT
	pda_type = /obj/item/pda/centcom
	flags = OUTFIT_EXTENDED_SURVIVAL|OUTFIT_COMPREHENSIVE_SURVIVAL

	post_equip(var/mob/living/carbon/human/H)
		..()
		ert.add_antagonist(H.mind)
