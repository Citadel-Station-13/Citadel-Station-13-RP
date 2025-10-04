/datum/prototype/role/job/station/senior_engineer
	title = "Senior Engineer"
	id = JOB_ID_SENIOR_ENGINEER
	economy_payscale = ECONOMY_PAYSCALE_JOB_SENIOR
	flag = SENIOR_ENGINEER
	departments = list(DEPARTMENT_ENGINEERING)
	department_flag = ENGSEC
	total_positions = 1
	spawn_positions = 5
	supervisors = "the Chief Engineer"
	selection_color = "#5B4D20"
	idtype = /obj/item/card/id/engineering/engineer
	pto_type = PTO_ENGINEERING

	minimal_access = list(
		ACCESS_COMMAND_EVA,
		ACCESS_ENGINEERING_ATMOS,
		ACCESS_ENGINEERING_MAIN,
		ACCESS_ENGINEERING_ENGINE,
		ACCESS_ENGINEERING_TECHSTORAGE,
		ACCESS_ENGINEERING_MAINT,
		ACCESS_ENGINEERING_AIRLOCK,
		ACCESS_ENGINEERING_CONSTRUCTION,
	)

	minimal_player_age = 14

	minimum_character_age = 25
	ideal_character_age = 45

	outfit_type = /datum/outfit/job/station/station_engineer/senior
	desc = "A Senior Engineer fulfills similar duties to other engineers, but usually occupies spare time with with training of other, newer Engineers \
			and giving advice in tricky engineering situations. You are not in command of the Engineering department, but should assist the CE in accordance with Standard Operating Procedures."

	alt_titles = list(
		"Engineering Training Specialist" = /datum/prototype/struct/alt_title/engi_trainer,
		)

/datum/prototype/struct/alt_title/engi_trainer
	title = "Engineering Training Specialist"
	title_blurb = "An Engineering Training Specialist is an experienced engineer who dedicates their time and expertise to the training of those who are less knowledgeable."

/datum/outfit/job/station/station_engineer/senior
	name = OUTFIT_JOB_NAME("Senior Engineer")
	head = /obj/item/clothing/head/hardhat/white
	uniform = /obj/item/clothing/under/rank/engineer
	id_type = /obj/item/card/id/engineering/engineer
	pda_type = /obj/item/pda/engineering
	l_ear = /obj/item/radio/headset/headset_eng
	belt = /obj/item/storage/belt/utility/atmostech
	belt = /obj/item/storage/belt/utility/full
	shoes = /obj/item/clothing/shoes/boots/workboots
	r_pocket = /obj/item/t_scanner

	id_type = /obj/item/card/id/engineering/atmos
	pda_type = /obj/item/pda/atmos

	backpack = /obj/item/storage/backpack/industrial
	satchel_one = /obj/item/storage/backpack/satchel/eng
	messenger_bag = /obj/item/storage/backpack/messenger/engi
	pda_slot = SLOT_ID_LEFT_POCKET
	dufflebag = /obj/item/storage/backpack/dufflebag/eng

	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
