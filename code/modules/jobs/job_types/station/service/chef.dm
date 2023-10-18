/datum/role/job/station/chef
	id = JOB_ID_CHEF
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
	additional_access = list(
		ACCESS_GENERAL_BOTANY,
		ACCESS_GENERAL_BAR,
	)
	minimal_access = list(
		ACCESS_GENERAL_KITCHEN,
	)

	outfit_type = /datum/outfit/job/station/chef
	desc = "A Chef cooks food for the crew. They generally have permission to charge for food or deny service to unruly diners."
	alt_titles = list(
		"Cook" = /datum/prototype/struct/alt_title/chef/cook,
		"Sous-chef" = /datum/prototype/struct/alt_title/chef/souschef,
		"Kitchen Worker" = /datum/prototype/struct/alt_title/chef/kitchen_worker,
		"Line Cook" = /datum/prototype/struct/alt_title/chef/line
	)

/datum/prototype/struct/alt_title/chef/souschef
	title = "Sous-chef"

/datum/prototype/struct/alt_title/chef/kitchen_worker
	title = "Kitchen Worker"
	title_blurb = "A Kitchen Worker has the same duties, though they may be less experienced."

/datum/prototype/struct/alt_title/chef/line
	title = "Line Cook"

// Chef Alt Titles
/datum/prototype/struct/alt_title/chef/cook
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
