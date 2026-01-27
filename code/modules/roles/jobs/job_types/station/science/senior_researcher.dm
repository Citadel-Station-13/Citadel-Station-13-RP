/datum/prototype/role/job/station/senior_researcher
	title = "Senior Researcher"
	economy_payscale = ECONOMY_PAYSCALE_JOB_SENIOR
	id = JOB_ID_SENIOR_RESEARCHER
	flag = SENIOR_RESEARCHER
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	total_positions = 1
	spawn_positions = 5
	supervisors = "the Research Director"
	selection_color = "#633D63"
	idtype = /obj/item/card/id/science/scientist
	pto_type = PTO_SCIENCE

	minimal_access = list(
		ACCESS_SCIENCE_FABRICATION,
		ACCESS_SCIENCE_TOXINS,
		ACCESS_SCIENCE_MAIN,
		ACCESS_SCIENCE_ROBOTICS,
		ACCESS_SCIENCE_XENOARCH,
		ACCESS_SCIENCE_XENOBIO,
		ACCESS_SCIENCE_XENOBOTANY,
		ACCESS_SCIENCE_GENETICS,
	)

	minimal_player_age = 14

	minimum_character_age = 25
	ideal_character_age = 45

	outfit_type = /datum/outfit/job/station/scientist/senior_researcher
	desc = "A Senior Researcher fulfills similar duties to other scientists, but usually occupies spare time with with training of other, newer scientists \
			and giving advice to ensure safety. You are not in command of the Science department, but should assist the RD in accordance with Standard Operating Procedures."

	alt_titles = list(
		"Research Training Specialist" = /datum/prototype/struct/alt_title/sci_trainer
		)

/datum/prototype/struct/alt_title/sci_trainer
	title = "Research Training Specialist"
	title_blurb = "An Research Training Specialist is an experienced scientist who dedicates their time and expertise to the training of those who are less knowledgeable."


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
