/datum/job/station/mining
	title = "Shaft Miner"
	flag = MINER
	departments = list(DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	pto_type = PTO_CARGO
	idtype = /obj/item/card/id/cargo/mining
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Quartermaster and the Head of Personnel"
	selection_color = "#7a4f33"
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting, access_cargo, access_cargo_bot)

	outfit_type = /datum/outfit/job/station/shaft_miner
	desc = "A Shaft Miner mines and processes minerals to be delivered to departments that need them."
	alt_titles = list(
		"Drill Technician" = /datum/alt_title/drill_tech,
		"Belt Miner" = /datum/alt_title/miner/belt
		)

/datum/alt_title/drill_tech
	title = "Drill Technician"
	title_blurb = "A Drill Technician specializes in operating and maintaining the machinery needed to extract ore from veins deep below the surface."

/datum/alt_title/miner/belt
	title = "Belt Miner"

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
