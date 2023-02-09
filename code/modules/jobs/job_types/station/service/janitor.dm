/datum/role/job/station/janitor
	id = JOB_ID_JANITOR
	title = "Janitor"
	flag = JANITOR
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	total_positions = 2
	spawn_positions = 2
	pto_type = PTO_CIVILIAN
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	idtype = /obj/item/card/id/civilian/janitor
	additional_access = list(ACCESS_GENERAL_JANITOR, ACCESS_ENGINEERING_MAINT)
	minimal_access = list(ACCESS_GENERAL_JANITOR, ACCESS_ENGINEERING_MAINT)

	outfit_type = /datum/outfit/job/station/janitor
	desc = "A Janitor keeps the station clean, as long as it doesn't interfere with active crime scenes."
	alt_titles = list(
		"Custodian" = /datum/prototype/alt_title/janitor/custodian,
		"Sanitation Technician" = /datum/prototype/alt_title/janitor/tech,
		"Viscera Cleaner" = /datum/prototype/alt_title/janitor/gorecleaner,
		"Maid" = /datum/prototype/alt_title/janitor/maid
		)

/datum/prototype/alt_title/janitor/custodian
	title = "Custodian"

/datum/prototype/alt_title/janitor/tech
	title = "Sanitation Technician"

/datum/prototype/alt_title/janitor/gorecleaner
	title = "Viscera Cleaner"

/datum/prototype/alt_title/janitor/maid
	title = "Maid"
	title_outfit = /datum/outfit/job/station/janitor/maid

/datum/outfit/job/station/janitor
	name = OUTFIT_JOB_NAME("Janitor")
	uniform = /obj/item/clothing/under/rank/janitor
	id_type = /obj/item/card/id/civilian/janitor
	pda_type = /obj/item/pda/janitor
	l_ear = /obj/item/radio/headset/headset_service

/datum/outfit/job/station/janitor/maid
	name = OUTFIT_JOB_NAME("Maid")
	uniform = /obj/item/clothing/under/dress/maid
	head = /obj/item/clothing/head/headband/maid
