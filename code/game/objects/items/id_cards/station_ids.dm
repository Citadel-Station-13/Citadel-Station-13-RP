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
	var/dna_hash = "\[UNSET\]"
	var/pronouns = "\[UNSET\]"
	var/species = "\[UNSET\]"
	var/icon/front
	var/icon/side
	var/photoupdatequeued

	/// Keyed list containing confidential information, such as blood type, vetalism, and more
	var/list/extra_info = list()
	var/extra_info_visible

	var/last_job_switch
	var/lost_access = list()

	var/primary_color = rgb(0,0,0) // Obtained by eyedroppering the stripe in the middle of the card
	var/secondary_color = rgb(0,0,0) // Likewise for the oval in the top-left corner

	var/datum/role/job/job_access_type = /datum/role/job/station/assistant    // Job type to acquire access rights from, if any

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job

	//* Point Redemption *//

	/// stored POINT_REDEMPTION_TYPE_* points; enum associated to number
	/// * lazy list
	var/list/stored_redemption_points

/obj/item/card/id/Initialize(mapload)
	. = ..()
	var/datum/role/job/getting_from
	if(ispath(job_access_type))
		job_access_type = SSjob.job_by_type(job_access_type)
	if(istype(job_access_type))
		getting_from = job_access_type
	else
		getting_from = SSjob.get_job(rank)
	if(!isnull(getting_from))
		access = getting_from.get_access()
		job_access_type = getting_from

/obj/item/card/id/examine(mob/user, dist)
	. = ..()
	. += "<div"
	if(front || side)
		. += " style='background: "
		if(side)
			. += "url([icon2html(side, world, sourceonly = TRUE)])"
		if(front && side)
			. += ", "
		if(front)
			. += "url([icon2html(front, world, sourceonly = TRUE)])"
		. += "; background-repeat: no-repeat; background-size: 64px; background-position: right 0px top 0px, right 64px top 0px; -ms-interpolation-mode: nearest-neighbor; image-rendering: pixelated'"
	. += ">"
	. += dat()
	. += "</div>"
	if(Adjacent(user))
		. += SPAN_NOTICE("<b>Alt-click</b> to [extra_info_visible ? "close" : "open"] the confidential information flap.")

/obj/item/card/id/get_description_info()
	. = ..()
	if(.)
		. += "<br>"
	for(var/key in stored_redemption_points)
		var/amount = stored_redemption_points[key]
		if(!amount)
			continue
		. += "There's [amount] [key] equipment redemption point[amount > 1 ? "s" : ""] loaded on this card."

/obj/item/card/id/update_name()
	name = "[registered_name? "[registered_name]'s " : ""]ID Card [assignment? "([assignment])" : ""]"

/**
 * Sets our registered name
 *
 * @params
 * * name - What name to set to.
 */
/obj/item/card/id/proc/set_registered_name(name)
	src.registered_name = name
	update_name()

/**
 * Sets our registered rank / assignment
 *
 * @params
 * * rank - what rank to set to. This is the job title. Defaults to unchanged.
 * * assignment - what assignment to set to. This is the job alt title, if any. Defaults to the rank.
 */
/obj/item/card/id/proc/set_registered_rank(rank = src.rank, assignment)
	src.rank = rank
	src.assignment = assignment || rank
	update_name()

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

/obj/item/card/id/proc/set_id_photo(var/mob/M)
	if(!photoupdatequeued)
		addtimer(CALLBACK(src, PROC_REF(_set_id_photo)), 1)
	photoupdatequeued = M


/obj/item/card/id/proc/_set_id_photo()
	var/mob/M = photoupdatequeued
	if(istype(M))
		UNTIL(!(M.atom_flags & ATOM_OVERLAY_QUEUED)) // this is necessary specifically because roundstart characters simply do not render their clothes, as they are waiting for overlays to compile. we are in hell we think
		front = get_flat_icon(M, SOUTH, TRUE)
		side = get_flat_icon(M, WEST, TRUE)
	photoupdatequeued = null

