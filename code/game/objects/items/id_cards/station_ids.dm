/obj/item/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access across the station."
	icon_state = "generic-nt"
	item_state = "card-id"
	item_state_slots = list(
		SLOT_ID_WORN_ID = "id"
	)

	/// Access levels held by this card.
	var/list/access = list()
	/// The name registered_name on the card.
	var/registered_name = "Unknown"
	slot_flags = SLOT_ID | SLOT_EARS

	var/age = "\[UNSET\]"
	var/blood_type = "\[UNSET\]"
	var/dna_hash = "\[UNSET\]"
	var/fingerprint_hash = "\[UNSET\]"
	var/sex = "\[UNSET\]"
	var/icon/front
	var/icon/side

	var/primary_color = rgb(0,0,0) // Obtained by eyedroppering the stripe in the middle of the card
	var/secondary_color = rgb(0,0,0) // Likewise for the oval in the top-left corner

	var/datum/job/job_access_type = /datum/job/station/assistant    // Job type to acquire access rights from, if any

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job
	var/dorm = 0			// determines if this ID has claimed a dorm already

	var/mining_points = 0	// For redeeming at mining equipment vendors
	var/survey_points = 0	// For redeeming at explorer equipment vendors.
	var/engineer_points = 0	// For redeeming at engineering equipment vendors

/obj/item/card/id/examine(mob/user)
	. = ..()
	show(user)

/obj/item/card/id/examine_more(mob/user)
	. = ..()
	var/list/msg = list(SPAN_NOTICE("<i>You examine [src] closer, and note the following...</i>"))

	if(mining_points)
		msg += "There's [mining_points] mining equipment redemption point\s loaded onto this card."
	return msg


/obj/item/card/id/proc/prevent_tracking()
	return 0

/obj/item/card/id/proc/show(mob/user as mob)
	if(front && side)
		user << browse_rsc(front, "front.png")
		user << browse_rsc(side, "side.png")
	var/datum/browser/popup = new(user, "idcard", name, 600, 250)
	popup.set_content(dat())
	popup.open()
	return

/obj/item/card/id/update_name()
	. = ..()
	name = "[src.registered_name]'s ID Card ([src.assignment])"

/obj/item/card/id/proc/set_id_photo(var/mob/M)
	var/icon/charicon = cached_character_icon(M)
	front = icon(charicon,dir = SOUTH)
	side = icon(charicon,dir = WEST)

/mob/proc/set_id_info(var/obj/item/card/id/id_card)
	id_card.age = 0
	id_card.registered_name		= real_name
	id_card.sex 				= capitalize(gender)
	id_card.set_id_photo(src)

	if(dna)
		id_card.blood_type		= dna.b_type
		id_card.dna_hash		= dna.unique_enzymes
		id_card.fingerprint_hash= md5(dna.uni_identity)
	id_card.update_name()

/mob/living/carbon/human/set_id_info(var/obj/item/card/id/id_card)
	..()
	id_card.age = age

/obj/item/card/id/proc/dat()
	var/dat = ("<table><tr><td>")
	dat += text("Name: []</A><BR>", registered_name)
	dat += text("Sex: []</A><BR>\n", sex)
	dat += text("Age: []</A><BR>\n", age)
	dat += text("Rank: []</A><BR>\n", assignment)
	dat += text("Fingerprint: []</A><BR>\n", fingerprint_hash)
	dat += text("Blood Type: []<BR>\n", blood_type)
	dat += text("DNA Hash: []<BR><BR>\n", dna_hash)
	if(front && side)
		dat +="<td align = center valign = top>Photo:<br><img src=front.png height=80 width=80 border=4><img src=side.png height=80 width=80 border=4></td>"
	dat += "</tr></table>"
	return dat

/obj/item/card/id/attack_self(mob/user as mob)
	user.visible_message("\The [user] shows you: [icon2html(thing = src, target = world)] [src.name]. The assignment on the card: [src.assignment]",\
		"You flash your ID card: [icon2html(thing = src, target = user)] [src.name]. The assignment on the card: [src.assignment]")

	src.add_fingerprint(user)
	return

/obj/item/card/id/GetAccess()
	return access.Copy()

/obj/item/card/id/GetID()
	return src

/obj/item/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	to_chat(usr, "[icon2html(thing = src, target = usr)] [src.name]: The current assignment on the card is [src.assignment].")
	to_chat(usr, "The blood type on the card is [blood_type].")
	to_chat(usr, "The DNA hash on the card is [dna_hash].")
	to_chat(usr, "The fingerprint hash on the card is [fingerprint_hash].")

