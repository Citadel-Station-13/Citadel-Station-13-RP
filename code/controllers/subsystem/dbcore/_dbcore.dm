SUBSYSTEM_DEF(dbcore)
	name = "Database"
	subsystem_flags = SS_BACKGROUND
	wait = 1 MINUTES
	init_order = INIT_ORDER_DBCORE
	init_stage = INIT_STAGE_BACKEND
	runlevels = RUNLEVEL_LOBBY|RUNLEVELS_DEFAULT

	var/schema_mismatch = 0
	var/db_minor = 0
	var/db_major = 0
	/// Number of failed connection attempts this try. Resets after the timeout or successful connection
	var/failed_connections = 0
	/// Max number of consecutive failures before a timeout (here and not a define so it can be vv'ed mid round if needed)
	var/max_connection_failures = 5
	/// world.time that connection attempts can resume
	var/failed_connection_timeout = 0
	/// Total number of times connections have had to be timed out.
	var/failed_connection_timeout_count = 0

	var/last_error
	var/list/active_queries = list()

	/// We are in the process of shutting down and should not allow more DB connections
	var/shutting_down = FALSE

	var/connection  // Arbitrary handle returned from rust_g.

	var/was_ever_connected = FALSE

/datum/controller/subsystem/dbcore/Initialize()
	Connect()

	//We send warnings to the admins during subsystem init, as the clients will be New'd and messages
	//will queue properly with goonchat
	switch(schema_mismatch)
		if(1)
			message_admins("Database schema ([db_major].[db_minor]) doesn't match the latest schema version ([DB_MAJOR_VERSION].[DB_MINOR_VERSION]), this may lead to undefined behaviour or errors")
		if(2)
			message_admins("Could not get schema version from database")

	return SS_INIT_SUCCESS

/datum/controller/subsystem/dbcore/fire(resumed = FALSE)
	if(!IsConnected())
		return

	for(var/I in active_queries)
		var/datum/db_query/query = I
		if(world.time - query.last_activity_time > (5 MINUTES))
			stack_trace("Found undeleted query, check the sql.log for the undeleted query and add a delete call to the query datum.")
			log_sql("Undeleted query: \"[query.sql]\" LA: [query.last_activity] LAT: [query.last_activity_time]")
			qdel(query)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/dbcore/Recover()
	connection = SSdbcore.connection

/datum/controller/subsystem/dbcore/Shutdown()
	shutting_down = TRUE

	//This is as close as we can get to the true round end before Disconnect() without changing where it's called, defeating the reason this is a subsystem
	if(SSdbcore.Connect())
		//log shutdown to the db
		// TODO: implement end_state
		var/datum/db_query/query_round_shutdown = SSdbcore.NewQuery(
			"UPDATE [DB_PREFIX_TABLE_NAME("round")] SET shutdown_datetime = Now() WHERE id = :round_id",
			list("round_id" = GLOB.round_id),
			TRUE
		)
		query_round_shutdown.Execute(FALSE)
		qdel(query_round_shutdown)

	if(IsConnected())
		Disconnect()

//nu
/datum/controller/subsystem/dbcore/can_vv_get(var_name)
	if(var_name == NAMEOF(src, connection))
		return FALSE
	if(var_name == NAMEOF(src, active_queries))
		return FALSE

	return ..()

/datum/controller/subsystem/dbcore/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, connection))
		return FALSE
	if(var_name == NAMEOF(src, active_queries))
		return FALSE

