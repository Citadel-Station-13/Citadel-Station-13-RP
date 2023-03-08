/datum/role/job/station/quartermaster
	id = JOB_ID_QUARTERMASTER
	title = "Quartermaster"
	economy_payscale = ECONOMY_PAYSCALE_JOB_SENIOR
	flag = QUARTERMASTER
	departments = list(
		DEPARTMENT_CARGO,
	)
	sorting_order = 1 // QM is above the cargo techs, but below the HoP.
	departments_managed = list(
		DEPARTMENT_CARGO,
	)
	department_flag = CIVILIAN
	pto_type = PTO_CARGO
	total_positions = 1
	spawn_positions = 1
	idtype = /obj/item/card/id/cargo/head
	supervisors = "the Head of Personnel"
	selection_color = "#9b633e"
	minimal_access = list(
		ACCESS_ENGINEERING_MAINT,
		ACCESS_SUPPLY_BAY,
		ACCESS_SUPPLY_EDIT,
		ACCESS_SUPPLY_MAIN,
		ACCESS_SUPPLY_MINE,
		ACCESS_SUPPLY_MINE_OUTPOST,
		ACCESS_SUPPLY_MULEBOT,
		ACCESS_SUPPLY_QM,
	)

	ideal_character_age = 40

	outfit_type = /datum/outfit/job/station/quartermaster
	desc = "The Quartermaster manages the Supply department, checking cargo orders and ensuring supplies get to where they are needed."
	alt_titles = list(
		"Supply Chief" = /datum/prototype/alt_title/supply_chief,
		"Logisticai-Adept" = /datum/prototype/alt_title/logisticai_adept
		)

/datum/prototype/alt_title/logisticai_adept
	title = "Logisticai-Adept"
	background_allow = list(
		/datum/lore/character_background/faction/naramadiguilds
	)
	background_enforce = TRUE

/datum/prototype/alt_title/supply_chief
	title = "Supply Chief"

/datum/outfit/job/station/quartermaster
	name = OUTFIT_JOB_NAME("Quartermaster")
	uniform = /obj/item/clothing/under/rank/cargo
	l_ear = /obj/item/radio/headset/headset_mine
	shoes = /obj/item/clothing/shoes/brown
	glasses = /obj/item/clothing/glasses/sunglasses
	l_hand = /obj/item/clipboard
	id_type = /obj/item/card/id/cargo/head
	pda_type = /obj/item/pda/quartermaster
