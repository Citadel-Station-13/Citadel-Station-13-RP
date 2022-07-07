/datum/job/station/librarian
	title = "Librarian"
	flag = LIBRARIAN
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	total_positions = 2
	spawn_positions = 2
	pto_type = PTO_CIVILIAN
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	idtype = /obj/item/card/id/civilian/librarian
	access = list(access_library, access_maint_tunnels)
	minimal_access = list(access_library)

	outfit_type = /datum/outfit/job/station/librarian
	desc = "The Librarian curates the book selection in the Library, so the crew might enjoy it."
	alt_titles = list(
		"Journalist" = /datum/alt_title/librarian/journalist,
		"Reporter" =  /datum/alt_title/librarian/reporter,
		"Writer" = /datum/alt_title/librarian/writer,
		"Historian" = /datum/alt_title/librarian/historian,
		"Archivist" = /datum/alt_title/librarian/archivist,
		"Professor" = /datum/alt_title/librarian/professor,
		"Academic" = /datum/alt_title/librarian/academic,
		"Philosopher" = /datum/alt_title/librarian/philosopher
	)

/datum/alt_title/librarian/librarian/reporter
	title = "Reporter"
	title_blurb = "Although NanoTrasen's official Press outlet is managed by Central Command, they often hire freelance journalists for local coverage."
	title_outfit = /datum/outfit/job/station/librarian/reporter

// Librarian Alt Titles
/datum/alt_title/librarian/journalist
	title = "Journalist"
	title_blurb = "The Journalist uses the Library as a base of operations, from which they can report the news and goings-on on the station with their camera."

/datum/alt_title/librarian/writer
	title = "Writer"
	title_blurb = "The Writer uses the Library as a quiet place to write whatever it is they choose to write."

/datum/alt_title/librarian/reporter
	title = "Reporter"
	title_blurb = "The Reporter uses the Library as a base of operations, from which they can report the news and goings-on on the station with their camera."

/datum/alt_title/librarian/historian
	title = "Historian"
	title_blurb = "The Historian uses the Library as a base of operation to record any important events occuring on station."

/datum/alt_title/librarian/archivist
	title = "Archivist"
	title_blurb = "The Archivist uses the Library as a base of operation to record any important events occuring on station."

/datum/alt_title/librarian/professor
	title = "Professor"
	title_blurb = "The Professor uses the Library as a base of operations to share their vast knowledge with the crew."

/datum/alt_title/librarian/academic
	title = "Academic"
	title_blurb = "The Academic uses the Library as a base of operations to share their vast knowledge with the crew."

/datum/alt_title/librarian/philosopher
	title = "Philosopher"
	title_blurb = "The Philosopher uses the Library as a base of operation to ruminate on nature of life and other great questions, and share their opinions with the crew."


/datum/outfit/job/station/librarian
	name = OUTFIT_JOB_NAME("Librarian")
	uniform = /obj/item/clothing/under/suit_jacket/red
	l_hand = /obj/item/barcodescanner
	id_type = /obj/item/card/id/civilian/librarian
	pda_type = /obj/item/pda/librarian

/datum/outfit/job/station/librarian/reporter
	name = OUTFIT_JOB_NAME("Reporter")
	uniform = /obj/item/clothing/under/suit_jacket/red
	id_type = /obj/item/card/id/civilian/librarian
	pda_type = /obj/item/pda/librarian
	belt = /obj/item/camera
	backpack_contents = list(/obj/item/clothing/accessory/badge/corporate_tag/press = 1,
							/obj/item/tape_recorder = 1,
							/obj/item/camera_film = 1
							)
