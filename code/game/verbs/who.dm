// todo: combine with advanced who wtf is this shit
// todo: /client/proc/who_query(client/asker, admin_rights, ...) be used for building the string?

/client/verb/who()
	set name = "Who"
	set category = VERB_CATEGORY_OOC

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	if(holder && (R_ADMIN & holder.rights || R_MOD & holder.rights))
		for(var/client/C in GLOB.clients)
			var/entry = "\t[C.get_revealed_key()]"
			if(!C.initialized)
				entry += "[C.ckey] - <b><font color='red'>Uninitialized</font></b>"
				Lines += entry
				continue
			if(!C.initialized)
				entry += " - [SPAN_BOLDANNOUNCE("UNINITIALIZED!")]"
				continue
			if(isnull(C.mob))
				entry += " - [SPAN_BOLDANNOUNCE("NULL MOB!")]"
				continue
			entry += " - Playing as [C.mob.real_name]"
			switch(C.mob.stat)
				if(UNCONSCIOUS)
					entry += " - <font color='darkgray'><b>Unconscious</b></font>"
				if(DEAD)
					if(isobserver(C.mob))
						var/mob/observer/dead/O = C.mob
						if(O.started_as_observer)
							entry += " - <font color='gray'>Observing</font>"
						else
							entry += " - <font color='black'><b>DEAD</b></font>"
					else
						entry += " - <font color='black'><b>DEAD</b></font>"

			var/age
			if(isnum(C.player.player_age))
				age = C.player.player_age
			else
				age = 0

			if(age <= 1)
				age = "<font color='#ff0000'><b>[age]</b></font>"
			else if(age < 10)
				age = "<font color='#ff8c00'><b>[age]</b></font>"

			entry += " - [age]"

			if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Antagonist</font></b>"

			if(C.is_afk())
				var/seconds = C.last_activity_seconds()
				entry += " (AFK - "
				entry += "[round(seconds / 60)] minutes, "
				entry += "[seconds % 60] seconds)"

			entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			Lines += entry
	else
		for(var/client/C in GLOB.clients)
			var/entry = "\t"
			if(!C.initialized)
				entry += "[C.ckey] - <b><font color='red'>Uninitialized</font></b>"
				Lines += entry
				continue
			if(C == src)
				entry += "[C.get_revealed_key()]"
			else
				entry += "[C.get_public_key()]"
			if(C.get_preference_toggle(/datum/game_preference_toggle/presence/show_advanced_who))
				if(isobserver(C.mob))
					entry += " - <font color='gray'>Observing</font>"
				else if(istype(C.mob, /mob/new_player))
					entry += " - <font color=#4F49AF>In Lobby</font>"
				else
					entry += " - <font color='#5fe312'>Playing</font>"
			Lines += entry

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	to_chat(src, msg)

/client/verb/staffwho()
	set category = "Admin"
	set name = "Staffwho"

	var/msg = ""
	var/num_admins_online = 0
	if(holder)
		for(var/client/C in GLOB.admins)
			if(!C.initialized)
				continue

			if(C.is_under_stealthmin() && !((R_ADMIN|R_MOD) & holder.rights))
				continue

			msg += "\t[C.get_revealed_key()] is a [C.holder.rank]"

			if(isobserver(C.mob))
				msg += " - Observing"
			else if(istype(C.mob,/mob/new_player))
				msg += " - Lobby"
			else
				msg += " - Playing"

			if(C.is_afk())
				var/seconds = C.last_activity_seconds()
				msg += " (AFK - "
				msg += "[round(seconds / 60)] minutes, "
				msg += "[seconds % 60] seconds)"
			msg += "\n"
			num_admins_online++

	else
		for(var/client/C in GLOB.admins)
			if(!C.initialized)
				continue
			if(C.is_under_stealthmin())
				continue	// hidden
			msg += "\t[C] is a [C.holder.rank]"
			num_admins_online++
			if(C.is_afk(10 MINUTES))
				if(C.is_afk(30 MINUTES))
					msg += " (AFK \[30m+\])"
				else
					msg += " (Inactive \[10m+\])"
			msg += "\n"

	msg = "<b>Current Admins ([num_admins_online]):</b>\n" + msg

	to_chat(src, msg)
