/datum/job/station/explorer
	title = "Explorer"
	flag = EXPLORER
	departments = list(DEPARTMENT_PLANET)
	department_flag = MEDSCI
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Pathfinder and the Research Director"
	selection_color = "#999440"
	economic_modifier = 6
	pto_type = PTO_EXPLORATION
	idtype = /obj/item/card/id/explorer/explorer
	access = list(access_explorer, access_external_airlocks, access_research, access_pilot, access_gateway)
	minimal_access = list(access_explorer, access_external_airlocks, access_research, access_pilot, access_gateway)
	outfit_type = /datum/outfit/job/station/explorer
	desc = "An Explorer searches for interesting things, and returns them to the station."
	alt_titles = list(
		"Surveyor" = /datum/alt_title/surveyor,
		"Offsite Scout" = /datum/alt_title/offsite_scout,
		"Field Scout" = /datum/alt_title/explorer/field_scout,
		"Pioneer" = /datum/alt_title/explorer/pioneer,
		"Jr. Explorer" = /datum/alt_title/explorer/junior
		)

/datum/alt_title/surveyor
	title = "Surveyor"

/datum/alt_title/offsite_scout
	title = "Offsite Scout"

/datum/alt_title/explorer/field_scout
	title = "Field Scout"

/datum/alt_title/explorer/pioneer
	title = "Pioneer"

/datum/alt_title/explorer/junior
	title = "Jr. Explorer"

/datum/outfit/job/station/explorer
	name = OUTFIT_JOB_NAME("Explorer")
	id_pda_assignment = "Explorer"
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	uniform = /obj/item/clothing/under/explorer
	l_ear = /obj/item/radio/headset/explorer

	id_slot = slot_wear_id
	pda_slot = slot_l_store
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
	pda_slot = slot_l_store
	id_pda_assignment = "Explorer Technician"

/datum/outfit/job/station/explorer/medic
	name = OUTFIT_JOB_NAME("Explorer Medic")
	l_hand = /obj/item/storage/firstaid/regular
	pda_slot = slot_l_store
	id_pda_assignment = "Explorer Medic"
