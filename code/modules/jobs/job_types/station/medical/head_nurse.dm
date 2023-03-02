/datum/role/job/station/head_nurse
	title = "Head Nurse"
	id = JOB_ID_HEAD_NURSE
	flag = HEAD_NURSE
	economy_payscale = ECONOMY_PAYSCALE_JOB_SENIOR
	departments = list(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	total_positions = 1
	spawn_positions = 3
	supervisors = "the Chief Medical Officer"
	selection_color = "#013D3B"
	pto_type = PTO_MEDICAL
	idtype = /obj/item/card/id/medical/doctor
	additional_access = list(ACCESS_MEDICAL_MAIN, ACCESS_MEDICAL_EQUIPMENT, ACCESS_MEDICAL_MORGUE, ACCESS_MEDICAL_SURGERY, ACCESS_MEDICAL_CHEMISTRY, ACCESS_MEDICAL_VIROLOGY, ACCESS_SCIENCE_GENETICS, ACCESS_COMMAND_EVA)
	minimal_access = list(ACCESS_MEDICAL_MAIN, ACCESS_MEDICAL_EQUIPMENT, ACCESS_MEDICAL_MORGUE, ACCESS_MEDICAL_SURGERY, ACCESS_MEDICAL_VIROLOGY, ACCESS_COMMAND_EVA)
	outfit_type = /datum/outfit/job/station/medical_doctor/head_nurse
	desc = "A Head Nurse is a senior medical professional from the nursing field. They are expected to coordinate and perform the duties associated with \
	nurses, such as sensors monitoring and non-critical care, as well as provide them and other medical staff with guidance and oversight when presented with \
	difficult situations related to patient care."

	minimal_player_age = 14
	minimum_character_age = 25
	ideal_character_age = 45

	alt_titles = list (
		"Medical Specialist" = /datum/prototype/alt_title/medical_specialist,
		"Consultant Physician" = /datum/prototype/alt_title/consultant_physician,
		"Biotechnical Advisor" = /datum/prototype/alt_title/biotechnical_advisor
	)

/datum/prototype/alt_title/biotechnical_advisor
	title = "Biotechnical Advisor"
	title_outfit = /datum/outfit/job/station/medical_doctor // todo: add OSSNECRO outfits.
	background_allow = list(
		/datum/lore/character_background/faction/onkhera_necropolis
	)
	background_enforce = TRUE

/datum/prototype/alt_title/medical_specialist
	title = "Medical Specialist"
	title_blurb = "A Medical Specialist is a senior medical professional with extensive knowledge within a particular field of medicine which \
	is expected to perform the standard duties of a medical doctor, as well as offer training, guidance and oversight to both resident \
	and attending physicians in all matters, especially when presented with difficult situations within their field of expertise."
	title_outfit = /datum/outfit/job/station/medical_doctor

/datum/prototype/alt_title/consultant_physician
	title = "Consultant Physician"
	title_blurb = "A Consultant Physician is a senior medical professional with extensive training in general medical practice which is expected to perform the \
	standard duties of a medical doctor, as well as offer training, guidance and oversight to resident and attending physicians, especially when presented with difficult \
	situations related to patient care."
	title_outfit = /datum/outfit/job/station/medical_doctor

/datum/outfit/job/station/medical_doctor/head_nurse
	name = OUTFIT_JOB_NAME("Medical Doctor")
	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	l_hand = /obj/item/storage/firstaid/regular
	r_pocket = /obj/item/flashlight/pen
	id_type = /obj/item/card/id/medical
	l_ear = /obj/item/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/white

	pda_type = /obj/item/pda/medical
	pda_slot = SLOT_ID_LEFT_POCKET
	backpack = /obj/item/storage/backpack/medic
	satchel_one = /obj/item/storage/backpack/satchel/med
	messenger_bag = /obj/item/storage/backpack/messenger/med
	dufflebag = /obj/item/storage/backpack/dufflebag/med


/datum/outfit/job/station/medical_doctor/nurse/pre_equip(mob/living/carbon/human/H)
	if(H.gender == FEMALE)
		if(prob(50))
			uniform = /obj/item/clothing/under/rank/nursesuit
		else
			uniform = /obj/item/clothing/under/rank/nurse
		head = /obj/item/clothing/head/nursehat
	else
		uniform = /obj/item/clothing/under/rank/medical/scrubs/purple
	..()
