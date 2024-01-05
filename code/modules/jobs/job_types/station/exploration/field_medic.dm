/datum/role/job/station/field_medic
	id = JOB_ID_FIELD_MEDIC
	title = "Field Medic"
	economy_payscale = ECONOMY_PAYSCALE_JOB_DANGER
	flag = SAR
	departments = list(DEPARTMENT_PLANET, DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Pathfinder and the Chief Medical Officer"
	selection_color = "#999440"
	idtype = /obj/item/card/id/medical/sar
	minimal_player_age = 3
	pto_type = PTO_EXPLORATION
	additional_access = list(
		ACCESS_MEDICAL_SURGERY,
		ACCESS_MEDICAL_CHEMISTRY,
		ACCESS_COMMAND_EVA,
		ACCESS_ENGINEERING_MAINT,
		ACCESS_ENGINEERING_AIRLOCK,
	)
	minimal_access = list(
		ACCESS_MEDICAL_MAIN,
		ACCESS_MEDICAL_EQUIPMENT,
		ACCESS_MEDICAL_MORGUE,
		ACCESS_GENERAL_PILOT,
		ACCESS_GENERAL_EXPLORER,
	)
	outfit_type = /datum/outfit/job/station/sar
	desc = "A Field medic works as the field doctor of expedition teams."
	alt_titles = list(
		"Expedition Medic" = /datum/prototype/struct/alt_title/expedition_medic
		)

/datum/prototype/struct/alt_title/expedition_medic
	title = "Expedition Medic"

/datum/outfit/job/station/sar
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

	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL|OUTFIT_COMPREHENSIVE_SURVIVAL
