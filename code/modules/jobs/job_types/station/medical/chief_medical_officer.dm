/datum/job/station/chief_medical_officer
	title = "Chief Medical Officer"
	flag = CMO
	departments_managed = list(DEPARTMENT_MEDICAL)
	departments = list(DEPARTMENT_MEDICAL, DEPARTMENT_COMMAND)
	sorting_order = 2
	department_flag = MEDSCI
	pto_type = PTO_MEDICAL
	disallow_jobhop = TRUE
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Facility Director"
	selection_color = "#026865"
	idtype = /obj/item/card/id/medical/head
	req_admin_notify = 1
	economic_modifier = 10
	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks, access_maint_tunnels)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks, access_maint_tunnels)

	minimum_character_age = 25
	minimal_player_age = 10
	ideal_character_age = 50

	outfit_type = /datum/outfit/job/station/chief_medical_officer
	desc = "The CMO manages the Medical department and is a position requiring experience and skill; their goal is to ensure that their \
						staff keep the station's crew healthy and whole. They are primarily interested in making sure that patients are safely found and \
						transported to Medical for treatment. They are expected to keep the crew informed about threats to their health and safety, and \
						about the importance of Suit Sensors."
	alt_titles = list (
		"Chief Physician" = /datum/alt_title/cmo/physician,
		"Director of Medicine" = /datum/alt_title/cmo/director,
		"Chief Surgeon" = /datum/alt_title/cmo/surgeon
	)

/datum/alt_title/cmo/physician
	title = "Chief Physician"

/datum/alt_title/cmo/director
	title = "Director of Medicine"

/datum/alt_title/cmo/surgeon
	title = "Chief Surgeon"

/datum/outfit/job/station/chief_medical_officer
	name = OUTFIT_JOB_NAME("Chief Medical Officer")
	l_ear  =/obj/item/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/rank/chief_medical_officer
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	shoes = /obj/item/clothing/shoes/brown
	l_hand = /obj/item/storage/firstaid/adv
	r_pocket = /obj/item/healthanalyzer

	id_type = /obj/item/card/id/medical/head
	pda_type = /obj/item/pda/heads/cmo
	pda_slot = SLOT_ID_LEFT_POCKET
	backpack = /obj/item/storage/backpack/medic
	satchel_one = /obj/item/storage/backpack/satchel/med
	messenger_bag = /obj/item/storage/backpack/messenger/med
	dufflebag = /obj/item/storage/backpack/dufflebag/med
