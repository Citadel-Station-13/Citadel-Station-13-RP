/* demoted to alt title
//////////////////////////////////
//			Xenobotanist
//////////////////////////////////
/datum/role/job/station/xenobotanist
	title = "Xenobotanist"
	flag = XENOBOTANIST
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Research Director"
	selection_color = "#633D63"
	additional_access = list(ACCESS_SCIENCE_ROBOTICS, ACCESS_SCIENCE_FABRICATION, ACCESS_SCIENCE_TOXINS, ACCESS_SCIENCE_MAIN, ACCESS_SCIENCE_XENOBOTANY, ACCESS_GENERAL_BOTANY)
	minimal_access = list(ACCESS_SCIENCE_MAIN, ACCESS_SCIENCE_XENOBOTANY, ACCESS_GENERAL_BOTANY, ACCESS_SCIENCE_TOXINS)
	pto_type = PTO_SCIENCE

	minimal_player_age = 14

	outfit_type = /datum/outfit/job/station/science/xenobiologist
	desc = "A Xenobotanist grows and cares for a variety of abnormal, custom made, and frequently dangerous plant life. When the products of these plants \
					are both safe and beneficial to the station, they may choose to introduce it to the rest of the crew."
	alt_titles = list(
		"Xenohydroponicist" = /datum/prototype/alt_title/xenohydroponicist,
		"Xenoflorist" = /datum/prototype/alt_title/xenoflorist
		)

/datum/prototype/alt_title/xenoflorist
	title = "Xenoflorist"

/datum/prototype/alt_title/xenohydroponicist
	title = "Xenohydroponicist"
*/
