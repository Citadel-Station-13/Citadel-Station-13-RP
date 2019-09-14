var/const/PATHFINDER 		=(1<<13) //VOREStation Edit - Added Pathfinder

var/const/access_pathfinder = 44

/datum/access/pathfinder
	id = access_pathfinder
	desc = "Pathfinder"
	region = ACCESS_REGION_GENERAL

/obj/item/weapon/card/id/science/head/pathfinder
	name = "\improper Pathfinder's ID"
	desc = "A card which represents discovery of the unknown."
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
	idtype = /obj/item/weapon/card/id/science/head/pathfinder
	economic_modifier = 7
	minimal_player_age = 7

	access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_pathfinder, access_tox, access_research, access_gateway)
	minimal_access = list(access_eva, access_pilot, access_explorer, access_pathfinder, access_tox, access_research, access_gateway)
	outfit_type = /decl/hierarchy/outfit/job/pathfinder