/mob/proc/set_id_info(obj/item/card/id/id_card, client/C)
	id_card.extra_info = list()
	id_card.age = 0
	id_card.registered_name		= real_name
	id_card.extra_info["sex"] = "<b>Biological Sex:</b> [capitalize(gender)]" //most people just use sex for the handful of pixels worth of difference in body model but eh why the hell not
	var/datum/gender/G = GLOB.gender_datums[get_gender()]
	if(istype(G))
		id_card.pronouns = G.pronoun_preview
	else
		id_card.pronouns = "Unknown"

	if(dna)
		id_card.extra_info["bloodtype"] = "<b>Blood Type:</b> [dna.b_type]"
		id_card.extra_info["dnahash"] = "<b>DNA Hash:</b> [dna.unique_enzymes]"
		id_card.extra_info["fingerprint"] = "<b>Fingerprint:</b> [md5(dna.uni_identity)]"
		id_card.dna_hash		= dna.unique_enzymes
	if(C && C.prefs)
		id_card.extra_info += C.prefs.get_trait_id_info()
	id_card.update_name()
	id_card.set_id_photo(src)

/mob/living/carbon/human/set_id_info(obj/item/card/id/id_card, client/C)
	..()
	id_card.age = age
	id_card.species = custom_species ? custom_species : species.get_examine_name()

	id_card.extra_info["biospecies"] = "<b>Biological Species:</b> [species.get_examine_name()]"

	if(istype(id_card,/obj/item/card/id/contractor))
		var/obj/item/card/id/contractor/c_id = id_card

		var/faction = src.mind?.original_background_faction()
		c_id.employing_coperation = faction

/obj/item/card/id/proc/dat()
	var/dat = list()
	dat += "<b>Name:</b> [registered_name]"
	dat += "<b>Pronouns:</b> [pronouns]"
	dat += "<b>Age:</b> [age]"
	dat += "<b>Rank:</b> [assignment]"
	dat += "<b>Species:</b> [species]"
	if(extra_info_visible)
		dat += SPAN_NOTICE("<br>CONFIDENTIAL:")
		if(length(extra_info))
			for(var/key in extra_info) // doing a simple dat += extra_info just results in the ID displaying all the keys instead of the actual text tied to 'em
				dat += extra_info[key]
		else
			dat += SPAN_NOTICE("The confidential information section is blank.")
	else
		dat += "The confidential information flap is closed."
	return dat

/obj/item/card/id/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	user.visible_message("\The [user] shows you: [icon2html(thing = src, target = world)] [src.name]. The assignment on the card: [src.assignment]",\
		"You flash your ID card: [icon2html(thing = src, target = user)] [src.name]. The assignment on the card: [src.assignment]")

	src.add_fingerprint(user)
	return

/obj/item/card/id/AltClick(mob/user)
	if(Adjacent(user))
		extra_info_visible = !extra_info_visible
	user.visible_message("[user] flips [src]'s confidential information flap [extra_info_visible ? "open" : "closed"].",\
		"You flip [src]'s confidential information flap [extra_info_visible ? "open" : "closed"].")


/obj/item/card/id/GetAccess()
	return access.Copy()

/obj/item/card/id/GetID()
	return src

/obj/item/card/id/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(null, "-----")
	VV_DROPDOWN_OPTION(VV_HK_ID_MOD, "Modify ID")

/obj/item/card/id/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_ID_MOD])
		var/datum/tgui_module/card_mod/admin/card_vv/mod = new(src)
		mod.ui_interact(usr)

//* Point Redemption *//

/obj/item/card/id/proc/get_redemption_points(point_type)
	return stored_redemption_points?[point_type] || 0

/obj/item/card/id/proc/set_redemption_points(point_type, amount)
	LAZYSET(stored_redemption_points, point_type, amount)

/obj/item/card/id/proc/adjust_redemption_points(point_type, amount)
	LAZYINITLIST(stored_redemption_points)
	stored_redemption_points[point_type] = max(0, stored_redemption_points[point_type] + amount)

