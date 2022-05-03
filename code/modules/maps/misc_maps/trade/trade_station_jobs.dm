
/datum/department/trade_station
	name = DEPARTMENT_TRADE
	short_name = "Beruang"
	color = "#afccb8"
	sorting_order = -3
	assignable = FALSE
	visible = FALSE

/datum/job/trader
	title = "Trader"
	flag = TRADER
//	department = "Trader"
	//department_flag = TRADE
	department_flag = CIVILIAN
	//departments_managed = list(DEPARTMENT_TRADE)
	desc = "You are an <b>non-antagonist</b> trader! Within the rules, \
		try to provide interesting interaction for the crew. \
		Try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules apply to you.</b>"
	supervisors = "As a crewmember of the Beruang, you answer to your manager and international laws of space."
	outfit_type = /datum/outfit/trade

	offmap_spawn = TRUE
	faction = "Station" //Required for SSjob to allow people to join as it
	departments = list(DEPARTMENT_TRADE)
	total_positions = 3
	spawn_positions = 3
	selection_color = "#afccb8"
	economic_modifier = 6
	minimal_player_age = 14
	pto_type = null
	access = list(access_trader)
	minimal_access = list(access_trader)
	alt_titles = list(
		"Trade Manager" = /datum/alt_title/trade_manager,
		"Merchant" = /datum/alt_title/merchant
		)

/datum/alt_title/trade_manager
	title = "Trade Manager"
//	title_blurb = "A Drill Technician specializes in operating and maintaining the machinery needed to extract ore from veins deep below the surface."

/datum/alt_title/merchant
	title = "Merchant"

/datum/outfit/trade
	name = OUTFIT_JOB_NAME("Trader")
	shoes = /obj/item/clothing/shoes/black
	gloves = /obj/item/clothing/gloves/brown
	back = /obj/item/storage/backpack/satchel
	l_ear = /obj/item/radio/headset/trader
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/trader_coveralls
	id_slot = slot_wear_id
	id_type = /obj/item/card/id/external/merchant	//created a new ID so merchant can open their doors
	pda_slot = slot_r_store
	pda_type = /obj/item/pda/chef //cause I like the look
	id_pda_assignment = "Trader"
