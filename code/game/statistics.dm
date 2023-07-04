/proc/sql_poll_population()
	var/admincount = GLOB.admins.len
	var/playercount = 0
	for(var/mob/M in GLOB.player_list)
		if(M.client)
			playercount += 1

	if(!SSdbcore.Connect())
		log_game("SQL ERROR during population polling. Failed to connect.")
	else
		var/datum/db_query/query = SSdbcore.NewQuery(
			"INSERT INTO [format_table_name("population")] (playercount, admincount, time) VALUES (:pc, :ac, NOW())",
			list(
				"pc" = sanitizeSQL(playercount),
				"ac" = sanitizeSQL(admincount),
			)
		)
		if(!query.Execute())
			var/err = query.ErrorMsg()
			log_game("SQL ERROR during population polling. Error : \[[err]\]\n")
		qdel(query)

/proc/sql_report_death(mob/living/carbon/human/H)
	if(!H)
		return
	if(!H.key || !H.mind)
		return

	var/area/placeofdeath = get_area(H)
	var/podname = placeofdeath ? placeofdeath.name : "Unknown area"

	var/sqlname = sanitizeSQL(H.real_name)
	var/sqlkey = sanitizeSQL(H.key)
	var/sqlpod = sanitizeSQL(podname)
	var/sqlspecial = sanitizeSQL(H.mind.special_role)
	var/sqljob = sanitizeSQL(H.mind.assigned_role)

	var/laname = ""
	var/lakey = ""
	if(H.lastattacker)
		laname = sanitizeSQL(H.lastattacker:real_name)
		lakey = sanitizeSQL(H.lastattacker:key)

	var/sqltime = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	var/coord = "[H.x], [H.y], [H.z]"

	if(!SSdbcore.Connect())
		log_game("SQL ERROR during death reporting. Failed to connect.")
	else
		var/datum/db_query/query = SSdbcore.NewQuery(
			"INSERT INTO [format_table_name("death")] (name, byondkey, job, special, pod, tod, laname, lakey, gender, bruteloss, fireloss, brainloss, oxyloss, coord) VALUES \
			(:name, :key, :job, :special, :pod, :time, :laname, :lakey, :gender, :bruteloss, :fireloss, :brainloss, :oxyloss, :coord)",
			list(
				"name" = sqlname,
				"key" = sqlkey,
				"job" = sqljob,
				"special" = sqlspecial,
				"pod" = sqlpod,
				"time" = sqltime,
				"laname" = laname,
				"lakey" = lakey,,
				"gender" = H.gender,
				"bruteloss" = H.getBruteLoss(),
				"fireloss" = H.getFireLoss(),
				"brainloss" = H.getBrainLoss(),
				"oxyloss" = H.getOxyLoss(),
				"coord" = coord,
			)
		)
		if(!query.Execute())
			var/err = query.ErrorMsg()
			log_game("SQL ERROR during death reporting. Error : \[[err]\]\n")
		qdel(query)

/proc/sql_report_cyborg_death(mob/living/silicon/robot/H)
	if(!H)
		return
	if(!H.key || !H.mind)
		return

	var/area/placeofdeath = get_area(H)
	var/podname = placeofdeath ? placeofdeath.name : "Unknown area"

	var/sqlname = sanitizeSQL(H.real_name)
	var/sqlkey = sanitizeSQL(H.key)
	var/sqlpod = sanitizeSQL(podname)
	var/sqlspecial = sanitizeSQL(H.mind.special_role)
	var/sqljob = sanitizeSQL(H.mind.assigned_role)
	var/laname
	var/lakey
	if(H.lastattacker)
		laname = sanitizeSQL(H.lastattacker:real_name)
		lakey = sanitizeSQL(H.lastattacker:key)
	var/sqltime = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	var/coord = "[H.x], [H.y], [H.z]"

	if(!SSdbcore.Connect())
		log_game("SQL ERROR during death reporting. Failed to connect.")
	else
		var/datum/db_query/query = SSdbcore.NewQuery(
			"INSERT INTO [format_table_name("death")] (name, byondkey, job, special, pod, tod, laname, lakey, gender, bruteloss, fireloss, brainloss, oxyloss, coord) VALUES \
			(:name, :key, :job, :special, :pod, :time, :laname, :lakey, :geender, :bruteloss, :fireloss, :brainloss, :oxyloss, :coord)",
			list(
				"name" = sqlname,
				"key" = sqlkey,
				"job" = sqljob,
				"special" = sqlspecial,
				"pod" = sqlpod,
				"time" = sqltime,
				"laname" = laname,
				"lakey" = lakey,,
				"gender" = H.gender,
				"bruteloss" = H.getBruteLoss(),
				"fireloss" = H.getFireLoss(),
				"brainloss" = H.getBrainLoss(),
				"oxyloss" = H.getOxyLoss(),
				"coord" = coord,
			)
		)
		if(!query.Execute())
			var/err = query.ErrorMsg()
			log_game("SQL ERROR during death reporting. Error : \[[err]\]\n")
		qdel(query)


/proc/statistic_cycle()
	while(1)
		sql_poll_population()
		sleep(6000)

// This proc is used for feedback. It is executed at round end.
/proc/sql_commit_feedback()
	if(!blackbox)
		log_game("Round ended without a blackbox recorder. No feedback was sent to the database.")
		return

	//content is a list of lists. Each item in the list is a list with two fields, a variable name and a value. Items MUST only have these two values.
	var/list/datum/feedback_variable/content = blackbox.get_round_feedback()

	if(!content)
		log_game("Round ended without any feedback being generated. No feedback was sent to the database.")
		return

	if(!SSdbcore.Connect())
		log_game("SQL ERROR during feedback reporting. Failed to connect.")
	else

		var/datum/db_query/max_query = SSdbcore.RunQuery(
			"SELECT MAX(roundid) AS max_round_id FROM [format_table_name("feedback")]",
			list(),
		)

		var/newroundid

		while(max_query.NextRow())
			newroundid = max_query.item[1]

		if(!(isnum(newroundid)))
			newroundid = text2num(newroundid)

		if(isnum(newroundid))
			newroundid++
		else
			newroundid = 1

		for(var/datum/feedback_variable/item in content)
			var/variable = item.get_variable()
			var/value = item.get_value()

			var/datum/db_query/query = SSdbcore.NewQuery(
				"INSERT INTO [format_table_name("feedback")] (id, roundid, time, variable, value) VALUES (null, :rid, Now(), :var, :val)",
				list(
					"rid" = newroundid,
					"var" = sanitizeSQL(variable),
					"val" = sanitizeSQL(value),
				)
			)
			if(!query.Execute())
				var/err = query.ErrorMsg()
				log_game("SQL ERROR during death reporting. Error : \[[err]\]\n")
			qdel(query)
