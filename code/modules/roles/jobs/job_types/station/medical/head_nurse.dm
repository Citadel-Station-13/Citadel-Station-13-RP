/datum/prototype/role/job/station/senior_physician
	title = "Senior Physician"
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
	additional_access = list(
		ACCESS_MEDICAL_CHEMISTRY,
		ACCESS_MEDICAL_VIROLOGY,
		ACCESS_SCIENCE_GENETICS,
	)
	minimal_access = list(
		ACCESS_COMMAND_EVA,
		ACCESS_MEDICAL_MAIN,
		ACCESS_MEDICAL_EQUIPMENT,
		ACCESS_MEDICAL_MORGUE,
		ACCESS_MEDICAL_SURGERY,
	)
	outfit_type = /datum/outfit/job/station/medical_doctor/senior_physician
	desc = "A Senior Physician is an experienced medical professional who fulfills a similar role to other doctors but usually occupies spare time with with training of other, newer doctors \
			and giving advice in tricky medical situations. You are not in command of the Medical department, but should assist the CMO in accordance with Standard Operating Procedures."

	minimal_player_age = 14
	minimum_character_age = 25
	ideal_character_age = 45

	alt_titles = list (
		"Medical Training Specialist" = /datum/prototype/struct/alt_title/medical_specialist,
	)


/datum/prototype/struct/alt_title/medical_specialist
	title = "Medical Training Specialist"
	title_blurb = "A Medical Training Specialist is a senior medical professional with extensive knowledge within a particular field of medicine which \
			is expected to perform the standard duties of a medical doctor, as well as offer training and guidance to both resident \
			and attending physicians in all matters, especially when presented with difficult situations within their field of expertise."
	title_outfit = /datum/outfit/job/station/medical_doctor


/datum/outfit/job/station/medical_doctor/senior_physician
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
