#define WHITELISTFILE "data/whitelist.txt"

var/list/whitelist = list()

/hook/startup/proc/loadWhitelist()
	if(config_legacy.usewhitelist)
		load_whitelist()
	return 1

/proc/load_whitelist()
	whitelist = world.file2list(WHITELISTFILE)
	if(!whitelist.len)	whitelist = null

/proc/check_whitelist(mob/M /*, var/rank*/)
	if(!whitelist)
		return 0
	return ("[M.ckey]" in whitelist)

/proc/is_alien_whitelisted(mob/M, var/datum/species/species)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return 1

	//You did something wrong
	if(!M || !species)
		return 0

	//The species isn't even whitelisted
	if(!(species.species_spawn_flags & SPECIES_SPAWN_WHITELISTED))
		return 1

	//If we have a loaded file, search it
	if(alien_whitelist)
		for (var/s in alien_whitelist)
			if(findtext(s,"[M.ckey] - [species.name]"))
				return 1
			if(findtext(s,"[M.ckey] - All"))
				return 1

#undef WHITELISTFILE
