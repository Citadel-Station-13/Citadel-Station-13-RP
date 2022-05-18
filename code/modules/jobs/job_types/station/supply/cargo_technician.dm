/datum/job/station/cargo_tech
	title = "Cargo Technician"
	flag = CARGOTECH
	departments = list(DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	pto_type = PTO_CARGO
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Quartermaster and the Head of Personnel"
	selection_color = "#7a4f33"
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mailsorting)

	outfit_type = /datum/outfit/job/station/cargo_technician
	desc = "A Cargo Technician fills and delivers cargo orders. They are encouraged to return delivered crates to the Cargo Shuttle, \
						because Central Command gives a partial refund."
	alt_titles = list("Logistics Specialist" = /datum/alt_title/logi_spec)

/datum/alt_title/logi_spec
	title = "Logistics Specialist"

/datum/outfit/job/station/cargo_technician
	name = OUTFIT_JOB_NAME("Cargo technician")
	uniform = /obj/item/clothing/under/rank/cargotech
	l_ear = /obj/item/radio/headset/headset_cargo
	id_type = /obj/item/card/id/cargo/cargo_tech
	pda_type = /obj/item/pda/cargo
