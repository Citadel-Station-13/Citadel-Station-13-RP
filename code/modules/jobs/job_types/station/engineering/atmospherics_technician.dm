/datum/job/station/atmos
	title = "Atmospheric Technician"
	flag = ATMOSTECH
	departments = list(DEPARTMENT_ENGINEERING)
	department_flag = ENGSEC
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Chief Engineer"
	selection_color = "#5B4D20"
	idtype = /obj/item/card/id/engineering/atmos
	economic_modifier = 5
	pto_type = PTO_ENGINEERING

	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics, access_external_airlocks)
	minimal_access = list(access_eva, access_engine, access_atmospherics, access_maint_tunnels, access_emergency_storage, access_construction, access_external_airlocks)

	minimal_player_age = 3

	outfit_type = /datum/outfit/job/station/atmospherics_technician
	desc = "An Atmospheric Technician is primarily concerned with keeping the station's atmosphere breathable. They are expected to have a good \
						understanding of the pipes, vents, and scrubbers that move gasses around the station, and to be familiar with proper firefighting procedure."

	alt_titles = list(
		"Atmospherics Maintainer" = /datum/alt_title/atmos_maint,
		"Pipe Network Specialist" = /datum/alt_title/pipe_spec,
		"Disposals Technician" = /datum/alt_title/disposals_tech
		)

// Atmos Tech Alt Titles
/datum/alt_title/atmos_maint
	title = "Atmospherics Maintainer"

/datum/alt_title/pipe_spec
	title = "Pipe Network Specialist"

/datum/alt_title/disposals_tech
	title = "Disposals Technician"
	title_blurb = "A Disposals Technician is an Atmospheric Technician still and can fulfill all the same duties, although specializes more in disposals delivery system's operations and configurations."

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
