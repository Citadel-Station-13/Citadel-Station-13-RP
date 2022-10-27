/datum/category_group/player_setup_category/occupation_preferences
	name = "Occupation"
	sort_order = 3
	category_item_type = /datum/category_item/player_setup_item/occupation
	auto_split = FALSE

/datum/category_item/player_setup_item/occupation
	is_global = FALSE

/**
 * save format: list(job id = priority)
 */
/datum/category_item/player_setup_item/occupation/jobs
	name = "Job Preferences"
	save_key = CHARACTER_DATA_JOBS

/datum/category_item/player_setup_item/occupation/jobs/filter(datum/preferences/prefs, data, list/errors)
	var/list/jobs = sanitize_islist(data)
	var/highest
	for(var/id in jobs)
		var/datum/job/J = SSjob.job_by_id(id)
		if(!J)
			jobs -= id
			continue
		if(jobs[id] == JOB_PRIORITY_HIGH)
			if(highest)
				jobs[id] = JOB_PRIORITY_MEDIUM
			else
				highest = jobs[id]
	return jobs

#define START_COLUMN . += "<td width='10%' valign='top'><table width='100%' cellpadding='1' cellspacing='0'>"
#define END_COLUMN . += "</table></td>"
#define NEW_COLUMN START_COLUMN; END_COLUMN; count = 0;
/datum/category_item/player_setup_item/occupation/jobs/content(datum/preferences/prefs, mob/user, data)
	// cast data
	var/list/current = data
	// if they have assistant selected all other jobs are irrelevant
	var/assistant_selected = !!current[JOB_ID_ASSISTANT]
	// prep list
	. = list()
	// monospace
	. += "<tt>"
	// center
	. += "<center>"
	// user intro
	. += "<h3>Choose occupation preferences</h3><br>Unavailable occupations are crossed out.<br>"
	// script inject for right click
	. += "<script type='text/javascript'>function setjob(id,lvl) { window.location.href = '?src=\ref[src];action=job;id=' + encodeURIComponent(lvl) + ';level=' + lvl; return false; }</script>"
	// grab job-by-department ui cache
	var/list/ui_data = SSjob.job_pref_ui_cache
	// build - one faction
	if(length(ui_data) == 1)
		// form table
		. += "<table width='100%' cellpadding='1' cellspacing='0'><tr>"
		// form column
		START_COLUMN
		// iterate
		var/count = 0
		var/limit = max(5, SSjob.job_pref_ui_per)
		for(var/list/department in ui_data[ui_data[1]])
			var/dep_amt = length(department)
			// if we'd hit limit, we split first as we're not longer than limit or would waste more than 4 slots.
			if(count + dep_amt > limit && dep_amt <= limit && limit - count <= 4)
				NEW_COLUMN
			for(var/id in department)
				. += render_job(prefs, SSjob.job_by_id(id), current[id], assistant_selected)
				++count
				if(count >= limit)
					NEW_COLUMN
		// close column
		END_COLUMN
		// close table
		. += "</tr></table>"
		// linebreak
		. += "<br>"
	// build - multi-faction
	else
		. += "<br>"
		for(var/faction in ui_data)
			// header
			. += "<b>[faction]</b>"
			// form table
			. += "<table width='100%' cellpadding='1' cellspacing='0'><tr>"
			// form column
			START_COLUMN
			// iterate
			var/count = 0
			var/limit = max(5, SSjob.job_pref_ui_per)
			for(var/list/department in ui_data[faction])
				var/dep_amt = length(department)
				// if we'd hit limit, we split first as we're not longer than limit or would waste more than 4 slots.
				if(count + dep_amt > limit && dep_amt <= limit && limit - count <= 4)
					NEW_COLUMN
				for(var/id in department)
					. += render_job(prefs, SSjob.job_by_id(id), current[id], assistant_selected)
					++count
					if(count >= limit)
						NEW_COLUMN
			// close column
			END_COLUMN
			// close table
			. += "</tr></table>"
			// linebreak
			. += "<br>"
	// remove monospace
	. += "</tt>"
	// add alternative options
	switch(prefs.get_character_data(CHARACTER_DATA_OVERFLOW_MODE))
		if(JOB_ALTERNATIVE_GET_RANDOM)
			. += href_simple(prefs, "overflow", "<u>Get random job if preferences unavailable</u>")
		if(JOB_ALTERNATIVE_BE_ASSISTANT)
			. += href_simple(prefs, "overflow", "<u>Be assistant if preference unavailable</u>")
		if(JOB_ALTERNATIVE_RETURN_LOBBY)
			. += href_simple(prefs, "overflow", "<u>Return to lobby if preference unavailable</u>")
	// add reset
	. += href_simple(prefs, "reset", "\[Reset]")
	// remove center
	. += "</center>"

#undef NEW_COLUMN
#undef END_COLUMN
#undef START_COLUMN

