//Food

//////////////////////////////////
//			Bartender
//////////////////////////////////

/datum/job/bartender
	title = "Bartender"
	flag = BARTENDER
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	idtype = /obj/item/card/id/civilian/bartender
	pto_type = PTO_CIVILIAN
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_bar)

	outfit_type = /decl/hierarchy/outfit/job/service/bartender
	job_description = "A Bartender mixes drinks for the crew. They generally have permission to charge for drinks or deny service to unruly patrons."
	alt_titles = list(
		"Barista" = /datum/alt_title/barista,
		"Barkeeper" = /datum/alt_title/barkeeper,
		"Barmaid" = /datum/alt_title/barmaid
	)

/datum/alt_title/barkeeper
	title = "Barkeeper"

/datum/alt_title/barmaid
	title = "Barmaid"

// Bartender Alt Titles
/datum/alt_title/barista
	title = "Barista"
	title_blurb = "A barista mans the Cafe, serving primarily non-alcoholic drinks to the crew. They generally have permission to charge for drinks \
					or deny service to unruly patrons."
	title_outfit = /decl/hierarchy/outfit/job/service/bartender/barista

//////////////////////////////////
//			   Chef
//////////////////////////////////

/datum/job/chef
	title = "Chef"
	flag = CHEF
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	pto_type = PTO_CIVILIAN
	idtype = /obj/item/card/id/civilian/chef
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_kitchen)

	outfit_type = /decl/hierarchy/outfit/job/service/chef
	job_description = "A Chef cooks food for the crew. They generally have permission to charge for food or deny service to unruly diners."
	alt_titles = list(
		"Cook" = /datum/alt_title/cook,
		"Sous-chef" = /datum/alt_title/souschef,
		"Kitchen Worker" = /datum/alt_title/kitchen_worker,
		"Line Cook" = /datum/alt_title/cook/line
	)

/datum/alt_title/souschef
	title = "Sous-chef"

/datum/alt_title/kitchen_worker
	title = "Kitchen Worker"
	title_blurb = "A Kitchen Worker has the same duties, though they may be less experienced."

/datum/alt_title/cook/line
	title = "Line Cook"

// Chef Alt Titles
/datum/alt_title/cook
	title = "Cook"
	title_blurb = "A Cook has the same duties, though they may be less experienced."

//////////////////////////////////
//			Botanist
//////////////////////////////////

/datum/job/hydro
	title = "Botanist"
	flag = BOTANIST
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	pto_type = PTO_CIVILIAN
	pto_type = PTO_CIVILIAN
	idtype = /obj/item/card/id/civilian/botanist
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_hydroponics)

	outfit_type = /decl/hierarchy/outfit/job/service/gardener
	job_description = "A Botanist grows plants for the Chef and Bartender."
	alt_titles = list("Gardener" = /datum/alt_title/gardener)

//Botanist Alt Titles
/datum/alt_title/gardener
	title = "Gardener"
	title_blurb = "A Gardener may be less professional than their counterparts, and are more likely to tend to the public gardens if they aren't needed elsewhere."


//Service
//////////////////////////////////
//			Janitor
//////////////////////////////////
/datum/job/janitor
	title = "Janitor"
	flag = JANITOR
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	pto_type = PTO_CIVILIAN
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	idtype = /obj/item/card/id/civilian/janitor
	access = list(access_janitor, access_maint_tunnels)
	minimal_access = list(access_janitor, access_maint_tunnels)

	outfit_type = /decl/hierarchy/outfit/job/service/janitor
	job_description = "A Janitor keeps the station clean, as long as it doesn't interfere with active crime scenes."
	alt_titles = list(
		"Custodian" = /datum/alt_title/custodian,
		"Sanitation Technician" = /datum/alt_title/janitor/tech,
		"Viscera Cleaner" = /datum/alt_title/janitor/gorecleaner,
		"Maid" = /datum/alt_title/janitor/maid
		)

// Janitor Alt Titles
/datum/alt_title/custodian
	title = "Custodian"

/datum/alt_title/janitor/tech
	title = "Sanitation Technician"

/datum/alt_title/janitor/gorecleaner
	title = "Viscera Cleaner"

/datum/alt_title/janitor/maid
	title = "Maid"

//More or less assistants
//////////////////////////////////
//			Librarian
//////////////////////////////////
/datum/job/librarian
	title = "Librarian"
	flag = LIBRARIAN
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	pto_type = PTO_CIVILIAN
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	idtype = /obj/item/card/id/civilian/librarian
	access = list(access_library, access_maint_tunnels)
	minimal_access = list(access_library)

	outfit_type = /decl/hierarchy/outfit/job/librarian
	job_description = "The Librarian curates the book selection in the Library, so the crew might enjoy it."
	alt_titles = list(
		"Journalist" = /datum/alt_title/journalist,
		"Reporter" =  /datum/alt_title/reporter,
		"Writer" = /datum/alt_title/writer,
		"Historian" = /datum/alt_title/historian,
		"Archivist" = /datum/alt_title/archivist,
		"Professor" = /datum/alt_title/professor,
		"Academic" = /datum/alt_title/academic,
		"Philosopher" = /datum/alt_title/philosopher
	)

