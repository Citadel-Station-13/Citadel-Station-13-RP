/datum/job/station/bartender
	id = JOB_ID_BARTENDER
	title = "Bartender"
	flag = BARTENDER
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	idtype = /obj/item/card/id/civilian/bartender
	pto_type = PTO_CIVILIAN
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_bar)

	outfit_type = /datum/outfit/job/station/bartender
	desc = "A Bartender mixes drinks for the crew. They generally have permission to charge for drinks or deny service to unruly patrons."
	alt_titles = list(
		"Barista" = /datum/alt_title/bartender/barista,
		"Barkeeper" = /datum/alt_title/bartender/barkeeper,
		"Barmaid" = /datum/alt_title/bartender/barmaid
	)

/datum/alt_title/bartender/barkeeper
	title = "Barkeeper"

/datum/alt_title/bartender/barmaid
	title = "Barmaid"

/datum/alt_title/bartender/barista
	title = "Barista"
	title_blurb = "A barista mans the Cafe, serving primarily non-alcoholic drinks to the crew. They generally have permission to charge for drinks \
					or deny service to unruly patrons."
	title_outfit = /datum/outfit/job/station/bartender/barista

/datum/outfit/job/station/bartender
	name = OUTFIT_JOB_NAME("Bartender")
	uniform = /obj/item/clothing/under/rank/bartender
	id_type = /obj/item/card/id/civilian/bartender
	pda_type = /obj/item/pda/bar
	l_ear = /obj/item/radio/headset/headset_service
	backpack_contents = list(/obj/item/clothing/accessory/permit/gun/bar = 1)

/datum/outfit/job/station/bartender/post_equip(mob/living/carbon/human/H)
	..()
	for(var/obj/item/clothing/accessory/permit/gun/bar/permit in H.back.contents)
		permit.set_name(H.real_name)

/datum/outfit/job/station/bartender/barista
	name = OUTFIT_JOB_NAME("Barista")
	id_pda_assignment = "Barista"
	backpack_contents = null

