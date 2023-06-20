/client/proc/handle_legacy_connection_whatevers()
	if(is_guest())
		return

	// Department Hours
	if(config_legacy.time_off)
		var/datum/db_query/query_hours = SSdbcore.RunQuery(
			"SELECT department, hours FROM [format_table_name("vr_player_hours")] WHERE ckey = :ckey",
			list(
				"ckey" = ckey
			)
		)
		while(query_hours.NextRow())
			LAZYINITLIST(department_hours)
			department_hours[query_hours.item[1]] = text2num(query_hours.item[2])