/datum/alt_title/librarian/reporter
	title = "Reporter"
	title_blurb = "Although NanoTrasen's official Press outlet is managed by Central Command, they often hire freelance journalists for local coverage."
	title_outfit = /decl/hierarchy/outfit/job/librarian/reporter

// Librarian Alt Titles
/datum/alt_title/journalist
	title = "Journalist"
	title_blurb = "The Journalist uses the Library as a base of operations, from which they can report the news and goings-on on the station with their camera."

/datum/alt_title/writer
	title = "Writer"
	title_blurb = "The Writer uses the Library as a quiet place to write whatever it is they choose to write."

/datum/alt_title/reporter
	title = "Reporter"
	title_blurb = "The Reporter uses the Library as a base of operations, from which they can report the news and goings-on on the station with their camera."

/datum/alt_title/historian
	title = "Historian"
	title_blurb = "The Historian uses the Library as a base of operation to record any important events occuring on station."

/datum/alt_title/archivist
	title = "Archivist"
	title_blurb = "The Archivist uses the Library as a base of operation to record any important events occuring on station."

/datum/alt_title/professor
	title = "Professor"
	title_blurb = "The Professor uses the Library as a base of operations to share their vast knowledge with the crew."

/datum/alt_title/academic
	title = "Academic"
	title_blurb = "The Academic uses the Library as a base of operations to share their vast knowledge with the crew."

/datum/alt_title/philosopher
	title = "Philosopher"
	title_blurb = "The Philosopher uses the Library as a base of operation to ruminate on nature of life and other great questions, and share their opinions with the crew."

//////////////////////////////////
//		Internal Affairs Agent
//////////////////////////////////

//var/global/lawyer = 0//Checks for another lawyer //This changed clothes on 2nd lawyer, both IA get the same dreds.
/datum/job/lawyer
	title = "Internal Affairs Agent"
	flag = LAWYER
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#515151"
	idtype = /obj/item/card/id/civilian/internal_affairs_agent
	economic_power = 7
	access = list(access_lawyer, access_sec_doors, access_maint_tunnels, access_heads)
	minimal_access = list(access_lawyer, access_sec_doors, access_heads)
	minimal_player_age = 7

	outfit_type = /decl/hierarchy/outfit/job/internal_affairs_agent
	alt_titles = list("Regulatory Affairs Agent" = /datum/alt_title/iaa/regulator)
	job_description = "An Internal Affairs Agent makes sure that the crew is following Standard Operating Procedure. They also \
						handle complaints against crew members, and can have issues brought to the attention of Central Command, \
						assuming their paperwork is in order."

/datum/alt_title/iaa/regulator
	title = "Regulatory Affairs Agent"

/*
/datum/job/lawyer/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(H)
*/

//////////////////////////////////
//			Entertainer
//////////////////////////////////

/datum/job/entertainer
	title = "Entertainer"
	flag = ENTERTAINER
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	access = list(access_entertainment)
	minimal_access = list(access_entertainment)
	pto_type = PTO_CIVILIAN

	outfit_type = /decl/hierarchy/outfit/job/assistant
	job_description = "An entertainer does just that, entertains! Put on plays, play music, sing songs, tell stories, or read your favorite fanfic."
	alt_titles = list(
		"Performer" = /datum/alt_title/performer,
		"Musician" = /datum/alt_title/musician,
		"Stagehand" = /datum/alt_title/stagehand,
		"Actor" = /datum/alt_title/actor,
		"Dancer" = /datum/alt_title/dancer,
		"Singer" = /datum/alt_title/singer,
		"Magician" = /datum/alt_title/magician,
		"Comedian" = /datum/alt_title/comedian,
		"Tragedian" = /datum/alt_title/tragedian
		)

// Entertainer Alt Titles
/datum/alt_title/actor
	title = "Actor"
	title_blurb = "An Actor is someone who acts out a role! Whatever sort of character it is, get into it and impress people with power of comedy and tragedy!"

/datum/alt_title/performer
	title = "Performer"
	title_blurb = "A Performer is someone who performs! Whatever sort of performance will come to your mind, the world's a stage!"

/datum/alt_title/musician
	title = "Musician"
	title_blurb = "A Musician is someone who makes music with a wide variety of musical instruments!"

/datum/alt_title/stagehand
	title = "Stagehand"
	title_blurb = "A Stagehand typically performs everything the rest of the entertainers don't. Operate lights, shutters, windows, or narrate through your voicebox!"

/datum/alt_title/dancer
	title = "Dancer"
	title_blurb = "A Dancer is someone who impresses people through power of their own body! From waltz to breakdance, as long as crowd as cheering!"

/datum/alt_title/singer
	title = "Singer"
	title_blurb = "A Singer is someone with gift of melodious voice! Impress people with your vocal range!"

/datum/alt_title/magician
	title = "Magician"
	title_blurb = "A Magician is someone who awes those around them with impossible! Show off your repertoire of magic tricks, while keeping the secret hidden!"

/datum/alt_title/comedian
	title = "Comedian"
	title_blurb = "A Comedian will focus on making people laugh with the power of wit! Telling jokes, stand-up comedy, you are here to make others smile!"

/datum/alt_title/tragedian
	title = "Tragedian"
	title_blurb = "A Tragedian will focus on making people think about life and world around them! Life is a tragedy, and who's better to convey its emotions than you?"
