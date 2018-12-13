var/const/PATHFINDER 		=(1<<13) //VOREStation Edit - Added Pathfinder

<<<<<<< HEAD
/obj/item/weapon/card/id/science/head/pathfinder
=======
/obj/item/weapon/card/id/medical/sar
	assignment = "Field Medic"
	rank = "Field Medic"
	icon_state = "cyan"
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)
	job_access_type = /datum/job/sar

/obj/item/weapon/card/id/explorer
	name = "identification card"
	desc = "A card issued to station exploration staff."
	icon_state = "green"
	primary_color = rgb(47,189,0)
	secondary_color = rgb(127,223,95)

/obj/item/weapon/card/id/explorer/pilot
	assignment = "Pilot"
	rank = "Pilot"
	job_access_type = /datum/job/pilot

/obj/item/weapon/card/id/explorer/explorer
	assignment = "Explorer"
	rank = "Explorer"
	job_access_type = /datum/job/explorer

/obj/item/weapon/card/id/explorer/head/
	name = "identification card"
>>>>>>> 56dbc1a... Merge pull request #4572 from Novacat/nova-heterochromia
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
	
	access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_research, access_gateway)
	minimal_access = list(access_eva, access_pilot, access_explorer, access_research, access_gateway)
	outfit_type = /decl/hierarchy/outfit/job/pathfinder
