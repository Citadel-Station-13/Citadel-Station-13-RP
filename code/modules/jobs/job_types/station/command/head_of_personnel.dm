/datum/job/station/head_of_personnel
	title = "Head of Personnel"
	flag = HOP
	departments = list(DEPARTMENT_COMMAND, DEPARTMENT_CIVILIAN, DEPARTMENT_CARGO)
	sorting_order = 2 // Above the QM, below captain.
	departments_managed = list(DEPARTMENT_CIVILIAN, DEPARTMENT_CARGO)
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
	economic_modifier = 10

	minimum_character_age = 25
	ideal_character_age = 50

	outfit_type = /datum/outfit/job/station/head_of_personnel
	desc = "The Head of Personnel manages the Service department, the Exploration team, and most other civilians. They also \
						manage the Supply department, through the Quartermaster. In addition, the Head of Personnel oversees the personal accounts \
						of the crew, including their money and access. If necessary, the Head of Personnel is first in line to assume Acting Command."
	alt_titles = list(
		"Crew Resources Officer" = /datum/alt_title/cro,
		"Deputy Director" = /datum/alt_title/hop/deputy
	)

	access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers,
						access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
						access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
						access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
						access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
						access_hop, access_RC_announce, access_keycard_auth, access_gateway)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers,
						access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
						access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
						access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
						access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
						access_hop, access_RC_announce, access_keycard_auth, access_gateway)

/datum/alt_title/cro
	title = "Crew Resources Officer"

/datum/alt_title/hop/deputy
	title = "Deputy Director"

/datum/outfit/job/station/head_of_personnel
	name = OUTFIT_JOB_NAME("Head of Personnel")
	uniform = /obj/item/clothing/under/rank/head_of_personnel
	l_ear = /obj/item/radio/headset/heads/hop
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/card/id/silver/hop
	pda_type = /obj/item/pda/heads/hop
