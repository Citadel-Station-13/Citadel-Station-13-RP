/datum/role/job/station/roboticist
	id = JOB_ID_ROBOTICIST
	title = "Roboticist"
	flag = ROBOTICIST
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Research Director"
	selection_color = "#633D63"
	pto_type = PTO_SCIENCE
	additional_access = list(
		ACCESS_SCIENCE_FABRICATION,
		ACCESS_SCIENCE_TOXINS,
		ACCESS_MEDICAL_MORGUE,
	)
	minimal_access = list(
		ACCESS_ENGINEERING_TECHSTORAGE,
		ACCESS_SCIENCE_ROBOTICS,
		ACCESS_SCIENCE_MAIN,
	)
	minimal_player_age = 7

	outfit_type = /datum/outfit/job/station/roboticist
	desc = "A Roboticist maintains and repairs the station's synthetics, including crew with prosthetic limbs. \
						They can also assist the station by producing simple robots and even pilotable exosuits."
	alt_titles = list(
		"Biomechanical Engineer" = /datum/prototype/struct/alt_title/biomech,
		"Mechatronic Engineer" = /datum/prototype/struct/alt_title/mech_tech,
		"Artificer-Biotechnicist" = /datum/prototype/struct/alt_title/artificer_biotechnicist
		)

/datum/prototype/struct/alt_title/artificer_biotechnicist
	title = "Artificer-Biotechnicist"
	background_allow = list(
		/datum/lore/character_background/faction/naramadiguilds
	)
	background_enforce = TRUE

/datum/prototype/struct/alt_title/biomech
	title = "Biomechanical Engineer"
	title_blurb = "A Biomechanical Engineer primarily works on prosthetics, and the organic parts attached to them. They may have some \
					knowledge of the relatively simple surgical procedures used in making cyborgs and attaching prosthesis."

/datum/prototype/struct/alt_title/mech_tech
	title = "Mechatronic Engineer"
	title_blurb = "A Mechatronic Engineer focuses on the construction and maintenance of Exosuits, and should be well versed in their use. \
					They may also be called upon to work on synthetics and prosthetics, if needed."

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
