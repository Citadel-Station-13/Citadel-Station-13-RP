//Food

//////////////////////////////////
//			Bartender
//////////////////////////////////

/datum/job/bartender
	title = "Bartender"
	flag = BARTENDER
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	idtype = /obj/item/card/id/civilian/bartender
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_bar)

	outfit_type = /decl/hierarchy/outfit/job/service/bartender
	job_description = "A Bartender mixes drinks for the crew. They generally have permission to charge for drinks or deny service to unruly patrons."
	alt_titles = list("Barista" = /datum/alt_title/barista)

// Bartender Alt Titles
/datum/alt_title/barista
	title = "Barista"
	title_blurb = "A barista mans the Cafe, serving primarily non-alcoholic drinks to the crew. They generally have permission to charge for drinks \
					or deny service to unruly patrons."
	title_outfit = /decl/hierarchy/outfit/job/service/bartender/barista

//////////////////////////////////
//			   Chef
//////////////////////////////////

/datum/job/chef
	title = "Chef"
	flag = CHEF
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	idtype = /obj/item/card/id/civilian/chef
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_kitchen)

	outfit_type = /decl/hierarchy/outfit/job/service/chef
	alt_titles = list("Cook","Line Cook")

/datum/job/hydro
	title = "Botanist"
	flag = BOTANIST
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	idtype = /obj/item/card/id/civilian/botanist
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_hydroponics)

	outfit_type = /decl/hierarchy/outfit/job/service/gardener
	job_description = "A Botanist grows plants for the Chef and Bartender."
	alt_titles = list("Gardener" = /datum/alt_title/gardener)

//Botanist Alt Titles
/datum/alt_title/gardener
	title = "Gardener"
	title_blurb = "A Gardener may be less professional than their counterparts, and are more likely to tend to the public gardens if they aren't needed elsewhere."

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
	total_positions = 1
	spawn_positions = 1
	idtype = /obj/item/card/id/cargo/head
	supervisors = "the Head of Personnel"
	selection_color = "#9b633e"
	economic_modifier = 5
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
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Quartermaster and the Head of Personnel"
	selection_color = "#7a4f33"
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mailsorting)

	outfit_type = /decl/hierarchy/outfit/job/cargo/cargo_tech
	alt_titles = list("Logistics Specialist", "Jr. Cargo Tech")

//////////////////////////////////
//			Shaft Miner
//////////////////////////////////

/datum/job/mining
	title = "Shaft Miner"
	flag = MINER
	departments = list(DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	faction = "Station"
	idtype = /obj/item/card/id/cargo/mining
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Quartermaster and the Head of Personnel"
	selection_color = "#7a4f33"
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting, access_cargo, access_cargo_bot)

	outfit_type = /decl/hierarchy/outfit/job/cargo/mining
	alt_titles = list("Drill Technician","Belt Miner")

//Service
//////////////////////////////////
//			Janitor
//////////////////////////////////
/datum/job/janitor
	title = "Janitor"
	flag = JANITOR
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	idtype = /obj/item/card/id/civilian/janitor
	access = list(access_janitor, access_maint_tunnels)
	minimal_access = list(access_janitor, access_maint_tunnels)

	outfit_type = /decl/hierarchy/outfit/job/service/janitor
	alt_titles = list("Custodian", "Sanitation Technician", "Viscera Cleaner", "Maid")

//More or less assistants
//////////////////////////////////
//			Librarian
//////////////////////////////////
/datum/job/librarian
	title = "Librarian"
	flag = LIBRARIAN
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	idtype = /obj/item/card/id/civilian/librarian
	access = list(access_library, access_maint_tunnels)
	minimal_access = list(access_library)

	outfit_type = /decl/hierarchy/outfit/job/librarian
	job_description = "The Librarian curates the book selection in the Library, so the crew might enjoy it."
	alt_titles = list("Journalist" = /datum/alt_title/journalist, "Writer" = /datum/alt_title/writer)

// Librarian Alt Titles
/datum/alt_title/journalist
	title = "Journalist"
	title_outfit = /decl/hierarchy/outfit/job/librarian/journalist
	title_blurb = "The Journalist uses the Library as a base of operations, from which they can report the news and goings-on on the station with their camera."

/datum/alt_title/writer
	title = "Writer"
	title_blurb = "The Writer uses the Library as a quiet place to write whatever it is they choose to write."

//////////////////////////////////
//		Internal Affairs Agent
//////////////////////////////////

//var/global/lawyer = 0//Checks for another lawyer //This changed clothes on 2nd lawyer, both IA get the same dreds.
/datum/job/lawyer
	title = "Internal Affairs Agent"
	flag = LAWYER
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#515151"
	idtype = /obj/item/card/id/civilian/internal_affairs_agent
	economic_modifier = 7
	access = list(access_lawyer, access_sec_doors, access_maint_tunnels, access_heads)
	minimal_access = list(access_lawyer, access_sec_doors, access_heads)
	minimal_player_age = 7

	outfit_type = /decl/hierarchy/outfit/job/internal_affairs_agent
	alt_titles = list("Regulatory Affairs Agent")
	job_description = "An Internal Affairs Agent makes sure that the crew is following Standard Operating Procedure. They also \
						handle complaints against crew members, and can have issues brought to the attention of Central Command, \
						assuming their paperwork is in order."

/*
/datum/job/lawyer/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(H)
*/
