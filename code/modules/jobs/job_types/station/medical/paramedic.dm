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
	additional_access = list(
		ACCESS_MEDICAL_SURGERY,
		ACCESS_MEDICAL_CHEMISTRY,
		ACCESS_COMMAND_EVA,
		ACCESS_MEDICAL_VIROLOGY,
		ACCESS_MEDICAL_PSYCH,
		ACCESS_ENGINEERING_MAINT,
		ACCESS_ENGINEERING_AIRLOCK,
	)
	minimal_access = list(
		ACCESS_MEDICAL_MAIN,
		ACCESS_MEDICAL_EQUIPMENT,
		ACCESS_MEDICAL_MORGUE,
		ACCESS_COMMAND_EVA,
		ACCESS_ENGINEERING_MAINT,
		ACCESS_GENERAL_PILOT,
		ACCESS_GENERAL_EXPLORER,
	)
	outfit_type = /datum/outfit/job/station/paramedic
	desc = "A Paramedic is primarily concerned with the stabilization and recovery of patients who are unable to make it to the Medical Department on their own. \
						They may also be called upon to keep patients stable when Medical is busy or understaffed and are renowned for their advanced emergency capabilities."
	alt_titles = list(
		"Emergency Medical Technician" = /datum/prototype/struct/alt_title/emt,
		"Field Medic" = /datum/prototype/struct/alt_title/field_medic,
		"Flight Medic" = /datum/prototype/struct/alt_title/flight_medic,
		)

/datum/prototype/struct/alt_title/emt
	title = "Emergency Medical Technician"
	title_blurb = "An Emergency Medical Technician is primarily concerned with the stabilization and recovery of patients who are unable to make it to the Medical Department on their \
					own. They are capable of keeping a patient stabilized until they reach the hands of someone with more training."
	title_outfit = /datum/outfit/job/station/paramedic/emt
	
/datum/prototype/struct/alt_title/field_medic
	title = "Field Medic"
	title_blurb = "A Field Medic is an advanced medical practitioner tasked with projecting advanced medical care to austere and unsterile environments. Due to the hazard \
					inherent with their duties, their expertise is critical to maintaining the readiness of exploration crew."
	title_outfit = /datum/outfit/job/station/paramedic/field_medic
	
/datum/prototype/struct/alt_title/flight_medic
	title = "Flight Medic"
	title_blurb = "A Flight Medic is an advanced medical practitioner tasked with operation of rapid response vehicles and assets while managing medical care with the complexity \
					of transport. They may be expected to operate emergency shuttles with multiple casualties on-board."
	title_outfit = /datum/outfit/job/station/paramedic/flight_medic

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

/datum/outfit/job/station/paramedic/emt
	name = OUTFIT_JOB_NAME("Emergency Medical Technician")
	uniform = /obj/item/clothing/under/rank/medical/paramedic
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/emt

/datum/outfit/job/station/paramedic/field_medic
	name = OUTFIT_JOB_NAME("Field Medic")
	uniform = /obj/item/clothing/under/utility/blue
	suit = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	l_ear = /obj/item/radio/headset/sar
	l_hand = /obj/item/storage/firstaid/regular
	belt = /obj/item/storage/belt/medical/emt
	pda_slot = SLOT_ID_LEFT_POCKET
	r_pocket = /obj/item/flashlight/pen
	pda_type = /obj/item/pda/sar
	id_type = /obj/item/card/id/medical/sar
	id_pda_assignment = "Field Medic"

	backpack = /obj/item/storage/backpack/medic
	satchel_one = /obj/item/storage/backpack/satchel/med
	messenger_bag = /obj/item/storage/backpack/messenger/med
	dufflebag = /obj/item/storage/backpack/dufflebag/med

/datum/outfit/job/station/paramedic/flight_medic
	name = OUTFIT_JOB_NAME("Flight Medic")
	uniform = /obj/item/clothing/under/utility/blue
	suit = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	l_ear = /obj/item/radio/headset/sar
	l_hand = /obj/item/storage/firstaid/regular
	belt = /obj/item/storage/belt/medical/emt
	pda_slot = SLOT_ID_LEFT_POCKET
	r_pocket = /obj/item/flashlight/pen
	pda_type = /obj/item/pda/sar
	id_type = /obj/item/card/id/medical/sar
	id_pda_assignment = "Flight Medic"

	backpack = /obj/item/storage/backpack/medic
	satchel_one = /obj/item/storage/backpack/satchel/med
	messenger_bag = /obj/item/storage/backpack/messenger/med
	dufflebag = /obj/item/storage/backpack/dufflebag/med
