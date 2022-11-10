/datum/job/station/senior_engineer
	title = "Senior Engineer"
	flag = SENIOR_ENGINEER
	departments = list(DEPARTMENT_ENGINEERING)
	department_flag = ENGSEC
	total_positions = 1
	spawn_positions = 5
	supervisors = "the Chief Engineer"
	selection_color = "#5B4D20"
	idtype = /obj/item/card/id/engineering/engineer
	economic_modifier = 5
	pto_type = PTO_ENGINEERING

	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics)
	minimal_access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction)

	minimal_player_age = 14

	minimum_character_age = 25
	ideal_character_age = 45

	outfit_type = /datum/outfit/job/station/station_engineer/senior
	desc = "A Senior Engineer fulfills similar duties to other engineers, but usually occupies spare time with with training of other, newer Engineers \
					and making sure the Chief's orders are followed to the letter. You are not in command of the Engineering departement."


/datum/outfit/job/station/station_engineer/senior
	name = OUTFIT_JOB_NAME("Senior Engineer")
	head = /obj/item/clothing/head/hardhat/white
	uniform = /obj/item/clothing/under/rank/engineer
	id_type = /obj/item/card/id/engineering/engineer
	pda_type = /obj/item/pda/engineering
	l_ear = /obj/item/radio/headset/headset_eng
	belt = /obj/item/storage/belt/utility/atmostech
	belt = /obj/item/storage/belt/utility/full
	shoes = /obj/item/clothing/shoes/boots/workboots
	r_pocket = /obj/item/t_scanner

	id_type = /obj/item/card/id/engineering/atmos
	pda_type = /obj/item/pda/atmos

	backpack = /obj/item/storage/backpack/industrial
	satchel_one = /obj/item/storage/backpack/satchel/eng
	messenger_bag = /obj/item/storage/backpack/messenger/engi
	pda_slot = SLOT_ID_LEFT_POCKET
	dufflebag = /obj/item/storage/backpack/dufflebag/eng

	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
