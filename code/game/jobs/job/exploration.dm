/obj/item/card/id/medical/sar
	assignment = "Field Medic"
	rank = "Field Medic"
	icon_state = "cyan"
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)
	job_access_type = /datum/job/sar

/obj/item/card/id/explorer
	name = "identification card"
	desc = "A card issued to station exploration staff."
	icon_state = "cyan"
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)

/obj/item/card/id/explorer/pilot
	assignment = "Pilot"
	rank = "Pilot"
	job_access_type = /datum/job/pilot

/obj/item/card/id/explorer/explorer
	assignment = "Explorer"
	rank = "Explorer"
	job_access_type = /datum/job/explorer

/obj/item/card/id/explorer/head
	name = "identification card"
	desc = "A card which represents discovery of the unknown."
	icon_state = "cyanGold"
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)

/obj/item/card/id/explorer/head/pathfinder
	assignment = "Pathfinder"
	rank = "Pathfinder"
	job_access_type = /datum/job/pathfinder

/datum/job/pathfinder
	title = "Pathfinder"
	flag = PATHFINDER
	departments = list(DEPARTMENT_PLANET)
	departments_managed = list(DEPARTMENT_PLANET)
	sorting_order = 1 // above the other explorers
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the facility director"
	selection_color = "#d6d05c"
	idtype = /obj/item/card/id/explorer/head/pathfinder
	economic_modifier = 7
	minimal_player_age = 7
	alt_titles = list("Expedition Leader", "Lead Pioneer", "Exploration Chief")
	pto_type = PTO_EXPLORATION
	dept_time_required = 20

	access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_research, access_gateway, access_pathfinder)
	minimal_access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_research, access_gateway, access_pathfinder)
	outfit_type = /decl/hierarchy/outfit/job/pathfinder

/datum/job/pilot
	title = "Pilot"
	flag = PILOT
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 4
	spawn_positions = 2
	supervisors = "the pathfinder and the head of personnel"
	idtype = /obj/item/card/id/explorer/pilot
	selection_color = "#515151"
	economic_modifier = 5
	minimal_player_age = 3
	alt_titles = list("Aviator")
	access = list(access_pilot, access_external_airlocks)
	minimal_access = list(access_pilot, access_external_airlocks)
	pto_type = PTO_EXPLORATION
	outfit_type = /decl/hierarchy/outfit/job/pilot

/datum/alt_title/co_pilot
	title = "Co-Pilot"
	title_blurb = "A Co-Pilot is there primarily to assist main pilot as well as learn from them"

/datum/alt_title/navigator
	title = "Navigator"


/datum/job/explorer
	title = "Explorer"
	flag = EXPLORER
	departments = list(DEPARTMENT_PLANET)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the pathfinder and the research director"
	selection_color = "#999440"
	idtype = /obj/item/card/id/explorer/explorer
	economic_modifier = 6
	alt_titles = list("Field Scout", "Pioneer", "Jr. Explorer")
	access = list(access_explorer, access_external_airlocks, access_research, access_pilot, access_gateway)
	minimal_access = list(access_explorer, access_external_airlocks, access_research, access_pilot, access_gateway)
	outfit_type = /decl/hierarchy/outfit/job/explorer2

/datum/alt_title/surveyor
	title = "Surveyor"

/datum/alt_title/offsite_scout
	title = "Offsite Scout"


/datum/job/sar
	title = "Field Medic"
	flag = SAR
	departments = list(DEPARTMENT_PLANET, DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Pathfinder and the Chief Medical Officer"
	selection_color = "#999440"
	idtype = /obj/item/card/id/medical/sar
	economic_modifier = 6
	minimal_player_age = 3
	alt_titles = list("Search and Rescue")
	access = list(access_medical, access_eva, access_maint_tunnels, access_external_airlocks, access_explorer, access_morgue, access_chemistry)
	minimal_access = list(access_medical, access_explorer, access_morgue, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/medical/sar

/datum/job/offduty_exploration
	title = "Off-duty Explorer"
	latejoin_only = TRUE
	timeoff_factor = -1
	total_positions = -1
	faction = "Station"
	department = "Exploration"
	supervisors = "nobody! Enjoy your time off"
	selection_color = "#999440"
	access = list(access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/assistant/explorer
