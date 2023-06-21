/**
 * IPIntel Subsystem
 */
SUBSYSTEM_DEF(ipintel)
	name = "IPIntel"
	init_order = INIT_ORDER_IPINTEL
	subsystem_flags = SS_NO_FIRE

	/// is ipintel enabled?
	var/enabled = FALSE
	/// threshold for blocking vpns
	var/vpn_threshold
	/// ip (as client.address form) to cache entry
	var/static/list/vpn_cache = list()
	/// current consequetive errors
	var/consequetive_errors = 0
	/// next time before we try again once errored
	var/next_attempt = 0
	/// retry delay
	var/retry_delay = 4 SECONDS
	/// max retries
	var/max_retries = 1

/datum/controller/subsystem/ipintel/OnConfigLoad()
	. = ..()
	enabled = !!CONFIG_GET(flag/ipintel_enabled)
	consequetive_errors = 0
	next_attempt = 0
	vpn_threshold = CONFIG_GET(number/ipintel_rating_bad)

/datum/controller/subsystem/ipintel/proc/vpn_connection_check(address, ckey)
	var/score = vpn_score(address)
	if(score >= vpn_threshold)
		log_and_message_admins("[ckey] detected to likely be using a vpn ([score] >= [vpn_threshold])")
		log_access("[ckey] ([address]) is likely using a vpn ([score] >= [vpn_threshold])")

/datum/controller/subsystem/ipintel/proc/vpn_score(address)
	var/datum/ipintel/cached = vpn_cache[address]
	if(isnull(cached))
		var/datum/ipintel/fetched = ipintel_cache_fetch(address)
		if(!isnull(fetched))
			log_ipintel("successfully fetched cache for [address]")
			cached = fetched
			vpn_cache[address] = fetched
	if(cached?.is_valid())
		log_ipintel("using valid cache for [address]")
		return cached.intel
	log_ipintel("using api for [address]")
	var/score = ipintel_query(address)
	if(isnull(score))
		return
	var/datum/ipintel/result = new
	result.intel = score
	result.address = address
	ipintel_cache_store(result)
	vpn_cache[address] = result
	return result.intel

/datum/controller/subsystem/ipintel/proc/vpn_check(address)
	return vpn_score(address) >= vpn_threshold

/datum/controller/subsystem/ipintel/proc/ipintel_query(address, retries)
	PRIVATE_PROC(TRUE)
	// no flooding API without cache being available
	if(!SSdbcore.Connect())
		log_ipintel("ipintel: no DB")
		message_admins("IPIntel failed due to lack of database. Yell at your hosts.")
		return
	if(retries > max_retries)
		log_ipintel("ipintel: bailing for [address] due to [retries] > [max_retries].")
		return
	if(!address)
		return
	if(next_attempt > REALTIMEOFDAY)
		return
	if(!enabled)
		return

	var/list/http[] = world.Export("http://[CONFIG_GET(string/ipintel_domain)]/check.php?ip=[address]&contact=[CONFIG_GET(string/ipintel_email)]&format=json&flags=f")

	if(isnull(http))
		ipintel_error(address, "Unable to connect", retries)
		retries++
		sleep(retry_delay)
		return .()

	var/status = text2num(http["STATUS"])

	if(status == 200)
		// success
		var/response = json_decode(file2text(http["CONTENT"]))
		if(isnull(response))
			ipintel_error(address, "Code 400, but no response. Bailing out.")
			return
		if(response["status"] == "success")
			var/parsed = text2num(response["result"])
			if(isnum(parsed))
				return parsed
			ipintel_error(address, "Bad intel from server: [response["result"]]", retries)
			retries++
			sleep(retry_delay)
			return .()
		else
			ipintel_error(address, "Bad response from server: [response["status"]]", retries)
			retries++
			sleep(retry_delay)
			return .()
	else if(status == 429)
		// ratelimited
		ipintel_error(address, "Code 429: Ratelimited")
		return
	else
		ipintel_error(address, "Code [status]: Unknown", retries)
		retries++
		sleep(retry_delay)
		return .()

/datum/controller/subsystem/ipintel/proc/ipintel_cache_fetch(address)
	PRIVATE_PROC(TRUE)
	if(!SSdbcore.Connect())
		return
	// admin proccall guard override - there's no volatile args here
	var/old_usr = usr
	usr = null
	. = ipintel_cache_fetch_impl(address)
	usr = old_usr

/datum/controller/subsystem/ipintel/proc/ipintel_cache_fetch_impl(address)
	PRIVATE_PROC(TRUE)
	var/datum/db_query/fetch = SSdbcore.NewQuery(
		"SELECT date, intel, TIMESTAMPDIFF(MINUTE,date,NOW()) FROM [format_table_name("ipintel")] WHERE ip = INET_ATON(:ip)",
		list(
			"ip" = address,
		)
	)
	#warn impl

