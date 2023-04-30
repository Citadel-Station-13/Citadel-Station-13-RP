/datum/role/job/station/head_of_security
	id = JOB_ID_HEAD_OF_SECURITY
	economy_payscale = ECONOMY_PAYSCALE_JOB_COMMAND
	title = "Head of Security"
	flag = HOS
	departments_managed = list(
		DEPARTMENT_SECURITY,
	)
	departments = list(
		DEPARTMENT_SECURITY,
		DEPARTMENT_COMMAND,
	)
	sorting_order = 2
	department_flag = ENGSEC
	disallow_jobhop = TRUE
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Facility Director"
	selection_color = "#8E2929"
	idtype = /obj/item/card/id/security/head
	disallow_jobhop = TRUE
	pto_type = PTO_SECURITY
	req_admin_notify = 1
	minimal_access = list(
		ACCESS_COMMAND_ANNOUNCE,
		ACCESS_COMMAND_BRIDGE,
		ACCESS_COMMAND_EVA,
		ACCESS_COMMAND_KEYAUTH,
		ACCESS_COMMAND_LOCKERS,
		ACCESS_ENGINEERING_AIRLOCK,
		ACCESS_ENGINEERING_CONSTRUCTION,
		ACCESS_ENGINEERING_MAIN,
		ACCESS_ENGINEERING_MAINT,
		ACCESS_MEDICAL_MAIN,
		ACCESS_MEDICAL_MORGUE,
		ACCESS_GENERAL_GATEWAY,
		ACCESS_SCIENCE_MAIN,
		ACCESS_SECURITY_ARMORY,
		ACCESS_SECURITY_BRIG,
		ACCESS_SECURITY_EDIT,
		ACCESS_SECURITY_EQUIPMENT,
		ACCESS_SECURITY_FORENSICS,
		ACCESS_SECURITY_HOS,
		ACCESS_SECURITY_MAIN,
		ACCESS_SUPPLY_MAIN,
		ACCESS_SUPPLY_MINE,
	)
	minimum_character_age = 25
	minimal_player_age = 14

	outfit_type = /datum/outfit/job/station/head_of_security
	desc = "	The Head of Security manages the Security Department, keeping the station safe and making sure the rules are followed. They are expected to \
						keep the other Department Heads, and the rest of the crew, aware of developing situations that may be a threat. If necessary, the HoS may \
						perform the duties of absent Security roles, such as distributing gear from the Armory."
	alt_titles = list(
		"Security Commander" = /datum/prototype/alt_title/hos/commander,
		"Chief of Security" = /datum/prototype/alt_title/hos/chief,
		"Defense Director" = /datum/prototype/alt_title/hos/director
		)

/datum/prototype/alt_title/hos/commander
	title = "Security Commander"

/datum/prototype/alt_title/hos/chief
	title = "Chief of Security"

/datum/prototype/alt_title/hos/director
	title = "Defense Director"

/datum/outfit/job/station/head_of_security
	name = OUTFIT_JOB_NAME("Head of security")
	l_ear = /obj/item/radio/headset/heads/hos
	uniform = /obj/item/clothing/under/rank/head_of_security
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	gloves = /obj/item/clothing/gloves/black
	shoes = /obj/item/clothing/shoes/boots/jackboots

	id_type = /obj/item/card/id/security/head
	pda_type = /obj/item/pda/heads/hos

	backpack = /obj/item/storage/backpack/security
	backpack_contents = list(/obj/item/handcuffs = 1)
	satchel_one = /obj/item/storage/backpack/satchel/sec
	messenger_bag = /obj/item/storage/backpack/messenger/sec
	dufflebag = /obj/item/storage/backpack/dufflebag/sec
