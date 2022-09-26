/datum/job/station/roboticist
	title = "Roboticist"
	flag = ROBOTICIST
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Research Director"
	selection_color = "#633D63"
	economic_modifier = 5
	pto_type = PTO_SCIENCE
	access = list(access_robotics, access_tox, access_tox_storage, access_tech_storage, access_morgue, access_research, access_tox) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_access = list(access_robotics, access_tech_storage, access_morgue, access_research, access_tox) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_player_age = 7

	outfit_type = /datum/outfit/job/station/roboticist
	desc = "A Roboticist maintains and repairs the station's synthetics, including crew with prosthetic limbs. \
						They can also assist the station by producing simple robots and even pilotable exosuits."
	alt_titles = list(
		"Biomechanical Engineer" = /datum/alt_title/biomech,
		"Mechatronic Engineer" = /datum/alt_title/mech_tech,
		"Prosthetists" = /datum/alt_title/prosthetists
		)

/datum/alt_title/biomech
	title = "Biomechanical Engineer"
	title_blurb = "A Biomechanical Engineer primarily works on prosthetics, and the organic parts attached to them. They may have some \
					knowledge of the relatively simple surgical procedures used in making cyborgs and attaching prosthesis."

/datum/alt_title/mech_tech
	title = "Mechatronic Engineer"
	title_blurb = "A Mechatronic Engineer focuses on the construction and maintenance of Exosuits, and should be well versed in their use. \
					They may also be called upon to work on synthetics and prosthetics, if needed."

/datum/alt_title/prosthetists
	title = "Prosthetists"
	title_blurb = "Prosthetists design and fabricate medical supportive devices and measure and fit patients for them. These devices \
					include artificial limbs (arms, hands, legs, and feet), braces, and other medical or surgical devices."

/datum/outfit/job/station/roboticist
	name = OUTFIT_JOB_NAME("Roboticist")
	uniform = /obj/item/clothing/under/rank/roboticist
	shoes = /obj/item/clothing/shoes/black
	belt = /obj/item/storage/belt/utility/full

	id_type = /obj/item/card/id/science/roboticist
	pda_slot = SLOT_ID_RIGHT_POCKET
	pda_type = /obj/item/pda/roboticist
	l_ear = /obj/item/radio/headset/headset_sci

	backpack = /obj/item/storage/backpack
	satchel_one = /obj/item/storage/backpack/satchel/norm
	messenger_bag = /obj/item/storage/backpack/messenger/tox
	dufflebag = /obj/item/storage/backpack/dufflebag/sci