/datum/category_item/player_setup_item/occupation/jobs/proc/render_job(datum/preferences/prefs, datum/job/J, current_priority, assistant_selected)
	. = list()
	. += "<tr bgcolor='[J.selection_color]'><td width='60%' align='right'>"
	// left side
	. += "<a href='?src=[REF(src)];prefs=[REF(prefs)];act=help;help=[J.id]'>\[?]</a> "
	var/rank
	if((J.title in SSjob.get_job_titles_in_department(DEPARTMENT_COMMAND)) || (J.id == JOB_ID_AI))
		rank = "<b>[J.title]</b>"
	else
		rank = "[J.title]"
	if(length(J.alt_titles))
		. += "<a href='?src=[REF(src)];prefs=[REF(prefs)];act=title;title=[J.id]'>[rank]</a> "
	else
		. += "[rank] "
	// right side
	. += "</td><td width='40%' align='right'> "
	// assistant is treated as yes/no
	var/fail_reason = check_job(prefs, J, current_priority)
	if(fail_reason)
		. += "\[[fail_reason]]"
	else if(J.id == JOB_ID_ASSISTANT)
		. += "<a href=?src=[REF(src)];prefs=[REF(prefs)];act=job;job=[J.id];level=[!assistant_selected]' oncontextmenu='javascript:return setjob(\"[J.id]\", [!assistant_selected]);'>[assistant_selected? "Yes" : "No"]</a>"
	else if(assistant_selected)
	else
		var/lower
		var/higher
		var/current
		switch(current_priority)
			if(JOB_PRIORITY_HIGH)
				lower = JOB_PRIORITY_MEDIUM
				higher = JOB_PRIORITY_NEVER
				current = "<font color='#55cc55'>High</font>"
			if(JOB_PRIORITY_MEDIUM)
				lower = JOB_PRIORITY_LOW
				higher = JOB_PRIORITY_HIGH
				current = "<font color='#eecc22'>Medium</font>"
			if(JOB_PRIORITY_LOW)
				lower = JOB_PRIORITY_NEVER
				higher = JOB_PRIORITY_MEDIUM
				current = "<font color='#cc5555'>Low</font>"
			else
				lower = JOB_PRIORITY_HIGH
				higher = JOB_PRIORITY_LOW
				current = "<font color='#000000'>Never</font>"
		. += "<a href=?src=[REF(src)];prefs=[REF(prefs)];act=job;job=[J.id];level=[higher]' oncontextmenu='javascript:return setjob(\"[J.id]\", [lower]);'>[current]</a>"
	. += "</td></tr>"

/**
 * return null if allowed, otherwise return error to display
 */
/datum/category_item/player_setup_item/occupation/jobs/proc/check_job(datum/preferences/prefs, datum/job/J, current_priority)
	var/client/C = pref.client
	if(!C)
		return null
	if(jobban_isbanned(C.mob, J.title))
		return "BANNED"
	if(!J.player_old_enough(C))
		var/in_days = J.available_in_days(C)
		return "IN [in_days] DAYS"
	if(!is_job_whitelisted(ckey(J.title), prefs.client_ckey))
		return "WHITELISTED"
	if(J.minimum_character_age && prefs.age < J.minimum_character_age)
		return "MINIMUM CHARACTER AGE: [J.minimum_character_age]"
	return null

/datum/category_item/player_setup_item/occupation/jobs/act(datum/preferences/prefs, mob/user, action, list/params)
	switch(action)
		if("job")
			prefs.set_job_priority(params["id"], text2num(params["level"]))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW
		if("title")
			var/datum/job/J = SSjob.job_by_id(params["id"])
			if(!J)
				return PREFERENCES_NOACTION
			var/title = input(user, "Choose a title for [J.title].", "Choose Title", prefs.get_job_alt_title_name(J)) as null|anything in J.alt_titles
			if(!title)
				return PREFERENCES_NOACTION
			prefs.set_job_title(params["id"], title)
			return PREFERENCES_REFRESH_UPDATE_PREVIEW
		if("help")
			var/datum/job/J = SSjob.job_by_id(params["help"])
			var/list/built = list("<blockquote class='info'>")
			built += "<center><b><h3>[J.title]</h3></b></center>"
			built += "<b>Purpose:</b> [J.desc]"
			built += "<b>Alternative titles:</b> [english_list(J.alt_titles)]"
			if(J.supervisors)
				built += "You answer to [J.supervisors], normally."
			if(J.departments)
				built += "<b>Departments</b>: [english_list(J.departments)]"
			if(J.departments_managed)
				built += "You manage these departments: [english_list(J.departments_managed)]"
			built += "</blockquote>"
			to_chat(user, built.Join("<br>"))
			return PREFERENCES_HANDLED
		if("overflow")
			var/current = prefs.get_character_data(CHARACTER_DATA_OVERFLOW_MODE)
			switch(current)
				if(JOB_ALTERNATIVE_BE_ASSISTANT)
					prefs.set_character_data(CHARACTER_DATA_OVERFLOW_MODE, JOB_ALTERNATIVE_GET_RANDOM)
				if(JOB_ALTERNATIVE_GET_RANDOM)
					prefs.set_character_data(CHARACTER_DATA_OVERFLOW_MODE, JOB_ALTERNATIVE_RETURN_LOBBY)
				if(JOB_ALTERNATIVE_RETURN_LOBBY)
					prefs.set_character_data(CHARACTER_DATA_OVERFLOW_MODE, JOB_ALTERNATIVE_BE_ASSISTANT)
			return PREFERENCES_REFRESH
		if("reset")
			prefs.reset_jobs()
			return PREFERENCES_REFRESH_UPDATE_PREVIEW
	return ..()

