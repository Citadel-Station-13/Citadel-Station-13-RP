/datum/job/station/clown
	id = JOB_ID_CLOWN
	title = "Clown"
	flag = CLOWN
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = ENGSEC
	total_positions = 1
	spawn_positions = 1
	supervisors = "the spirit of laughter"
	selection_color = "#515151"
	economic_modifier = 1
	access = list(access_entertainment)
	minimal_access = list(access_entertainment)
	desc = "A Clown is there to entertain the crew and keep high morale using various harmless pranks and ridiculous jokes!"
	whitelist_only = 1
	outfit_type = /datum/outfit/job/station/clown
	pto_type = PTO_CIVILIAN
	alt_titles = list("Jester" = /datum/alt_title/clown/jester, "Fool" = /datum/alt_title/clown/fool)

/datum/alt_title/clown/jester
	title = "Jester"

/datum/alt_title/clown/fool
	title = "Fool"

/datum/job/station/clown/get_access()
	if(config_legacy.assistant_maint)
		return list(access_maint_tunnels, access_entertainment, access_clown, access_tomfoolery)
	else
		return list(access_entertainment, access_clown, access_tomfoolery)

/datum/outfit/job/station/clown
	name = OUTFIT_JOB_NAME("Clown")
	shoes = /obj/item/clothing/shoes/clown_shoes
	uniform = /obj/item/clothing/under/rank/clown
	mask = /obj/item/clothing/mask/gas/clown_hat
	r_pocket = /obj/item/bikehorn
	l_ear = /obj/item/radio/headset
	id_slot = SLOT_ID_WORN_ID
	id_type = /obj/item/card/id/civilian
	pda_slot = SLOT_ID_BELT
	pda_type = /obj/item/pda/clown
	id_pda_assignment = "Clown"

	backpack = /obj/item/storage/backpack/clown
	dufflebag = /obj/item/storage/backpack/dufflebag/clown
