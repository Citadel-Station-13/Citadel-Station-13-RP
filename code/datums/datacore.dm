
/legacy_hook/startup/proc/createDatacore()
	data_core = new /datum/datacore()
	return 1

/datum/datacore
	var/name = "datacore"
	//For general station crew
	var/static/list/medical = list()
	var/static/list/general = list()
	var/static/list/security = list()
	//For offmap spawns so they can have records accessible by certain things
	var/static/list/hidden_medical = list()
	var/static/list/hidden_general = list()
	var/static/list/hidden_security = list()
	//This list tracks characters spawned in the world and cannot be modified in-game. Currently referenced by respawn_character().
	var/static/list/locked = list()

/**
 * Returns a list of DEPARTMENT_KEY lists with names = ranks
 */
/datum/datacore/proc/get_raw_manifest_data(OOC = FALSE, activity = FALSE)
	var/list/command = new()
	var/list/security = new()
	var/list/engineering = new()
	var/list/medical = new()
	var/list/science = new()
	var/list/cargo = new()
	var/list/exploration = new()
	var/list/civilian = new()
	var/list/silicons = new()
	var/list/misc = new()
	var/list/offduty = new()
	var/list/trade = new()
	var/list/offmap = new()
	var/list/isactive = new()

	//Categorize crew roles
	for(var/datum/data/record/t in general)
		var/name = t.fields["name"]
		var/rank = t.fields["rank"]
		var/real_rank = make_list_rank(t.fields["real_rank"])

		//Check if players are active. Check real stats
		if(activity == TRUE && OOC == TRUE)
			var/active = FALSE
			for(var/mob/M in GLOB.player_list)
				if(M.real_name == name && M.client && M.client.inactivity <= 10 MINUTES)
					active = TRUE
					break
			isactive[name] = active ? "Active" : "Inactive"
		else if(activity == TRUE)
			isactive[name] = t.fields["p_stat"]

		//Check for command first, then exploration. As these roles can have multiple departments and we want these roles to be dominant.
		if(SSjob.is_job_in_department(real_rank, DEPARTMENT_COMMAND))
			command[name] = rank
		else if(SSjob.is_job_in_department(real_rank, DEPARTMENT_PLANET))
			exploration[name] = rank
		else if(SSjob.is_job_in_department(real_rank, DEPARTMENT_SECURITY))
			security[name] = rank
		else if(SSjob.is_job_in_department(real_rank, DEPARTMENT_ENGINEERING))
			engineering[name] = rank
		else if(SSjob.is_job_in_department(real_rank, DEPARTMENT_MEDICAL))
			medical[name] = rank
		else if(SSjob.is_job_in_department(real_rank, DEPARTMENT_RESEARCH))
			science[name] = rank
		else if(SSjob.is_job_in_department(real_rank, DEPARTMENT_CARGO))
			cargo[name] = rank
		else if(SSjob.is_job_in_department(real_rank, DEPARTMENT_CIVILIAN))
			civilian[name] = rank
		else if(SSjob.is_job_in_department(real_rank, DEPARTMENT_OFFDUTY))
			offduty[name] = rank
		else if(SSjob.is_job_in_department(real_rank, DEPARTMENT_TRADE))
			trade[name] = rank
		else if(SSjob.is_job_in_department(real_rank, DEPARTMENT_SYNTHETIC))
			silicons[name] = rank
		else misc[name] = rank

	if(OOC == TRUE)
		//Categorize offmap roles
		for(var/datum/data/record/t in hidden_general)
			var/name = t.fields["name"]
			var/rank = t.fields["rank"]
			var/real_rank = make_list_rank(t.fields["real_rank"])

			if(activity == TRUE)
				var/active = FALSE
				for(var/mob/M in GLOB.player_list)
					if(M.real_name == name && M.client && M.client.inactivity <= 10 MINUTES)
						active = TRUE
						break
				isactive[name] = active ? "Active" : "Inactive"

			var/datum/prototype/role/job/J = RSroles.legacy_job_by_title(real_rank)
			if(J?.offmap_spawn)
				offmap[name] = rank

		// add pAIs	to the returned manifest
		for(var/mob/living/silicon/pai/pai in GLOB.mob_list)
			silicons[pai.name] = "pAI"

	//Return all of our lists.
	var/list/manifest_data = new()
	if(command.len) manifest_data["Command"] = command
	if(security.len) manifest_data["Security"] = security
	if(engineering.len) manifest_data["Engineering"] = engineering
	if(medical.len) manifest_data["Medical"] = medical
	if(science.len) manifest_data["Science"] = science
	if(cargo.len) manifest_data["Cargo"] = cargo
	if(exploration.len) manifest_data["Exploration"] = exploration
	if(civilian.len) manifest_data["Civilian"] = civilian
	if(silicons.len) manifest_data["Silicons"] = silicons
	if(misc.len) manifest_data["Misc"] = misc
	if(offduty.len) manifest_data["Off Duty"] = offduty
	if (OOC == TRUE)
		if(trade.len) manifest_data["Trade"] = trade
		if(offmap.len) manifest_data["Non-Crew"] = offmap
	if (activity == TRUE)
		if(isactive.len) manifest_data["IsActive"] = isactive

	return manifest_data


