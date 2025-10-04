/datum/prototype/role/job/station/outsider
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
	offmap_spawn = TRUE
	alt_titles = list(
		"Contractor" = /datum/prototype/struct/alt_title/contractor,
		"Freelancer" = /datum/prototype/struct/alt_title/freelancer,
		"Frontier Colonist" = /datum/prototype/struct/alt_title/colonist,
		"Tourist" = /datum/prototype/struct/alt_title/tourist,
		"NT Vacationer" = /datum/prototype/struct/alt_title/vacationer,
		"Independant Reporter" = /datum/prototype/struct/alt_title/indyreport
	)

/datum/outfit/job/station/outsider
	name = OUTFIT_JOB_NAME("outsider")
	id_type = /obj/item/card/id/assistant
	l_ear = /obj/item/radio/headset/trader/outsider
	shoes = /obj/item/clothing/shoes/black
	uniform = /obj/item/clothing/under/laconic
	suit = /obj/item/clothing/suit/storage/tajaran/jacket
	gloves = /obj/item/clothing/gloves/fingerless
	id_slot = SLOT_ID_WORN_ID
	pda_slot = SLOT_ID_BELT
	pda_type = /obj/item/pda
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL
	backpack_contents = list(/obj/item/spacecash/c200 = 2)

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

/datum/prototype/struct/alt_title/vacationer
	title = "NT Vacationer"
	title_outfit = /datum/outfit/job/station/outsider/vacationer
	title_blurb = "You are a off-duty NT employee. While you enjoy the benefits of being vacationning outside the station, base, ship, you are off-duty and can't return on duty unless something grave happends."

/datum/prototype/struct/alt_title/indyreport
	title = "Independant Reporter"
	title_outfit = /datum/outfit/job/station/outsider/indyreport
	title_blurb = "You are a tourist, visiting the sector."

/datum/outfit/job/station/outsider/contractor
	id_pda_assignment = "Contractor"

/datum/outfit/job/station/outsider/freelancer
	id_pda_assignment = "Freelancer"

/datum/outfit/job/station/outsider/colonist
	id_pda_assignment = "Colonist"

/datum/outfit/job/station/outsider/tourist
	id_pda_assignment = "Tourist"

/datum/outfit/job/station/outsider/vacationer
	id_pda_assignment = "NT Vacationer"

/datum/outfit/job/station/outsider/indyreport
	name = OUTFIT_JOB_NAME("Independant Reporter")
	uniform = /obj/item/clothing/under/suit_jacket/red
	id_type = /obj/item/card/id/assistant
	pda_type = /obj/item/pda/librarian
	belt = /obj/item/camera
	backpack_contents = list(/obj/item/clothing/accessory/badge/corporate_tag/press = 1,
							/obj/item/tape_recorder = 1,
							/obj/item/camera_film = 1
							)