/**
 * @return TRUE / FALSE on success / fail
 */
/obj/item/card/id/proc/use_redemption_points(point_type, amount)
	if(stored_redemption_points?[point_type] < amount)
		return FALSE
	stored_redemption_points[point_type] -= amount
	return TRUE

/obj/item/card/id/silver
	name = "command identification card"
	desc = "A silver card which shows honour and dedication."
	icon_state = "silver-id"
	item_state = "silver_id"

/obj/item/card/id/silver/secretary
	name = "secretary ID"
	assignment = "Command Secretary"
	rank = "Command Secretary"
	job_access_type = /datum/role/job/station/command_secretary

/obj/item/card/id/silver/hop
	name = "\improper HoP ID"
	assignment = "Head of Personnel"
	rank = "Head of Personnel"
	desc = "A card which represents the balance between those that serve and those that are served."
	job_access_type = /datum/role/job/station/head_of_personnel

/obj/item/card/id/silver/blueshield
	name = "\improper Blueshield ID"
	assignment = "Blueshield"
	rank = "Blueshield"
	job_access_type = /datum/role/job/station/blueshield

/obj/item/card/id/gold
	name = "gold identification card"
	desc = "A golden card which shows power and might."
	icon_state = "gold-id"
	item_state = "gold_id"
	preserve_item = 1

/obj/item/card/id/gold/captain
	name = "\improper Captain's ID"
	assignment = "Captain"
	rank = "Captain"
	job_access_type = /datum/role/job/station/captain

/obj/item/card/id/gold/captain/spare
	name = "\improper Captain's Spare ID"
	desc = "The spare ID of the High Lord himself."
	registered_name = "Captain"
	icon_state = "gold-id-alternate"
	job_access_type = /datum/role/job/station/captain

/obj/item/card/id/synthetic
	name = "\improper Synthetic ID"
	desc = "Access module for Nanotrasen Synthetics"
	icon_state = "id-robot"
	item_state = "idgreen"
	assignment = "Synthetic"

/obj/item/card/id/synthetic/Initialize(mapload)
	. = ..()
	access = SSjob.access_ids_of_type(ACCESS_TYPE_STATION) + ACCESS_SPECIAL_SILICONS

/obj/item/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Central Command."
	icon_state = "cc-id"
	registered_name = "Central Command"
	assignment = "General"

/obj/item/card/id/centcom/Initialize(mapload)
	. = ..()
	access = SSjob.access_ids_of_type(ACCESS_TYPE_CENTCOM)

/obj/item/card/id/centcom/station/Initialize(mapload)
	. = ..()
	access |= SSjob.access_ids_of_type(ACCESS_TYPE_STATION)

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
	job_access_type = /datum/role/job/station/doctor

/obj/item/card/id/medical/chemist
	name = "chemist ID"
	assignment = "Chemist"
	rank = "Chemist"
	job_access_type = /datum/role/job/station/chemist

/obj/item/card/id/medical/geneticist
	name = "geneticist ID"
	assignment = "Geneticist"
	rank = "Geneticist"
	job_access_type = /datum/role/job/station/doctor	//geneticist

/obj/item/card/id/medical/psychiatrist
	name = "psychiatrist ID"
	assignment = "Psychiatrist"
	rank = "Psychiatrist"
	job_access_type = /datum/role/job/station/psychiatrist

/obj/item/card/id/medical/paramedic
	name = "paramedic ID"
	assignment = "Paramedic"
	rank = "Paramedic"
	job_access_type = /datum/role/job/station/paramedic

/obj/item/card/id/medical/head
	name = "\improper CMO ID"
	desc = "A card which represents care and compassion."
	primary_color = rgb(189,237,237)
	secondary_color = rgb(255,223,127)
	assignment = "Chief Medical Officer"
	rank = "Chief Medical Officer"
	job_access_type = /datum/role/job/station/chief_medical_officer

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
	job_access_type = /datum/role/job/station/officer

