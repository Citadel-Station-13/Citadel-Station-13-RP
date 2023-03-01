/datum/role/job/station/centcom_officer //For Business
	id = JOB_ID_CENTCOM_OFFICER
	title = "CentCom Officer"
	economy_payscale = ECONOMY_PAYSCALE_JOB_ADMIN
	whitelist_only = 1
	departments = list("Central Command")
	department_accounts = list(DEPARTMENT_COMMAND, DEPARTMENT_ENGINEERING, DEPARTMENT_MEDICAL, DEPARTMENT_RESEARCH, DEPARTMENT_SECURITY, DEPARTMENT_CARGO, DEPARTMENT_PLANET, DEPARTMENT_CIVILIAN)
	total_positions = 2
	spawn_positions = 1
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#1D1D4F"
	idtype = /obj/item/card/id/centcom
	additional_access = list()
	minimal_access = list()
	minimal_player_age = 14
	join_types = JOB_LATEJOIN
	outfit_type = /datum/outfit/job/station/centcom_officer
	desc = "A Central Command Officer is there on official business. Most of time. Whatever it is, they're a VIP."

	minimum_character_age = 25
	ideal_character_age = 40

	pto_type = PTO_CIVILIAN

/datum/role/job/station/centcom_officer/get_access()
	return get_all_accesses().Copy()

/datum/outfit/job/station/centcom_officer
	name = OUTFIT_JOB_NAME("CentCom Officer")
	glasses = /obj/item/clothing/glasses/omnihud/all
	uniform = /obj/item/clothing/under/rank/centcom
	l_ear = /obj/item/radio/headset/centcom
	shoes = /obj/item/clothing/shoes/laceup
	id_type = /obj/item/card/id/centcom
	belt = /obj/item/gun/energy/pulse_pistol
	gloves = /obj/item/clothing/gloves/white
	head = /obj/item/clothing/head/beret/centcom/officer
	r_pocket = /obj/item/pda/centcom
	id_pda_assignment = "CentCom Officer"
