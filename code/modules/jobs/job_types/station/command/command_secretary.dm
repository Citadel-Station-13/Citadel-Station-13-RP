/datum/role/job/station/command_secretary
	id = JOB_ID_COMMAND_SECRETARY
	title = "Command Secretary"
	economy_payscale = ECONOMY_PAYSCALE_JOB_HELM
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

	additional_access = list(ACCESS_COMMAND_BRIDGE, ACCESS_COMMAND_KEYAUTH)
	minimal_access = list(ACCESS_COMMAND_BRIDGE, ACCESS_COMMAND_KEYAUTH)

	outfit_type = /datum/outfit/job/station/command_secretary
	desc = "A Command Secretary handles paperwork duty for the Heads of Staff, so they can better focus on managing their departments. \
						They are not Heads of Staff, and have no real authority."

	alt_titles = list(
		"Command Liaison" = /datum/prototype/alt_title/command_liaison,
		"Bridge Secretary" = /datum/prototype/alt_title/bridge_secretary,
		"Command Assistant" = /datum/prototype/alt_title/command_assistant,
		"Command Intern" = /datum/prototype/alt_title/command_intern,
		"Helmsman" = /datum/prototype/alt_title/commsec/helmsman,
		"Bridge Officer" = /datum/prototype/alt_title/commsec/officer
	)

/datum/prototype/alt_title/command_liaison
	title = "Command Liaison"

/datum/prototype/alt_title/bridge_secretary
	title = "Bridge Secretary"

/datum/prototype/alt_title/command_assistant
	title = "Command Assistant"

/datum/prototype/alt_title/command_intern
	title = "Command Intern"

/datum/prototype/alt_title/commsec/helmsman
	title = "Helmsman"

/datum/prototype/alt_title/commsec/officer
	title = "Bridge Officer"
	title_outfit = /datum/outfit/job/station/command_secretary/bridge_officer

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

/datum/outfit/job/station/command_secretary/bridge_officer
	name = OUTFIT_JOB_NAME("Bridge Officer")
	shoes = /obj/item/clothing/shoes/laceup
	id_type = /obj/item/card/id/silver/secretary
	pda_type = /obj/item/pda/heads/hop
	l_hand = /obj/item/clipboard
	head = /obj/item/clothing/head/bocap
	suit = /obj/item/clothing/suit/storage/bridgeofficer
	glasses = /obj/item/clothing/glasses/sunglasses

/datum/outfit/job/station/command_secretary/bridge_officer/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/bridgeofficerskirt
	else
		uniform = /obj/item/clothing/under/bridgeofficer
