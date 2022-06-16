/datum/job/station/engineer
	title = "Station Engineer"
	flag = ENGINEER
	departments = list(DEPARTMENT_ENGINEERING)
	department_flag = ENGSEC
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Chief Engineer"
	selection_color = "#5B4D20"
	idtype = /obj/item/card/id/engineering/engineer
	economic_modifier = 5
	pto_type = PTO_ENGINEERING

	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics)
	minimal_access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction)

	alt_titles = list(
		"Maintenance Technician" = /datum/alt_title/maint_tech,
		"Engine Technician" = /datum/alt_title/engine_tech,
		"Electrician" = /datum/alt_title/electrician,
		"Apprentice Engineer" = /datum/alt_title/apprentice_engineer,
		"Construction Engineer" = /datum/alt_title/construction_engi
		)

	minimal_player_age = 3

	outfit_type = /datum/outfit/job/station/station_engineer
	desc = "An Engineer keeps the station running. They repair damages, keep the atmosphere stable, and ensure that power is being \
						generated and distributed. On quiet shifts, they may be called upon to make cosmetic alterations to the station."
/datum/alt_title/maint_tech
	title = "Maintenance Technician"
	title_blurb = "A Maintenance Technician is generally a junior Engineer, and can be expected to run the mildly unpleasant or boring tasks that other \
					Engineers don't care to do."

/datum/alt_title/engine_tech
	title = "Engine Technician"
	title_blurb = "An Engine Technician tends to the engine, most commonly a Supermatter crystal. They are expected to be able to keep it stable, and \
					possibly even run it beyond normal tolerances."

/datum/alt_title/electrician
	title = "Electrician"
	title_blurb = "An Electrician's primary duty is making sure power is properly distributed thoughout the station, utilizing solars, substations, and other \
					methods to ensure every department has power in an emergency."

/datum/alt_title/apprentice_engineer
	title = "Apprentice Engineer"

/datum/alt_title/construction_engi
	title = "Construction Engineer"
	title_blurb = "A Construction Engineer fulfills similar duties to other engineers, but usually occupies spare time with construction of extra facilities in dedicated areas or \
					as additions to station layout."

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
	pda_slot = slot_l_store

	backpack = /obj/item/storage/backpack/industrial
	satchel_one = /obj/item/storage/backpack/satchel/eng
	messenger_bag = /obj/item/storage/backpack/messenger/engi
	dufflebag = /obj/item/storage/backpack/dufflebag/eng

	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