/obj/item/card/id/Initialize(mapload)
	. = ..()
	var/datum/job/J = SSjob.get_job(rank)
	if(J)
		access = J.get_access()

/obj/item/card/id/silver
	name = "command identification card"
	desc = "A silver card which shows honour and dedication."
	icon_state = "silver-id"
	item_state = "silver_id"

/obj/item/card/id/silver/secretary
	name = "secretary ID"
	assignment = "Command Secretary"
	rank = "Command Secretary"
	job_access_type = /datum/job/station/command_secretary

/obj/item/card/id/silver/hop
	name = "\improper HoP ID"
	assignment = "Head of Personnel"
	rank = "Head of Personnel"
	desc = "A card which represents the balance between those that serve and those that are served."
	job_access_type = /datum/job/station/head_of_personnel

/obj/item/card/id/gold
	name = "gold identification card"
	desc = "A golden card which shows power and might."
	icon_state = "gold-id"
	item_state = "gold_id"
	preserve_item = 1

/obj/item/card/id/gold/captain
	name = "\improper Facility Director's ID"
	assignment = "Facility Director"
	rank = "Facility Director"
	job_access_type = /datum/job/station/captain

/obj/item/card/id/gold/captain/spare
	name = "\improper Facility Director's spare ID"
	desc = "The spare ID of the High Lord himself."
	registered_name = "Facility Director"
	icon_state = "gold-id-alternate"
	job_access_type = /datum/job/station/captain

/obj/item/card/id/synthetic
	name = "\improper Synthetic ID"
	desc = "Access module for NanoTrasen Synthetics"
	icon_state = "id-robot"
	item_state = "idgreen"
	assignment = "Synthetic"

/obj/item/card/id/synthetic/Initialize(mapload)
	. = ..()
	access = get_all_station_access().Copy() + access_synth

/obj/item/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Central Command."
	icon_state = "cc-id"
	registered_name = "Central Command"
	assignment = "General"

/obj/item/card/id/centcom/Initialize(mapload)
	. = ..()
	access = get_all_centcom_access().Copy()

/obj/item/card/id/centcom/station/Initialize(mapload)
	. = ..()
	access |= get_all_station_access()

/obj/item/card/id/centcom/vip
	name = "\improper V.I.P. ID"
	desc = "An ID given to someone whose fingernail is probably worth more than you."
	icon_state = "vip-id"
	registered_name = "Very Important Person"

/obj/item/card/id/centcom/ERT
	name = "\improper Emergency Response Team ID"
	assignment = "Emergency Response Team"
	icon_state = "ert-id"

/obj/item/card/id/centcom/ERT/Initialize(mapload)
	. = ..()
	access |= get_all_station_access()

/obj/item/card/id/centcom/ERT/PARA
	name = "\improper PARA ID"
	assignment = "Paracausal Anomaly Response Agent"
	icon_state = "ert-id"

/obj/item/card/id/centcom/ERT/PARA/Initialize(mapload)
	. = ..()
	access |= get_all_station_access()

// Department-flavor IDs
/obj/item/card/id/medical
	name = "medical identification card"
	desc = "A card issued to station medical staff."
	icon_state = "medical-id"
	primary_color = rgb(189,237,237)
	secondary_color = rgb(223,255,255)

/obj/item/card/id/medical/doctor
	name = "doctor ID"
	assignment = "Medical Doctor"
	rank = "Medical Doctor"
	job_access_type = /datum/job/station/doctor

/obj/item/card/id/medical/chemist
	name = "chemist ID"
	assignment = "Chemist"
	rank = "Chemist"
	job_access_type = /datum/job/station/chemist

/obj/item/card/id/medical/geneticist
	name = "geneticist ID"
	assignment = "Geneticist"
	rank = "Geneticist"
	job_access_type = /datum/job/station/doctor	//geneticist

/obj/item/card/id/medical/psychiatrist
	name = "psychiatrist ID"
	assignment = "Psychiatrist"
	rank = "Psychiatrist"
	job_access_type = /datum/job/station/psychiatrist

/obj/item/card/id/medical/paramedic
	name = "paramedic ID"
	assignment = "Paramedic"
	rank = "Paramedic"
	job_access_type = /datum/job/station/paramedic

/obj/item/card/id/medical/head
	name = "\improper CMO ID"
	desc = "A card which represents care and compassion."
	primary_color = rgb(189,237,237)
	secondary_color = rgb(255,223,127)
	assignment = "Chief Medical Officer"
	rank = "Chief Medical Officer"
	job_access_type = /datum/job/station/chief_medical_officer

