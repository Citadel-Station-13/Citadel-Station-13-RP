/datum/role/job/station/engineer
	id = JOB_ID_STATION_ENGINEER
	title = "Station Engineer"
	flag = ENGINEER
	departments = list(DEPARTMENT_ENGINEERING)
	department_flag = ENGSEC
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Chief Engineer"
	selection_color = "#5B4D20"
	idtype = /obj/item/card/id/engineering/engineer
	pto_type = PTO_ENGINEERING

	additional_access = list(ACCESS_COMMAND_EVA, ACCESS_ENGINEERING_MAIN, ACCESS_ENGINEERING_ENGINE, ACCESS_ENGINEERING_TECHSTORAGE, ACCESS_ENGINEERING_MAINT, ACCESS_ENGINEERING_AIRLOCK, ACCESS_ENGINEERING_CONSTRUCTION, ACCESS_ENGINEERING_ATMOS)
	minimal_access = list(ACCESS_COMMAND_EVA, ACCESS_ENGINEERING_MAIN, ACCESS_ENGINEERING_ENGINE, ACCESS_ENGINEERING_TECHSTORAGE, ACCESS_ENGINEERING_MAINT, ACCESS_ENGINEERING_AIRLOCK, ACCESS_ENGINEERING_CONSTRUCTION)

	alt_titles = list(
		"Maintenance Technician" = /datum/prototype/alt_title/maint_tech,
		"Engine Technician" = /datum/prototype/alt_title/engine_tech,
		"Electrician" = /datum/prototype/alt_title/electrician,
		"Apprentice Engineer" = /datum/prototype/alt_title/apprentice_engineer,
		"Construction Engineer" = /datum/prototype/alt_title/construction_engi,
		"Artificer-Apprentice" = /datum/prototype/alt_title/artificer_apprentice,
		"Artificer" = /datum/prototype/alt_title/artificer
		)

	minimal_player_age = 3

	outfit_type = /datum/outfit/job/station/station_engineer
	desc = "An Engineer keeps the station running. They repair damages, keep the atmosphere stable, and ensure that power is being \
						generated and distributed. On quiet shifts, they may be called upon to make cosmetic alterations to the station."
/datum/prototype/alt_title/maint_tech
	title = "Maintenance Technician"
	title_blurb = "A Maintenance Technician is generally a junior Engineer, and can be expected to run the mildly unpleasant or boring tasks that other \
					Engineers don't care to do."

/datum/prototype/alt_title/engine_tech
	title = "Engine Technician"
	title_blurb = "An Engine Technician tends to the engine, most commonly a Supermatter crystal. They are expected to be able to keep it stable, and \
					possibly even run it beyond normal tolerances."

/datum/prototype/alt_title/electrician
	title = "Electrician"
	title_blurb = "An Electrician's primary duty is making sure power is properly distributed thoughout the station, utilizing solars, substations, and other \
					methods to ensure every department has power in an emergency."

/datum/prototype/alt_title/apprentice_engineer
	title = "Apprentice Engineer"

/datum/prototype/alt_title/construction_engi
	title = "Construction Engineer"
	title_blurb = "A Construction Engineer fulfills similar duties to other engineers, but usually occupies spare time with construction of extra facilities in dedicated areas or \
					as additions to station layout."

/datum/prototype/alt_title/artificer_apprentice
	title = "Artificer-Apprentice"
	background_allow = list(
		/datum/lore/character_background/faction/naramadiguilds
	)
	background_enforce = TRUE

/datum/prototype/alt_title/artificer
	title = "Artificer"
	background_allow = list(
		/datum/lore/character_background/faction/naramadiguilds
	)
	background_enforce = TRUE

/datum/outfit/job/station/station_engineer
	name = OUTFIT_JOB_NAME("Engineer")
	head = /obj/item/clothing/head/hardhat
	uniform = /obj/item/clothing/under/rank/engineer
	id_type = /obj/item/card/id/engineering/engineer
	pda_type = /obj/item/pda/engineering
	l_ear = /obj/item/radio/headset/headset_eng
	belt = /obj/item/storage/belt/utility/atmostech
	belt = /obj/item/storage/belt/utility/full
	shoes = /obj/item/clothing/shoes/boots/workboots
	r_pocket = /obj/item/t_scanner

	id_type = /obj/item/card/id/engineering/atmos
	pda_type = /obj/item/pda/atmos

	backpack = /obj/item/storage/backpack/industrial
	satchel_one = /obj/item/storage/backpack/satchel/eng
	messenger_bag = /obj/item/storage/backpack/messenger/engi
	pda_slot = SLOT_ID_LEFT_POCKET
	dufflebag = /obj/item/storage/backpack/dufflebag/eng

	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