/obj/item/card/id/security/detective
	name = "detective ID"
	assignment = "Detective"
	rank = "Detective"
	job_access_type = /datum/role/job/station/detective

/obj/item/card/id/security/warden
	name = "warden ID"
	assignment = "Warden"
	rank = "Warden"
	job_access_type = /datum/role/job/station/warden

/obj/item/card/id/security/head
	name = "\improper HoS ID"
	desc = "A card which represents honor and protection."
	primary_color = rgb(189,47,0)
	secondary_color = rgb(255,223,127)
	assignment = "Head of Security"
	rank = "Head of Security"
	job_access_type = /datum/role/job/station/head_of_security


/obj/item/card/id/prisoner
	name = "Prisoner ID card"
	desc = "A card representing someone's incarceration. Do not lose."
	icon_state = "civilian-id"
	assignment = "Prisoner"
	primary_color = rgb(243, 97, 0)
	secondary_color = rgb(5, 7, 3)
	var/goal = 0 //How far from freedom?
	var/points = 0

	var/served = 0 //Time served in seconds
	var/sentence = 0 //Sentence in minutes
	var/crime = "\[redacted\]"

	job_access_type = null
	access = list(ACCESS_SECURITY_GENPOP_ENTER)

/obj/item/card/id/prisoner/New()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	registered_name = "Prisoner #13-[rand(100,999)]"

/obj/item/card/id/prisoner/process()
	if (sentence > 0 && served > (sentence * 60)) //FREEDOM!
		assignment = "Ex-Convict"
		access = list(ACCESS_SECURITY_GENPOP_EXIT)
		update_name(registered_name, assignment)
		playsound(loc, 'sound/machines/ping.ogg', 50, 1)
		if(isliving(loc))
			to_chat(loc, "<span class='boldnotice'>\The [src] buzzes: You have served your sentence! You may now exit prison through the turnstiles and collect your belongings.</span>")
		STOP_PROCESSING(SSprocessing, src)
	else
		served += 1

/obj/item/card/id/prisoner/examine(mob/user)
	. = ..()

	var/minutesServed = round(served / 60)
	var/secondsServed = served - (minutesServed * 60)
	if(sentence <= 0)
		. += "\n<span class='notice'>You are serving a permanent sentence for [crime].</span>"
	else if(served >= (sentence * 60))
		. += "\n<span class='notice'>You have served your sentence for [crime].</span>"
	else
		. += "\n<span class='notice'>You have served [minutesServed] minutes [secondsServed] seconds of your [sentence] minute sentence for [crime].</span>"
	if(goal > 0)
		. += "\n<span class='notice'>You have accumulated [points] out of the [goal] points you need for freedom.</span>"



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
	job_access_type = /datum/role/job/station/engineer

/obj/item/card/id/engineering/atmos
	name = "atmospherics ID"
	assignment = "Atmospheric Technician"
	rank = "Atmospheric Technician"
	job_access_type = /datum/role/job/station/atmos

/obj/item/card/id/engineering/head
	name = "\improper CE ID"
	desc = "A card which represents creativity and ingenuity."
	primary_color = rgb(189,94,0)
	secondary_color = rgb(255,223,127)
	assignment = "Chief Engineer"
	rank = "Chief Engineer"
	job_access_type = /datum/role/job/station/chief_engineer

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
	job_access_type = /datum/role/job/station/scientist

/obj/item/card/id/science/xenobiologist
	name = "xenobiologist ID"
	assignment = "Xenobiologist"
	rank = "Xenobiologist"
	job_access_type = /datum/role/job/station/scientist // /datum/role/job/station/xenobiologist

/obj/item/card/id/science/roboticist
	name = "roboticist ID"
	assignment = "Roboticist"
	rank = "Roboticist"
	job_access_type = /datum/role/job/station/roboticist

