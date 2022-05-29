/datum/job/station/chef
	title = "Chef"
	flag = CHEF
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	pto_type = PTO_CIVILIAN
	idtype = /obj/item/card/id/civilian/chef
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_kitchen)

	outfit_type = /datum/outfit/job/station/chef
	desc = "A Chef cooks food for the crew. They generally have permission to charge for food or deny service to unruly diners."
	alt_titles = list(
		"Cook" = /datum/alt_title/chef/cook,
		"Sous-chef" = /datum/alt_title/chef/souschef,
		"Kitchen Worker" = /datum/alt_title/chef/kitchen_worker,
		"Line Cook" = /datum/alt_title/chef/line
	)

/datum/alt_title/chef/souschef
	title = "Sous-chef"

/datum/alt_title/chef/kitchen_worker
	title = "Kitchen Worker"
	title_blurb = "A Kitchen Worker has the same duties, though they may be less experienced."

/datum/alt_title/chef/line
	title = "Line Cook"

// Chef Alt Titles
/datum/alt_title/chef/cook
	title = "Cook"
	title_blurb = "A Cook has the same duties, though they may be less experienced."

/datum/outfit/job/station/chef
	name = OUTFIT_JOB_NAME("Chef")
	uniform = /obj/item/clothing/under/rank/chef
	suit = /obj/item/clothing/suit/chef
	head = /obj/item/clothing/head/chefhat
	id_type = /obj/item/card/id/civilian/chef
	pda_type = /obj/item/pda/chef
	l_ear = /obj/item/radio/headset/headset_service

/datum/outfit/job/station/chef/cook
	name = OUTFIT_JOB_NAME("Cook")
	id_pda_assignment = "Cook"
