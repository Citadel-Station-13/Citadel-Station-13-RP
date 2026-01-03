/client/proc/start_line_profiling()
	set category = "Profile"
	set name = "Start Line Profiling"
	set desc = "Starts tracking line by line profiling for code lines that support it"

	if(!check_rights(R_DEBUG))
		return

	LINE_PROFILE_START

	message_admins(SPAN_ADMINNOTICE("[key_name_admin(usr)] started line by line profiling."))
	// BLACKBOX_LOG_ADMIN_VERB("Start Line Profiling")
	log_admin("[key_name(usr)] started line by line profiling.")

/client/proc/stop_line_profiling()
	set category = "Profile"
	set name = "Stop Line Profiling"
	set desc = "Stops tracking line by line profiling for code lines that support it"

	if(!check_rights(R_DEBUG))
		return

	LINE_PROFILE_STOP

	message_admins(SPAN_ADMINNOTICE("[key_name_admin(usr)] stopped line by line profiling."))
	// BLACKBOX_LOG_ADMIN_VERB("Stop Line Profiling")
	log_admin("[key_name(usr)] stopped line by line profiling.")

/client/proc/show_line_profiling()
	set category = "Profile"
	set name = "Show Line Profiling"
	set desc = "Shows tracked profiling info from code lines that support it."

	if(!check_rights(R_DEBUG))
		return

	var/list/sortlist = list(
		"Avg time" = GLOBAL_PROC_REF(cmp_profile_avg_time_dsc),
		"Total Time" = GLOBAL_PROC_REF(cmp_profile_time_dsc),
		"Call Count" = GLOBAL_PROC_REF(cmp_profile_count_dsc),
	)
	var/sort = input(usr, "Sort type?", "Sort Type", "Avg time") as null|anything in sortlist
	if (!sort)
		return
	sort = sortlist[sort]
	profile_show(usr, sort)
