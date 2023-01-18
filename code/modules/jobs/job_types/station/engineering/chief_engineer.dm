/datum/job/station/chief_engineer
	id = JOB_ID_CHIEF_ENGINEER
	title = "Chief Engineer"
	flag = CHIEF
	departments_managed = list(DEPARTMENT_ENGINEERING)
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_COMMAND)
	sorting_order = 2
	department_flag = ENGSEC
	disallow_jobhop = TRUE
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Facility Director"
	selection_color = "#7F6E2C"
	idtype = /obj/item/card/id/engineering/head
	req_admin_notify = 1
	economic_modifier = 10
	pto_type = PTO_ENGINEERING

	minimum_character_age = 25
	ideal_character_age = 50

	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
						access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
						access_heads, access_construction, access_sec_doors,
						access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
						access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
						access_heads, access_construction, access_sec_doors,
						access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload)
	minimal_player_age = 7
	alt_titles = list(
		"Head Engineer" = /datum/alt_title/head_engineer,
		"Maintenance Manager" = /datum/alt_title/maintenance_manager,
		"Engineering Director" = /datum/alt_title/engineering_director
		)

	outfit_type = /datum/outfit/job/station/chief_engineer
	desc = "The Chief Engineer manages the Engineering Department, ensuring that the Engineers work on what needs to be done, handling distribution \
						of manpower as much as they handle hands-on operations and repairs. They are also expected to keep the rest of the station informed of \
						any structural threats to the station that may be hazardous to health or disruptive to work."

/datum/alt_title/engineering_director
	title = "Engineering Director"

/datum/alt_title/head_engineer
	title = "Head Engineer"

/datum/alt_title/maintenance_manager
	title = "Maintenance Manager"

/datum/outfit/job/station/chief_engineer
	name = OUTFIT_JOB_NAME("Chief engineer")
	head = /obj/item/clothing/head/hardhat/white
	uniform = /obj/item/clothing/under/rank/chief_engineer
	l_ear = /obj/item/radio/headset/heads/ce
	gloves = /obj/item/clothing/gloves/black
	belt = /obj/item/storage/belt/utility/full
	shoes = /obj/item/clothing/shoes/boots/workboots
	r_pocket = /obj/item/t_scanner

	id_type = /obj/item/card/id/engineering/head
	pda_type = /obj/item/pda/heads/ce

	backpack = /obj/item/storage/backpack/industrial
	satchel_one = /obj/item/storage/backpack/satchel/eng
	messenger_bag = /obj/item/storage/backpack/messenger/engi
	pda_slot = SLOT_ID_LEFT_POCKET
	dufflebag = /obj/item/storage/backpack/dufflebag/eng
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
