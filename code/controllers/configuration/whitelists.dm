// todo: rework whitelists, fuck.
/datum/controller/configuration
	/// alien whitelist: list() of species **NAME** (not uid because headmins don't read code) = list(ckeys)
	///     language whitelists also go in here because what the fuck i hate this.
	var/list/alien_whitelist = list()
	/// job whitelist: list() of job **TITLE** (not uid because headmins don't read code) = list(ckeys)
	var/list/job_whitelist = list()

/**
 * name, ckey must be CKEY()'d.
 */
/datum/controller/configuration/proc/check_alien_whitelist(name, ckey)
	if(!config_legacy.usealienwhitelist)
		// ignore
		return TRUE
	if(admin_datums[ckey])
		// bypass
		return TRUE
	var/list/relevant = alien_whitelist[name]
	return relevant?.Find(ckey)

/**
 * get every alien (species | language) someone's whitelisted for
 * returns *names*, not uids.
 */
/datum/controller/configuration/proc/all_alien_whitelists_for(ckey)
	. = list()
	for(var/ayy in alien_whitelist)
		if(!(ckey in alien_whitelist[ayy]))
			continue
		. += ayy

/**
 * name, ckey must be CKEY()'d.
 */
/datum/controller/configuration/proc/check_job_whitelist(name, ckey)
	if(admin_datums[ckey])
		// bypass
		return TRUE
	var/list/relevant = job_whitelist[name]
	return relevant?.Find(ckey)

/datum/controller/configuration/proc/LoadWhitelists()
	reload_alien_whitelist()
	reload_job_whitelist()

/datum/controller/configuration/proc/reload_job_whitelist()
	job_whitelist = list()
	var/fname = "config/jobwhitelist.txt"
	if(!fexists(fname))
		log_config("Failed to load [fname]")
		return FALSE
	var/list/lines = world.file2list(fname)
	var/count = 0
	for(var/line in lines)
		++count
		line = trim(line)
		if(!length(line))
			continue
		var/list/parts = splittext(line, "-")
		if(length(parts) != 2)
			log_config("jobwhitelist - skipping line [count]: [line]")
			continue
		var/title = ckey(parts[2])
		var/ckey = ckey(parts[1])
		LAZYINITLIST(job_whitelist[title])
		if(ckey in job_whitelist[title])
			log_config("jobwhitelist - duplicate ckey [ckey] for [title]")
			continue
		LAZYADD(job_whitelist[title], ckey)
	return TRUE

/datum/controller/configuration/proc/reload_alien_whitelist()
	alien_whitelist = list()
	var/fname = "config/alienwhitelist.txt"
	if(!fexists(fname))
		log_config("Failed to load [fname]")
		return FALSE
	var/list/lines = world.file2list(fname)
	var/count = 0
	for(var/line in lines)
		++count
		line = trim(line)
		if(!length(line))
			continue
		var/list/parts = splittext(line, "-")
		if(length(parts) != 2)
			log_config("alienwhitelist - skipping line [count]: [line]")
			continue
		var/alien = ckey(parts[2])
		var/ckey = ckey(parts[1])
		LAZYINITLIST(alien_whitelist[alien])
		if(ckey in alien_whitelist[alien])
			log_config("alienwhitelist - duplicate ckey [ckey] for [alien]")
			continue
		LAZYADD(alien_whitelist[alien], ckey)
	return TRUE
