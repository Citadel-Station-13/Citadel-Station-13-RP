/datum/job/assistant
	title = USELESS_JOB
	flag = ASSISTANT
	departments = list(DEPARTMENT_CIVILIAN)
	sorting_order = -1
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "nobody! You don't work here"
	selection_color = "#515151"
	economic_modifier = 1
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	timeoff_factor = 0

	outfit_type = /datum/outfit/job/assistant
	alt_titles = list(
		"Visitor" = /datum/alt_title/visitor,
		"Server" = /datum/alt_title/server,
		"Morale Officer" = /datum/alt_title/morale_officer,
		"Assistant" = /datum/alt_title/assistant
	)

/datum/job/assistant/get_access()
	if(config_legacy.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()

/datum/job/assistant/New()
	..()
	if(config)
		total_positions = config_legacy.limit_visitors
		spawn_positions = config_legacy.limit_visitors

/datum/job/assistant/get_access()
	return list()

/datum/alt_title/visitor
	title = "Visitor"
	title_outfit = /datum/outfit/job/assistant/visitor

/datum/alt_title/server
	title = "Server"
	title_outfit = /datum/outfit/job/assistant/server

/datum/alt_title/morale_officer
	title = "Morale Officer"

/datum/alt_title/assistant
	title = "Assistant"
	title_outfit = /datum/outfit/job/assistant

/datum/outfit/job/assistant
	name = OUTFIT_JOB_NAME(USELESS_JOB)
	id_type = /obj/item/card/id/assistant

/datum/outfit/job/assistant/cargo
	id_type = /obj/item/card/id/cargo

/datum/outfit/job/assistant/engineer
	id_type = /obj/item/card/id/engineering
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/datum/outfit/job/assistant/intern
	name = OUTFIT_JOB_NAME("Intern")
	id_type = /obj/item/card/id/civilian

/datum/outfit/job/assistant/medic
	id_type = /obj/item/card/id/medical

/datum/outfit/job/assistant/officer
	id_type = /obj/item/card/id/security

/datum/outfit/job/assistant/resident
	name = OUTFIT_JOB_NAME("Resident")
	id_pda_assignment = "Resident"
	uniform = /obj/item/clothing/under/color/white

/datum/outfit/job/assistant/scientist
	id_type = /obj/item/card/id/science

/datum/outfit/job/assistant/visitor
	name = OUTFIT_JOB_NAME("Visitor")
	id_pda_assignment = "Visitor"
	uniform = /obj/item/clothing/under/assistantformal

/datum/outfit/job/assistant/worker
	id_type = /obj/item/card/id/civilian

/datum/outfit/job/assistant/server
	name = OUTFIT_JOB_NAME("Server")
	uniform = /obj/item/clothing/under/waiter
	l_ear = /obj/item/radio/headset/headset_service
