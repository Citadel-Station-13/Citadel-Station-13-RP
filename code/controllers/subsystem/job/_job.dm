SUBSYSTEM_DEF(job)
	name = "Job"
	init_order = INIT_ORDER_JOBS
	init_stage = INIT_STAGE_EARLY
	subsystem_flags = SS_NO_FIRE

	/// job preferences ui cache - cache[faction string][department name] = list(job ids)
	var/list/job_pref_ui_cache
	/// jobs per column
	var/job_pref_ui_per = 25

	var/list/department_datums = list()
	var/debug_messages = FALSE


/datum/controller/subsystem/job/Initialize(timeofday)
	init_access()
	if(!length(department_datums))
		setup_departments()
	reconstruct_job_ui_caches()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/job/Recover()
	init_access()
	reconstruct_spawnpoints()
	reconstruct_job_ui_caches()
	return ..()

/datum/controller/subsystem/job/proc/reconstruct_job_ui_caches()
	// todo: this is shit but it works
	job_pref_ui_cache = list()
	for(var/datum/prototype/role/job/J as anything in RSroles.legacy_all_sorted_job_datums())
		if(!(J.join_types & JOB_ROUNDSTART))
			continue
		var/faction = J.faction
		LAZYINITLIST(job_pref_ui_cache[faction])
		var/department = LAZYACCESS(J.departments, 1) || "Misc"
		LAZYADD(job_pref_ui_cache[faction][department], J.id)
	// todo: why
	for(var/fname in job_pref_ui_cache)
		var/list/faction = job_pref_ui_cache[fname]
		var/list/asinine_sort = list()
		for(var/depname in department_datums)
			if(faction[depname])
				asinine_sort[depname] = faction[depname]
				faction -= depname
		faction.Insert(1, asinine_sort)
		for(var/depname in asinine_sort)
			faction[depname] = asinine_sort[depname]

/datum/controller/subsystem/job/proc/add_to_departments(datum/prototype/role/job/J)
	// Adds to the regular job lists in the departments, which allow multiple departments for a job.
	for(var/D in J.departments)
		var/datum/department/dept = LAZYACCESS(department_datums, D)
		if(!istype(dept))
			job_debug_message("Job '[J.title]' is defined as being inside department '[D]', but it does not exist.")
			continue
		dept.jobs[J.title] = J

	// Now for the 'primary' department for a job, which is defined as being the first department in the list for a job.
	// This results in no duplicates, which can be useful in some situations.
	if(LAZYLEN(J.departments))
		var/primary_department = J.departments[1]
		var/datum/department/dept = LAZYACCESS(department_datums, primary_department)
		if(!istype(dept))
			job_debug_message("Job '[J.title]' has their primary department be '[primary_department]', but it does not exist.")
		else
			dept.primary_jobs[J.title] = J

/datum/controller/subsystem/job/proc/setup_departments()
	for(var/t in subtypesof(/datum/department))
		var/datum/department/D = new t()
		department_datums[D.name] = D

	tim_sort(department_datums, GLOBAL_PROC_REF(cmp_department_datums), TRUE)

	for(var/datum/prototype/role/job/job as anything in RSroles.legacy_all_job_datums())
		if(LAZYLEN(job.departments))
			add_to_departments(job)

	for(var/D in department_datums)
		var/datum/department/dept = department_datums[D]
		tim_sort(dept.jobs, GLOBAL_PROC_REF(cmp_job_datums), TRUE)
		tim_sort(dept.primary_jobs, GLOBAL_PROC_REF(cmp_job_datums), TRUE)

/datum/controller/subsystem/job/proc/get_all_department_datums()
	var/list/dept_datums = list()
	for(var/D in department_datums)
		dept_datums += department_datums[D]
	return dept_datums

// Determines if a job title is inside of a specific department.
// Useful to replace the old `if(job_title in command_positions)` code.
/datum/controller/subsystem/job/proc/is_job_in_department(rank, target_department_name)
	var/datum/department/D = LAZYACCESS(department_datums, target_department_name)
	if(istype(D))
		return LAZYFIND(D.jobs, rank) ? TRUE : FALSE
	return FALSE

// Returns a list of all job names in a specific department.
/datum/controller/subsystem/job/proc/get_job_titles_in_department(target_department_name)
	var/datum/department/D = LAZYACCESS(department_datums, target_department_name)
	if(istype(D))
		var/list/job_titles = list()
		for(var/J in D.jobs)
			job_titles += J
		return job_titles

	job_debug_message("Was asked to get job titles for a non-existant department '[target_department_name]'.")
	return list()

// Returns a reference to the primary department datum that a job is in.
// Can receive job datum refs, typepaths, or job title strings.
/datum/controller/subsystem/job/proc/get_primary_department_of_job(datum/prototype/role/job/J)
	if(!istype(J, /datum/prototype/role/job))
		if(ispath(J))
			J = RSroles.legacy_job_by_type(J)
		else if(istext(J))
			J = RSroles.legacy_job_by_title(J)

	if(!istype(J))
		job_debug_message("Was asked to get department for job '[J]', but input could not be resolved into a job datum.")
		return

	if(!LAZYLEN(J.departments))
		return

	var/primary_department = J.departments[1]
	var/datum/department/dept = LAZYACCESS(department_datums, primary_department)
	if(!istype(dept))
		job_debug_message("Job '[J.title]' has their primary department be '[primary_department]', but it does not exist.")
		return

	return department_datums[primary_department]

/datum/controller/subsystem/job/proc/job_debug_message(message)
	if(debug_messages)
		log_debug(SPAN_DEBUG("JOB DEBUG: [message]"))
