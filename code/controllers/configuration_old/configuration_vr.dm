//
// Lets read our settings from the configuration file on startup too!
//

/datum/configuration_legacy
	var/time_off = FALSE
	var/pto_job_change = FALSE
	var/pto_cap = 100 //Hours

/hook/startup/proc/read_vs_config()
	var/list/Lines = world.file2list("config/legacy/config.txt")
	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		switch (name)
			if ("chat_webhook_url")
				config_legacy.chat_webhook_url = value
			if ("chat_webhook_key")
				config_legacy.chat_webhook_key = value
			if ("items_survive_digestion")
				config_legacy.items_survive_digestion = 1
			if ("pto_cap")
				config_legacy.pto_cap = text2num(value)
			if ("time_off")
				config_legacy.time_off = TRUE
			if ("pto_job_change")
				config_legacy.pto_job_change = TRUE
	return 1
