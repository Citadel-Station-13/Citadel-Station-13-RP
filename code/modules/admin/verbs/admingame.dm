/client/proc/player_panel()
	set name = "Player Panel"
	set category = "Admin"
	set desc = "See all players and their Player Panel."

	if(!check_rights(R_ADMIN))
		return

	holder.player_panel()
	feedback_add_details("admin_verb","PPN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/datum/admins/proc/show_player_panel(mob/player in GLOB.mob_list)
	set category = "Admin"
	set name = "Show Player Panel"
	set desc="Edit player (respawn, ban, heal, etc)"

	if(!check_rights(R_ADMIN))
		return

	var/mob/user = usr
	log_admin("[key_name(user)] checked the individual player panel for [key_name(player)][isobserver(user)?"":" while in game"].")

	if(!player)
		to_chat(user, SPAN_WARNING("You seem to be selecting a mob that doesn't exist anymore."), confidential = TRUE)
		return

	var/body = "<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title>Options for [player.key]</title></head>"
	body += "<body>Options panel for <b>[player]</b>"
	if(player.client)
		body += " played by <b>[player.client]</b> "
		body += "\[<A href='byond://?_src_=holder;[HrefToken()];editrights=show;key=[player.key]'>[player.client.holder ? player.client.holder.rank : "Player"]</A>\]"

	if(isnewplayer(player))
		body += " <B>Hasn't Entered Game</B> "
	else
		body += " \[<A href='byond://?_src_=holder;[HrefToken()];revive=[REF(player)]'>Heal</A>\] "

	if(player.client)
		body += "<br>\[<b>First Seen:</b> [player.client.player.player_age] days ago\]"
		body += "<br>\[<b>Byond account registered on:</b> [player.client.persistent.account_join]\]"
		body += "<br>\[<b>Byond account age (days):</b> [player.client.persistent.account_age]\]"
		var/full_version = "Unknown"
		if(player.client.byond_version)
			full_version = "[player.client.byond_version].[player.client.byond_build ? player.client.byond_build : "xxx"]"
		body += "<br>\[<b>Byond version:</b> [full_version]\]<br>"


	body += "<br><br>\[ "
	body += "<a href='byond://?_src_=vars;[HrefToken()];Vars=[REF(player)]'>VV</a> - "
	if(player.mind)
		body += "<a href='byond://?_src_=holder;[HrefToken()];traitor=[REF(player)]'>TP</a> - "
	body += "<a href='byond://?priv_msg=[player.ckey]'>PM</a> - "
	body += "<a href='byond://?_src_=holder;[HrefToken()];subtlemessage=[REF(player)]'>SM</a> - "
	body += admin_jump_link(player)

	body += "<b>Mob type</b> = [player.type]"
	body += "<b>Inactivity time:</b> [player.client ? "[player.client.inactivity/600] minutes" : "Logged out"]<br><br>"

	body += "<A href='byond://?_src_=holder;[HrefToken()];boot2=[REF(player)]'>Kick</A> | "
	body += "<A href='byond://?_src_=holder;[HrefToken()];newban=[REF(player)]'>Ban</A> | "
	body += "<A href='byond://?_src_=holder;[HrefToken()];jobban2=[REF(player)]'>Jobban</A> | "
	body += "<A href='byond://?_src_=holder;[HrefToken()];oocban=[player.ckey]'>[SSbans.t_is_role_banned_ckey(player.ckey, role = BAN_ROLE_OOC)? "<font color='red'>OOC Ban</font>" : "OOC Ban"]</A> | "

	body += "<A href='byond://?_src_=holder;[HrefToken()];notes=show;mob=[REF(player)]'>Notes | Messages</A> | "

	if(player.client)
		var/muted = player.client.prefs.muted
		body += "<br><b>Mute: </b> "
		body += "\[<A href='byond://?_src_=holder;[HrefToken()];mute=[REF(player)];mute_type=[MUTE_IC]'><font color='[(muted & MUTE_IC)?"red":"blue"]'>IC</font></a> | "
		body += "<A href='byond://?_src_=holder;[HrefToken()];mute=[REF(player)];mute_type=[MUTE_OOC]'><font color='[(muted & MUTE_OOC)?"red":"blue"]'>OOC</font></a> | "
		body += "<A href='byond://?_src_=holder;[HrefToken()];mute=[REF(player)];mute_type=[MUTE_PRAY]'><font color='[(muted & MUTE_PRAY)?"red":"blue"]'>PRAY</font></a> | "
		body += "<A href='byond://?_src_=holder;[HrefToken()];mute=[REF(player)];mute_type=[MUTE_ADMINHELP]'><font color='[(muted & MUTE_ADMINHELP)?"red":"blue"]'>ADMINHELP</font></a> | "
		body += "<A href='byond://?_src_=holder;[HrefToken()];mute=[REF(player)];mute_type=[MUTE_DEADCHAT]'><font color='[(muted & MUTE_DEADCHAT)?"red":"blue"]'>DEADCHAT</font></a>\]"
		body += "(<A href='byond://?_src_=holder;[HrefToken()];mute=[REF(player)];mute_type=[MUTE_ALL]'><font color='[(muted & MUTE_ALL)?"red":"blue"]'>toggle all</font></a>)"

	body += "<br><br>"
	body += "<A href='byond://?_src_=holder;[HrefToken()];jumpto=[REF(player)]'><b>Jump to</b></A> | "
	body += "<A href='byond://?_src_=holder;[HrefToken()];getmob=[REF(player)]'>Get</A> | "
	body += "<A href='byond://?_src_=holder;[HrefToken()];sendmob=[REF(player)]'>Send To</A>"

	body += "<br><br>"
	body += "<A href='byond://?_src_=holder;[HrefToken()];traitor=[REF(player)]'>Traitor panel</A> | "
	body += "<A href='byond://?_src_=holder;[HrefToken()];narrateto=[REF(player)]'>Narrate to</A> | "
	body += "<A href='byond://?_src_=holder;[HrefToken()];subtlemessage=[REF(player)]'>Subtle message</A>"

	if(player.client)
		if(!isnewplayer(player))
			body += "<br><br>"
			body += "<b>Transformation:</b><br>"
			if(isobserver(player))
				body += "<b>Ghost</b> | "
			else
				body += "<A href='byond://?_src_=holder;[HrefToken()];simplemake=observer;mob=[REF(player)]'>Make Ghost</A> | "

			if(ishuman(player) && !issmall(player))
				body += "<b>Human</b> | "
			else
				body += "<A href='byond://?_src_=holder;[HrefToken()];simplemake=human;mob=[REF(player)]'>Make Human</A> | "

			//Monkey
			if(issmall(player))
				body += "<b>Monkey</b> | "
			else
				body += "<A href='byond://?_src_=holder;[HrefToken()];simplemake=monkey;mob=[REF(player)]'>Make Monkey</A> | "

			if(isrobot(player))
				body += "<b>Cyborg</b> | "
			else
				body += "<A href='byond://?_src_=holder;[HrefToken()];makerobot=[REF(player)]'>Make Cyborg</A> | "

			if(isAI(player))
				body += "<b>AI</b>"
			else
				body += "<A href='byond://?_src_=holder;[HrefToken()];makeai=[REF(player)]'>Make AI</A>"

			if (isalien(player))
				body += "<b>Alien</b>"
			else
				body += "<A href='byond://?_src_=holder;[HrefToken()];makealien=[REF(player)]'>Make Alien</A>"

			//Simple Animals
			if(isanimal_legacy_this_is_broken(player))
				body += "<A href='byond://?_src_=holder;[HrefToken()];makeanimal=[REF(player)]'>Re-Animalize</A> | "
			else
				body += "<A href='byond://?_src_=holder;[HrefToken()];makeanimal=[REF(player)]'>Animalize</A> | "

			// DNA2 - Admin Hax
			if(player.dna && iscarbon(player))
				body += "<br><br>"
				body += "<b>DNA Blocks:</b><br><table border='0'><tr><th>&nbsp;</th><th>1</th><th>2</th><th>3</th><th>4</th><th>5</th>"
				var/bname
				for(var/block=1;block<=DNA_SE_LENGTH;block++)
					if(((block-1)%5)==0)
						body += "</tr><tr><th>[block-1]</th>"
					bname = assigned_blocks[block]
					body += "<td>"
					if(bname)
						var/bstate=player.dna.GetSEState(block)
						var/bcolor="[(bstate)?"#006600":"#ff0000"]"
						body += "<A href='byond://?_src_=holder;[HrefToken()];togmutate=[REF(player)];block=[block]' style='color:[bcolor];'>[bname]</A><sub>[block]</sub>"
					else
						body += "[block]"
					body+="</td>"
				body += "</tr></table>"

			body += {"<br><br>
				<b>Rudimentary transformation:</b><font size=2><br>These transformations only create a new mob type and copy stuff over. They do not take into account MMIs and similar mob-specific things. The buttons in 'Transformations' are preferred, when possible.</font><br>
				\[ Xenos: <A href='byond://?_src_=holder;[HrefToken()];simplemake=larva;mob=[REF(player)]'>Larva</A>
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=human;species=Xenomorph Drone;mob=[REF(player)]'>Drone</A>
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=human;species=Xenomorph Hunter;mob=[REF(player)]'>Hunter</A>
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=human;species=Xenomorph Sentinel;mob=[REF(player)]'>Sentinel</A>
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=human;species=Xenomorph Queen;mob=[REF(player)]'>Queen</A> \] |
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=human;species=Unathi;mob=[REF(player)]'>Unathi</A>
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=human;species=Tajaran;mob=[REF(player)]'>Tajaran</A>
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=human;species=Skrell;mob=[REF(player)]'>Skrell</A> \] | \[
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=nymph;mob=[REF(player)]'>Nymph</A>
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=human;species='Diona';mob=[REF(player)]'>Diona</A> \] |
				\[ slime: <A href='byond://?_src_=holder;[HrefToken()];simplemake=slime;mob=[REF(player)]'>Baby</A>,
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=adultslime;mob=[REF(player)]'>Adult</A> \]
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=monkey;mob=[REF(player)]'>Monkey</A> |
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=robot;mob=[REF(player)]'>Cyborg</A> |
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=cat;mob=[REF(player)]'>Cat</A> |
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=runtime;mob=[REF(player)]'>Runtime</A> |
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=corgi;mob=[REF(player)]'>Corgi</A> |
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=ian;mob=[REF(player)]'>Ian</A> |
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=crab;mob=[REF(player)]'>Crab</A> |
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=coffee;mob=[REF(player)]'>Coffee</A> |
				\[ Construct: <A href='byond://?_src_=holder;[HrefToken()];simplemake=constructarmoured;mob=[REF(player)]'>Armoured</A> ,
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=constructbuilder;mob=[REF(player)]'>Builder</A> ,
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=constructwraith;mob=[REF(player)]'>Wraith</A> \]
				<A href='byond://?_src_=holder;[HrefToken()];simplemake=shade;mob=[REF(player)]'>Shade</A>
				<br>
			"}

	body += "<br><br>"
	body += "<b>Other actions:</b>"
	body += "<br>"

	if(!isnewplayer(player))
		body += "<A href='byond://?_src_=holder;[HrefToken()];forcespeech=[REF(player)]'>Forcesay</A> | "
		body += "<A href='byond://?_src_=holder;[HrefToken()];tdome1=[REF(player)]'>Thunderdome 1</A> | "
		body += "<A href='byond://?_src_=holder;[HrefToken()];tdome2=[REF(player)]'>Thunderdome 2</A> | "
		body += "<A href='byond://?_src_=holder;[HrefToken()];tdomeadmin=[REF(player)]'>Thunderdome Admin</A> | "
		body += "<A href='byond://?_src_=holder;[HrefToken()];tdomeobserve=[REF(player)]'>Thunderdome Observer</A> | "

	// language toggles
	body += "<br><br><b>Languages:</b><br>"
	var/f = 1
	for(var/datum/prototype/language/L as anything in tim_sort(RSlanguages.fetch_subtypes_immutable(/datum/prototype/language), /proc/cmp_name_asc))
		if(!(L.language_flags & LANGUAGE_INNATE))
			if(!f) body += " | "
			else f = 0
			if(L in player.languages)
				body += "<a href='byond://?_src_=holder;[HrefToken()];toglang=[REF(player)];lang=[html_encode(L.name)]' style='color:#006600'>[L.name]</a>"
			else
				body += "<a href='byond://?_src_=holder;[HrefToken()];toglang=[REF(player)];lang=[html_encode(L.name)]' style='color:#ff0000'>[L.name]</a>"

	body += "<br>"
	body += "</body></html>"

	user << browse(body, "window=adminplayeropts-[REF(player)];size=550x540")
	feedback_add_details("admin_verb","SPP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_godmode(mob/M in GLOB.mob_list)
	set category = "Special Verbs"
	set name = "Godmode"

	if(!check_rights(R_ADMIN))
		return

	M.status_flags ^= STATUS_GODMODE
	to_chat(usr, SPAN_ADMINNOTICE("Toggled [(M.status_flags & STATUS_GODMODE) ? "ON" : "OFF"]"), confidential = TRUE)

	log_admin("[key_name(usr)] has toggled [key_name(M)]'s nodamage to [(M.status_flags & STATUS_GODMODE) ? "On" : "Off"]")
	var/msg = "[key_name_admin(usr)] has toggled [ADMIN_LOOKUPFLW(M)]'s nodamage to [(M.status_flags & STATUS_GODMODE) ? "On" : "Off"]"
	message_admins(msg)
	admin_ticket_log(M, msg)
	feedback_add_details("admin_verb","GOD") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/*
If a guy was gibbed and you want to revive him, this is a good way to do so.
Works kind of like entering the game with a new character. Character receives a new mind if they didn't have one.
Traitors and the like can also be revived with the previous role mostly intact.
/N */
/client/proc/respawn_character()
	set category = "Special Verbs"
	set name = "Spawn Character"
	set desc = "(Re)Spawn a client's loaded character."
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return

	//I frontload all the questions so we don't have a half-done process while you're reading.
	var/client/picked_client = input(src, "Please specify which client's character to spawn.", "Client", "") as null|anything in GLOB.clients
	if(!picked_client)
		return

	var/location = alert(src,"Please specify where to spawn them.", "Location", "Right Here", "Arrivals", "Cancel")
	if(location == "Cancel" || !location)
		return

	var/announce = alert(src,"Announce as if they had just arrived?", "Announce", "Yes", "No", "Cancel")
	if(announce == "Cancel")
		return
	else if(announce == "Yes") //Too bad buttons can't just have 1/0 values and different display strings
		announce = 1
	else
		announce = 0

	var/inhabit = alert(src,"Put the person into the spawned mob?", "Inhabit", "Yes", "No", "Cancel")
	if(inhabit == "Cancel")
		return
	else if(inhabit == "Yes")
		inhabit = 1
	else
		inhabit = 0

	//Name matching is ugly but mind doesn't persist to look at.
	var/charjob
	var/records

	var/datum/data/record/record_found
	record_found = find_general_record("name",picked_client.prefs.real_name)

	//Found their record, they were spawned previously
	if(record_found)
		var/samejob = alert(src,"Found [picked_client.prefs.real_name] in data core. They were [record_found.fields["real_rank"]] this round. Assign same job? They will not be re-added to the manifest/records, either way.","Previously spawned","Yes","Assistant","No")
		if(samejob == "Yes")
			charjob = record_found.fields["real_rank"]
		else if(samejob == USELESS_JOB)
			charjob = USELESS_JOB
	else
		records = alert(src,"No data core entry detected. Would you like add them to the manifest, and sec/med/HR records?","Records","Yes","No","Cancel")
		if(records == "Cancel")
			return
		if(records == "Yes")
			records = 1
		else
			records = 0

	//Well you're not reloading their job or they never had one.
	if(!charjob)
		var/pickjob = input(src,"Pick a job to assign them (or none).","Job Select","-No Job-") as null|anything in RSroles.legacy_all_job_titles() + "-No Job-"
		if(!pickjob)
			return
		if(pickjob != "-No Job-")
			charjob = pickjob

	//If you've picked a job by now, you can equip them.
	var/equipment
	if(charjob)
		equipment = alert(src,"Spawn them with equipment?", "Equipment", "Yes", "No", "Cancel")
		if(equipment == "Cancel")
			return
		else if(equipment == "Yes")
			equipment = 1
		else
			equipment = 0

	//For logging later
	var/admin = key_name_admin(src)
	var/player_key = picked_client.key
	// Needed for persistence
	var/picked_ckey = picked_client.ckey
	var/picked_slot = picked_client.prefs.default_slot

	var/mob/living/carbon/human/new_character
	var/spawnloc

	//Where did you want to spawn them?
	switch(location)
		if("Right Here") //Spawn them on your turf
			if(!src.mob)
				to_chat(src, "You can't use 'Right Here' when you are not 'Right Anywhere'!")
				return

			spawnloc = get_turf(src.mob)

		if("Arrivals") //Spawn them at a latejoin spawnpoint
			spawnloc = SSjob.get_latejoin_spawnpoint(faction = JOB_FACTION_STATION)?.GetSpawnLoc()

		else //I have no idea how you're here
			to_chat(src, "Invalid spawn location choice.")
			return

	//Did we actually get a loc to spawn them?
	if(!spawnloc)
		to_chat(src, "Couldn't get valid spawn location.")
		return

	// todo: this entire stack is awful and should be a ssjob thing maybe

	new_character = new(spawnloc)
	new_character.mind_initialize()

	//We were able to spawn them, right?
	if(!new_character)
		to_chat(src, "Something went wrong and spawning failed.")
		return

	//Write the appearance and whatnot out to the character
	picked_client.prefs.copy_to(new_character)
	if(new_character.dna)
		new_character.dna.ResetUIFrom(new_character)
		new_character.sync_organ_dna()
	if(inhabit)
		new_character.set_ckey(ckey(player_key))
		//Were they any particular special role? If so, copy.
		if(new_character.mind)
			var/datum/antagonist/antag_data = get_antag_data(new_character.mind.special_role)
			if(antag_data)
				antag_data.add_antagonist(new_character.mind)
				antag_data.place_mob(new_character)

	// Required for persistence
	if(new_character.mind)
		new_character.mind.loaded_from_ckey = picked_ckey
		new_character.mind.loaded_from_slot = picked_slot

	//If desired, apply equipment.
	if(equipment)
		if(charjob)
			SSjob.EquipRank(new_character, charjob, 1)

	//If desired, add records.
	if(records)
		data_core.manifest_inject(new_character)

	//A redraw for good measure
	new_character.regenerate_icons()

	//If we're announcing their arrival
	if(announce)
		AnnounceArrival(new_character, new_character.mind.assigned_role, "[new_character], [new_character.mind.assigned_role], will arrive shortly.")

	var/msg = SPAN_ADMINNOTICE("[admin] has (re)spawned [player_key] as [new_character.real_name].")
	message_admins(msg)
	admin_ticket_log(new_character, msg)

	to_chat(new_character, "You have been fully (re)spawned. Enjoy the game.", confidential = TRUE)

	feedback_add_details("admin_verb","RSPCH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	return new_character

/client/proc/free_slot()
	set name = "Free Job Slot"
	set category = "Admin"

	if(!check_rights())
		return

	if(!SSjob.initialized)
		tgui_alert(usr, "You cannot manage jobs before the job subsystem is initialized!")
		return

	if(holder)
		var/list/jobs = list()
		for (var/datum/prototype/role/job/J in RSroles.legacy_all_job_datums())
			if (J.current_positions >= J.total_positions && J.total_positions != -1)
				jobs += J.title
		if (!jobs.len)
			to_chat(usr, "There are no fully staffed jobs.")
			return
		var/job = input("Please select job slot to free", "Free job slot")  as null|anything in jobs
		if (job)
			SSjob.FreeRole(job)
			message_admins("A job slot for [job] has been opened by [key_name_admin(usr)]")
			return

/client/proc/check_antagonists()
	set name = "Check Antagonists"
	set category = "Admin"
	if(holder)
		holder.check_antagonists()
		log_admin("[key_name(usr)] checked antagonists.")	//for tsar~
	feedback_add_details("admin_verb","CHA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return
