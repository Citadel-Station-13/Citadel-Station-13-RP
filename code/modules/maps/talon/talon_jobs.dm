// Used to be tether_jobs.dm and only loaded on tether... Why I do not know - Bloop
// Make sure to have these z levels defined in whatever map defines you are creating. Tempted to just define them here but thats something to test later
/*
///Change the numbers here as appropriate
#define Z_LEVEL_OFFMAP1					1000
#define Z_LEVEL_OFFMAP2					1001
*/
///////////////////////////////////
//// Talon Jobs

/* ///On request of Maintainer I am commenting this out for now. Maybe in the future we can find a new purpose for Talon -Bloop 2-17-2022

/datum/department/talon
	name = DEPARTMENT_TALON
	short_name = "Talon"
	color = "#888888"
	sorting_order = -2
	assignable = FALSE
	visible = FALSE

/datum/job/talon_captain
	title = "Talon Captain"
	flag = TALCAP
	department_flag = TALON
	departments_managed = list(DEPARTMENT_TALON)
	desc = "The captain's job is to generate profit through trade or other means such as salvage or even privateering."
	supervisors = "yourself"
	outfit_type = /datum/outfit/job/talon_captain

	offmap_spawn = TRUE
	faction = "Station" //Required for SSjob to allow people to join as it
	departments = list(DEPARTMENT_TALON)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#999999"
	economic_modifier = 7
	minimal_player_age = 14
	pto_type = null
	access = list(access_talon)
	minimal_access = list(access_talon)
	alt_titles = list("Talon Commander" = /datum/alt_title/talon_commander)

/datum/alt_title/talon_commander
	title = "Talon Commander"

/datum/job/talon_doctor
	title = "Talon Doctor"
	flag = TALDOC
	department_flag = TALON
	desc = "The doctor's job is to make sure the crew of the ITV Talon remain in good health and to monitor them when away from the ship."
	supervisors = "the ITV Talon's captain"
	outfit_type = /datum/outfit/job/talon_doctor

	offmap_spawn = TRUE
	faction = "Station" //Required for SSjob to allow people to join as it
	departments = list(DEPARTMENT_TALON)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#aaaaaa"
	economic_modifier = 5
	minimal_player_age = 14
	pto_type = null
	access = list(access_talon)
	minimal_access = list(access_talon)
	alt_titles = list("Talon Medic" = /datum/alt_title/talon_medic)

/datum/alt_title/talon_medic
	title = "Talon Medic"


/datum/job/talon_engineer
	title = "Talon Engineer"
	flag = TALENG
	department_flag = TALON
	desc = "The engineer's job is to ensure the ITV Talon remains in tip-top shape and to repair any damage as well as manage the shields."
	supervisors = "the ITV Talon's captain"
	outfit_type = /datum/outfit/job/talon_engineer

	offmap_spawn = TRUE
	faction = "Station" //Required for SSjob to allow people to join as it
	departments = list(DEPARTMENT_TALON)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#aaaaaa"
	economic_modifier = 5
	minimal_player_age = 14
	pto_type = null
	access = list(access_talon)
	minimal_access = list(access_talon)
	alt_titles = list("Talon Technician" = /datum/alt_title/talon_tech)

/datum/alt_title/talon_tech
	title = "Talon Technician"


/datum/job/talon_pilot
	title = "Talon Pilot"
	flag = TALPIL
	department_flag = TALON
	desc = "The pilot's job is to fly the ITV Talon in the most efficient and profitable way possible."
	supervisors = "the ITV Talon's captain"
	outfit_type = /datum/outfit/job/talon_pilot

	offmap_spawn = TRUE
	faction = "Station" //Required for SSjob to allow people to join as it
	departments = list(DEPARTMENT_TALON)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#aaaaaa"
	economic_modifier = 5
	minimal_player_age = 14
	pto_type = null
	access = list(access_talon)
	minimal_access = list(access_talon)
	alt_titles = list("Talon Helmsman" = /datum/alt_title/talon_helmsman)

/datum/alt_title/talon_helmsman
	title = "Talon Helmsman"


/datum/job/talon_guard
	title = "Talon Guard"
	flag = TALSEC
	department_flag = TALON
	desc = "The guard's job is to keep the crew of the ITV Talon safe and ensure the captain's wishes are carried out."
	supervisors = "the ITV Talon's captain"
	outfit_type = /datum/outfit/job/talon_security

	offmap_spawn = TRUE
	faction = "Station" //Required for SSjob to allow people to join as it
	departments = list(DEPARTMENT_TALON)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#aaaaaa"
	economic_modifier = 5
	minimal_player_age = 14
	pto_type = null
	access = list(access_talon)
	minimal_access = list(access_talon)
	alt_titles = list("Talon Security" = /datum/alt_title/talon_security)

/datum/alt_title/talon_security
	title = "Talon Security"


/datum/outfit/job/talon_captain
	name = OUTFIT_JOB_NAME("Talon Captain")

	id_type = /obj/item/card/id/gold
	id_slot = slot_wear_id
	pda_type = null

	l_ear = /obj/item/radio/headset/talon
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/rank/captain/talon
	shoes = /obj/item/clothing/shoes/brown
	backpack = /obj/item/storage/backpack/captain/talon
	satchel_one = /obj/item/storage/backpack/satchel/cap/talon
	messenger_bag = /obj/item/storage/backpack/messenger/com/talon

/datum/outfit/job/talon_pilot
	name = OUTFIT_JOB_NAME("Talon Pilot")

	id_slot = slot_wear_id
	pda_type = null
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL

	l_ear = /obj/item/radio/headset/talon
	shoes = /obj/item/clothing/shoes/black
	uniform = /obj/item/clothing/under/rank/pilot2
	suit = /obj/item/clothing/suit/storage/toggle/bomber/pilot
	gloves = /obj/item/clothing/gloves/fingerless
	glasses = /obj/item/clothing/glasses/fakesunglasses/aviator
	uniform_accessories = list(/obj/item/clothing/accessory/storage/webbing/pilot1 = 1)
/datum/outfit/job/talon_doctor
	name = OUTFIT_JOB_NAME("Talon Doctor")
	abstract_type = /datum/outfit/job

	id_type = /obj/item/card/id/medical
	id_slot = slot_wear_id
	pda_type = null

	l_ear = /obj/item/radio/headset/talon
	shoes = /obj/item/clothing/shoes/white
	backpack = /obj/item/storage/backpack/medic
	satchel_one = /obj/item/storage/backpack/satchel/med
	messenger_bag = /obj/item/storage/backpack/messenger/med
	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	l_hand = /obj/item/storage/firstaid/regular
	r_pocket = /obj/item/flashlight/pen

/datum/outfit/job/talon_security
	name = OUTFIT_JOB_NAME("Talon Security")
	abstract_type = /datum/outfit/job

	id_type = /obj/item/card/id/security
	id_slot = slot_wear_id
	pda_type = null
	backpack_contents = list(/obj/item/handcuffs = 1)

	l_ear = /obj/item/radio/headset/talon
	gloves = /obj/item/clothing/gloves/black
	shoes = /obj/item/clothing/shoes/boots/jackboots
	backpack = /obj/item/storage/backpack/security
	satchel_one = /obj/item/storage/backpack/satchel/sec
	messenger_bag = /obj/item/storage/backpack/messenger/sec
	uniform = /obj/item/clothing/under/rank/security
	l_pocket = /obj/item/flash

/datum/outfit/job/talon_engineer
	name = OUTFIT_JOB_NAME("Talon Engineer")
	abstract_type = /datum/outfit/job

	id_type = /obj/item/card/id/engineering
	id_slot = slot_wear_id
	pda_type = null
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

	l_ear = /obj/item/radio/headset/talon
	belt = /obj/item/storage/belt/utility/full
	shoes = /obj/item/clothing/shoes/boots/workboots
	r_pocket = /obj/item/t_scanner
	backpack = /obj/item/storage/backpack/industrial
	satchel_one = /obj/item/storage/backpack/satchel/eng
	messenger_bag = /obj/item/storage/backpack/messenger/engi
	uniform = /obj/item/clothing/under/rank/atmospheric_technician
	belt = /obj/item/storage/belt/utility/atmostech
*/
