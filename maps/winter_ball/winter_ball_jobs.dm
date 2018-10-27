/*
///datum/configuration - add var/force_offduty_only  = FALSE
/datum/configuration/proc/load - add

	if ("force_offduty_only")
	config.force_offduty_only  = TRUE

return (((timeoff_factor >= 0 || (C && LAZYACCESS(C.department_hours, department) > 0)) && config.force_offduty_only == FALSE) || (timeoff_factor < 0 && config.force_offduty_only == TRUE))
*/