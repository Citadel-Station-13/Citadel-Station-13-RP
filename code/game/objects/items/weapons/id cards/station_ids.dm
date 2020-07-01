/obj/item/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access across the station."
	icon_state = "generic-nt"
	item_state = "card-id"
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/seromi/id.dmi'
		)
	slot_flags = SLOT_ID | SLOT_EARS
	var/mining_points = 0	// For redeeming at mining equipment vendors
	var/survey_points = 0	// For redeeming at explorer equipment vendors.
	var/access = list()
	var/registered_name = null // The name registered_name on the card
	var/assignment = null	//can be alt title or the actual job

	//Legacy shitcode vars bellow!
	var/age = "\[UNSET\]"
	var/blood_type = "\[UNSET\]"
	var/dna_hash = "\[UNSET\]"
	var/fingerprint_hash = "\[UNSET\]"
	var/sex = "\[UNSET\]"
	var/icon/front
	var/icon/side

	var/primary_color = rgb(0,0,0) // Obtained by eyedroppering the stripe in the middle of the card
	var/secondary_color = rgb(0,0,0) // Likewise for the oval in the top-left corner
	var/datum/job/job_access_type = /datum/job/assistant    // Job type to acquire access rights from, if any
	var/rank = null			//actual job
	var/dorm = FALSE			// determines if this ID has claimed a dorm already.

/obj/item/card/id/Initialize()
	. = ..()
	var/datum/job/J = SSjobs.GetJob(rank)
	if(J)
		access = J.get_access()

/obj/item/card/id/attack_self(mob/user)
	if(Adjacent(user))
		user.visible_message("<span class='notice'>[user] shows you: [icon2html(src, viewers(user))] [src.name]. The assignment on the card: [src.assignment].</span>", \
					"<span class='notice'>You show \the [src.name].</span>")
		add_fingerprint(user)

/obj/item/card/id/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if("assignment","registered_name")
				update_label()

/obj/item/card/id/examine(mob/user)
	. = ..()
	if(in_range(usr, src))
		show(usr)
	if(mining_points)
		. += "There's [mining_points] mining equipment redemption point\s loaded onto this card."
	// if(!bank_support || (bank_support == ID_LOCKED_BANK_ACCOUNT && !registered_account))
	// 	. += "<span class='info'>This ID has no banking support whatsover, must be an older model...</span>"
	// else if(registered_account)
	// 	. += "The account linked to the ID belongs to '[registered_account.account_holder]' and reports a balance of [registered_account.account_balance] cr."
	// 	if(registered_account.account_job)
	// 		var/datum/bank_account/D = SSeconomy.get_dep_account(registered_account.account_job.paycheck_department)
	// 		if(D)
	// 			. += "The [D.account_holder] reports a balance of [D.account_balance] cr."
	// 	. += "<span class='info'>Alt-Click the ID to pull money from the linked account in the form of holochips.</span>"
	// 	. += "<span class='info'>You can insert credits into the linked account by pressing holochips, cash, or coins against the ID.</span>"
	// 	if(registered_account.account_holder == user.real_name)
	// 		. += "<span class='boldnotice'>If you lose this ID card, you can reclaim your account by Alt-Clicking a blank ID card while holding it and entering your account ID number.</span>"
	// else
	// 	. += "<span class='info'>There is no registered account linked to this card. Alt-Click to add one.</span>"

/obj/item/card/id/GetAccess()
	return access

/obj/item/card/id/GetID()
	return src

/*
Usage:
update_label()
	Sets the id name to whatever registered_name and assignment is

update_label("John Doe", "Clowny")
	Properly formats the name and occupation and sets the id name to the arguments
*/
/obj/item/card/id/proc/update_label(newname, newjob)
	if(newname || newjob)
		name = "[(!newname)	? "identification card"	: "[newname]'s ID Card"][(!newjob) ? "" : " ([newjob])"]"
		return

	name = "[(!registered_name)	? "identification card"	: "[registered_name]'s ID Card"][(!assignment) ? "" : " ([assignment])"]"

//About to be depricated, DO NOT USE. Instead, use that one above!
/obj/item/card/id/proc/update_name()
	update_label()

/obj/item/card/id/proc/prevent_tracking()
	return FALSE

