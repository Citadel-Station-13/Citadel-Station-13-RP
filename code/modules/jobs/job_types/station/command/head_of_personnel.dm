/datum/role/job/station/head_of_personnel
	id = JOB_ID_HEAD_OF_PERSONNEL
	title = "Head of Personnel"
	flag = HOP
	economy_payscale = ECONOMY_PAYSCALE_JOB_COMMAND
	departments = list(
		DEPARTMENT_COMMAND,
		DEPARTMENT_CIVILIAN,
		DEPARTMENT_CARGO,
	)
	sorting_order = 2 // Above the QM, below captain.
	departments_managed = list(
		DEPARTMENT_CIVILIAN,
		DEPARTMENT_CARGO,
	)
	department_flag = CIVILIAN
	disallow_jobhop = TRUE
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Facility Director"
	idtype = /obj/item/card/id/silver/hop
	pto_type = PTO_COMMAND
	selection_color = "#1D1D4F"
	req_admin_notify = 1
	minimal_player_age = 10

	minimum_character_age = 25
	ideal_character_age = 50

	outfit_type = /datum/outfit/job/station/head_of_personnel
	desc = "The Head of Personnel manages the Service department, the Exploration team, and most other civilians. They also \
						manage the Supply department, through the Quartermaster. In addition, the Head of Personnel oversees the personal accounts \
						of the crew, including their money and access. If necessary, the Head of Personnel is first in line to assume Acting Command."
	alt_titles = list(
		"Crew Resources Officer" = /datum/prototype/alt_title/cro,
		"Deputy Director" = /datum/prototype/alt_title/hop/deputy
	)

	minimal_access = list(
		ACCESS_COMMAND_ANNOUNCE,
		ACCESS_COMMAND_BANKING,
		ACCESS_COMMAND_BRIDGE,
		ACCESS_COMMAND_CARDMOD,
		ACCESS_COMMAND_EVA,
		ACCESS_COMMAND_HOP,
		ACCESS_COMMAND_IAA,
		ACCESS_COMMAND_KEYAUTH,
		ACCESS_COMMAND_LOCKERS,
		ACCESS_COMMAND_UPLOAD,
		ACCESS_COMMAND_VAULT,
		ACCESS_ENGINEERING_CONSTRUCTION,
		ACCESS_ENGINEERING_MAIN,
		ACCESS_ENGINEERING_MAINT,
		ACCESS_GENERAL_BAR,
		ACCESS_GENERAL_BOTANY,
		ACCESS_GENERAL_CHAPEL,
		ACCESS_GENERAL_CREMATOR,
		ACCESS_GENERAL_GATEWAY,
		ACCESS_GENERAL_JANITOR,
		ACCESS_GENERAL_KITCHEN,
		ACCESS_GENERAL_LIBRARY,
		ACCESS_MEDICAL_MAIN,
		ACCESS_MEDICAL_MORGUE,
		ACCESS_SCIENCE_MAIN,
		ACCESS_SECURITY_BRIG,
		ACCESS_SECURITY_EQUIPMENT,
		ACCESS_SECURITY_FORENSICS,
		ACCESS_SECURITY_MAIN,
		ACCESS_SUPPLY_BAY,
		ACCESS_SUPPLY_MAIN,
		ACCESS_SUPPLY_MINE,
		ACCESS_SUPPLY_MINE_OUTPOST,
		ACCESS_SUPPLY_MULEBOT,
		ACCESS_SUPPLY_QM,
	)

/datum/prototype/alt_title/cro
	title = "Crew Resources Officer"

/datum/prototype/alt_title/hop/deputy
	title = "Deputy Director"

/datum/outfit/job/station/head_of_personnel
	name = OUTFIT_JOB_NAME("Head of Personnel")
	uniform = /obj/item/clothing/under/rank/head_of_personnel
	l_ear = /obj/item/radio/headset/heads/hop
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/card/id/silver/hop
	pda_type = /obj/item/pda/heads/hop
