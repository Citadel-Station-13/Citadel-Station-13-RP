/// When a query has been queued up for execution/is being executed
#define DB_QUERY_STARTED 0
/// When a query is finished executing
#define DB_QUERY_FINISHED 1
/// When there was a problem with the execution of a query.
#define DB_QUERY_BROKEN 2

/datum/db_query
	// Inputs
	var/connection
	var/sql
	var/arguments

	var/datum/callback/success_callback
	var/datum/callback/fail_callback

	// Status information
	/// Current status of the query.
	var/status
	/// Job ID of the query passed by rustg.
	var/job_id
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
	SSdbcore.all_queries += src
	SSdbcore.all_queries_num++
	Activity("Created")
	item = list()

	src.connection = connection
	src.sql = sql
	src.arguments = arguments

/datum/db_query/Destroy()
	Close()
	SSdbcore.all_queries -= src
	SSdbcore.queries_standby -= src
	SSdbcore.queries_active -= src
	return ..()

/datum/db_query/CanProcCall(proc_name)
	//fuck off kevinz
	return FALSE

/datum/db_query/proc/Activity(activity)
	last_activity = activity
	last_activity_time = world.time

/datum/db_query/proc/warn_execute(async = TRUE)
	. = Execute(async)
	if(!.)
		to_chat(usr, SPAN_DANGER("A SQL error occurred during this operation, check the server logs."))

/datum/db_query/proc/Execute(async = TRUE, log_error = TRUE)
	Activity("Execute")
	if(status == DB_QUERY_STARTED)
		CRASH("Attempted to start a new query while waiting on the old one")

	if(!SSdbcore.IsConnected())
		last_error = "No connection!"
		return FALSE

	var/start_time
	if(!async)
		start_time = REALTIMEOFDAY
	Close()
	status = DB_QUERY_STARTED
	if(async)
		if(!MC_RUNNING(SSdbcore.init_stage))
			SSdbcore.run_query_sync(src)
		else
			SSdbcore.queue_query(src)
		sync()
	else
		var/job_result_str = rustg_sql_query_blocking(connection, sql, json_encode(arguments))
		store_data(json_decode(job_result_str))

	. = (status != DB_QUERY_BROKEN)
	var/timed_out = !. && findtext(last_error, "Operation timed out")
	if(!. && log_error)

		log_sql("[last_error] | Query used: [sql] | Arguments: [json_encode(arguments)]")

	if(!async && timed_out)
		log_sql("Query used: [sql] | start_time: [start_time] | end_time: [REALTIMEOFDAY]")
		slow_query_check()

/// Sleeps until execution of the query has finished.
/datum/db_query/proc/sync()
	while(status < DB_QUERY_FINISHED)
		stoplag()

/datum/db_query/process(seconds_per_tick)
	if(status >= DB_QUERY_FINISHED)
		return TRUE // we are done processing after all

	status = DB_QUERY_STARTED
	var/job_result = rustg_sql_check_query(job_id)
	if(job_result == RUSTG_JOB_NO_RESULTS_YET)
		return FALSE //no results yet

	store_data(json_decode(job_result))
	return TRUE

/datum/db_query/proc/store_data(result)
	switch(result["status"])
		if("ok")
			rows = result["rows"]
			affected = result["affected"]
			last_insert_id = result["last_insert_id"]
			status = DB_QUERY_FINISHED
			return
		if("err")
			last_error = result["data"]
			status = DB_QUERY_BROKEN
			return
		if("offline")
			last_error = "CONNECTION OFFLINE"
			status = DB_QUERY_BROKEN
			return


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
