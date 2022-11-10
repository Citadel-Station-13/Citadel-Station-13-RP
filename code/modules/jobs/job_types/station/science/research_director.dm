/datum/job/station/research_director
	title = "Research Director"
	flag = RD
	departments_managed = list(DEPARTMENT_RESEARCH)
	departments = list(DEPARTMENT_RESEARCH, DEPARTMENT_COMMAND)
	sorting_order = 2
	disallow_jobhop = TRUE
	pto_type = PTO_SCIENCE
	department_flag = MEDSCI
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Facility Director"
	selection_color = "#AD6BAD"
	idtype = /obj/item/card/id/science/head
	req_admin_notify = 1
	economic_modifier = 15
	access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
						access_tox_storage, access_teleporter, access_sec_doors,
						access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
						access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network)
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
						access_tox_storage, access_teleporter, access_sec_doors,
						access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
						access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network)

	minimum_character_age = 25
	minimal_player_age = 14
	ideal_character_age = 50

	outfit_type = /datum/outfit/job/station/research_director
	desc = "The Research Director manages and maintains the Research department. They are required to ensure the safety of the entire crew, \
						at least with regards to anything occuring in the Research department, and to inform the crew of any disruptions that \
						might originate from Research. The Research Director often has at least passing knowledge of most of the Research department, but \
						are encouraged to allow their staff to perform their own duties."
	alt_titles = list(
		"Research Supervisor" = /datum/alt_title/research_supervisor,
		"Head of Development" = /datum/alt_title/head_of_development,
		"Head Scientist" = /datum/alt_title/head_scientist
		)

/datum/alt_title/research_supervisor
	title = "Research Supervisor"

/datum/alt_title/head_of_development
	title = "Head of Development"

/datum/alt_title/head_scientist
	title = "Head Scientist"

/datum/outfit/job/station/research_director
	name = OUTFIT_JOB_NAME("Research Director")
	l_ear = /obj/item/radio/headset/heads/rd
	uniform = /obj/item/clothing/under/rank/research_director
	shoes = /obj/item/clothing/shoes/brown
	l_hand = /obj/item/clipboard
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/rd

	id_type = /obj/item/card/id/science/head
	pda_type = /obj/item/pda/heads/rd

	backpack = /obj/item/storage/backpack/toxins
	satchel_one = /obj/item/storage/backpack/satchel/tox
	messenger_bag = /obj/item/storage/backpack/messenger/tox
	dufflebag = /obj/item/storage/backpack/dufflebag/sci
