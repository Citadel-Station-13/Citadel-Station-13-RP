/datum/job/station/scientist
	title = "Scientist"
	flag = SCIENTIST
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	total_positions = 7
	spawn_positions = 5
	supervisors = "the Research Director"
	selection_color = "#633D63"
	idtype = /obj/item/card/id/science/scientist
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch, access_xenobotany)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch, access_xenobiology, access_xenobotany)

	minimal_player_age = 14

	outfit_type = /datum/outfit/job/station/scientist
	pto_type = PTO_SCIENCE
	desc = "A Scientist is a generalist working in the Research department, with general knowledge of the scientific process, as well as \
						the principles and requirements of Research and Development. They may also formulate experiments of their own devising, if \
						they find an appropriate topic."
	alt_titles = list(
		"Junior Scientist" = /datum/alt_title/scientist/junior,
		"Lab Assistant" = /datum/alt_title/scientist/assistant,
		"Researcher" = /datum/alt_title/scientist/researcher,
		"Xenoarchaeologist" = /datum/alt_title/scientist/xenoarch,
		"Anomalist" = /datum/alt_title/scientist/anomalist, \
		"Phoron Researcher" = /datum/alt_title/scientist/phoron_research,
		"Circuit Designer" = /datum/alt_title/scientist/circuit,
		"Research Field Technician" = /datum/alt_title/scientist/fieldtech,
		"Xenobotanist" = /datum/alt_title/scientist/xenobotanist,
		"Xenobiologist" = /datum/alt_title/scientist/xenobiologist
		)

/datum/alt_title/scientist/junior
	title = "Junior Scientist"
	title_blurb = "A Junior Scientist is a lower-level member of research staff, whose main purpose is to help scientists with their specialized work in more menial fashion, while also \
					learning the specializations in process."

/datum/alt_title/scientist/assistant
	title = "Lab Assistant"
	title_blurb = "A Lab Assistant is a lower-level member of research staff, whose main purpose is to help scientists with their specialized work in more menial fashion, while also \
					learning the specializations in process."

/datum/alt_title/scientist/researcher
	title = "Researcher"

/datum/alt_title/scientist/xenoarch
	title = "Xenoarchaeologist"
	title_blurb = "A Xenoarchaeologist enters digsites in search of artifacts of alien origin. These digsites are frequently in vacuum or other inhospitable \
					locations, and as such a Xenoarchaeologist should be prepared to handle hostile evironmental conditions."

/datum/alt_title/scientist/anomalist
	title = "Anomalist"
	title_blurb = "An Anomalist is a Scientist whose expertise is analyzing alien artifacts. They are familar with the most common methods of testing artifact \
					function. They work closely with Xenoarchaeologists, or Miners, if either role is present."

/datum/alt_title/scientist/phoron_research
	title = "Phoron Researcher"
	title_blurb = "A Phoron Researcher is a specialist in the practical applications of phoron, and has knowledge of its practical uses and dangers. \
					Many Phoron Researchers are interested in the combustability and explosive properties of gaseous phoron, as well as the specific hazards \
					of working with the substance in that state."

/datum/alt_title/scientist/circuit
	title = "Circuit Designer"
	title_blurb = "A Circuit Designer is a Scientist whose expertise is working with integrated circuits. They are familar with the workings and programming of those devices. \
					They work to create various useful devices using the capabilities of integrated circuitry."

/datum/alt_title/scientist/fieldtech
	title = "Research Field Technician"

/datum/alt_title/scientist/xenobiologist
	title = "Xenobiologist"
	title_blurb = "A Xenobiologist studies esoteric lifeforms, usually in the relative safety of their lab. They attempt to find ways to benefit \
						from the byproducts of these lifeforms, and their main subject at present is the Giant Slime."
	title_outfit = /datum/outfit/job/station/scientist/xenobiologist

/datum/alt_title/scientist/xenobotanist
	title = "Xenobotanist"
	title_blurb = "A Xenobotanist grows and cares for a variety of abnormal, custom made, and frequently dangerous plant life. When the products of these plants \
					are both safe and beneficial to the station, they may choose to introduce it to the rest of the crew."
	title_outfit = /datum/outfit/job/station/scientist/xenobiologist

/datum/outfit/job/station/scientist
	name = OUTFIT_JOB_NAME("Scientist")
	uniform = /obj/item/clothing/under/rank/scientist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science
	l_ear = /obj/item/radio/headset/headset_sci
	shoes = /obj/item/clothing/shoes/white

	id_type = /obj/item/card/id/science/scientist
	pda_type = /obj/item/pda/science
	pda_slot = slot_l_store

	backpack = /obj/item/storage/backpack/toxins
	satchel_one = /obj/item/storage/backpack/satchel/tox
	messenger_bag = /obj/item/storage/backpack/messenger/tox
	dufflebag = /obj/item/storage/backpack/dufflebag/sci

/datum/outfit/job/station/scientist/xenobiologist
	name = OUTFIT_JOB_NAME("Xenobiologist")
	id_type = /obj/item/card/id/science/xenobiologist