/datum/controller/subsystem/dbcore/proc/Connect()
	if(IsConnected())
		return TRUE

	if(connection)
		Disconnect() //clear the current connection handle so isconnected() calls stop invoking rustg
		connection = null //make sure its cleared even if runtimes happened

	if(failed_connection_timeout <= world.time) //it's been long enough since we failed to connect, reset the counter
		failed_connections = 0
		failed_connection_timeout = 0

	if(failed_connection_timeout > 0)
		return FALSE

	if(!CONFIG_GET(flag/sql_enabled))
		return FALSE

	var/user = CONFIG_GET(string/sql_user)
	var/pass = CONFIG_GET(string/sql_password)
	var/db = CONFIG_GET(string/sql_database)
	var/address = CONFIG_GET(string/sql_address)
	var/port = CONFIG_GET(number/sql_port)
	var/timeout = max(CONFIG_GET(number/async_query_timeout), CONFIG_GET(number/blocking_query_timeout))
	var/thread_limit = CONFIG_GET(number/bsql_thread_limit)

	var/result = json_decode(rustg_sql_connect_pool(json_encode(list(
		"host" = address,
		"port" = port,
		"user" = user,
		"pass" = pass,
		"db_name" = db,
		"read_timeout" = timeout,
		"write_timeout" = timeout,
		"max_threads" = thread_limit,
	))))
	. = (result["status"] == "ok")
	if (.)
		connection = result["handle"]
		if(was_ever_connected)
			// we got re-connected.
			for(var/datum/controller/subsystem/subsystem in Master.subsystems)
				subsystem.on_sql_reconnect()
			world.on_sql_reconnect()
		was_ever_connected = TRUE
	else
		connection = null
		last_error = result["data"]
		log_sql("Connect() failed | [last_error]")
		++failed_connections
		//If it failed to establish a connection more than 5 times in a row, don't bother attempting to connect for a time.
		if(failed_connections > max_connection_failures)
			failed_connection_timeout_count++
			//basic exponential backoff algorithm
			failed_connection_timeout = world.time + ((2 ** failed_connection_timeout_count) SECONDS)

/datum/controller/subsystem/dbcore/proc/CheckSchemaVersion()
	if(CONFIG_GET(flag/sql_enabled))
		if(Connect())
			log_world("Database connection established.")
			var/datum/db_query/query_db_version = NewQuery("SELECT major, minor FROM [DB_PREFIX_TABLE_NAME("schema_revision")] ORDER BY date DESC LIMIT 1")
			query_db_version.Execute()
			if(query_db_version.NextRow())
				db_major = text2num(query_db_version.item[1])
				db_minor = text2num(query_db_version.item[2])
				if(db_major != DB_MAJOR_VERSION || db_minor != DB_MINOR_VERSION)
					schema_mismatch = 1 // flag admin message about mismatch
					log_sql("Database schema ([db_major].[db_minor]) doesn't match the latest schema version ([DB_MAJOR_VERSION].[DB_MINOR_VERSION]), this may lead to undefined behaviour or errors")
			else
				schema_mismatch = 2 //flag admin message about no schema version
				log_sql("Could not get schema version from database")
			qdel(query_db_version)
		else
			log_sql("Your server failed to establish a connection with the database.")
	else
		log_sql("Database is not enabled in configuration.")


/datum/controller/subsystem/dbcore/proc/InitializeRound()
	CheckSchemaVersion()

	if(!Connect())
		return
	var/datum/db_query/query_round_initialize = SSdbcore.NewQuery(
		"INSERT INTO [DB_PREFIX_TABLE_NAME("round")] (initialize_datetime, server_ip, server_port) VALUES (Now(), INET_ATON(:internet_address), :port)",
		list("internet_address" = world.internet_address || "0", "port" = "[world.port]")
	)
	query_round_initialize.Execute(async = FALSE)
	GLOB.round_id = "[query_round_initialize.last_insert_id]"
	GLOB.round_number = text2num(GLOB.round_id)
	qdel(query_round_initialize)

	log_world("Round ID: [GLOB.round_id]")

/datum/controller/subsystem/dbcore/proc/SetRoundStart()
	if(!Connect())
		return
	var/datum/db_query/query_round_start = SSdbcore.NewQuery(
		"UPDATE [DB_PREFIX_TABLE_NAME("round")] SET start_datetime = Now() WHERE id = :round_id",
		list("round_id" = GLOB.round_id)
	)
	query_round_start.Execute()
	qdel(query_round_start)

/datum/controller/subsystem/dbcore/proc/SetRoundEnd()
	if(!Connect())
		return
	var/datum/db_query/query_round_end = SSdbcore.NewQuery(
		"UPDATE [DB_PREFIX_TABLE_NAME("round")] SET end_datetime = Now(), station_name = :station_name WHERE id = :round_id",
		list("station_name" = station_name(), "round_id" = GLOB.round_id)
	)
	query_round_end.Execute()
	qdel(query_round_end)

/datum/controller/subsystem/dbcore/proc/Disconnect()
	failed_connections = 0
	if (connection)
		rustg_sql_disconnect_pool(connection)
	connection = null

/datum/controller/subsystem/dbcore/proc/IsConnected()
	if (!CONFIG_GET(flag/sql_enabled))
		return FALSE
	if (!connection)
		return FALSE
	return json_decode(rustg_sql_connected(connection))["status"] == "online"

