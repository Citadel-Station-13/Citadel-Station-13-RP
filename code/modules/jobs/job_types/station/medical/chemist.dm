/datum/role/job/station/chemist
	id = JOB_ID_CHEMIST
	title = "Chemist"
	flag = CHEMIST
	departments = list(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Medical Officer"
	selection_color = "#013D3B"
	pto_type = PTO_MEDICAL
	idtype = /obj/item/card/id/medical/chemist
	additional_access = list(ACCESS_MEDICAL_MAIN, ACCESS_MEDICAL_EQUIPMENT, ACCESS_MEDICAL_MORGUE, ACCESS_MEDICAL_SURGERY, ACCESS_MEDICAL_CHEMISTRY, ACCESS_MEDICAL_VIROLOGY, ACCESS_SCIENCE_GENETICS)
	minimal_access = list(ACCESS_MEDICAL_MAIN, ACCESS_MEDICAL_EQUIPMENT, ACCESS_MEDICAL_CHEMISTRY)
	minimal_player_age = 3

	outfit_type = /datum/outfit/job/station/chemist
	desc = "A Chemist produces and maintains a stock of basic to advanced chemicals for medical and occasionally research use. \
						They are likely to know the use and dangers of many lab-produced chemicals."
	alt_titles = list(
		"Pharmacist" = /datum/prototype/alt_title/pharmacist,
		"Pharmacologist" = /datum/prototype/alt_title/pharmacologist,
		"Biochemist" = /datum/prototype/alt_title/biochemist
		)

/datum/prototype/alt_title/biochemist
	title = "Biochemist"
	background_allow = list(
		/datum/lore/character_background/faction/onkhera_necropolis
	)
	background_enforce = TRUE

/datum/prototype/alt_title/pharmacist
	title = "Pharmacist"
	title_blurb = "A Pharmacist focuses on the chemical needs of the Medical Department, and often offers to fill crew prescriptions at their discretion."

/datum/prototype/alt_title/pharmacologist
	title = "Pharmacologist"
	title_blurb = "A Pharmacologist focuses on the chemical needs of the Medical Department, primarily specializing in producing more advanced forms of medicine."

/datum/outfit/job/station/chemist
	name = OUTFIT_JOB_NAME("Chemist")
	uniform = /obj/item/clothing/under/rank/chemist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/chemist
	l_ear = /obj/item/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/white

	id_type = /obj/item/card/id/medical/chemist
	pda_type = /obj/item/pda/chemist
	pda_slot = SLOT_ID_LEFT_POCKET

	backpack = /obj/item/storage/backpack/chemistry
	satchel_one = /obj/item/storage/backpack/satchel/chem
	messenger_bag = /obj/item/storage/backpack/messenger/med
	dufflebag = /obj/item/storage/backpack/dufflebag/chemistry
