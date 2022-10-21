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
	. += "<b>Choose occupation preferences</b><br>Unavailable occupations are crossed out.<br>"
	// script inject for right click
	#warn script
	// form table

	// grab job-by-department ui cache
	var/list/ui_data = SSjob.job_pref_ui_cache
	// build - one faction
	if(length(ui_data) == 1)
		for(var/list/department as anything in ui_data[ui_data[1]])

	// build - multi-faction
	else
		for(var/faction in ui_data)
			var/list/departments = ui_data[faction]
			for(var/department in departments)

	// close table

	// remove center
	. += "</center>"
	// remove monospace
	. += "</tt>"
	#warn impl above/below

/datum/category_item/player_setup_item/occupation/jobs/proc/encode_job(datum/job/J, current_priority, assistant_selected)
	// assistant is treated as yes/no
	if(J.id == JOB_ID_ASSISTANT)

/**
 * return null if allowed, otherwise return error to display
 */
/datum/category_item/player_setup_item/occupation/jobs/proc/check_job(datum/job/J, current_priority)
	// always allow assistant
	if(J.id == JOB_ID_ASSISTANT)
		return null

/datum/category_item/player_setup_item/occupation/jobs/act(datum/preferences/prefs, mob/user, action, list/params)
	switch(action)
		if("job")

		if("title")

		if("help")

		if("overflow")

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
		var/datum/job/J in SSjob.job_by_id(id)
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

/datum/category_item/player_setup_item/occupation/content(mob/user, limit = 25, list/splitJobs = list())

	. = list()
	. += "<script type='text/javascript'>function setJobPrefRedirect(level, rank) { window.location.href='?src=\ref[src];level=' + level + ';set_job=' + encodeURIComponent(rank); return false; }</script>"
	. += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%' valign='top'>" // Table within a table for alignment, also allows you to easily add more columns.
	. += "<table width='100%' cellpadding='1' cellspacing='0'>"
	var/index = -1

	//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
	var/datum/job/lastJob
	var/datum/department/last_department = null // Used to avoid repeating the look-ahead check for if a whole department can fit.

	var/list/all_valid_jobs = list()
	// If the occupation window gets opened before SSJob initializes, then it'll just be blank, with no runtimes.
	// It will work once init is finished.

	for(var/D in SSjob.department_datums)
		var/datum/department/department = SSjob.department_datums[D]
		if(department.centcom_only) // No joining as a centcom role, if any are ever added.
			continue

		for(var/J in department.primary_jobs)
			all_valid_jobs += department.jobs[J]

	for(var/datum/job/job in all_valid_jobs)
		if(job.latejoin_only) continue
		var/datum/department/current_department = SSjob.get_primary_department_of_job(job)

		// Should we add a new column?
		var/make_new_column = FALSE
		if(++index > limit)
			// Ran out of rows, make a new column.
			make_new_column = TRUE

		else if(job.title in splitJobs)
			// Is hardcoded to split at this job title.
			make_new_column = TRUE

		else if(current_department != last_department)
			// If the department is bigger than the limit then we have to split.
			if(limit >= current_department.primary_jobs.len)
				// Look ahead to see if we would need to split, and if so, avoid it.
				if(index + current_department.primary_jobs.len > limit)
					// Looked ahead, and determined that a new column is needed to avoid splitting the department into two.
					make_new_column = TRUE


		if(make_new_column)
