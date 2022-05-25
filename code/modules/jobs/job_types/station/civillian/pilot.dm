/datum/job/station/pilot
	title = "Pilot"
	flag = PILOT
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Pathfinder and the Head of Personnel"
	idtype = /obj/item/card/id/explorer/pilot
	selection_color = "#515151"
	economic_modifier = 5
	minimal_player_age = 3
	pto_type = PTO_EXPLORATION
	access = list(access_pilot, access_external_airlocks)
	minimal_access = list(access_pilot, access_external_airlocks)
	outfit_type = /datum/outfit/job/station/pilot
	desc = "A Pilot flies the various shuttles in the Virgo-Erigone System."
	alt_titles = list(
		"Co-Pilot" = /datum/alt_title/co_pilot,
		"Navigator" = /datum/alt_title/navigator
		)

/datum/alt_title/co_pilot
	title = "Co-Pilot"
	title_blurb = "A Co-Pilot is there primarily to assist main pilot as well as learn from them"

/datum/alt_title/navigator
	title = "Navigator"

/datum/outfit/job/station/pilot
	name = OUTFIT_JOB_NAME("Pilot")
	shoes = /obj/item/clothing/shoes/black
	uniform = /obj/item/clothing/under/rank/pilot1
	suit = /obj/item/clothing/suit/storage/toggle/bomber/pilot
	gloves = /obj/item/clothing/gloves/fingerless
	glasses = /obj/item/clothing/glasses/fakesunglasses/aviator
	l_ear = /obj/item/radio/headset/pilot/alt
	id_slot = slot_wear_id
	pda_slot = slot_belt
	pda_type = /obj/item/pda
	id_type = /obj/item/card/id/explorer/pilot
	id_pda_assignment = "Pilot"
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL
