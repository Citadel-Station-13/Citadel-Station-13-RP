/datum/role/job/station/pilot
	id = JOB_ID_PILOT
	title = "Pilot"
	economy_payscale = ECONOMY_PAYSCALE_JOB_HELM
	flag = PILOT
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Pathfinder and the Head of Personnel"
	idtype = /obj/item/card/id/explorer/pilot
	selection_color = "#515151"
	minimal_player_age = 3
	pto_type = PTO_EXPLORATION
	additional_access = list(ACCESS_GENERAL_PILOT, ACCESS_ENGINEERING_AIRLOCK)
	minimal_access = list(ACCESS_GENERAL_PILOT, ACCESS_ENGINEERING_AIRLOCK)
	outfit_type = /datum/outfit/job/station/pilot
	desc = "A Pilot flies the various shuttles in the Virgo-Erigone System."
	alt_titles = list(
		"Co-Pilot" = /datum/prototype/alt_title/co_pilot,
		"Navigator" = /datum/prototype/alt_title/navigator
		)

/datum/prototype/alt_title/co_pilot
	title = "Co-Pilot"
	title_blurb = "A Co-Pilot is there primarily to assist main pilot as well as learn from them"

/datum/prototype/alt_title/navigator
	title = "Navigator"

/datum/outfit/job/station/pilot
	name = OUTFIT_JOB_NAME("Pilot")
	shoes = /obj/item/clothing/shoes/black
	uniform = /obj/item/clothing/under/rank/pilot1
	suit = /obj/item/clothing/suit/storage/toggle/bomber/pilot
	gloves = /obj/item/clothing/gloves/fingerless
	glasses = /obj/item/clothing/glasses/fakesunglasses/aviator
	l_ear = /obj/item/radio/headset/pilot/alt
	id_slot = SLOT_ID_WORN_ID
	pda_slot = SLOT_ID_BELT
	pda_type = /obj/item/pda
	id_type = /obj/item/card/id/explorer/pilot
	id_pda_assignment = "Pilot"
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL
