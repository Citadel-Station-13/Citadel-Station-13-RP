/datum/role/job/station/explorer
	id = JOB_ID_EXPLORER
	title = "Explorer"
	economy_payscale = ECONOMY_PAYSCALE_JOB_DANGER
	flag = EXPLORER
	departments = list(DEPARTMENT_PLANET)
	department_flag = MEDSCI
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Pathfinder and the Research Director"
	selection_color = "#999440"
	pto_type = PTO_EXPLORATION
	idtype = /obj/item/card/id/explorer/explorer
	additional_access = list(ACCESS_GENERAL_EXPLORER, ACCESS_ENGINEERING_AIRLOCK, ACCESS_SCIENCE_MAIN, ACCESS_GENERAL_PILOT, ACCESS_GENERAL_GATEWAY)
	minimal_access = list(ACCESS_GENERAL_EXPLORER, ACCESS_ENGINEERING_AIRLOCK, ACCESS_SCIENCE_MAIN, ACCESS_GENERAL_PILOT, ACCESS_GENERAL_GATEWAY)
	outfit_type = /datum/outfit/job/station/explorer
	desc = "An Explorer searches for interesting things, and returns them to the station."
	alt_titles = list(
		"Surveyor" = /datum/prototype/alt_title/surveyor,
		"Offsite Scout" = /datum/prototype/alt_title/offsite_scout,
		"Field Scout" = /datum/prototype/alt_title/explorer/field_scout,
		"Pioneer" = /datum/prototype/alt_title/explorer/pioneer,
		"Jr. Explorer" = /datum/prototype/alt_title/explorer/junior
		)

/datum/prototype/alt_title/surveyor
	title = "Surveyor"

/datum/prototype/alt_title/offsite_scout
	title = "Offsite Scout"

/datum/prototype/alt_title/explorer/field_scout
	title = "Field Scout"

/datum/prototype/alt_title/explorer/pioneer
	title = "Pioneer"

/datum/prototype/alt_title/explorer/junior
	title = "Jr. Explorer"

/datum/outfit/job/station/explorer
	name = OUTFIT_JOB_NAME("Explorer")
	id_pda_assignment = "Explorer"
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	uniform = /obj/item/clothing/under/explorer
	l_ear = /obj/item/radio/headset/explorer

	id_slot = SLOT_ID_WORN_ID
	pda_slot = SLOT_ID_LEFT_POCKET

	pda_type = /obj/item/pda/explorer
	id_type = /obj/item/card/id/explorer/explorer

	backpack = /obj/item/storage/backpack/voyager
	backpack_contents = list(/obj/item/clothing/accessory/permit/gun/planetside = 1)
	satchel_one = /obj/item/storage/backpack/satchel/voyager
	dufflebag = /obj/item/storage/backpack/dufflebag/voyager

	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL

/datum/outfit/job/station/explorer2/post_equip(mob/living/carbon/human/H)
	..()
	for(var/obj/item/clothing/accessory/permit/gun/planetside/permit in H.back.contents)
		permit.set_name(H.real_name)

/datum/outfit/job/station/explorer/technician
	name = OUTFIT_JOB_NAME("Explorer Technician")
	belt = /obj/item/storage/belt/utility/full
	pda_slot = SLOT_ID_LEFT_POCKET
	id_pda_assignment = "Explorer Technician"

/datum/outfit/job/station/explorer/medic
	name = OUTFIT_JOB_NAME("Explorer Medic")
	l_hand = /obj/item/storage/firstaid/regular
	pda_slot = SLOT_ID_LEFT_POCKET
	id_pda_assignment = "Explorer Medic"
