//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// ban wrappers until we make new ban system

/datum/controller/subsystem/bans/proc/t_place_system_ban(bantype, mob/banned_mob, duration = -1, reason, job = "", rounds = 0, banckey = null, banip = null, bancid = null)
	if(!SSdbcore.Connect())
		return

	var/serverip = "[world.internet_address]:[world.port]"
	var/bantype_pass = 0
	var/bantype_str
	switch(bantype)
		if(BANTYPE_PERMA)
			bantype_str = "PERMABAN"
			duration = -1
			bantype_pass = 1
		if(BANTYPE_TEMP)
			bantype_str = "TEMPBAN"
			bantype_pass = 1
		if(BANTYPE_JOB_PERMA)
			bantype_str = "JOB_PERMABAN"
			duration = -1
			bantype_pass = 1
		if(BANTYPE_JOB_TEMP)
			bantype_str = "JOB_TEMPBAN"
			bantype_pass = 1
	if( !bantype_pass ) return
	if( !istext(reason) ) return
	if( !isnum(duration) ) return

	var/ckey
	var/computerid
	var/ip

	if(ismob(banned_mob))
		ckey = banned_mob.ckey
		if(banned_mob.client)
			computerid = banned_mob.client.computer_id
			ip = banned_mob.client.address
	else if(banckey)
		ckey = ckey(banckey)
		computerid = bancid
		ip = banip

	var/a_ckey
	var/a_computerid
	var/a_ip

	var/who
	for(var/client/C in GLOB.clients)
		if(!who)
			who = "[C]"
		else
			who += ", [C]"

	var/adminwho
	for(var/client/C in GLOB.admins)
		if(!adminwho)
			adminwho = "[C]"
		else
			adminwho += ", [C]"

	reason = sql_sanitize_text(reason)

	if(isnull(computerid))
		computerid = ""
	if(isnull(ip))
		ip = ""
	var/sql = "INSERT INTO [DB_PREFIX_TABLE_NAME("ban")] \
	(`id`,`bantime`,`serverip`,`bantype`,`reason`,`job`,`duration`,`rounds`,`expiration_time`,`ckey`,`computerid`,`ip`,`a_ckey`,`a_computerid`,`a_ip`,`who`,`adminwho`,`edits`,`unbanned`,`unbanned_datetime`,`unbanned_ckey`,`unbanned_computerid`,`unbanned_ip`) \
	VALUES (null, Now(), :serverip, :type, :reason, :job, :duration, :rounds, Now() + INTERVAL :duration MINUTE, :ckey, :cid, :ip, :a_ckey, :a_cid, :a_ip, :who, :adminwho, '', null, null, null, null, null)"
	SSdbcore.RunQuery(
		sql,
		list(
			"serverip" = serverip,
			"type" = bantype_str,
			"reason" = reason,
			"job" = job,
			"duration" = duration? duration : 0,
			"rounds" = rounds? rounds : 0,
			"ckey" = ckey,
			"cid" = computerid,
			"ip" = ip,
			"a_ckey" = a_ckey,
			"a_cid" = a_computerid,
			"a_ip" = a_ip,
			"who" = who,
			"adminwho" = adminwho
		)
	)
	to_chat(usr, "<font color=#4F49AF>Ban saved to database.</font>")
	message_admins("[key_name_admin(usr)] has added a [bantype_str] for [ckey] [(job)?"([job])":""] [(duration > 0)?"([duration] minutes)":""] with the reason: \"[reason]\" to the ban database.",1)
	. = TRUE

	// reload
	jobban_loadbanfile()


/**
 * master proc to check if someone's banned from a role
 *
 * @params
 * * ckey - the player's ckey
 * * character_id - the character's id, null for global account ban
 * * role - role enum check [code/__DEFINES/admin/bans.dm]
 *
 * @return TRUE / FALSE for if they are banned right now
 */
/datum/controller/subsystem/bans/proc/t_is_role_banned_ckey(ckey, character_id, role)
	// sanitize just in case
	ckey = ckey(ckey)

	// isolate from proccall, this is sanitized
	var/mob/old_usr = usr
	usr = null

	. = FALSE

	switch(role)
		if(BAN_ROLE_SERVER)
			. = world.IsBanned(ckey)
		else
			// lol this is dumb, refactor jobbans when
			for(var/str as anything in jobban_keylist)
				if(findtext(str, "[ckey] - [role]") == 1)
					. = TRUE

	// restore admin proccall
	usr = old_usr

/**
 * ban someone from a role for a certain time, specified in minutes.
 *
 * BAN_ROLE_SERVER is not allowed here.
 *
 * @params
 * * ckey - the player's ckey
 * * character_id - the character's id, null for global account ban
 * * role - role enum check [code/__DEFINES/admin/bans.dm] - BAN_ROLE_SERVER is not allowed here!
 * * minutes - minutes from Now() - null for permanent
 * * reason - why?
 * * admin - the banning admin, if any
 *
 * @return TRUE / FALSE on success / failure
 */
/datum/controller/subsystem/bans/proc/t_role_ban_ckey(ckey, character_id, role, minutes, reason, datum/admins/admin)
	ASSERT(isnull(minutes) || (isnum(minutes) && minutes > 0))
	// sanitize just in case
	ckey = ckey(ckey)

	if(IsAdminAdvancedProcCall())
		return // use the panel!

	//? shitcode alert: for now, db bans *must* be anchored to an admin datum.

	. = admin?.DB_ban_record(isnull(minutes)? BANTYPE_JOB_PERMA : BANTYPE_JOB_TEMP, duration = isnull(minutes)? -1 : minutes, job = role, banckey = ckey, reason = reason) || FALSE