/datum/datacore/proc/get_html_manifest(monochrome = FALSE, OOC = FALSE)
	var/dat = {"
	<head><style>
		.manifest {border-collapse:collapse;}
		.manifest td, th {border:1px solid [monochrome?"black":"[OOC?"black; background-color:#272727; color:white":"#DEF; background-color:white; color:black"]"]; padding:.25em}
		.manifest th {height: 2em; [monochrome?"border-top-width: 3px":"background-color: [OOC?"#40628A":"#48C"]; color:white"]}
		.manifest tr.head th { [monochrome?"border-top-width: 1px":"background-color: [OOC?"#013D3B;":"#488;"]"] }
		.manifest td:first-child {text-align:right}
		.manifest tr.alt td {[monochrome?"border-top-width: 2px":"background-color: [OOC?"#373737; color:white":"#DEF"]"]}
	</style></head>
	<table class="manifest" width='350px'>
	<tr class='head'><th>Name</th><th>Rank</th><th>Activity</th></tr>
	"}
	var/even = FALSE

	var/list/raw_data = get_raw_manifest_data(OOC, TRUE)

	if(raw_data.Find("Command"))
		dat += "<tr><th colspan=3>Heads</th></tr>"
		for(name in raw_data["Command"])
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[raw_data["Command"][name]]</td><td>[raw_data["IsActive"][name]]</td></tr>"
			even = !even
	if(raw_data.Find("Security"))
		dat += "<tr><th colspan=3>Security</th></tr>"
		for(name in raw_data["Security"])
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[raw_data["Security"][name]]</td><td>[raw_data["IsActive"][name]]</td></tr>"
			even = !even
	if(raw_data.Find("Engineering"))
		dat += "<tr><th colspan=3>Engineering</th></tr>"
		for(name in raw_data["Engineering"])
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[raw_data["Engineering"][name]]</td><td>[raw_data["IsActive"][name]]</td></tr>"
			even = !even
	if(raw_data.Find("Medical"))
		dat += "<tr><th colspan=3>Medical</th></tr>"
		for(name in raw_data["Medical"])
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[raw_data["Medical"][name]]</td><td>[raw_data["IsActive"][name]]</td></tr>"
			even = !even
	if(raw_data.Find("Science"))
		dat += "<tr><th colspan=3>Science</th></tr>"
		for(name in raw_data["Science"])
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[raw_data["Science"][name]]</td><td>[raw_data["IsActive"][name]]</td></tr>"
			even = !even
	if(raw_data.Find("Cargo"))
		dat += "<tr><th colspan=3>Cargo</th></tr>"
		for(name in raw_data["Cargo"])
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[raw_data["Cargo"][name]]</td><td>[raw_data["IsActive"][name]]</td></tr>"
			even = !even
	if(raw_data.Find("Exploration"))
		dat += "<tr><th colspan=3>Exploration</th></tr>"
		for(name in raw_data["Exploration"])
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[raw_data["Exploration"][name]]</td><td>[raw_data["IsActive"][name]]</td></tr>"
			even = !even
	if(raw_data.Find("Civilian"))
		dat += "<tr><th colspan=3>Civilian</th></tr>"
		for(name in raw_data["Civilian"])
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[raw_data["Civilian"][name]]</td><td>[raw_data["IsActive"][name]]</td></tr>"
			even = !even
	if(raw_data.Find("Silicons"))
		dat += "<tr><th colspan=3>Silicon</th></tr>"
		for(name in raw_data["Silicons"])
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[raw_data["Silicons"][name]]</td><td>[raw_data["IsActive"][name]]</td></tr>"
			even = !even
	// offmap spawners
	if(raw_data.Find("Non-Crew"))
		dat += "<tr><th colspan=3>Offmap Spawns</th></tr>"
		for(name in raw_data["Non-Crew"])
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[raw_data["Non-Crew"][name]]</td><td>[raw_data["IsActive"][name]]</td></tr>"
			even = !even
	if(raw_data.Find("Trade"))
		dat += "<tr><th colspan=3>Traders</th></tr>"
		for(name in raw_data["Trade"])
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[raw_data["Trade"][name]]</td><td>[raw_data["IsActive"][name]]</td></tr>"
			even = !even
	// misc guys
	if(raw_data.Find("Misc"))
		dat += "<tr><th colspan=3>Miscellaneous</th></tr>"
		for(name in raw_data["Misc"])
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[raw_data["Misc"][name]]</td><td>[raw_data["IsActive"][name]]</td></tr>"
			even = !even

	dat += "</table>"
	dat = replacetext(dat, "\n", "") // so it can be placed on paper correctly
	dat = replacetext(dat, "\t", "")
	return dat

/*
We can't just insert in HTML into the nanoUI so we need the raw data to play with.
Instead of creating this list over and over when someone leaves their PDA open to the page
we'll only update it when it changes.  The GLOB.PDA_Manifest global list is zeroed out upon any change
using /datum/datacore/proc/manifest_inject( ), or manifest_insert( )
*/
GLOBAL_LIST_EMPTY(PDA_Manifest)

/datum/datacore/proc/update_manifest_list()
	//PDA_Manifest is still cached.
	if(GLOB.PDA_Manifest.len)
		return

	var/list/raw_data = get_raw_manifest_data(FALSE, TRUE)
	var/list/heads = list()
	var/list/sec = list()
	var/list/eng = list()
	var/list/med = list()
	var/list/sci = list()
	var/list/car = list()
	var/list/exp = list()
	var/list/civ = list()
	var/list/bot = list()
	var/list/misc = list()

	//Reshuffle the raw_data into the pda_manifest format
	for(name in raw_data["Command"])
		heads[heads.len++] = list("name" = name, "rank" = raw_data["Command"][name], "active" = raw_data["IsActive"][name])
	for(name in raw_data["Security"])
		sec[sec.len++] = list("name" = name, "rank" = raw_data["Security"][name], "active" = raw_data["IsActive"][name])
	for(name in raw_data["Engineering"])
		eng[eng.len++] = list("name" = name, "rank" = raw_data["Engineering"][name], "active" = raw_data["IsActive"][name])
	for(name in raw_data["Medical"])
		med[med.len++] = list("name" = name, "rank" = raw_data["Medical"][name], "active" = raw_data["IsActive"][name])
	for(name in raw_data["Science"])
		sci[sci.len++] = list("name" = name, "rank" = raw_data["Science"][name], "active" = raw_data["IsActive"][name])
	for(name in raw_data["Cargo"])
		car[car.len++] = list("name" = name, "rank" = raw_data["Cargo"][name], "active" = raw_data["IsActive"][name])
	for(name in raw_data["Exploration"])
		exp[exp.len++] = list("name" = name, "rank" = raw_data["Exploration"][name], "active" = raw_data["IsActive"][name])
	for(name in raw_data["Civilian"])
		civ[civ.len++] = list("name" = name, "rank" = raw_data["Civilian"][name], "active" = raw_data["IsActive"][name])
	for(name in raw_data["Silicons"])
		bot[bot.len++] = list("name" = name, "rank" = raw_data["Silicons"][name], "active" = raw_data["IsActive"][name])
	for(name in raw_data["Misc"])
		misc[misc.len++] = list("name" = name, "rank" = raw_data["Misc"][name], "active" = raw_data["IsActive"][name])

	//! This old code pulls the name of the cyborg modules. The new code doesnt. May need to figure out a better system over all for this.
	//for(var/mob/living/silicon/robot/robot in GLOB.mob_list)
	//	// No combat/syndicate cyborgs, no drones, and no AI shells.
	//	if(robot.scrambledcodes || robot.shell || (robot.module && robot.module.hide_on_manifest))
	//		continue
	//	bot[++bot.len] = list("name" = robot.real_name, "rank" = "[robot.modtype] [robot.braintype]", "active" = "Active")

	GLOB.PDA_Manifest = list(
		list("cat" = "Command", "elems" = heads),
		list("cat" = "Security", "elems" = sec),
		list("cat" = "Engineering", "elems" = eng),
		list("cat" = "Medical", "elems" = med),
		list("cat" = "Science", "elems" = sci),
		list("cat" = "Cargo", "elems" = car),
		list("cat" = "Exploration", "elems" = exp),
		list("cat" = "Civilian", "elems" = civ),
		list("cat" = "Silicon", "elems" = bot),
		list("cat" = "Miscellaneous", "elems" = misc)
		)
	return

/datum/datacore/proc/manifest()
	spawn()
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			manifest_inject(H)
		return

/datum/datacore/proc/manifest_modify(var/name, var/assignment, var/rank)
	ResetPDAManifest()
	var/datum/data/record/foundrecord
	var/real_title = assignment

	for(var/datum/data/record/t in data_core.general)
		if (t)
			if(t.fields["name"] == name)
				foundrecord = t
				break

	var/list/all_jobs = get_job_datums()

	for(var/datum/prototype/role/job/J in all_jobs)
		if(J.title == rank)					//If we have a rank, just default to using that.
			real_title = rank
			break
		else if(J.title == assignment)
			real_title = assignment
			break
		else
			var/list/alttitles = get_alternate_titles(J.title)
			if(assignment in alttitles)
				real_title = J.title
				break

	if(foundrecord)
		foundrecord.fields["rank"] = assignment
		foundrecord.fields["real_rank"] = real_title

/datum/datacore/proc/manifest_inject(var/mob/living/carbon/human/H)
	if(H.mind && !player_is_antag(H.mind, only_offstation_roles = 1))
		var/assignment = GetAssignment(H)
		var/hidden
		var/datum/prototype/role/job/J = RSroles.legacy_job_by_title(H.mind.assigned_role)
		hidden = J?.offmap_spawn

		/* Note: Due to cached_character_icon, a number of emergent properties occur due to the initialization
		* order of readied-up vs latejoiners. Namely, latejoiners will get a uniform in their datacore picture, but readied-up will
		* not. This is due to the fact that SSticker calls data_core.manifest_inject() inside of ticker/proc/create_characters(),
		* but does not equip them until ticker/proc/equip_characters(), which is called later. So, this proc is literally called before
		* they ever get their equipment, and so it can't get a picture of them in their equipment.
		* Latejoiners do not have this problem, because /mob/new_player/proc/AttemptLateSpawn calls EquipRank() before it calls
		* this proc, which means that they're already clothed by the time they get their picture taken here.
		* The compile_overlays() here is just to bypass SSoverlays taking for-fucking-ever to update the mob, since we're about to
		* take a picture of them, we want all the overlays.
		*/
		H.compile_overlays()

		var/id = generate_record_id()
		//General Record
		var/datum/data/record/G = CreateGeneralRecord(H, id, hidden)
		G.fields["name"]		= H.real_name
		G.fields["real_rank"]	= H.mind.assigned_role
		G.fields["rank"]		= assignment
		G.fields["age"]			= H.age
		if(H.get_FBP_type())
			G.fields["brain_type"] = H.get_FBP_type()
		else
			G.fields["brain_type"] = "Organic"
		G.fields["fingerprint"]	= md5(H.dna.uni_identity)
		G.fields["p_stat"]		= "Active"
		G.fields["m_stat"]		= "Stable"
		G.fields["sex"]			= gender2text(H.gender)
		G.fields["species"]		= H.get_species_name()
		G.fields["home_system"]	= H.home_system
		G.fields["citizenship"]	= H.citizenship
		G.fields["faction"]		= H.personal_faction
		G.fields["religion"]	= H.religion
		if(H.gen_record && !jobban_isbanned(H, "Records"))
			G.fields["notes"] = H.gen_record

		//Medical Record
		var/datum/data/record/M = CreateMedicalRecord(H.real_name, id, hidden)
		M.fields["b_type"]		= H.b_type
		M.fields["b_dna"]		= H.dna.unique_enzymes
		M.fields["id_gender"]	= gender2text(H.identifying_gender)
		if(H.get_FBP_type())
			M.fields["brain_type"] = H.get_FBP_type()
		else
			M.fields["brain_type"] = "Organic"
		if(H.med_record && !jobban_isbanned(H, "Records"))
			M.fields["notes"] = H.med_record

		//Security Record
		var/datum/data/record/S = CreateSecurityRecord(H.real_name, id, hidden)
		if(H.get_FBP_type())
			S.fields["brain_type"] = H.get_FBP_type()
		else
			S.fields["brain_type"] = "Organic"
		if(H.sec_record && !jobban_isbanned(H, "Records"))
			S.fields["notes"] = H.sec_record

		//Locked Record
		var/datum/data/record/L = new()
		L.fields["id"]			= md5("[H.real_name][H.mind.assigned_role]")
		L.fields["name"]		= H.real_name
		L.fields["rank"] 		= H.mind.assigned_role
		L.fields["age"]			= H.age
		L.fields["fingerprint"]	= md5(H.dna.uni_identity)
		L.fields["sex"]			= gender2text(H.gender)
		L.fields["id_gender"]	= gender2text(H.identifying_gender)
		if(H.get_FBP_type())
			L.fields["brain_type"] = H.get_FBP_type()
		else
			L.fields["brain_type"] = "Organic"
		L.fields["b_type"]		= H.b_type
		L.fields["b_dna"]		= H.dna.unique_enzymes
		L.fields["enzymes"]		= H.dna.SE // Used in respawning
		L.fields["identity"]	= H.dna.UI // "
		L.fields["species"]		= H.get_species_name()
		L.fields["home_system"]	= H.home_system
		L.fields["citizenship"]	= H.citizenship
		L.fields["faction"]		= H.personal_faction
		L.fields["religion"]	= H.religion
		L.fields["image"]		= icon(cached_character_icon(H), dir = SOUTH)
		L.fields["antagfac"]	= H.antag_faction
		L.fields["antagvis"]	= H.antag_vis
		L.fields["offmap"]      = hidden
		if(H.exploit_record && !jobban_isbanned(H, "Records"))
			L.fields["exploit_record"] = H.exploit_record
		else
			L.fields["exploit_record"] = "No additional information acquired."
		locked += L
	return

/proc/generate_record_id()
	return add_zero(num2hex(rand(1, 65535)), 4)	//no point generating higher numbers because of the limitations of num2hex

/datum/datacore/proc/CreateGeneralRecord(mob/living/carbon/human/H, id, hidden)
	ResetPDAManifest()
	var/icon/front
	var/icon/side
	if(H)
		var/icon/charicon = cached_character_icon(H)
		front = icon(charicon, dir = SOUTH, frame = 1)
		side = icon(charicon, dir = WEST, frame = 1)
	else // Sending null things through browse_rsc() makes a runtime and breaks the console trying to view the record.
		front = icon('html/images/no_image32.png')
		side = icon('html/images/no_image32.png')

	if(!id)
		id = "[add_zero(num2hex(rand(1, 65536)), 4)]"
	var/datum/data/record/G = new /datum/data/record()
	G.name = "Employee Record #[id]"
	G.fields["name"] = "New Record"
	G.fields["id"] = id
	G.fields["rank"] = "Unassigned"
	G.fields["real_rank"] = "Unassigned"
	G.fields["sex"] = "Unknown"
	G.fields["age"] = "Unknown"
	G.fields["brain_type"] = "Unknown"
	G.fields["fingerprint"] = "Unknown"
	G.fields["p_stat"] = "Active"
	G.fields["m_stat"] = "Stable"
	G.fields["species"] = SPECIES_HUMAN
	G.fields["home_system"]	= "Unknown"
	G.fields["citizenship"]	= "Unknown"
	G.fields["faction"]		= "Unknown"
	G.fields["religion"]	= "Unknown"
	G.fields["photo_front"]	= front
	G.fields["photo_side"]	= side
	G.fields["photo-south"] = "'data:image/png;base64,[icon2base64(front)]'"
	G.fields["photo-west"] = "'data:image/png;base64,[icon2base64(side)]'"
	G.fields["notes"] = "No notes found."
	if(hidden)
		hidden_general += G
	else
		general += G

	return G

/datum/datacore/proc/CreateSecurityRecord(var/name, var/id, var/hidden)
	ResetPDAManifest()
	var/datum/data/record/R = new /datum/data/record()
	R.name = "Security Record #[id]"
	R.fields["name"] = name
	R.fields["id"] = id
	R.fields["brain_type"] = "Unknown"
	R.fields["criminal"]	= "None"
	R.fields["mi_crim"]		= "None"
	R.fields["mi_crim_d"]	= "No minor crime convictions."
	R.fields["ma_crim"]		= "None"
	R.fields["ma_crim_d"]	= "No major crime convictions."
	R.fields["notes"]		= "No notes."
	R.fields["notes"] = "No notes."
	if(hidden)
		hidden_security += R
	else
		security += R

	return R

/datum/datacore/proc/CreateMedicalRecord(var/name, var/id, var/hidden)
	ResetPDAManifest()
	var/datum/data/record/M = new()
	M.name = "Medical Record #[id]"
	M.fields["id"]			= id
	M.fields["name"]		= name
	M.fields["b_type"]		= "AB+"
	M.fields["b_dna"]		= md5(name)
	M.fields["id_gender"]	= "Unknown"
	M.fields["brain_type"]	= "Unknown"
	M.fields["mi_dis"]		= "None"
	M.fields["mi_dis_d"]	= "No minor disabilities have been declared."
	M.fields["ma_dis"]		= "None"
	M.fields["ma_dis_d"]	= "No major disabilities have been diagnosed."
	M.fields["alg"]			= "None"
	M.fields["alg_d"]		= "No allergies have been detected in this patient."
	M.fields["cdi"]			= "None"
	M.fields["cdi_d"]		= "No diseases have been diagnosed at the moment."
	M.fields["notes"] = "No notes found."
	if(hidden)
		hidden_medical += M
	else
		medical += M

	return M

/datum/datacore/proc/ResetPDAManifest()
	if(GLOB.PDA_Manifest.len)
		GLOB.PDA_Manifest.Cut()

/proc/find_general_record(field, value)
	return find_record(field, value, data_core.general)

/proc/find_medical_record(field, value)
	return find_record(field, value, data_core.medical)

/proc/find_security_record(field, value)
	return find_record(field, value, data_core.security)

/proc/find_record(field, value, list/L)
	for(var/datum/data/record/R in L)
		if(R.fields[field] == value)
			return R

/proc/GetAssignment(var/mob/living/carbon/human/H)
	. = "Unassigned"
	// var/faction = H.mind?.original_background_faction()?.id
	if(!H.mind.role_alt_title)
		. = H.mind.assigned_role
	else if(H.mind.role_alt_title)
		. = H.mind.role_alt_title
	else if(H.job)
		. =  H.job
