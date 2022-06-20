/datum/job/station/detective
	title = "Detective"
	flag = DETECTIVE
	departments = list(DEPARTMENT_SECURITY)
	department_flag = ENGSEC
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Head of Security"
	selection_color = "#601C1C"
	idtype = /obj/item/card/id/security/detective
	access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_eva, access_external_airlocks, access_brig)
	minimal_access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_eva, access_external_airlocks)
	economic_modifier = 5
	minimal_player_age = 3

	outfit_type = /datum/outfit/job/station/detective
	desc = "A Detective works to help Security find criminals who have not properly been identified, through interviews and forensic work. \
						For crimes only witnessed after the fact, or those with no survivors, they attempt to piece together what they can from pure evidence."
	alt_titles = list(
		"Forensic Technician" = /datum/alt_title/detective/forensics_tech,
		"Crime Scene Investigator" = /datum/alt_title/detective/csi
		)

/datum/alt_title/detective/csi
	title = "Crime Scene Investigator"

/// Detective Alt Titles
/datum/alt_title/detective/forensics_tech
	title = "Forensic Technician"
	title_blurb = "A Forensic Technician works more with hard evidence and labwork than a Detective, but they share the purpose of solving crimes."
	title_outfit = /datum/outfit/job/station/detective/forensic

/datum/outfit/job/station/detective
	name = OUTFIT_JOB_NAME("Detective")
	head = /obj/item/clothing/head/det
	uniform = /obj/item/clothing/under/det
	suit = /obj/item/clothing/suit/storage/det_trench
	gloves = /obj/item/clothing/gloves/forensic
	l_pocket = /obj/item/flame/lighter/zippo
	shoes = /obj/item/clothing/shoes/laceup
	l_ear = /obj/item/radio/headset/headset_sec
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	r_hand = /obj/item/storage/briefcase/crimekit

	id_type = /obj/item/card/id/security/detective
	pda_type = /obj/item/pda/detective

	backpack = /obj/item/storage/backpack
	backpack_contents = list(/obj/item/storage/box/evidence = 1)
	satchel_one = /obj/item/storage/backpack/satchel/sec
	messenger_bag = /obj/item/storage/backpack/messenger/sec
	dufflebag = /obj/item/storage/backpack/dufflebag/sec

/datum/outfit/job/station/detective/forensic
	name = OUTFIT_JOB_NAME("Forensic technician")
	head = null
	suit = /obj/item/clothing/suit/storage/forensics/blue

/datum/outfit/job/station/detective/vice
	name = OUTFIT_JOB_NAME("Vice Investigator")
	head = null
	uniform = /obj/item/clothing/under/hawaiian
	suit = null
