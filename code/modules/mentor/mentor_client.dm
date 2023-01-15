/client
	/**
	 * Acts the same way holder does towards admin: it holds the mentor datum.
	 * If set, the guy's a mentor.
	 */
	var/datum/mentors/mentor_datum

/client/New()
	. = ..()
	mentor_datum_set()

/client/proc/is_mentor() // admins are mentors too.
	if(mentor_datum || check_rights_for(src, R_ADMIN,0))
		return TRUE

/client/proc/mentor_datum_set(admin)
	mentor_datum = GLOB.mentor_datums[ckey]
	if(!mentor_datum && check_rights_for(src, R_ADMIN,0)) // admin with no mentor datum?let's fix that
		new /datum/mentors(ckey)
	if(mentor_datum)
		if(!check_rights_for(src, R_ADMIN,0) && !admin)
			GLOB.mentors |= src // don't add admins to this list too.
		mentor_datum.owner = src
		add_mentor_verbs()
		mentor_memo_output("Show")

/client/proc/reload_mentors()
	set name = "Reload Mentors"
	set category = "Admin"
	if(!src.holder)
		return
	load_mentors()
	message_admins("[key_name_admin(usr)] manually reloaded mentors")