/obj/item/card/id/security
	name = "security identification card"
	desc = "A card issued to station security staff."
	icon_state = "security-id"
	primary_color = rgb(189,47,0)
	secondary_color = rgb(223,127,95)

/obj/item/card/id/security/officer
	name = "officer ID"
	assignment = "Security Officer"
	rank = "Security Officer"
	job_access_type = /datum/job/station/officer

/obj/item/card/id/security/detective
	name = "detective ID"
	assignment = "Detective"
	rank = "Detective"
	job_access_type = /datum/job/station/detective

/obj/item/card/id/security/warden
	name = "warden ID"
	assignment = "Warden"
	rank = "Warden"
	job_access_type = /datum/job/station/warden

/obj/item/card/id/security/head
	name = "\improper HoS ID"
	desc = "A card which represents honor and protection."
	primary_color = rgb(189,47,0)
	secondary_color = rgb(255,223,127)
	assignment = "Head of Security"
	rank = "Head of Security"
	job_access_type = /datum/job/station/head_of_security

/obj/item/card/id/engineering
	name = "engineering identification card"
	desc = "A card issued to station engineering staff."
	icon_state = "engineering-id"
	primary_color = rgb(189,94,0)
	secondary_color = rgb(223,159,95)

/obj/item/card/id/engineering/engineer
	name = "engineer ID"
	assignment = "Station Engineer"
	rank = "Station Engineer"
	job_access_type = /datum/job/station/engineer

/obj/item/card/id/engineering/atmos
	name = "atmospherics ID"
	assignment = "Atmospheric Technician"
	rank = "Atmospheric Technician"
	job_access_type = /datum/job/station/atmos

/obj/item/card/id/engineering/head
	name = "\improper CE ID"
	desc = "A card which represents creativity and ingenuity."
	primary_color = rgb(189,94,0)
	secondary_color = rgb(255,223,127)
	assignment = "Chief Engineer"
	rank = "Chief Engineer"
	job_access_type = /datum/job/station/chief_engineer

/obj/item/card/id/science
	name = "science identification card"
	desc = "A card issued to station science staff."
	icon_state = "science-id"
	primary_color = rgb(142,47,142)
	secondary_color = rgb(191,127,191)

/obj/item/card/id/science/scientist
	name = "scientist ID"
	assignment = "Scientist"
	rank = "Scientist"
	job_access_type = /datum/job/station/scientist

/obj/item/card/id/science/xenobiologist
	name = "xenobiologist ID"
	assignment = "Xenobiologist"
	rank = "Xenobiologist"
	job_access_type = /datum/job/station/scientist // /datum/job/station/xenobiologist

/obj/item/card/id/science/roboticist
	name = "roboticist ID"
	assignment = "Roboticist"
	rank = "Roboticist"
	job_access_type = /datum/job/station/roboticist

/obj/item/card/id/science/head
	name = "\improper RD ID"
	desc = "A card which represents knowledge and reasoning."
	primary_color = rgb(142,47,142)
	secondary_color = rgb(255,223,127)
	assignment = "Research Director"
	rank = "Research Director"
	job_access_type = /datum/job/station/research_director

/obj/item/card/id/cargo
	name = "cargo identification card"
	desc = "A card issued to station cargo staff."
	icon_state = "cargo-id"
	primary_color = rgb(142,94,0)
	secondary_color = rgb(191,159,95)

/obj/item/card/id/cargo/cargo_tech
	name = "cargo ID"
	assignment = "Cargo Technician"
	rank = "Cargo Technician"
	job_access_type = /datum/job/station/cargo_tech

/obj/item/card/id/cargo/mining
	name = "mining ID"
	assignment = "Shaft Miner"
	rank = "Shaft Miner"
	job_access_type = /datum/job/station/mining

/obj/item/card/id/cargo/head
	name = "\improper Quartermaster's ID"
	desc = "A card which represents service and planning."
	primary_color = rgb(142,94,0)
	secondary_color = rgb(255,223,127)
	assignment = "Quartermaster"
	rank = "Quartermaster"
	job_access_type = /datum/job/station/quartermaster

/obj/item/card/id/assistant
	assignment = USELESS_JOB
	rank = USELESS_JOB
	job_access_type = /datum/job/station/assistant

