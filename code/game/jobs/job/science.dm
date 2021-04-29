//////////////////////////////////
//		Research Director
//////////////////////////////////
/datum/job/rd
	title = "Research Director"
	flag = RD
	departments_managed = list(DEPARTMENT_RESEARCH)
	departments = list(DEPARTMENT_RESEARCH, DEPARTMENT_COMMAND)
	sorting_order = 2
	department_flag = MEDSCI
	disallow_jobhop = TRUE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Facility Director"
	selection_color = "#AD6BAD"
	idtype = /obj/item/card/id/science/head
	req_admin_notify = 1
	economic_modifier = 15
	access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter, access_sec_doors,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_eva, access_network)
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter, access_sec_doors,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_eva, access_network)
	minimum_character_age = 25
	minimal_player_age = 14
	ideal_character_age = 50

	outfit_type = /decl/hierarchy/outfit/job/science/rd
	alt_titles = list("Research Supervisor","Expedition Director")

//////////////////////////////////
//			Scientist
//////////////////////////////////
/datum/job/scientist
	title = "Scientist"
	flag = SCIENTIST
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the Research Director"
	selection_color = "#633D63"
	idtype = /obj/item/card/id/science/scientist
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch)

	minimal_player_age = 14

	outfit_type = /decl/hierarchy/outfit/job/science/scientist
	alt_titles = list("Xenoarchaeologist", "Anomalist", "Phoron Researcher", "Circuit Designer", "Research Field Technician", "Lab Assistant", "Junior Scientist")


//////////////////////////////////
//			Xenobiologist
//////////////////////////////////
/datum/job/xenobiologist
	title = "Xenobiologist"
	flag = XENOBIOLOGIST
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the Research Director"
	selection_color = "#633D63"
	idtype = /obj/item/card/id/science/xenobiologist
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_hydroponics, access_tox)
	minimal_access = list(access_research, access_xenobiology, access_hydroponics, access_tox_storage,access_tox)

	minimal_player_age = 14

	outfit_type = /decl/hierarchy/outfit/job/science/xenobiologist
	job_description = "A Xenobiologist studies esoteric lifeforms, usually in the relative safety of their lab. They attempt to find ways to benefit \
						from the byproducts of these lifeforms, and their main subject at present is the Giant Slime."
/*VR edit start
	alt_titles = list("Xenobotanist" = /datum/alt_title/xenobot)

 Xenibiologist Alt Titles
/datum/alt_title/xenobot
	title = "Xenobotanist"
	title_blurb = "A Xenobotanist grows and cares for a variety of abnormal, custom made, and frequently dangerous plant life. When the products of these plants \
					is both safe and beneficial to the station, they may choose to introduce it to the rest of the crew."
VR edit end*/

//////////////////////////////////
//			Roboticist
//////////////////////////////////
/datum/job/roboticist
	title = "Roboticist"
	flag = ROBOTICIST
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Research Director"
	selection_color = "#633D63"
	economic_modifier = 5
	access = list(access_robotics, access_tox, access_tox_storage, access_tech_storage, access_morgue, access_research, access_tox) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_access = list(access_robotics, access_tech_storage, access_morgue, access_research, access_tox) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_player_age = 7

	outfit_type = /decl/hierarchy/outfit/job/science/roboticist
	job_description = "A Roboticist maintains and repairs the station's synthetics, including crew with prosthetic limbs. \
						They can also assist the station by producing simple robots and even pilotable exosuits."
	alt_titles = list("Biomechanical Engineer" = /datum/alt_title/biomech, "Mechatronic Engineer" = /datum/alt_title/mech_tech)

// Roboticist Alt Titles
/datum/alt_title/biomech
	title = "Biomechanical Engineer"
	title_blurb = "A Biomechanical Engineer primarily works on prosthetics, and the organic parts attached to them. They may have some \
					knowledge of the relatively simple surgical procedures used in making cyborgs and attaching prosthesis."

/datum/alt_title/mech_tech
	title = "Mechatronic Engineer"
	title_blurb = "A Mechatronic Engineer focuses on the construction and maintenance of Exosuits, and should be well versed in their use. \
					They may also be called upon to work on synthetics and prosthetics, if needed."