var/const/SAR 				=(1<<11)
var/const/PILOT 			=(1<<15)
var/const/EXPLORER 			=(1<<12)
var/const/PATHFINDER 		=(1<<13)

/obj/item/weapon/card/id/science/head/pathfinder
	name = "\improper Pathfinder's ID"
	desc = "A card which represents discovery of the unknown."
	icon_state = "greenGold"
	primary_color = rgb(47,189,0)
	secondary_color = rgb(127,223,95)

/obj/item/weapon/card/id/explorer/head/pathfinder
	assignment = "Pathfinder"
	rank = "Pathfinder"
	job_access_type = /datum/job/pathfinder

/datum/job/pathfinder
	title = "Pathfinder"
	flag = PATHFINDER
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the research director"
	selection_color = "#AD6BAD"
	idtype = /obj/item/weapon/card/id/explorer/head/pathfinder
	economic_modifier = 7
	minimal_player_age = 7

	access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_research, access_gateway)
	minimal_access = list(access_eva, access_pilot, access_explorer, access_research, access_gateway)
	outfit_type = /decl/hierarchy/outfit/job/pathfinder

/datum/job/pilot
	title = "Pilot"
	flag = PILOT
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the pathfinder and the head of personnel"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/explorer/pilot
	economic_modifier = 5
	minimal_player_age = 3
	access = list(access_pilot)
	minimal_access = list(access_pilot)
	outfit_type = /decl/hierarchy/outfit/job/pilot

/datum/job/explorer
	title = "Explorer"
	flag = EXPLORER
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the pathfinder and the research director"
	selection_color = "#633D63"
	idtype = /obj/item/weapon/card/id/explorer/explorer
	economic_modifier = 6
	access = list(access_explorer, access_research)
	minimal_access = list(access_explorer, access_research)
	outfit_type = /decl/hierarchy/outfit/job/explorer2

/datum/job/sar
	title = "Field Medic"
	flag = SAR
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the pathfinder and the chief medical officer"
	selection_color = "#013D3B"
	idtype = /obj/item/weapon/card/id/medical/sar
	economic_modifier = 6
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/medical/sar
