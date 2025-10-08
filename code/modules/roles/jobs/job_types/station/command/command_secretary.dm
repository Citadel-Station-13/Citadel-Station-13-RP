/datum/prototype/role/job/station/command_secretary
	id = JOB_ID_COMMAND_SECRETARY
	title = "Bridge Officer"
	economy_payscale = ECONOMY_PAYSCALE_JOB_HELM
	flag = BRIDGE
	departments = list(DEPARTMENT_COMMAND)
	department_accounts = list(DEPARTMENT_COMMAND)
	department_flag = CIVILIAN
	disallow_jobhop = TRUE
	pto_type = PTO_COMMAND
	total_positions = 2
	spawn_positions = 2
	supervisors = "command staff"
	selection_color = "#1D1D4F"
	minimal_player_age = 5

	minimal_access = list(
		ACCESS_COMMAND_BRIDGE,
		ACCESS_COMMAND_KEYAUTH,
		ACCESS_ENGINEERING_MAINT,
	)

	outfit_type = /datum/outfit/job/station/command_secretary/bridge_officer
	desc = "A bridge officer is often considered command staff in-training. Their duties are to assist the command staff with things like paperwork, \
			as well as to assist in piloting the ship when deemed necessary and applicable."

	alt_titles = list(
		"Command Intern" = /datum/prototype/struct/alt_title/command_intern,
		"Helmsman" = /datum/prototype/struct/alt_title/commsec/helmsman,
		"Command Secretary" = /datum/prototype/struct/alt_title/commsec/actually_commsec
	)

/datum/prototype/struct/alt_title/command_intern
	title = "Command Intern"
	title_outfit = /datum/outfit/job/station/command_secretary

/datum/prototype/struct/alt_title/commsec/helmsman
	title = "Helmsman"

/datum/prototype/struct/alt_title/commsec/actually_commsec
	title = "Command Secretary"
	title_outfit = /datum/outfit/job/station/command_secretary

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
