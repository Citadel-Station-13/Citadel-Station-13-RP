/datum/job/station/mime
	id = JOB_ID_MIME
	title = "Mime"
	flag = MIME
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = ENGSEC
	total_positions = 1
	spawn_positions = 1
	supervisors = "the spirit of performance"
	selection_color = "#515151"
	economic_modifier = 1
	access = list(access_entertainment)
	minimal_access = list(access_entertainment)
	desc = "A Mime is there to entertain the crew and keep high morale using unbelievable performances and acting skills!"
	alt_titles = list("Poseur" = /datum/alt_title/mime/poseur)
	whitelist_only = 1
	outfit_type = /datum/outfit/job/station/mime
	pto_type = PTO_CIVILIAN

/datum/alt_title/mime/poseur
	title = "Poseur"

/datum/job/station/mime/get_access()
	if(config_legacy.assistant_maint)
		return list(access_maint_tunnels, access_entertainment, access_tomfoolery, access_mime)
	else
		return list(access_entertainment, access_tomfoolery, access_mime)

/datum/outfit/job/station/mime
	name = OUTFIT_JOB_NAME("Mime")
	shoes = /obj/item/clothing/shoes/mime
	uniform = /obj/item/clothing/under/mime
	mask = /obj/item/clothing/mask/gas/mime
	l_ear = /obj/item/radio/headset
	id_slot = SLOT_ID_WORN_ID
	r_pocket = /obj/item/pen/crayon/mime
	id_type = /obj/item/card/id/civilian
	pda_slot = SLOT_ID_BELT
	pda_type = /obj/item/pda/mime
	id_pda_assignment = "Mime"

	backpack = /obj/item/storage/backpack/mime
