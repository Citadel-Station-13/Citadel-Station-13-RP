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
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobotany, access_hydroponics)
	minimal_access = list(access_research, access_xenobotany, access_hydroponics, access_tox_storage)
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
