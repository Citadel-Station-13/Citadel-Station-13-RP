/* Demoted to alt title for now
//////////////////////////////////
//			Xenobiologist
//////////////////////////////////
/datum/role/job/station/xenobiologist
	title = "Xenobiologist"
	flag = XENOBIOLOGIST
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	total_positions = 3
	spawn_positions = 2
	supervisors = "the Research Director"
	selection_color = "#633D63"
	idtype = /obj/item/card/id/science/xenobiologist
	pto_type = PTO_SCIENCE
	additional_access = list(ACCESS_SCIENCE_ROBOTICS, ACCESS_SCIENCE_FABRICATION, ACCESS_SCIENCE_TOXINS, ACCESS_SCIENCE_MAIN, ACCESS_SCIENCE_XENOBIO, ACCESS_GENERAL_BOTANY, ACCESS_SCIENCE_FABRICATION)
	minimal_access = list(ACCESS_SCIENCE_MAIN, ACCESS_SCIENCE_XENOBIO, ACCESS_GENERAL_BOTANY, ACCESS_SCIENCE_TOXINS,ACCESS_SCIENCE_FABRICATION)

	minimal_player_age = 14

	outfit_type = /datum/outfit/job/station/science/xenobiologist
	desc = "A Xenobiologist studies esoteric lifeforms, usually in the relative safety of their lab. They attempt to find ways to benefit \
						from the byproducts of these lifeforms, and their main subject at present is the Giant Slime."

	alt_titles = list(
		"Xenozoologist" = /datum/prototype/alt_title/xenozoologist,
		"Xenoanthropologist" = /datum/prototype/alt_title/xenoanthropologist
		)

// Xenibiologist Alt Titles
/datum/prototype/alt_title/xenozoologist
	title = "Xenozoologist"
	title_blurb = "Xenozoologists are well versed in their study of extra-terrestrial life." // Someone make a better blurb please

/datum/prototype/alt_title/xenoanthropologist
	title = "Xenoanthropologist"
	title_blurb = "Xenoanthropologist still heavily focuses their study on alien lifeforms, but their specialty leans more towards fellow sapient beings than simple animals."
*/
