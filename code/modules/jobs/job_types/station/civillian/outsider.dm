/datum/role/job/station/outsider
	id = JOB_ID_OUTSIDER
	title = "Traveler"
	flag = OUTSIDER
	departments = list(DEPARTMENT_CIVILIAN)
	sorting_order = -1
	department_flag = CIVILIAN
	total_positions = -1
	spawn_positions = -1
	desc = "You are in the sector for various reason, may it be visiting or simply exploring. You start on the Nebula Gas Station, and can use the services here. (This is not a antag role)"
	supervisors = "Nobody !"
	selection_color = "#515151"
	outfit_type = /datum/outfit/job/station/outsider
	alt_titles = list(
		"Contractor" = /datum/prototype/struct/alt_title/contractor,
		"Freelancer" = /datum/prototype/struct/alt_title/freelancer,
		"Frontier Colonist" = /datum/prototype/struct/alt_title/colonist,
		"Tourist" = /datum/prototype/struct/alt_title/tourist
	)

/datum/outfit/job/station/outsider
	name = OUTFIT_JOB_NAME(USELESS_JOB)
	id_type = /obj/item/card/id/assistant

/datum/prototype/struct/alt_title/contractor
	title = "Contractor"
	title_outfit = /datum/outfit/job/station/outsider/contractor
	title_blurb = "You are a independant contractor, working for a faction."

/datum/prototype/struct/alt_title/freelancer
	title = "Freelancer"
	title_outfit = /datum/outfit/job/station/outsider/freelancer
	title_blurb = "You are a independant freelancer."

/datum/prototype/struct/alt_title/colonist
	title = "Frontier Colonist"
	title_outfit = /datum/outfit/job/station/outsider/colonist
	title_blurb = "You are a colonist in the frontier! Make yourself a home on any place in the sector."

/datum/prototype/struct/alt_title/tourist
	title = "Tourist"
	title_outfit = /datum/outfit/job/station/outsider/tourist
	title_blurb = "You are a tourist, visiting the sector."

/datum/outfit/job/station/outsider/contractor
	id_pda_assignment = "Contractor"

/datum/outfit/job/station/outsider/freelancer
	id_pda_assignment = "Freelancer"

/datum/outfit/job/station/outsider/colonist
	id_pda_assignment = "Colonist"

/datum/outfit/job/station/outsider/tourist
	id_pda_assignment = "Tourist"