/obj/item/card/id/civilian
	name = "civilian identification card"
	desc = "A card issued to station civilian staff."
	icon_state = "civilian-id"
	primary_color = rgb(0,94,142)
	secondary_color = rgb(95,159,191)
	assignment = "Civilian"
	rank = "Assistant"
	job_access_type = /datum/job/station/assistant

/obj/item/card/id/civilian/bartender
	name = "bartender ID"
	assignment = "Bartender"
	rank = "Bartender"
	job_access_type = /datum/job/station/bartender

/obj/item/card/id/civilian/botanist
	name = "botanist ID"
	assignment = "Botanist"
	rank = "Botanist"
	job_access_type = /datum/job/station/hydro

/obj/item/card/id/civilian/chaplain
	name = "chaplain ID"
	assignment = "Chaplain"
	rank = "Chaplain"
	job_access_type = /datum/job/station/chaplain

/obj/item/card/id/civilian/chef
	name = "chef ID"
	assignment = "Chef"
	rank = "Chef"
	job_access_type = /datum/job/station/chef

/obj/item/card/id/civilian/internal_affairs_agent
	name = "internal affairs ID"
	assignment = "Internal Affairs Agent"
	rank = "Internal Affairs Agent"
	job_access_type = /datum/job/station/lawyer

/obj/item/card/id/civilian/janitor
	name = "janitor ID"
	assignment = "Janitor"
	rank = "Janitor"
	job_access_type = /datum/job/station/janitor

/obj/item/card/id/civilian/librarian
	name = "librarian ID"
	assignment = "Librarian"
	rank = "Librarian"
	job_access_type = /datum/job/station/librarian

/obj/item/card/id/civilian/clown
	name = "clown ID"
	assignment = "Clown"
	rank = "Clown"
	job_access_type = /datum/job/station/clown

/obj/item/card/id/civilian/mime
	name = "mime ID"
	assignment = "Mime"
	rank = "Mime"
	job_access_type = /datum/job/station/mime

/obj/item/card/id/civilian/head //This is not the HoP. There's no position that uses this right now.
	name = "\improper Services Officer ID"
	desc = "A card which represents common sense and responsibility."
	primary_color = rgb(0,94,142)
	secondary_color = rgb(255,223,127)

/obj/item/card/id/external
	name = "external identification card"
	desc = "An identification card of some sort. It does not look like it is issued by NT."
	icon_state = "generic"
	primary_color = rgb(142,94,0)
	secondary_color = rgb(191,159,95)

/obj/item/card/id/external/merchant //created so that when assigning the outfit of merchant, it assigns a working ID
	name = "identity chit"
	desc = "A mass-market access chit used in many non-Corporate environments as a form of identification."
	icon_state = "chit"
	primary_color = rgb(142,94,0)
	secondary_color = rgb(191,159,95)
	access = list(160, 13)
	var/random_color = TRUE

/obj/item/card/id/external/merchant/Initialize(mapload)
	. = ..()
	if(random_color)
		switch(pick("brown","green","red","purple","white","orange","blue"))
			if ("brown")
				icon_state = "chit"
			if ("green")
				icon_state = "chit_green"
			if ("red")
				icon_state = "chit_red"
			if ("purple")
				icon_state = "chit_purple"
			if ("white")
				icon_state = "chit_white"
			if ("orange")
				icon_state = "chit_orange"
			if ("blue")
				icon_state = "chit_blue"

/obj/item/card/id/external/pirate
	name = "black market identity chit"
	desc = "A mass-market access chit used in many non-Corporate environments as a form of identification. It appears to have been illegally modified."
	icon_state = "pirate"
	primary_color = rgb(17, 1, 1)
	secondary_color = rgb(149, 152, 153)
	access = list(168)

/obj/item/card/id/medical/sar
	assignment = "Field Medic"
	rank = "Field Medic"
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)
	job_access_type = /datum/job/station/field_medic

/obj/item/card/id/explorer
	name = "identification card"
	desc = "A card issued to station exploration staff."
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)

/obj/item/card/id/explorer/pilot
	assignment = "Pilot"
	rank = "Pilot"
	job_access_type = /datum/job/station/pilot

/obj/item/card/id/explorer/explorer
	assignment = "Explorer"
	rank = "Explorer"
	job_access_type = /datum/job/station/explorer

/obj/item/card/id/explorer/head
	name = "identification card"
	desc = "A card which represents discovery of the unknown."
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)


/obj/item/card/id/explorer/head/pathfinder
	assignment = "Pathfinder"
	rank = "Pathfinder"
	job_access_type = /datum/job/station/pathfinder