/obj/item/card/id/science/head
	name = "\improper RD ID"
	desc = "A card which represents knowledge and reasoning."
	primary_color = rgb(142,47,142)
	secondary_color = rgb(255,223,127)
	assignment = "Research Director"
	rank = "Research Director"
	job_access_type = /datum/role/job/station/research_director

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
	job_access_type = /datum/role/job/station/cargo_tech

/obj/item/card/id/cargo/mining
	name = "mining ID"
	assignment = "Shaft Miner"
	rank = "Shaft Miner"
	job_access_type = /datum/role/job/station/mining

/obj/item/card/id/cargo/head
	name = "\improper Quartermaster's ID"
	desc = "A card which represents service and planning."
	primary_color = rgb(142,94,0)
	secondary_color = rgb(255,223,127)
	assignment = "Quartermaster"
	rank = "Quartermaster"
	job_access_type = /datum/role/job/station/quartermaster

/obj/item/card/id/assistant
	assignment = USELESS_JOB
	rank = USELESS_JOB
	job_access_type = /datum/role/job/station/assistant

/obj/item/card/id/civilian
	name = "civilian identification card"
	desc = "A card issued to station civilian staff."
	icon_state = "civilian-id"
	primary_color = rgb(0,94,142)
	secondary_color = rgb(95,159,191)
	assignment = "Civilian"
	rank = "Assistant"
	job_access_type = /datum/role/job/station/assistant

/obj/item/card/id/civilian/bartender
	name = "bartender ID"
	assignment = "Bartender"
	rank = "Bartender"
	job_access_type = /datum/role/job/station/bartender

/obj/item/card/id/civilian/botanist
	name = "botanist ID"
	assignment = "Botanist"
	rank = "Botanist"
	job_access_type = /datum/role/job/station/hydro

/obj/item/card/id/civilian/chaplain
	name = "chaplain ID"
	assignment = "Chaplain"
	rank = "Chaplain"
	job_access_type = /datum/role/job/station/chaplain

/obj/item/card/id/civilian/chef
	name = "chef ID"
	assignment = "Chef"
	rank = "Chef"
	job_access_type = /datum/role/job/station/chef

/obj/item/card/id/civilian/internal_affairs_agent
	name = "internal affairs ID"
	assignment = "Internal Affairs Agent"
	rank = "Internal Affairs Agent"
	job_access_type = /datum/role/job/station/lawyer

/obj/item/card/id/civilian/janitor
	name = "janitor ID"
	assignment = "Janitor"
	rank = "Janitor"
	job_access_type = /datum/role/job/station/janitor

/obj/item/card/id/civilian/librarian
	name = "librarian ID"
	assignment = "Librarian"
	rank = "Librarian"
	job_access_type = /datum/role/job/station/librarian

/obj/item/card/id/civilian/clown
	name = "clown ID"
	assignment = "Clown"
	rank = "Clown"
	job_access_type = /datum/role/job/station/clown

/obj/item/card/id/civilian/mime
	name = "mime ID"
	assignment = "Mime"
	rank = "Mime"
	job_access_type = /datum/role/job/station/mime

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
	//primary_color = rgb(142,94,0)
	//secondary_color = rgb(191,159,95)
	job_access_type = /datum/role/job/trader
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
	job_access_type = null
	access = list(168)

/obj/item/card/id/medical/sar
	assignment = "Field Medic"
	rank = "Field Medic"
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)
	job_access_type = /datum/role/job/station/field_medic

/obj/item/card/id/explorer
	name = "identification card"
	desc = "A card issued to station exploration staff."
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)

/obj/item/card/id/explorer/pilot
	assignment = "Pilot"
	rank = "Pilot"
	job_access_type = /datum/role/job/station/pilot

/obj/item/card/id/explorer/explorer
	assignment = "Explorer"
	rank = "Explorer"
	job_access_type = /datum/role/job/station/explorer

/obj/item/card/id/explorer/head
	name = "identification card"
	desc = "A card which represents discovery of the unknown."
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)


/obj/item/card/id/explorer/head/pathfinder
	assignment = "Pathfinder"
	rank = "Pathfinder"
	job_access_type = /datum/role/job/station/pathfinder