/*******
			if((index < limit) && (lastJob != null))
				//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
				//the last job's selection color and blank buttons that do nothing. Creating a rather nice effect.
				for(var/i = 0, i < (limit - index), i++)
					. += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'>//>&nbsp</a></td><td><a>&nbsp</a></td></tr>"
*******/
			. += "</table></td><td width='20%' valign='top'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0
		last_department = current_department

		. += "<tr bgcolor='[job.selection_color]'><td width='60%' align='right'>"

		var/rank = job.title
		lastJob = job
		. += "<a href='?src=\ref[src];job_info=[rank]'>"
		if(jobban_isbanned(user, rank))
			. += "<del>[rank]</del></td></a><td><b> \[BANNED]</b></td></tr>"
			continue
		if(!job.player_old_enough(user.client))
			var/available_in_days = job.available_in_days(user.client)
			. += "<del>[rank]</del></td></a><td> \[IN [(available_in_days)] DAYS]</td></tr>"
			continue
		if(!is_job_whitelisted(user,rank))
			. += "<del>[rank]</del></td></a><td><b> \[WHITELIST ONLY]</b></td></tr>"
			continue
		if(job.minimum_character_age && user.client && (user.client.prefs.age < job.minimum_character_age))
			. += "<del>[rank]</del></td></a><td> \[MINIMUM CHARACTER AGE: [job.minimum_character_age]]</td></tr>"
			continue
		if((pref.job_civilian_low & ASSISTANT) && job.type != /datum/job/station/assistant)
			. += "<font color=grey>[rank]</font></a></td><td></td></tr>"
			continue
		if((rank in SSjob.get_job_titles_in_department(DEPARTMENT_COMMAND) ) || (rank == "AI"))//Bold head jobs
			. += "<b>[rank]</b></a>"
		else
			. += "[rank]</a>"

		. += "</td><td width='40%'>"

		var/prefLevelLabel = "ERROR"
		var/prefLevelColor = "pink"
		var/prefUpperLevel = -1 // level to assign on left click
		var/prefLowerLevel = -1 // level to assign on right click
		if(pref.GetJobDepartment(job, 1) & job.flag)
			prefLevelLabel = "High"
			prefLevelColor = "55cc55"
			prefUpperLevel = 4
			prefLowerLevel = 2
		else if(pref.GetJobDepartment(job, 2) & job.flag)
			prefLevelLabel = "Medium"
			prefLevelColor = "eecc22"
			prefUpperLevel = 1
			prefLowerLevel = 3
		else if(pref.GetJobDepartment(job, 3) & job.flag)
			prefLevelLabel = "Low"
			prefLevelColor = "cc5555"
			prefUpperLevel = 2
			prefLowerLevel = 4
		else
			prefLevelLabel = "NEVER"
			prefLevelColor = "black"
			prefUpperLevel = 3
			prefLowerLevel = 1

		. += "<a href='?src=\ref[src];set_job=[rank];level=[prefUpperLevel]' oncontextmenu='javascript:return setJobPrefRedirect([prefLowerLevel], \"[rank]\");'>"

		if(job.type == /datum/job/station/assistant)//Assistant is special
			if(pref.job_civilian_low & ASSISTANT)
				. += " <font color=55cc55>\[Yes]</font>"
			else
				. += " <font color=black>\[No]</font>"
			if(LAZYLEN(job.alt_titles)) //Blatantly cloned from a few lines down.
				. += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'>&nbsp</td><td><a href='?src=\ref[src];select_alt_title=\ref[job]'>\[[pref.GetPlayerAltTitle(job)]\]</a></td></tr>"
			. += "</a></td></tr>"
			continue

		. += " <font color=[prefLevelColor]>\[[prefLevelLabel]]</font>"
		if(LAZYLEN(job.alt_titles))
			. += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'>&nbsp</td><td><a href='?src=\ref[src];select_alt_title=\ref[job]'>\[[pref.GetPlayerAltTitle(job)]\]</a></td></tr>"
		. += "</a></td></tr>"
	. += "</td'></tr></table>"
	. += "</center></table><center>"

	switch(pref.alternate_option)
		if(GET_RANDOM_JOB)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Get random job if preferences unavailable</a></u>"
		if(BE_ASSISTANT)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Be assistant if preference unavailable</a></u>"
		if(RETURN_TO_LOBBY)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Return to lobby if preference unavailable</a></u>"

	. += "<a href='?src=\ref[src];reset_jobs=1'>\[Reset\]</a></center>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/occupation/OnTopic(href, href_list, user)
	if(href_list["reset_jobs"])
		ResetJobs()
		return PREFERENCES_REFRESH

	else if(href_list["job_alternative"])
		if(pref.alternate_option == GET_RANDOM_JOB || pref.alternate_option == BE_ASSISTANT)
			pref.alternate_option += 1
		else if(pref.alternate_option == RETURN_TO_LOBBY)
			pref.alternate_option = 0
		return PREFERENCES_REFRESH

	else if(href_list["select_alt_title"])
		var/datum/job/job = locate(href_list["select_alt_title"])
		if (job)
			var/choices = list(job.title) + job.alt_titles
			var/choice = input("Choose a title for [job.title].", "Choose Title", pref.GetPlayerAltTitle(job)) as anything in choices|null
			if(choice && CanUseTopic(user))
				SetPlayerAltTitle(job, choice)
				return (pref.equip_preview_mob ? PREFERENCES_REFRESH_UPDATE_PREVIEW : PREFERENCES_REFRESH)

	else if(href_list["set_job"])
		if(SetJob(user, href_list["set_job"], text2num(href_list["level"])))
			return (pref.equip_preview_mob ? PREFERENCES_REFRESH_UPDATE_PREVIEW : PREFERENCES_REFRESH)

	else if(href_list["job_info"])
		var/rank = href_list["job_info"]
		var/datum/job/job = job_master.GetJob(rank)
		var/dat = list()

		dat += "<p style='background-color: [job.selection_color]'><br><br><p>"
		if(job.alt_titles)
			dat += "<i><b>Alternate titles:</b> [english_list(job.alt_titles)].</i>"
		user << browse_rsc(job.get_job_icon(), "job[ckey(rank)].png")
		dat += "<img src=job[ckey(rank)].png width=96 height=96 style='float:left;'>"
		if(job.departments)
			dat += "<b>Departments:</b> [english_list(job.departments)]."
			if(LAZYLEN(job.departments_managed))
				dat += "You manage these departments: [english_list(job.departments_managed)]"

		dat += "You answer to <b>[job.supervisors]</b> normally."

		dat += "<hr style='clear:left;'>"
		if(config_legacy.wikiurl)
			dat += "<a href='?src=\ref[src];job_wiki=[rank]'>Open wiki page in browser</a>"

		var/alt_title = pref.GetPlayerAltTitle(job)
		var/list/description = job.get_description_blurb(alt_title)
		if(LAZYLEN(description))
			dat += html_encode(description[1])
			if(description.len > 1)
				if(!isnull(description[2]))
					dat += "<br>"
					dat += html_encode(description[2])

		var/datum/browser/popup = new(user, "Job Info", "[capitalize(rank)]", 430, 520, src)
		popup.set_content(jointext(dat,"<br>"))
		popup.open()

	else if(href_list["job_wiki"])
		var/rank = href_list["job_wiki"]
		user << link("[config_legacy.wikiurl][rank]")

	return ..()

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

#warn: FOR THIS WHOLE FILE, ASSISTANT SHOULD BE TREATED AS YES/NO.

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
