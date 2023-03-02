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
/proc/is_role_banned_ckey(ckey, character_id, role)
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
 * ban someone from a role for a certain time, specified in deciseconds.
 *
 * BAN_ROLE_SERVER is not allowed here.
 *
 * @params
 * * ckey - the player's ckey
 * * character_id - the character's id, null for global account ban
 * * role - role enum check [code/__DEFINES/admin/bans.dm] - BAN_ROLE_SERVER is not allowed here!
 * * time - deciseconds from Now() - null for permanent
 *
 * @return TRUE / FALSE on success / failure
 */
/proc/role_ban_ckey(ckey, character_id, role, time)
	ASSERT(isnull(time) || (isnum(time) && time > 0))

	// isolate from proccall, this is sanitized
	var/mob/old_usr = usr
	usr = null

	//? shitcode alert: for now, db bans *must* be anchored to an admind atum.

	var/datum/admins/holder_datum = old_usr?.client?.holder
	if(!istype(holder_datum)) // hard istype, no rnutimes allowed
		. = FALSE
	else
		. = holder_datum.DB_ban_record(isnull(time)? BANTYPE_JOB_PERMA : BANTYPE_JOB_TEMP, duration = isnull(time)? -1 : duration, job = role, banckey = ckey)

	// restore admin proccall
	usr = old_usr

// todo: query_role_banned_ckey(ckey)
// todo: why_role_banned_ckey(ckey)
// todo: time_role_banned_ckey(ckey)

// todo: for the above, we should probably make the overhead not miserable by caching it in /datum/player_data.

// todo: x_role_y_player(...) for player ids instead