/datum/category_item/player_setup_item/occupation/jobs/default_value(randomizing)
	return list()

/**
 * display is done by jobs; this datum only handles data filtering
 *
 * save format: list(job id = title NAME)
 */
/datum/category_item/player_setup_item/occupation/alt_titles
	name = "(Virtual) Alt Titles"
	save_key = CHARACTER_DATA_ALT_TITLES

/datum/category_item/player_setup_item/occupation/alt_titles/filter(datum/preferences/prefs, data, list/errors)
	var/list/jobs = sanitize_islist(data)
	for(var/id in jobs)
		var/datum/job/J = SSjob.job_by_id(id)
		if(!J)
			jobs -= id
			continue
		var/title = jobs[id]
		if(!J.alt_titles[title])
			jobs -= id
			continue
	return jobs

/datum/category_item/player_setup_item/occupation/alt_titles/default_value(randomizing)
	return list()

/**
 * display is done by jobs; this datum only handles data filtering
 *
 * save format: overflow mode as enum define
 */
/datum/category_item/player_setup_item/occupation/overflow_mode
	name = "(Virtual) Overflow Mode"
	save_key = CHARACTER_DATA_OVERFLOW_MODE

/datum/category_item/player_setup_item/occupation/overflow_mode/default_value(randomizing)
	return JOB_ALTERNATIVE_BE_ASSISTANT

/datum/category_item/player_setup_item/occupation/overflow_mode/filter(datum/preferences/prefs, data, list/errors)
	var/static/list/static_list = list(
		JOB_ALTERNATIVE_BE_ASSISTANT,
		JOB_ALTERNATIVE_GET_RANDOM,
		JOB_ALTERNATIVE_RETURN_LOBBY
	)
	return sanitize_inlist(data, static_list, JOB_ALTERNATIVE_BE_ASSISTANT)

#warn take faction into account by blocking spawn/view but not wiping

/datum/preferences/proc/get_job_priority(datum/job/J)
	var/list/jobs = get_character_data(CHARACTER_DATA_JOBS)
	return jobs[J.id]

/datum/preferences/proc/get_job_alt_title_name(datum/job/J)
	RETURN_TYPE(/datum/alt_title)
	var/list/titles = get_character_data(CHARACTER_DATA_ALT_TITLES)
	return titles[J.id] || J.title

/datum/preferences/proc/preview_job_id()
	var/list/jobs = get_character_data(CHARACTER_DATA_JOBS)
	if(jobs[JOB_ID_ASSISTANT])
		return JOB_ID_ASSISTANT
	for(var/id in jobs)
		if(jobs[id] == JOB_PRIORITY_HIGH)
			return id

/datum/preferences/proc/effective_job_priorities()
	RETURN_TYPE(/list)
	#warn impl - factions

/datum/preferences/proc/effective_job_priority(datum/job/J)
	var/list/jobs = get_character_data(CHARACTER_DATA_JOBS)
	return jobs[J.id]
	#warn check faction

/**
 * resets job prefs
 */
/datum/preferences/proc/reset_jobs()
	set_character_data(CHARACTER_DATA_JOBS, list())
	set_character_data(CHARACTER_DATA_ALT_TITLES, list())
	set_character_data(CHARACTER_DATA_OVERFLOW_MODE, JOB_ALTERNATIVE_BE_ASSISTANT)

/**
 * resets any jobs set to high to medium
 */
/datum/preferences/proc/demote_high_priority_jobs()
	var/list/jobs = get_character_data(CHARACTER_DATA_JOBS)
	for(var/id in jobs)
		if(jobs[id] == JOB_PRIORITY_HIGH)
			jobs[id] = JOB_PRIORITY_MEDIUM
	set_character_data(CHARACTER_DATA_JOBS, jobs)

/datum/preferences/proc/get_job_alternative()
	return get_character_data(CHARACTER_DATA_OVERFLOW_MODE)

/datum/preferences/proc/set_job_priority(id, priority)
	var/datum/job/J = SSjob.job_by_id(id)
	if(!J)
		return
	if(priority < JOB_PRIORITY_LOW || priority > JOB_PRIORITY_HIGH)
		return
	var/list/current = get_character_data(CHARACTER_DATA_JOBS)
	current[id] = priority
	set_character_data(CHARACTER_DATA_JOBS, current)

/datum/preferences/proc/set_job_title(id, title)
	var/datum/job/J = SSjob.job_by_id(id)
	if(!J)
		return
	if(!J.alt_titles[title])
		return
	var/list/current = get_character_data(CHARACTER_DATA_ALT_TITLES)
	current[id] = title
	set_character_data(CHARACTER_DATA_ALT_TITLES, current)
