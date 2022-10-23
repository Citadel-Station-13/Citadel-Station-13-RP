/* Demoted to alt title for now
//////////////////////////////////
//			Xenobiologist
//////////////////////////////////
/datum/job/station/xenobiologist
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
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_hydroponics, access_tox)
	minimal_access = list(access_research, access_xenobiology, access_hydroponics, access_tox_storage,access_tox)

	minimal_player_age = 14

	outfit_type = /datum/outfit/job/station/science/xenobiologist
	desc = "A Xenobiologist studies esoteric lifeforms, usually in the relative safety of their lab. They attempt to find ways to benefit \
						from the byproducts of these lifeforms, and their main subject at present is the Giant Slime."

	alt_titles = list(
		"Xenozoologist" = /datum/alt_title/xenozoologist,
		"Xenoanthropologist" = /datum/alt_title/xenoanthropologist
		)

// Xenibiologist Alt Titles
/datum/alt_title/xenozoologist
	title = "Xenozoologist"
	title_blurb = "Xenozoologists are well versed in their study of extra-terrestrial life." // Someone make a better blurb please

/datum/alt_title/xenoanthropologist
	title = "Xenoanthropologist"
	title_blurb = "Xenoanthropologist still heavily focuses their study on alien lifeforms, but their specialty leans more towards fellow sapient beings than simple animals."
*/
