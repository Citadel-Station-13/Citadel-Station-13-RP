/datum/job/station/command_secretary
	title = "Command Secretary"
	flag = BRIDGE
	departments = list(DEPARTMENT_COMMAND)
	department_accounts = list(DEPARTMENT_COMMAND)
	department_flag = CIVILIAN
	disallow_jobhop = TRUE
	pto_type = PTO_CIVILIAN
	total_positions = 2
	spawn_positions = 2
	supervisors = "command staff"
	selection_color = "#1D1D4F"
	minimal_player_age = 5
	economic_modifier = 7

	access = list(access_heads, access_keycard_auth)
	minimal_access = list(access_heads, access_keycard_auth)

	outfit_type = /datum/outfit/job/station/command_secretary
	desc = "A Command Secretary handles paperwork duty for the Heads of Staff, so they can better focus on managing their departments. \
						They are not Heads of Staff, and have no real authority."

	alt_titles = list(
		"Command Liaison" = /datum/alt_title/command_liaison,
		"Bridge Secretary" = /datum/alt_title/bridge_secretary,
		"Command Assistant" = /datum/alt_title/command_assistant,
		"Command Intern" = /datum/alt_title/command_intern,
		"Helmsman" = /datum/alt_title/commsec/helmsman,
		"Bridge Officer" = /datum/alt_title/commsec/officer
	)

/datum/alt_title/command_liaison
	title = "Command Liaison"

/datum/alt_title/bridge_secretary
	title = "Bridge Secretary"

/datum/alt_title/command_assistant
	title = "Command Assistant"

/datum/alt_title/command_intern
	title = "Command Intern"

/datum/alt_title/commsec/helmsman
	title = "Helmsman"

/datum/alt_title/commsec/officer
	title = "Bridge Officer"

/datum/outfit/job/station/command_secretary
	name = OUTFIT_JOB_NAME("Command Secretary")
	l_ear = /obj/item/radio/headset/headset_adj //Citadel Edit: command secretaries get service on their headsets.
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/card/id/silver/secretary
	pda_type = /obj/item/pda/heads/hop
	l_hand = /obj/item/clipboard

/datum/outfit/job/station/command_secretary/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/suit_jacket/female/skirt
	else
		uniform = /obj/item/clothing/under/suit_jacket/charcoal
