/datum/job/station/cyborg
	id = JOB_ID_CYBORG
	title = "Cyborg"
	flag = CYBORG
	departments = list(DEPARTMENT_SYNTHETIC)
	department_flag = ENGSEC
	total_positions = 4			// Along with one able to spawn later in the round.
	spawn_positions = 3			// Let's have 3 able to spawn in roundstart
	supervisors = "your laws and the AI"	//Nodrak
	selection_color = "#254C25"
	minimal_player_age = 3		// 1 day is a little too little time
	account_allowed = 0
	economic_modifier = 0
	pto_type = PTO_CYBORG
	has_headset = FALSE
	assignable = FALSE
	mob_type = JOB_SILICON_ROBOT
	outfit_type = /datum/outfit/job/station/cyborg
	desc = "A Cyborg is a mobile station synthetic, piloted by a cybernetically preserved brain. It is considered a person, but is still required \
						to follow its Laws."
	alt_titles = list(
		"Robot" = /datum/alt_title/robot,
		"Drone" = /datum/alt_title/drone
		)

// Cyborg Alt Titles
/datum/alt_title/robot
	title = "Robot"
	title_blurb = "A Robot is a mobile station synthetic, piloted by an advanced piece of technology called a Positronic Brain. It is considered a person, \
					legally, but is required to follow its Laws."

/datum/alt_title/drone
	title = "Drone"
	title_blurb = "A Drone is a mobile station synthetic, piloted by a simple computer-based AI. As such, it is not a person, but rather an expensive and \
					and important piece of station property, and is expected to follow its Laws."

// Cyborg procs
/datum/job/station/cyborg/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	return 1

/datum/job/station/cyborg/equip_preview(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/cardborg(H), SLOT_ID_SUIT)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cardborg(H), SLOT_ID_HEAD)
	return 1

/datum/outfit/job/station/cyborg
	name = OUTFIT_JOB_NAME("Cyborg")
	head = /obj/item/clothing/head/cardborg
	suit = /obj/item/clothing/suit/cardborg
