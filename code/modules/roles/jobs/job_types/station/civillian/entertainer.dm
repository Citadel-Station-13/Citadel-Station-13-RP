/datum/prototype/role/job/station/entertainer
	id = JOB_ID_ENTERTAINER
	title = "Entertainer"
	flag = ENTERTAINER
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	minimal_access = list(
		ACCESS_GENERAL_ENTERTAINMENT,
	)
	pto_type = PTO_CIVILIAN

	outfit_type = /datum/outfit/job/station/assistant
	desc = "An entertainer does just that, entertains! Put on plays, play music, sing songs, tell stories, or read your favorite fanfic."
	alt_titles = list(
		"Performer" = /datum/prototype/struct/alt_title/entertainer/performer,
		"Musician" = /datum/prototype/struct/alt_title/entertainer/musician,
		"Stagehand" = /datum/prototype/struct/alt_title/entertainer/stagehand,
		"Actor" = /datum/prototype/struct/alt_title/entertainer/actor,
		"Dancer" = /datum/prototype/struct/alt_title/entertainer/dancer,
		"Singer" = /datum/prototype/struct/alt_title/entertainer/singer,
		"Magician" = /datum/prototype/struct/alt_title/entertainer/magician,
		"Comedian" = /datum/prototype/struct/alt_title/entertainer/comedian,
		"Tragedian" = /datum/prototype/struct/alt_title/entertainer/tragedian
		)

// Entertainer Alt Titles
/datum/prototype/struct/alt_title/entertainer/actor
	title = "Actor"
	title_blurb = "An Actor is someone who acts out a role! Whatever sort of character it is, get into it and impress people with power of comedy and tragedy!"

/datum/prototype/struct/alt_title/entertainer/performer
	title = "Performer"
	title_blurb = "A Performer is someone who performs! Whatever sort of performance will come to your mind, the world's a stage!"

/datum/prototype/struct/alt_title/entertainer/musician
	title = "Musician"
	title_blurb = "A Musician is someone who makes music with a wide variety of musical instruments!"

/datum/prototype/struct/alt_title/entertainer/stagehand
	title = "Stagehand"
	title_blurb = "A Stagehand typically performs everything the rest of the entertainers don't. Operate lights, shutters, windows, or narrate through your voicebox!"

/datum/prototype/struct/alt_title/entertainer/dancer
	title = "Dancer"
	title_blurb = "A Dancer is someone who impresses people through power of their own body! From waltz to breakdance, as long as crowd as cheering!"

/datum/prototype/struct/alt_title/entertainer/singer
	title = "Singer"
	title_blurb = "A Singer is someone with gift of melodious voice! Impress people with your vocal range!"

/datum/prototype/struct/alt_title/entertainer/magician
	title = "Magician"
	title_blurb = "A Magician is someone who awes those around them with impossible! Show off your repertoire of magic tricks, while keeping the secret hidden!"

/datum/prototype/struct/alt_title/entertainer/comedian
	title = "Comedian"
	title_blurb = "A Comedian will focus on making people laugh with the power of wit! Telling jokes, stand-up comedy, you are here to make others smile!"

/datum/prototype/struct/alt_title/entertainer/tragedian
	title = "Tragedian"
	title_blurb = "A Tragedian will focus on making people think about life and world around them! Life is a tragedy, and who's better to convey its emotions than you?"
