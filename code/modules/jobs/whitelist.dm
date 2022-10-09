#define WHITELISTFILE "data/whitelist.txt"

var/list/whitelist = list()

/hook/startup/proc/loadWhitelist()
	if(CONFIG_GET(flag/use_whitelist))
		load_whitelist()
	return TRUE

/proc/load_whitelist()
	whitelist = world.file2list(WHITELISTFILE)
	if(!whitelist.len)
		whitelist = null

/proc/check_whitelist(mob/M)
	if(!whitelist)
		return FALSE
	return ("[M.ckey]" in whitelist)

/var/list/species_whitelist = list()

/hook/startup/proc/loadSpeciesWhitelist()
	if(CONFIG_GET(flag/use_species_whitelist))
		load_species_whitelist()
	return TRUE

/proc/load_species_whitelist()
	var/text = file2text("config/alienwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/alienwhitelist.txt")
	else
		species_whitelist = splittext(text, "\n")

/proc/is_alien_whitelisted(mob/M, datum/species/species)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return TRUE

	//You did something wrong
	if(!M || !species)
		return FALSE

	//The species isn't even whitelisted
	if(!(species.spawn_flags & SPECIES_IS_WHITELISTED))
		return TRUE

	//If we have a loaded file, search it
	if(species_whitelist)
		for (var/s in species_whitelist)
			if(findtext(s,"[M.ckey] - [species.name]"))
				return TRUE
			if(findtext(s,"[M.ckey] - All"))
				return TRUE

//TODO: Remove this. @Zandario
/proc/is_lang_whitelisted(mob/M, datum/language/language)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return TRUE

	//You did something wrong
	if(!M || !language)
		return FALSE

	//The language isn't even whitelisted
	if(!(language.flags & WHITELISTED))
		return TRUE

	//If we have a loaded file, search it
	if(species_whitelist)
		for (var/s in species_whitelist)
			if(findtext(s,"[M.ckey] - [language.name]"))
				return TRUE
			if(findtext(s,"[M.ckey] - All"))
				return TRUE

/proc/whitelist_overrides(mob/M)
	if(!CONFIG_GET(flag/use_species_whitelist))
		return TRUE
	if(check_rights(R_ADMIN|R_EVENT, FALSE, M))
		return TRUE

	return FALSE
var/list/job_whitelist = list()

/hook/startup/proc/loadJobWhitelist()
	load_job_whitelist()
	return TRUE

/proc/load_job_whitelist()
	var/text = file2text("config/jobwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/jobwhitelist.txt")
	else
		job_whitelist = splittext(text, "\n")

/proc/is_job_whitelisted(mob/M, rank)
	var/datum/job/job = SSjob.get_job(rank)
	if(!job.whitelist_only)
		return TRUE
	if(rank == USELESS_JOB)
		return TRUE
	if(check_rights(R_ADMIN, FALSE))
		return TRUE
	if(!job_whitelist)
		return FALSE
	if(M && rank)
		for (var/s in job_whitelist)
			if(findtext(s,"[lowertext(M.ckey)] - [lowertext(rank)]"))
				return TRUE
			if(findtext(s,"[M.ckey] - All"))
				return TRUE
	return FALSE

#undef WHITELISTFILE
