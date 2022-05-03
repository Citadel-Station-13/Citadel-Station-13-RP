/datum/job/station/quartermaster
	title = "Quartermaster"
	flag = QUARTERMASTER
	departments = list(DEPARTMENT_CARGO)
	sorting_order = 1 // QM is above the cargo techs, but below the HoP.
	departments_managed = list(DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	pto_type = PTO_CARGO
	total_positions = 1
	spawn_positions = 1
	idtype = /obj/item/card/id/cargo/head
	supervisors = "the Head of Personnel"
	selection_color = "#9b633e"
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)

	ideal_character_age = 40

	outfit_type = /datum/outfit/job/station/quartermaster
	desc = "The Quartermaster manages the Supply department, checking cargo orders and ensuring supplies get to where they are needed."
	alt_titles = list("Supply Chief" = /datum/alt_title/supply_chief)

/datum/alt_title/supply_chief
	title = "Supply Chief"

/datum/outfit/job/station/quartermaster
	name = OUTFIT_JOB_NAME("Quartermaster")
	uniform = /obj/item/clothing/under/rank/cargo
	l_ear = /obj/item/radio/headset/headset_mine
	shoes = /obj/item/clothing/shoes/brown
	glasses = /obj/item/clothing/glasses/sunglasses
	l_hand = /obj/item/clipboard
	id_type = /obj/item/card/id/cargo/head
	pda_type = /obj/item/pda/quartermaster
