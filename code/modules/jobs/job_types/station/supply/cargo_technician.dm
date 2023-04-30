/datum/role/job/station/cargo_tech
	id = JOB_ID_CARGO_TECHNICIAN
	title = "Cargo Technician"
	flag = CARGOTECH
	departments = list(DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	pto_type = PTO_CARGO
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Quartermaster and the Head of Personnel"
	selection_color = "#7a4f33"
	additional_access = list(ACCESS_ENGINEERING_MAINT, ACCESS_SUPPLY_MAIN, ACCESS_SUPPLY_BAY, ACCESS_SUPPLY_MULEBOT, ACCESS_SUPPLY_MINE, ACCESS_SUPPLY_MINE_OUTPOST)
	minimal_access = list(ACCESS_ENGINEERING_MAINT, ACCESS_SUPPLY_BAY, ACCESS_SUPPLY_MULEBOT, ACCESS_SUPPLY_MAIN)

	outfit_type = /datum/outfit/job/station/cargo_technician
	desc = "A Cargo Technician fills and delivers cargo orders. They are encouraged to return delivered crates to the Cargo Shuttle, \
						because Central Command gives a partial refund."
	alt_titles = list(
		"Logistics Specialist" = /datum/prototype/alt_title/logi_spec,
		"Logisticai-Apprentice" = /datum/prototype/alt_title/logisticai_apprentice,
		"Logisticai" = /datum/prototype/alt_title/logisticai
		)

/datum/prototype/alt_title/logisticai_apprentice
	title = "Logisticai-Apprentice"
	background_allow = list(
		/datum/lore/character_background/faction/naramadiguilds
	)
	background_enforce = TRUE

/datum/prototype/alt_title/logisticai
	title = "Logisticai"
	background_allow = list(
		/datum/lore/character_background/faction/naramadiguilds
	)
	background_enforce = TRUE

/datum/prototype/alt_title/logi_spec
	title = "Logistics Specialist"

/datum/outfit/job/station/cargo_technician
	name = OUTFIT_JOB_NAME("Cargo technician")
	uniform = /obj/item/clothing/under/rank/cargotech
	l_ear = /obj/item/radio/headset/headset_cargo
	id_type = /obj/item/card/id/cargo/cargo_tech
	pda_type = /obj/item/pda/cargo
