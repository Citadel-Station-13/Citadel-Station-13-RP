/datum/job/station/janitor
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
	access = list(access_janitor, access_maint_tunnels)
	minimal_access = list(access_janitor, access_maint_tunnels)

	outfit_type = /datum/outfit/job/station/janitor
	desc = "A Janitor keeps the station clean, as long as it doesn't interfere with active crime scenes."
	alt_titles = list(
		"Custodian" = /datum/alt_title/janitor/custodian,
		"Sanitation Technician" = /datum/alt_title/janitor/tech,
		"Viscera Cleaner" = /datum/alt_title/janitor/gorecleaner,
		"Maid" = /datum/alt_title/janitor/maid
		)

/datum/alt_title/janitor/custodian
	title = "Custodian"

/datum/alt_title/janitor/tech
	title = "Sanitation Technician"

/datum/alt_title/janitor/gorecleaner
	title = "Viscera Cleaner"

/datum/alt_title/janitor/maid
	title = "Maid"

/datum/outfit/job/station/janitor
	name = OUTFIT_JOB_NAME("Janitor")
	uniform = /obj/item/clothing/under/rank/janitor
	id_type = /obj/item/card/id/civilian/janitor
	pda_type = /obj/item/pda/janitor
	l_ear = /obj/item/radio/headset/headset_service
