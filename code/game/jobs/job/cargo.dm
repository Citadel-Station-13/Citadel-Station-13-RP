//Cargo
//////////////////////////////////
//			Quartermaster
//////////////////////////////////
/datum/job/qm
	title = "Quartermaster"
	flag = QUARTERMASTER
	departments = list(DEPARTMENT_CARGO)
	sorting_order = 1 // QM is above the cargo techs, but below the HoP.
	departments_managed = list(DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	faction = "Station"
	pto_type = PTO_CARGO
	total_positions = 1
	spawn_positions = 1
	idtype = /obj/item/card/id/cargo/head
	supervisors = "the Head of Personnel"
	selection_color = "#9b633e"
	economic_power = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)

	ideal_character_age = 40

	outfit_type = /decl/hierarchy/outfit/job/cargo/qm
	job_description = "The Quartermaster manages the Supply department, checking cargo orders and ensuring supplies get to where they are needed."
	alt_titles = list("Supply Chief" = /datum/alt_title/supply_chief)

// Quartermaster Alt Titles
/datum/alt_title/supply_chief
	title = "Supply Chief"

//////////////////////////////////
//			Cargo Tech
//////////////////////////////////
/datum/job/cargo_tech
	title = "Cargo Technician"
	flag = CARGOTECH
	departments = list(DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	pto_type = PTO_CARGO
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Quartermaster and the Head of Personnel"
	selection_color = "#7a4f33"
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mailsorting)

	outfit_type = /decl/hierarchy/outfit/job/cargo/cargo_tech
	job_description = "A Cargo Technician fills and delivers cargo orders. They are encouraged to return delivered crates to the Cargo Shuttle, \
						because Central Command gives a partial refund."
	alt_titles = list("Logistics Specialist" = /datum/alt_title/logi_spec)

// Cargo Technician Alt Titles
/datum/alt_title/logi_spec
	title = "Logistics Specialist"

//////////////////////////////////
//			Shaft Miner
//////////////////////////////////

/datum/job/mining
	title = "Shaft Miner"
	flag = MINER
	departments = list(DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	faction = "Station"
	pto_type = PTO_CARGO
	idtype = /obj/item/card/id/cargo/mining
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Quartermaster and the Head of Personnel"
	selection_color = "#7a4f33"
	economic_power = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting, access_cargo, access_cargo_bot)

	outfit_type = /decl/hierarchy/outfit/job/cargo/mining
	job_description = "A Shaft Miner mines and processes minerals to be delivered to departments that need them."
	alt_titles = list(
		"Drill Technician" = /datum/alt_title/drill_tech,
		"Belt Miner" = /datum/alt_title/miner/belt
		)

/datum/alt_title/drill_tech
	title = "Drill Technician"
	title_blurb = "A Drill Technician specializes in operating and maintaining the machinery needed to extract ore from veins deep below the surface."

/datum/alt_title/miner/belt
	title = "Belt Miner"