/datum/controller/subsystem/dbcore/proc/ErrorMsg()
	if(!CONFIG_GET(flag/sql_enabled))
		return "Database disabled by configuration"
	return last_error

/datum/controller/subsystem/dbcore/proc/ReportError(error)
	last_error = error

/**
 * makes a query
 *
 * **you must qdel this query yourself.**
 *
 * * sql_query - The SQL query string to execute
 * * arguments - List of arguments to pass to the query for parameter binding
 * * allow_during_shutdown - If TRUE, allows query to be created during subsystem shutdown. Generally, only cleanup queries should set this.
 */
/datum/controller/subsystem/dbcore/proc/NewQuery(sql_query, arguments, allow_during_shutdown=FALSE)
	RETURN_TYPE(/datum/db_query)
	//If the subsystem is shutting down, disallow new queries
	if(!allow_during_shutdown && shutting_down)
		CRASH("Attempting to create a new db query during the world shutdown")

	if(IsAdminAdvancedProcCall())
		log_admin_private("ERROR: Advanced admin proc call led to sql query: [sql_query]. Query has been blocked")
		message_admins("ERROR: Advanced admin proc call led to sql query. Query has been blocked")
		return FALSE
	return new /datum/db_query(connection, sql_query, arguments)

/**
 * Creates and executes a query without waiting for or tracking the results.
 * Query is executed asynchronously (without blocking) and deleted afterwards - any results or errors are discarded.
 *
 * Arguments:
 * * sql_query - The SQL query string to execute
 * * arguments - List of arguments to pass to the query for parameter binding
 * * allow_during_shutdown - If TRUE, allows query to be created during subsystem shutdown. Generally, only cleanup queries should set this.
 */
/datum/controller/subsystem/dbcore/proc/FireAndForget(sql_query, arguments, allow_during_shutdown = FALSE)
	var/datum/db_query/query = NewQuery(sql_query, arguments, allow_during_shutdown)
	if(!query)
		return
	ASYNC
		query.Execute()
		qdel(query)

/**
 * makes, and runs a query
 *
 * **you must qdel this query yourself.**
 *
 * @params
 * - sql_query - the query. use :arg for arguments
 * - arguments - keyed list
 */
/datum/controller/subsystem/dbcore/proc/ExecuteQuery(sql_query, arguments)
	RETURN_TYPE(/datum/db_query)
	var/datum/db_query/query = NewQuery(sql_query, arguments)
	. = query
	query.Execute()

/**
 * immediately runs a sql query with selected arguments
 * always uses async queries
 * will block the caller.
 *
 * ! do not use this proc for new things, this proc is bad practice.
 *
 * **warning**: will delete the query right after the current set of procs run. USE NewQuery IF YOU WANT TO MANAGE THIS YOURSELF.
 */
/datum/controller/subsystem/dbcore/proc/RunQuery(sql_query, arguments)
	RETURN_TYPE(/datum/db_query)
	var/datum/db_query/query = NewQuery(sql_query, arguments)
	. = query
	query.Execute(TRUE, TRUE)
	QDEL_IN(query, 0)

/** QuerySelect
 * Run a list of query datums in parallel, blocking until they all complete.
 * * queries - List of queries or single query datum to run.
 * * warn - Controls rather warn_execute() or Execute() is called.
 * * qdel - If you don't care about the result or checking for errors, you can have the queries be deleted afterwards.
 * 	This can be combined with invoke_async as a way of running queries async without having to care about waiting for them to finish so they can be deleted,
 * 	however you should probably just use FireAndForget instead if it's just a single query.
 */
/datum/controller/subsystem/dbcore/proc/QuerySelect(list/queries, warn = FALSE, qdel = FALSE)
	if (!islist(queries))
		if (!istype(queries, /datum/db_query))
			CRASH("Invalid query passed to QuerySelect: [queries]")
		queries = list(queries)
	else
		queries = queries.Copy() //we don't want to hide bugs in the parent caller by removing invalid values from this list.

	for (var/datum/db_query/query as anything in queries)
		if (!istype(query))
			queries -= query
			stack_trace("Invalid query passed to QuerySelect: `[query]` [REF(query)]")
			continue

		if (warn)
			INVOKE_ASYNC(query, TYPE_PROC_REF(/datum/db_query, warn_execute))
		else
			INVOKE_ASYNC(query, TYPE_PROC_REF(/datum/db_query, Execute))

	for (var/datum/db_query/query as anything in queries)
		UNTIL(!query.in_progress)
		if (qdel)
			qdel(query)

