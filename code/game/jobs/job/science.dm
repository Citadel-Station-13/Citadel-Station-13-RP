//////////////////////////////////
//		Research Director
//////////////////////////////////
/datum/job/rd
	title = "Research Director"
	flag = RD
	departments_managed = list(DEPARTMENT_RESEARCH)
	departments = list(DEPARTMENT_RESEARCH, DEPARTMENT_COMMAND)
	sorting_order = 2
	disallow_jobhop = TRUE
	pto_type = PTO_SCIENCE
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Facility Director"
	selection_color = "#AD6BAD"
	idtype = /obj/item/card/id/science/head
	req_admin_notify = 1
	economic_power = 15
	access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
						access_tox_storage, access_teleporter, access_sec_doors,
						access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
						access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network)
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
						access_tox_storage, access_teleporter, access_sec_doors,
						access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
						access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network)

	minimum_character_age = 25
	minimal_player_age = 14
	ideal_character_age = 50

	outfit_type = /decl/hierarchy/outfit/job/science/rd
	job_description = "The Research Director manages and maintains the Research department. They are required to ensure the safety of the entire crew, \
						at least with regards to anything occuring in the Research department, and to inform the crew of any disruptions that \
						might originate from Research. The Research Director often has at least passing knowledge of most of the Research department, but \
						are encouraged to allow their staff to perform their own duties."
	alt_titles = list(
		"Research Supervisor" = /datum/alt_title/research_supervisor,
		"Head of Development" = /datum/alt_title/head_of_development,
		"Head Scientist" = /datum/alt_title/head_scientist
		)

// Research Director Alt Titles
/datum/alt_title/research_supervisor
	title = "Research Supervisor"

/datum/alt_title/head_of_development
	title = "Head of Development"

/datum/alt_title/head_scientist
	title = "Head Scientist"

//////////////////////////////////
//			Scientist
//////////////////////////////////
/datum/job/scientist
	title = "Scientist"
	flag = SCIENTIST
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 7
	spawn_positions = 5
	supervisors = "the Research Director"
	selection_color = "#633D63"
	idtype = /obj/item/card/id/science/scientist
	economic_power = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch, access_xenobotany)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch, access_xenobiology, access_xenobotany)

	minimal_player_age = 14

	outfit_type = /decl/hierarchy/outfit/job/science/scientist
	pto_type = PTO_SCIENCE
	job_description = "A Scientist is a generalist working in the Research department, with general knowledge of the scientific process, as well as \
						the principles and requirements of Research and Development. They may also formulate experiments of their own devising, if \
						they find an appropriate topic."
	alt_titles = list(
		"Junior Scientist" = /datum/alt_title/scientist/junior,
		"Lab Assistant" = /datum/alt_title/scientist/assistant,
		"Researcher" = /datum/alt_title/researcher,
		"Xenoarchaeologist" = /datum/alt_title/xenoarch,
		"Anomalist" = /datum/alt_title/anomalist, \
		"Phoron Researcher" = /datum/alt_title/phoron_research,
		"Circuit Designer" = /datum/alt_title/scientist/circuit,
		"Research Field Technician" = /datum/alt_title/scientist/fieldtech,
		"Xenobotanist" = /datum/alt_title/scientist/xenobotanist,
		"Xenobiologist" = /datum/alt_title/scientist/xenobiologist
		)

// Scientist Alt Titles
/datum/alt_title/scientist/junior
	title = "Junior Scientist"
	title_blurb = "A Junior Scientist is a lower-level member of research staff, whose main purpose is to help scientists with their specialized work in more menial fashion, while also \
					learning the specializations in process."

/datum/alt_title/scientist/assistant
	title = "Lab Assistant"
	title_blurb = "A Lab Assistant is a lower-level member of research staff, whose main purpose is to help scientists with their specialized work in more menial fashion, while also \
					learning the specializations in process."

/datum/alt_title/researcher
	title = "Researcher"

/datum/alt_title/xenoarch
	title = "Xenoarchaeologist"
	title_blurb = "A Xenoarchaeologist enters digsites in search of artifacts of alien origin. These digsites are frequently in vacuum or other inhospitable \
					locations, and as such a Xenoarchaeologist should be prepared to handle hostile evironmental conditions."

/datum/alt_title/anomalist
	title = "Anomalist"
	title_blurb = "An Anomalist is a Scientist whose expertise is analyzing alien artifacts. They are familar with the most common methods of testing artifact \
					function. They work closely with Xenoarchaeologists, or Miners, if either role is present."

/datum/alt_title/phoron_research
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
	title_outfit = /decl/hierarchy/outfit/job/science/xenobiologist

/datum/alt_title/scientist/xenobotanist
	title = "Xenobotanist"
	title_blurb = "A Xenobotanist grows and cares for a variety of abnormal, custom made, and frequently dangerous plant life. When the products of these plants \
					are both safe and beneficial to the station, they may choose to introduce it to the rest of the crew."
	title_outfit = /decl/hierarchy/outfit/job/science/xenobiologist

/* Demoted to alt title for now
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
	pto_type = PTO_SCIENCE
	economic_power = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_hydroponics, access_tox)
	minimal_access = list(access_research, access_xenobiology, access_hydroponics, access_tox_storage,access_tox)

	minimal_player_age = 14

	outfit_type = /decl/hierarchy/outfit/job/science/xenobiologist
	job_description = "A Xenobiologist studies esoteric lifeforms, usually in the relative safety of their lab. They attempt to find ways to benefit \
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

//////////////////////////////////
//			Xenobotanist
//////////////////////////////////
/datum/job/xenobotanist
	title = "Xenobotanist"
	flag = XENOBOTANIST
	departments = list(DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Research Director"
	selection_color = "#633D63"
	economic_power = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobotany, access_hydroponics)
	minimal_access = list(access_research, access_xenobotany, access_hydroponics, access_tox_storage)
	pto_type = PTO_SCIENCE

	minimal_player_age = 14

	outfit_type = /decl/hierarchy/outfit/job/science/xenobiologist
	job_description = "A Xenobotanist grows and cares for a variety of abnormal, custom made, and frequently dangerous plant life. When the products of these plants \
					are both safe and beneficial to the station, they may choose to introduce it to the rest of the crew."
	alt_titles = list(
		"Xenohydroponicist" = /datum/alt_title/xenohydroponicist,
		"Xenoflorist" = /datum/alt_title/xenoflorist
		)

/datum/alt_title/xenoflorist
	title = "Xenoflorist"

/datum/alt_title/xenohydroponicist
	title = "Xenohydroponicist"
*/

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
	economic_power = 5
	pto_type = PTO_SCIENCE
	access = list(access_robotics, access_tox, access_tox_storage, access_tech_storage, access_morgue, access_research, access_tox) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_access = list(access_robotics, access_tech_storage, access_morgue, access_research, access_tox) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_player_age = 7

	outfit_type = /decl/hierarchy/outfit/job/science/roboticist
	job_description = "A Roboticist maintains and repairs the station's synthetics, including crew with prosthetic limbs. \
						They can also assist the station by producing simple robots and even pilotable exosuits."
	alt_titles = list(
		"Biomechanical Engineer" = /datum/alt_title/biomech,
		"Mechatronic Engineer" = /datum/alt_title/mech_tech,
		"Prosthetists" = /datum/alt_title/prosthetists
		)

// Roboticist Alt Titles
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
