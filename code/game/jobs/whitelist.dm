#define WHITELISTFILE "data/whitelist.txt"

var/list/whitelist = list()
var/list/job_whitelist = list()

/hook/startup/proc/loadWhitelist()
	if(config_legacy.usewhitelist)
		load_whitelist()
	return 1

/hook/startup/proc/loadJobWhitelist()
	load_jobwhitelist()
	return 1

/proc/load_whitelist()
	whitelist = file2list(WHITELISTFILE)
	if(!whitelist.len)	whitelist = null

/proc/check_whitelist(mob/M /*, var/rank*/)
	if(!whitelist)
		return FALSE
	return ("[M.ckey]" in whitelist)

/var/list/alien_whitelist = list()

/hook/startup/proc/loadAlienWhitelist()
	if(config_legacy.usealienwhitelist)
		load_alienwhitelist()
	return 1

/proc/load_alienwhitelist()
	var/text = file2text("config/alienwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/alienwhitelist.txt")
	else
		alien_whitelist = splittext(text, "\n")

/proc/is_alien_whitelisted(mob/M, var/datum/species/species)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return 1

	//You did something wrong
	if(!M || !species)
		return FALSE

	//The species isn't even whitelisted
	if(!(species.spawn_flags & SPECIES_IS_WHITELISTED))
		return 1

	//If we have a loaded file, search it
	if(alien_whitelist)
		for (var/s in alien_whitelist)
			if(findtext(s,"[M.ckey] - [species.name]"))
				return 1
			if(findtext(s,"[M.ckey] - All"))
				return 1

/proc/is_lang_whitelisted(mob/M, var/datum/language/language)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return 1

	//You did something wrong
	if(!M || !language)
		return FALSE

	//The language isn't even whitelisted
	if(!(language.flags & WHITELISTED))
		return 1

	//If we have a loaded file, search it
	if(alien_whitelist)
		for (var/s in alien_whitelist)
			if(findtext(s,"[M.ckey] - [language.name]"))
				return 1
			if(findtext(s,"[M.ckey] - All"))
				return 1

/proc/whitelist_overrides(mob/M)
	if(!config_legacy.usealienwhitelist)
		return 1
	if(check_rights(R_ADMIN, 0, M))
		return 1

	return FALSE


/proc/load_jobwhitelist()
	var/text = file2text("config/jobwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/jobwhitelist.txt")
	else
		job_whitelist = splittext(text, "\n")

/proc/is_job_whitelisted(mob/M, var/rank)
	var/datum/job/job = SSjobs.GetJob(rank)
	if(!job.whitelist_only)
		return 1
	if(rank == USELESS_JOB)
		return 1
	if(check_rights(R_ADMIN, 0))
		return 1
	if(!job_whitelist)
		return FALSE
	if(M && rank)
		for (var/s in job_whitelist)
			if(findtext(s,"[lowertext(M.ckey)] - [lowertext(rank)]"))
				return 1
			if(findtext(s,"[M.ckey] - All"))
				return 1
	return FALSE

#undef WHITELISTFILE
