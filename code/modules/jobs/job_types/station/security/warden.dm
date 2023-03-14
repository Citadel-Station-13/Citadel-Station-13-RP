/datum/role/job/station/warden
	id = JOB_ID_WARDEN
	economy_payscale = ECONOMY_PAYSCALE_JOB_SENIOR
	title = "Warden"
	flag = WARDEN
	departments = list(DEPARTMENT_SECURITY)
	sorting_order = 1
	department_flag = ENGSEC
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Head of Security"
	selection_color = "#601C1C"
	idtype = /obj/item/card/id/security/warden
	pto_type = PTO_SECURITY
	additional_access = list(ACCESS_SECURITY_EQUIPMENT, ACCESS_COMMAND_EVA, ACCESS_SECURITY_MAIN, ACCESS_SECURITY_BRIG, ACCESS_SECURITY_ARMORY, ACCESS_ENGINEERING_MAINT, ACCESS_MEDICAL_MORGUE, ACCESS_ENGINEERING_AIRLOCK)
	minimal_access = list(ACCESS_SECURITY_EQUIPMENT, ACCESS_COMMAND_EVA, ACCESS_SECURITY_MAIN, ACCESS_SECURITY_BRIG, ACCESS_SECURITY_ARMORY, ACCESS_ENGINEERING_MAINT, ACCESS_ENGINEERING_AIRLOCK)
	minimal_player_age = 5

	outfit_type = /datum/outfit/job/station/warden
	desc = "The Warden watches over the physical Security Department, making sure the Brig and Armoury are secure and in order at all times. They oversee \
						prisoners that have been processed and brigged, and are responsible for their well being. The Warden is also in charge of distributing \
						Armoury gear in a crisis, and retrieving it when the crisis has passed. In an emergency, the Warden may be called upon to direct the \
						Security Department as a whole."
	alt_titles = list(
		"Jailor" = /datum/prototype/alt_title/warden/jailor,
		"Dispatch Officer" = /datum/prototype/alt_title/warden/dispatch_officer
		)

/datum/prototype/alt_title/warden/jailor
	title = "Jailor"

/datum/prototype/alt_title/warden/dispatch_officer
	title = "Dispatch Officer"

/datum/outfit/job/station/warden
	name = OUTFIT_JOB_NAME("Warden")
	uniform = /obj/item/clothing/under/rank/warden
	l_pocket = /obj/item/flash
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	l_ear = /obj/item/radio/headset/headset_sec
	gloves = /obj/item/clothing/gloves/black
	shoes = /obj/item/clothing/shoes/boots/jackboots

	id_type = /obj/item/card/id/security/warden
	pda_type = /obj/item/pda/warden

	backpack = /obj/item/storage/backpack/security
	backpack_contents = list(/obj/item/handcuffs = 1)
	satchel_one = /obj/item/storage/backpack/satchel/sec
	messenger_bag = /obj/item/storage/backpack/messenger/sec
	dufflebag = /obj/item/storage/backpack/dufflebag/sec
