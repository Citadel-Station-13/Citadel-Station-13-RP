/datum/job/station/warden
	id = JOB_ID_WARDEN
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
	economic_modifier = 5
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_morgue, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_external_airlocks)
	minimal_player_age = 5

	outfit_type = /datum/outfit/job/station/warden
	desc = "The Warden watches over the physical Security Department, making sure the Brig and Armoury are secure and in order at all times. They oversee \
						prisoners that have been processed and brigged, and are responsible for their well being. The Warden is also in charge of distributing \
						Armoury gear in a crisis, and retrieving it when the crisis has passed. In an emergency, the Warden may be called upon to direct the \
						Security Department as a whole."
	alt_titles = list(
		"Jailor" = /datum/alt_title/warden/jailor,
		"Dispatch Officer" = /datum/alt_title/warden/dispatch_officer
		)

/datum/alt_title/warden/jailor
	title = "Jailor"

/datum/alt_title/warden/dispatch_officer
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
