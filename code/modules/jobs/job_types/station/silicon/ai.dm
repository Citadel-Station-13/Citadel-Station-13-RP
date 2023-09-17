/datum/role/job/station/ai
	id = JOB_ID_AI
	title = "AI"
	flag = AI
	departments = list(DEPARTMENT_SYNTHETIC)
	sorting_order = 1 // Be above their borgs.
	department_flag = ENGSEC
	total_positions = 0 // Not used for AI, see is_position_available below and modules/mob/living/silicon/ai/latejoin.dm
	spawn_positions = 1
	selection_color = "#3F823F"
	supervisors = "your Laws"
	req_admin_notify = 1
	minimal_player_age = 7
	account_allowed = 0
	pto_type = PTO_CIVILIAN
	has_headset = FALSE
	assignable = FALSE
	mob_type = JOB_SILICON_AI
	outfit_type = /datum/outfit/job/station/ai
	desc = "The AI oversees the operation of the station and its crew, but has no real authority over them. \
						The AI is required to follow its Laws, and Lawbound Synthetics that are linked to it are expected to follow \
						the AI's commands, and their own Laws."
	disallow_jobhop = TRUE

// AI procs
/datum/role/job/station/ai/equip(var/mob/living/carbon/human/H)
	if(!H)
		return 0
	return 1

/datum/role/job/station/ai/slots_remaining(latejoin)
	if(latejoin)
		return GLOB.empty_playable_ai_cores.len
	return ..()

/datum/role/job/station/ai/is_position_available()
	return (GLOB.empty_playable_ai_cores.len != 0)

/datum/role/job/station/ai/equip_preview(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/straight_jacket(H), SLOT_ID_SUIT)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cardborg(H), SLOT_ID_HEAD)
	return 1

/datum/outfit/job/station/ai
	name = OUTFIT_JOB_NAME("AI")
	head = /obj/item/clothing/head/cardborg
	suit = /obj/item/clothing/suit/straight_jacket