/datum/controller/subsystem/ipintel/proc/ipintel_cache_store(datum/ipintel/entry)
	PRIVATE_PROC(TRUE)
	if(!SSdbcore.Connect())
		return
	// admin proccall guard override - there's no volatile args here
	var/old_usr = usr
	usr = null
	. = ipintel_cache_store_impl(entry)
	usr = old_usr

/datum/controller/subsystem/ipintel/proc/ipintel_cache_store_impl(datum/ipintel/entry)
	PRIVATE_PROC(TRUE)
	var/datum/db_query/update = SSdbcore.NewQuery(
		"INSERT INTO [format_table_name("ipintel")] (ip, intel) VALUES (INET_ATON(:ip), :intel) \
		ON DUPLICATE KEY UPDATE intel = VALUES(intel), date = NOW()",
		list(
			"ip" = entry.address,
			"intel" = entry.intel,
		)
	)
	update.Execute()
	qdel(update)

/datum/controller/subsystem/ipintel/proc/ipintel_error(address, error, retries)
	PRIVATE_PROC(TRUE)
	var/str = "IPIntel error handling on [address]: "
	if(retries)
		consequetive_errors++
		#warn impl all
		str += "Could not check [address]. Disabling IPIntel for "
	else
		str += "Attempting to retry."

/datum/ipintel
	var/address
	var/intel
	var/cached_realtime

/datum/ipintel/New()
	cached_realtime = world.realtime

/datum/ipintel/proc/is_valid()
	. = FALSE
	var/allowable_hours = intel < SSipintel.vpn_threshold? CONFIG_GET(number/ipintel_save_good) : CONFIG_GET(number/ipintel_save_bad)
	return world.realtime < cached_realtime + (allowable_hours HOURS)

/**
/datum/ipintel
	var/cache = FALSE
	var/cacheminutesago = 0
	var/cachedate = ""

/datum/ipintel/New()
	cachedate = SQLtime()

/proc/get_ip_intel(ip, bypasscache = FALSE, updatecache = TRUE)
	var/datum/ipintel/res = new()
	res.ip = ip
	. = res
	if (!ip || !CONFIG_GET(string/ipintel_email) || !SSipintel.enabled)
		return
	if (!bypasscache)
		var/datum/ipintel/cachedintel = SSipintel.cache[ip]
		if (cachedintel?.is_valid())
			cachedintel.cache = TRUE
			return cachedintel

		if(SSdbcore.Connect())
			var/rating_bad = CONFIG_GET(number/ipintel_rating_bad)
			var/datum/db_query/query_get_ip_intel = SSdbcore.NewQuery({"
				SELECT date, intel, TIMESTAMPDIFF(MINUTE,date,NOW())
				FROM [format_table_name("ipintel")]
				WHERE
					ip = INET_ATON(':ip')
					AND ((
							intel < :rating_bad
							AND
							date + INTERVAL :save_good HOUR > NOW()
						) OR (
							intel >= :rating_bad
							AND
							date + INTERVAL :save_bad HOUR > NOW()
					))
			"}, list("ip" = ip, "rating_bad" = rating_bad, "save_good" = CONFIG_GET(number/ipintel_save_good), "save_bad" = CONFIG_GET(number/ipintel_save_bad)))
			if(!query_get_ip_intel.Execute())
				qdel(query_get_ip_intel)
				return
			if (query_get_ip_intel.NextRow())
				res.cache = TRUE
				res.cachedate = query_get_ip_intel.item[1]
				res.intel = text2num(query_get_ip_intel.item[2])
				res.cacheminutesago = text2num(query_get_ip_intel.item[3])
				res.cacherealtime = world.realtime - (text2num(query_get_ip_intel.item[3])*10*60)
				SSipintel.cache[ip] = res
				qdel(query_get_ip_intel)
				return
			qdel(query_get_ip_intel)
	res.intel = ip_intel_query(ip)
	if (updatecache && res.intel >= 0)
		SSipintel.cache[ip] = res
		if(SSdbcore.Connect())
			var/datum/db_query/query_add_ip_intel = SSdbcore.NewQuery(
				"INSERT INTO [format_table_name("ipintel")] (ip, intel) VALUES (INET_ATON(:ip), :intel) ON DUPLICATE KEY UPDATE intel = VALUES(intel), date = NOW()",
				list("ip" = ip, "intel" = res.intel)
			)
			query_add_ip_intel.Execute()
			qdel(query_add_ip_intel)

/proc/ipintel_handle_error(error, ip, retryed)
	if (retryed)
		SSipintel.errors++
		error += " Could not check [ip]. Disabling IPINTEL for [SSipintel.errors] minute[( SSipintel.errors == 1 ? "" : "s" )]"
		SSipintel.throttle = world.timeofday + (10 * 120 * SSipintel.errors)
	else
		error += " Attempting retry on [ip]."
	log_ipintel(error)

 */
