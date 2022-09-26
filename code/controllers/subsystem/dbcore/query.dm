/datum/db_query
	// Inputs
	var/connection
	var/sql
	var/arguments

	// Status information
	var/in_progress
	var/last_error
	var/last_activity
	var/last_activity_time

	// Output
	var/list/list/rows
	var/next_row_to_take = 1
	var/affected
	var/last_insert_id

	var/list/item  //list of data values populated by NextRow()

/datum/db_query/New(connection, sql, arguments)
	SSdbcore.active_queries[src] = TRUE
	Activity("Created")
	item = list()

	src.connection = connection
	src.sql = sql
	src.arguments = arguments

/datum/db_query/Destroy()
	Close()
	SSdbcore.active_queries -= src
	return ..()

/datum/db_query/proc/Activity(activity)
	last_activity = activity
	last_activity_time = world.time

/datum/db_query/proc/warn_execute(async = TRUE)
	. = Execute(async)
	if(!.)
		to_chat(usr, "<span class='danger'>A SQL error occurred during this operation, check the server logs.</span>")

/datum/db_query/proc/Execute(async = TRUE, log_error = TRUE)
	Activity("Execute")
	if(in_progress)
		CRASH("Attempted to start a new query while waiting on the old one")

	if(!SSdbcore.IsConnected())
		last_error = "No connection!"
		return FALSE

	var/start_time
	if(!async)
		start_time = REALTIMEOFDAY
	Close()
	. = run_query(async)
	var/timed_out = !. && findtext(last_error, "Operation timed out")
	if(!. && log_error)
		log_sql("[last_error] | Query used: [sql] | Arguments: [json_encode(arguments)]")
	if(!async && timed_out)
		log_query_debug("Query execution started at [start_time]")
		log_query_debug("Query execution ended at [REALTIMEOFDAY]")
		log_query_debug("Slow query timeout detected.")
		log_query_debug("Query used: [sql]")
		slow_query_check()

/datum/db_query/proc/run_query(async)
	var/job_result_str

	if (async)
		var/job_id = rustg_sql_query_async(connection, sql, json_encode(arguments))
		in_progress = TRUE
		UNTIL((job_result_str = rustg_sql_check_query(job_id)) != RUSTG_JOB_NO_RESULTS_YET)
		in_progress = FALSE

		if (job_result_str == RUSTG_JOB_ERROR)
			last_error = job_result_str
			return FALSE
	else
		job_result_str = rustg_sql_query_blocking(connection, sql, json_encode(arguments))

	var/result = json_decode(job_result_str)
	switch (result["status"])
		if ("ok")
			rows = result["rows"]
			affected = result["affected"]
			last_insert_id = result["last_insert_id"]
			return TRUE
		if ("err")
			last_error = result["data"]
			return FALSE
		if ("offline")
			last_error = "offline"
			return FALSE

/datum/db_query/proc/slow_query_check()
	message_admins("HEY! A database query timed out. Did the server just hang? <a href='?_src_=holder;[HrefToken()];slowquery=yes'>\[YES\]</a>|<a href='?_src_=holder;[HrefToken()];slowquery=no'>\[NO\]</a>")

/datum/db_query/proc/NextRow(async = TRUE)
	Activity("NextRow")

	if (rows && next_row_to_take <= rows.len)
		item = rows[next_row_to_take]
		next_row_to_take++
		return !!item
	else
		return FALSE

/datum/db_query/proc/ErrorMsg()
	return last_error

/datum/db_query/proc/Close()
	rows = null
	item = null

//! protect
/datum/db_query/can_vv_get(var_name)
	switch(var_name)
		if(NAMEOF(src, connection))
			return FALSE
	return ..()

/datum/db_query/vv_edit_var(var_name, var_value)
	// nah
	return FALSE

/datum/db_query/CanProcCall(proc_name)
	//fuck off kevinz
	return FALSE
