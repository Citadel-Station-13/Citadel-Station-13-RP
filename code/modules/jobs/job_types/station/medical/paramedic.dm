/datum/role/job/station/paramedic
	id = JOB_ID_PARAMEDIC
	title = "Paramedic"
	flag = PARAMEDIC
	departments = list(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Chief Medical Officer"
	selection_color = "#013D3B"
	pto_type = PTO_MEDICAL
	idtype = /obj/item/card/id/medical/paramedic
	additional_access = list(ACCESS_MEDICAL_MAIN, ACCESS_MEDICAL_EQUIPMENT, ACCESS_MEDICAL_MORGUE, ACCESS_MEDICAL_SURGERY, ACCESS_MEDICAL_CHEMISTRY, ACCESS_MEDICAL_VIROLOGY, ACCESS_COMMAND_EVA, ACCESS_ENGINEERING_MAINT, ACCESS_ENGINEERING_AIRLOCK, ACCESS_MEDICAL_PSYCH)
	minimal_access = list(ACCESS_MEDICAL_MAIN, ACCESS_MEDICAL_EQUIPMENT, ACCESS_MEDICAL_MORGUE, ACCESS_COMMAND_EVA, ACCESS_ENGINEERING_MAINT, ACCESS_ENGINEERING_AIRLOCK)
	outfit_type = /datum/outfit/job/station/paramedic
	desc = "A Paramedic is primarily concerned with the recovery of patients who are unable to make it to the Medical Department on their own. \
						They may also be called upon to keep patients stable when Medical is busy or understaffed."
	alt_titles = list(
		"Emergency Medical Technician" = /datum/prototype/alt_title/emt,
		"Medical Responder" = /datum/prototype/alt_title/medical_responder,
		"Biotechnical Responder" = /datum/prototype/alt_title/biotech_responder
		)
		
/datum/prototype/alt_title/biotech_responder
	title = "Biotechnical Responder"
	title_outfit = /datum/outfit/job/station/paramedic/emt  //TODO: add OSSNECRO outfits.
	background_allow = list(
		/datum/lore/character_background/faction/onkhera_necropolis
	)
	background_enforce = TRUE

/datum/prototype/alt_title/emt
	title = "Emergency Medical Technician"
	title_blurb = "An Emergency Medical Technician is primarily concerned with the recovery of patients who are unable to make it to the Medical Department on their \
					own. They are capable of keeping a patient stabilized until they reach the hands of someone with more training."
	title_outfit = /datum/outfit/job/station/paramedic/emt

/datum/prototype/alt_title/medical_responder
	title = "Medical Responder"
	title_blurb = "A Medical Responder is primarily concerned with the recovery of patients who are unable to make it to the Medical Department on their \
					own. They are capable of keeping a patient stabilized until they reach the hands of someone with more training."
	title_outfit = /datum/outfit/job/station/paramedic/emt

/datum/outfit/job/station/paramedic
	name = OUTFIT_JOB_NAME("Paramedic")
	uniform = /obj/item/clothing/under/rank/medical/scrubs/black
	suit = /obj/item/clothing/suit/storage/toggle/fr_jacket
	shoes = /obj/item/clothing/shoes/boots/jackboots
	l_hand = /obj/item/storage/firstaid/regular
	belt = /obj/item/storage/belt/medical/emt
	pda_slot = SLOT_ID_LEFT_POCKET
	id_type = /obj/item/card/id/medical/paramedic
	l_ear = /obj/item/radio/headset/headset_med
	pda_type = /obj/item/pda/medical

	backpack = /obj/item/storage/backpack/medic
	satchel_one = /obj/item/storage/backpack/satchel/med
	messenger_bag = /obj/item/storage/backpack/messenger/med
	dufflebag = /obj/item/storage/backpack/dufflebag/emt

	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/datum/outfit/job/station/paramedic/emt
	name = OUTFIT_JOB_NAME("Emergency Medical Technician")
	uniform = /obj/item/clothing/under/rank/medical/paramedic
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/emt
