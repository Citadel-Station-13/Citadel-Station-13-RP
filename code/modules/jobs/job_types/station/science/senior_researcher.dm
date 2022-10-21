/datum/job/station/senior_researcher
	title = "Senior Researcher"
	flag = SENIOR_RESEARCHER
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	total_positions = 1
	spawn_positions = 5
	supervisors = "the Research Director"
	selection_color = "#633D63"
	idtype = /obj/item/card/id/science/scientist
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch, access_xenobotany)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch, access_xenobiology, access_xenobotany)

	minimal_player_age = 14

	minimum_character_age = 25
	ideal_character_age = 45

	outfit_type = /datum/outfit/job/station/scientist/senior_researcher
	pto_type = PTO_SCIENCE
	desc = "Lorem Ipsum"


/datum/outfit/job/station/scientist/senior_researcher
	name = OUTFIT_JOB_NAME("Scientist")
	uniform = /obj/item/clothing/under/rank/scientist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science
	l_ear = /obj/item/radio/headset/headset_sci
	shoes = /obj/item/clothing/shoes/white

	id_type = /obj/item/card/id/science/scientist
	pda_type = /obj/item/pda/science
	pda_slot = SLOT_ID_LEFT_POCKET

	backpack = /obj/item/storage/backpack/toxins
	satchel_one = /obj/item/storage/backpack/satchel/tox
	messenger_bag = /obj/item/storage/backpack/messenger/tox
	dufflebag = /obj/item/storage/backpack/dufflebag/sci

/datum/outfit/job/station/scientist/xenobiologist
	name = OUTFIT_JOB_NAME("Xenobiologist")
	id_type = /obj/item/card/id/science/xenobiologist
