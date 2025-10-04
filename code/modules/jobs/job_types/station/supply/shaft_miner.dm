/datum/prototype/role/job/station/mining
	id = JOB_ID_SHAFT_MINER
	title = "Shaft Miner"
	flag = MINER
	economy_payscale = ECONOMY_PAYSCALE_JOB_DANGER
	departments = list(DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	pto_type = PTO_CARGO
	idtype = /obj/item/card/id/cargo/mining
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Quartermaster and the Head of Personnel"
	selection_color = "#7a4f33"
	additional_access = list(
		ACCESS_ENGINEERING_MAINT,
	)
	minimal_access = list(
		ACCESS_SUPPLY_MINE,
		ACCESS_SUPPLY_MINE_OUTPOST,
		ACCESS_SUPPLY_MAIN,
		ACCESS_SUPPLY_BAY,
		ACCESS_SUPPLY_MULEBOT,
	)

	outfit_type = /datum/outfit/job/station/shaft_miner
	desc = "A Shaft Miner mines and processes minerals to be delivered to departments that need them."
	alt_titles = list(
		"Drill Technician" = /datum/prototype/struct/alt_title/miner/drill_tech,
		"Belt Miner" = /datum/prototype/struct/alt_title/miner/belt,
		"Salvage Technician" = /datum/prototype/struct/alt_title/salvage,
		"Apprentice Miner" = /datum/prototype/struct/alt_title/miner/apprenticemine,
		"Apprentice Salvager" = /datum/prototype/struct/alt_title/miner/apprenticesalv
		)

/datum/prototype/struct/alt_title/miner
	abstract_type = /datum/prototype/struct/alt_title/miner

/datum/prototype/struct/alt_title/miner/drill_tech
	title = "Drill Technician"
	title_blurb = "A Drill Technician specializes in operating and maintaining the machinery needed to extract ore from veins deep below the surface."

/datum/prototype/struct/alt_title/miner/belt
	title = "Belt Miner"

/datum/prototype/struct/alt_title/miner/apprenticemine
	title = "Apprentice Miner"
	title_blurb = "An Apprentice Miner is still learning about the typical grind of a miner, and should seek the guidance of other miners and salvagers for direction."

/datum/prototype/struct/alt_title/miner/apprenticesalv
	title = "Apprentice Salvager"
	title_blurb = "An Apprentice Salvager is still learning about the typical grind of a salvager, and should seek the guidance of other miners and salvagers for direction."

/datum/prototype/struct/alt_title/salvage
	title = "Salvage Technician"
	title_blurb = "A Salvage Technician specialized in traveling to wrecks and stripping them of useful items and materials."

/datum/outfit/job/station/shaft_miner
	name = OUTFIT_JOB_NAME("Shaft Miner")
	uniform = /obj/item/clothing/under/rank/miner
	l_ear = /obj/item/radio/headset/headset_mine
	backpack = /obj/item/storage/backpack/industrial
	satchel_one  = /obj/item/storage/backpack/satchel/eng
	id_type = /obj/item/card/id/cargo/mining
	pda_type = /obj/item/pda/shaftminer
	backpack_contents = list(/obj/item/tool/crowbar = 1, /obj/item/storage/bag/ore = 1)
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