/**
 * Takes a list of rows (each row being an associated list of column => value) and inserts them via a single mass query.
 * Rows missing columns present in other rows will resolve to SQL NULL
 * You are expected to do your own escaping of the data, and expected to provide your own quotes for strings.
 * The duplicate_key arg can be true to automatically generate this part of the query
 * 	or set to a string that is appended to the end of the query
 * Ignore_errors instructes mysql to continue inserting rows if some of them have errors.
 * 	the erroneous row(s) aren't inserted and there isn't really any way to know why or why errored
 */
/datum/controller/subsystem/dbcore/proc/MassInsert(table, list/rows, duplicate_key = FALSE, ignore_errors = FALSE, warn = FALSE, async = TRUE, special_columns = null)
	if (!table || !rows || !istype(rows))
		return

	// Prepare column list
	var/list/columns = list()
	var/list/has_question_mark = list()
	for (var/list/row in rows)
		for (var/column in row)
			columns[column] = "?"
			has_question_mark[column] = TRUE
	for (var/column in special_columns)
		columns[column] = special_columns[column]
		has_question_mark[column] = findtext(special_columns[column], "?")

	// Prepare SQL query full of placeholders
	var/list/query_parts = list("INSERT")
	if (ignore_errors)
		query_parts += " IGNORE"
	query_parts += " INTO "
	query_parts += table
	query_parts += "\n([columns.Join(", ")])\nVALUES"

	var/list/arguments = list()
	var/has_row = FALSE
	for (var/list/row in rows)
		if (has_row)
			query_parts += ","
		query_parts += "\n  ("
		var/has_col = FALSE
		for (var/column in columns)
			if (has_col)
				query_parts += ", "
			if (has_question_mark[column])
				var/name = "p[arguments.len]"
				query_parts += replacetext(columns[column], "?", ":[name]")
				arguments[name] = row[column]
			else
				query_parts += columns[column]
			has_col = TRUE
		query_parts += ")"
		has_row = TRUE

	if (duplicate_key == TRUE)
		var/list/column_list = list()
		for (var/column in columns)
			column_list += "[column] = VALUES([column])"
		query_parts += "\nON DUPLICATE KEY UPDATE [column_list.Join(", ")]"
	else if (duplicate_key != FALSE)
		query_parts += duplicate_key

	var/datum/db_query/Query = NewQuery(query_parts.Join(), arguments)
	if (warn)
		. = Query.warn_execute(async)
	else
		. = Query.Execute(async)
	qdel(Query)

/**
 * **WARNING**: Extremely dangerous.
 *
 * Directly runs SQL strings asynchronously, and only returns when they're done.
 *
 * No sanitization provided.
 */
/datum/controller/subsystem/dbcore/proc/dangerously_block_on_multiple_unsanitized_queries(list/query_strings, timeout = 10 SECONDS)
	var/list/datum/db_query/queries = list()
	var/expire_at = world.time + timeout

	for(var/string in query_strings)
		var/datum/db_query/query = SSdbcore.NewQuery(string)
		INVOKE_ASYNC(query, TYPE_PROC_REF(/datum/db_query, warn_execute))
		queries += query

	for(var/datum/db_query/query as anything in queries)
		UNTIL(!query.in_progress || world.time > expire_at)
		if(world.time > expire_at)
			. = FALSE
			CRASH("timeout expired")
	return TRUE

/**
 * WARNING: This proc currently does nothing.
 * why??? Because rust_g already sanitizes strings.
 * This proc simply flattens a string.
 */
/proc/sanitizeSQL(t)
	return "[t]"

/**
 * LISTEN UP MOTHERFUCKERS
 * This is NOT LIKE THAT PROC ABOVE THAT.
 *
 * DO NOT REPLACE THIS BLINDLY, LEST YOU OPEN US UP TO SQL INJECTION ATTACKS
 * We'll phase both of these out eventually(tm)
 * DON'T BLINDLY TOUCH IT.
 */
// Sanitize inputs to avoid SQL injection attacks
/proc/sql_sanitize_text(var/text)
	text = replacetext(text, "'", "''")
	text = replacetext(text, ";", "")
	text = replacetext(text, "&", "")
	return text

/**
 * Override this proc when you need to hook into it.
 */
/world/proc/on_sql_reconnect()
	return
