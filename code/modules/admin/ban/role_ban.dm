//? Role ban system
//? Rolebans are for taking functionality away from problematic players.
//? If you want a player off the server / there's no point in keeping then,
//? use server_ban.dm functions instead.

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
/proc/role_ban_ckey(ckey, character_id, role, minutes, reason, datum/admins/admin)
	ASSERT(isnull(minutes) || (isnum(minutes) && minutes > 0))
	// sanitize just in case
	ckey = ckey(ckey)

	if(IsAdminAdvancedProcCall())
		return // use the panel!

	//? shitcode alert: for now, db bans *must* be anchored to an admin datum.

	. = admin?.DB_ban_record(isnull(minutes)? BANTYPE_JOB_PERMA : BANTYPE_JOB_TEMP, duration = isnull(minutes)? -1 : minutes, job = role, banckey = ckey, reason = reason) || FALSE

// todo: query_role_banned_ckey(ckey)
// todo: why_role_banned_ckey(ckey)
// todo: time_role_banned_ckey(ckey)

// todo: for the above, we should probably make the overhead not miserable by caching it in /datum/player_data.

// todo: x_role_y_player(...) for player ids instead
