/datum/role/job/station/psychiatrist
	id = JOB_ID_PSYCHIATRIST
	title = "Psychiatrist"
	flag = PSYCHIATRIST
	departments = list(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Medical Officer"
	selection_color = "#013D3B"
	pto_type = PTO_MEDICAL
	idtype = /obj/item/card/id/medical/psychiatrist
	additional_access = list(
		ACCESS_MEDICAL_CHEMISTRY,
		ACCESS_MEDICAL_MORGUE,
	)
	minimal_access = list(
		ACCESS_MEDICAL_MAIN,
		ACCESS_MEDICAL_EQUIPMENT,
		ACCESS_MEDICAL_PSYCH,
	)
	outfit_type = /datum/outfit/job/station/psychiatrist
	desc = "A Psychiatrist provides mental health services to crew members in need. They may also be called upon to determine whatever \
					ails the mentally unwell, frequently under Security supervision. They understand the effects of various psychoactive drugs."
	alt_titles = list(
		"Psychologist" = /datum/prototype/struct/alt_title/psychologist,
		"Counselor" = /datum/prototype/struct/alt_title/counselor
		)

/datum/prototype/struct/alt_title/psychologist
	title = "Psychologist"
	title_blurb =  "A Psychologist provides mental health services to crew members in need, focusing more on therapy than medication. They may also be \
					called upon to determine whatever ails the mentally unwell, frequently under Security supervision."
	title_outfit = /datum/outfit/job/station/psychiatrist/psychologist

/datum/prototype/struct/alt_title/counselor
	title = "Counselor"
	title_blurb = "A Counselor tends to the emotional needs of the crew, and usually specializes in giving advice to those struggling with interpersonal \
				relationships, addictions, self-esteem issues, and/or grief."

/datum/outfit/job/station/psychiatrist
	name = OUTFIT_JOB_NAME("Psychiatrist")
	uniform = /obj/item/clothing/under/rank/psych
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/laceup
	l_ear = /obj/item/radio/headset/headset_med

	id_type = /obj/item/card/id/medical/psychiatrist
	pda_type = /obj/item/pda/medical
	pda_slot = SLOT_ID_LEFT_POCKET
	backpack = /obj/item/storage/backpack/medic
	satchel_one = /obj/item/storage/backpack/satchel/med
	messenger_bag = /obj/item/storage/backpack/messenger/med
	dufflebag = /obj/item/storage/backpack/dufflebag/med

/datum/outfit/job/station/psychiatrist/psychologist
	name = OUTFIT_JOB_NAME("Psychologist")
	uniform = /obj/item/clothing/under/rank/psych/turtleneck
