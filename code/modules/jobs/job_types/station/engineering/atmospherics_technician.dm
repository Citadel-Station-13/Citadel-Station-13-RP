/datum/role/job/station/atmos
	id = JOB_ID_ATMOSPHERIC_TECHNICIAN
	title = "Atmospheric Technician"
	flag = ATMOSTECH
	departments = list(DEPARTMENT_ENGINEERING)
	department_flag = ENGSEC
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Chief Engineer"
	selection_color = "#5B4D20"
	idtype = /obj/item/card/id/engineering/atmos
	pto_type = PTO_ENGINEERING

	additional_access = list(ACCESS_COMMAND_EVA, ACCESS_ENGINEERING_MAIN, ACCESS_ENGINEERING_ENGINE, ACCESS_ENGINEERING_TECHSTORAGE, ACCESS_ENGINEERING_MAINT, ACCESS_ENGINEERING_AIRLOCK, ACCESS_ENGINEERING_CONSTRUCTION, ACCESS_ENGINEERING_ATMOS, ACCESS_ENGINEERING_AIRLOCK)
	minimal_access = list(ACCESS_COMMAND_EVA, ACCESS_ENGINEERING_MAIN, ACCESS_ENGINEERING_ATMOS, ACCESS_ENGINEERING_MAINT, ACCESS_ENGINEERING_TRIAGE, ACCESS_ENGINEERING_CONSTRUCTION, ACCESS_ENGINEERING_AIRLOCK)

	minimal_player_age = 3

	outfit_type = /datum/outfit/job/station/atmospherics_technician
	desc = "An Atmospheric Technician is primarily concerned with keeping the station's atmosphere breathable. They are expected to have a good \
						understanding of the pipes, vents, and scrubbers that move gasses around the station, and to be familiar with proper firefighting procedure."

	alt_titles = list(
		"Atmospherics Maintainer" = /datum/prototype/alt_title/atmos_maint,
		"Pipe Network Specialist" = /datum/prototype/alt_title/pipe_spec,
		"Disposals Technician" = /datum/prototype/alt_title/disposals_tech,
		"Artificer" = /datum/prototype/alt_title/atmos_artificer
		)

// Atmos Tech Alt Titles
/datum/prototype/alt_title/atmos_maint
	title = "Atmospherics Maintainer"

/datum/prototype/alt_title/pipe_spec
	title = "Pipe Network Specialist"

/datum/prototype/alt_title/disposals_tech
	title = "Disposals Technician"
	title_blurb = "A Disposals Technician is an Atmospheric Technician still and can fulfill all the same duties, although specializes more in disposals delivery system's operations and configurations."

/datum/prototype/alt_title/atmos_artificer
	title = "Artificer"
	background_allow = list(
		/datum/lore/character_background/faction/naramadiguilds
	)
	background_enforce = TRUE

/datum/outfit/job/station/atmospherics_technician
	name = OUTFIT_JOB_NAME("Atmospheric technician")
	uniform = /obj/item/clothing/under/rank/atmospheric_technician
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