/obj/item/card/id/external/gaia
	name = "Happy Trails Resort Company Day Pass"
	desc = "A pass giving one access to the normal facilties at Happy Trails Resort stations."
	icon_state = "gaia_normal"
	job_access_type = null
	access = list(250)

/obj/item/card/id/external/gaia/vip
	name = "Happy Trails Resort Company VIP Day Pass"
	desc = "A premium day pass for accessing the most luxurious parts of the Happy Trails Resorts."
	icon_state = "gaia_vip"
	access = list(250,251)

/obj/item/card/id/external/gaia/staff//created so that when assigning the outfit of merchant, it assigns a working ID
	name = "Happy Trails Resort Company Staff ID"
	desc = "Issued to staff of the Happy Trails Company."
	icon_state = "gaia_staff"
	access = list(250,251,252)

/obj/item/card/id/external/nebula/room1
	name = "Card to Room 1"
	desc = "A card that grants usage of Room 1 of the Nebula Motel"
	icon_state = "guest"
	job_access_type = null
	access = list(161)

/obj/item/card/id/external/nebula/room2
	name = "Card to Room 2"
	desc = "A card that grants usage of Room 2 of the Nebula Motel"
	icon_state = "guest"
	job_access_type = null
	access = list(162)

/obj/item/card/id/external/nebula/room3
	name = "Card to Room 3"
	desc = "A card that grants usage of Room 3 of the Nebula Motel"
	icon_state = "guest"
	job_access_type = null
	access = list(163)

/obj/item/card/id/external/nebula/room4
	name = "Card to Room 4"
	desc = "A card that grants usage of Room 4 of the Nebula Motel"
	icon_state = "guest"
	job_access_type = null
	access = list(164)

/obj/item/card/id/external/nebula/room5
	name = "Card to Room 5"
	desc = "A card that grants usage of Room 5 of the Nebula Motel"
	icon_state = "guest"
	job_access_type = null
	access = list(165)

/obj/item/card/id/external/nebula/room6
	name = "Card to Room 6"
	desc = "A card that grants usage of Room 6 of the Nebula Motel"
	icon_state = "guest"
	job_access_type = null
	access = list(166)

/obj/item/card/id/external/nebula/room7
	name = "Card to Room 7"
	desc = "A card that grants usage of Room 7 of the Nebula Motel"
	icon_state = "guest"
	job_access_type = null
	access = list(167)

/obj/item/card/id/external/nebula/room8
	name = "Card to Room 8"
	desc = "A card that grants usage of Room 8 of the Nebula Motel"
	icon_state = "guest"
	job_access_type = null
	access = list(169)

/obj/item/card/id/external/nebula/room9
	name = "Card to the VIP Suit"
	color = "#ffbd17"
	desc = "A card that grants usage to the VIP suite of the Nebula Motel, and its Arrowhead shuttle."
	icon_state = "guest"
	job_access_type = null
	access = list(170)

/obj/item/card/id/external/id_nka
	name = "New Kingdom of Adhomai Commoner's ID"
	desc = "An ID issued to the non-noble commoners of the New Kingdom of Adhomai. In some regions, adults must legally carry it on their person at all times."
	icon_state = "nka"
	job_access_type = null

/obj/item/card/id/external/id_sdf
	name = "haddi's folley SDF ID"
	desc = "An ID issued to members of the system defence force of haddi's folley."
	icon_state = "sdf"
	job_access_type = null
	access = list(155)

/obj/item/card/id/external/id_occulum
	name = "Occulum Operator ID"
	desc = "An ID issued to operators of Occulum. Radio host, reporter, journalist, contacts, technician, spies... All get one. It also counts as a Press document, valid in this system."
	icon_state = "occulum"

/obj/item/card/id/external/id_slavager
	name = "Guardian Salvaging Inc ID"
	desc = "An ID issued to workers of the Guardian Salvaging Inc. It looks generic and cheap."
	icon_state = "generic"
