/datum/role/job/station/emergency_responder //For staff managing/leading ERTs
	id = JOB_ID_EMERGENCY_RESPONDER
	title = "Emergency Responder"
	economy_payscale = ECONOMY_PAYSCALE_JOB_ADMIN
	departments = list("Central Command")
	department_accounts = list(DEPARTMENT_COMMAND, DEPARTMENT_ENGINEERING, DEPARTMENT_MEDICAL, DEPARTMENT_RESEARCH, DEPARTMENT_SECURITY, DEPARTMENT_CARGO, DEPARTMENT_PLANET, DEPARTMENT_CIVILIAN)
	total_positions = 2
	spawn_positions = 1
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#1D1D4F"
	additional_access = list()
	minimal_access = list()
	minimal_player_age = 14
	whitelist_only = 1
	join_types = JOB_LATEJOIN
	outfit_type = /datum/outfit/job/station/emergency_responder
	desc = "Emergency Responders are usually called in to deal with on-station emergencies that the crew require assistance to deal with."

	minimum_character_age = 18
	ideal_character_age = 30

	pto_type = PTO_CIVILIAN

/datum/role/job/station/emergency_responder/get_access()
	return get_all_accesses().Copy()

/datum/outfit/job/station/emergency_responder
	name = OUTFIT_JOB_NAME("Emergency Responder")
	uniform = /obj/item/clothing/under/ert
	shoes = /obj/item/clothing/shoes/boots/swat
	gloves = /obj/item/clothing/gloves/swat
	l_ear = /obj/item/radio/headset/ert
	glasses = /obj/item/clothing/glasses/sunglasses
	back = /obj/item/storage/backpack/satchel
	id_type = /obj/item/card/id/centcom/ERT
	belt = /obj/item/gun/energy/pulse_pistol
	r_pocket = /obj/item/pda/centcom
	flags = OUTFIT_EXTENDED_SURVIVAL|OUTFIT_COMPREHENSIVE_SURVIVAL

/datum/outfit/job/station/emergency_responder/post_equip(var/mob/living/carbon/human/H)
	..()
	ert.add_antagonist(H.mind)