/obj/item/card/id/proc/show(mob/user)
	var/dat = "<table><tr><td>"
	dat += "Name: [registered_name]<BR>"
	dat += "Sex: [sex]<BR>"
	dat += "Age: [age]<BR>"
	dat += "Rank: [assignment]<BR>"
	dat += "Fingerprint: [fingerprint_hash]<BR>"
	dat += "Blood Type: [blood_type]<BR>"
	dat += "DNA Hash: [dna_hash]</td><BR><BR>"
	if(front || side)
		dat += "<td align = center valign = top>Photo:<br>"
		if(front)
			dat +="<span style='height:80px;width:80px;border:4px;'>[icon2html(front, user)]</span>"
		if(side)
			dat += "<span style='height:80px;width:80px;border:4px;'>[icon2html(side, user)]</span>"
		dat += "</td>"
	dat += "</tr></table>"

	var/datum/browser/popup = new(user, "idcard", name, 600, 250)
	popup.set_content(dat)
	popup.set_title_image(usr.browse_rsc_icon(icon, icon_state))
	popup.open()
	return

/obj/item/card/id/proc/set_id_photo(mob/M)
	var/icon/charicon = cached_character_icon(M)
	front = icon(charicon, dir = SOUTH)
	side = icon(charicon, dir = WEST)

/mob/proc/set_id_info(obj/item/card/id/id_card)
	id_card.age = 0
	id_card.registered_name		= real_name
	id_card.sex 				= capitalize(gender)
	id_card.set_id_photo(src)

	if(dna)
		id_card.blood_type		= dna.b_type
		id_card.dna_hash		= dna.unique_enzymes
		id_card.fingerprint_hash= md5(dna.uni_identity)
	id_card.update_label()

/mob/living/carbon/human/set_id_info(obj/item/card/id/id_card)
	..()
	id_card.age = age

/obj/item/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	to_chat(usr, "[icon2html(src, usr)] [src.name]: The current assignment on the card is [src.assignment].")
	to_chat(usr, "The blood type on the card is [blood_type].")
	to_chat(usr, "The DNA hash on the card is [dna_hash].")
	to_chat(usr, "The fingerprint hash on the card is [fingerprint_hash].")
	return

/obj/item/card/id/get_worn_icon_state(slot_name)
	if(slot_name == slot_wear_id_str)
		return "id" //Legacy, just how it is. There's only one sprite.
	return ..()

/obj/item/card/id/silver
	name = "command identification card"
	desc = "A silver card which shows honour and dedication."
	icon_state = "silver-id"
	item_state = "silver_id"

/obj/item/card/id/silver/secretary
	name = "secretary ID"
	assignment = "Command Secretary"
	rank = "Command Secretary"
	job_access_type = /datum/job/secretary

/obj/item/card/id/silver/hop
	name = "\improper HoP ID"
	assignment = "Head of Personnel"
	rank = "Head of Personnel"
	desc = "A card which represents the balance between those that serve and those that are served."
	job_access_type = /datum/job/hop

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
	job_access_type = /datum/job/captain

/obj/item/card/id/gold/captain/spare
	name = "\improper Facility Director's spare ID"
	desc = "The spare ID of the High Lord himself."
	registered_name = "Facility Director"
	icon_state = "gold-id-alternate"
	job_access_type = /datum/job/captain

/obj/item/card/id/synthetic
	name = "\improper Synthetic ID"
	desc = "Access module for NanoTrasen Synthetics"
	icon_state = "id-robot"
	item_state = "idgreen"
	assignment = "Synthetic"

/obj/item/card/id/synthetic/Initialize()
	. = ..()
	access |= get_all_station_access()
	access |= access_synth

/obj/item/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Central Command."
	icon_state = "cc-id"
	registered_name = "Central Command"
	assignment = "General"

/obj/item/card/id/centcom/Initialize()
	. = ..()
	access |= get_all_centcom_access() //fuck you whoever made those copy

/obj/item/card/id/centcom/station/Initialize()
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

/obj/item/card/id/centcom/ERT/Initialize()
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
	job_access_type = /datum/job/doctor

/obj/item/card/id/medical/chemist
	name = "chemist ID"
	assignment = "Chemist"
	rank = "Chemist"
	job_access_type = /datum/job/chemist

/obj/item/card/id/medical/geneticist
	name = "geneticist ID"
	assignment = "Geneticist"
	rank = "Geneticist"
	job_access_type = /datum/job/doctor	//geneticist

/obj/item/card/id/medical/psychiatrist
	name = "psychiatrist ID"
	assignment = "Psychiatrist"
	rank = "Psychiatrist"
	job_access_type = /datum/job/psychiatrist

/obj/item/card/id/medical/paramedic
	name = "paramedic ID"
	assignment = "Paramedic"
	rank = "Paramedic"
	job_access_type = /datum/job/paramedic

/obj/item/card/id/medical/head
	name = "\improper CMO ID"
	desc = "A card which represents care and compassion."
	primary_color = rgb(189,237,237)
	secondary_color = rgb(255,223,127)
	assignment = "Chief Medical Officer"
	rank = "Chief Medical Officer"
	job_access_type = /datum/job/cmo

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
	job_access_type = /datum/job/officer

