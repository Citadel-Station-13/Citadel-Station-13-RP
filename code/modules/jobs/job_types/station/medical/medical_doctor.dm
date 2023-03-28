/datum/role/job/station/doctor
	id = JOB_ID_MEDICAL_DOCTOR
	title = "Medical Doctor"
	flag = DOCTOR
	departments = list(DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	total_positions = 5
	spawn_positions = 3
	supervisors = "the Chief Medical Officer"
	selection_color = "#013D3B"
	pto_type = PTO_MEDICAL
	idtype = /obj/item/card/id/medical/doctor
	additional_access = list(ACCESS_MEDICAL_MAIN, ACCESS_MEDICAL_EQUIPMENT, ACCESS_MEDICAL_MORGUE, ACCESS_MEDICAL_SURGERY, ACCESS_MEDICAL_CHEMISTRY, ACCESS_MEDICAL_VIROLOGY, ACCESS_SCIENCE_GENETICS, ACCESS_COMMAND_EVA)
	minimal_access = list(ACCESS_MEDICAL_MAIN, ACCESS_MEDICAL_EQUIPMENT, ACCESS_MEDICAL_MORGUE, ACCESS_MEDICAL_SURGERY, ACCESS_MEDICAL_VIROLOGY, ACCESS_COMMAND_EVA)
	outfit_type = /datum/outfit/job/station/medical_doctor
	desc = "A Medical Doctor is a Jack-of-All-Trades Medical title, covering a variety of skill levels and minor specializations. They are likely \
						familiar with basic first aid, and a number of accompanying medications, and can generally save, if not cure, a majority of the \
						patients they encounter."
	alt_titles = list(
		"Surgeon" = /datum/prototype/alt_title/surgeon,
		"Emergency Physician" = /datum/prototype/alt_title/emergency_physician,
		"Nurse" = /datum/prototype/alt_title/nurse,
		"Virologist" = /datum/prototype/alt_title/virologist,
		"Medical Resident" = /datum/prototype/alt_title/doctor/resident,
		"Medical Intern" = /datum/prototype/alt_title/doctor/intern,
		"Orderly" = /datum/prototype/alt_title/orderly,
		"Biotechnician" = /datum/prototype/alt_title/biotechnician
		)

// Medical Doctor Alt Titles

/datum/prototype/alt_title/biotechnician
	title = "Biotechnician"
	title_outfit = /datum/outfit/job/station/medical_doctor/surgeon //todo: add OSSNECRO outfits
	background_allow = list(
		/datum/lore/character_background/faction/onkhera_necropolis
	)
	background_enforce = TRUE

/datum/prototype/alt_title/surgeon
	title = "Surgeon"
	title_blurb = "A Surgeon specializes in providing surgical aid to injured patients, up to and including amputation and limb reattachement. They are expected \
					to know the ins and outs of anesthesia and surgery."
	title_outfit = /datum/outfit/job/station/medical_doctor/surgeon

/datum/prototype/alt_title/orderly
	title = "Orderly"
	title_blurb = "An Orderly acts as Medbay's general helping hand, assisting any doctor that might need some form of help, as well as handling manual \
					and dirty labor around the department."
	title_outfit = /datum/outfit/job/station/medical_doctor/nurse

/datum/prototype/alt_title/emergency_physician
	title = "Emergency Physician"
	title_blurb = "An Emergency Physician is a Medical professional trained for stabilizing and treating severely injured and/or dying patients. \
					They are generally the first response for any such individual brought to the Medbay, and can sometimes be expected to help their patients \
					make a full recovery."
	title_outfit = /datum/outfit/job/station/medical_doctor/emergency_physician

/datum/prototype/alt_title/nurse
	title = "Nurse"
	title_blurb = "A Nurse acts as a general purpose Doctor's Aide, providing basic care to non-critical patients, and stabilizing critical patients during \
					busy periods. They frequently watch the suit sensors console, to help manage the time of other Doctors. In rare occasions, a Nurse can be \
					called upon to revive deceased crew members."
	title_outfit = /datum/outfit/job/station/medical_doctor/nurse

/datum/prototype/alt_title/virologist
	title = "Virologist"
	title_blurb = "A Virologist cures active diseases in the crew, and prepares antibodies for possible infections. They also have the skills \
					to produce the various types of virus foods or mutagens."
	title_outfit = /datum/outfit/job/station/medical_doctor/virologist

/datum/prototype/alt_title/doctor/resident
	title = "Medical Resident"

/datum/prototype/alt_title/doctor/intern
	title = "Medical Intern"

/datum/outfit/job/station/medical_doctor
	name = OUTFIT_JOB_NAME("Medical Doctor")
	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	l_hand = /obj/item/storage/firstaid/regular
	r_pocket = /obj/item/flashlight/pen
	id_type = /obj/item/card/id/medical
	l_ear = /obj/item/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/white

	pda_type = /obj/item/pda/medical
	pda_slot = SLOT_ID_LEFT_POCKET
	backpack = /obj/item/storage/backpack/medic
	satchel_one = /obj/item/storage/backpack/satchel/med
	messenger_bag = /obj/item/storage/backpack/messenger/med
	dufflebag = /obj/item/storage/backpack/dufflebag/med

/datum/outfit/job/station/medical_doctor/emergency_physician
	name = OUTFIT_JOB_NAME("Emergency Physician")
	suit = /obj/item/clothing/suit/storage/toggle/fr_jacket

/datum/outfit/job/station/medical_doctor/surgeon
	name = OUTFIT_JOB_NAME("Surgeon")
	uniform = /obj/item/clothing/under/rank/medical/scrubs
	head = /obj/item/clothing/head/surgery/blue

/datum/outfit/job/station/medical_doctor/virologist
	name = OUTFIT_JOB_NAME("Virologist")
	uniform = /obj/item/clothing/under/rank/virologist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/virologist
	mask = /obj/item/clothing/mask/surgical

	backpack = /obj/item/storage/backpack/virology
	satchel_one = /obj/item/storage/backpack/satchel/vir
	dufflebag = /obj/item/storage/backpack/dufflebag/virology

/datum/outfit/job/station/medical_doctor/nurse
	name = OUTFIT_JOB_NAME("Nurse")
	suit = null

/datum/outfit/job/station/medical_doctor/nurse/pre_equip(mob/living/carbon/human/H)
	if(H.gender == FEMALE)
		if(prob(50))
			uniform = /obj/item/clothing/under/rank/nursesuit
		else
			uniform = /obj/item/clothing/under/rank/nurse
		head = /obj/item/clothing/head/nursehat
	else
		uniform = /obj/item/clothing/under/rank/medical/scrubs/purple
	..()