/obj/item/card/id/security/detective
	name = "detective ID"
	assignment = "Detective"
	rank = "Detective"
	job_access_type = /datum/job/detective

/obj/item/card/id/security/warden
	name = "warden ID"
	assignment = "Warden"
	rank = "Warden"
	job_access_type = /datum/job/warden

/obj/item/card/id/security/head
	name = "\improper HoS ID"
	desc = "A card which represents honor and protection."
	primary_color = rgb(189,47,0)
	secondary_color = rgb(255,223,127)
	assignment = "Head of Security"
	rank = "Head of Security"
	job_access_type = /datum/job/hos

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
	job_access_type = /datum/job/engineer

/obj/item/card/id/engineering/atmos
	name = "atmospherics ID"
	assignment = "Atmospheric Technician"
	rank = "Atmospheric Technician"
	job_access_type = /datum/job/atmos

/obj/item/card/id/engineering/head
	name = "\improper CE ID"
	desc = "A card which represents creativity and ingenuity."
	primary_color = rgb(189,94,0)
	secondary_color = rgb(255,223,127)
	assignment = "Chief Engineer"
	rank = "Chief Engineer"
	job_access_type = /datum/job/chief_engineer

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
	job_access_type = /datum/job/scientist

/obj/item/card/id/science/xenobiologist
	name = "xenobiologist ID"
	assignment = "Xenobiologist"
	rank = "Xenobiologist"
	job_access_type = /datum/job/xenobiologist

/obj/item/card/id/science/roboticist
	name = "roboticist ID"
	assignment = "Roboticist"
	rank = "Roboticist"
	job_access_type = /datum/job/roboticist

/obj/item/card/id/science/head
	name = "\improper RD ID"
	desc = "A card which represents knowledge and reasoning."
	primary_color = rgb(142,47,142)
	secondary_color = rgb(255,223,127)
	assignment = "Research Director"
	rank = "Research Director"
	job_access_type = /datum/job/rd

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
	job_access_type = /datum/job/cargo_tech

/obj/item/card/id/cargo/mining
	name = "mining ID"
	assignment = "Shaft Miner"
	rank = "Shaft Miner"
	job_access_type = /datum/job/mining

/obj/item/card/id/cargo/head
	name = "\improper Quartermaster's ID"
	desc = "A card which represents service and planning."
	primary_color = rgb(142,94,0)
	secondary_color = rgb(255,223,127)
	assignment = "Quartermaster"
	rank = "Quartermaster"
	job_access_type = /datum/job/qm

/obj/item/card/id/assistant
	assignment = USELESS_JOB //VOREStation Edit - Visitor not Assistant
	rank = USELESS_JOB //VOREStation Edit - Visitor not Assistant
	job_access_type = /datum/job/assistant

/obj/item/card/id/civilian
	name = "civilian identification card"
	desc = "A card issued to station civilian staff."
	icon_state = "civilian-id"
	primary_color = rgb(0,94,142)
	secondary_color = rgb(95,159,191)
	assignment = "Civilian"
	rank = "Assistant"
	job_access_type = /datum/job/assistant

/obj/item/card/id/civilian/bartender
	name = "bartender ID"
	assignment = "Bartender"
	rank = "Bartender"
	job_access_type = /datum/job/bartender

/obj/item/card/id/civilian/botanist
	name = "botanist ID"
	assignment = "Botanist"
	rank = "Botanist"
	job_access_type = /datum/job/hydro

/obj/item/card/id/civilian/chaplain
	name = "chaplain ID"
	assignment = "Chaplain"
	rank = "Chaplain"
	job_access_type = /datum/job/chaplain

/obj/item/card/id/civilian/chef
	name = "chef ID"
	assignment = "Chef"
	rank = "Chef"
	job_access_type = /datum/job/chef

/obj/item/card/id/civilian/internal_affairs_agent
	name = "internal affairs ID"
	assignment = "Internal Affairs Agent"
	rank = "Internal Affairs Agent"
	job_access_type = /datum/job/lawyer

/obj/item/card/id/civilian/janitor
	name = "janitor ID"
	assignment = "Janitor"
	rank = "Janitor"
	job_access_type = /datum/job/janitor

/obj/item/card/id/civilian/librarian
	name = "librarian ID"
	assignment = "Librarian"
	rank = "Librarian"
	job_access_type = /datum/job/librarian

/obj/item/card/id/civilian/clown
	name = "clown ID"
	assignment = "Clown"
	rank = "Clown"
	job_access_type = /datum/job/clown

/obj/item/card/id/civilian/mime
	name = "mime ID"
	assignment = "Mime"
	rank = "Mime"
	job_access_type = /datum/job/mime

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
